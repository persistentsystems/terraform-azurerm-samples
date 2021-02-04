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
    name                    = "${module.coreinfra.context.application_name}-${module.coreinfra.context.environment_name}-${module.coreinfra.context.location.suffix}"
  }

}
