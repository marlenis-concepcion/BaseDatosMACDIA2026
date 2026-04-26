# Guion de Exposicion - Tarea 5.1 DBNomina

Universidad Autonoma de Santo Domingo (UASD)  
Asignatura: Base de Datos I - INF-8236-C2  
Tema: Consultas Avanzadas, Stored Procedures y Triggers en SQL Server  
Grupo: Mannix, Roberto Byas, Victor Perez y Marlenis Concepcion  

## Distribucion exacta

- Diapositiva 1: portada, la puede abrir Marlenis o decirla entre todos.
- Diapositiva 2: distribucion del grupo, la puede presentar Marlenis.
- Mannix: diapositivas 3 a 6.
- Roberto: diapositivas 7 a 9.
- Victor: diapositivas 10 a 12.
- Marlenis: diapositivas 13 a 18.
- Diapositiva 19: cierre, idealmente la hace Marlenis o entre todos.

## Apertura breve

### Diapositiva 1 - Portada

Texto sugerido:

"Buenos dias. Somos el grupo integrado por Mannix, Roberto Byas, Victor Perez y Marlenis Concepcion. En esta presentacion mostraremos la solucion de la Tarea 5.1 de la Unidad 5, desarrollada en SQL Server sobre la base de datos DBNomina."

### Diapositiva 2 - Distribucion

Texto sugerido:

"Para organizar la exposicion dividimos el contenido en cuatro partes. Mannix presentara el contexto y el modelo, Roberto la optimizacion, Victor el manejo transaccional y la concurrencia, y Marlenis la parte mas tecnica de scripts: stored procedures, funcion, triggers, vista indexada, seguridad y evidencias."

## Mannix - Diapositivas 3 a 6

### Diapositiva 3

Objetivo:
Presentar el contexto general de la tarea.

Guion:

"En esta primera parte presentamos el contexto de la tarea. El trabajo pertenece a la Unidad 5 de la asignatura Base de Datos I y se centra en administracion, optimizacion y herramientas avanzadas de SQL Server aplicadas a DBNomina."

### Diapositiva 4

Objetivo:
Explicar el alcance de la solucion.

Guion:

"La solucion cubre los 12 ejercicios planteados por la tutora. No solo construimos la base de datos, sino que tambien incluimos transacciones, optimizacion, procedimientos almacenados, triggers, una funcion, una vista indexada y seguridad."

### Diapositiva 5

Objetivo:
Presentar el modelo DBNomina.

Guion:

"Aqui vemos las tablas principales del modelo. Tenemos compania, tipo de periodo, departamento, empleado, tipo de nomina, periodo y transaccion de nomina. Estas tablas permiten organizar la estructura basica del sistema y asegurar la integridad entre empleados, periodos y pagos."

### Diapositiva 6

Objetivo:
Explicar los datos de prueba y la logica dominicana.

Guion:

"Tambien cargamos datos de prueba realistas. Usamos nombres del grupo y del contexto academico para que la solucion fuera mas cercana a la tarea. Ademas, aplicamos reglas reales de Republica Dominicana para AFP, ARS e ISR, de forma que los calculos de nomina fueran coherentes."

Transicion final:

"Con esta base ya construida, le doy el paso a Roberto para explicar como optimizamos las consultas y como analizamos el rendimiento."

## Roberto - Diapositivas 7 a 9

### Diapositiva 7

Objetivo:
Introducir la parte de optimizacion.

Guion:

"En esta seccion explico la parte de optimizacion. El objetivo fue analizar como responde SQL Server a una consulta por empleado y luego mejorar el rendimiento con indices y estadisticas."

### Diapositiva 8

Objetivo:
Explicar plan de ejecucion e indice.

Guion:

"La consulta evaluada fue sobre la tabla TransaccionNomina filtrando por Empleado_ID. Antes de crear el indice, el motor tiende a usar un Clustered Index Scan. Despues de crear el indice no agrupado sobre Empleado_ID, la operacion esperada mejora a un Index Seek, lo que reduce lecturas innecesarias."

### Diapositiva 9

Objetivo:
Explicar estadisticas.

Guion:

"Luego actualizamos las estadisticas de la tabla. Esto es importante porque el optimizador necesita informacion actualizada para estimar cuantas filas devolvera una consulta y asi elegir el mejor plan posible. En otras palabras, las estadisticas ayudan a que SQL Server tome decisiones mas inteligentes."

Transicion final:

"Despues de optimizar la consulta, Victor presentara la parte de transacciones, control de errores, concurrencia y niveles de aislamiento."

## Victor - Diapositivas 10 a 12

### Diapositiva 10

Objetivo:
Introducir ACID y concurrencia.

Guion:

"En esta parte trabajamos el control transaccional. Aqui se demuestra como SQL Server mantiene la consistencia de los datos usando las propiedades ACID y mecanismos como COMMIT, ROLLBACK, SAVEPOINT y niveles de aislamiento."

### Diapositiva 11

Objetivo:
Explicar COMMIT y SAVEPOINT.

Guion:

"Primero hicimos una transaccion con COMMIT para insertar un pago de nomina y confirmar que el registro quedara guardado. Luego simulamos un caso con SAVEPOINT, donde insertamos dos registros, hicimos una actualizacion posterior y finalmente revertimos solo esa parte. Esto muestra la ventaja del rollback parcial."

### Diapositiva 12

Objetivo:
Explicar bloqueo y READ COMMITTED.

Guion:

"Tambien simulamos concurrencia con dos sesiones. La primera actualiza un sueldo y deja la transaccion abierta; la segunda intenta modificar el mismo registro y queda bloqueada. Esto ocurre por el bloqueo exclusivo de la primera sesion. Ademas, usamos READ COMMITTED para evitar lecturas sucias y mantener consistencia."

Transicion final:

"Ahora le paso la palabra a Marlenis, que presentara la parte mas tecnica del trabajo: los scripts de programabilidad, la automatizacion y las evidencias."

## Marlenis - Diapositivas 13 a 18

### Diapositiva 13

Objetivo:
Introducir la programabilidad.

Guion:

"En esta ultima parte voy a presentar la seccion mas tecnica de la solucion. Aqui concentramos la logica de negocio usando stored procedures, una funcion escalar y varios triggers para automatizar calculos, auditoria, cache e historico."

### Diapositiva 14

Objetivo:
Explicar los stored procedures.

Guion:

"Creamos cinco stored procedures. El primero calcula y actualiza sueldo base, AFP, ARS, ISR y sueldo neto. El segundo consulta toda la nomina de un empleado. Los otros tres se encargan de insertar auditoria en empleado, auditoria en transacciones y el historico de transacciones eliminadas."

Punto clave:

"La ventaja principal es que la logica queda centralizada, reutilizable y mas facil de mantener."

### Diapositiva 15

Objetivo:
Explicar funcion y triggers.

Guion:

"Tambien se creo la funcion FN_SalarioAnual, que simplemente multiplica el sueldo mensual por doce. Luego implementamos cinco triggers. Dos disparan procesos luego de insertar transacciones, uno actualiza automaticamente los calculos y otro llena una cache de consulta por empleado. Los otros triggers auditan cambios y guardan historico cuando una transaccion es eliminada."

Punto clave:

"Aqui se ve como SQL Server puede automatizar procesos sin depender de ejecucion manual."

### Diapositiva 16

Objetivo:
Explicar vista indexada y seguridad.

Guion:

"Para la parte de vistas materializadas, en SQL Server usamos una indexed view con schemabinding. Esta vista resume por empleado cuantas transacciones tiene y cuanto total neto ha cobrado. En seguridad, creamos un login, un usuario y un rol de solo lectura, aplicando el principio de minimo privilegio."

### Diapositiva 17

Objetivo:
Mostrar evidencias.

Guion:

"En las evidencias documentadas se puede observar que el empleado 3 devuelve dos transacciones, que el pago 1007 queda confirmado con COMMIT, que el SAVEPOINT conserva los inserts pero revierte la actualizacion, y que al insertar y luego eliminar la transaccion 1010 se activan tanto la auditoria como el historico."

### Diapositiva 18

Objetivo:
Explicar respaldo tecnico y legal de calculos.

Guion:

"Finalmente, aqui mostramos las fuentes oficiales que respaldan los calculos aplicados. Usamos referencias de DGII para la escala de ISR 2026 y de TSS para porcentajes y topes de cotizacion. Esto fortalece la validez tecnica del script entregado."

Transicion al cierre:

"Con esto concluimos la parte tecnica del proyecto. Paso ahora al cierre final de la presentacion."

## Cierre

### Diapositiva 19

Guion sugerido:

"En conclusion, esta tarea nos permitio integrar modelado, optimizacion, control transaccional y programabilidad avanzada en SQL Server. Entregamos el script completo, el documento de respuestas con evidencias y esta presentacion. Muchas gracias."

## Recomendaciones para exponer

- Cada persona debe durar entre 2 y 3 minutos.
- No lean toda la diapositiva; usen la diapositiva como apoyo y desarrollen la idea con sus palabras.
- Marlenis debe enfatizar que su parte concentra la logica tecnica del sistema.
- Roberto y Victor deben usar palabras clave: rendimiento, consistencia, bloqueo, aislamiento.
- Mannix debe abrir con seguridad porque su parte da el contexto general.
