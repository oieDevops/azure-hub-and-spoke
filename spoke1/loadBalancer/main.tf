locals {
  spoke_rg = oie-eus-sandbox-rg
  spoke_vnet = oie-eus-sandbox-vnet
  spoke_web_subnet = oie-eus-sandbox-web-subnet
  lb_name = oie-eus-sandbox-iis-web
  scaleset_rg = webScaleSetRg
  vm_name = iis-web
  kv = oie
  kv_rg = key-vault-rg
  kv_secret_name = oie-eus-sandbox-iis-web-scaleset
}

# KEY VAULT DATA SOURCE
data "azurerm_key_vault" "vault" {
  name                = "${local.kv}"
  resource_group_name = "${local.kv_rg}"
}

# SPOKE FRONT END SUBNET DATA SOURCE
data "azurerm_subnet" "web_subnet" {
  name                 = "${local.spoke_web_subnet}"
  virtual_network_name = "${spoke_vnet}"
  resource_group_name  = "${spoke_rg}"
}

# LOAD BALANCER RESOURCE GROUP
resource "azurerm_resource_group" "lb_rg" {
  name     = "${local.lb_name}-lb"
  location = var.location
  tags     = var.default_tags
}

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