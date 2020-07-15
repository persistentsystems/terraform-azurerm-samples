

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


module "msa-sample" {
  
  source           = "./samples/scenarios/microservices"

}


module "fn-sample" {
  
  source           = "./samples/services/fn"

}


module "adf-sample" {
  
  source           = "./samples/services/datafactory"

}

/*
module "cosmos-sample" {
  
  source           = "./samples/services/cosmos-db"

}*/

/*
module "log-analytics-sample" {
  
  source           = "./samples/services/log-analytics"

}*/