# Proyecto BD: Accidentes automovilísticos en México

## Fuente de datos

Para este proyecto se utilizan datos proporcionados por el portal de datos
del gobierno de México sobre hechos de tránsito. Se puede acceder a los datos en
[link](https://datos.cdmx.gob.mx/dataset/a9afdb1b-80ed-4f6c-a34a-0200211e527e/resource/0555dd20-d921-4f76-aa8c-1a0689f48bce/download/nuevo_acumulado_hechos_de_transito_2023_12.csv).
[link para descargar](https://datos.cdmx.gob.mx/dataset/a9afdb1b-80ed-4f6c-a34a-0200211e527e/resource/0555dd20-d921-4f76-aa8c-1a0689f48bce/download/nuevo_acumulado_hechos_de_transito_2023_12.csv).

## Carga inicial de datos

Para insertar los datos en bruto se debe primero correr el script `data_schema_creation.sql` y posteriormente
ejecutar el siguiente comando en una sesión de línea de comandos de Postgres.

```{postgresql}
\copy 
    raw.food_inspections (inspection_id, dba_name, aka_name, license_number, facility_type, risk, address, city, state, zip, inspection_date, inspection_type, results, violations, latitude, longitude, location)
    FROM 'path_to_downloaded_csv' 
    WITH (FORMAT CSV, HEADER true, DELIMITER ',');
```

## Limpieza de datos

El proceso de limpieza sigue una metodología de refresh destructiuvo, por lo que cada vez que se corra se generará desde
cero el esquema y las tablas correspondientes. El script correspondiente es el llamado: ```data_cleaning.sql```.
