resource "azurerm_subnet" "subnet" {
  name                 = var.sensor_subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group
  address_prefixes = [
    cidrsubnet(var.virtual_network_address_space, 8, 1)
  ]
}