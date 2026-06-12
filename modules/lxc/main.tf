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
        gateway = var.gateway
      }
    }

    dns {
      servers = var.dns_servers
      domain  = var.dns_domain
    }

    user_account {
      keys     = var.ssh_keys
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
    swap      = var.swap
  }

  network_interface {
    name    = "eth0"
    bridge  = var.network_bridge
    enabled = true
  }

  # Attendre que le SSH soit prêt, puis appeler Ansible
  provisioner "local-exec" {
    command = <<-EOT
      echo "Attente du démarrage SSH..."
      for i in $(seq 1 30); do
        sshpass -p '${var.root_password}' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 root@${split("/", var.ipv4_address)[0]} exit && break
        sleep 10
      done
      cd ~/ansible-infra-lab2
      ansible-playbook -i inventory playbook_first_install.yml --limit ${var.hostname}
    EOT
  }
}
