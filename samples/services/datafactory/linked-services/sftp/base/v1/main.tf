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

module "sftp_linkedsvc" {
     source = "github.com/persistentsystems/terraform-azurerm/services/datafactory/linked-services/sftp/base/v1"
     service_settings = {
                        name = "sftp_linkedsvc"
                        data_factory_name = module.adf.ADF_NAME
                        authentication_type = "Basic"
                        host = "test.rebex.net"
                        port = 22
                        username = "demo"
                        password = "password"
                   }
    context = module.rg.context
}
