locals {
  name        = "oie-eus-sandbox-test-linux-vm"
  subnet_data = "oie-eus-sandbox"
  kv_name         = "oie-sandbox-key-vault"
  kv_rg       = "oie-sandbox-key-vault"
}

# RESOURCE GROUP
resource "azurerm_resource_group" "vm_rg" {
  name     = "${local.name}-rg"
  location = var.location
}

# SPOKE FRONT END SUBNET DATA SOURCE
data "azurerm_subnet" "web_subnet" {
  name                 = "${local.subnet_data}-web-subnet"
  virtual_network_name = "${local.subnet_data}-vnet"
  resource_group_name  = "${local.subnet_data}-rg"
}

# KEY VAULT
data "azurerm_key_vault" "this" {
  name                = local.kv_name
  resource_group_name = "${local.kv_rg}-rg"
}

# NIC
resource "azurerm_network_interface" "vm_nic" {
  name                = "${local.name}-nic"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "${local.name}-ip"
    subnet_id                     = data.azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# GENERATE RANDOM_PET FOR OS DISK
resource "random_pet" "this" {
  length = 1
}

# GENERATE VM PASSWORD
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# SAVE PASSWORD TO KEYVAULT
resource "azurerm_key_vault_secret" "vm_password" {
  name         = "${local.name}-admin-password"
  value        = random_password.admin_password.result
  key_vault_id = data.azurerm_key_vault.this.id
}

# LINUX VIRTUAL MACHINE
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = local.name
  location                        = azurerm_resource_group.vm_rg.location
  resource_group_name             = azurerm_resource_group.vm_rg.name
  network_interface_ids           = [azurerm_network_interface.vm_nic.id]
  size                            = var.vmsize
  admin_username                  = var.username
  admin_password                  = random_password.admin_password.result
  disable_password_authentication = false

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
