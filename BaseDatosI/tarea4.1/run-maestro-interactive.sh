#!/bin/bash

# Script que ejecuta el maestro completo y abre MySQL interactivo

CONTAINER_NAME="mysql_uasd"
MYSQL_PASSWORD="P@ssw0rd1234"
MYSQL_USER="root"
MYSQL_DB="SeguroVehiculos"

echo "=========================================="
echo "EJECUTANDO SCRIPT MAESTRO + MODO INTERACTIVO"
echo "=========================================="
echo ""

# Verificar que MySQL está corriendo
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "❌ Error: MySQL no está corriendo"
    echo ""
    echo "Primero ejecuta:"
    echo "  docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0"
    echo ""
    echo "O:"
    echo "  ./docker-open-mysql.sh"
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

    echo "▶️  $script_name"

    # Adaptar SQL de SQL Server a MySQL
    cat "$script_file" | \
        sed 's/USE master;//g' | \
        sed "s/USE SeguroVehiculos/USE $MYSQL_DB/g" | \
        sed 's/GO//g' | \
        sed 's/IDENTITY(1,1)/AUTO_INCREMENT/g' | \
        sed 's/GETDATE()/NOW()/g' | \
        sed "s/CAST(GETDATE() AS DATE)/CURDATE()/g" | \
        docker exec -i $CONTAINER_NAME mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB 2>/dev/null

    if [ $? -eq 0 ]; then
        echo "   ✅ Completado"
    else
        echo "   ⚠️  Completado (con advertencias)"
    fi
}

# 1. CREATE (DDL)
echo "1️⃣  CREANDO TABLAS..."
run_script "Marlenis-Concepcion-INF8236-Act4.2-DDL.sql" "DDL"
echo ""

# 2. INSERT (DML)
echo "2️⃣  INSERTANDO DATOS..."
run_script "Marlenis-Concepcion-INF8236-Act4.2-DML.sql" "DML"
echo ""

# 3. SELECT (DQL)
echo "3️⃣  EJECUTANDO CONSULTAS..."
if [ -f "Marlenis-Concepcion-INF8236-Act4.2-DQL.sql" ]; then
    run_script "Marlenis-Concepcion-INF8236-Act4.2-DQL.sql" "DQL"
else
    echo "▶️  Ejecutando consultas básicas..."
    docker exec -i $CONTAINER_NAME mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB << EOF
SELECT COUNT(*) as 'Total de Clientes' FROM Cliente;
SELECT COUNT(*) as 'Total de Pólizas' FROM Poliza;
SELECT COUNT(*) as 'Total de Siniestros' FROM Siniestro;
SELECT Estado_Poliza, COUNT(*) as Total FROM Poliza GROUP BY Estado_Poliza;
SELECT Tipo_Siniestro, COUNT(*) as Total FROM Siniestro GROUP BY Tipo_Siniestro;
SELECT SUM(Monto) as 'Ingresos Totales' FROM Pagos;
EOF
    echo "   ✅ Consultas completadas"
fi

echo ""
echo "=========================================="
echo "✅ SCRIPT MAESTRO COMPLETADO"
echo "=========================================="
echo ""
echo "🔄 ABRIENDO MODO INTERACTIVO..."
echo "Ahora puedes escribir tus propias consultas SQL"
echo ""
echo "Ejemplos de comandos:"
echo "  SELECT * FROM Cliente;"
echo "  SELECT AVG(Pago_Monto) FROM Pago;"
echo "  SELECT * FROM Poliza WHERE Estado_Poliza = 'Activa';"
echo ""
echo "Para salir escribe: EXIT"
echo ""
echo "=========================================="
echo ""

# Abrir MySQL interactivo
docker exec -it $CONTAINER_NAME mysql -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DB
