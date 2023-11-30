output "rg_id" {
  value = azurerm_resource_group.vm_rg.id
}

output "subnet_id" {
  value = data.azurerm_subnet.web_subnet.id
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}
