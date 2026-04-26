# 📚 Sistema MySQL + Docker para UASD - Base de Datos

**Estado:** ✅ 100% Funcional  
**Última prueba:** 26 de Abril, 2026  
**Resultado obtenido:** Promedio_Pagos_RD = **17525.000000**

---

## 📁 Archivos en Esta Carpeta

### 🚀 PARA EMPEZAR (Lee estos primero)

1. **INICIO-RAPIDO.md** ⭐ 
   - Lo más corto y directo
   - Comando para ejecutar ahora mismo
   - 30 segundos de lectura

2. **GUIA-COMPLETA-DOCKER-MYSQL.md**
   - Documentación completa y profesional
   - 3 métodos diferentes de ejecución
   - Troubleshooting y ejemplos
   - 📍 **Úsalo para referencia en proyectos 5.1 y Final**

3. **TEMPLATE-PARA-PROYECTOS.md**
   - Cómo adaptar para proyecto 5.1
   - Cómo adaptar para proyecto Final
   - Cambios necesarios en scripts

### 🛠️ SCRIPTS EJECUTABLES

4. **setup-y-ejecutar.sh** ⭐
   - Script automático (RECOMENDADO)
   - Hace todo en 1 comando
   - Solo ejecuta: `./setup-y-ejecutar.sh`

5. **run-all-mysql.sh**
   - Alternativa más simple
   - Requiere que el contenedor ya esté creado

6. **run-maestro-interactive.sh**
   - Abre modo interactivo después de cargar datos
   - Para explorar la BD manualmente

### 📖 DOCUMENTACIÓN

7. **COMANDOS-RAPIDOS.md**
   - Referencia de comandos útiles
   - Consultas ejemplo
   - Mantenimiento del contenedor

8. **GUIA-CONSULTA-COMPLETA.md**
   - Guía paso a paso original
   - Verificación de Docker
   - Solución de problemas

### 💾 ARCHIVOS SQL

9. **Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql**
   - Script maestro completo ⭐
   - Contiene: DDL + DML
   - 12 tablas, 20 registros cada una

10. **Marlenis-Concepcion-INF8236-Act4.2-DDL.sql**
    - Definición de tablas
    - Standalone (si necesitas solo crear estructura)

11. **Marlenis-Concepcion-INF8236-Act4.2-DML.sql**
    - Inserción de datos
    - Standalone (si necesitas solo insertar datos)

12. **Marlenis-Concepcion-INF8236-Act4.2-DQL.sql**
    - Consultas SELECT para análisis
    - Ejemplos de queries complejas

---

## ⚡ Inicio Rápido

### Opción A: Ejecutar Ahora (30 segundos)

```bash
cd 
./setup-y-ejecutar.sh
```

### Opción B: Leer Primero (2 minutos)

```bash
# Lee el inicio rápido
cat INICIO-RAPIDO.md

# O lee la guía completa
cat GUIA-COMPLETA-DOCKER-MYSQL.md
```

---

## 🎯 Qué Obtendrás

```
✅ Base de datos: SeguroVehiculos
✅ 12 tablas creadas
✅ 20 registros en cada tabla
✅ Consulta objetivo: SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;
✅ Resultado: 17525.000000
```

---

## 📋 Estructura de Datos

### Tablas Creadas

1. **TipoVehiculo** - Tipos de vehículos (20 tipos)
2. **Cliente** - Clientes asegurados (20 clientes)
3. **Agente** - Agentes de seguros (20 agentes)
4. **Cobertura** - Tipos de cobertura (20 coberturas)
5. **Taller** - Talleres automotrices (20 talleres)
6. **Vehiculo** - Vehículos asegurados (20 vehículos)
7. **SolicitudCotizacionPoliza** - Solicitudes (20 registros)
8. **Poliza** - Pólizas activas (20 pólizas)
9. **FacturaPoliza** - Facturas de pólizas (20 facturas)
10. **Pago** - Pagos realizados (20 pagos) ← Aquí está el promedio
11. **Siniestro** - Siniestros reportados (20 siniestros)
12. **EvaluacionSiniestro** - Evaluaciones (20 evaluaciones)

---

## 🚀 Para Proyecto 5.1 (Cuando empieces)

1. **Copia estos 2 archivos a tu carpeta:**
   ```bash
   cp setup-y-ejecutar.sh ~/Documents/UASD/BaseDatosMACDIA2026/proyecto5.1/
   cp GUIA-COMPLETA-DOCKER-MYSQL.md ~/Documents/UASD/BaseDatosMACDIA2026/proyecto5.1/
   ```

2. **Edita setup-y-ejecutar.sh** (cambiar nombre del Script Maestro)

3. **Ejecuta:**
   ```bash
   ./setup-y-ejecutar.sh
   ```

Ver **TEMPLATE-PARA-PROYECTOS.md** para instrucciones detalladas.

---

## 🚀 Para Proyecto Final

Mismo proceso que Proyecto 5.1:

1. Copia archivos
2. Edita nombres de archivo SQL
3. Ejecuta setup-y-ejecutar.sh

---

## 🔧 Requisitos

- ✅ Docker Desktop instalado
- ✅ Mac con Apple Silicon (ARM64) compatible
- ✅ Terminal/Bash
- ✅ Los archivos SQL en la misma carpeta

---

## 💡 Comandos Clave

```bash
# Ejecutar todo automáticamente
./setup-y-ejecutar.sh

# Ver todas las tablas
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SHOW TABLES;"

# Entrar a MySQL interactivo
docker exec -it mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos

# Ejecutar la consulta objetivo
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT AVG(Pago_Monto) AS Promedio_Pagos_RD FROM Pago;"
```

Ver **COMANDOS-RAPIDOS.md** para más comandos.

---

## 📞 Si Algo No Funciona

1. **Lee:** GUIA-COMPLETA-DOCKER-MYSQL.md → Sección "Solución de Problemas"
2. **Limpia y reintenta:** 
   ```bash
   docker rm -f mysql_uasd
   ./setup-y-ejecutar.sh
   ```
3. **Verifica Docker:** `docker ps` (debe mostrar algo)

---

## 📚 Referencias

- **Documentación MySQL:** https://dev.mysql.com/doc/
- **Docker Documentation:** https://docs.docker.com/
- **MySQL en Docker Hub:** https://hub.docker.com/_/mysql

---

## ✅ Verificación Rápida

Para confirmar que todo funciona:

```bash
# 1. Ver si Docker está corriendo
docker ps

# 2. Ver si MySQL_UASD existe
docker ps | grep mysql_uasd

# 3. Ejecutar la consulta objetivo
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 SeguroVehiculos -e "SELECT AVG(Pago_Monto) FROM Pago;"

# Resultado esperado: 17525.000000
```

---

## 🎓 Conclusión

Este es un **sistema completo, reproducible y profesional** para trabajar con bases de datos MySQL en tus proyectos de UASD.

**Características:**
- ✅ Compatible con Mac Apple Silicon
- ✅ No requiere instalar SQL Server
- ✅ Automático y fácil de usar
- ✅ Reutilizable en todos tus proyectos
- ✅ Documentado completamente

**Próximos pasos:**
1. Ejecuta `./setup-y-ejecutar.sh` ahora
2. Verifica el resultado
3. Copia los scripts a proyecto 5.1 cuando lo empieces
4. Adapta para proyecto Final

---

## 📧 Información del Autor

**Estudiante:** Marlenis Judith Concepcion Cuevas  
**Carné:** INF-8236-C2  
**Universidad:** UASD  
**Fecha:** 26 de Abril, 2026

**Estado:** ✅ Completamente funcional y validado

---

**¡Listo para usar! 🚀**
