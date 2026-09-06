// Universidad Autónoma de Santo Domingo
// Base de Datos II - Práctica N.º 5: cineMovie
// Estudiante: Marlenis Concepción
// Docente: Bismark Montero
// Preparación repetible: reemplaza SOLO mv201 a mv208 en cineMovie.Movie02.
// Ejecutar el archivo completo una vez por demostración.
db = db.getSiblingDB("cineMovie");
const idsPractica = Array.from({ length: 8 }, (_, i) => "mv" + (201 + i));
if (db.Movie02.countDocuments({ movieID: { $nin: idsPractica } }) > 0) {
  throw new Error("Movie02 contiene datos ajenos a la práctica. Utilice una base de práctica vacía.");
}
db.Movie02.deleteMany({ movieID: { $in: idsPractica } });
print("Carga inicial: siete películas");
db.Movie02.insertMany([
    {
        "movieID": "mv201",
        "title": "Star Wars",
        "runtime": 121,
        "voteAverage": 8.1,
        "dateRelease": new Date("1997-03-27"),
        "dateExpired": new Date("2020-01-01"),
        "lastView": new Date("2010-06-01"),
        "isView": false,
        "productionCompany": [
            {
                "name": "Twentieth Century Fox Film Corporation",
                "country": "United States"
            }
        ]
    },
    {
        "movieID": "mv202",
        "title": "Pirates of the Caribbean: The Curse of the Black Pearl",
        "runtime": 111,
        "voteAverage": 7.7,
        "dateRelease": new Date("2003-07-09"),
        "dateExpired": new Date("2015-12-01"),
        "lastView": new Date("2009-08-01"),
        "isView": false,
        "productionCompany": [
            {
                "name": "Walt Disney Pictures",
                "country": "United States"
            },
            {
                "name": "Jerry Bruckheimer Films",
                "country": "United States"
            }
        ]
    },
    {
        "movieID": "mv203",
        "title": "The Simpsons Movie",
        "runtime": 87,
        "voteAverage": 6.9,
        "dateRelease": new Date("2007-07-26"),
        "dateExpired": new Date("2018-06-06"),
        "lastView": new Date("2014-02-15"),
        "isView": false,
        "productionCompany": [
            {
                "name": "Gracie Films",
                "country": "United States"
            },
            {
                "name": "Twentieth Century Fox Film Corporation",
                "country": "United States"
            }
        ]
    },
    {
        "movieID": "mv204",
        "title": "Gladiator",
        "runtime": 155,
        "voteAverage": 7.9,
        "dateRelease": new Date("2000-06-01"),
        "dateExpired": new Date("2020-03-14"),
        "lastView": new Date("2017-01-20"),
        "isView": false,
        "productionCompany": [
            {
                "name": "Universal Pictures",
                "country": "United States"
            },
            {
                "name": "DreamWorks SKG",
                "country": "United States"
            },
            {
                "name": "Scott Free Productions",
                "country": "United Kingdom"
            }
        ]
    },
    {
        "movieID": "mv205",
        "title": "Charlie and the Chocolate Factory",
        "runtime": 115,
        "voteAverage": 6.7,
        "dateRelease": new Date("2005-07-27"),
        "dateExpired": new Date("2028-09-14"),
        "lastView": new Date("2022-04-14"),
        "isView": false,
        "productionCompany": [
            {
                "name": "Village Roadshow Pictures",
                "country": "United States"
            },
            {
                "name": "The Zanuck Company",
                "country": "United States"
            }
        ]
    },
    {
        "movieID": "mv206",
        "title": "Saw III",
        "runtime": 108,
        "voteAverage": 6.1,
        "dateRelease": new Date("2006-10-27"),
        "dateExpired": new Date("2024-08-01"),
        "lastView": new Date("2019-09-01"),
        "isView": false,
        "productionCompany": [
                "Lions Gate Films",
                "Got Films",
                "Twisted Pictures"
        ]
    },
    {
        "movieID": "mv207",
        "title": "Indiana Jones",
        "runtime": 162
    }
]);
function mostrar() {
  printjson(db.Movie02.find({}, { _id: 0 }).sort({ movieID: 1 }).toArray());
}
mostrar();

// 1. Reemplazar la película mv207
// replaceOne sustituye el documento completo y conserva su _id. Se transcribe literalmente la segunda productora del enunciado, aunque contiene un nombre vacío y un país aparentemente mal escrito.
print("\n1. Reemplazar la película mv207");
db.Movie02.replaceOne({ movieID: "mv207" }, {
  movieID: "mv207",
  title: "Indiana Jones and the Kingdom of the Crystal Skull",
  runtime: 162, voteAverage: 7.2,
  dateRelease: new Date("2008-05-21"),
  dateExpired: new Date("2027-05-21"),
  lastView: new Date("2023-09-15"), isView: false,
  productionCompany: [
    { name: "Lucasfilm", country: "United States" },
    { name: "", country: "UnitedParamount Pictures States" }
  ]
});
mostrar();

// 2. Actualizar las productoras de mv206
// Se reemplaza el arreglo de cadenas por un arreglo de documentos con nombre y país.
print("\n2. Actualizar las productoras de mv206");
db.Movie02.updateOne({ movieID: "mv206" }, { $set: {
  productionCompany: [
    { name: "Lions Gate Films", country: "United States" },
    { name: "Got Films", country: "United States" },
    { name: "Twisted Pictures", country: "United States" }
  ]
} });
mostrar();

// 3. Agregar los idiomas
// Se representan los dos idiomas como elementos de un arreglo en las siete películas.
print("\n3. Agregar los idiomas");
db.Movie02.updateMany({}, { $set: { idioma: ["English", "Spanish"] } });
mostrar();

// 4. Disminuir la valoración y agregar el impuesto
// Se necesitan dos actualizaciones: la disminución afecta solo a mv203, mv205 y mv206; el impuesto se agrega a todas las películas.
print("\n4. Disminuir la valoración y agregar el impuesto");
db.Movie02.updateMany({ voteAverage: { $lt: 7 } }, { $inc: { voteAverage: -1 } });
db.Movie02.updateMany({}, { $set: { "%tax": 0.1 } });
mostrar();

// 5. Limitar la fecha de estreno
// mv207 cambia del 21 al 1 de mayo de 2008. El filtro selecciona únicamente fechas superiores al límite.
print("\n5. Limitar la fecha de estreno");
db.Movie02.updateMany(
  { dateRelease: { $gt: new Date("2008-05-01") } },
  { $min: { dateRelease: new Date("2008-05-01") } }
);
mostrar();

// 6. Establecer una fecha mínima de vencimiento
// mv202 cambia de 2015-12-01 a 2016-12-01.
print("\n6. Establecer una fecha mínima de vencimiento");
db.Movie02.updateMany(
  { dateExpired: { $lt: new Date("2016-12-01") } },
  { $max: { dateExpired: new Date("2016-12-01") } }
);
mostrar();

// 7. Multiplicar el impuesto por dos
// El impuesto pasa de 0.1 a 0.2 en las siete películas.
print("\n7. Multiplicar el impuesto por dos");
db.Movie02.updateMany({}, { $mul: { "%tax": 2 } });
mostrar();

// 8. Renombrar los campos
// Los valores se conservan con los nuevos nombres.
print("\n8. Renombrar los campos");
db.Movie02.updateMany({}, { $rename: {
  idioma: "language", "%tax": "percentTax"
} });
mostrar();

// 9. Eliminar los campos indicados
// Se eliminan los tres campos en las siete películas.
print("\n9. Eliminar los campos indicados");
db.Movie02.updateMany({}, { $unset: {
  productionCompany: "", language: "", percentTax: ""
} });
mostrar();

// 10. Actualizar la última visualización
// lastView recibe la fecha y hora de ejecución como BSON Date; isView queda en true.
print("\n10. Actualizar la última visualización");
db.Movie02.updateMany({}, {
  $currentDate: { lastView: { $type: "date" } },
  $set: { isView: true }
});
mostrar();

// 11. Insertar King Kong solo si no existe
// upsert inserta el documento cuando no existe; $setOnInsert conserva una película ya existente. Se utiliza movieID, respetando las mayúsculas del campo real. Como se inserta después del paso 10, King Kong mantiene isView: false y su lastView original.
print("\n11. Insertar King Kong solo si no existe");
db.Movie02.updateOne({ movieID: "mv208" }, {
  $setOnInsert: {
    movieID: "mv208", title: "King Kong", runtime: 187, voteAverage: 6.6,
    dateRelease: new Date("2005-12-15"),
    dateExpired: new Date("2030-01-01"),
    lastView: new Date("2023-08-01"), isView: false
  }
}, { upsert: true });
mostrar();

// Comprobaciones del resultado final.
function verificar(condicion, mensaje) {
  if (!condicion) throw new Error("VERIFICACIÓN FALLIDA: " + mensaje);
  print("OK: " + mensaje);
}
verificar(db.Movie02.countDocuments({}) === 8, "Ocho películas al finalizar");
verificar(db.Movie02.countDocuments({ movieID: { $ne: "mv208" }, isView: true, lastView: { $type: "date" } }) === 7, "Siete películas vistas con fecha BSON Date");
verificar(db.Movie02.countDocuments({ $or: [
  { productionCompany: { $exists: true } }, { idioma: { $exists: true } },
  { language: { $exists: true } }, { "%tax": { $exists: true } },
  { percentTax: { $exists: true } }
] }) === 0, "Campos temporales eliminados");
for (const [id, esperado] of [["mv203", 5.9], ["mv205", 5.7], ["mv206", 5.1]]) {
  verificar(Math.abs(db.Movie02.findOne({ movieID: id }).voteAverage - esperado) < 1e-9, "Valoración de " + id);
}
verificar(db.Movie02.findOne({ movieID: "mv207" }).dateRelease.toISOString() === "2008-05-01T00:00:00.000Z", "Estreno de mv207");
verificar(db.Movie02.findOne({ movieID: "mv202" }).dateExpired.toISOString() === "2016-12-01T00:00:00.000Z", "Vencimiento de mv202");
verificar(db.Movie02.findOne({ movieID: "mv208" }).isView === false, "King Kong conserva isView false");
print("Práctica terminada: cineMovie.Movie02");
