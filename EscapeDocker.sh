#!/bin/bash

echo "--- COMPROBACIÓN DE ESCAPE DE DOCKER ---"

# 1. Comprobar si estamos en modo --privileged
if [ -e /dev/sda ]; then
    echo -e "[!] PELIGRO: El contenedor parece estar en modo PRIVILEGIADO."
    echo "    Puedes montar el disco del host con: mount /dev/sda1 /mnt"
fi

# 2. Comprobar si el socket de docker está montado
if [ -S /var/run/docker.sock ]; then
    echo -e "[!] PELIGRO: El socket de Docker está expuesto."
    echo "    Puedes crear un nuevo contenedor que controle el host."
fi

# 3. Comprobar capacidades (Capabilities)
echo "[*] Revisando capacidades especiales..."
capsh --print 2>/dev/null | grep -E "cap_sys_admin|cap_dac_override" && echo "    Capacidades peligrosas detectadas."

echo "--- Fin del análisis ---"