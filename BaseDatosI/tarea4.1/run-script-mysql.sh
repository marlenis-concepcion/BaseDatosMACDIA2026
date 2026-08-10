#!/bin/bash

# Script para ejecutar el script maestro con MySQL en Mac

CONTAINER_NAME="mysql_uasd"
MYSQL_PASSWORD="P@ssw0rd1234"
MYSQL_USER="root"
MYSQL_DB="SeguroVehiculos"

echo "=========================================="
echo "Ejecutando script maestro en MySQL..."
echo "=========================================="
echo ""

# Verificar que el contenedor existe
if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "❌ Error: MySQL no está corriendo"
    echo ""
    echo "Primero ejecuta:"
    echo "docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0"
    echo ""
    echo "Luego espera 15 segundos"
    exit 1
fi

# Función para ejecutar un script SQL
run_script() {
    local script_file=$1
    local script_name=$2

    if [ ! -f "$script_file" ]; then
        echo "❌ Error: No se encuentra $script_file"
        return 1
    fi

    echo "▶️  Ejecutando: $script_name"

    # Adaptar SQL de SQL Server a MySQL
    cat "$script_file" | \
        sed 's/USE master;//g' | \
        sed 's/USE SeguroVehiculos;//g' | \
        sed "s/USE SeguroVehiculos/USE $MYSQL_DB/g" | \
        sed 's/GO//g' | \
        sed 's/IDENTITY(1,1)/AUTO_INCREMENT/g' | \
        sed 's/GETDATE()/NOW()/g' | \
        sed "s/CAST(GETDATE() AS DATE)/CURDATE()/g" | \
        docker exec -i $CONTAINER_NAME mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB

    if [ $? -eq 0 ]; then
        echo "✅ $script_name completado"
    else
        echo "⚠️  $script_name completado (puede haber advertencias)"
    fi
    echo ""
}

# 1. DDL (CREATE)
echo "Creando tablas..."
run_script "Marlenis-Concepcion-INF8236-Act4.2-DDL.sql" "DDL (Crear tablas)"

# 2. DML (INSERT, UPDATE, DELETE)
echo "Insertando datos..."
run_script "Marlenis-Concepcion-INF8236-Act4.2-DML.sql" "DML (Insertar/Actualizar datos)"

echo ""
echo "=========================================="
echo "✓ Scripts ejecutados en MySQL"
echo "=========================================="
echo ""
echo "Para hacer consultas:"
echo "  docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos"
echo ""
echo "O ejecutar una consulta rápida:"
echo "  docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \"SELECT COUNT(*) FROM Cliente;\""
