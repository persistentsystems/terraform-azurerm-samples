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
  name = "pstf-fn"
}

module "logs" {
  source  = "github.com/persistentsystems/terraform-azurerm/services/log-analytics/workspace/base/v1"
  context = module.rg.context
  service_settings = {
    name = "pstf-fn-logs"
    retention_in_days = 30
  }
}

module "plan" { 
  source  = "github.com/persistentsystems/terraform-azurerm/services/app-service/plan/premium/base/v1"
  context = module.rg.context
  service_settings = {
    name = "pstf-fn-svc1"
    size                   = "EP1"
    storage_type           = "GRS"
    maximum_instance_count = 2
    minimum_instance_count = 1
    workspace_id           = "foo"
  }
}

module "fn" {  
  source  = "github.com/persistentsystems/terraform-azurerm/services/fn/premium/base/v1"
  context = module.rg.context
  service_settings = {
    name = "pstf-fn-svc1"
    runtime_version = "~3"
    runtime_type = "dotnet"
    plan_id = module.plan.id
    app_settings = {}
    storage_account = module.plan.storage_account
  }
}