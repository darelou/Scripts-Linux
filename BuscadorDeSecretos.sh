#!/bin/bash

echo "--- Buscando secretos en archivos de configuración y logs ---"
echo "Buscando en /var/www, /home y /etc (excluyendo binarios)..."

# Definimos patrones: pass, key, token, user, db...
# -r: recursivo
# -i: insesible a mayúsculas
# -n: muestra número de línea
# -E: expresión regular extendida
# Excluimos directorios pesados o irrelevantes

grep -rTnE "password|secret|api_key|access_token|db_pass" \
    /var/www/html /home/* /etc/ \
    --exclude-dir={proc,sys,dev,run,boot,lib,bin,sbin} \
    --exclude=*.{png,jpg,gif,css,js,zip,gz} \
    2>/dev/null | head -n 20

echo "----------------------------------------"
echo "--- Analizando historiales de Bash (.bash_history) ---"
# A veces los admins escriben contraseñas en la terminal por error

grep -rE "mysql -p|sshpass|pass|key" /home/*/.bash_history /root/.bash_history 2>/dev/null

echo "--- Búsqueda finalizada ---"