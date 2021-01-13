#
# Create the core infra for this demo, remember to destroy any previous
# deployments of core infra before running this demo.  We don't import
# state for simplicity of these demos.
module "coreinfra" {
    source = "../01-coreinfra"
}
locals {
  resource_name = "${module.coreinfra.context.application_name}-${module.coreinfra.context.environment_name}-${module.coreinfra.context.location_suffix}"
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
    soft_delete_enabled     = false
  }
}

#
# Give the current user access to vault
# you will need access to search keys etc.
# This is for a human user, a service account with 
# an application registration will need to 
# make some tweaks.
#
data "azurerm_client_config" "current" {}

resource azurerm_key_vault_access_policy current_user {
   key_vault_id   = module.keyvault.id
   object_id      = data.azurerm_client_config.current.object_id
   tenant_id      = data.azurerm_client_config.current.tenant_id
 
    key_permissions = [
      "get"
    ]

    secret_permissions = [
      "get", "list", "set", "delete", "recover", "backup", "restore","purge", "restore"
    ]   
}



# 
# Create a cosmosDB account
#
module cosmosdb_account {
  depends_on  = [ azurerm_key_vault_access_policy.current_user ]
  source      = "../../../submodules/terraform-azurerm/services/cosmos-db/endpoint/dual/secure/v1"
  context                   = module.coreinfra.context
  observability_settings    = module.coreinfra.observability_settings
  service_settings = {
    name = local.resource_name
    tier = "Standard"
    kind = "GlobalDocumentDB"
    failover_location = "WestUS"
    consistency_level = "Eventual"
  }
  security_settings = {
    secret_prefix = "cosmos-${module.coreinfra.context.environment_name}"
    keyvault_id   = module.keyvault.id 
  }
}


