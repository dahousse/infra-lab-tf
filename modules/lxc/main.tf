terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_container" "this" {
  node_name = var.node_name
  vm_id     = var.vm_id

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ipv4_address
      }
    }

    user_account {
      password = var.root_password
    }
  }

  operating_system {
    template_file_id = var.template_file_id
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.disk_size
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }
}
