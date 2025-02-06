data "azurerm_subnet" "mon_subnet" {
  name                 = local.monitoring_subnet_name
  resource_group_name  = local.monitoring_subnet_resource_group_name
  virtual_network_name = local.monitoring_subnet_vnet_name
}
