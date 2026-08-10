# Practica MongoDB

Universidad Autonoma de Santo Domingo  
Asignatura: Base de Datos II  
Tema: Configuracion del entorno MongoDB y fundamentos de trabajo documental  
Estudiante: Marlenis Concepcion  
Matricula: 40225495809  
Fecha: 10 de agosto de 2026

## 1. Proposito

Esta practica tiene como objetivo configurar y validar un entorno local de MongoDB, crear una base de datos documental, insertar documentos, aplicar consultas con filtros y proyecciones, y ejecutar operaciones basicas CRUD sobre una coleccion academica.

## 2. Entorno utilizado

- Motor de base de datos: MongoDB Community Server ejecutado en Docker.
- Interfaz grafica: MongoDB Compass.
- Cadena de conexion local: `mongodb://127.0.0.1:37017`.
- Contenedor utilizado: `mongodb-uasd`, basado en la imagen `mongo:8.0`.
- Base de datos creada: `maestria_nosql`.
- Coleccion creada: `estudiantes`.

## 3. Estructura documental

La coleccion `estudiantes` contiene documentos con campos simples, arreglos y documentos embebidos. Los campos principales son `matricula`, `nombre`, `edad`, `programa`, `activo`, `competencias` y `contacto`.

El campo `competencias` se modelo como arreglo porque un estudiante puede tener varias habilidades asociadas. El campo `contacto` se modelo como documento embebido porque sus datos pertenecen directamente al estudiante.

## 4. Documentos originales insertados

Se insertaron tres documentos iniciales:

- Ana Perez, matricula `2026-001`.
- Carlos Rodriguez, matricula `2026-002`.
- Laura Martinez, matricula `2026-003`.

Cada documento recibio un campo `_id` unico generado por MongoDB.

## 5. Consultas realizadas

Se ejecutaron los siguientes filtros:

- Mostrar todos los documentos: `{}`.
- Mostrar estudiantes activos: `{ "activo": true }`.
- Mostrar mayores de 30 anos: `{ "edad": { "$gt": 30 } }`.
- Buscar competencia Python: `{ "competencias": "Python" }`.
- Filtrar por ciudad: `{ "contacto.ciudad": "Santo Domingo" }`.

Tambien se aplico la siguiente proyeccion:

```javascript
{ "_id": 0, "nombre": 1, "programa": 1, "competencias": 1 }
```

## 6. Actividad de consolidacion

Se inserto un documento adicional con la matricula `40225495809`, incluyendo los arreglos `competencias` y `certificaciones`, ademas del documento embebido `direccion`.

Luego se consultaron los documentos con la competencia SQL usando:

```javascript
{ "competencias": "SQL" }
```

Posteriormente, se actualizo el estado activo del documento original de Laura Martinez:

```javascript
{ "$set": { "activo": true } }
```

Finalmente, se elimino unicamente el documento adicional con la matricula `40225495809`, conservando los tres documentos originales de la practica.

## 7. Evidencias y cumplimiento

La practica fue ejecutada desde la consola utilizando Docker como entorno de ejecucion para MongoDB. El contenedor `mongodb-uasd` expuso el servicio local mediante la cadena `mongodb://127.0.0.1:37017`.

### Lo solicitado y como se cumplio

| Requisito | Como se cumplio |
|---|---|
| Configurar un entorno local de MongoDB. | Se levanto MongoDB con Docker usando el contenedor `mongodb-uasd`, la imagen `mongo:8.0` y el puerto local `37017`. |
| Crear la base `maestria_nosql` y la coleccion `estudiantes`. | El script `run-practica-mongodb-docker.sh` ejecuto la practica completa. |
| Insertar tres documentos originales. | Se insertaron Ana Perez, Carlos Rodriguez y Laura Martinez. |
| Ejecutar filtros y proyeccion. | Se consultaron activos, mayores de 30 anos, competencia Python, ciudad Santo Domingo y la proyeccion sugerida. |
| Insertar un documento adicional. | Se inserto el documento de Marlenis Concepcion con certificaciones y direccion embebida. |
| Actualizar un documento original. | Se actualizo el campo `activo` de Laura Martinez a `true`. |
| Eliminar el documento adicional. | Se elimino solo el documento con matricula `40225495809` y quedaron los tres documentos originales. |

### Capturas incluidas en el PDF

1. Inicio de la corrida del script con Docker.
2. Documentos insertados y consulta de estudiantes activos.
3. Consulta de mayores de 30 anos y competencia Python.
4. Filtro por ciudad y proyeccion.
5. Insercion del documento adicional.
6. Actualizacion del documento original.
7. Eliminacion del documento adicional y conservacion de los tres documentos originales.

## 8. Preguntas de reflexion

### Que diferencias estructurales observa entre un documento de MongoDB y una fila de una tabla relacional?

Una fila de una tabla relacional sigue una estructura fija definida por columnas, tipos de datos y restricciones. En cambio, un documento de MongoDB tiene una estructura flexible y puede incluir campos simples, arreglos y documentos embebidos dentro del mismo registro.

### Que beneficios y riesgos introduce la flexibilidad de esquema?

La flexibilidad de esquema permite adaptar la base de datos a cambios del negocio sin modificar una estructura rigida. Tambien facilita representar datos complejos en un solo documento. Como riesgo, puede producir inconsistencias si no se mantienen reglas claras de modelado y validacion.

### Por que contacto se modelo como documento embebido y competencias como arreglo?

`contacto` se modelo como documento embebido porque agrupa datos relacionados directamente con un estudiante, como ciudad y correo. `competencias` se modelo como arreglo porque un estudiante puede tener varias competencias asociadas al mismo campo.

### Que funcion cumple _id y que ocurriria si se intentara insertar un valor duplicado?

El campo `_id` identifica de forma unica cada documento dentro de una coleccion. Si se intenta insertar un documento con un `_id` duplicado, MongoDB rechaza la operacion porque violaria la unicidad de esa clave.

### Como cambiaria el modelo si un estudiante pudiera pertenecer simultaneamente a varios programas?

El campo `programa` podria convertirse en un arreglo llamado `programas`, donde se almacenen varios programas asociados al estudiante. Si cada programa tuviera muchos detalles propios, tambien podria modelarse como una coleccion separada y relacionarse mediante identificadores.

## 9. Conclusion

La practica permitio validar los conceptos iniciales de MongoDB mediante la creacion de una base documental, el manejo de documentos con arreglos y objetos embebidos, y la ejecucion de operaciones CRUD. Tambien se comprobo la utilidad de los filtros y proyecciones para recuperar informacion especifica dentro de una coleccion.
