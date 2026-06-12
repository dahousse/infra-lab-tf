module "test_lxc" {
  source = "./modules/lxc"

  node_name       = var.proxmox_node
  vm_id           = 999
  hostname        = "test-clean"
  template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  datastore_id    = "local-lvm"
  disk_size       = 8
  cores           = 1
  memory          = 512
  ipv4_address    = "192.168.1.99/24"
  root_password   = var.lxc_root_password
  ssh_keys        = [trimspace(file("~/.ssh/id_ed25519.pub"))]
}
