# Unidad 3 - Practica No. 2 - Empleado

## Objetivo

Aplicar tecnicas de importacion e insercion masiva de documentos en MongoDB, comprendiendo el comportamiento de `_id`, `insertMany()` y las inserciones ordenadas.

## Entrega solicitada

- Script de importacion.
- Sentencias de insercion.
- Evidencia del contenido final de la coleccion.
- Captura del resultado cuando se produce el conflicto de `_id`.

## Archivos preparados

- `dataset/empleados.json`: dataset en formato JSON Array para importar con `mongoimport`.
- `run-unidad3-practica2-docker.sh`: script de importacion y ejecucion con Docker.
- `Concepcion_Unidad3_Practica2_Empleado.js`: sentencias de insercion, conflicto de `_id` y consultas con operadores.
- `Concepcion_Unidad3_Practica2_Empleado.txt`: resumen de la practica y comandos.

## Comando de ejecucion

```bash
docker start mongodb-uasd
cd /PATH/BaseDatosMACDIA2026/BasedeDatosII/Unidad3/PracticaMongoDB
./run-unidad3-practica2-docker.sh
```

## Conexion para Compass

```text
mongodb://127.0.0.1:*******
```

## Lo solicitado y como se cumplio

| Requisito | Cumplimiento |
|---|---|
| Script de importacion. | `run-unidad3-practica2-docker.sh` usa `mongoimport` para cargar `dataset/empleados.json`. |
| Sentencias de insercion. | `Concepcion_Unidad3_Practica2_Empleado.js` contiene `insertOne()` e `insertMany()`. |
| Evidencia final. | El script imprime el total final y los documentos ordenados por `_id`. |
| Conflicto de `_id`. | Se intenta insertar un documento con `_id` repetido y se captura el error de MongoDB. |
| Inserciones ordenadas. | Se demuestra `ordered:true`, donde la insercion se detiene al encontrar el duplicado. |
| Inserciones no ordenadas. | Se demuestra `ordered:false`, donde MongoDB continua insertando los documentos validos. |
| Operadores. | Se ejecutan consultas con `$gt`, `$lte`, `$in`, `$ne`, `$and`, `$or`, `$nor` y `$not`. |
