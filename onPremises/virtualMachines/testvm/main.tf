# RG DATA SOURCE
data "azurerm_resource_group" "this" {
  name = "sandbox-spoke1-eus-rg"
}
output "id" {
  value = data.azurerm_resource_group.this.id
}

# SPOKE 1  MANAGEMENT SUBNET DATA SOURCE
data "azurerm_subnet" "mgmt-sbn" {
  name                 = "sandbox-spoke1-eus-mgmt-sbn"
  virtual_network_name = "sandbox-spoke1-eus-vnet"
  resource_group_name  = "sandbox-spoke1-eus-rg"
}
output "subnet_id" {
  value = data.azurerm_subnet.mgmt-sbn.id
}

# NIC
resource "azurerm_network_interface" "spk1mgt-nic" {
  name                = "spk1-test-vm-nic"
  location              = data.azurerm_resource_group.this.location
  resource_group_name   = data.azurerm_resource_group.this.name

  ip_configuration {
    name                          = "spk1-testconfiguration1"
    subnet_id                     = data.azurerm_subnet.mgmt-sbn.id
    private_ip_address_allocation = "Dynamic"
  }
}


# HUB VIRTUAL MACHINE
resource "azurerm_virtual_machine" "spoke1-vm" {
  name                  = "spoke1-test-vm"
  location              = data.azurerm_resource_group.this.location
  resource_group_name   = data.azurerm_resource_group.this.name
  network_interface_ids = [azurerm_network_interface.spk1mgt-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "sandbox-spoke1-eus-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "spoke1-test-vm"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = merge(
    var.default_tags,
    {
      Name = "spoke1-test-vm"
    },
  )
}
