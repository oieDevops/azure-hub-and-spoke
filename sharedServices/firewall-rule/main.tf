locals {
  prefix  = "oie-eus"
  network = "sharedservices"
}

# FIREWALL RULE RESOURCE GROUP 
resource "azurerm_resource_group" "afw_web_rule_rg" {
  name     = "${local.prefix}-${local.network}-afw-web-rule-rg"
  location = var.location
  tags     = var.default_tags
}

# AZ FIREWALL RESOURCE GROUP DATA SOURCE
data "azurerm_resource_group" "afw_rg" {
  name = "${local.prefix}-${local.network}-rg"
}

# AZ FIREWALL DATA SOURCE
data "azurerm_firewall" "afw" {
  name                = "${local.prefix}-${local.network}-firewall"
  resource_group_name = "${local.prefix}-${local.network}-rg"
}

# AZ FIREWALL NETWORK RULE FOR WEB ACCESS
resource "azurerm_firewall_network_rule_collection" "afw_net_web" {
  name                = "${local.prefix}-${local.network}-web-rule"
  azure_firewall_name = data.azurerm_firewall.afw.name
  resource_group_name = data.azurerm_resource_group.afw_rg.name
  priority            = 101
  action              = "Allow"
  rule {
    name                  = "HTTP"
    source_addresses      = ["17.0.0.0/16"]
    destination_ports     = ["80"]
    destination_addresses = ["*"]
    protocols             = ["TCP"]
  }
  rule {
    name                  = "HTTPS"
    source_addresses      = ["17.0.0.0/16"]
    destination_ports     = ["443"]
    destination_addresses = ["*"]
    protocols             = ["TCP"]
  }
  rule {
    name                  = "ICMP"
    source_addresses      = ["*"]
    destination_ports     = ["*"]
    destination_addresses = ["*"]
    protocols             = ["ICMP"]
  }
}