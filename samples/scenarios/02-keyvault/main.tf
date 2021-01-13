module "coreinfra" {
    source = "../01-coreinfra"
}

module "keyvault" {
  
  source                    = "../../../submodules/terraform-azurerm/services/keyvault/endpoint/base/v1"
  # 
  # The context (Where) to deploy the keyvault to
  #
  context                   = module.coreinfra.context
  #
  # The Observability settings that help create keyvault
  # in a best practices manner
  observability_settings    = module.coreinfra.observability_settings
  
  # KeyVault specific settings 
  service_settings = {
    name                    = "${module.coreinfra.context.application_name}-${module.coreinfra.context.environment_name}-${module.coreinfra.context.location_suffix}"
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

