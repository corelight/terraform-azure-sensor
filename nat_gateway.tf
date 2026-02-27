resource "azurerm_public_ip" "nat_gw_ip" {
  count = var.create_nat_gateway ? 1 : 0

  name                = var.nat_gateway_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_nat_gateway" "lb_nat_gw" {
  count = var.create_nat_gateway ? 1 : 0

  name                = var.nat_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet_nat_gateway_association" "nat_gw_association" {
  count = var.create_nat_gateway ? 1 : 0

  subnet_id      = var.management_subnet_id
  nat_gateway_id = azurerm_nat_gateway.lb_nat_gw[0].id
}

resource "azurerm_nat_gateway_public_ip_association" "public_ip_association" {
  count = var.create_nat_gateway ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.lb_nat_gw[0].id
  public_ip_address_id = azurerm_public_ip.nat_gw_ip[0].id
}