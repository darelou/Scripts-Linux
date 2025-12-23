#!/bin/bash

echo "--- ENUMERACIÓN DE USUARIOS Y SESIONES ---"

echo -e "\n[*] Usuarios actualmente conectados:"
w

echo -e "\n[*] Últimos usuarios que iniciaron sesión:"
last -a | head -n 10

echo -e "\n[*] ¿Quién tiene procesos corriendo ahora mismo?"
ps -eo user | sort | uniq -c | sort -nr

echo -e "\n[*] Tareas programadas (Cron) visibles para todos:"
ls -la /etc/cron* 2>/dev/null

echo -e "\n[*] Llaves SSH en el sistema (posibles conexiones entre máquinas):"
find /home -name "id_rsa*" -o -name "authorized_keys" 2>/dev/null