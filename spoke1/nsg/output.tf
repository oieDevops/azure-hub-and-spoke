output "nsg_rg_id" {
  value = azurerm_resource_group.this.id
}

output "nsg_id" {
  value = azurerm_network_security_group.this.id
}

output "nsg_assoc_id" {
  value = azurerm_subnet_network_security_group_association.this.id
}
