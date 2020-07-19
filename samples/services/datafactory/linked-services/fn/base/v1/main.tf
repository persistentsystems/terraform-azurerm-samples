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

module "plan" {

  source  = "github.com/persistentsystems/terraform-azurerm/services/app-service/plan/premium/base/v1"

  context = module.rg.context
  service_settings = {
    name = "pstf-fn-svc21"
    size                   = "EP1"
    storage_type           = "GRS"
    maximum_instance_count = 1
    minimum_instance_count = 1
    workspace_id           = "foo"
  }

}


module "svc1" {

  source  = "github.com/persistentsystems/terraform-azurerm/services/fn/premium/base/v1"

  context = module.rg.context
  service_settings = {
    name = "pstf-fn-svc21"
    runtime_version = "~3"
    runtime_type = "dotnet"
    app_settings = {}
    plan_id = module.plan.id
    storage_account = module.plan.storage-account
  }

}

module "azfn_linkedsvc-sample" {
     source = "github.com/persistentsystems/terraform-azurerm/services/datafactory/linked-services/fn/base/v1"
     service_settings = {
                        name = "azfn_linkedsvc_name"
                        data_factory_name = module.adf.ADF_NAME
                        url = module.svc1.hostname
                        key = module.svc1.function_key
                   }
    context = module.rg.context
}
