module my_resource_group {
    source  = "../../../submodules/terraform-azurerm/services/resource-group/base/v1"
    context = var.context 
    name = "myapp-dev-eastus"
}