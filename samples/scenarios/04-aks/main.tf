module "coreinfra" {
    source = "../01-coreinfra"
}
data http my_ip_address {
  url = "http://ipv4.icanhazip.com"    
}
locals {
    default_resource_name = "${module.coreinfra.context.application_name}-${module.coreinfra.context.environment_name}-${module.coreinfra.context.location_suffix}"
    aks_service_offering  = var.aks_service_offerings[var.aks_cluster_size]
}

module "aks_cluster" {
  
  source  = "../../../submodules/terraform-azurerm/services/aks/cluster/base/v1"

  context = module.coreinfra.context

  service_settings = {
    name                = local.default_resource_name
    # AKS will not deploy to an existing resource group, it will create this one.
    resource_group_name = "${module.coreinfra.context.resource_group_name}-cluster"
    node_count          = local.aks_service_offering.node_count
    node_size           = local.aks_service_offering.node_size
    node_min_count      = local.aks_service_offering.node_min_count
    node_max_count      = local.aks_service_offering.node_max_count
    rbac_enabled        = true
    enable_pod_security_policy = false 
    # Allow only the current machine acecss to the Kubernetes API
    api_server_authorized_ip_ranges = ["${chomp(data.http.my_ip_address.body)}/32" ]
  }
  # The Observability settings that help create keyvault
  # in a best practices manner
  observability_settings    = module.coreinfra.observability_settings
}
