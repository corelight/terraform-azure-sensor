resource "azurerm_subnet" "subnet" {
  name                 = var.sensor_subnet_name
  virtual_network_name = data.azurerm_virtual_network
  resource_group_name  = var.resource_group_name
  address_prefixes = [
    cidrsubnet(data.azurerm_virtual_network.vnet.address_space, 8, 1)
  ]
}