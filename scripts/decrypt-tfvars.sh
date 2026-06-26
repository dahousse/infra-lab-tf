#!/bin/bash
# Decrypt terraform.tfvars from Ansible Vault
# Usage: ./decrypt-tfvars.sh
set -e
VAULT_FILE="$(dirname "$0")/../.vault-tfvars.yml"
TFVARS="$(dirname "$0")/../terraform.tfvars"
if [ -f "$VAULT_FILE" ]; then
    ansible-vault decrypt "$VAULT_FILE" --output "$TFVARS" --vault-password-file ~/.vault_pass
    echo "Decrypted $VAULT_FILE → $TFVARS"
else
    echo "No vault file found at $VAULT_FILE"
    exit 1
fi
