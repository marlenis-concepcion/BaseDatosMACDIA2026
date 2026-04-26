#!/bin/bash

# ============================================================
# SCRIPT TODO EN UNO - Crear Docker + MySQL + Cargar Datos
# ============================================================

echo "🚀 INICIANDO SETUP COMPLETO..."
echo "=========================================="
echo ""

# 1. Eliminar contenedor anterior si existe
echo "1️⃣  Limpiando contenedor anterior..."
docker rm -f mysql_uasd 2>/dev/null || true
echo "   ✅ Limpio"

# 2. Crear contenedor nuevo
echo ""
echo "2️⃣  Creando contenedor MySQL..."
docker run -d --name mysql_uasd \
  -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 \
  -e MYSQL_DATABASE=SeguroVehiculos \
  -p 3306:3306 \
  mysql:8.0 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   ✅ Contenedor creado"
else
    echo "   ❌ Error creando contenedor"
    exit 1
fi

# 3. Esperar a que MySQL inicie
echo ""
echo "3️⃣  Esperando a que MySQL inicie (20 segundos)..."
sleep 20
echo "   ✅ MySQL listo"

# 4. Ejecutar Script Maestro
echo ""
echo "4️⃣  Cargando base de datos..."
cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql | \
  docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "   ✅ Base de datos cargada"
else
    echo "   ⚠️  Error durante carga"
fi

# 5. Verificar
echo ""
echo "5️⃣  Verificando datos..."
TABLE_COUNT=$(docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='SeguroVehiculos';" 2>/dev/null | tail -1)
echo "   📊 Tablas creadas: $TABLE_COUNT"

CLIENT_COUNT=$(docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM Cliente;" 2>/dev/null | tail -1)
echo "   👥 Clientes registrados: $CLIENT_COUNT"

PAGO_COUNT=$(docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM Pago;" 2>/dev/null | tail -1)
echo "   💰 Pagos registrados: $PAGO_COUNT"

# 6. Ejecutar consulta objetivo
echo ""
echo "6️⃣  Ejecutando consulta: SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"
echo "=========================================="
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;" 2>&1 | grep -v Warning
echo "=========================================="

echo ""
echo "✅ PROCESO COMPLETADO EXITOSAMENTE"
echo ""
echo "📌 COMANDOS ÚTILES:"
echo ""
echo "   Ver todas las tablas:"
echo "   docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e 'SHOW TABLES;'"
echo ""
echo "   Abrir MySQL interactivo:"
echo "   docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos"
echo ""
echo "   Ejecutar otra consulta:"
echo "   docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e 'SELECT * FROM Cliente LIMIT 5;'"
echo ""
echo "   Detener MySQL:"
echo "   docker stop mysql_uasd"
echo ""
echo "   Reiniciar MySQL:"
echo "   docker start mysql_uasd"
echo ""
