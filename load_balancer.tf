resource "azurerm_lb" "scale_set_lb" {
  location            = var.location
  name                = var.load_balancer_name
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name      = var.lb_frontend_ip_config_name
    subnet_id = var.monitoring_subnet_id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "management_pool" {
  loadbalancer_id = azurerm_lb.scale_set_lb.id
  name            = var.lb_mgmt_backend_address_pool_name
}

resource "azurerm_lb_backend_address_pool" "monitoring_pool" {
  loadbalancer_id = azurerm_lb.scale_set_lb.id
  name            = var.lb_mon_backend_address_pool_name
}

resource "azurerm_lb_probe" "sensor_health_check_probe" {
  loadbalancer_id     = azurerm_lb.scale_set_lb.id
  name                = var.lb_health_check_probe_name
  port                = 41080
  request_path        = "/api/system/healthcheck"
  protocol            = "Http"
  interval_in_seconds = 30
  number_of_probes    = 2
  probe_threshold     = 2
}

resource "azurerm_lb_rule" "monitoring_vxlan_lb_rule" {
  loadbalancer_id                = azurerm_lb.scale_set_lb.id
  name                           = var.lb_vxlan_rule_name
  protocol                       = "Udp"
  backend_port                   = 4789
  frontend_port                  = 4789
  frontend_ip_configuration_name = azurerm_lb.scale_set_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.monitoring_pool.id
  ]
  probe_id = azurerm_lb_probe.sensor_health_check_probe.id
}

resource "azurerm_lb_rule" "monitoring_health_check_rule" {
  name                           = var.lb_health_check_rule_name
  loadbalancer_id                = azurerm_lb.scale_set_lb.id
  protocol                       = "Tcp"
  backend_port                   = 41080
  frontend_port                  = 41080
  frontend_ip_configuration_name = azurerm_lb.scale_set_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.monitoring_pool.id
  ]
  probe_id = azurerm_lb_probe.sensor_health_check_probe.id
}

resource "azurerm_lb_rule" "management_lb_rule" {
  name                           = var.lb_ssh_rule_name
  loadbalancer_id                = azurerm_lb.scale_set_lb.id
  frontend_ip_configuration_name = azurerm_lb.scale_set_lb.frontend_ip_configuration[0].name
  protocol                       = "Tcp"
  backend_port                   = 22
  frontend_port                  = 22
  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.management_pool.id
  ]
  probe_id = azurerm_lb_probe.sensor_health_check_probe.id
}
