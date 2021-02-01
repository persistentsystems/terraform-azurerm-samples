#
# Create the core infra for this demo, remember to destroy any previous
# deployments of core infra before running this demo.  We don't import
# state for simplicity of these demos.
module "coreinfra" {
    source = "../01-coreinfra"
}
locals {
  resource_name = "${module.coreinfra.context.application_name}-${module.coreinfra.context.environment_name}-${module.coreinfra.context.location.suffix}"
}
#
# Create a KeyVault where the cosmosDB module can store the access keys
#
module "keyvault" {
  source                    = "../../../submodules/terraform-azurerm/services/keyvault/endpoint/base/v1"
  context                   = module.coreinfra.context
  observability_settings    = module.coreinfra.observability_settings
  service_settings = {
    name                    = local.resource_name
  }
}


# 
# Create a cosmosDB account
#
module cosmosdb_account {
  depends_on  = [ module.keyvault ]
  source      = "../../../submodules/terraform-azurerm/services/cosmos-db/endpoint/dual/secure/v1"
  context                   = module.coreinfra.context
  observability_settings    = module.coreinfra.observability_settings
  service_settings = {
    name = local.resource_name
    tier = "Standard"
    kind = "GlobalDocumentDB"
    automatic_failover = false 
    locations = [
      {
        name     = "EastUS"
        priority = 0
      },
      {
        name     = "WestUS"
        priority = 1
      }


    ]
    failover_location = "WestUS"
    consistency_level = "Eventual"
  }
  security_settings = {
    secret_prefix = "cosmos-${module.coreinfra.context.environment_name}"
    keyvault_id   = module.keyvault.id 
  }
}

module cosmosdb_database {
  source = "../../../submodules/terraform-azurerm/services/cosmos-db/database/sql/base/v1"
  context                   = module.coreinfra.context
  service_settings = {
    name            = "Northwind-Customers"
    account_name    = module.cosmosdb_account.name 
    # for autoscaling resources, shared between all containers
    # the module just does shared autoscaling at this time.
    # We can create more modules in the library as needed.
    max_throughput  = 4000
  }

}

module "cosmosdb_northwind_customers" {
  
  source = "../../../submodules/terraform-azurerm/services/cosmos-db/container/v1"

  context = module.coreinfra.context
  
  service_settings = {
    
    account_name       = module.cosmosdb_account.name
    database_name      = module.cosmosdb_database.name
    name               = "customers"
    partition_key_path = "/customerid"
  }
}