variable "node_name" {}
variable "vm_id" {}

variable "hostname" {}
variable "ipv4_address" {
  default = "dhcp"
}

variable "root_password" {
  sensitive = true
}

variable "template_file_id" {}
variable "datastore_id" {}
variable "disk_size" {}

variable "cores" {}
variable "memory" {}
