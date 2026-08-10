#!/bin/bash

# Script para ejecutar consultas SQL interactivamente

CONTAINER_NAME="sqlserver_uasd"
SA_PASSWORD="P@ssw0rd1234"

echo "=========================================="
echo "Modo Consultas SQL - SeguroVehiculos"
echo "=========================================="
echo ""
echo "Escribe tus consultas SQL (termina con GO en una línea nueva)"
echo "O escribe 'exit' para salir"
echo ""

# Conectar a la terminal SQL interactiva
docker exec -it $CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD
