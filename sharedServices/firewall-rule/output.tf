output "rg_id" {
  value = azurerm_resource_group.afw_web_rule_rg.id
}

output "afw_rg_id" {
  value = data.azurerm_resource_group.afw_rg.id
}

output "firewall_id" {
  value = data.azurerm_firewall.afw.id
}

output "rule_id" {
  value = azurerm_firewall_network_rule_collection.afw_net_web.id
}



