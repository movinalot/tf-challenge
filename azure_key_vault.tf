data "azurerm_key_vault" "key_vault" {
  name                = "FTNT-Training-Key-Vault"
  resource_group_name = "FTNT-Training-Mgmt"
}

output "vault_uri" {
  value = data.azurerm_key_vault.key_vault.vault_uri
}

data "azurerm_key_vault_secret" "key_vault_secret" {
  name         = "tf-challenge-webhook"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

output "secret_value" {
  value     = data.azurerm_key_vault_secret.key_vault_secret.value
  sensitive = true
}