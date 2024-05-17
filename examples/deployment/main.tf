locals {
  subscription_id     = "<your subscription uuid>"
  resource_group_name = "corelight"
  location            = "eastus"
  license             = "<your corelight sensor license key>"
  tags = {
    terraform : true,
    purpose : "Corelight"
  }
}

####################################################################################################
# Create a resource group for the corelight resources
####################################################################################################
resource "azurerm_resource_group" "sensor_rg" {
  location = local.location
  name     = local.resource_group_name

  tags = local.tags
}

####################################################################################################
# Get data on the existing vnet and create a subnet in that vnet for the sensor
####################################################################################################
data "azurerm_virtual_network" "existing_vnet" {
  name                = "<vnet name>"
  resource_group_name = "<vnet resource group>"
}

####################################################################################################
# Deploy the Sensor
####################################################################################################
module "sensor" {
  source = "../../modules/scale_set"

  license_key                    = local.license
  location                       = local.location
  resource_group_name            = azurerm_resource_group.sensor_rg.name
  virtual_network_name           = data.azurerm_virtual_network.existing_vnet.name
  corelight_sensor_image_id      = "<image resource id from Corelight"
  sensor_api_password            = "<password for the sensor api>"
  sensor_ssh_public_key          = "<path to ssh public key>"
  virtual_network_resource_group = "<vnet resource group"

  # Optionally create a bastion host for accessing the sensor
  # create_bastion_host  = true

  tags = local.tags
}

