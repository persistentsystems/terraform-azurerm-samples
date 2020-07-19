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

module "storage-account" {
  source = "github.com/persistentsystems/terraform-azurerm/services/storage/endpoint/base/v1"
  service_settings = {
                        name = "pstfstorageacc"
                        tier = "Standard"
                        type = "GRS"
                   }
    context = module.rg.context
}

module "fileshare" {
  source  = "github.com/persistentsystems/terraform-azurerm/services/storage/file/share/base/v1"
  service_settings = {
                        name = "pstf-fileshare"
                        storage_account_name = module.storage-account.name
                        quota = 10
                   }
    context = module.rg.context
}

module "filestorage_linkedsvc" {
     source = "github.com/persistentsystems/terraform-azurerm/services/datafactory/linked-services/file-storage/base/v1"
     service_settings = {
                        name = "file_storage_linked_svc"
                        data_factory_name = module.adf.ADF_NAME
                        connection_string = module.storage-account.primary_connection_string
                   }
    context = module.rg.context
}
