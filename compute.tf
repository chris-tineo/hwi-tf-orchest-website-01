module "resourcegroup" {
  source  = "app.terraform.io/HelloWorldInc/resourcegroup/azurerm"
  version = "0.0.1"
  
  rsrc_name     = "RGWEBSITE01PROD"
  rsrc_location = "East US 2" 
}

module "appservice" {
  source  = "app.terraform.io/HelloWorldInc/appservice/azurerm"
  version = "0.0.1"
  
  rsrc_location = "aps"
  rsrc_name     = "apswebsprd01"
  rsrc_rg       =  module.resourcegroup.name
  rsrc_sku      =  "F1"
}
