resource "proxmox_virtual_environment_vm" "test_clone" {
  name      = var.clone_name
  node_name = var.proxmox_node
  vm_id     = var.clone_vm_id

  clone {
    vm_id = var.template_vm_id
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  # Mise à jour automatique de l'inventaire Ansible
  provisioner "local-exec" {
    command = <<-EOT
      echo "[test-clean]" >> ~/ansible-infra-lab2/inventory
      echo "${var.clone_name} ansible_host=${self.ipv4_addresses[1][0]}" >> ~/ansible-infra-lab2/inventory
    EOT
  }
}

output "vm_ip" {
  value = proxmox_virtual_environment_vm.test_clone.ipv4_addresses
}

output "vm_hostname" {
  value = proxmox_virtual_environment_vm.test_clone.name
}
