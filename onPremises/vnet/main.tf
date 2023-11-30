# SPOKE-1 RESOURCE GROUP
resource "azurerm_resource_group" "opRg" {
  name     = "onPremRg"
  location = var.location
  tags     = var.default_tags
}

# SPOKE-1 VNET 
resource "azurerm_virtual_network" "opVnet" {
  name                = "onPremVnet"
  location            = azurerm_resource_group.opRg.location
  resource_group_name = azurerm_resource_group.opRg.name
  address_space       = var.op_cidr
  tags = merge(
    var.default_tags,
    {
      Name = "onPremVnet"
    },
  )
}

# SPOKE-1 WEB SUBNET 
resource "azurerm_subnet" "fEnd" {
  name                 = "frontEnd"
  resource_group_name  = azurerm_resource_group.opRg.name
  virtual_network_name = azurerm_virtual_network.opVnet.name
  address_prefixes     = var.op_web
}

# SPOKE-1 APP SUBNET 
resource "azurerm_subnet" "bEnd" {
  name                 = "backEnd"
  resource_group_name  = azurerm_resource_group.opRg.name
  virtual_network_name = azurerm_virtual_network.opVnet.name
  address_prefixes     = var.op_app
}

# SPOKE-1 DATA SUBNET
resource "azurerm_subnet" "db" {
  name                 = "database"
  resource_group_name  = azurerm_resource_group.opRg.name
  virtual_network_name = azurerm_virtual_network.opVnet.name
  address_prefixes     = var.op_db
}
