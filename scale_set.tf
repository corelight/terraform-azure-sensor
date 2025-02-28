resource "azurerm_linux_virtual_machine_scale_set" "sensor_scale_set" {
  admin_username = var.sensor_admin_username
  admin_ssh_key {
    public_key = var.sensor_ssh_public_key
    username   = var.sensor_admin_username
  }
  location            = var.location
  name                = var.scale_set_name
  resource_group_name = var.resource_group_name
  sku                 = var.virtual_machine_size
  instances           = 1
  custom_data         = module.sensor_config.cloudinit_config.rendered

  source_image_id = var.corelight_sensor_image_id

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = var.virtual_machine_os_disk_size
  }

  health_probe_id = azurerm_lb_probe.mgmt_sensor_health_check_probe.id
  upgrade_mode    = "Automatic"

  network_interface {
    name    = "management-nic"
    primary = true
    ip_configuration {
      name      = "management-nic-ip-cfg"
      primary   = true
      subnet_id = var.management_subnet_id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.management_pool.id
      ]
    }
  }

  network_interface {
    name                          = "monitoring-nic"
    enable_accelerated_networking = true
    ip_configuration {
      name      = "monitoring-nic-ip-cfg"
      primary   = true
      subnet_id = var.monitoring_subnet_id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.monitoring_pool.id
      ]
    }
  }

  extension {
    name                       = "HealthExtension"
    publisher                  = "Microsoft.ManagedServices"
    type                       = "ApplicationHealthLinux"
    type_handler_version       = "2.0"
    auto_upgrade_minor_version = true
    settings = jsonencode({
      protocol          = "https"
      port              = local.monitoring_health_check_port
      requestPath       = "/api/system/healthcheck"
      intervalInSeconds = 15
      numberOfProbes    = 2
      gracePeriod       = 600
    })
  }

  tags = var.tags
}

resource "azurerm_monitor_autoscale_setting" "auto_scale_config" {
  location            = var.location
  name                = var.autoscale_setting_name
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.sensor_scale_set.id

  profile {
    name = "autoscale"
    capacity {
      default = 1
      minimum = 1
      maximum = 5
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.sensor_scale_set.id
        operator           = "GreaterThan"
        statistic          = "Average"
        threshold          = 70
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT5M"
      }

      scale_action {
        cooldown  = "PT1M"
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.sensor_scale_set.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_lb_probe.sensor_health_check_probe
  ]
}

