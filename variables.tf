variable "proxmox_node" {
  type    = string
  default = "proxmox"
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "lxc_root_password" {
  type      = string
  sensitive = true
}
