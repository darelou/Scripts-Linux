BEGIN { print "Analizando posibles ataques SQL..." }
# Busca patrones comunes de SQLi en la URL (columna 7 del log de Apache)
$7 ~ /union|select|drop|--/ {
    print "[ALERTA] IP: " $1 " intentó SQLi en: " $7
}