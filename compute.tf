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
  
resource "azurerm_storage_account" "storage_account" {
  name                     = "stacwebsprd01"
  resource_group_name      = module.resourcegroup.rg_name
  location                 = "East US 2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_service_plan" "serviceplan" {
  name                = "srplwebsprd01"
  resource_group_name = module.resourcegroup.rg_name
  location            = "East US 2"
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_function_app" "lnx_function_app" {
  name                = "lnfnwebsprd01"
  resource_group_name = module.resourcegroup.rg_name
  location            = "East US 2"

  storage_account_name = azurerm_storage_account.storage_account.name
  service_plan_id      = azurerm_service_plan.serviceplan.id

  site_config {}
}
