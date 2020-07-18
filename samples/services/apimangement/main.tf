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

module "apimanagement" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/api-mangement/backend/fn/base/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-api-mangement-sample"
        endpoint_name = "${local.context.application_name}-${local.context.environment_name}-api-mgmt-sample-endpoint"
        function_name = module.api_fn.name
        function_key = "${lookup(azurerm_template_deployment.azfn_function_key.outputs, "functionkey")}"
        protocol = "https"
    }
}

module "apimanagement" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/api-mangement/endpoint/base/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-api-mangement-sample"
        publisher_name = "Foo Bar"
        publisher_email = "food@bar.com"
        sku_name = "standard"
    }
}

module "apimanagement" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/api-mangement/endpoint/cors/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-cors-settings"
        publisher_name = "Foo Bar:
        publisher_email = "food@bar.com"
        sku_name = "standard"
    }
    cors_settings = {
        alllowed_origins = "https://localhost.com, http://localhost.com"
        allowed_headers = "https://localhost.com, http://localhost.com"
    }
}

module "apimanagement" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/api-mangement/product/base/v1"
    context = module.rg.context
    service_settings = {
        endpoint_name = "${local.context.application_name}-${local.context.environment_name}-api-mgmt-sample-endpoint"
        product_id = module.api_fn.product_id
        description = "Sample API Mangement Product Base"
    }
}

module "apimanagement" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/api-mangement/subscription/base/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-api-mangement-sample"
        endpoint_name = "${local.context.application_name}-${local.context.environment_name}-api-mgmt-sample-endpoint"
        product_id = module.api_fn.product_id
        user_id = "12345"
        description = "Sample API Management Subscription"
    }
}

module "apimanagement" {
    source = "github.com/persistentsystems/terraform-azurerm/blob/master/services/api-mangement/user/base/v1"
    context = module.rg.context
    service_settings = {
        name = "${local.context.application_name}-${local.context.environment_name}-api-mangement-sample"
        endpoint_name = "${local.context.application_name}-${local.context.environment_name}-api-mgmt-sample-endpoint"
        user_id = "12345"
        first_name = "Foo"
        last_name = "Bar"
        email = "foo@bar.com"
    }
}