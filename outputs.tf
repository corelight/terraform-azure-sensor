output "internal_load_balancer_name" {
  value = azurerm_lb.scale_set_lb.name
}

output "sensor_identity_principal_id" {
  value = azurerm_linux_virtual_machine_scale_set.sensor_scale_set.identity[0].principal_id
}

output "sensor_scale_set_name" {
  value = azurerm_linux_virtual_machine_scale_set.sensor_scale_set.name
}

output "sensor_scale_set_subnet_name" {
  value = azurerm_subnet.subnet.name
}