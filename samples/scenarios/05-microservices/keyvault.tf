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
    # keyvault only allows 24 characters and needs to be globally unique, for this demo i'm using the 
    # random string instead of application name to avoid conflicts.  There isnt' enough characters for the 
    # 'fully qualified' local.default_resource_name
    name                    = "${module.coreinfra.deploy_suffix}-${module.coreinfra.context.environment_name}"

  }

}
