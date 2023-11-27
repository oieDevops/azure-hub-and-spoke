output "rg_id" {
  value = azurerm_resource_group.spoke_vnet_rg.id
}

output "vnet_id" {
  value = azurerm_virtual_network.spoke_vnet.id
}

output "web_id" {
  value = azurerm_subnet.web_subnet.id
}

output "app_id" {
  value = azurerm_subnet.app_subnet.id
}

output "db_id" {
  value = azurerm_subnet.db_subnet.id
}