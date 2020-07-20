
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
  name = "pstf-fn-logs"

}

