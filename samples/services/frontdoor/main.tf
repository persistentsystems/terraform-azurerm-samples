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

module "frontdoor" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/frontdoor/endpoint/base/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-frontdoor-sample"
        workspace_id = module.log-analytics.id
    }
    primary_backend = {
        host_header = ""
        address = ""
        http_port = "80"
        https_port = "443"
    }
    secondary_backend = {
        host_header = ""
        address = ""
        http_port = "80"
        https_port = "443"
    }
    backend_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-backend-settings"
        healthprobe_path = "/health"
    }
}

# module "frontdoor" {
#     source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/frontdoor/endpoint/base/v1"
#     context = module.rg.primary_backend
#     primary_backend = {
#         host_header = ""
#         address = ""
#         http_port = "80"
#         https_port = "443"
#     }
# }
# 
# module "frontdoor" {
#     source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/frontdoor/endpoint/base/v1"
#     context = module.rg.secondary_backend
#     secondary_backend = {
#         host_header = ""
#         address = ""
#         http_port = "80"
#         https_port = "443"
#     }
# }
# 
# module "frontdoor" {
#     source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/frontdoor/endpoint/base/v1"
#     context = module.rg.backend_settings
#     backend_settings = {
#         name = "${local.context.application_name}-${local.context.environment_name}-backend-settings"
#         healthprobe_path = "/health"
#     }
# }
# 
# module "log_analytics" {
#   source  = "github.com/persistentsystems/terraform-azurerm/services/log-analytics/workspace/base/v1"
#   context = module.rg.context
#   service_settings = {
#     name = "${local.context.application_name}-${local.context.environment_name}-frontdoor-log-analytics-sample"
#     retention_in_days = 14
#   }
# }