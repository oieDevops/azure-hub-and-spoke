locals {
  kv_name = "oie-sandbox-key-vault"
}

data "azurerm_client_config" "current" {}

# CREATE KEY VAULT RESOURCE GROUP
resource "azurerm_resource_group" "keyvault_rg" {
  name     = "${local.kv_name}-rg"
  location = var.location
}

# CREATE KEY VAULT
resource "azurerm_key_vault" "vault" {
  name                        = local.kv_name
  location                    = azurerm_resource_group.keyvault_rg.location
  resource_group_name         = azurerm_resource_group.keyvault_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "List", "Create", "Delete", "Get", "Purge", "Recover", "Update", "GetRotationPolicy", "SetRotationPolicy",
    ]

    secret_permissions = [
      "Get", "Set",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}
