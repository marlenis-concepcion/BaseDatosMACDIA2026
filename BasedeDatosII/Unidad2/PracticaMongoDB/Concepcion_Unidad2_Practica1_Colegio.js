// Universidad Autonoma de Santo Domingo
// Base de Datos II - Unidad 2
// Practica No. 1 - Colegio
// Objetivo: aplicar operaciones CRUD sobre documentos MongoDB
// utilizando documentos y arreglos anidados.
// Estudiante: Marlenis Concepcion
// Docente: Bismark Montero

use("colegio");

print("\n============================================================");
print("Practica No. 1 - Colegio");
print("Base de datos: colegio");
print("Coleccion: estudiantes");
print("============================================================\n");

print("Preparacion: limpiar coleccion para una corrida reproducible");
db.estudiantes.drop();
db.createCollection("estudiantes");

print("\nCREATE 1: Insertar estudiantes con documentos y arreglos anidados");
db.estudiantes.insertMany([
  {
    matricula: "EST-2026-001",
    nombre: "Ana Perez",
    edad: 12,
    grado: "6to",
    seccion: "A",
    activo: true,
    direccion: {
      ciudad: "Santo Domingo",
      sector: "Gazcue",
      calle: "Principal"
    },
    tutor: {
      nombre: "Maria Perez",
      parentesco: "Madre",
      telefonos: ["809-555-1001", "829-555-1001"]
    },
    asignaturas: [
      { nombre: "Matematica", calificacion: 92 },
      { nombre: "Lengua Espanola", calificacion: 88 },
      { nombre: "Ciencias Naturales", calificacion: 91 }
    ],
    actividades: ["Lectura", "Robotica"]
  },
  {
    matricula: "EST-2026-002",
    nombre: "Carlos Rodriguez",
    edad: 13,
    grado: "7mo",
    seccion: "B",
    activo: true,
    direccion: {
      ciudad: "Santiago",
      sector: "Los Jardines",
      calle: "Duarte"
    },
    tutor: {
      nombre: "Jose Rodriguez",
      parentesco: "Padre",
      telefonos: ["809-555-2002"]
    },
    asignaturas: [
      { nombre: "Matematica", calificacion: 85 },
      { nombre: "Lengua Espanola", calificacion: 90 },
      { nombre: "Sociales", calificacion: 87 }
    ],
    actividades: ["Baloncesto", "Ajedrez"]
  },
  {
    matricula: "EST-2026-003",
    nombre: "Laura Martinez",
    edad: 11,
    grado: "6to",
    seccion: "A",
    activo: false,
    direccion: {
      ciudad: "La Vega",
      sector: "Centro",
      calle: "Las Flores"
    },
    tutor: {
      nombre: "Rosa Martinez",
      parentesco: "Madre",
      telefonos: ["809-555-3003", "849-555-3003"]
    },
    asignaturas: [
      { nombre: "Matematica", calificacion: 78 },
      { nombre: "Lengua Espanola", calificacion: 84 },
      { nombre: "Ciencias Naturales", calificacion: 80 }
    ],
    actividades: ["Pintura", "Lectura"]
  }
]);
printjson(db.estudiantes.find({}, { _id: 0 }).toArray());

print("\nREAD 1: Consultar todos los estudiantes activos");
printjson(db.estudiantes.find({ activo: true }, { _id: 0 }).toArray());

print("\nREAD 2: Consultar estudiantes de 6to grado, seccion A");
printjson(db.estudiantes.find({ grado: "6to", seccion: "A" }, { _id: 0 }).toArray());

print("\nREAD 3: Consultar por documento anidado: ciudad Santo Domingo");
printjson(db.estudiantes.find({ "direccion.ciudad": "Santo Domingo" }, { _id: 0 }).toArray());

print("\nREAD 4: Consultar por arreglo simple: actividad Lectura");
printjson(db.estudiantes.find({ actividades: "Lectura" }, { _id: 0 }).toArray());

print("\nREAD 5: Consultar por arreglo de documentos: Matematica con calificacion mayor o igual a 90");
printjson(
  db.estudiantes.find(
    {
      asignaturas: {
        $elemMatch: {
          nombre: "Matematica",
          calificacion: { $gte: 90 }
        }
      }
    },
    { _id: 0, matricula: 1, nombre: 1, asignaturas: 1 }
  ).toArray()
);

print("\nUPDATE 1: Actualizar estado de Laura Martinez a activo");
db.estudiantes.updateOne(
  { matricula: "EST-2026-003" },
  { $set: { activo: true } }
);
printjson(db.estudiantes.find({ matricula: "EST-2026-003" }, { _id: 0 }).toArray());

print("\nUPDATE 2: Agregar una nueva actividad a Carlos Rodriguez");
db.estudiantes.updateOne(
  { matricula: "EST-2026-002" },
  { $addToSet: { actividades: "Programacion" } }
);
printjson(db.estudiantes.find({ matricula: "EST-2026-002" }, { _id: 0 }).toArray());

print("\nUPDATE 3: Actualizar calificacion de Matematica de Carlos Rodriguez");
db.estudiantes.updateOne(
  { matricula: "EST-2026-002", "asignaturas.nombre": "Matematica" },
  { $set: { "asignaturas.$.calificacion": 89 } }
);
printjson(
  db.estudiantes.find(
    { matricula: "EST-2026-002" },
    { _id: 0, matricula: 1, nombre: 1, asignaturas: 1 }
  ).toArray()
);

print("\nCREATE 2: Insertar estudiante adicional para demostrar delete");
db.estudiantes.insertOne({
  matricula: "EST-2026-004",
  nombre: "Miguel Santos",
  edad: 14,
  grado: "8vo",
  seccion: "C",
  activo: true,
  direccion: {
    ciudad: "San Cristobal",
    sector: "Madre Vieja",
    calle: "Independencia"
  },
  tutor: {
    nombre: "Elena Santos",
    parentesco: "Madre",
    telefonos: ["809-555-4004"]
  },
  asignaturas: [
    { nombre: "Matematica", calificacion: 81 },
    { nombre: "Ingles", calificacion: 93 }
  ],
  actividades: ["Beisbol"]
});
printjson(db.estudiantes.find({ matricula: "EST-2026-004" }, { _id: 0 }).toArray());

print("\nDELETE: Eliminar unicamente el estudiante adicional");
db.estudiantes.deleteOne({ matricula: "EST-2026-004" });
printjson(db.estudiantes.find({}, { _id: 0, matricula: 1, nombre: 1, activo: 1 }).toArray());

print("\nRESUMEN FINAL");
print("Total de estudiantes conservados:");
printjson(db.estudiantes.countDocuments());
print("La practica conserva los tres estudiantes originales y evidencia operaciones CRUD.");
