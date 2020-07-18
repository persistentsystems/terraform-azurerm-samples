locals {
  context = {
    application_name = "pstf"
    environment_name = "fn"
    location = "East US"
    location_suffix = "us-east"
  }

module "rg" {
  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"
  context = local.context
}

module "keyvault" {
    source = "github.com/persistentsystems/terraform-azurerm/tree/master/services/keyvault/endpoint/base/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-sample"
        workspace_id = module.log-analytics.id
    }
}

module "log-analytics" {
    source = "github.com/persistentsystems/terraform-azurerm/tree/master/services/log-analytics/endpoint/base/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-sample"
        retention_in_days = 14
    }
}

