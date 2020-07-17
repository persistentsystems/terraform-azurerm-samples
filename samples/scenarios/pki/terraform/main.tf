

module "root_ca" {
    source              = "github.com/persistentsystems/terraform-azurerm/services/pki-certificates/v1/root-ca"
    common_name         = "ACME Root CA"
    issuer_organization = var.issuer_organization
    output_cert_path    = "${path.cwd}/secrets/root-ca"
}

module "intermediate_ca" {
    source              = "github.com/persistentsystems/terraform-azurerm/services/pki-certificates/v1/int-ca"
    common_name         = "ACME Int CA"
    issuer_organization = var.issuer_organization
    ca_key_file         = module.root_ca.ca_key
    ca_pem_data         = module.root_ca.ca_pem_data  
    output_cert_path    = "${path.cwd}/secrets/int-ca"
}
# you can chain more intermediate certs here, but you need to watch
# your validity period.  By default, the the root_ca is 20 years,
# the intermediate is good for 15 years.  An intermediate cannot 
# issue a cert with a validity longer than it's parent.  If you
# create a chain of intermediate certs, the validity period needs
# to get smaller on each one.



#
# client certs
#
module "client_cert" {
    source              = "github.com/persistentsystems/terraform-azurerm/services/pki-certificates/v1/client-cert"
    subject_name        = "user1@acme.com"
    ca_key_file         = module.intermediate_ca.ca_key
    ca_pem_data         = module.intermediate_ca.ca_pem_data  
    output_cert_path    = "${path.cwd}/secrets/clients/user1"
}

#
# Terraform 0.13 examples
# 0.13 allows you to loop a module over a set or list of objects
#
# Commented out as this will cause errors in earlier versions
#

# variable client_certs  {
#     type = set(string)
#     default = [ "user1@acme.com", "user2@acme.com", "user3@acme.com" ]
# }

# module "client_certs" {
#     source                   = "github.com/persistentsystems/terraform-azurerm/services/pki-certificates/v1/client-cert"
#     for_each                 = var.client_certs # loop though all emails in client certs
#         #indentation is not necessary
#         subject_name        = each.key 
#         ca_key_file         = module.intermediate_ca.ca_key
#         ca_pem_data         = module.intermediate_ca.ca_pem_data  
#         output_cert_path    = "${path.cwd}/secrets/clients/${each.key}"
# }


#
# Server cert
# The Common Names are dns names and we add SAN so that 
# the cert is valid when an IP address is used instead
#
module "server_cert" {
    source              = "github.com/persistentsystems/terraform-azurerm/services/pki-certificates/v1/server-cert"
    dns_names           = ["www.acme.com", "www1.acme.com", "www2.acme.com", "localhost" ]
    ip_addresses        = ["127.0.0.1", "192.168.1.5"]
    ca_key_file         = module.intermediate_ca.ca_key
    ca_pem_data         = module.intermediate_ca.ca_pem_data  
    output_cert_path    = "${path.cwd}/secrets/servers/www"
}

#
# CA bundle
# In order for our certs to be trusted each client needs to have all
# of the certs in order, up to our root ca, in order and in a file
# In our case we only have "Int CA Cert-> Root CA Cert"
# If you add more intermediates you need to add them here.
# To test:  openssl verify -verbose -CAfile  secrets/CA-certiciate-chain.pem -purpose sslserver  secrets/servers/www/cert.pem
resource local_file server_client_ca_chain {
    sensitive_content = "${module.intermediate_ca.ca_pem_data}\n${module.root_ca.ca_pem_data }"
    filename = "${path.cwd}/secrets/CA-certiciate-chain.pem"
    file_permission = "0600"
}
