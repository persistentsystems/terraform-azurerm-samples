# Newer Microsoft Security Adivisor Recommendations want mTLS connections to
# Azure Functions and API Management.  
# In a production environment you will want to be more careful about 
# how you create the Root Key.
# https://stvdilln.medium.com/creating-a-certificate-authority-with-hashicorp-vault-and-terraform-4d9ddad31118

module root_ca {
    source = "../../../submodules/terraform-azurerm/services/pki-certificates/v1/root-ca"
    output_cert_path = "./certs/root"    
}
module intermediate_ca {
    source = "../../../submodules/terraform-azurerm/services/pki-certificates/v1/int-ca"
    output_cert_path = "./certs/intermediate"
    ca_key_data = file(module.root_ca.ca_key_file)
    ca_pem_data = module.root_ca.ca_pem_data
}
# Cert for Azure Function to require to be called
module az_fct_client_cert {
    source = "../../../submodules/terraform-azurerm/services/pki-certificates/v1/client-cert"
    output_cert_path = "./certs/clients/az-fct"
    ca_key_data      = file(module.intermediate_ca.ca_key_file)
    ca_pem_data      = module.intermediate_ca.ca_pem_data
    subject_name     = "az-fct-client1@acme.com"

}
