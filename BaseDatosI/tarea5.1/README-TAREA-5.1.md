# 📊 TAREA 5.1 - Sistema de Nómina con MySQL + Docker

**UASD - Base de Datos I (INF-8236-C2)**  
**Estudiante:** Marlenis Judith Concepcion Cuevas  
**Tutora:** Mtra. Rosmery Alberto M.  
**Fecha:** 26 de Abril de 2026

---

## 🎯 Descripción del Proyecto

Sistema integral de nómina para la Universidad Autónoma de Santo Domingo (UASD), implementado en MySQL 8.0 con Docker. Incluye gestión de empleados, períodos de nómina, transacciones con cálculos de impuestos, auditoría completa y vistas analíticas.

---

## 📁 Estructura de Archivos

```
tarea5.1/
├── setup-y-ejecutar.sh                           # Script bash para ejecutar todo
├── .env.example                                  # Ejemplo de configuración (copiar a .env)
├── .gitignore                                    # Archivos a ignorar en Git
│
├── SCRIPT MAESTRO (Completo)
├── Marlenis-Concepcion-INF8236-Tarea-5.1-Script-Maestro-Actualizado.sql
│   ├── DDL (Definición de tablas)
│   ├── DML (Datos de prueba - 22 empleados, 22 transacciones)
│   ├── Funciones (1)
│   ├── Stored Procedures (5)
│   ├── Triggers (4)
│   └── Vistas (1)
│
├── ARCHIVOS DIVIDIDOS (opcional)
├── Act5.1-DDL.sql                               # Solo definiciones de tablas
├── Act5.1-DML.sql                               # Solo datos de prueba (22 empleados, 22 transacciones)
├── Act5.1-DQL.sql                               # Solo consultas de ejemplo (14 queries)
│
└── DOCUMENTACION
    ├── README-TAREA-5.1.md                     # Este archivo
    ├── INICIO-RAPIDO.md                        # Guía de 1 minuto
    └── (Otros archivos de la tarea)
```

---

## 🚀 Ejecución Rápida

### Opción 1: Script Automático (Recomendado)

```bash
cd tarea5.1
./setup-y-ejecutar.sh
```

**Resultado esperado:**
```
✅ TAREA 5.1 LISTA
📊 Tablas creadas: 12
👥 Empleados registrados: 22
```

### Opción 2: Manual (sin script)

```bash
# 1. Crear contenedor
docker run -d --name mysql_uasd \
  -e MYSQL_ROOT_PASSWORD=P@ssw0rd1234 \
  -e MYSQL_DATABASE=DBNomina \
  -p 3306:3306 \
  mysql:8.0

# 2. Esperar 20 segundos

# 3. Cargar datos
cat Marlenis-Concepcion-INF8236-Tarea-5.1-Script-Maestro-Actualizado.sql | \
  docker exec -i mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina

# 4. Verificar
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SELECT COUNT(*) FROM Empleado;"
```

---

## 📊 Estructura de Base de Datos

### Tablas Maestras (6)

| Tabla | Registros | Descripción |
|-------|-----------|------------|
| **Compania** | 1 | Información de empresa |
| **TipoPeriodoNomina** | 3 | Tipos de período (Mensual, Quincenal, Diaria) |
| **Departamento** | 6 | Departamentos de UASD |
| **Empleado** | **22** | Empleados activos |
| **TipoNomina** | 5 | Tipos de nómina (Fija, Docencia, etc.) |
| **PeriodoNomina** | **12** | Períodos mensuales (Enero-Diciembre 2026) |

### Tablas Transaccionales (1)

| Tabla | Registros | Descripción |
|-------|-----------|------------|
| **TransaccionNomina** | **22** | Transacciones de nómina procesadas |

### Tablas de Auditoría/Caché (4)

| Tabla | Descripción |
|-------|------------|
| **EmpleadoLog** | Auditoría de cambios en empleados |
| **TransaccionNominaLog** | Auditoría de cambios en transacciones |
| **TransaccionNominaHistorico** | Histórico de transacciones procesadas |
| **NominaEmpleadoConsultaCache** | Caché de consultas de nómina |

**TOTAL: 12 tablas**

---

## 🔧 Objetos Avanzados

### 1 Función SQL

**`FN_SalarioAnual(pSueldoMensual DECIMAL)`**
- Calcula el salario anual a partir del mensual
- Retorna: DECIMAL(14,2)
- Uso: `SELECT FN_SalarioAnual(42000.00);` → 504000.00

### 5 Stored Procedures

| Procedimiento | Parámetros | Descripción |
|---|---|---|
| **SP_Actualizar_TransaccionesNomina** | ID, Compañía, Código Empleado, Sueldo | Recalcula montos AFP/ARS/ISR |
| **SP_Consultar_NominaEmpleado** | ID Empleado | Retorna todas sus transacciones |
| **SP_Insertar_EmpleadoLog** | ID, Código, Nombre, Estado, Acción | Registra cambios en empleados |
| **SP_Insertar_TransaccionNominaLog** | ID, Monto, Estado, Acción | Registra cambios en transacciones |
| **SP_Insertar_TransaccionesNominaHistorico** | Múltiples campos | Guarda histórico completo |

### 4 Triggers

| Trigger | Evento | Acción |
|---|---|---|
| **TR_TransaccionNomina_AfterInsert_ConsultarEmpleado** | INSERT TransaccionNomina | Registra en log |
| **TR_Empleado_Audit** | INSERT Empleado | Registra en audit log |
| **TR_TransaccionNomina_Audit** | UPDATE TransaccionNomina | Registra actualización |
| **TR_TransaccionNomina_Historico** | UPDATE TransaccionNomina | Guarda histórico |

### 1 Vista

**`VW_TotalNominaEmpleado`**
- Resumen por empleado con cálculos totales
- Campos: ID, Código, Nombre, Cargo, Total Transacciones, Montos (Bruto/AFP/ARS/ISR/Neto)
- Actualización: Tiempo real

---

## 📊 Datos de Prueba

### Empleados (22)

6 departamentos con empleados en varios niveles:
- **ADM** (Administración): 4 empleados
- **FIN** (Finanzas): 4 empleados
- **DOC** (Docencia): 3 empleados
- **TIC** (Tecnología): 3 empleados
- **RHH** (Recursos Humanos): 2 empleados
- **OPE** (Operaciones): 2 empleados

Rango salarial: RD$28,000 - RD$250,000

### Períodos (12)

Nóminas mensuales Enero-Diciembre 2026
- Enero-Febrero: Estado **Pagado**
- Marzo-Diciembre: Estado **Abierto**

### Transacciones (22)

Nóminas procesadas:
- 5 en Enero 2026
- 5 en Febrero 2026
- 12 en Marzo 2026

---

## 🔐 Convención de Nomenclatura

### Tablas
- **PascalCase:** `Compania`, `Empleado`, `TransaccionNomina`

### Columnas
- **Patrón:** `NombreTabla_NombreCampo`
- Ejemplos:
  - `Empleado_ID` (PK de tabla Empleado)
  - `Compania_Codigo` (FK referenciando Compania)
  - `TransaccionNomina_Monto` (Campo de tabla TransaccionNomina)

### Foreign Keys
- **Nombrados según tabla referenciada** (NO según tabla que usa)
- `Empleado_ID` → referencia tabla Empleado
- `Compania_Codigo` → referencia tabla Compania

### Stored Procedures
- **Prefijo:** `SP_`
- Patrón: `SP_[Verbo]_[Objeto]`
- Ejemplos: `SP_Insertar_EmpleadoLog`, `SP_Actualizar_TransaccionesNomina`

### Triggers
- **Prefijo:** `TR_`
- Patrón: `TR_[Tabla]_[Evento]_[Acción]`
- Ejemplos: `TR_Empleado_Audit`, `TR_TransaccionNomina_Historico`

### Funciones
- **Prefijo:** `FN_`
- Patrón: `FN_[Descripción]`
- Ejemplo: `FN_SalarioAnual`

---

## 💰 Cálculos de Nómina

### Descuentos por Seguridad Social (vigentes R.D. 2026)

| Concepto | Tasa | Tope | Fórmula |
|----------|------|------|---------|
| **AFP** | 2.87% | RD$464,460 | Salario × 0.0287 (máx. RD$464,460) |
| **ARS** | 3.04% | RD$232,230 | Salario × 0.0304 (máx. RD$232,230) |
| **ISR** | Variable | - | Según tabla progresiva anual |

### Cálculo ISR Mensual

**Paso 1:** Ingreso Anual Gravado = (Bruto - AFP - ARS) × 12

**Paso 2:** ISR por rango anual:
- **≤ RD$416,220:** 0%
- **RD$416,220 - RD$624,329:** 15% sobre exceso
- **RD$624,329 - RD$867,123:** RD$31,216 + 20% sobre exceso
- **> RD$867,123:** RD$79,776 + 25% sobre exceso

**Paso 3:** ISR Mensual = ISR Anual ÷ 12

---

## 🛠️ Configuración con Variables de Entorno

### Archivo `.env`

Crear `.env` (no se sube a Git) basado en `.env.example`:

```bash
CONTAINER_NAME=mysql_uasd
DB_ROOT_PASSWORD=P@ssw0rd1234
DB_NAME=DBNomina
DB_USER=root
DB_PORT=3306
SCRIPT_MAESTRO=Marlenis-Concepcion-INF8236-Tarea-5.1-Script-Maestro-Actualizado.sql
STARTUP_WAIT=20
```

El script `setup-y-ejecutar.sh` automáticamente carga estas variables.

---

## 📋 Archivos Divididos (Optional)

Si prefiere trabajar con archivos separados:

### `Act5.1-DDL.sql` (Data Definition Language)
- Solo definiciones de 12 tablas
- Constraints, primary keys, foreign keys
- 400 líneas aprox.

### `Act5.1-DML.sql` (Data Manipulation Language)
- 22 empleados con datos realistas
- 22 transacciones de nómina
- 12 períodos, 6 departamentos, 5 tipos de nómina
- 200 líneas aprox.

### `Act5.1-DQL.sql` (Data Query Language)
- 14 consultas de ejemplo
- Análisis, reportes, auditoría
- Validación de datos
- 400 líneas aprox.

**Uso:** Ejecutar en orden: DDL → DML → DQL

---

## 🔄 Diferencia: Tarea 4.1 vs Tarea 5.1

| Aspecto | Tarea 4.1 | Tarea 5.1 |
|---------|-----------|----------|
| **Base de datos** | SeguroVehiculos | DBNomina |
| **Tablas maestras** | 4 | 6 |
| **Tablas transaccionales** | 1 | 1 |
| **Tablas de auditoría** | 3 | 4 |
| **Empleados** | 6 | **22** |
| **Procedimientos** | 5 | 5 |
| **Triggers** | 5 | 4 (sin circular) |
| **Función** | 1 | 1 |
| **Vista** | 1 | 1 |
| **Sintaxis** | MySQL nativa | MySQL nativa |
| **Rutas** | Relativas (sin /Users) | Relativas con .env |

**Lecciones Aplicadas de Tarea 4.1:**
- ✅ MySQL syntax desde el inicio (no SQL Server)
- ✅ Sin rutas absolutas (solo rutas relativas y variables de entorno)
- ✅ Nomenclatura FK correcta (según tabla referenciada)
- ✅ Archivos DDL/DML/DQL separados
- ✅ Environment variables con .gitignore
- ✅ Triggers sin circular references
- ✅ 20+ registros por tabla principal

---

## 🧪 Verificación Final

```bash
# 1. Verificar tablas
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SHOW TABLES;"

# 2. Contar empleados
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SELECT COUNT(*) FROM Empleado;"

# 3. Contar transacciones
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SELECT COUNT(*) FROM TransaccionNomina;"

# 4. Ver procedimientos
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SHOW PROCEDURE STATUS WHERE DB='DBNomina';"

# 5. Ejecutar stored procedure
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "CALL SP_Consultar_NominaEmpleado(1);"

# 6. Consultar vista
docker exec mysql_uasd mysql -u root -pP@ssw0rd1234 DBNomina -e "SELECT * FROM VW_TotalNominaEmpleado LIMIT 3;"
```

---

## 📚 Documentación Adicional

- **INICIO-RAPIDO.md** - Guía de ejecución en 1 minuto
- **Script Maestro Actualizado** - Comentarios en cada sección
- **Variables de entorno** - .env.example con todas las opciones
- **.gitignore** - Protege archivos sensibles

---

## 🎓 Notas Técnicas

1. **Docker**: MySQL 8.0 con soporte nativo ARM64 (Apple Silicon)
2. **Triggers**: No tienen circular references (MySQL limitación)
3. **Vistas**: Materializada con GROUP BY para mejor performance
4. **Auditoría**: 4 tablas log tracking cambios en tiempo real
5. **ISR**: Cálculos con referencias vigentes R.D. 2026

---

## ✅ Estado Actual

| Componente | Estado | Detalles |
|-----------|--------|---------|
| **Tablas DDL** | ✅ | 12 tablas, 11 con datos |
| **Datos DML** | ✅ | 22 empleados, 22 transacciones |
| **Stored Procedures** | ✅ | 5 procedimientos funcionales |
| **Funciones** | ✅ | 1 función FN_SalarioAnual |
| **Triggers** | ✅ | 4 triggers activos |
| **Vistas** | ✅ | 1 vista materializada |
| **Script Bash** | ✅ | setup-y-ejecutar.sh con env vars |
| **Documentación** | ✅ | Completa y dividida |
| **Docker** | ✅ | MySQL 8.0 ARM64 |
| **Nomenclatura** | ✅ | FK según tabla referenciada |

---

## 🚀 Próximos Pasos (Opcionales)

1. Agregar índices por performance
2. Crear vistas materializadas con triggers
3. Implementar particionamiento temporal
4. Agregar más tipos de reportes
5. Crear panel de dashboard

---

**Última actualización:** 26 de Abril de 2026  
**Versión:** 1.0 (Completa)  
**Autor:** Marlenis Judith Concepcion Cuevas
