#
# API Management APIs can belong to one or more products.
# A Subscription allows access to one or more products
# An API management User can have access to one or more Subscriptions.
# 
# If you are going to be onboarding more than a handful of users
# you probably want to use something more dynamic than Terraform.
#
# In the end you have User->Subscriptions->Products->APIs
#

# Create a User that will access out products
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_user
resource "azurerm_api_management_user" "user1" {
    resource_group_name = local.context.resource_group_name
    api_management_name = module.apim.name 
    user_id             = "Rush-1001001"
    first_name          = "Neal"
    last_name           = "Peart"
    email               = "cygnusx11@mailinator.com"
    state               = "active"
    confirmation        = "signup"
}

# Create a subscription that allows access to our DemoProduct
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_subscription
resource "azurerm_api_management_subscription" "user1_sub1" {
    resource_group_name = local.context.resource_group_name 
    api_management_name = module.apim.name
    user_id             = azurerm_api_management_user.user1.id 
    product_id          = module.product.id 
    display_name        = "Demo API access for Neal"
    state               = "active"
}