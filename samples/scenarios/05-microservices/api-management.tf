#
# 1 - Create the API management endpoint, this gives us a URL and allows us to start building out 
#     api management.
#
module "apim" {
  
  source  = "../../../submodules/terraform-azurerm/services/api-management/endpoint/base/v1"
  context                = local.context
  observability_settings = local.observability_settings

  service_settings = {
    name               = local.default_resource_name
    tier = "Developer"
    capacity = 1

    publisher          = {
        name  = "Terraform AzureRM Module"
        email = "nobody@nowhere.com"
    }
    policies = {
        inbound          =  ""  # allow anybody to talk to API mgmt (TODO: when we add front door to demo, lock this down)
        backend          = "<forward-request timeout='30'/>"
        outbound         = ""
        error            = ""
        # <<-EOT
        #                     <return-response><set-status code='429' reason='Too many requests' />
        #                     <set-body><![CDATA[{ Rate limit is exceeded. Try again after some time.}]]></set-body>
        #                     </return-response>
        #                     <return-response><set-status code="500" reason="Internal Server Error" />
        #                     <set-body><![CDATA[{ Internal Server Error, Please try again. }]]></set-body>
        #                     </return-response>   
        #                     <return-response><set-status code="503" reason="Service Unavailable" />
        #                     <set-body><![CDATA[{ Service Unavailable, Please try again. }]]></set-body>
        #                     </return-response>
        #                     <retry condition="@(context.Response.StatusCode == 500)" count="2" interval="10" />
        #                     EOT

    }
  }
}

#
# Create a "Product", this is a product to be 'sold' or measured by API management.  You can 
# give access to a product, and rate limit etc.
#
module "product" {
  
  source = "../../../submodules/terraform-azurerm/services/api-management/product/base/v1"

  context = local.context

  service_settings = {
    endpoint            = module.apim.name 
    product = {
      id                  = "demoapi-${local.random_string}"
      description         = "AzureRM Demo API"
      approval_required     = false
      subscription_required = true 
      subscriptions_limit   = 1 
      publish               = true 
    }
  }
}
locals {
  no_policy = {
    inbound  = ""
    outbound = ""
    backend  = ""
    error    = ""
  }
}
#
# There is a product, and in azure-fcts.tf we have an Azure Function app Created
# We now need to create the connections that tie API management to the 
# function.
# With the IP restrictions on the Azure function only a small set 
# of IP address can access the Function Directly.  The rest of the 
# world needs to access the API with API Management.
#
module "demo_api_fct" {
  source = "../../../submodules/terraform-azurerm/services/api-management/api/base/v1"
  context = local.context
  service_settings = {
    endpoint = module.apim.name 
    logger   = module.apim.logger.id 
    api = {
      name         = "demo-api"
      description  = "Demonstration API"
      revision     = 1 
      path         = "demo-api"

      # This is a bit hardcoded, the C# code determines the final paths
      # of the URL and there isn't an easy way to import the Paths
      # into terraform.  So I'm hardcoding this path for sake of 
      # demo simplicity.  
      service_url  = "https://${module.fn_demo.name}.azurewebsites.net/api/"

      products = [ module.product.product_id ]
      subscription_required = true
      policies = local.no_policy

    }

  }
}

# Teraform Docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation
# Underlying API docs: https://docs.microsoft.com/en-us/rest/api/apimanagement/2019-12-01/apioperation/createorupdate
resource "azurerm_api_management_api_operation" "name_get" {
  resource_group_name = local.context.resource_group_name
  api_management_name = module.apim.name 
  api_name            = module.demo_api_fct.name 
  operation_id        = "azurerm-demo-get"
  display_name        = "Azure Demo Get"
  description         = "<h2>Get<h2> - perform a get with a name parameter"
  method              = "get"
  url_template        = "/AzureRMDemo"  
  response {
    status_code = 200
  }
  # The parammeter 'name' is passed without harm, so there doesn't see to be a lot 
  # of need for this tight integration, unless you want to perform validations/transformations
  # at the API Management Layer.
  #

  #request {
  #  query_parameter {
  #    name = "name"  # The API takes one parameter, called 'name' which is like ?name=joe
  #    required = false 
  #    type = "string" 
  #  }
  #}


}

resource "azurerm_api_management_api_operation" "health_get" {
  resource_group_name = local.context.resource_group_name
  api_management_name = module.apim.name 
  api_name            = module.demo_api_fct.name 
  operation_id        = "healthcheck"
  display_name        = "Health Check"
  description         = "Returns if the resources by the Azure Function are working."
  method              = "get"
  url_template        = "/healthcheck"  # do not add any paths to the URL passed to the Azure Function, 
  response {
    status_code = 200
  }
}



