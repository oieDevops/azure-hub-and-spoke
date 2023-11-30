output "rg_id" {
  value = azurerm_resource_group.ss_vnet_rg.id
}

output "vnet_id" {
  value = azurerm_virtual_network.ss_vnet.id
}

output "gw_subnet_id" {
  value = azurerm_subnet.gw_subnet.id
}

output "afw_subnet_id" {
  value = azurerm_subnet.afw_subnet.id
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}

output "mgmt_subnet_id" {
  value = azurerm_subnet.mgmt_subnet.id
}

output "ss_vngw_id" {
  value = azurerm_virtual_network_gateway.ss_vngw.id
}

output "firewall_id" {
  value = azurerm_firewall.firewall.id
}

output "ss_bastion_vm_id" {
  value = azurerm_bastion_host.ss_bastion_vm.id
}