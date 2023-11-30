locals {
  prefix  = "oie-eus"
  network = "sharedservices"
}

# HUB RESOURCE GROUP
resource "azurerm_resource_group" "ss_vnet_rg" {
  name     = "${local.prefix}-${local.network}-rg"
  location = var.location
  tags     = var.default_tags
}

# HUB VNET 
resource "azurerm_virtual_network" "ss_vnet" {
  name                = "${local.prefix}-${local.network}-vnet"
  location            = azurerm_resource_group.ss_vnet_rg.location
  resource_group_name = azurerm_resource_group.ss_vnet_rg.name
  address_space       = var.vnet
  tags = merge(
    var.default_tags,
    {
      Name = "${local.prefix}-${local.network}-vnet"
    },
  )
}

# HUB GATEWAY SUBNET
resource "azurerm_subnet" "gw_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.ss_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.ss_vnet.name
  address_prefixes     = var.gateway
}

# HUB FIREWALL SUBNET
resource "azurerm_subnet" "afw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.ss_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.ss_vnet.name
  address_prefixes     = var.firewall
}

# AZURE BASTION
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.ss_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.ss_vnet.name
  address_prefixes     = var.bastion
}

# HUB MANAGEMENT SUBNET
resource "azurerm_subnet" "mgmt_subnet" {
  name                 = "${local.prefix}-${local.network}-mgmt-subnet"
  resource_group_name  = azurerm_resource_group.ss_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.ss_vnet.name
  address_prefixes     = var.mgmt
}

# Virtual Network Gateway PUBLIC IP
resource "azurerm_public_ip" "ss_vgw_pip" {
  name                = "${local.prefix}-${local.network}-vng-pip"
  location            = azurerm_resource_group.ss_vnet_rg.location
  resource_group_name = azurerm_resource_group.ss_vnet_rg.name

  allocation_method = "Dynamic"
}

# Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "ss_vngw" {
  name                = "${local.prefix}-${local.network}-ss_vngw"
  location            = azurerm_resource_group.ss_vnet_rg.location
  resource_group_name = azurerm_resource_group.ss_vnet_rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "${local.prefix}-${local.network}-ss_vngw-ip"
    public_ip_address_id          = azurerm_public_ip.ss_vgw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gw_subnet.id
  }
  depends_on = [azurerm_public_ip.ss_vgw_pip]
}

# HUB AZURE FIREWALL PUBLIC IP
resource "azurerm_public_ip" "ss_afw_pip" {
  name                = "${local.prefix}-${local.network}-afw-pip"
  location            = azurerm_resource_group.ss_vnet_rg.location
  resource_group_name = azurerm_resource_group.ss_vnet_rg.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# HUB AZURE FIREWALL
resource "azurerm_firewall" "firewall" {
  name                = "${local.prefix}-${local.network}-firewall"
  location            = azurerm_resource_group.ss_vnet_rg.location
  resource_group_name = azurerm_resource_group.ss_vnet_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard" #"premium"

  ip_configuration {
    name                 = "${local.prefix}-${local.network}-afw-ip"
    subnet_id            = azurerm_subnet.afw_subnet.id
    public_ip_address_id = azurerm_public_ip.ss_afw_pip.id
  }
  tags = merge(
    var.default_tags,
    {
      Name = "${local.prefix}-${local.network}-firewall"
    },
  )
}

# PUBLIC IP FOR BASTION VM
resource "azurerm_public_ip" "ss_bastion_pip" {
  name                = "${local.prefix}-${local.network}-bastion-pip"
  location            = azurerm_resource_group.ss_vnet_rg.location
  resource_group_name = azurerm_resource_group.ss_vnet_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# BASTION VM
resource "azurerm_bastion_host" "ss_bastion_vm" {
  name                = "${local.prefix}-${local.network}-bastion"
  location            = azurerm_resource_group.ss_vnet_rg.location
  resource_group_name = azurerm_resource_group.ss_vnet_rg.name

  ip_configuration {
    name                 = "${local.prefix}-${local.network}-bastion-ip"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.ss_bastion_pip.id
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${local.prefix}-${local.network}-bastion"
    },
  )
}
