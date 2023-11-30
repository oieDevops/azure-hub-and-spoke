output "ss_rg_id" {
  value = data.azurerm_resource_group.sharedservices_rg.id
}

output "spoke_rg_id" {
  value = data.azurerm_resource_group.spoke_vnet_rg.id
}

output "ss_spoke_peer_id" {
  value = azurerm_virtual_network_peering.sharedservice_spoke_peer.id
}

output "spoke_ss_peer_id" {
  value = azurerm_virtual_network_peering.spoke_sharedservices_peer.id
}