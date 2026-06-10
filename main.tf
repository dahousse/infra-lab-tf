resource "proxmox_virtual_environment_container" "test_lxc" {
  node_name = var.proxmox_node
  vm_id     = 999

  initialization {
    hostname = "test-clean"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      password = var.lxc_root_password
    }
  }

  operating_system {
    template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  }

  disk {
    datastore_id = "local-lvm"
    size         = 8
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
  }
}
