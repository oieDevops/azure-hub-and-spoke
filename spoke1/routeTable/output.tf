output "ss_rg_id" {
  value = data.azurerm_resource_group.ss_rg.id
}

output "spoke_rg_id" {
  value = data.azurerm_resource_group.spoke_rg.id
}

output "spoke_subnet_id" {
  value = data.azurerm_subnet.web_subnet.id
}

output "spoke_vnet_id" {
  value = data.azurerm_virtual_network.spoke_vnet.id
}

output "firewall_private_ip" {
  value = data.azurerm_firewall.this.ip_configuration[0].private_ip_address
}

output "rtb_rg_id" {
  value = azurerm_resource_group.rtb_rg.id
}

output "rtb_id" {
  value = azurerm_route_table.rtb.id
}
output "rtb_asscoation_id" {
  value = azurerm_subnet_route_table_association.rtb_assoc_1.id
}
