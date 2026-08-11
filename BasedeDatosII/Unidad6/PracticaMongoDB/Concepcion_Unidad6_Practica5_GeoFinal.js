// Universidad Autonoma de Santo Domingo
// Base de Datos II - Unidad 6
// Practica No. 5 - Indices Geoespaciales con MongoDB y GeoJSON
// Proyecto Final - MongoDB
// Estudiante: Marlenis Concepcion
// Docente: Bismark Montero

use("unidad6_geo_final");

print("\n============================================================");
print("Unidad 6 - Practica No. 5 y Proyecto Final MongoDB");
print("GeoJSON, indices 2dsphere, aggregation y backup");
print("Base de datos: unidad6_geo_final");
print("============================================================\n");

print("Preparacion: limpiar colecciones");
db.usuarios.drop();
db.posts.drop();
db.tags.drop();
db.lugares.drop();

print("\n1. Carga de datos geoespaciales y sociales");
db.usuarios.insertMany([
  { _id: ObjectId("66f600000000000000000001"), username: "ana", ciudad: "Santo Domingo", rol: "Estudiante" },
  { _id: ObjectId("66f600000000000000000002"), username: "carlos", ciudad: "Santiago", rol: "Docente" },
  { _id: ObjectId("66f600000000000000000003"), username: "laura", ciudad: "La Vega", rol: "Estudiante" }
]);

db.tags.insertMany([
  { _id: ObjectId("66f610000000000000000001"), nombre: "geo" },
  { _id: ObjectId("66f610000000000000000002"), nombre: "mongodb" },
  { _id: ObjectId("66f610000000000000000003"), nombre: "backup" }
]);

db.posts.insertMany([
  {
    _id: ObjectId("66f620000000000000000001"),
    usuarioId: ObjectId("66f600000000000000000001"),
    titulo: "Consulta geoespacial",
    tags: ["geo", "mongodb"],
    visitas: 42,
    creado: new Date("2026-08-10T13:00:00Z")
  },
  {
    _id: ObjectId("66f620000000000000000002"),
    usuarioId: ObjectId("66f600000000000000000002"),
    titulo: "Aggregation pipeline",
    tags: ["mongodb"],
    visitas: 31,
    creado: new Date("2026-08-10T14:00:00Z")
  },
  {
    _id: ObjectId("66f620000000000000000003"),
    usuarioId: ObjectId("66f600000000000000000001"),
    titulo: "Backup y restore",
    tags: ["backup", "mongodb"],
    visitas: 25,
    creado: new Date("2026-08-10T15:00:00Z")
  }
]);

db.lugares.insertMany([
  {
    nombre: "Universidad Autonoma de Santo Domingo",
    categoria: "universidad",
    location: { type: "Point", coordinates: [-69.91997, 18.46077] }
  },
  {
    nombre: "Parque Mirador Sur",
    categoria: "parque",
    location: { type: "Point", coordinates: [-69.9497, 18.4318] }
  },
  {
    nombre: "Faro a Colon",
    categoria: "monumento",
    location: { type: "Point", coordinates: [-69.8735, 18.4801] }
  },
  {
    nombre: "Agora Mall",
    categoria: "comercial",
    location: { type: "Point", coordinates: [-69.9389, 18.4821] }
  }
]);
printjson({
  usuarios: db.usuarios.countDocuments(),
  posts: db.posts.countDocuments(),
  tags: db.tags.countDocuments(),
  lugares: db.lugares.countDocuments()
});

print("\n2. Crear indice 2dsphere");
db.lugares.createIndex({ location: "2dsphere" }, { name: "idx_location_2dsphere" });
printjson(db.lugares.getIndexes());

print("\n3. Consulta geoespacial $near");
print("Lugares cercanos a la UASD en un radio de 5 km.");
printjson(
  db.lugares.find({
    location: {
      $near: {
        $geometry: { type: "Point", coordinates: [-69.91997, 18.46077] },
        $maxDistance: 5000
      }
    }
  }, { _id: 0, nombre: 1, categoria: 1, location: 1 }).toArray()
);

print("\n4. Consulta geoespacial $geoWithin");
const radioKm = 6;
const radioRadianes = radioKm / 6378.1;
printjson(
  db.lugares.find({
    location: {
      $geoWithin: {
        $centerSphere: [[-69.91997, 18.46077], radioRadianes]
      }
    }
  }, { _id: 0, nombre: 1, categoria: 1 }).toArray()
);

print("\n5. Aggregation pipeline: posts por usuario con $lookup");
printjson(
  db.posts.aggregate([
    { $group: { _id: "$usuarioId", totalPosts: { $sum: 1 }, visitas: { $sum: "$visitas" } } },
    { $sort: { totalPosts: -1, visitas: -1 } },
    { $lookup: { from: "usuarios", localField: "_id", foreignField: "_id", as: "autor" } },
    { $unwind: "$autor" },
    { $project: { _id: 0, usuario: "$autor.username", ciudad: "$autor.ciudad", totalPosts: 1, visitas: 1 } }
  ]).toArray()
);

print("\n6. Aggregation pipeline: conteo por tag");
printjson(
  db.posts.aggregate([
    { $unwind: "$tags" },
    { $group: { _id: "$tags", total: { $sum: 1 }, visitas: { $sum: "$visitas" } } },
    { $sort: { total: -1 } }
  ]).toArray()
);

print("\n7. Proyeccion final");
printjson(
  db.lugares.aggregate([
    { $project: { _id: 0, nombre: 1, categoria: 1, tipoGeoJSON: "$location.type", coordenadas: "$location.coordinates" } },
    { $sort: { nombre: 1 } }
  ]).toArray()
);

print("\nResumen final Unidad 6");
print("Se completo carga de datos, indice geoespacial, consultas GeoJSON y pipelines de agregacion.");
