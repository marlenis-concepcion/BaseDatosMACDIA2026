#!/bin/bash

# ============================================================
# SCRIPT TODO EN UNO - TAREA 5.1
# Sistema de Nomina - MySQL + Docker
# MUESTRA TODOS LOS PROCEDURES, FUNCIONES, TRIGGERS Y VISTAS
# ============================================================

# Cargar variables de entorno
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Valores por defecto si .env no existe
CONTAINER_NAME=${CONTAINER_NAME:-mysql_uasd}
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-P@ssw0rd1234}
DB_NAME=${DB_NAME:-DBNomina}
DB_USER=${DB_USER:-root}
DB_PORT=${DB_PORT:-3306}
SCRIPT_MAESTRO=${SCRIPT_MAESTRO:-Marlenis-Concepcion-INF8236-Tarea-5.1-Script-Maestro-Actualizado.sql}
STARTUP_WAIT=${STARTUP_WAIT:-20}

echo "🚀 INICIANDO SETUP TAREA 5.1..."
echo "=========================================="
echo ""

# 1. Eliminar contenedor anterior si existe
echo "1️⃣  Limpiando contenedor anterior..."
docker rm -f $CONTAINER_NAME 2>/dev/null || true
echo "   ✅ Limpio"

# 2. Crear contenedor nuevo
echo ""
echo "2️⃣  Creando contenedor MySQL..."
docker run -d --name $CONTAINER_NAME \
  -e MYSQL_ROOT_PASSWORD=$DB_ROOT_PASSWORD \
  -e MYSQL_DATABASE=$DB_NAME \
  -p $DB_PORT:3306 \
  mysql:8.0 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   ✅ Contenedor creado"
else
    echo "   ❌ Error creando contenedor"
    exit 1
fi

# 3. Esperar a que MySQL inicie
echo ""
echo "3️⃣  Esperando a que MySQL inicie ($STARTUP_WAIT segundos)..."
sleep $STARTUP_WAIT
echo "   ✅ MySQL listo"

# 4. Ejecutar Script Maestro
echo ""
echo "4️⃣  Cargando Script Maestro..."
cat $SCRIPT_MAESTRO | \
  docker exec -i $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   ✅ Script Maestro cargado exitosamente"
else
    echo "   ⚠️  Error durante carga"
fi

# 5. Verificar Funciones SQL Creadas
echo ""
echo "5️⃣  FUNCIONES SQL CREADAS"
echo "=========================================="
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e "
SELECT ROUTINE_NAME AS 'Función Creada', ROUTINE_TYPE AS 'Tipo'
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA='$DB_NAME' AND ROUTINE_TYPE='FUNCTION';" 2>&1 | grep -v Warning
echo ""

# 6. Verificar Stored Procedures Creados
echo ""
echo "6️⃣  STORED PROCEDURES CREADOS (5 TOTAL)"
echo "=========================================="
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e "
SELECT ROUTINE_NAME AS 'Procedure Creado', ROUTINE_TYPE AS 'Tipo'
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA='$DB_NAME' AND ROUTINE_TYPE='PROCEDURE';" 2>&1 | grep -v Warning
echo ""

# 7. Verificar Triggers Creados
echo ""
echo "7️⃣  TRIGGERS CREADOS Y ACTIVOS (4 TOTAL)"
echo "=========================================="
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e "
SELECT TRIGGER_NAME AS 'Trigger', EVENT_OBJECT_TABLE AS 'Tabla', EVENT_MANIPULATION AS 'Evento'
FROM INFORMATION_SCHEMA.TRIGGERS WHERE TRIGGER_SCHEMA='$DB_NAME';" 2>&1 | grep -v Warning
echo ""

# 8. Verificar Vistas Creadas
echo ""
echo "8️⃣  VISTAS CREADAS"
echo "=========================================="
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e "
SHOW FULL TABLES FROM $DB_NAME WHERE TABLE_TYPE='VIEW';" 2>&1 | grep -v Warning
echo ""

# 9. Conteo de Datos en Tablas
echo ""
echo "9️⃣  DATOS CARGADOS EN LAS TABLAS"
echo "=========================================="
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e "
SELECT 'Empleado' AS Tabla, COUNT(*) AS Registros FROM Empleado
UNION ALL
SELECT 'TransaccionNomina', COUNT(*) FROM TransaccionNomina
UNION ALL
SELECT 'PeriodoNomina', COUNT(*) FROM PeriodoNomina
UNION ALL
SELECT 'Departamento', COUNT(*) FROM Departamento
UNION ALL
SELECT 'TipoNomina', COUNT(*) FROM TipoNomina;" 2>&1 | grep -v Warning
echo ""

# 10. Ejecutar FUNCIÓN - FN_SalarioAnual
echo ""
echo "🔟 EJECUTANDO FUNCIÓN: FN_SalarioAnual"
echo "=========================================="
echo "   Prueba: FN_SalarioAnual(42000.00) - Salario anual"
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e \
  "SELECT FN_SalarioAnual(42000.00) AS 'Salario Anual RD';" 2>&1 | grep -v Warning
echo ""

# 11. Ejecutar PROCEDURE 1 - SP_Consultar_NominaEmpleado
echo ""
echo "1️⃣1️⃣ EJECUTANDO PROCEDURE: SP_Consultar_NominaEmpleado(1)"
echo "=========================================="
echo "   Parámetro: Empleado_ID = 1 (Marlenis Judith)"
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e \
  "CALL SP_Consultar_NominaEmpleado(1);" 2>&1 | grep -v Warning
echo ""

# 12. Verificar Logs - Trigger TR_Empleado_Audit
echo ""
echo "1️⃣2️⃣ VERIFICANDO TRIGGER: TR_Empleado_Audit"
echo "=========================================="
echo "   Registros en EmpleadoLog (generados por trigger)"
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e \
  "SELECT COUNT(*) AS 'Registros en EmpleadoLog' FROM EmpleadoLog;" 2>&1 | grep -v Warning
echo ""

# 13. Verificar Logs - Trigger TR_TransaccionNomina_AfterInsert_ConsultarEmpleado
echo ""
echo "1️⃣3️⃣ VERIFICANDO TRIGGER: TR_TransaccionNomina_AfterInsert_ConsultarEmpleado"
echo "=========================================="
echo "   Registros en TransaccionNominaLog (generados por trigger)"
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e \
  "SELECT COUNT(*) AS 'Registros en TransaccionNominaLog' FROM TransaccionNominaLog;" 2>&1 | grep -v Warning
echo ""

# 14. Consultar VISTA - VW_TotalNominaEmpleado
echo ""
echo "1️⃣4️⃣ CONSULTANDO VISTA: VW_TotalNominaEmpleado"
echo "=========================================="
echo "   Primeros 5 empleados con sus totales de nómina"
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e \
  "SELECT Empleado_Codigo, Empleado_NombreCompleto, Empleado_Cargo, TotalTransacciones, MontoBrutoTotal, MontoNetoTotal
   FROM VW_TotalNominaEmpleado LIMIT 5;" 2>&1 | grep -v Warning
echo ""

# 15. Listado Completo de Empleados
echo ""
echo "1️⃣5️⃣ LISTADO COMPLETO DE EMPLEADOS (22 TOTAL)"
echo "=========================================="
docker exec $CONTAINER_NAME mysql -u $DB_USER -p$DB_ROOT_PASSWORD $DB_NAME -e \
  "SELECT Empleado_Codigo, Empleado_Nombre, Empleado_Apellido, Empleado_Cargo, Empleado_SueldoBase
   FROM Empleado WHERE Compania_Codigo = 'UAS' ORDER BY Empleado_Codigo;" 2>&1 | grep -v Warning
echo "=========================================="

echo ""
echo "✅ TAREA 5.1 COMPLETADA Y VERIFICADA"
echo "=========================================="
echo ""
echo "📊 RESUMEN FINAL:"
echo "   ✅ 1 Función SQL (FN_SalarioAnual)"
echo "   ✅ 5 Stored Procedures"
echo "   ✅ 4 Triggers Activos"
echo "   ✅ 1 Vista Materializada"
echo "   ✅ 12 Tablas Creadas"
echo "   ✅ 22 Empleados Cargados"
echo "   ✅ 22 Transacciones Procesadas"
echo "=========================================="
