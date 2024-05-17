resource "azurerm_lb" "scale_set_lb" {
  location            = var.location
  name                = var.load_balancer_name
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name      = "corelight-sensor-lb-ip"
    subnet_id = azurerm_subnet.subnet.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "management_pool" {
  loadbalancer_id = azurerm_lb.scale_set_lb.id
  name            = "management-pool"
}

resource "azurerm_lb_backend_address_pool" "monitoring_pool" {
  loadbalancer_id = azurerm_lb.scale_set_lb.id
  name            = "monitoring-pool"
}

resource "azurerm_lb_probe" "sensor_health_check_probe" {
  loadbalancer_id     = azurerm_lb.scale_set_lb.id
  name                = "health-check"
  port                = 443
  request_path        = "/api/system/healthcheck/"
  protocol            = "Https"
  interval_in_seconds = 30
  probe_threshold     = 3
}

resource "azurerm_lb_rule" "monitoring_vxlan_lb_rule" {
  loadbalancer_id                = azurerm_lb.scale_set_lb.id
  name                           = "vxlan-lb-rule"
  protocol                       = "Udp"
  backend_port                   = 4789
  frontend_port                  = 4789
  frontend_ip_configuration_name = azurerm_lb.scale_set_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.monitoring_pool.id
  ]
}

resource "azurerm_lb_rule" "monitoring_geneve_lb_rule" {
  name                           = "geneve-lb-rule"
  loadbalancer_id                = azurerm_lb.scale_set_lb.id
  protocol                       = "Udp"
  backend_port                   = 6081
  frontend_port                  = 6081
  frontend_ip_configuration_name = azurerm_lb.scale_set_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.monitoring_pool.id
  ]
}

resource "azurerm_lb_rule" "monitoring_health_check_rule" {
  name                           = "healthcheck-lb-rule"
  loadbalancer_id                = azurerm_lb.scale_set_lb.id
  protocol                       = "Tcp"
  backend_port                   = 443
  frontend_port                  = 443
  frontend_ip_configuration_name = azurerm_lb.scale_set_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.management_pool.id
  ]
  probe_id = azurerm_lb_probe.sensor_health_check_probe.id
}

resource "azurerm_lb_rule" "management_lb_rule" {
  name                           = "management-ssh-lb-rule"
  loadbalancer_id                = azurerm_lb.scale_set_lb.id
  frontend_ip_configuration_name = azurerm_lb.scale_set_lb.frontend_ip_configuration[0].name
  protocol                       = "Tcp"
  backend_port                   = 22
  frontend_port                  = 22
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.management_pool.id
  ]
}
