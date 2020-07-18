locals {
  context = {
    application_name = "pstf"
    environment_name = "fn"
    location = "East US"
    location_suffix = "us-east"
  }
}

module "rg" {
  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"
  context = local.context
}

# TODO: Determine whether this should reside here or in the 'fn' sample folder.
# module "app-service" {
#     source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/app-service/plan/premium/base/v1"
#     context = module.rg.context
#     service_settings = {
#         name = "${local.context.application_name}-${local.context.environment_name}-premium-sample"
#         size = "EP1"
#         storage_type = "GRS"
#         maximum_instance_count = "3"
#         minimum_instance_count = "1"
#     }
# }

module "app-service" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/app-service/plan/serverless/base/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-serverless-sample"
        storage_type = "GRS"
    }
}