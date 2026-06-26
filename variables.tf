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

variable "clone_prefix" {
  description = "Préfixe du nom de VM (ex: test, app, db) — combiné avec vm_id pour un nom unique"
  type        = string
  default     = "vm"
}

variable "vm_cpus" {
  description = "Nombre de CPU cores"
  type        = number
  default     = 1
}

variable "vm_memory" {
  description = "RAM en MB"
  type        = number
  default     = 512
}

variable "traefik_domain" {
  description = "Domaine Traefik (optionnel) — auto-enregistre la VM dans Traefik"
  type        = string
  default     = ""
}

variable "traefik_port" {
  description = "Port Traefik (optionnel) — associé au domaine"
  type        = string
  default     = ""
}
