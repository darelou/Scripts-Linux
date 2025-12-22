#!/bin/bash

# Monitoriza nuevos procesos cada segundo
old_process=$(ps -eo command)

while true; do
  new_process=$(ps -eo command)
  # Compara el estado anterior con el actual y muestra solo las líneas nuevas
  diff <(echo "$old_process") <(echo "$new_process") | grep ">"
  old_process="$new_process"
  sleep 1
done