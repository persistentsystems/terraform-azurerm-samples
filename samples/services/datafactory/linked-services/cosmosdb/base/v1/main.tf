locals {
  context = {
    application_name = "pstf"
    environment_name = "adf"
    location = "East US"
    location_suffix = "us-east"
  }
}


module "rg" {

  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"

  context = local.context
  name = "pstf-rg"

}

module "adf" {

  source           = "github.com/persistentsystems/terraform-azurerm/services/datafactory/endpoint/base/v1"
  service_settings = {
                        name = "pstf-ADF"
                   }
    context = module.rg.context


}

module "cosmosdb_account" {

  source  = "github.com/persistentsystems/terraform-azurerm/services/cosmos-db/endpoint/dual/base/v1"

  context = module.rg.context
  service_settings = {
    name                = "pstf-cosmos"
    tier                = "Standard"
    kind                = "GlobalDocumentDB"
    failover_location   = "East US"
    consistency_level   = "Eventual"
  }

}

module "cosmosdb_linkedsvc" {
     source = "github.com/persistentsystems/terraform-azurerm/services/datafactory/linked-services/cosmosdb/base/v1"
     service_settings = {
                        name = "cosmosdb_linkedsvc"
                        data_factory_name = module.adf.ADF_NAME
                        connection_string = module.cosmosdb_account-sample.connection_strings[0]
                   }
    context = module.rg.context
}
