resource "azurerm_public_ip" "nat_gw_ip" {
  name                = var.nat_gateway_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway" "my_nat_gateway" {
  name                = var.nat_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet_nat_gateway_association" "nat_gw_association" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.my_nat_gateway.id
}

resource "azurerm_nat_gateway_public_ip_association" "public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.my_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gw_ip.id
}