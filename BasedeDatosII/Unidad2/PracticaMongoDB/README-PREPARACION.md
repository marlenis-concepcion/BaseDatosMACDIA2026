# Unidad 2 - Practica No. 1 - Colegio

Carpeta de trabajo:

```text
/PATH/BaseDatosMACDIA2026/BasedeDatosII/Unidad2/PracticaMongoDB
```

## Objetivo

Aplicar operaciones CRUD sobre documentos MongoDB utilizando una estructura con documentos y arreglos anidados.

## Enunciado recibido

```text
Practica No. 1 - Colegio
Objetivo: Aplicar las operaciones CRUD sobre documentos MongoDB utilizando una estructura con documentos y arreglos anidados.
Todas las instrucciones utilizadas deberan ser conservadas como evidencia de la solucion.
```

## Entorno MongoDB disponible

Se uso Docker con el contenedor:

```text
mongodb-uasd
```

Conexion para MongoDB Compass:

```text
mongodb://127.0.0.1:*******
```

Comandos utiles:

```bash
docker start mongodb-uasd
docker stop mongodb-uasd
docker exec -it mongodb-uasd mongosh
```

## Archivos generados

- `Concepcion_Unidad2_Practica1_Colegio.js`: instrucciones MongoDB completas.
- `Concepcion_Unidad2_Practica1_Colegio.txt`: resumen de instrucciones y entrega.
- `run-unidad2-practica1-docker.sh`: ejecuta la practica en Docker.

## Comando para correr la practica y tomar captura

```bash
docker start mongodb-uasd
cd /PATH/BaseDatosMACDIA2026/BasedeDatosII/Unidad2/PracticaMongoDB
./run-unidad2-practica1-docker.sh
```

Para guardar la salida en un archivo de texto:

```bash
./run-unidad2-practica1-docker.sh | tee salida-unidad2-practica1.txt
```

## Lo que se cumplio

| Operacion | Cumplimiento |
|---|---|
| Create | Insercion de tres estudiantes originales con documentos y arreglos anidados. |
| Read | Consultas por estado activo, grado/seccion, ciudad, actividad y asignatura/calificacion. |
| Update | Cambio de estado activo, adicion de actividad y actualizacion de calificacion dentro de arreglo anidado. |
| Delete | Insercion y eliminacion controlada de un estudiante adicional. |

## Nota de seguridad

No subir capturas ni archivos con datos sensibles. Los documentos de evidencias finales deben permanecer locales si contienen rutas o informacion personal.
