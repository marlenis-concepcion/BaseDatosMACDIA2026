# Unidad 6 - Practica No. 5 y Proyecto Final MongoDB

## Objetivo

Aplicar capacidades avanzadas de MongoDB con datos GeoJSON, indices geoespaciales, aggregation pipelines y backup.

## Fuente

La practica utiliza el paquete `MongoDB_Final_Project_Package.zip` de la unidad final como referencia y recurso base.

## Comandos

```bash
docker start mongodb-uasd
cd /PATH/BaseDatosMACDIA2026/BasedeDatosII/Unidad6/PracticaMongoDB
./run-unidad6-practica5-docker.sh
./run-unidad6-backup-docker.sh
```

## Archivos

- `MongoDB_Final_Project_Package.zip`: paquete original del proyecto final.
- `Concepcion_Unidad6_Practica5_GeoFinal.js`: script MongoDB completo.
- `run-unidad6-practica5-docker.sh`: runner de la practica.
- `run-unidad6-backup-docker.sh`: runner de backup.
- `Concepcion_Unidad6_Practica5_GeoFinal.txt`: resumen y comandos.
- `dataset/places.geojson`: dataset geoespacial de referencia.

## Cumplimiento

| Requisito | Cumplimiento |
|---|---|
| GeoJSON. | `lugares.location` usa `{ type: "Point", coordinates: [lng, lat] }`. |
| Indice geoespacial. | Se crea `idx_location_2dsphere`. |
| Consulta geoespacial. | Se ejecutan `$near` y `$geoWithin`. |
| Aggregation pipeline. | Se usan `$group`, `$sort`, `$lookup`, `$unwind` y `$project`. |
| Backup. | `run-unidad6-backup-docker.sh` ejecuta `mongodump` y copia el backup local. |
| Proyecto final. | Integra modelado, referencias, geoespacial, aggregation y respaldo. |
