module my_resource_group {
    source  = "../../../submodules/terraform-azurerm/services/resource-group/base/v1"
    context = {
        application_name = "myapp"
        environment_name = "dev"
        location = {
            name = "East US"
            suffix = "east-us"
            number = 1
        }
    }
    name = "myapp-dev-east-us"
}