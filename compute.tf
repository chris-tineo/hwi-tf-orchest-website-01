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
  
resource "azurerm_application_insights" "example" {
  name                = "tf-test-appinsights"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  workspace_id        = azurerm_log_analytics_workspace.example.id
  application_type    = "web"
}
