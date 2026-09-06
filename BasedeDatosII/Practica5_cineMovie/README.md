# Práctica N.º 5 — cineMovie

Estudiante: Marlenis Concepción. Docente: Bismark Montero.

La unidad no se especifica en las imágenes; se conserva esta práctica en una carpeta propia dentro de Base de Datos II.

## Ejecutar

Desde esta carpeta, con el contenedor de las demás prácticas disponible:

```bash
docker start mongodb-uasd
./run-practica5-cinemovie-docker.sh
```

Alternativa con MongoDB local:

```bash
mongosh "mongodb://127.0.0.1:27017" --file Concepcion_Practica5_cineMovie.js
```

En Compass: base `cineMovie`, colección `Movie02`. El script carga los datos; no es necesario importar antes. Para importar manualmente, usar `dataset/Movie02.json` (Extended JSON con fechas BSON), y ejecutar únicamente los pasos 1 a 11.

El script completo restaura los ocho identificadores de la práctica antes de comenzar, para permitir repetir la demostración sin acumular disminuciones de valoración. Rechaza colecciones con identificadores ajenos. Los pasos individuales 4 y 7 no deben repetirse sobre el mismo estado.

## Archivos

- [Informe PDF para entregar](Concepcion_Practica5_cineMovie.pdf).

- `Concepcion_Practica5_cineMovie.js`: carga, once ejercicios, consultas de evidencia y comprobaciones finales.
- `Concepcion_Practica5_cineMovie_Informe.html`: informe con portada UASD, desarrollo y enunciados; imprimible en PDF.
- `Concepcion_Practica5_cineMovie.txt`: explicación y comandos de los once ejercicios.
- `dataset/Movie02.json`: siete películas en Extended JSON importable.
- `dataset/Practica5-original.json`: adjunto original, cuya sintaxis `new Date` es JavaScript.
- `assets/evidencias/`: imágenes originales del enunciado.
- `run-practica5-cinemovie-docker.sh`: ejecución y registro real en `evidencias/ejecucion.txt`.

## Validación

Se comprobaron la sintaxis del script y la integridad del dataset. La ejecución contra MongoDB queda pendiente: este entorno no dispone de Docker ni mongosh. Los resultados del informe están identificados como esperados, no como evidencia de ejecución.
