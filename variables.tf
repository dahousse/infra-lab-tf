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
variable "template_vm_id" {
  description = "ID du template à cloner"
  type        = number
}

variable "clone_vm_id" {
  description = "ID de la nouvelle VM"
  type        = number
}

variable "clone_name" {
  description = "Nom de la nouvelle VM"
  type        = string
}
