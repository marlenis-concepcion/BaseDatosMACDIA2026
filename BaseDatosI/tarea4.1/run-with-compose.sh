#!/bin/bash

# ⚠️  DEPRECATED: Este script usa SQL Server que no funciona en Mac Apple Silicon
# ⚠️  USAR: setup-y-ejecutar.sh EN SU LUGAR (compatible con MySQL en Docker)

# Script para ejecutar SQL Server y el script maestro usando Docker Compose

set -e

SCRIPT_PATH="./Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro.sql"
CONTAINER_NAME="sqlserver_uasd"
SA_PASSWORD="P@ssw0rd1234"

echo "=========================================="
echo "Iniciando SQL Server con Docker Compose..."
echo "=========================================="

# 1. Cambiar al directorio del proyecto
cd "$(dirname "$SCRIPT_PATH")"

# 2. Iniciar servicios
echo "Levantando contenedor..."
docker-compose up -d

# 3. Esperar a que SQL Server esté listo
echo "Esperando a que SQL Server esté completamente inicializado..."
for i in {1..30}; do
    if docker-compose exec -T sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -Q "SELECT 1" &>/dev/null; then
        echo "✓ SQL Server listo"
        break
    fi
    echo "Intento $i/30..."
    sleep 2
done

# 4. Ejecutar script SQL
echo ""
echo "=========================================="
echo "Ejecutando script maestro..."
echo "=========================================="
docker-compose exec -T sqlserver /opt/mssql-tools/bin/sqlcmd \
    -S localhost \
    -U sa \
    -P $SA_PASSWORD \
    -i /var/opt/mssql/script.sql < <(cat "$SCRIPT_PATH") || true

# Alternativa si la anterior falla:
if [ $? -ne 0 ]; then
    echo "Intentando método alternativo..."
    cat "$SCRIPT_PATH" | docker-compose exec -T sqlserver /opt/mssql-tools/bin/sqlcmd \
        -S localhost \
        -U sa \
        -P $SA_PASSWORD
fi

echo ""
echo "=========================================="
echo "✓ Proceso completado"
echo "=========================================="
echo ""
echo "Información de conexión:"
echo "  Server: localhost,1433"
echo "  User: sa"
echo "  Password: $SA_PASSWORD"
echo "  Database: SeguroVehiculos"
echo ""
echo "Para ver los logs:"
echo "  docker-compose logs -f"
echo ""
echo "Para detener los servicios:"
echo "  docker-compose down"
echo ""
echo "Para detener y eliminar datos:"
echo "  docker-compose down -v"
