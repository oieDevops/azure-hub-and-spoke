# This creates the following spoke resources
# Resource group
# Vnet
# web subnet
# app subnet
# database subnet

locals {
  prefix  = "oie-eus"
  network = "sandbox"
}

# SPOKE RESOURCE GROUP
resource "azurerm_resource_group" "spoke_vnet_rg" {
  name     = "${local.prefix}-${local.network}-rg"
  location = var.location
  tags     = var.default_tags
}

# SPOKE VNET 
resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "${local.prefix}-${local.network}-vnet"
  location            = azurerm_resource_group.spoke_vnet_rg.location
  resource_group_name = azurerm_resource_group.spoke_vnet_rg.name
  address_space       = var.vnet
  tags = merge(
    var.default_tags,
    {
      Name = "${local.prefix}-${local.network}-vnet"
    },
  )
}

# SPOKE WEB SUBNET 
resource "azurerm_subnet" "web_subnet" {
  name                 = "${local.prefix}-${local.network}-web-subnet"
  resource_group_name  = azurerm_resource_group.spoke_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = var.web
}

# SPOKE APP SUBNET 
resource "azurerm_subnet" "app_subnet" {
  name                 = "${local.prefix}-${local.network}-app-subnet"
  resource_group_name  = azurerm_resource_group.spoke_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = var.app
}

# SPOKE DATA SUBNET
resource "azurerm_subnet" "db_subnet" {
  name                 = "${local.prefix}-${local.network}-db-subnet"
  resource_group_name  = azurerm_resource_group.spoke_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = var.db
}
