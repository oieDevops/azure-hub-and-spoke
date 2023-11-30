output "rg_id" {
  value = azurerm_resource_group.vm_rg.id
}

output "subnet_id" {
  value = data.azurerm_subnet.web_subnet.id
}

output "vm_id" {
  value = azurerm_virtual_machine.vm.id
}

output "vault_url" {
  value = data.azurerm_key_vault.this.vault_uri
}

output "vault_id" {
  value = data.azurerm_key_vault.this.id
}