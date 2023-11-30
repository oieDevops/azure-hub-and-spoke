output "keyvault_rg_id" {
  value = azurerm_resource_group.keyvault_rg.id
}

output "vault_id" {
  value = azurerm_key_vault.vault.id
}
