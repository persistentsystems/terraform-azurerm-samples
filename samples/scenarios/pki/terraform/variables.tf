variable issuer_organization {
 type = object ({
     organization      = string
     organizational_unit = string
     street_address    = list(string)
     locality          = string # city
     province          = string # state
     country           = string
     postal_code       = string     
 })  
 default = {
     organization      = "ACME Corp"
     organizational_unit = "Development"
     street_address= ["1234 Main St"]
     locality      = "Beverly Hills"
     province      = "CA"
     country       = "USA"
     postal_code   = "90210"
 }
}
variable output_cert_path {
    type = string
    description = "Base File path of output certificate files."
    default ="./secrets"
}
variable common_name {
    type = string 
    description = "The name of the cert, describes the company issuing and type"
    default = "ACME.com Root CA"
}