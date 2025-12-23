#!/bin/bash
# network_recon.sh

echo -e "--- DESCUBRIMIENTO PASIVO DE RED ---"

echo -e "\n[*] Interfaces de Red y sus IPs:"
ip -4 addr show | grep -oE 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | awk '{print $2}'

echo -e "\n[*] Tabla ARP (Dispositivos que 'viven' cerca):"
# Muestra dispositivos que han hablado con esta máquina
arp -e 2>/dev/null || cat /proc/net/arp

echo -e "\n[*] Puertos escuchando localmente (Posibles servicios internos):"
# -l: listening, -n: numeric, -t: tcp, -u: udp
ss -lntu | grep "LISTEN" || netstat -lntu | grep "LISTEN"

echo -e "\n[*] Archivo /etc/hosts (Nombres de dominio internos):"
cat /etc/hosts | grep -v "localhost"