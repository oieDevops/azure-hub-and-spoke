output "rg_id" {
  value = azurerm_resource_group.vm_ss.id
}

output "subnet_id" {
  value = data.azurerm_subnet.web_subnet.id
}

output "vm_ss_id" {
  value = azurerm_windows_virtual_machine_scale_set.vm_scaleset.id
}

output "lb_id" {
  value = azurerm_lb.lb.id
}

output "lb_rule_id" {
  value = azurerm_lb_rule.lb_rule_app1.id
}

output "probe_id" {
  value = azurerm_lb_probe.lb_probe.id
}

output "backend_address_pool" {
  value = azurerm_lb_backend_address_pool.backend_address_pool.id
}