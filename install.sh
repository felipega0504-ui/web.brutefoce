#!/bin/bash

echo ""
echo "Web Vulnerability Scanner - Mini Audit Script"
echo ""

# Si no se pasa argumento, solicitarlo por pantalla
if [ $# -lt 1 ]; then
    echo -n "Web URL: "
    read URL
    if [ -z "$URL" ]; then
        echo "Debes ingresar una URL para analizar."
        exit 1
    fi
else
    URL=$1
fi

echo "Analizando: $URL"
echo ""

# Verifica si curl está instalado
if ! command -v curl &> /dev/null
then
    echo "Error: curl no está instalado."
    exit 1
fi

# Obtener headers de respuesta
echo "Obteniendo headers HTTP..."
headers=$(curl -s -D - -o /dev/null "$URL")

echo "$headers" | grep -i 'server:' && echo "[INFO] Header 'Server' visible (¡puede revelar tecnología!)."
echo "$headers" | grep -i 'x-powered-by:' && echo "[WARN] Header 'X-Powered-By' presente: revela tecnología backend."
echo "$headers" | grep -i 'set-cookie:' | grep -vi 'httponly' && echo "[WARN] Las cookies pueden no tener 'HttpOnly'."
echo "$headers" | grep -i 'content-security-policy:' || echo "[WARN] Falta 'Content-Security-Policy'."
echo "$headers" | grep -i 'x-frame-options:' || echo "[WARN] Falta 'X-Frame-Options'. (Puede ser vulnerable a clickjacking)"
echo "$headers" | grep -i 'strict-transport-security:' || echo "[WARN] Falta 'Strict-Transport-Security'. (Mejor usar HTTPS estricto)"
echo "$headers" | grep -i 'x-content-type-options:' || echo "[WARN] Falta 'X-Content-Type-Options: nosniff'"
echo "$headers" | grep -i 'referrer-policy:' || echo "[WARN] Falta 'Referrer-Policy'."
echo "$headers" | grep -i 'permissions-policy:' || echo "[WARN] Falta 'Permissions-Policy'."
echo ""

# Quick check para directorio .git expuesto
if curl -s -o /dev/null -I -w "%{http_code}" "$URL/.git/config" | grep -q "200"
then
    echo "[CRITICAL] ¡Repositorio .git expuesto!"
fi

# Quick check para robots.txt
if curl -s -o /dev/null -I -w "%{http_code}" "$URL/robots.txt" | grep -q "200"
then
    echo "[INFO] Hay un archivo robots.txt público, puede contener rutas interesantes."
fi

echo ""
echo "[Finalizado] Auditoría básica completada. Úsalo sólo para prácticas legales y educativas."
