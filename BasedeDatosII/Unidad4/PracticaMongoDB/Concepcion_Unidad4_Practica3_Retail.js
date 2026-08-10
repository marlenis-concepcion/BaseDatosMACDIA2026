// Universidad Autonoma de Santo Domingo
// Base de Datos II - Unidad 4
// Practica No. 3 - Retail
// Objetivo: construir consultas MongoDB sobre estructuras JSON complejas,
// combinando filtros, documentos embebidos, arrays y operadores.
// Estudiante: Marlenis Concepcion
// Docente: Bismark Montero

use("retail");

print("\n============================================================");
print("Practica No. 3 - Retail");
print("Base de datos: retail");
print("Coleccion: ventas");
print("============================================================\n");

print("Dataset cargado:");
printjson(db.ventas.find({}, { _id: 1, tienda: 1, canal: 1, total: 1, estado: 1 }).sort({ _id: 1 }).toArray());

print("\nConsulta 1 - $exists y $type");
print("Ventas que tienen documento envio y cuyo total es numerico.");
printjson(
  db.ventas.find(
    {
      envio: { $exists: true, $type: "object" },
      total: { $type: "number" }
    },
    { _id: 1, tienda: 1, total: 1, envio: 1 }
  ).sort({ _id: 1 }).toArray()
);

print("\nConsulta 2 - $regex sobre documento embebido");
print("Clientes cuyo nombre comienza con A, C o R.");
printjson(
  db.ventas.find(
    { "cliente.nombre": { $regex: "^(Ana|Carlos|Rosa)", $options: "i" } },
    { _id: 1, "cliente.nombre": 1, "cliente.ciudad": 1, total: 1 }
  ).sort({ _id: 1 }).toArray()
);

print("\nConsulta 3 - $elemMatch en array de documentos");
print("Ventas con un producto de tecnologia cuyo precio es mayor o igual a 14000.");
printjson(
  db.ventas.find(
    {
      productos: {
        $elemMatch: {
          categoria: "tecnologia",
          precio: { $gte: 14000 }
        }
      }
    },
    { _id: 1, tienda: 1, productos: 1, total: 1 }
  ).sort({ _id: 1 }).toArray()
);

print("\nConsulta 4 - $all y $size en arrays");
print("Ventas que usaron tarjeta y puntos, y tienen exactamente dos cupones.");
printjson(
  db.ventas.find(
    {
      pagos: { $all: ["tarjeta", "puntos"] },
      cupones: { $size: 2 }
    },
    { _id: 1, cliente: 1, pagos: 1, cupones: 1 }
  ).sort({ _id: 1 }).toArray()
);

print("\nConsulta 5 - $expr, $mod, $and y documento anidado");
print("Ventas pagadas, de cliente premium, con total par y total mayor que edad del cliente multiplicada por 300.");
printjson(
  db.ventas.find(
    {
      $and: [
        { estado: "pagada" },
        { "cliente.tipo": "premium" },
        { total: { $mod: [2, 0] } },
        { $expr: { $gt: ["$total", { $multiply: ["$cliente.edad", 300] }] } }
      ]
    },
    { _id: 1, "cliente.nombre": 1, "cliente.tipo": 1, "cliente.edad": 1, total: 1, estado: 1 }
  ).sort({ _id: 1 }).toArray()
);

print("\nResumen final");
print("Total de ventas en la coleccion:");
printjson(db.ventas.countDocuments());
print("Se ejecutaron cinco consultas avanzadas sobre documentos embebidos y arrays.");
