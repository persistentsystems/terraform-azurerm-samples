module "waf" {
    
    source = "../../../submodules/terraform-azurerm/services/frontdoor/policy/base/v1"
    
    context = local.context 
    service_settings = {
        enabled = true 
        policy = {
            custom_block_response_status_code = "403"
            custom_block_response_body        = "UmVxdWVzdCBOb3QgQXV0aG9yaXplZA=="  # echo -n "Request Not Authorized" | base64
            mode                              = "Prevention"
            redirect_url                      = "https://YourErrorPage.domain.com" 
        }
        managed_rulesets = [
            {        
                type     = "DefaultRuleSet"
                version  = "1.0"   
            },
            {        
                type     = "Microsoft_BotManagerRuleSet"
                version  = "1.0"   
            }
        ]
        custom_rules = [
            {
                name                            = "GEOLocationFilter"
                enabled                         = true
                priority                        = 1
                rate_limit_duration_in_minutes  = 1
                rate_limit_threshold            = 10
                type                            = "MatchRule"
                action                          = "Allow"
                match_variable     = "RemoteAddr"
                operator           = "GeoMatch"
                negation_condition = false
                # Only Allow traffic from US and India into front door.
                match_values       = ["US", "IN"]
            }
        ]
    }
}


module "frontdoor" {
  source = "../../../submodules/terraform-azurerm/services/frontdoor/endpoint/base/v1"

  context                = local.context
  observability_settings = local.observability_settings 

  service_settings = {
    # This resource is global, so the location is not put in the name
    name              = "${local.context.application_name}-${local.context.environment_name}-${local.random_string}"
    waf_id            = module.waf.id
    pools = [
        {
            name             = "demoapi"
            healthprobe_path = "/demo-health"
            latency          = 0 
            backends = [
                    {
                        host_header = module.apim.gateway_domain
                        address     = module.apim.gateway_domain
                        http_port   = 80
                        https_port  = 443
                        weight      = 100  
                    }
            ]
        }
    ]    
  }

}