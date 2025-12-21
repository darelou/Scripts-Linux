#!/bin/bash

echo "--- BUSCANDO RUTAS CON PERMISOS DE ESCRITURA ---"

# 1. Buscar directorios donde podemos escribir (para soltar exploits)
echo -e "\n[*] Directorios con escritura para todos (World-writable):"
find / -type d -perm -0002 -not -path "/proc/*" -not -path "/sys/*" 2>/dev/null

# 2. Buscar archivos que podemos modificar y que NO son nuestros
echo -e "\n[*] Archivos que puedes modificar (pero pertenecen a otros):"
find / -type f -writable -not -user $(whoami) -not -path "/proc/*" 2>/dev/null | head -n 15

# 3. Buscar archivos .sh, .py, .pl que sean escribibles (scripts de tareas)
echo -e "\n[*] Scripts que puedes editar (posibles Cron Jobs):"
find / -name "*.sh" -o -name "*.py" -writable 2>/dev/null | grep -v "home/$(whoami)"

echo -e "\n--- Búsqueda finalizada ---"