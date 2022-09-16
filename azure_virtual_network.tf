resource "azurerm_virtual_network" "virtual_network" {
  resource_group_name = local.resource_group_name
  location            = var.location

  name          = local.virtual_network_name
  address_space = [var.virtual_network_address_space]

  tags = {
    environment = local.environment_tag
  }
}

resource "azurerm_subnet" "subnet" {
  for_each = local.subnets

  resource_group_name = each.value.resource_group_name

  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_public_ip" "public_ip" {
  resource_group_name = local.resource_group_name
  location            = var.location

  name              = "pip_fgt"
  allocation_method = "Static"
  sku               = "Standard"

  tags = {
    environment = local.environment_tag
  }
}

resource "azurerm_network_interface" "network_interface" {
  for_each = local.network_interfaces

  resource_group_name = local.resource_group_name
  location            = var.location

  name                          = each.value.name
  enable_ip_forwarding          = each.value.enable_ip_forwarding
  enable_accelerated_networking = each.value.enable_accelerated_networking

  dynamic "ip_configuration" {

    for_each = each.value.ip_configurations
    content {
      name                          = ip_configuration.value.name
      primary                       = lookup(ip_configuration.value, "primary", false)
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
      public_ip_address_id          = ip_configuration.value.public_ip_address_id
    }
  }

  tags = {
    environment = local.environment_tag
  }
}

resource "azurerm_network_security_group" "network_security_group" {
  for_each = local.network_security_groups

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  name = each.value.name

  tags = {
    environment = local.environment_tag
  }
}

resource "azurerm_network_security_rule" "network_security_rule" {
  for_each = local.network_security_rules

  resource_group_name = each.value.resource_group_name

  network_security_group_name = each.value.network_security_group_name

  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
}


resource "azurerm_network_interface_security_group_association" "port1nsg" {
  network_interface_id      = azurerm_network_interface.network_interface["nic-port1"].id
  network_security_group_id = azurerm_network_security_group.network_security_group["nsg_external"].id
}

resource "azurerm_network_interface_security_group_association" "port2nsg" {
  network_interface_id      = azurerm_network_interface.network_interface["nic-port2"].id
  network_security_group_id = azurerm_network_security_group.network_security_group["nsg_internal"].id
}