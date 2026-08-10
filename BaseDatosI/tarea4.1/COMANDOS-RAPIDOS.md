# ⚡ COMANDOS RÁPIDOS - Sistema de Seguro de Vehículos

## 🚀 OPCIÓN 1: SCRIPT AUTOMÁTICO (RECOMENDADO)

Simplemente ejecuta:

```bash
cd 
./setup-y-ejecutar.sh
```

Este script hace TODO automáticamente:
- ✅ Limpia contenedor anterior
- ✅ Crea MySQL en Docker
- ✅ Espera a que inicie
- ✅ Carga la base de datos completa
- ✅ Verifica los datos
- ✅ Ejecuta la consulta objetivo

---

## 🔧 OPCIÓN 2: COMANDO TODO EN UNO (COPIAR Y PEGAR)

Si prefieres un solo comando en la terminal:

```bash
docker rm -f mysql_uasd 2>/dev/null; \
docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0; \
sleep 20; \
cd ; \
cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql | \
docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos; \
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"
```

---

## 📋 OPCIÓN 3: PASO A PASO MANUAL

### 1. Limpiar contenedor anterior
```bash
docker rm -f mysql_uasd
```

### 2. Crear contenedor MySQL
```bash
docker run -d --name mysql_uasd \
  -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 \
  -e MYSQL_DATABASE=SeguroVehiculos \
  -p 3306:3306 \
  mysql:8.0
```

### 3. Esperar a que inicie
```bash
sleep 20
```

### 4. Cargar datos (desde el directorio correcto)
```bash
cd 
cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql | \
  docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

### 5. Ejecutar la consulta objetivo
```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"
```

**Resultado esperado:**
```
Promedio_Pagos_RD
17525.000000
```

---

## 🔍 VERIFICACIÓN RÁPIDA

### Ver todas las tablas
```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SHOW TABLES;"
```

### Contar registros en Cliente
```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM Cliente;"
```

### Contar registros en Pago
```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM Pago;"
```

### Ver primeros 5 clientes
```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT * FROM Cliente LIMIT 5;"
```

---

## 💻 MODO INTERACTIVO

Para escribir consultas propias en MySQL:

```bash
docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

Ejemplo de consultas que puedes ejecutar:

```sql
-- Ver todos los clientes
SELECT * FROM Cliente;

-- Total de pagos
SELECT SUM(Pago_Monto) as Total_Pagado FROM Pago;

-- Máximo y mínimo pago
SELECT MAX(Pago_Monto) as Max, MIN(Pago_Monto) as Min FROM Pago;

-- Cantidad de pólizas por cliente
SELECT Cliente_ID, COUNT(*) as Cantidad_Polizas FROM Poliza GROUP BY Cliente_ID;

-- Pagos ordenados por cantidad
SELECT Pago_ID, Pago_Monto, Pago_Metodo FROM Pago ORDER BY Pago_Monto DESC;

-- Salir
EXIT
```

---

## 🛠️ MANTENIMIENTO

### Detener MySQL
```bash
docker stop mysql_uasd
```

### Reiniciar MySQL
```bash
docker start mysql_uasd
```

### Eliminar completamente
```bash
docker rm -f mysql_uasd
```

### Ver logs de MySQL
```bash
docker logs mysql_uasd
```

### Verificar estado del contenedor
```bash
docker ps | grep mysql_uasd
```

---

## 📊 MÁS CONSULTAS ÚTILES

### Resumen de todas las tablas
```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos << 'EOF'
SELECT 'Cliente' as Tabla, COUNT(*) as Total FROM Cliente
UNION ALL
SELECT 'Agente', COUNT(*) FROM Agente
UNION ALL
SELECT 'Cobertura', COUNT(*) FROM Cobertura
UNION ALL
SELECT 'Taller', COUNT(*) FROM Taller
UNION ALL
SELECT 'TipoVehiculo', COUNT(*) FROM TipoVehiculo
UNION ALL
SELECT 'Vehiculo', COUNT(*) FROM Vehiculo
UNION ALL
SELECT 'Pago', COUNT(*) FROM Pago
UNION ALL
SELECT 'Poliza', COUNT(*) FROM Poliza
UNION ALL
SELECT 'FacturaPoliza', COUNT(*) FROM FacturaPoliza
UNION ALL
SELECT 'SolicitudCotizacionPoliza', COUNT(*) FROM SolicitudCotizacionPoliza
UNION ALL
SELECT 'Siniestro', COUNT(*) FROM Siniestro
UNION ALL
SELECT 'EvaluacionSiniestro', COUNT(*) FROM EvaluacionSiniestro;
EOF
```

### Consultas del archivo DQL
Para ejecutar todas las consultas del archivo DQL:

```bash
cd 
cat Marlenis-Concepcion-INF8236-Act4.2-DQL.sql | \
  docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

---

## ✅ CHECKLIST DE FUNCIONAMIENTO

- [ ] Docker Desktop abierto
- [ ] Script maestro cargado sin errores
- [ ] 12 tablas creadas
- [ ] Cada tabla con 20 registros
- [ ] Consulta de promedio retorna: 17525.000000
- [ ] Puedo entrar a MySQL interactivo
- [ ] Puedo ejecutar mis propias consultas

---

**Última actualización:** 26 de Abril, 2026  
**Estudiante:** Marlenis Judith Concepcion Cuevas  
**Curso:** UASD INF-8236-C2
