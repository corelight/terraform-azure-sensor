module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor"

  fleet_community_string                       = var.community_string
  sensor_license                               = var.license_key
  sensor_management_interface_name             = "eth0"
  sensor_monitoring_interface_name             = "eth1"
  ### begin i don't think Azure is setup correctly
  ### the mgmt interface needs to be the default gw
  ### the mon interface is what the load balacner is hooked up to
  ### if a health check comes into the mon interface by default it will respond
  ### out the mgmt interface, unless the following is configured, which causes
  ### packets to return out the mon interface
  sensor_health_check_probe_source_ranges_cidr = var.region_probe_source_ranges_cidr
  subnetwork_monitoring_cidr                   = var.subnetwork_mon_cidr
  subnetwork_monitoring_gateway                = var.subnetwork_mon_gateway
  ### end
  enrichment_cloud_provider_name               = "azure"
  enrichment_storage_account_name              = var.enrichment_storage_account_name
  enrichment_storage_container_name            = var.enrichment_storage_container_name
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

  health_probe_id = azurerm_lb_probe.sensor_health_check_probe.id
  upgrade_mode    = "Automatic"

  ### it looks like these are both on the same subnet
  network_interface {
    name    = "management-nic"
    primary = true

    ip_configuration {
      primary   = false
      name      = "management-nic-ip-cfg"
      subnet_id = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.management_pool.id
      ]
    }
  }

  network_interface {
    name = "monitoring-nic"
    ip_configuration {
      primary   = false
      name      = "monitoring-nic-ip-cfg"
      subnet_id = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [
        azurerm_lb_backend_address_pool.monitoring_pool.id
      ]
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_lb_rule.monitoring_health_check_rule,
  ]
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
