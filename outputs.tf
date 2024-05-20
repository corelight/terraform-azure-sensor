output "bastion_subnet_name" {
  value = azurerm_subnet.bastion_subnet.name
}

output "bastion_public_ip_name" {
  value = azurerm_public_ip.bastion_ip.name
}

output "bastion_host_name" {
  value = azurerm_bastion_host.bastion.name
}

output "internal_load_balancer_name" {
  value = azurerm_lb.scale_set_lb.name
}

output "nat_gateway_public_ip_name" {
  value = azurerm_public_ip.nat_gw_ip.name
}

output "nat_gateway_name" {
  value = azurerm_nat_gateway.lb_nat_gw.name
}

output "sensor_scale_set_name" {
  value = azurerm_linux_virtual_machine_scale_set.sensor_scale_set.name
}

output "sensor_scale_set_subnet_name" {
  value = azurerm_subnet.subnet.name
}