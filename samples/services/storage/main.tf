locals {
  context = {
    application_name = "pstf"
    environment_name = "fn"
    location = "East US"
    location_suffix = "us-east"
  }

module "rg-storage" {
  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"
  context = local.context
  name = "storage-foo"
}

module "storage" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/storage/endpoint/base/v1"
}