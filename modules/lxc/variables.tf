variable "node_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "hostname" {
  type = string
}

variable "ipv4_address" {
  type = string
}

variable "root_password" {
  type      = string
  sensitive = true
}

variable "template_file_id" {
  type = string
}

variable "datastore_id" {
  type = string
}

variable "disk_size" {
  type    = number
  default = 8
}

variable "cores" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 512
}

variable "swap" {
  type    = number
  default = 512
}

variable "gateway" {
  type    = string
  default = "192.168.1.254"
}

variable "dns_servers" {
  type    = list(string)
  default = ["192.168.1.202"]
}

variable "dns_domain" {
  type    = string
  default = "mysmihome.duckdns.org"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "ssh_keys" {
  type    = list(string)
  default = []
}
