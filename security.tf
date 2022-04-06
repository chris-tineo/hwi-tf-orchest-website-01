resource "azurerm_key_vault" "keyvault01" {
  name                        = "keyvwebsprd01"
  location                    = "East US 2"
  resource_group_name         = module.resourcegroup.rg_name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
    
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "0f6a62ba-a500-46d5-b1fc-a3a918fbfc3c"

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}
