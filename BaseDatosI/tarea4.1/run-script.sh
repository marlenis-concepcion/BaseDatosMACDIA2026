#!/bin/bash

# Script para ejecutar el script maestro en el contenedor Docker

CONTAINER_NAME="sqlserver_uasd"
SA_PASSWORD="P@ssw0rd1234"
SCRIPT_PATH="Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro.sql"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: No se encuentra el archivo $SCRIPT_PATH"
    exit 1
fi

echo "=========================================="
echo "Ejecutando script maestro..."
echo "=========================================="
echo ""

cat "$SCRIPT_PATH" | docker exec -i $CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD

echo ""
echo "=========================================="
echo "✓ Script ejecutado correctamente"
echo "=========================================="
