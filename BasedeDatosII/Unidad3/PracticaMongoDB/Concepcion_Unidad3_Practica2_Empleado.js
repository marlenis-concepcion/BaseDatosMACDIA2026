// Universidad Autonoma de Santo Domingo
// Base de Datos II - Unidad 3
// Practica No. 2 - Empleado
// Objetivo: aplicar importacion, insercion masiva, _id,
// insertMany() e inserciones ordenadas en MongoDB.
// Estudiante: Marlenis Concepcion
// Docente: Bismark Montero

use("empresa");

print("\n============================================================");
print("Practica No. 2 - Empleado");
print("Base de datos: empresa");
print("Coleccion: empleados");
print("============================================================\n");

print("0. Validacion del dataset importado con mongoimport");
print("Total luego de importar dataset:");
printjson(db.empleados.countDocuments());
printjson(db.empleados.find({}, { _id: 1, nombre: 1, departamento: 1, salario: 1, activo: 1 }).toArray());

print("\n1. insertOne(): insertar un empleado adicional");
db.empleados.insertOne({
  _id: "EMP-006",
  nombre: "Pedro Castillo",
  edad: 38,
  departamento: "Operaciones",
  cargo: "Encargado de Logistica",
  salario: 64000,
  activo: true,
  fechaIngreso: "2022-09-12",
  habilidades: ["Inventario", "Logistica", "Excel"],
  direccion: {
    ciudad: "Santo Domingo",
    sector: "Villa Consuelo"
  }
});
printjson(db.empleados.find({ _id: "EMP-006" }).toArray());

print("\n2. insertMany() ordenado con conflicto de _id");
print("El documento EMP-007 se inserta antes del conflicto. EMP-008 no se inserta porque ordered:true detiene la operacion.");
try {
  db.empleados.insertMany(
    [
      {
        _id: "EMP-007",
        nombre: "Sofia Reyes",
        edad: 28,
        departamento: "Marketing",
        cargo: "Analista de Mercado",
        salario: 57000,
        activo: true,
        fechaIngreso: "2023-08-22",
        habilidades: ["SEO", "Analitica", "CRM"],
        direccion: { ciudad: "Santo Domingo", sector: "Piantini" }
      },
      {
        _id: "EMP-003",
        nombre: "Documento Duplicado",
        edad: 45,
        departamento: "Prueba",
        cargo: "Duplicado",
        salario: 1,
        activo: false,
        fechaIngreso: "2024-01-01",
        habilidades: ["Duplicado"],
        direccion: { ciudad: "Prueba", sector: "Prueba" }
      },
      {
        _id: "EMP-008",
        nombre: "Daniel Pina",
        edad: 31,
        departamento: "Tecnologia",
        cargo: "Administrador de Sistemas",
        salario: 70000,
        activo: true,
        fechaIngreso: "2021-12-01",
        habilidades: ["Linux", "Redes", "MongoDB"],
        direccion: { ciudad: "Santiago", sector: "Centro" }
      }
    ],
    { ordered: true }
  );
} catch (error) {
  print("Conflicto capturado por _id duplicado en insertMany ordenado.");
  printjson({
    name: error.name,
    code: error.code,
    message: error.message
  });
}
print("Estado despues del insertMany ordenado:");
printjson(db.empleados.find({ _id: { $in: ["EMP-007", "EMP-008"] } }, { _id: 1, nombre: 1 }).toArray());

print("\n3. insertMany() no ordenado con conflicto de _id");
print("Con ordered:false MongoDB reporta el duplicado, pero continua insertando los documentos validos.");
try {
  db.empleados.insertMany(
    [
      {
        _id: "EMP-009",
        nombre: "Patricia Gomez",
        edad: 30,
        departamento: "Finanzas",
        cargo: "Analista Financiera",
        salario: 66000,
        activo: true,
        fechaIngreso: "2022-03-15",
        habilidades: ["Presupuesto", "Excel", "Power BI"],
        direccion: { ciudad: "La Vega", sector: "Centro" }
      },
      {
        _id: "EMP-002",
        nombre: "Otro Duplicado",
        edad: 50,
        departamento: "Prueba",
        cargo: "Duplicado",
        salario: 1,
        activo: false,
        fechaIngreso: "2024-01-01",
        habilidades: ["Duplicado"],
        direccion: { ciudad: "Prueba", sector: "Prueba" }
      },
      {
        _id: "EMP-010",
        nombre: "Jose Medina",
        edad: 44,
        departamento: "Gerencia",
        cargo: "Gerente General",
        salario: 120000,
        activo: true,
        fechaIngreso: "2019-04-08",
        habilidades: ["Liderazgo", "Planificacion", "Finanzas"],
        direccion: { ciudad: "Santo Domingo", sector: "Bella Vista" }
      }
    ],
    { ordered: false }
  );
} catch (error) {
  print("Conflicto capturado por _id duplicado en insertMany no ordenado.");
  printjson({
    name: error.name,
    code: error.code,
    message: error.message
  });
}
print("Estado despues del insertMany no ordenado:");
printjson(db.empleados.find({ _id: { $in: ["EMP-009", "EMP-010"] } }, { _id: 1, nombre: 1 }).toArray());

print("\n4. Operadores de comparacion");
print("Salario mayor que 65000 ($gt):");
printjson(db.empleados.find({ salario: { $gt: 65000 } }, { _id: 1, nombre: 1, salario: 1 }).toArray());

print("Edad menor o igual a 30 ($lte):");
printjson(db.empleados.find({ edad: { $lte: 30 } }, { _id: 1, nombre: 1, edad: 1 }).toArray());

print("Departamentos Tecnologia o Finanzas ($in):");
printjson(db.empleados.find({ departamento: { $in: ["Tecnologia", "Finanzas"] } }, { _id: 1, nombre: 1, departamento: 1 }).toArray());

print("Empleados cuyo departamento no es Tecnologia ($ne):");
printjson(db.empleados.find({ departamento: { $ne: "Tecnologia" } }, { _id: 1, nombre: 1, departamento: 1 }).toArray());

print("\n5. Operadores logicos");
print("$and: activos con salario mayor o igual a 70000");
printjson(db.empleados.find({ $and: [{ activo: true }, { salario: { $gte: 70000 } }] }, { _id: 1, nombre: 1, salario: 1, activo: 1 }).toArray());

print("$or: empleados de Ventas o Recursos Humanos");
printjson(db.empleados.find({ $or: [{ departamento: "Ventas" }, { departamento: "Recursos Humanos" }] }, { _id: 1, nombre: 1, departamento: 1 }).toArray());

print("$nor: no activos y no Tecnologia");
printjson(db.empleados.find({ $nor: [{ activo: true }, { departamento: "Tecnologia" }] }, { _id: 1, nombre: 1, departamento: 1, activo: 1 }).toArray());

print("$not: salarios que no son mayores que 90000");
printjson(db.empleados.find({ salario: { $not: { $gt: 90000 } } }, { _id: 1, nombre: 1, salario: 1 }).toArray());

print("\n6. Evidencia del contenido final de la coleccion");
print("Total final:");
printjson(db.empleados.countDocuments());
printjson(db.empleados.find({}, { _id: 1, nombre: 1, departamento: 1, salario: 1, activo: 1 }).sort({ _id: 1 }).toArray());

print("\nPractica finalizada. Se evidencio mongoimport, insertOne, insertMany, ordered:true, ordered:false y consultas con operadores.");
