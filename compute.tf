module "resourcegroup" {
  source  = "app.terraform.io/HelloWorldInc/resourcegroup/azurerm"
  version = "0.0.1"
  
  rsrc_name     = "RGWEBSITE01PROD"
  rsrc_location = "East US 2" 
}

module "staticsite" {
  source  = "app.terraform.io/HelloWorldInc/staticsite/azurerm"
  version = "0.0.3"
 
  rsrc_location   = "East US 2"
  rsrc_name       = "ststwebsprd01"
  rsrc_rg         =  module.resourcegroup.rg_name
  rsrc_skugeneral = "Standard"
}
  
#######Resources needed to Alert Static Site using Azure Monitor
  
resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = "lganwebsprd01"
  location            = "East US 2"
  resource_group_name = module.resourcegroup.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
  
resource "azurerm_application_insights" "appinsights" {
  name                = "apinwebsprd01"
  location            = "East US 2"
  resource_group_name = module.resourcegroup.rg_name
  workspace_id        = azurerm_log_analytics_workspace.loganalytics.id
  application_type    = "web"
}
