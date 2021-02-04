#
# Log Analytics Workspace
#
module log_analytics {
    source = "../../../submodules/terraform-azurerm/services/log-analytics/base/v1"
    context = module.my_resource_group.context 
    service_settings =  {
          name = "${module.my_resource_group.context.application_name}-${module.my_resource_group.context.environment_name}-workspace-${random_string.deploy_suffix.result}-${module.my_resource_group.context.location.suffix}"
          sku               = "PerGB2018"
          retention_in_days = 30
      }
}
# LogAnalytics (and Storage) accounts need to have globally unique names
# Given the shared used of this demo, we need to add some 
# randomness so that multiple people can deploy these demos.
resource random_string deploy_suffix {
  length  = 4
  special = false
  upper   = false
}
#
# Azure Monitor Alerts
# 
module "alert_group_critical" {
  source    = "../../../submodules/terraform-azurerm/services/monitor/action-group/email/v1"
  context   = module.my_resource_group.context
  service_settings = {
    name       = "critical action group"
    short_name = "critical"
    # If this is an email distribution group you probably only need one email address instead of 
    # listing and maintining them here.
    subscriber_name  = "critical alerts"
    subscriber_email = "critical.alerts@mailinator.com"
    subscribers = []
  }
}
# 
# App Insights
#
module "appinsights" {
  
  source           = "../../../submodules/terraform-azurerm/services/app-insights/endpoint/base/v1"

  context          = module.my_resource_group.context

  service_settings =  {
      name = "${module.my_resource_group.context.application_name}-${module.my_resource_group.context.environment_name}-${module.my_resource_group.context.location.suffix}"
      retention_in_days = var.logs_short_term_days
      action_groups = {
        critical = [module.alert_group_critical.id ]
        high = []
        moderate = []
      }
  }
  
}

# 
# Log Storage Account
#

module "logs_storage" {
  
  source = "../../../submodules/terraform-azurerm/services/storage/endpoint/base/v1"

  context = module.my_resource_group.context

  service_settings = {
      name                = "logretention"
      tier                = "Standard"
      type                = "LRS"  # RAGRS or something better for production use
      security_settings = {
        allow_blob_public_access = false
        min_tls_version          = "TLS1_2"
      }
    }

}

# 
# Log Storage Container
#
resource "azurerm_storage_container" "container" {
  name                  = "logretention"
  storage_account_name  = module.logs_storage.name
}


# This can be passed to anything wanting observability_settings
locals {
    observability_settings = {
        instrumentation_key = module.appinsights.instrumentation_key
        workspace_id        = module.log_analytics.id 
        storage_account     = module.logs_storage.id
        retention_policy = {
          short_term = var.logs_short_term_days
          long_term  = var.logs_long_term_days  
        }
        action_groups = {
          critical = [ module.alert_group_critical.id ]
          high = []
          moderate = []
        }
    }
}
