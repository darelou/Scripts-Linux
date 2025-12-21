#!/bin/bash

# Función para limpiar al salir (mata procesos en segundo plano si cancelas con Ctrl+C)
trap "kill 0" SIGINT

clear
echo "--- ESCÁNER DE RED (Solo Ping) ---"

# 1. Solicitar datos
read -p "Introduce la IP de red (ej. 192.168.1.0): " ip_input
read -p "Introduce el CIDR (Nota: este script optimizado asume /24): " cidr_input

# Extraemos los primeros 3 octetos (ej. 192.168.1)
base_ip=$(echo $ip_input | cut -d'.' -f1-3)

echo "----------------------------------------"
echo "Iniciando barrido de pings en $base_ip.1 - $base_ip.254"
echo "Esto tomará unos segundos..."

# Archivo temporal para guardar resultados
temp_file=$(mktemp)

# 2. Bucle principal
# Lanzamos 254 pings en paralelo
for i in {1..254}; do
    (
        target="$base_ip.$i"
        # -c 1: un solo ping
        # -W 1: esperar máximo 1 segundo de respuesta
        if ping -c 1 -W 1 "$target" > /dev/null 2>&1; then
            echo "$target" >> "$temp_file"
        fi
    ) & # El & manda el proceso al fondo para ir rápido
done

# 3. Esperar a que terminen todos los pings
wait

echo "----------------------------------------"
echo "RESUMEN: IPs QUE RESPONDIERON"
echo "----------------------------------------"

# Ordenamos las IPs numéricamente y las mostramos
if [ -s "$temp_file" ]; then
    sort -V "$temp_file"
else
    echo "No se encontraron dispositivos."
fi

# Borramos el archivo temporal
rm "$temp_file"

echo "----------------------------------------"
echo "Escaneo finalizado."