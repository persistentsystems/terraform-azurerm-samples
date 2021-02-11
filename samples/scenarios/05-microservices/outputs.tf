output url_demofn {
    value = "https://${module.fn_demo.name}.azurewebsites.net/api/AzureRMDemo"
}
output demo_subscription_key {
    value = azurerm_api_management_subscription.user1_sub1.primary_key

}
output test_azure_fct_url {
    value = "curl 'https://${module.fn_demo.hostname}/api/AzureRMDemo?name=NealArmstrong'"
}
output test_azure_fct_healthcheck {
    value = "curl 'https://${module.fn_demo.hostname}/api/healthcheck'"
}
output test_api_management_url {
    value = "curl -H 'Ocp-Apim-Subscription-Key: ${azurerm_api_management_subscription.user1_sub1.primary_key}' '${module.apim.gateway_url}/${module.demo_api_fct.name}${azurerm_api_management_api_operation.name_get.url_template}?name=SallyRide'"
}
output test_api_management_healthcheck {
    value = "curl -H 'Ocp-Apim-Subscription-Key: ${azurerm_api_management_subscription.user1_sub1.primary_key}' '${module.apim.gateway_url}/${module.demo_api_health.name}${azurerm_api_management_api_operation.health_get.url_template}'"
}

output test_fd_api_name {
     value = "curl -H 'Ocp-Apim-Subscription-Key: ${azurerm_api_management_subscription.user1_sub1.primary_key}' 'https://${module.frontdoor.cname}/${module.demo_api_fct.name}${azurerm_api_management_api_operation.name_get.url_template}?name=JohnGlenn'"
}
output test_fd_api_health {
     value = "curl 'https://${module.frontdoor.cname}/${module.demo_api_health.name}${azurerm_api_management_api_operation.health_get.url_template}'"
}