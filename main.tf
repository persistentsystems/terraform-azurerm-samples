

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

# module "dev-sample" {
#   
#   source           = "./samples/scenarios/microservices"
# 
# }


module "fn-sample" {
  
  source           = "./samples/services/fn"

}

# module "blobstorage_linkedsvc-sample" {
#   
#   source           = "./samples/services/datafactory/linked-services/blob-storage/base/v1"
# 
# }

/*
module "cosmos-sample" {
  
  source           = "./samples/services/cosmos-db"

}*/

/*
module "log-analytics-sample" {
  
  source           = "./samples/services/log-analytics"

}*/
