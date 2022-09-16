resource "azurerm_resource_group" "resource_group" {
  count = local.resource_group_exists ? 0 : 1

  name     = local.resource_group_name_combined
  location = var.location

  tags = {
    environment = local.environment_tag
  }
}

data "azurerm_resource_group" "resource_group" {
  count = local.resource_group_exists ? 1 : 0
  name  = local.resource_group_name_combined
}
