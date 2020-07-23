
locals {
  context = {
    application_name = "pstf"
    environment_name = "${random_string.random.result}"
    location = "East US"
    location_suffix = "us-east"
  }
}


resource "random_string" "random" {
  length = 4
  special = false
  lower = true
  upper = false
}

module "rg" {
  
  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"

  context = local.context
  name = "${local.context.application_name}-${local.context.environment_name}"

}



module "aks_cluster" {
  
  source  = "github.com/persistentsystems/terraform-azurerm/services/aks/cluster/base/v1"

  context = module.rg.context
  service_settings = {
    name                = "${local.context.application_name}-${local.context.environment_name}"
    resource_group_name = "${module.rg.context.resource_group_name}-nodes"
    node_count          = 1
    node_size           = "Standard_D2_v2"
  }

}
