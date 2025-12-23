#!/bin/bash
# port_scanner.sh

host=$1
if [ -z "$host" ]; then
    echo "Uso: ./archivo.sh <IP>"
    echo "Ejemplo: ./archivo.sh 127.0.0.1"
    exit 1
fi

echo "--- Escaneando puertos comunes en $host ---"
# Lista de puertos top (puedes añadir más)
ports=(21 22 23 25 53 80 110 139 443 445 1433 3306 3389 8000 8080)

for port in "${ports[@]}"; do
    # El truco de magia: redirigir eco al dispositivo TCP virtual de bash
    (echo > /dev/tcp/$host/$port) >/dev/null 2>&1 && \
        echo "Abierto: $port" || \
        echo "Cerrado: $port" >/dev/null # Silencioso si está cerrado
done

echo "--- Fin del escaneo ---"