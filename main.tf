module "test_lxc" {
  source = "./modules/lxc"

  # Identité Proxmox
  node_name = var.proxmox_node
  vm_id     = 999
  hostname  = "test-clean"

  # Réseau
  ipv4_address = "dhcp"

  # Sécurité
  root_password = var.lxc_root_password

  # OS
  template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"

  # Stockage
  datastore_id = "local-lvm"
  disk_size    = 8

  # Ressources
  cores  = 1
  memory = 512
}

# Appel automatique du playbook Ansible pour configurer la nouvelle machine
resource "null_resource" "ansible_first_install" {
  depends_on = [module.test_lxc]

  provisioner "local-exec" {
    command = <<-EOT
      cd ~/ansible-infra-lab2
      ansible-playbook -i inventory playbook_first_install.yml --limit test-clean
    EOT
  }
}
