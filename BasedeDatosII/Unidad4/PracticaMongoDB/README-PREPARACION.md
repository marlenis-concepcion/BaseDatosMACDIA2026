# Unidad 4 - Practica No. 3 - Retail

## Objetivo

Construir consultas MongoDB sobre estructuras JSON complejas, combinando filtros, documentos embebidos, arrays y operadores de comparacion y logicos.

## Entrega solicitada

- Script con las cinco consultas.
- Resultado obtenido para cada consulta.
- Breve explicacion del operador utilizado.

## Archivos preparados

- `dataset/ventas-retail.json`: dataset de ventas retail con documentos embebidos y arrays.
- `Concepcion_Unidad4_Practica3_Retail.js`: cinco consultas avanzadas con resultados impresos.
- `run-unidad4-practica3-docker.sh`: importa el dataset y ejecuta el script en Docker.
- `Concepcion_Unidad4_Practica3_Retail.txt`: resumen de la practica y comandos.

## Comando de ejecucion

```bash
docker start mongodb-uasd
cd /PATH/BaseDatosMACDIA2026/BasedeDatosII/Unidad4/PracticaMongoDB
./run-unidad4-practica3-docker.sh
```

## Conexion para Compass

```text
mongodb://127.0.0.1:*******
```

## Lo solicitado y como se cumplio

| Requisito | Cumplimiento |
|---|---|
| Script con cinco consultas. | El archivo `Concepcion_Unidad4_Practica3_Retail.js` contiene cinco consultas numeradas. |
| Resultado obtenido. | Cada consulta imprime su resultado con `printjson()`. |
| Explicacion del operador. | El informe y el archivo `.txt` explican el uso de cada operador. |
| Documentos embebidos. | Se consulta `cliente`, `envio` y subcampos como `cliente.tipo` y `cliente.edad`. |
| Arrays. | Se consulta `productos`, `pagos` y `cupones` usando operadores para arreglos. |
