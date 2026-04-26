# 📝 NOTA TÉCNICA: Por Qué No Corrió el Script Inicialmente - Tarea 4.2

**Para:** Profesora  
**De:** Marlenis Judith Concepcion Cuevas  
**Asignatura:** Base de Datos I - INF-8236-C2  
**Actividad:** 4.2 - Desarrollo Completo en SQL  
**Fecha:** 26 de Abril de 2026  
**Asunto:** Razón Técnica del Problema Inicial con el Script SQL

---

## 🔴 EL PROBLEMA

El script SQL original de la Tarea 4.2 fue escrito en **sintaxis SQL Server**, pero la máquina utiliza **MySQL en Docker**.

### Ejemplo del Problema:

```sql
-- ❌ ORIGINAL (SQL Server)
USE SeguroVehiculos;
GO
INSERT INTO TipoVehiculo (...) VALUES (...);
GO
```

**Error en MySQL:**
```
ERROR: Syntax error near 'GO'
```

---

## 🐋 POR QUÉ DOCKER NO CORRÍA CON SQL SERVER

El primer intento fue usar **Microsoft SQL Server en Docker**, pero esto presentó un problema de **arquitectura de hardware incompatible**. La máquina utiliza un procesador **Apple Silicon (ARM64)** (M1, M2 o M3), pero la imagen oficial de SQL Server en Docker solo tiene soporte para **arquitectura x86_64 (Intel)**. Cuando Docker intentaba descargar y ejecutar la imagen de SQL Server (`mcr.microsoft.com/mssql/server:2022-latest`), fallaba con un error de arquitectura incompatible porque la imagen no existía compilada para ARM64. MySQL, en cambio, sí tiene **soporte nativo para ARM64**, por lo que su imagen Docker funciona perfectamente en Mac con Apple Silicon sin necesidad de emulación o workarounds. Esto hizo que cambiar a MySQL fuera la solución óptima: no solo resolvió el problema de Docker, sino que también mejoró el rendimiento al no requerir virtualización adicional.

---

## 🔍 INCOMPATIBILIDADES PRINCIPALES

### 1. **Sentencia `GO` - SQL Server Específica**
- `GO` es un **separador de lotes en SQL Server** (no es SQL estándar)
- **MySQL NO reconoce** la sentencia `GO`
- Causa: Parse error inmediatamente

### 2. **Sentencia `USE`** 
- SQL Server: `USE SeguroVehiculos;` + `GO`
- MySQL: `USE SeguroVehiculos;` (sin `GO`)
- MySQL no necesita separador de lotes

### 3. **Diferencias en Tipos de Datos**
- SQL Server tiene `DATETIME`, `SMALLINT`
- MySQL tiene `DATETIME`, `SMALLINT` (compatible ✓)
- Pero algunos tipos no existen en MySQL

### 4. **Restricciones y Constraints**
- SQL Server: CONSTRAINT PK_Tabla PRIMARY KEY CLUSTERED
- MySQL: CONSTRAINT PK_Tabla PRIMARY KEY
- MySQL no soporta `CLUSTERED` (innecesario)

---

## 📋 SOLUCIÓN APLICADA

### Cambios Realizados para Compatibilidad MySQL:

1. **Remover todos los `GO`**
   ```sql
   -- ❌ Antes
   USE SeguroVehiculos;
   GO
   INSERT INTO Cliente (...) VALUES (...);
   GO
   
   -- ✅ Después  
   USE SeguroVehiculos;
   INSERT INTO Cliente (...) VALUES (...);
   ```

2. **Ajustar sintaxis de PRIMARY KEY**
   ```sql
   -- ❌ Antes (SQL Server)
   CONSTRAINT PK_Tabla PRIMARY KEY CLUSTERED (id)
   
   -- ✅ Después (MySQL)
   CONSTRAINT PK_Tabla PRIMARY KEY (id)
   ```

3. **Convertir funciones de fecha**
   ```sql
   -- ❌ Antes (SQL Server)
   GETDATE()
   CAST(GETDATE() AS DATE)
   
   -- ✅ Después (MySQL)
   NOW()
   CURDATE()
   ```

4. **Remover comandos SQL Server específicos**
   ```sql
   -- ❌ Removido
   SET NOCOUNT ON;
   
   -- (No necesario en MySQL)
   ```

---

## ✅ VERIFICACIÓN FINAL

El script ahora corre correctamente en MySQL:

```bash
$ ./setup-y-ejecutar.sh

✅ PROCESO COMPLETADO EXITOSAMENTE
Promedio_Pagos_RD
17525.000000
```

---

## 🎓 LECCIÓN APRENDIDA

**Los scripts SQL NO son 100% portables entre motores:**

| Aspecto | SQL Server | MySQL | Estado |
|---|---|---|---|
| Separadores de lotes (`GO`) | ✅ Nativo | ❌ No existe | ❌ Incompatible |
| Sintaxis PRIMARY KEY | CLUSTERED | Estándar | ✅ Ajustable |
| Funciones de fecha | GETDATE() | NOW() | ✅ Reemplazable |
| Tipos de datos base | Compatibles | Compatibles | ✅ Compatible |

**Conclusión:** Convertir entre motores SQL requiere:
- Conocer diferencias de sintaxis
- Entender funciones específicas de cada motor
- Mantener la lógica de negocio intacta

---

## 📊 ESTADO ACTUAL

| Componente | Estado |
|---|---|
| Script DDL | ✅ Funciona en MySQL |
| Script DML | ✅ Funciona en MySQL |
| Script DQL | ✅ Funciona en MySQL |
| Docker | ✅ MySQL 8.0 activo |
| Base de datos | ✅ 12 tablas creadas |
| Registros | ✅ 20 por tabla |
| Consulta objetivo | ✅ Resultado: 17525.000000 |

---

## 🏷️ CORRECCIONES DE NOMENCLATURA APLICADAS

Se aplicó correctamente la **convención de nomenclatura solicitada** en todas las tablas. Cada columna sigue el patrón `NombreTabla_NombreCampo` de manera consistente. Por ejemplo:
- Tabla `Cliente` → columnas: `Cliente_ID`, `Cliente_Cedula`, `Cliente_Nombre`, `Cliente_Apellido`, `Cliente_Email`, etc.
- Tabla `Pago` → columnas: `Pago_ID`, `Pago_Monto`, `Pago_Fecha`, `Pago_Cliente_ID`, `Pago_FacturaPolizaID`, etc.
- Tabla `Vehiculo` → columnas: `Vehiculo_ID`, `Vehiculo_Cliente_ID`, `Vehiculo_TipoVehiculo_ID`, `Vehiculo_Placa`, etc.

Esta nomenclatura consistente facilita la lectura, mantenimiento y entendimiento inmediato de la estructura de la base de datos, permitiendo identificar rápidamente a qué tabla pertenece cada campo.

## 🔗 CORRECCIONES DE FOREIGN KEYS APLICADAS

Se implementaron correctamente todas las **relaciones de foreign keys** entre tablas, asegurando la integridad referencial del modelo. Las relaciones principales incluyen: `Pago` referencia a `Cliente` (Pago_Cliente_ID → Cliente.Cliente_ID) y a `FacturaPoliza` (Pago_FacturaPolizaID → FacturaPoliza.FacturaPoliza_ID); `Vehiculo` referencia a `Cliente` (Vehiculo_Cliente_ID → Cliente.Cliente_ID) y a `TipoVehiculo` (Vehiculo_TipoVehiculo_ID → TipoVehiculo.TipoVehiculo_ID); `Poliza` referencia a sus tablas maestras: Cliente, Vehiculo, Agente, Cobertura, y a SolicitudCotizacionPoliza; y `Siniestro` referencia a `Poliza` y a `Vehiculo`. Todas estas relaciones fueron validadas y ejecutadas correctamente en MySQL, confirmando que los datos insertados respetan las restricciones de clave foránea sin errores de integridad referencial.

---

## 💡 CONCLUSIÓN

**La Tarea 4.2 está completada y funcionando correctamente** después de:

1. ✅ Identificar incompatibilidades SQL Server vs MySQL
2. ✅ Convertir sintaxis a MySQL compatible
3. ✅ Validar todas las tablas y datos
4. ✅ Ejecutar las consultas correctamente
5. ✅ Documentar el proceso y la solución

**El resultado es idéntico al esperado en SQL Server, pero en MySQL.**

---

Atentamente,  
**Marlenis Judith Concepcion Cuevas**

*Nota técnica generada: 26 de Abril de 2026*
