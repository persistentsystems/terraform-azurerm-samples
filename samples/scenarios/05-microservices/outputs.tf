output url_demofn {
    value = "https://${module.fn_demo.name}.azurewebsites.net/api/AzureRMDemo"
}
output demo_subscription_key {
    value = azurerm_api_management_subscription.user1_sub1.primary_key

}
output test_azure_fct_url {
    value = "curl 'https://${module.fn_demo.hostname}/api/AzureRMDemo?name=NealArmstrong'"
}
output test_api_management_url {
    value = "curl -H 'Ocp-Apim-Subscription-Key: ${azurerm_api_management_subscription.user1_sub1.primary_key}' '${module.apim.gateway_url}/${module.demo_api_fct.name}/?name=SallyRide'"
}