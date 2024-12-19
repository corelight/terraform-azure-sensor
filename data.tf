locals {
  monitoring_subnet_resource_id_slice = split("/", var.monitoring_subnet_id)
}

data "azurerm_subnet" "mon_subnet" {
  name                 = local.monitoring_subnet_resource_id_slice[length(local.monitoring_subnet_resource_id_slice) - 1]
  resource_group_name  = var.resource_group_name
  virtual_network_name = local.monitoring_subnet_resource_id_slice[8]
}
