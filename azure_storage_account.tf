resource "random_id" "id" {
  keepers = {
    resource_group = local.resource_group_name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "diag${random_id.id.hex}"
  resource_group_name      = local.resource_group_name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  min_tls_version = "TLS1_2"

  tags = {
    environment = local.environment_tag
  }
}
