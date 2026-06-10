terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.60.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.1.1:8006/"
  username = "root@pam"
  password = var.proxmox_password
  insecure = true
}
