# Proyecto BD: Accidentes automovilísticos en México

## Fuente de datos

Para este proyecto se utilizan datos proporcionados por el portal de datos
del gobierno de México sobre hechos de tránsito. Se puede acceder a los datos en
[link](https://datos.cdmx.gob.mx/dataset/hechos-de-transito-reportados-por-ssc-base-ampliada-no-comparativa) o 
[link to download](https://datos.cdmx.gob.mx/dataset/a9afdb1b-80ed-4f6c-a34a-0200211e527e/resource/0555dd20-d921-4f76-aa8c-1a0689f48bce/download/nuevo_acumulado_hechos_de_transito_2023_12.csv).

## Carga inicial de datos

Para insertar los datos en bruto se debe primero correr el script `data_schema_creation.sql` y posteriormente
ejecutar el siguiente comando en una sesión de línea de comandos de Postgres.

```{postgresql}
\copy
    proyecto.accidentes (fecha_evento, hora_evento, tipo_evento, fecha_captura, folio, latitud, longitud, punto_1, punto_2, colonia, alcaldia, zona_vial, sector, unidad_a_cargo, tipo_interseccion, interseccion_semaforizada, clasificacion_vialidad, sentido_circulacion, dia, prioridad, origen, unidad_medica_de_apoyo, matricula_unidad_medica, trasladado_lesionados, personas_fallecidas, personas_lesionadas)

    FROM 'path_to_file.csv'
    WITH (FORMAT CSV, HEADER TRUE, DELIMITER ',', ENCODING 'ISO-8859-1');
```

## Limpieza de datos

El proceso de limpieza sigue una metodología de refresh destructiuvo, por lo que cada vez que se corra se generará desde
cero el esquema y las tablas correspondientes. El script correspondiente es el llamado: ```data_cleaning.sql```.
