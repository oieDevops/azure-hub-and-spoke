locals {
  name        = "oie-eus-sandbox-web-nsg"
  subnet_data = "oie-eus-sandbox"

}

# SPOKE FRONT END SUBNET DATA SOURCE
data "azurerm_subnet" "web_subnet" {
  name                 = "${local.subnet_data}-web-subnet"
  virtual_network_name = "${local.subnet_data}-vnet"
  resource_group_name  = "${local.subnet_data}-rg"
}

# NSG RESOURCE GROUP 
resource "azurerm_resource_group" "this" {
  name     = "${local.name}-rg"
  location = var.location
}

# NSG 
resource "azurerm_network_security_group" "this" {
  name                = local.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${local.name}"
    },
  )
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = data.azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.this.id
}
