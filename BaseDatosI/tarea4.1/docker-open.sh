#!/bin/bash

# Script para abrir SQL Server en Docker (sin ejecutar script)

set -e

CONTAINER_NAME="sqlserver_uasd"
SA_PASSWORD="P@ssw0rd1234"

echo "=========================================="
echo "Abriendo SQL Server con Docker..."
echo "=========================================="

# 1. Detener y eliminar contenedor existente si está corriendo
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Deteniendo contenedor existente..."
    docker stop $CONTAINER_NAME 2>/dev/null || true
    docker rm $CONTAINER_NAME 2>/dev/null || true
fi

# 2. Ejecutar SQL Server en Docker
echo "Creando contenedor SQL Server..."
docker run -d \
    --name $CONTAINER_NAME \
    -e ACCEPT_EULA=Y \
    -e MSSQL_SA_PASSWORD=$SA_PASSWORD \
    -p 1433:1433 \
    mcr.microsoft.com/mssql/server:2022-latest

echo "Esperando a que SQL Server inicie (25 segundos)..."
sleep 25

# 3. Verificar conexión
echo "Verificando conexión a SQL Server..."
docker exec $CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd \
    -S localhost \
    -U sa \
    -P $SA_PASSWORD \
    -Q "SELECT @@VERSION;" || {
        echo "Error: No se puede conectar a SQL Server"
        exit 1
    }

echo ""
echo "=========================================="
echo "✓ SQL Server está corriendo y listo"
echo "=========================================="
echo ""
echo "Información de conexión:"
echo "  Server: localhost,1433"
echo "  User: sa"
echo "  Password: $SA_PASSWORD"
echo ""
echo "Ahora puedes ejecutar tu script SQL:"
echo ""
echo "  cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro.sql | docker exec -i $CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD"
echo ""
echo "O desde Azure Data Studio conectándote a: localhost,1433"
echo ""
echo "Para ver logs:"
echo "  docker logs $CONTAINER_NAME"
echo ""
echo "Para detener:"
echo "  docker stop $CONTAINER_NAME"
