resource "azurerm_subnet" "bastion_subnet" {
  count                = var.create_bastion_host && var.virtual_network_name != "" ? 1 : 0
  address_prefixes     = [cidrsubnet(data.azurerm_virtual_network.vnet.address_space, 1, 1)]
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}

resource "azurerm_public_ip" "bastion_ip" {
  count               = var.create_bastion_host && var.virtual_network_name != "" ? 1 : 0
  name                = var.bastion_host_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}


resource "azurerm_bastion_host" "bastion" {
  count               = var.create_bastion_host && var.virtual_network_name != "" ? 1 : 0
  name                = var.bastion_host_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "bastion-public-cfg"
    subnet_id            = azurerm_subnet.bastion_subnet[count.index].id
    public_ip_address_id = azurerm_public_ip.bastion_ip[count.index].id
  }

  tags = var.tags
}