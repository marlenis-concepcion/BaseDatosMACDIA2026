// Universidad Autonoma de Santo Domingo
// Base de Datos II - Unidad 5
// Practica No. 4 - Modelado de Datos: Embebido vs. Referenciado
// Estudiante: Marlenis Concepcion
// Docente: Bismark Montero

use("unidad5_modelado");

print("\n============================================================");
print("Unidad 5 - Practica No. 4");
print("Modelado de Datos: Embebido vs. Referenciado");
print("Base de datos: unidad5_modelado");
print("============================================================\n");

print("Preparacion: limpiar colecciones");
db.usuarios.drop();
db.publicaciones.drop();
db.etiquetas.drop();
db.inscripciones.drop();

print("\n1. Escenario embebido: usuario con perfil y direcciones");
db.createCollection("usuarios");
db.usuarios.insertMany([
  {
    _id: ObjectId("66f500000000000000000001"),
    username: "ana",
    email: "ana@example.com",
    perfil: {
      nombreCompleto: "Ana Perez",
      rol: "Estudiante",
      telefono: "809-555-1001"
    },
    direcciones: [
      { tipo: "casa", ciudad: "Santo Domingo", sector: "Gazcue" },
      { tipo: "trabajo", ciudad: "Santo Domingo", sector: "Naco" }
    ]
  },
  {
    _id: ObjectId("66f500000000000000000002"),
    username: "carlos",
    email: "carlos@example.com",
    perfil: {
      nombreCompleto: "Carlos Rodriguez",
      rol: "Docente",
      telefono: "809-555-1002"
    },
    direcciones: [
      { tipo: "casa", ciudad: "Santiago", sector: "Los Jardines" }
    ]
  }
]);

print("Consulta embebida: usuarios con direccion en Santo Domingo");
printjson(
  db.usuarios.find(
    { "direcciones.ciudad": "Santo Domingo" },
    { _id: 0, username: 1, perfil: 1, direcciones: 1 }
  ).toArray()
);

print("\nJustificacion embebida:");
print("Se usa perfil embebido para relacion 1:1 y direcciones embebidas para 1:N de bajo crecimiento, porque se consultan junto al usuario.");

print("\n2. Escenario referenciado: publicaciones, etiquetas e inscripciones");
db.createCollection("etiquetas");
db.etiquetas.insertMany([
  { _id: ObjectId("66f510000000000000000001"), nombre: "nosql" },
  { _id: ObjectId("66f510000000000000000002"), nombre: "mongodb" },
  { _id: ObjectId("66f510000000000000000003"), nombre: "modelado" },
  { _id: ObjectId("66f510000000000000000004"), nombre: "validacion" }
]);

db.createCollection("publicaciones");
db.publicaciones.insertMany([
  {
    _id: ObjectId("66f520000000000000000001"),
    usuarioId: ObjectId("66f500000000000000000001"),
    titulo: "Modelo embebido",
    contenido: "Ejemplo de perfil y direcciones dentro del usuario.",
    etiquetasIds: [
      ObjectId("66f510000000000000000001"),
      ObjectId("66f510000000000000000003")
    ],
    fecha: new Date("2026-08-10T10:00:00Z")
  },
  {
    _id: ObjectId("66f520000000000000000002"),
    usuarioId: ObjectId("66f500000000000000000002"),
    titulo: "Schema validation",
    contenido: "Ejemplo de validacion de documentos en MongoDB.",
    etiquetasIds: [
      ObjectId("66f510000000000000000002"),
      ObjectId("66f510000000000000000004")
    ],
    fecha: new Date("2026-08-10T11:00:00Z")
  }
]);

print("Consulta referenciada con $lookup: publicaciones con usuario");
printjson(
  db.publicaciones.aggregate([
    {
      $lookup: {
        from: "usuarios",
        localField: "usuarioId",
        foreignField: "_id",
        as: "autor"
      }
    },
    { $unwind: "$autor" },
    {
      $project: {
        _id: 0,
        titulo: 1,
        "autor.username": 1,
        "autor.perfil.nombreCompleto": 1
      }
    }
  ]).toArray()
);

print("\nConsulta referenciada N:M con $lookup pipeline: publicaciones con etiquetas");
printjson(
  db.publicaciones.aggregate([
    {
      $lookup: {
        from: "etiquetas",
        let: { ids: "$etiquetasIds" },
        pipeline: [
          { $match: { $expr: { $in: ["$_id", "$$ids"] } } },
          { $project: { _id: 0, nombre: 1 } }
        ],
        as: "etiquetas"
      }
    },
    { $project: { _id: 0, titulo: 1, etiquetas: 1 } }
  ]).toArray()
);

print("\nJustificacion referenciada:");
print("Se usan referencias para publicaciones y etiquetas porque una etiqueta puede aparecer en muchas publicaciones y una publicacion puede tener muchas etiquetas.");

print("\n3. Schema Validation: coleccion inscripciones");
db.createCollection("inscripciones", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["estudiante", "asignatura", "periodo"],
      properties: {
        estudiante: { bsonType: "string", minLength: 3 },
        asignatura: { bsonType: "string", minLength: 3 },
        periodo: { bsonType: "string" },
        creditos: { bsonType: "int", minimum: 1 },
        activa: { bsonType: "bool" }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});

print("Insercion valida:");
db.inscripciones.insertOne({
  estudiante: "Marlenis Concepcion",
  asignatura: "Base de Datos II",
  periodo: "2026-02",
  creditos: NumberInt(4),
  activa: true
});
printjson(db.inscripciones.find({}, { _id: 0 }).toArray());

print("\nInsercion invalida: falta asignatura y creditos no es entero valido");
try {
  db.inscripciones.insertOne({
    estudiante: "MC",
    periodo: "2026-02",
    creditos: "cuatro",
    activa: true
  });
} catch (error) {
  print("Error esperado por validacion de esquema:");
  printjson({
    name: error.name,
    code: error.code,
    message: error.message
  });
}

print("\nResumen final Unidad 5");
printjson({
  usuarios: db.usuarios.countDocuments(),
  publicaciones: db.publicaciones.countDocuments(),
  etiquetas: db.etiquetas.countDocuments(),
  inscripciones: db.inscripciones.countDocuments()
});
