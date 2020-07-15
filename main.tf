

provider "azurerm" {
  version = "=2.18.0"
  features {}
}

provider "random" {
  version = "2.2.0"
}

provider "azuread" {
  version = "=0.7.0"
}

module "active_sample" {
  
  source           = "./samples/cosmos-db"

}