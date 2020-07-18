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

module "aad" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/application/graph-read/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-aad-graph-read-sample"
        workspace_id = module.rg.workspace_id
        homepage = "https://localhost"
        identifier_urls = "[https://localhost/aad/sample, https://localhost/aad/graph-read/sample]"
        reply_urls = "[https://localhost/aad/sample, https://localhost/aad/graph-read/sample]"
        avaliable_to_other_tenants = false 
        allow_implicit_flow = false
    }
}

module "aad" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/service-principle/base/v1"
    context = module.rg.context
    service_settings = {
        application_id = module.app.application_id
    }
}