output "ResourceGroup" {
  value = local.resource_group_name
}

output "FortiGate_Public_IP" {
  value = format("https://%s", azurerm_public_ip.public_ip.ip_address)
}

output "credentials" {
  value = format("username: %s / password: %s", var.username, data.azurerm_key_vault_secret.fgt_password.value)
  sensitive = true
}