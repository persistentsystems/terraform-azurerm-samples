locals {
  context = {
    application_name = "pstf"
    environment_name = "adf"
    location = "East US"
    location_suffix = "us-east"
  }
}


module "rg" {

  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"

  context = local.context
  name = "pstf-rg"

}

module "adf" {

  source           = "github.com/persistentsystems/terraform-azurerm/services/datafactory/endpoint/base/v1"
  service_settings = {
                        name = "pstf-ADF"
                   }
    context = module.rg.context


}

module "web_linkedsvc-sample" {
     source = "github.com/persistentsystems/terraform-azurerm/services/datafactory/linked-services/web/base/v1"
     service_settings = {
                        name = "web_linkedsvc"
                        data_factory_name = module.adf.ADF_NAME
                        authentication_type = "Anonymous"
                        url = "http://www.bing.com"
                   }
    context = module.rg.context
}
