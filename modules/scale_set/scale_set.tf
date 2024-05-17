module "cloud_init" {
  source = "../cloud_init"

  license_key         = var.license_key
  sensor_api_password = var.sensor_api_password
}

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
  custom_data         = module.cloud_init.rendered_cloud_init

  source_image_id = var.corelight_sensor_image_id

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 100
  }

  health_probe_id = azurerm_lb_probe.sensor_health_check_probe.id
  network_interface {
    name    = "management-nic"
    primary = true

    ip_configuration {
      name      = "management-nic-ip-cfg"
      subnet_id = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.management_pool.id
      ]
    }
  }

  network_interface {
    name    = "monitoring-nic"
    primary = false

    ip_configuration {
      name      = "monitoring-nic-ip-cfg"
      subnet_id = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.monitoring_pool.id
      ]
    }
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
}