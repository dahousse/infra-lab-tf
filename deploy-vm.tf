resource "proxmox_virtual_environment_vm" "test_clone" {
  name      = "${var.clone_prefix}-${var.clone_vm_id}"
  node_name = var.proxmox_node
  vm_id     = var.clone_vm_id

  clone {
    vm_id = var.template_vm_id
  }

  cpu {
    cores = var.vm_cpus
  }

  memory {
    dedicated = var.vm_memory
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    dns {
      domain  = "local"
      servers = ["1.1.1.1", "8.8.8.8"]
    }

    user_account {
      keys     = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+DOpU0eaiBKxnRhNF85gTSjU2lwWgYpjjuk7zunCah infra@cockpit"]
      password = var.lxc_root_password
      username = "root"
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  # Mise à jour propre de l'inventaire Ansible + lancement automatique
  provisioner "local-exec" {
    command = <<-EOT
      # 1. Nettoyer les anciennes entrees pour ce nom
      sed -i "/^${var.clone_prefix}-${var.clone_vm_id} /d" ~/ansible-infra-lab2/inventory

      # 2. Construire la ligne d'inventaire avec vars Traefik si fournies
      LINE="${var.clone_prefix}-${var.clone_vm_id} ansible_host=${self.ipv4_addresses[1][0]}"
      if [ -n "${var.traefik_domain}" ] && [ -n "${var.traefik_port}" ]; then
        LINE="$LINE traefik_domain=${var.traefik_domain} traefik_port=${var.traefik_port}"
      fi

      # 3. Insérer sous [test-clean] (un seul emplacement)
      sed -i "/^\[test-clean\]/a\\$LINE" ~/ansible-infra-lab2/inventory

      # 4. Attendre que la VM soit joignable en SSH
      echo "Attente de la VM ${self.ipv4_addresses[1][0]}..."
      for i in $(seq 1 30); do
        ssh -o StrictHostKeyChecking=no -o ConnectTimeout=2 root@${self.ipv4_addresses[1][0]} "echo OK" 2>/dev/null && break
        sleep 2
      done

      # 5. Lancer Ansible — first_install (user infra, SSH, Zsh, paquets)
      echo "=== Ansible: First Install ==="
      cd ~/ansible-infra-lab2 && \
      ansible-playbook -i inventory playbook_first_install.yml \
        -l "${var.clone_prefix}-${var.clone_vm_id}" \
        --ssh-common-args="-o StrictHostKeyChecking=no"

      # 6. Lancer Ansible — traefik_config (enregistrement dans Traefik)
      if [ -n "${var.traefik_domain}" ] && [ -n "${var.traefik_port}" ]; then
        echo "=== Ansible: Traefik Config ==="
        ansible-playbook -i inventory playbook_traefik_config.yml \
          --ssh-common-args="-o StrictHostKeyChecking=no"
      fi
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      # Clean Ansible inventory
      sed -i "/^${self.name} /d" ~/ansible-infra-lab2/inventory

      # Clean Traefik conf (safe: rm -f ne génère pas d'erreur si inexistant)
      ssh -o StrictHostKeyChecking=no root@192.168.1.200 \
        "rm -f /etc/traefik/conf.d/${self.name}.yml && \
         systemctl kill -s USR1 traefik && \
         echo 'Traefik: ${self.name} config removed + reloaded'"
    EOT
  }
}

output "vm_ip" {
  value = proxmox_virtual_environment_vm.test_clone.ipv4_addresses
}

output "vm_hostname" {
  value = proxmox_virtual_environment_vm.test_clone.name
}
