data azurerm_subscription current {

}

output aks_login_command {
    value = "az aks get-credentials --subscription '${data.azurerm_subscription.current.display_name}' --resource-group '${module.coreinfra.context.resource_group_name}' --name '${local.default_resource_name}' --context demo-cluster --overwrite-existing "
}