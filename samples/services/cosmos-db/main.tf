
locals {
  context = {
    application_name = "pstf"
    environment_name = "dev"
    location = "East US"
    location_suffix = "us-east"
  }
}


module "rg" {
  
  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"

  context = local.context
  name = "pstf-cosmos"

}



module "cosmosdb" {
  
  source  = "github.com/persistentsystems/terraform-azurerm/services/cosmos-db/endpoint/dual/base/v1"

  context = module.rg.context
  service_settings = {
    name                = "pstf-cosmos"
    tier                = "Standard"
    kind                = "GlobalDocumentDB"
    failover_location   = "West US"
    consistency_level   = "Eventual"
  }

}