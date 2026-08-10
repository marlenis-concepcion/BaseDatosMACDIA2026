#!/bin/bash

# Script para ejecutar TODOS los scripts SQL en orden correcto

CONTAINER_NAME="sqlserver_uasd"
SA_PASSWORD="P@ssw0rd1234"

echo "=========================================="
echo "Ejecutando todos los scripts SQL..."
echo "=========================================="
echo ""

# Función para ejecutar un script
run_script() {
    local script_file=$1
    local script_name=$2

    if [ ! -f "$script_file" ]; then
        echo "❌ Error: No se encuentra $script_file"
        return 1
    fi

    echo "▶️  Ejecutando: $script_name"
    cat "$script_file" | docker exec -i $CONTAINER_NAME /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD

    if [ $? -eq 0 ]; then
        echo "✅ $script_name completado"
    else
        echo "❌ Error en $script_name"
        return 1
    fi
    echo ""
}

# 1. DDL (CREATE)
run_script "Marlenis-Concepcion-INF8236-Act4.2-DDL.sql" "DDL (Crear tablas)"

# 2. DML (INSERT, UPDATE, DELETE)
run_script "Marlenis-Concepcion-INF8236-Act4.2-DML.sql" "DML (Insertar/Actualizar datos)"

# 3. DQL (SELECT - Consultas)
run_script "Marlenis-Concepcion-INF8236-Act4.2-DQL.sql" "DQL (Consultas SELECT)"

echo ""
echo "=========================================="
echo "✓ TODOS los scripts ejecutados"
echo "=========================================="
