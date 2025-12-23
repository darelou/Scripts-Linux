#!/bin/bash

echo "--- ENUMERACIÓN DE ENTORNO DE EJECUCIÓN ---"

# Lista de binarios a buscar
tools=("gcc" "g++" "python" "python3" "perl" "ruby" "php" "nc" "nmap" "wget" "curl" "git" "docker")

echo -e "HERRAMIENTA\tESTADO\t\tVERSIÓN"
echo "------------------------------------------------"

for tool in "${tools[@]}"; do
    path=$(which $tool 2>/dev/null)
    if [ ! -z "$path" ]; then
        version=$($tool --version 2>&1 | head -n 1 | cut -d' ' -f2,3)
        echo -e "$tool\t\t[INSTALADO]\t$version"
    else
        echo -e "$tool\t\t[NO]"
    fi
done

echo -e "\n[*] Información del Kernel y Sistema:"
uname -a
cat /etc/issue