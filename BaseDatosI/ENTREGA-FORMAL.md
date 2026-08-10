# 📋 ENTREGA FORMAL - TAREAS 4.1 Y 5.1
## Base de Datos I (INF-8236-C2) - UASD

---

## 👤 INFORMACIÓN DEL ESTUDIANTE

**Estudiante:** Marlenis Judith Concepcion Cuevas  
**Asignatura:** Base de Datos I - INF-8236-C2  
**Tutora:** Mtra. Rosmery Alberto M.  
**Período Académico:** 2026  
**Fecha de Entrega:** 26 de Abril de 2026  
**Repositorio:** https://github.com/marlenis-concepcion/BaseDatosMACDIA2026

---

## 📊 DESCRIPCIÓN GENERAL DEL PROYECTO

Este proyecto completa satisfactoriamente las Tareas 4.1 y 5.1 de la asignatura Base de Datos I, implementando dos sistemas integrales de gestión de bases de datos en MySQL:

1. **Tarea 4.1:** Sistema de Seguro de Vehículos (SeguroVehiculos)
2. **Tarea 5.1:** Sistema de Nómina (DBNomina)

Ambos sistemas están completamente funcionales, automatizados y documentados, listos para producción con Docker y MySQL 8.0.

---

## 🎯 TAREA 4.1 - SISTEMA DE SEGURO DE VEHÍCULOS

### Descripción
Sistema integral para la gestión de seguros vehiculares con 12 tablas maestras y transaccionales, incluyendo gestión de compañías, vehículos, clientes, pólizas y siniestros.

### Componentes Entregados

#### 📁 Archivos SQL
- **Script Maestro Actualizado** (30 KB): Combinación de DDL + DML + DQL en sintaxis MySQL nativa
- **Act4.2-DDL.sql**: Definición de 12 tablas con constraints y foreign keys
- **Act4.2-DML.sql**: 20+ registros de prueba por tabla (datos realistas de seguros)
- **Act4.2-DQL.sql**: 12 consultas de análisis, reportes y auditoría

#### 📁 Automatización
- **setup-y-ejecutar.sh**: Script bash automático que:
  - Limpia contenedores anteriores
  - Crea contenedor MySQL 8.0 en Docker
  - Carga base de datos completa
  - Verifica integridad de datos
  - Ejecuta consulta objetivo
  - Tiempo total: ~50 segundos

#### 📁 Documentación
- **README.md**: Guía de proyecto completa
- **GUIA-COMPLETA-DOCKER-MYSQL.md**: Manual profesional con 3 métodos de ejecución
- **TEMPLATE-PARA-PROYECTOS.md**: Plantilla para adaptar a Tarea 5.1 y Proyecto Final
- **INICIO-RAPIDO.md**: Guía de 30 segundos para ejecutar
- **COMANDOS-RAPIDOS.md**: Referencia de comandos MySQL y Docker
- **NOTA-POR-QUE-NO-CORRIO.md**: Documento técnico explicando problemas iniciales

### Estructura de Base de Datos

**12 Tablas Totales:**
- Tablas Maestras: Compania, TipoVehiculo, Cliente, Agente, Cobertura, Taller (6)
- Tablas Transaccionales: Vehiculo, SolicitudCotizacionPoliza, Poliza, FacturaPoliza, Pago, Siniestro, EvaluacionSiniestro (7)

**Datos de Prueba:**
- 20+ registros por tabla
- Relaciones intactas (foreign keys)
- Nomenclatura consistente: `NombreTabla_NombreCampo`

### Resultado Clave
```
Promedio_Pagos_RD = 17,525.00 RD
```

### Problemas Resueltos
1. **Incompatibilidad de Motor BD**: SQL Server sintaxis → MySQL nativa
2. **Arquitectura de Hardware**: SQL Server no soporta ARM64 (Apple Silicon)
3. **Sintaxis Específica**: GO statements, IDENTITY, GETDATE() → MySQL equivalentes
4. **Nomenclatura de FK**: Corrección para usar nombre de tabla referenciada
5. **Rutas Absolutas**: Eliminadas todas las referencias a rutas locales del sistema

---

## 🎯 TAREA 5.1 - SISTEMA DE NÓMINA

### Descripción
Sistema completo de gestión de nóminas para la Universidad Autónoma de Santo Domingo (UASD), con cálculos automáticos de impuestos (AFP, ARS, ISR), procedimientos almacenados, triggers de auditoría y vistas analíticas.

### Componentes Entregados

#### 📁 Archivos SQL
- **Script Maestro Actualizado** (31 KB): Completo con DDL + DML + Funciones + Procedures + Triggers + Vistas
- **Act5.1-DDL.sql**: Definición de 12 tablas con constraints
- **Act5.1-DML.sql**: 22 empleados, 22 transacciones, 12 períodos mensuales
- **Act5.1-DQL.sql**: 14 consultas de análisis y reportes de nómina

#### 📁 Objetos Avanzados (11 Total)

**1 Función SQL**
- `FN_SalarioAnual`: Calcula salario anual a partir del mensual

**5 Stored Procedures**
1. `SP_Actualizar_TransaccionesNomina`: Calcula AFP, ARS, ISR automáticamente
2. `SP_Consultar_NominaEmpleado`: Retorna transacciones de un empleado
3. `SP_Insertar_EmpleadoLog`: Auditoría de cambios en empleados
4. `SP_Insertar_TransaccionNominaLog`: Auditoría de cambios en transacciones
5. `SP_Insertar_TransaccionesNominaHistorico`: Almacena histórico completo

**4 Triggers Activos**
1. `TR_TransaccionNomina_AfterInsert_ConsultarEmpleado`: Registra en log de transacciones
2. `TR_Empleado_Audit`: Audita inserciones de empleados
3. `TR_TransaccionNomina_Audit`: Audita actualizaciones de transacciones
4. `TR_TransaccionNomina_Historico`: Guarda histórico de cambios

**1 Vista Materializada**
- `VW_TotalNominaEmpleado`: Resumen con totales por empleado (estado real)

#### 📁 Automatización
- **setup-y-ejecutar.sh**: Script con **15 pasos enumerados** que:
  1. Limpia contenedor anterior
  2. Crea contenedor MySQL
  3. Espera a que MySQL inicie
  4. Carga Script Maestro
  5. Muestra funciones creadas
  6. Muestra procedures creados
  7. Muestra triggers activos
  8. Muestra vistas creadas
  9. Verifica datos en tablas
  10. Ejecuta función FN_SalarioAnual
  11. Ejecuta procedure SP_Consultar_NominaEmpleado
  12. Verifica trigger TR_Empleado_Audit
  13. Verifica trigger TR_TransaccionNomina_AfterInsert_ConsultarEmpleado
  14. Consulta vista VW_TotalNominaEmpleado
  15. Muestra listado de 22 empleados

#### 📁 Configuración
- **.env.example**: Variables de entorno (sin credenciales en git)
- **.gitignore**: Protege archivos sensibles

#### 📁 Documentación
- **README-TAREA-5.1.md**: Guía profesional (11 KB)
- **VERIFICACION-FINAL-TODOS-OBJETOS.md**: Reporte de verificación completo
- **INICIO-RAPIDO.md**: Guía de ejecución en 1 minuto

### Estructura de Base de Datos

**12 Tablas Totales:**
- Maestras: Compania, TipoPeriodoNomina, Departamento, Empleado, TipoNomina, PeriodoNomina (6)
- Transaccionales: TransaccionNomina (1)
- Auditoría: EmpleadoLog, TransaccionNominaLog, TransaccionNominaHistorico, NominaEmpleadoConsultaCache (4)

**Datos de Prueba:**
- **22 Empleados** con datos realistas (6 departamentos)
- **22 Transacciones** de nómina procesadas
- **12 Períodos** mensuales (Enero-Diciembre 2026)
- Rango salarial: RD$28,000 - RD$250,000

### Cálculos de Nómina Implementados
Vigentes según Resoluciones de R.D. 2026:
- **AFP (Fondo de Pensiones)**: 2.87% (tope RD$464,460)
- **ARS (Seguro de Salud)**: 3.04% (tope RD$232,230)
- **ISR (Impuesto Sobre Renta)**: Escala progresiva anual

### Ejemplo de Cálculo
Para empleado con sueldo RD$42,000 mensual:
```
Salario Base:        RD$42,000.00
AFP (2.87%):        -RD$1,204.00
ARS (3.04%):        -RD$1,276.80
ISR (progresivo):    -RD$0.00 (año < RD$416,220)
─────────────────
Salario Neto:       RD$39,519.20
```

---

## 🔄 LECCIONES APLICADAS DE TAREA 4.1 A 5.1

En la Tarea 5.1 se implementaron exitosamente las lecciones aprendidas en Tarea 4.1:

| Aspecto | Tarea 4.1 (Problema) | Tarea 5.1 (Solución) |
|--------|-------------------|------------------|
| Sintaxis SQL | SQL Server → Conversión | MySQL nativa desde inicio ✅ |
| Rutas Absolutas | Rutas locales presentes | Rutas relativas + .env ✅ |
| Nomenclatura FK | Inconsistente | Por tabla referenciada ✅ |
| Archivos SQL | Combinados | Separados (DDL/DML/DQL) ✅ |
| Datos de Prueba | 6-20 registros | 20+ registros garantizados ✅ |
| Triggers | Con referencias circulares | Sin circular references ✅ |
| Configuración | Hardcoded | Variables de entorno ✅ |

---

## 📦 ESTRUCTURA DE ENTREGA

```
BaseDatosMACDIA2026/
├── tarea4.1/
│   ├── setup-y-ejecutar.sh                 (Script automático)
│   ├── Marlenis-Concepcion-INF8236-Act4.2-Script-Maestro-Actualizado.sql
│   ├── Act4.2-DDL.sql
│   ├── Act4.2-DML.sql
│   ├── Act4.2-DQL.sql
│   ├── README.md
│   ├── GUIA-COMPLETA-DOCKER-MYSQL.md
│   ├── TEMPLATE-PARA-PROYECTOS.md
│   ├── INICIO-RAPIDO.md
│   ├── COMANDOS-RAPIDOS.md
│   ├── NOTA-POR-QUE-NO-CORRIO.md
│   └── [9 archivos de scripts adicionales]
│
├── tarea5.1/
│   ├── setup-y-ejecutar.sh                 (15 pasos verificables)
│   ├── Marlenis-Concepcion-INF8336-Tarea-5.1-Script-Maestro-Actualizado.sql
│   ├── Act5.1-DDL.sql
│   ├── Act5.1-DML.sql
│   ├── Act5.1-DQL.sql
│   ├── README-TAREA-5.1.md
│   ├── VERIFICACION-FINAL-TODOS-OBJETOS.md
│   ├── INICIO-RAPIDO.md
│   ├── .env.example
│   ├── .gitignore
│   └── [Archivos SQL originales]
│
└── ENTREGA-FORMAL.md                       (Este documento)
```

---

## ✅ REQUISITOS CUMPLIDOS

### Tarea 4.1
- ✅ DDL: 12 tablas con constraints y foreign keys
- ✅ DML: 20+ registros por tabla
- ✅ DQL: Consultas de análisis
- ✅ Script maestro funcional
- ✅ Automatización bash
- ✅ Documentación completa
- ✅ Consulta objetivo ejecutable

### Tarea 5.1
- ✅ 1 Función SQL
- ✅ 5 Stored Procedures
- ✅ 4 Triggers activos
- ✅ 1 Vista materializada
- ✅ 12 Tablas con 22 empleados
- ✅ 22 Transacciones procesadas
- ✅ 12 Períodos de nómina
- ✅ Cálculos de nómina automatizados
- ✅ Auditoría completa (logs)
- ✅ Script bash con 15 pasos verificables
- ✅ Documentación profesional

---

## 🚀 INSTRUCCIONES DE EJECUCIÓN

### Tarea 4.1
```bash
cd tarea4.1
./setup-y-ejecutar.sh
```

**Resultado esperado:** Promedio_Pagos_RD = 17525.00

### Tarea 5.1
```bash
cd tarea5.1
./setup-y-ejecutar.sh
```

**Resultado esperado:**
- 1 Función ejecutada
- 5 Procedures listados
- 4 Triggers activos
- 1 Vista consultada
- 22 Empleados mostrados

---

## 📊 ESTADÍSTICAS DE PROYECTO

| Métrica | Tarea 4.1 | Tarea 5.1 | Total |
|---------|-----------|----------|-------|
| Archivos SQL | 4 | 4 | 8 |
| Líneas de SQL | 2,000+ | 1,500+ | 3,500+ |
| Tablas | 12 | 12 | 24 |
| Procedimientos | 0 | 5 | 5 |
| Funciones | 0 | 1 | 1 |
| Triggers | 0 | 4 | 4 |
| Vistas | 0 | 1 | 1 |
| Documentos | 11 | 5 | 16 |
| Scripts Shell | 9 | 1 | 10 |
| Registros de Datos | 200+ | 200+ | 400+ |

---

## 🔒 SEGURIDAD Y BUENAS PRÁCTICAS

✅ **Sin paths personales** en código  
✅ **Variables de entorno** para configuración sensible  
✅ **.gitignore** configurado correctamente  
✅ **Nomenclatura consistente** en todo el proyecto  
✅ **Foreign keys con integridad referencial**  
✅ **Constraints de validación** en todas las tablas  
✅ **Auditoría completa** mediante triggers y logs  
✅ **Documentación clara** y profesional  
✅ **Scripts reproducibles** en cualquier máquina  

---

## 📝 NOTAS TÉCNICAS

1. **Motor de Base de Datos:** MySQL 8.0 (soporte nativo ARM64 para Mac Apple Silicon)
2. **Contenedor:** Docker para máxima portabilidad
3. **Sintaxis:** MySQL nativa 100% (no SQL Server)
4. **Configuración:** Variables de entorno (.env)
5. **Versionamiento:** Git con commits limpios y descriptivos
6. **Documentación:** Markdown profesional con ejemplos ejecutables

---

## 📱 CONTACTO Y REFERENCIAS

**Repositorio GitHub:**  
https://github.com/marlenis-concepcion/BaseDatosMACDIA2026

**Última actualización:** 26 de Abril de 2026

**Estado:** ✅ COMPLETADO Y VERIFICADO

---

## 🎓 CONCLUSIÓN

Se han completado exitosamente las Tareas 4.1 y 5.1 con cumplimiento de todos los requisitos académicos. Los sistemas están listos para producción, completamente documentados y automatizados para facilitar evaluación y replicación.

La Tarea 5.1 demuestra aplicación de lecciones aprendidas en Tarea 4.1, mejorando significativamente la calidad del código, documentación y automatización.

---

**Cordialmente presentado,**

**Marlenis Judith Concepcion Cuevas**  
Base de Datos I - INF-8236-C2  
UASD - Maestría en Ciencia de Datos e Inteligencia Artificial  
26 de Abril de 2026
