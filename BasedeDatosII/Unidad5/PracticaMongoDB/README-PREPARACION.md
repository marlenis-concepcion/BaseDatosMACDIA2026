# Unidad 5 - Practica No. 4 - Modelado

## Objetivo

Aplicar modelado embebido y referenciado en MongoDB, justificar la cardinalidad, demostrar consultas con `$lookup` y crear una coleccion con validacion de esquema.

## Entrega solicitada

- Escenario con relacion embebida y justificacion.
- Escenario con relacion referenciada y justificacion.
- Documentos JSON usados.
- Consulta de demostracion para cada modelo.
- `$lookup` entre colecciones relacionadas.
- Schema Validation con insercion valida e invalida.

## Comando de ejecucion

```bash
docker start mongodb-uasd
cd /PATH/BaseDatosMACDIA2026/BasedeDatosII/Unidad5/PracticaMongoDB
./run-unidad5-practica4-docker.sh
```

## Archivos

- `Concepcion_Unidad5_Practica4_Modelado.js`: script completo.
- `run-unidad5-practica4-docker.sh`: runner con Docker.
- `Concepcion_Unidad5_Practica4_Modelado.txt`: resumen y comandos.

## Cumplimiento

| Requisito | Cumplimiento |
|---|---|
| Relacion embebida. | `usuarios` contiene `perfil` y `direcciones` embebidas. |
| Cardinalidad embebida. | `perfil` es 1:1 y `direcciones` es 1:N. |
| Relacion referenciada. | `publicaciones` referencia `usuarios` y `etiquetas`. |
| Cardinalidad referenciada. | Usuario-publicaciones es 1:N; publicaciones-etiquetas es N:M. |
| `$lookup`. | Se ejecutan dos consultas: publicaciones con autor y publicaciones con etiquetas. |
| Schema Validation. | `inscripciones` exige `estudiante`, `asignatura` y `periodo`. |
| Insercion invalida. | El script intenta insertar un documento incorrecto y MongoDB lo rechaza. |
