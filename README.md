# 🧱 infra-lab-tf — Terraform Proxmox

> Provisionnement automatisé de VMs Proxmox via Terraform (provider bpg/proxmox).

## 🚀 Déploiement rapide

```bash
terraform apply \
  -var="clone_prefix=test" \
  -var="clone_vm_id=906" \
  -var="template_vm_id=102" \
  -var="vm_cpus=2" \
  -var="vm_memory=2048" \
  -var="traefik_domain=test-906.mysmihome.duckdns.org" \
  -var="traefik_port=80" \
  -auto-approve
```

→ Clone template 102 → configure Ansible → enregistre Traefik

## 🗑️ Destruction

```bash
terraform destroy -auto-approve
```
Nettoie automatiquement : VM Proxmox + inventory Ansible + conf Traefik.

## 📋 Variables

| Variable | Default | Description |
|:---|---:|:---|
| `clone_prefix` | `"vm"` | Préfixe du nom |
| `clone_vm_id` | — | ID VM + nom `${prefix}-${id}` |
| `template_vm_id` | 102 | Template Proxmox |
| `vm_cpus` | 1 | CPU cores |
| `vm_memory` | 512 | RAM MB |
| `traefik_domain` | `""` | Domaine (optionnel) |
| `traefik_port` | `""` | Port service (optionnel) |

## 🔄 Cycle complet

Voir la doc : [`infra-lab/docs/cycle-tf-ansible-traefik.md`](https://github.com/dahousse/infra-lab/blob/main/docs/cycle-tf-ansible-traefik.md)

## ✅ CI/CD

| Workflow | Runner |
|:---|---|
| `terraform-validate.yml` | ubuntu-latest (fmt + validate) |
| `terraform-plan.yml` | self-hosted (plan contre Proxmox) |

## 🏷️ Versionning

Les tags suivent les Goals du Kanban. Même version sur les 3 repos.

| Tag | Goal | Date |
|:---|---:|:---|
| v0.4.0 | I1 — Cycle TF→Ansible→Traefik | 2026-06-26 |

---

*INFRA LAB — Hasmi © 2026*
