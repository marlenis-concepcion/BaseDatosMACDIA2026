// Universidad Autonoma de Santo Domingo
// Base de Datos II - Unidad 1
// Practica MongoDB: maestria_nosql.estudiantes
// Estudiante: Marlenis Concepcion

use("maestria_nosql");

db.estudiantes.drop();

db.createCollection("estudiantes");

db.estudiantes.insertMany([
  {
    identificador: "2026-001",
    nombre: "Ana Perez",
    edad: 29,
    programa: "Maestria en Ciencia de Datos",
    activo: true,
    competencias: ["SQL", "Python", "Power BI"],
    contacto: {
      ciudad: "Santo Domingo",
      correo: "ana.perez@example.com"
    }
  },
  {
    identificador: "2026-002",
    nombre: "Carlos Rodriguez",
    edad: 34,
    programa: "Maestria en Ciencia de Datos",
    activo: true,
    competencias: ["Python", "MongoDB", "Machine Learning"],
    contacto: {
      ciudad: "Santiago",
      correo: "carlos.rodriguez@example.com"
    }
  },
  {
    identificador: "2026-003",
    nombre: "Laura Martinez",
    edad: 31,
    programa: "Maestria en Analitica de Datos",
    activo: false,
    competencias: ["Excel", "SQL", "Tableau"],
    contacto: {
      ciudad: "La Vega",
      correo: "laura.martinez@example.com"
    }
  }
]);

print("\n1. Todos los documentos");
printjson(db.estudiantes.find({}).toArray());

print("\n2. Estudiantes activos");
printjson(db.estudiantes.find({ activo: true }).toArray());

print("\n3. Mayores de 30 anos");
printjson(db.estudiantes.find({ edad: { $gt: 30 } }).toArray());

print("\n4. Estudiantes con competencia Python");
printjson(db.estudiantes.find({ competencias: "Python" }).toArray());

print("\n5. Estudiante por ciudad Santo Domingo");
printjson(db.estudiantes.find({ "contacto.ciudad": "Santo Domingo" }).toArray());

print("\n6. Proyeccion sugerida");
printjson(
  db.estudiantes.find(
    {},
    { _id: 0, nombre: 1, programa: 1, competencias: 1 }
  ).toArray()
);

print("\n7. Insertar documento adicional");
db.estudiantes.insertOne({
  identificador: "EST-ADICIONAL",
  nombre: "Marlenis Concepcion",
  edad: 30,
  programa: "Maestria en Ciencia de Datos",
  activo: true,
  competencias: ["SQL", "MongoDB", "Analisis de Datos"],
  certificaciones: ["MongoDB Basics", "SQL Intermedio"],
  contacto: {
    ciudad: "Santo Domingo",
    correo: "marlenis.concepcion@example.com"
  },
  direccion: {
    ciudad: "Santo Domingo",
    sector: "Distrito Nacional",
    pais: "Republica Dominicana"
  }
});
printjson(db.estudiantes.find({ identificador: "EST-ADICIONAL" }).toArray());

print("\n8. Consultar documentos con competencia SQL");
printjson(db.estudiantes.find({ competencias: "SQL" }).toArray());

print("\n9. Actualizar estado activo de un documento original");
db.estudiantes.updateOne(
  { identificador: "2026-003" },
  { $set: { activo: true } }
);
printjson(db.estudiantes.find({ identificador: "2026-003" }).toArray());

print("\n10. Eliminar unicamente el documento adicional");
db.estudiantes.deleteOne({ identificador: "EST-ADICIONAL" });
printjson(db.estudiantes.find({}).toArray());

print("\nPractica finalizada. La coleccion conserva los tres documentos originales.");
