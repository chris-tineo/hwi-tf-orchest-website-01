resource "azurerm_key_vault" "keyvault01" {
  name                        = "keyvwebsprd01"
  location                    = "East US 2"
  resource_group_name         = module.resourcegroup.rg_name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}
  
resource "azurerm_key_vault_access_policy" "srvprinc_permissions" {
  key_vault_id = azurerm_key_vault.keyvault01.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "a6a524c1-3010-4fa3-b8b8-40efe7c58ef6"

  key_permissions = [
    "Get", "Update", "Create", "Delete"
  ]

  secret_permissions = [
    "Get", "Delete", "Set", "List", "Purge", "Recover", "Restore"
  ]
}    
    
resource "azurerm_key_vault_access_policy" "ctineo_permissions" {
  key_vault_id = azurerm_key_vault.keyvault01.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "55379066-08e9-4fda-9b12-018b83392ba5"

  key_permissions = [
    "Get", "Update", "Create", "Delete"
  ]

  secret_permissions = [
    "Get", "Delete"
  ]
  depends_on = [
    azurerm_key_vault_access_policy.srvprinc_permissions,
  ]
}

resource "azurerm_key_vault_secret" "github_token" {
  name         = "githubtoken"
  value        = var.github_token
  key_vault_id = azurerm_key_vault.keyvault01.id
  
  depends_on = [
    azurerm_key_vault_access_policy.srvprinc_permissions,
  ]
}
