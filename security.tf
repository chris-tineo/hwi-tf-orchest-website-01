resource "azurerm_key_vault" "keyvault01" {
  name                        = "keyvwebsprd01"
  location                    = "East US 2"
  resource_group_name         = module.resourcegroup.rg_name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
 
resource "azurerm_key_vault_access_policy" "srvprinc_permissions" {
  key_vault_id = azurerm_key_vault.keyvault01.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "0f6a62ba-a500-46d5-b1fc-a3a918fbfc3c"

  key_permissions = [
    "Get", "Update", "Create", "Delete"
  ]

  secret_permissions = [
    "Get", "Update", "Create", "Delete"
  ]
}    
    
resource "azurerm_key_vault_access_policy" "srvprinc_permissions" {
  key_vault_id = azurerm_key_vault.keyvault01.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "4f6d35d3-98d3-4a7f-a293-885728cd1b03"

  key_permissions = [
    "Get", "Update", "Create", "Delete"
  ]

  secret_permissions = [
    "Get", "Update", "Create", "Delete"
  ]
}