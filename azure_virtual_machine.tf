locals {
  hostname = "vm-fgt"
}

resource "azurerm_virtual_machine" "virtual_machine" {
  resource_group_name = local.resource_group_name
  location            = var.location

  name = local.hostname

  network_interface_ids        = [azurerm_network_interface.network_interface["nic-port1"].id, azurerm_network_interface.network_interface["nic-port2"].id]
  primary_network_interface_id = azurerm_network_interface.network_interface["nic-port1"].id
  vm_size                      = local.vm_image["fortigate"].vm_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  zones = [1]

  storage_image_reference {
    publisher = local.vm_image["fortigate"].publisher
    offer     = local.vm_image["fortigate"].offer
    sku       = local.vm_image["fortigate"].license_type == "byol" ? local.vm_image["fortigate"].sku["byol"] : local.vm_image["fortigate"].sku["payg"]
    version   = local.vm_image["fortigate"].version
  }

  plan {
    name      = local.vm_image["fortigate"].license_type == "byol" ? local.vm_image["fortigate"].sku["byol"] : local.vm_image["fortigate"].sku["payg"]
    publisher = local.vm_image["fortigate"].publisher
    product   = local.vm_image["fortigate"].offer
  }

  storage_os_disk {
    name              = "disk-vm-fgt-os"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name              = "disk-vm-fgt-data"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "30"
  }

  os_profile {
    computer_name  = local.hostname
    admin_username = var.username
    admin_password = var.password
    custom_data = templatefile("${var.fgtvm_configuration}", {
      hostname     = local.hostname
      type         = local.vm_image["fortigate"].license_type
      license_file = var.license_file
      webhook_uri  = data.azurerm_key_vault_secret.key_vault_secret.value
    })
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }

  tags = {
    environment = local.environment_tag
  }
}
