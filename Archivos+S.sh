#!/bin/bash

# Colores para el output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

clear
echo -e "${YELLOW}--- CAZADOR DE BINARIOS SUID/SGID ---${NC}"
echo "Buscando en todo el sistema. Esto puede tardar un momento..."
echo "Ignorando errores de 'Permiso denegado' para limpiar la salida."
echo "---------------------------------------------------------"

# Archivos temporales
temp_suid=$(mktemp)
temp_sgid=$(mktemp)

# 1. Búsqueda de SUID (User +s) - Los más peligrosos para Root
# -perm -4000: busca bit SUID
# -type f: solo archivos (no directorios)
# 2>/dev/null: manda los errores al vacío
echo -e "${BLUE}[*] Buscando binarios con bit SUID (Permisos -4000)...${NC}"
find / -perm -4000 -type f 2>/dev/null > "$temp_suid"

# Procesar y mostrar SUID
if [ -s "$temp_suid" ]; then
    echo -e "${GREEN}Se encontraron los siguientes binarios SUID:${NC}"
    echo "PERMISOS      USUARIO   GRUPO     RUTA"
    echo "---------------------------------------------------------"
    
    # Leemos el archivo y hacemos un ls -lh para ver detalles
    while IFS= read -r file; do
        # Verificamos si es propiedad de ROOT (El objetivo real)
        owner=$(stat -c '%U' "$file")
        if [ "$owner" == "root" ]; then
            # Si es de root, lo pintamos en ROJO (Peligro crítico)
            ls -ldb "$file" | awk -v color="$RED" -v end="$NC" '{printf "%s %s %s " color $9 end "\n", $1, $3, $4}'
        else
            # Si no es de root, lo pintamos normal
            ls -ldb "$file" | awk '{print $1, $3, $4, $9}'
        fi
    done < "$temp_suid"
else
    echo "No se encontraron binarios SUID."
fi

echo "---------------------------------------------------------"

# 2. Búsqueda de SGID (Group +s) - Útil para pivoting lateral
echo -e "${BLUE}[*] Buscando binarios con bit SGID (Permisos -2000)...${NC}"
find / -perm -2000 -type f 2>/dev/null > "$temp_sgid"

if [ -s "$temp_sgid" ]; then
    # Mostramos solo las primeras 10 líneas para no saturar, ya que suele haber muchos
    count=$(wc -l < "$temp_sgid")
    echo -e "${GREEN}Se encontraron $count binarios SGID. Mostrando ejemplos:${NC}"
    head -n 10 "$temp_sgid"
    if [ "$count" -gt 10 ]; then echo "... (y otros $((count - 10)) más)"; fi
else
    echo "No se encontraron binarios SGID."
fi

# Limpieza
rm "$temp_suid" "$temp_sgid"

echo "---------------------------------------------------------"
echo -e "${YELLOW}Consejo: Busca estos binarios en https://gtfobins.github.io/${NC}"
echo "Busca secciones 'SUID' para ver cómo explotarlos."