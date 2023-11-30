locals {
  spoke_rg         = "oie-eus-sandbox"
  spoke_vnet       = "oie-eus-sandbox"
  spoke_web_subnet = "oie-eus-sandbox-web-subnet"
  lb_name          = "oie-eus-sandbox-iis-web"
  scaleset_rg      = "oie-eus-sandbox-webscaleset"
  vm_name          = "iis-web"
  kv_name          = "oie-sandbox-key-vault"
  kv_rg            = "oie-sandbox-key-vault"
  kv_secret_name   = "oie-eus-sandbox-iis-web-scaleset"
}

# KEY VAULT DATA SOURCE
data "azurerm_key_vault" "this" {
  name                = local.kv_name
  resource_group_name = "${local.kv_rg}-rg"
}

# SCALESET RESOURCE GROUP
resource "azurerm_resource_group" "vm_ss" {
  name     = "${local.scaleset_rg}-rg"
  location = var.location
}

# SPOKE FRONT END SUBNET DATA SOURCE
data "azurerm_subnet" "web_subnet" {
  name                 = local.spoke_web_subnet
  virtual_network_name = "${local.spoke_vnet}-vnet"
  resource_group_name  = "${local.spoke_rg}-rg"
}

# CREATE AZ STANDARD LOAD BALANCER
resource "azurerm_lb" "lb" {
  name                = "${local.lb_name}-lb"
  location            = azurerm_resource_group.vm_ss.location
  resource_group_name = azurerm_resource_group.vm_ss.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                          = "${local.lb_name}-ip"
    subnet_id                     = data.azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    private_ip_address            = "17.0.0.20" # PROVIDE A STATIC IP ADDRESS HERE FOR ALB
  }
}

# CREATE AZ LB BACKEND POOL
resource "azurerm_lb_backend_address_pool" "backend_address_pool" {
  name            = "${local.lb_name}-backend-pool"
  loadbalancer_id = azurerm_lb.lb.id
}

# CREATE AZ LB PROBE
resource "azurerm_lb_probe" "lb_probe" {
  name            = "${local.lb_name}-probe"
  protocol        = "Tcp"
  port            = var.application_port
  loadbalancer_id = azurerm_lb.lb.id
}

# CREATE AZ LB RULE
resource "azurerm_lb_rule" "lb_rule_app1" {
  name                           = "${local.lb_name}-rule-app-1"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_address_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
  loadbalancer_id                = azurerm_lb.lb.id
}

# GENERATE VM PASSWORD
resource "random_password" "admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# SAVE PASSWORD TO KEYVAULT
resource "azurerm_key_vault_secret" "vault" {
  name         = local.kv_secret_name
  value        = random_password.admin_password.result
  key_vault_id = data.azurerm_key_vault.this.id
}

# CREATE AZURE VM SCALE SET (AUTOSCALING GROUP)
resource "azurerm_windows_virtual_machine_scale_set" "vm_scaleset" {
  name                 = "${local.lb_name}-scaleset"
  location             = azurerm_resource_group.vm_ss.location
  resource_group_name  = azurerm_resource_group.vm_ss.name
  sku                  = var.vmsize
  instances            = 1
  computer_name_prefix = local.vm_name
  admin_username       = var.username
  admin_password       = random_password.admin_password.result


  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${local.vm_name}-network"
    primary = true

    ip_configuration {
      name                                   = "${local.vm_name}-ip"
      primary                                = true
      subnet_id                              = data.azurerm_subnet.web_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_address_pool.id]
    }
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${local.lb_name}-scaleset"
    },
  )
}
