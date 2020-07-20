
locals {
  context = {
    application_name = "pstf"
    environment_name = "dev"
    location = "East US"
    location_suffix = "us-east"
  }
}


module "rg" {
  
  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"

  context = local.context
  name    = "pstf-dev"

}

module "log_analytics" {
  
  source  = "github.com/persistentsystems/terraform-azurerm/services/log-analytics/workspace/base/v1"

  context = module.rg.context
  service_settings = {
    name                   = "pstf-dev"
    retention_in_days      = 30
  }

}

module "host" {
  
  source  = "github.com/persistentsystems/terraform-azurerm/scenarios/microservices/fn/host/premium/base/v1"

  context = module.rg.context
  service_settings = {
    name                   = "pstf-dev-svc1"
    size                   = "EP1"
    storage_type           = "GRS"
    workspace_id           = module.log_analytics.id
    maximum_instance_count = 1
    minimum_instance_count = 1
    soft_delete_enabled = true
  }

}

module "svc1" {
  
  source           = "github.com/persistentsystems/terraform-azurerm/scenarios/microservices/fn/http/premium/base/v1"

  context          = module.rg.context
  host_settings    = module.host.host_settings

  service_settings = {
    name              = "pstf-dev-svc1"
    service_name      = "svc1"
    runtime_version   = "~3"
    runtime_type      = "dotnet"
    app_settings      = {}
    package_filename  = "./samples/scenarios/microservices/DemoCode.zip"
    workspace_id      = module.log_analytics.id
    client_id         = "foo"
    client_secret     = "bar"
  }

}
