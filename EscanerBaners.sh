#!/bin/bash

IP=$1
PORT=$2

if [ -z "$IP" ] || [ -z "$PORT" ]; then
    echo "Uso: ./banner_grabber.sh <IP> <PUERTO>"
    exit 1
fi

echo "[*] Intentando obtener banner de $IP:$PORT..."

# Usamos un timeout de 2 segundos para no quedarnos colgados
# Enviamos un carácter vacío para forzar al servicio a responder
timeout 2 bash -c "exec 3<>/dev/tcp/$IP/$PORT && echo -e 'HEAD / HTTP/1.0\r\n\r\n' >&3 && cat <&3" | head -n 10