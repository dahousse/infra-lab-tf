# infra-lab-tf
## 🏗️ Créer un template Proxmox léger avec Vagrant

Cette méthode permet de créer un template Debian 12 "Bookworm" ultra-léger, prêt à être cloné par Terraform ou utilisé manuellement.

### 1. Installer Vagrant
```bash
sudo apt update && sudo apt install vagrant -y
2. Télécharger l'image officielle Debian 12
bash
wget https://app.vagrantup.com/debian/boxes/bookworm64/versions/12.20250126.1/providers/virtualbox.box -O debian-bookworm64.box
3. Extraire l'archive .box
bash
mkdir debian-box
tar -xf debian-bookworm64.box -C debian-box
4. Copier l'image sur Proxmox
bash
scp debian-box/*.vmdk root@192.168.1.1:/var/lib/vz/template/iso/
5. Créer le template sur Proxmox
bash
ssh root@192.168.1.1 qm create 900 --name debian12-template --memory 512 --cores 1 --net0 virtio,bridge=vmbr0
ssh root@192.168.1.1 qm importdisk 900 /var/lib/vz/template/iso/debian-*.vmdk local-lvm
ssh root@192.168.1.1 qm set 900 --scsi0 local-lvm:vm-900-disk-0
ssh root@192.168.1.1 qm set 900 --boot c --bootdisk scsi0
ssh root@192.168.1.1 qm template 900
6. Utiliser le template avec Terraform
Dans votre main.tf, utilisez ce template en clonant le VM ID 900 :

hcl
clone      = 900
full_clone = true
Résultat : un template Debian 12 de 330 Mo, prêt à être cloné en quelques secondes.
## 🚀 Déploiement automatique d'une VM (Infrastructure as Code)

Cette méthode permet de créer une machine prête à l'emploi en moins de 30 secondes, sans aucune intervention manuelle.

### 1. Prérequis
- Un template Proxmox avec cloud-init activé (exemple : VM 102).
- Les variables `template_vm_id`, `clone_vm_id` et `clone_name` définies dans `terraform.tfvars`.

### 2. Déploiement
```bash
terraform apply -auto-approve
3. Résultat
Une VM créée à partir du template, avec IP, hostname et clé SSH injectés automatiquement.

L'inventaire Ansible est mis à jour automatiquement avec la nouvelle machine.

Ansible peut prendre le relais immédiatement avec playbook_first_install.yml.

4. Exemple de terraform.tfvars
hcl
template_vm_id = 102
clone_vm_id    = 903
clone_name     = "test-clone"
proxmox_password = "votre_mdp"
proxmox_user     = "root@pam"
proxmox_node     = "proxmox"
text

---

### 🚀 Appliquer la modification
