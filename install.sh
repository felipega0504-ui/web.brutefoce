#!/bin/bash

echo ""
echo "======= Instalador de Web Vulnerability Scanner ======="
echo ""

# Da permisos de ejecución al script principal
if [ -f web.sh ]; then
    chmod +x web.sh
    echo "[OK] Permisos de ejecución añadidos a web.sh"
else
    echo "[ERROR] No se encontró web.sh en la carpeta actual."
    exit 1
fi

# Se asegura de que exista usuarios.txt
if [ ! -f usuarios.txt ]; then
    touch usuarios.txt
    echo "[OK] Archivo usuarios.txt creado (vacío)"
fi

echo ""
echo "Listo. Puedes ejecutar el escáner así:"
echo "    ./web.sh"
echo "O también:"
echo "    bash web.sh"
echo ""
echo "Recuerda usar solo para fines educativos y legales."
echo ""
echo "======================================================="
