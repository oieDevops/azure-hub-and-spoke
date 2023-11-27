# This resource creates peering connection between sharedservices and spoke vnet

locals {
  sharedservices_prefix = "oie-eus-sharedservices"
  spoke_prefix          = "oie-eus-sandbox"
  peer_prefix           = "oie-eus"
  network               = "sandbox"
}

# HUB RG DATA SOURCE
data "azurerm_resource_group" "sharedservices_rg" {
  name = "${local.sharedservices_prefix}-rg"
}

# SPOKE1 RG DATA SOURCE
data "azurerm_resource_group" "spoke_vnet_rg" {
  name = "${local.spoke_prefix}-rg"
}

# HUB VNET DATA SOURCE
data "azurerm_virtual_network" "sharedservices_vnet" {
  name                = "${local.sharedservices_prefix}-vnet"
  resource_group_name = data.azurerm_resource_group.sharedservices_rg.name
}

# SPOKE 1 VNET DATA SOURCE
data "azurerm_virtual_network" "spoke_vnet" {
  name                = "${local.spoke_prefix}-vnet"
  resource_group_name = data.azurerm_resource_group.spoke_vnet_rg.name
}

# HUB TO SPOKE-1 PEERING
resource "azurerm_virtual_network_peering" "sharedservice_spoke_peer" {
  name                         = "${local.peer_prefix}-sharedservices-spoke-peer"
  resource_group_name          = data.azurerm_resource_group.sharedservices_rg.name
  virtual_network_name         = data.azurerm_virtual_network.sharedservices_vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# SPOKE-1 TO HUB PEERING
resource "azurerm_virtual_network_peering" "spoke_sharedservices_peer" {
  name                      = "${local.peer_prefix}-spoke-sharedservices-peer"
  resource_group_name       = data.azurerm_resource_group.spoke_vnet_rg.name
  virtual_network_name      = data.azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.sharedservices_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}