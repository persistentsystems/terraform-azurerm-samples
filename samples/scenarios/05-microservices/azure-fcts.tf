module "api_hosting_plan" {
  
  source           = "../../../submodules/terraform-azurerm/services/app-service/plan/premium/base/v1"

  context                = local.context
  observability_settings = local.observability_settings
  
  service_settings = {
      name = local.default_resource_name
      size = "EP1"
      storage_type = "LRS"
      minimum_instance_count = 1
      maximum_instance_count = 2

  }

}

locals {

  code_drop_prefix = "https://${module.api_hosting_plan.storage_account.name}.blob.core.windows.net/${azurerm_storage_container.code_storage.name}"
  code_drop_url = "${local.code_drop_prefix}/${azurerm_storage_blob.deployment_blob.name}${module.api_hosting_plan.storage_account.sas}"

}
#
# "Upload", the zip file
#
resource "azurerm_storage_container" "code_storage" {
  name                    = "codedrops"
  storage_account_name    = module.api_hosting_plan.storage_account.name
  container_access_type   = "private"
}

resource "azurerm_storage_blob" "deployment_blob" {
  name                    = "DemoPackage.zip"
  storage_account_name    = module.api_hosting_plan.storage_account.name
  storage_container_name  = azurerm_storage_container.code_storage.name
  type                    = "Block"
  source                  = "./DemoPackage.zip"
}
#
# Create Azure Function with Zip File as Source. 
# When we load the ZIP file it will determine the APIs supported by 
# annotations in the code.
# See ./AzureFunctionCode/AzureFunctionCode.cs and this:
        # [FunctionName("AzureRMDemo")]
        # public static async Task<IActionResult> Run(
        #     [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
        #     ILogger log)
# So when we load this, all of the functions in the Module are exposed.  There isn't 
# a simple way to enumerate the APIs, and then feed them into API management.
# In the Zip file we upload is a file function.json that is auto generated and it lists
# the APIs and the verbs they support.  One could track/examine that to determine 
# What APIs are available.
# In the Azure Console you can navigate to the Azure Fct App->Functions and it will list the 
# functions exposed.  
module "fn_demo" {
  
  source                  = "../../../submodules/terraform-azurerm/services/fn/premium/base/v1"
  
  context                = local.context 
  observability_settings = local.observability_settings
  service_settings       = {
      plan = module.api_hosting_plan.id
      name = "${module.coreinfra.context.application_name}-${module.coreinfra.context.environment_name}-demo"
      runtime_version = "~3"
      runtime_type = "dotnet"
      app_settings = {
        Environment     = module.coreinfra.context.environment_name
        WEBSITE_RUN_FROM_PACKAGE = local.code_drop_url
      }

  }
  ip_rules_settings = {
    # Default value for below variable is set to empty but change it to ["0.0.0.0/0"] in the pipeline env
    # variable or set it in tfvar file to disable ip restriction which will allow access to all just like
    # original setting, add specifc ip list by replacing above values to restrict to user defined ip-s 
    # e.g - all developer ip-s
     user_defined_iplist = concat(["${chomp(data.http.my_ip_address.body)}/32"],var.user_defined_iplist)
     # API management will talk to these endpoints, so allow that to happen.
     apim_iplist          = module.apim.public_ip_cidr_ranges
     ## Microsoft publishes a list of Public IP ranges for it's services (https://www.microsoft.com/en-us/download/details.aspx?id=56519)
     ## If you have an Azure Service that nees to connect to thsese IPs add them here.
     services_iplist      = []
   }
}




