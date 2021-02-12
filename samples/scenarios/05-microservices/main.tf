module "coreinfra" {
    source = "../01-coreinfra"
}
locals {
  default_resource_name = "${module.coreinfra.context.application_name}-${module.coreinfra.context.environment_name}-${module.coreinfra.context.location.suffix}-${module.coreinfra.deploy_suffix}"
  # This is a random string to help ensure that our resoures have unique names, using the same
  # random suffix for different resources is sometimes a bit simpler than creating more randoms.
  random_string             = module.coreinfra.deploy_suffix
  context                   = module.coreinfra.context
  observability_settings    = module.coreinfra.observability_settings

}
data http my_ip_address {
  url = "http://ipv4.icanhazip.com"    
}