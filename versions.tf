terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.97.1"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">=2.3.4"
    }
  }
}
