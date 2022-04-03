module "resourcegroup" {
  source  = "app.terraform.io/HelloWorldInc/resourcegroup/azurerm"
  version = "0.0.1"
  
  rsrc_name     = "RGWEBSITE01PROD"
  rsrc_location = "East US 2" 
}

module "appservice" {
  source  = "app.terraform.io/HelloWorldInc/appservice/azurerm"
  version = "0.0.2"
  
  rsrc_location = "East US 2"
  rsrc_name     = "apswebsprd01"
  rsrc_rg       =  module.resourcegroup.rg_name
  rsrc_sku      =  "S1"
  rsrc_os_type  = "Linux"
}

module "staticsite" {
  source  = "app.terraform.io/HelloWorldInc/staticsite/azurerm"
  version = "0.0.1"
 
  rsrc_location = "East US 2"
  rsrc_name     = "ststwebsprd01"
  rsrc_rg       =  module.resourcegroup.rg_name
}
