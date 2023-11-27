locals {
  name        = "oie-eus-sharedservices-test-linux-vm"
  subnet_data = "oie-eus-sharedservices"
}

# RESOURCE GROUP
resource "azurerm_resource_group" "vm_rg" {
  name     = "${local.name}-rg"
  location = var.location
}

# SPOKE FRONT END SUBNET DATA SOURCE
data "azurerm_subnet" "mgmt_subnet" {
  name                 = "${local.subnet_data}-mgmt-subnet"
  virtual_network_name = "${local.subnet_data}-vnet"
  resource_group_name  = "${local.subnet_data}-rg"
}

# NIC
resource "azurerm_network_interface" "vm_nic" {
  name                = "${local.name}-nic"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "${local.name}-ip"
    subnet_id                     = data.azurerm_subnet.mgmt_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# GENERATE RANDOM_PET FOR OS DISK
resource "random_pet" "this" {
  length = 1
}

# HUB VIRTUAL MACHINE
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = local.name
  location              = azurerm_resource_group.vm_rg.location
  resource_group_name   = azurerm_resource_group.vm_rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = var.vmsize
  admin_username        = var.username

  admin_ssh_key {
    username   = var.username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "${local.name}-osdisk1-${random_pet.this.id}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${local.name}"
    },
  )
}
