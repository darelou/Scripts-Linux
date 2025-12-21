#!/bin/bash
# proc_mon.sh

# Duración del bucle
end=$((SECONDS+600)) # Ejecutar por 10 minutos (ajustable)

echo "--- Monitorizando procesos nuevos (Estilo PSPY) ---"
echo "Presiona Ctrl+C para parar."

# Guardamos estado inicial
ps -ef > /tmp/proc_old

while [ $SECONDS -lt $end ]; do
    # Guardamos estado actual
    ps -ef > /tmp/proc_new
    
    # Comparamos old vs new.
    # grep "<" muestra lo que estaba en el archivo nuevo pero no en el viejo
    diff /tmp/proc_old /tmp/proc_new | grep ">" | while read -r line; do
        # Limpiamos el formato del diff
        clean_line=$(echo "$line" | sed 's/> //')
        echo "[NUEVO PROCESO DETECTADO] $(date +%T) -> $clean_line"
    done
    
    # Actualizamos el estado "viejo" para la siguiente vuelta
    mv /tmp/proc_new /tmp/proc_old
    
    # Esperamos un poco (ajustar según necesidad, 0.5 o 1 segundo)
    sleep 1
done