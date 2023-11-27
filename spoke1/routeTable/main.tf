locals {
  name            = "oie-eus-sandbox-to-sharedservices-routing"
  subnet_data     = "oie-eus-sandbox-web-subnet"
  ss_rg_name      = "oie-eus-sharedservices-rg"
  spoke_rg_name   = "oie-eus-sandbox-rg"
  spoke_vnet_name = "oie-eus-sandbox-vnet"
  firewall_name   = "oie-eus-sharedservices-firewall"
  route_name      = "spoke-traffic-to-afw"
}

# ROUTE TABLE RESOURCE GROUP
resource "azurerm_resource_group" "rtb_rg" {
  name     = "${local.name}-rg"
  location = var.location
}

# HUB RESOURCE GROUP DATA SOURCE
data "azurerm_resource_group" "ss_rg" {
  name = local.ss_rg_name
}

# SPOKE RESOURCE GROUP DATA SOURCE
data "azurerm_resource_group" "spoke_rg" {
  name = local.spoke_rg_name
}

# SPOKE VNET DATA SOURCE
data "azurerm_virtual_network" "spoke_vnet" {
  name                = local.spoke_vnet_name
  resource_group_name = local.spoke_rg_name
}

# SPOKE FRONT END SUBNET DATA SOURCE
data "azurerm_subnet" "web_subnet" {
  name                 = local.subnet_data
  virtual_network_name = data.azurerm_virtual_network.spoke_vnet.name
  resource_group_name  = data.azurerm_resource_group.spoke_rg.name
}

# AZURE FIREWALL DATA SOURCE
data "azurerm_firewall" "this" {
  name                = local.firewall_name
  resource_group_name = data.azurerm_resource_group.ss_rg.name
}

# SPOKE RTB
# region specific. use one route table for both spoke vnet in same region
resource "azurerm_route_table" "rtb" {
  name                          = local.name
  location                      = data.azurerm_resource_group.ss_rg.location
  resource_group_name           = data.azurerm_resource_group.ss_rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = data.azurerm_firewall.this.ip_configuration[0].private_ip_address
  }

  route {
    name                   = local.route_name
    address_prefix         = "17.0.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = data.azurerm_firewall.this.ip_configuration[0].private_ip_address
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${local.name}"
    },
  )
}

# SPOKE RTB ASSOCIATION TO SPOKE WEB SUBNET
resource "azurerm_subnet_route_table_association" "rtb_assoc_1" {
  subnet_id      = data.azurerm_subnet.web_subnet.id
  route_table_id = azurerm_route_table.rtb.id
}

# SPOKE RTB ASSOCIATION TO SPOKE APP SUBNET
# resource "azurerm_subnet_route_table_association" "s1-rtb-assoc2" {
#   subnet_id      = data.azurerm_subnet.bEnd.id
#   route_table_id = azurerm_route_table.rtb.id
# }
