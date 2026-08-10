#!/bin/bash

# ⚠️  DEPRECATED: Este script usa SQL Server que no funciona en Mac Apple Silicon
# ⚠️  USAR: setup-y-ejecutar.sh EN SU LUGAR (compatible con MySQL en Docker)

# Script para ejecutar SQL Server en Docker y cargar el script maestro
# REQUISITOS: Docker instalado y corriendo

set -e

DB_NAME="SeguroVehiculos"
CONTAINER_NAME="sqlserver_uasd"
SCRIPT_PATH="./Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro.sql"
SA_PASSWORD="P@ssw0rd1234"  # Cambiar por una contraseña segura

echo "=========================================="
echo "Iniciando SQL Server con Docker..."
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

echo "Esperando a que SQL Server inicie (20 segundos)..."
sleep 20

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

echo "✓ Conexión establecida"

# 4. Copiar script al contenedor
echo "Copiando script SQL al contenedor..."
docker cp "$SCRIPT_PATH" $CONTAINER_NAME:/var/opt/script.sql

# 5. Ejecutar script
echo ""
echo "=========================================="
echo "Ejecutando script maestro..."
echo "=========================================="
docker exec $CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd \
    -S localhost \
    -U sa \
    -P $SA_PASSWORD \
    -i /var/opt/script.sql

echo ""
echo "=========================================="
echo "✓ Script ejecutado correctamente"
echo "=========================================="
echo ""
echo "Información de conexión:"
echo "  Server: localhost"
echo "  Port: 1433"
echo "  User: sa"
echo "  Password: $SA_PASSWORD"
echo "  Database: $DB_NAME"
echo ""
echo "Para conectar desde Azure Data Studio o SSMS:"
echo "  Server name: localhost,1433"
echo ""
echo "Para ver logs del contenedor:"
echo "  docker logs $CONTAINER_NAME"
echo ""
echo "Para detener el contenedor:"
echo "  docker stop $CONTAINER_NAME"
