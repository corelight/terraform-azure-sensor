output "internal_load_balancer_name" {
  value = azurerm_lb.scale_set_lb.name
}

output "nat_gateway_public_ip_name" {
  value = azurerm_public_ip.nat_gw_ip.name
}

output "nat_gateway_name" {
  value = azurerm_nat_gateway.lb_nat_gw.name
}

output "sensor_identity_principal_id" {
  value = azurerm_linux_virtual_machine_scale_set.sensor_scale_set.identity[0].principal_id
}

output "sensor_scale_set_name" {
  value = azurerm_linux_virtual_machine_scale_set.sensor_scale_set.name
}

output "sensor_load_balancer_management_frontend_ip_address" {
  value = azurerm_lb.scale_set_lb.frontend_ip_configuration[0].private_ip_address
}

output "sensor_load_balancer_monitoring_frontend_ip_address" {
  value = azurerm_lb.scale_set_lb.frontend_ip_configuration[1].private_ip_address
}
