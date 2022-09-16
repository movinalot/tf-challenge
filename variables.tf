variable "resource_group_name_suffix" {
  type    = string
  default = "terraform-single-fgt"
}

variable "location" {
  type    = string
  default = "centralus"
}

variable "username" {
  type = string
}

variable "virtual_network_address_space" {
  default = "10.1.0.0/16"
}

variable "fgtvm_configuration" {
  type    = string
  default = "fgtvm.conf"
}

variable "license_file" {
  type    = string
  default = ""
}
