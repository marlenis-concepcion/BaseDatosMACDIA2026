# 📚 GUÍA COMPLETA: MySQL + Docker para Proyectos UASD

**Autor:** Marlenis Judith Concepcion Cuevas  
**Curso:** UASD INF-8236-C2  
**Vigencia:** Proyectos 4.2, 5.1 y Final  
**Última actualización:** 26 de Abril, 2026

---

## 📋 Tabla de Contenidos

1. [Visión General](#visión-general)
2. [Requisitos Previos](#requisitos-previos)
3. [Método 1: Script Automático](#método-1-script-automático)
4. [Método 2: Comando Todo en Uno](#método-2-comando-todo-en-uno)
5. [Método 3: Paso a Paso Manual](#método-3-paso-a-paso-manual)
6. [Estructura del Script Maestro](#estructura-del-script-maestro)
7. [Comandos Útiles](#comandos-útiles)
8. [Modo Interactivo MySQL](#modo-interactivo-mysql)
9. [Solución de Problemas](#solución-de-problemas)
10. [Consultas Ejemplo](#consultas-ejemplo)

---

## 🎯 Visión General

Este sistema permite ejecutar MySQL en Docker (sin necesidad de instalar SQL Server) compatible con Mac Apple Silicon.

**Componentes principales:**
- 🐋 Docker (contiene MySQL 8.0)
- 🗄️ Base de datos: SeguroVehiculos
- 📊 12 tablas con 20 registros cada una
- 🔐 Usuario: root | Contraseña: P@ssw0rd1234

**Resultado final esperado:**
```
Promedio_Pagos_RD
17525.000000
```

---

## ✅ Requisitos Previos

### 1. Docker Desktop instalado

```bash
# Verificar si está instalado
docker --version
```

**Si dice "command not found":**
- Descargar: https://www.docker.com/products/docker-desktop
- Instalar y reiniciar la computadora

### 2. Archivos en la carpeta tarea4.1

Necesitas estos archivos en `/`:

- ✅ `Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql` (DDL + DML)
- ✅ `setup-y-ejecutar.sh` (Script automático)
- ✅ `Marlenis-Concepcion-INF8236-Act4.2-DQL.sql` (Consultas, opcional)

---

## 🚀 Método 1: Script Automático (RECOMENDADO)

**Lo más fácil y rápido.**

### Paso 1: Abrir Terminal

### Paso 2: Navegar a la carpeta

```bash
cd 
```

### Paso 3: Ejecutar el script

```bash
./setup-y-ejecutar.sh
```

### Resultado esperado

```
🚀 INICIANDO SETUP COMPLETO...
==========================================

1️⃣  Limpiando contenedor anterior...
   ✅ Limpio

2️⃣  Creando contenedor MySQL...
   ✅ Contenedor creado

3️⃣  Esperando a que MySQL inicie (20 segundos)...
   ✅ MySQL listo

4️⃣  Cargando base de datos...
   ✅ Base de datos cargada

5️⃣  Verificando datos...
   📊 Tablas creadas: 12
   👥 Clientes registrados: 20
   💰 Pagos registrados: 20

6️⃣  Ejecutando consulta: SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;
==========================================
Promedio_Pagos_RD
17525.000000
==========================================

✅ PROCESO COMPLETADO EXITOSAMENTE
```

---

## 💻 Método 2: Comando Todo en Uno

**Si prefieres copiar y pegar un solo comando.**

```bash
docker rm -f mysql_uasd 2>/dev/null; \
docker run -d --name mysql_uasd \
  -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 \
  -e MYSQL_DATABASE=SeguroVehiculos \
  -p 3306:3306 \
  mysql:8.0; \
sleep 20; \
cd ; \
cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql | \
docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos; \
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
"SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"
```

**⚠️ Importante:** Este comando:
1. Elimina el contenedor anterior (si existe)
2. Crea uno nuevo
3. Espera 20 segundos
4. Carga todos los datos
5. Ejecuta la consulta objetivo

---

## 📝 Método 3: Paso a Paso Manual

### Paso 1: Limpiar contenedor anterior

```bash
docker rm -f mysql_uasd
```

**Resultado esperado:**
```
mysql_uasd
```
(Si no existe, dirá "Error response from daemon")

### Paso 2: Crear contenedor MySQL

```bash
docker run -d --name mysql_uasd \
  -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 \
  -e MYSQL_DATABASE=SeguroVehiculos \
  -p 3306:3306 \
  mysql:8.0
```

**Resultado esperado:**
```
[ID del contenedor - hash largo]
```

### Paso 3: Esperar a que MySQL inicie

```bash
sleep 20
```

### Paso 4: Cambiar a directorio del proyecto

```bash
cd 
```

### Paso 5: Cargar el Script Maestro

```bash
cat Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql | \
  docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

**Nota:** No hay salida visible (es normal)

### Paso 6: Ejecutar la consulta objetivo

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

## 🔧 Estructura del Script Maestro

El archivo `Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql` contiene:

### Sección 1: Crear Base de Datos y Tablas (DDL)

```sql
CREATE DATABASE IF NOT EXISTS SeguroVehiculos;
USE SeguroVehiculos;

CREATE TABLE TipoVehiculo (
    TipoVehiculo_ID INT AUTO_INCREMENT NOT NULL,
    TipoVehiculo_Descripcion VARCHAR(100) NOT NULL,
    ...
);

-- 11 tablas más...
```

**Tablas creadas:**
1. TipoVehiculo
2. Cliente
3. Agente
4. Cobertura
5. Taller
6. Vehiculo
7. SolicitudCotizacionPoliza
8. Poliza
9. FacturaPoliza
10. Pago
11. Siniestro
12. EvaluacionSiniestro

### Sección 2: Insertar Datos (DML)

```sql
INSERT INTO TipoVehiculo (TipoVehiculo_Descripcion, TipoVehiculo_TarifaBase) VALUES
('Automovil Sedan', 5000.00),
('SUV Compacta', 7000.00),
-- ... 18 registros más
;

INSERT INTO Cliente (Cliente_Cedula, Cliente_Nombre, ...) VALUES
('001-1000001-1','Jose Manuel','Martinez Perez', ...),
-- ... 19 registros más
;

-- Inserts para las 12 tablas
```

**Cada tabla recibe 20 registros.**

---

## 📊 Comandos Útiles

### Ver todas las tablas

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SHOW TABLES;"
```

**Resultado:**
```
Tables_in_SeguroVehiculos
Agente
Cliente
Cobertura
EvaluacionSiniestro
FacturaPoliza
Pago
Poliza
Siniestro
SolicitudCotizacionPoliza
Taller
TipoVehiculo
Vehiculo
```

### Contar registros en una tabla

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT COUNT(*) as Total FROM Cliente;"
```

### Ver estructura de una tabla

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "DESCRIBE Cliente;"
```

### Ver los primeros N registros

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT * FROM Cliente LIMIT 5;"
```

### Crear un backup de la BD

```bash
docker exec mysql_uasd mysqldump -u root -pP@ssw0rd1234 SeguroVehiculos > backup.sql
```

### Restaurar desde backup

```bash
cat backup.sql | docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

---

## 🖥️ Modo Interactivo MySQL

Para escribir consultas propias y explorar:

```bash
docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos
```

**Verás:**
```
MySQL [SeguroVehiculos]>
```

### Ejemplos de comandos en modo interactivo

```sql
-- Ver todos los clientes
SELECT * FROM Cliente;

-- Ver clientes de una ciudad
SELECT * FROM Cliente WHERE Cliente_Ciudad = 'Santo Domingo';

-- Total de pagos
SELECT SUM(Pago_Monto) as Total_Pagado FROM Pago;

-- Máximo y mínimo pago
SELECT MAX(Pago_Monto) as Maximo, MIN(Pago_Monto) as Minimo FROM Pago;

-- Cantidad de pólizas por cliente
SELECT 
  Cliente_ID,
  COUNT(*) as Cantidad_Polizas 
FROM Poliza 
GROUP BY Cliente_ID;

-- Pagos ordenados por cantidad (mayor a menor)
SELECT Pago_ID, Pago_Monto, Pago_Metodo 
FROM Pago 
ORDER BY Pago_Monto DESC;

-- Clientes con pago mayor al promedio
SELECT DISTINCT
  c.Cliente_Nombre,
  c.Cliente_Apellido,
  p.Pago_Monto
FROM Cliente c
INNER JOIN Pago p ON p.Pago_Cliente_ID = c.Cliente_ID
WHERE p.Pago_Monto > (SELECT AVG(Pago_Monto) FROM Pago)
ORDER BY p.Pago_Monto DESC;

-- Salir de MySQL
EXIT
```

---

## 🛠️ Gestión del Contenedor

### Detener MySQL

```bash
docker stop mysql_uasd
```

### Reiniciar MySQL

```bash
docker start mysql_uasd
```

### Verificar estado

```bash
docker ps | grep mysql_uasd
```

### Ver logs

```bash
docker logs mysql_uasd
```

### Eliminar completamente

```bash
docker rm -f mysql_uasd
```

---

## 🆘 Solución de Problemas

### ❌ "docker: command not found"

**Solución:** Docker no está instalado
1. Descarga Docker Desktop: https://www.docker.com/products/docker-desktop
2. Instala y reinicia tu Mac
3. Intenta nuevamente

### ❌ "Table 'SeguroVehiculos.Cliente' doesn't exist"

**Solución:** El Script Maestro no cargó correctamente

**Opción 1:** Limpiar y reintentar
```bash
docker rm -f mysql_uasd
./setup-y-ejecutar.sh
```

**Opción 2:** Verificar que estés en el directorio correcto
```bash
cd 
ls -la Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql
```

### ❌ "Port 3306 already in use"

**Solución:** Hay otro MySQL corriendo. Elimina el anterior
```bash
docker rm -f mysql_uasd
docker run -d --name mysql_uasd -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 -e MYSQL_DATABASE=SeguroVehiculos -p 3306:3306 mysql:8.0
sleep 20
```

### ❌ "Permission denied" en setup-y-ejecutar.sh

**Solución:** El script no es ejecutable
```bash
chmod +x setup-y-ejecutar.sh
./setup-y-ejecutar.sh
```

### ❌ "mysql: [Warning] Using a password on the command line interface can be insecure"

**Respuesta:** Es solo una advertencia, no es un error. El sistema sigue funcionando normalmente.

### ⚠️ Consulta devuelve filas vacías

**Posibles causas:**
- La tabla no tiene registros (verificar con `SELECT COUNT(*) FROM tabla_nombre;`)
- La tabla no existe (verificar con `SHOW TABLES;`)
- Hay un error en la sintaxis de la consulta

---

## 📋 Consultas Ejemplo

### Consulta 1: Promedio de pagos (OBJETIVO)

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"
```

**Resultado:**
```
Promedio_Pagos_RD
17525.000000
```

### Consulta 2: Total de clientes

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT COUNT(*) as Total_Clientes FROM Cliente;"
```

### Consulta 3: Suma de todos los pagos

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT SUM(Pago_Monto) as Total_Pagado FROM Pago;"
```

### Consulta 4: Pago máximo y mínimo

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT MAX(Pago_Monto) as Maximo, MIN(Pago_Monto) as Minimo FROM Pago;"
```

### Consulta 5: Clientes por ciudad

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT Cliente_Ciudad, COUNT(*) as Total FROM Cliente GROUP BY Cliente_Ciudad;"
```

### Consulta 6: Polizas activas

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT COUNT(*) as Polizas_Activas FROM Poliza WHERE Poliza_Estatus = 'Activa';"
```

### Consulta 7: Vehículos con mayor valor asegurado

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e \
  "SELECT Vehiculo_Marca, Vehiculo_Modelo, Vehiculo_ValorAsegurado 
   FROM Vehiculo 
   ORDER BY Vehiculo_ValorAsegurado DESC LIMIT 5;"
```

### Consulta 8: JOIN - Clientes y sus pagos

```bash
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos << 'EOF'
SELECT 
  c.Cliente_Nombre,
  c.Cliente_Apellido,
  p.Pago_Monto,
  p.Pago_Metodo
FROM Cliente c
INNER JOIN Pago p ON p.Pago_Cliente_ID = c.Cliente_ID
ORDER BY p.Pago_Monto DESC;
EOF
```

---

## 📁 Estructura de Carpetas

```
<tu-directorio-proyecto>/BaseDatos-UASD/
├── tarea4.1/
│   ├── Marlenis-Concepcion-INF8236-Act4.2-DDL.sql
│   ├── Marlenis-Concepcion-INF8236-Act4.2-DML.sql
│   ├── Marlenis-Concepcion-INF8236-Act4.2-DQL.sql
│   ├── Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql ⭐
│   ├── setup-y-ejecutar.sh ⭐
│   ├── run-all-mysql.sh
│   ├── COMANDOS-RAPIDOS.md
│   ├── GUIA-CONSULTA-COMPLETA.md
│   ├── GUIA-COMPLETA-DOCKER-MYSQL.md (ESTE ARCHIVO)
│   └── ... otros archivos ...
│
├── proyecto5.1/
│   └── (Usar los scripts de tarea4.1)
│
└── proyecto_final/
    └── (Usar los scripts de tarea4.1)
```

---

## 🔄 Reutilización en Proyectos 5.1 y Final

### Para Proyecto 5.1

1. **Copia los archivos necesarios:**
   ```bash
   cp tarea4.1/setup-y-ejecutar.sh proyecto5.1/
   cp tarea4.1/GUIA-COMPLETA-DOCKER-MYSQL.md proyecto5.1/
   ```

2. **Modifica según sea necesario:**
   - Si tienes un Script Maestro nuevo: `cp mi-script-maestro.sql proyecto5.1/`
   - Actualiza los nombres de archivo en `setup-y-ejecutar.sh` si es necesario

3. **Ejecuta desde proyecto5.1:**
   ```bash
   cd proyecto5.1
   ./setup-y-ejecutar.sh
   ```

### Para Proyecto Final

1. **Sigue el mismo proceso que Proyecto 5.1:**
   ```bash
   cp tarea4.1/setup-y-ejecutar.sh proyecto_final/
   cp tarea4.1/GUIA-COMPLETA-DOCKER-MYSQL.md proyecto_final/
   ```

2. **Personaliza según tus necesidades:**
   - Reemplaza el Script Maestro
   - Modifica la consulta objetivo si es diferente
   - Actualiza comentarios en el script

---

## ✅ Checklist de Funcionamiento

- [ ] Docker Desktop instalado y abierto
- [ ] Archivos en la carpeta correcta
- [ ] Ejecuté el script sin errores
- [ ] Se crearon 12 tablas
- [ ] Cada tabla tiene 20 registros
- [ ] Consulta objetivo retorna: 17525.000000
- [ ] Puedo entrar a MySQL interactivo
- [ ] Puedo ejecutar mis propias consultas

---

## 📞 Referencia Rápida

| Tarea | Comando |
|-------|---------|
| Ejecutar todo | `./setup-y-ejecutar.sh` |
| Ver tablas | `docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SHOW TABLES;"` |
| Contar registros | `docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT COUNT(*) FROM tabla_nombre;"` |
| Modo interactivo | `docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos` |
| Detener MySQL | `docker stop mysql_uasd` |
| Reiniciar MySQL | `docker start mysql_uasd` |
| Consulta objetivo | `docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"` |

---

## 🎓 Conclusión

Este sistema proporciona una forma consistente, reproducible y confiable de trabajar con MySQL en Mac durante todos tus proyectos de Base de Datos en UASD.

**Ventajas:**
- ✅ No requiere instalar SQL Server
- ✅ Compatible con Mac Apple Silicon
- ✅ Reutilizable en múltiples proyectos
- ✅ Fácil de automatizar
- ✅ Scripts reproducibles

**Próximos pasos:**
1. Usa `setup-y-ejecutar.sh` para proyectos 5.1 y Final
2. Adapta el Script Maestro según tus necesidades
3. Documenta tus consultas SQL
4. Mantén backups de tus datos importantes

---

**Última actualización:** 26 de Abril, 2026  
**Estudiante:** Marlenis Judith Concepcion Cuevas  
**Curso:** UASD INF-8236-C2  
**Validado:** ✅ Funcionando 100%
