# Practica MongoDB en MongoDB Compass

Estudiante: Marlenis Concepcion  
Base de datos: `maestria_nosql`  
Coleccion: `estudiantes`

## 1. Crear la base y la coleccion

En MongoDB Compass:

1. Conectar con `mongodb://127.0.0.1:*******`.
2. Crear la base de datos `maestria_nosql`.
3. Crear la coleccion `estudiantes`.

## 2. Insertar documentos originales

Use `Add Data` > `Insert Document` o `Insert Many`.

```javascript
[
  {
    "identificador": "2026-001",
    "nombre": "Ana Perez",
    "edad": 29,
    "programa": "Maestria en Ciencia de Datos",
    "activo": true,
    "competencias": ["SQL", "Python", "Power BI"],
    "contacto": {
      "ciudad": "Santo Domingo",
      "correo": "ana.perez@example.com"
    }
  },
  {
    "identificador": "2026-002",
    "nombre": "Carlos Rodriguez",
    "edad": 34,
    "programa": "Maestria en Ciencia de Datos",
    "activo": true,
    "competencias": ["Python", "MongoDB", "Machine Learning"],
    "contacto": {
      "ciudad": "Santiago",
      "correo": "carlos.rodriguez@example.com"
    }
  },
  {
    "identificador": "2026-003",
    "nombre": "Laura Martinez",
    "edad": 31,
    "programa": "Maestria en Analitica de Datos",
    "activo": false,
    "competencias": ["Excel", "SQL", "Tableau"],
    "contacto": {
      "ciudad": "La Vega",
      "correo": "laura.martinez@example.com"
    }
  }
]
```

## 3. Filtros solicitados

Mostrar todos los documentos:

```javascript
{}
```

Mostrar estudiantes activos:

```javascript
{ "activo": true }
```

Mostrar mayores de 30 anos:

```javascript
{ "edad": { "$gt": 30 } }
```

Buscar competencia Python:

```javascript
{ "competencias": "Python" }
```

Filtrar por ciudad:

```javascript
{ "contacto.ciudad": "Santo Domingo" }
```

## 4. Proyeccion sugerida

Filtro:

```javascript
{}
```

Project:

```javascript
{ "_id": 0, "nombre": 1, "programa": 1, "competencias": 1 }
```

## 5. Documento adicional

```javascript
{
  "identificador": "EST-ADICIONAL",
  "nombre": "Marlenis Concepcion",
  "edad": 30,
  "programa": "Maestria en Ciencia de Datos",
  "activo": true,
  "competencias": ["SQL", "MongoDB", "Analisis de Datos"],
  "certificaciones": ["MongoDB Basics", "SQL Intermedio"],
  "contacto": {
    "ciudad": "Santo Domingo",
    "correo": "marlenis.concepcion@example.com"
  },
  "direccion": {
    "ciudad": "Santo Domingo",
    "sector": "Distrito Nacional",
    "pais": "Republica Dominicana"
  }
}
```

## 6. Consulta de documentos con competencia SQL

```javascript
{ "competencias": "SQL" }
```

## 7. Actualizacion solicitada

Actualizar el documento original de Laura Martinez:

Filtro:

```javascript
{ "identificador": "2026-003" }
```

Update:

```javascript
{ "$set": { "activo": true } }
```

## 8. Eliminar unicamente el documento adicional

Filtro:

```javascript
{ "identificador": "EST-ADICIONAL" }
```

Resultado esperado: la coleccion conserva los tres documentos originales.
