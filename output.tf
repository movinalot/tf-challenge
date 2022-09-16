output "ResourceGroup" {
  value = local.resource_group_name
}

output "FortiGate_Public_IP" {
  value = format("https://%s", azurerm_public_ip.public_ip.ip_address)
}

output "FortiGate_Admin_Credentials" {
  value = format("username: %s / password: %s", var.username, var.password)
}