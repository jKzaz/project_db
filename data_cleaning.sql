-- A. Delete unnecessary columns
ALTER TABLE proyecto.accidentes
DROP COLUMN punto_1,
DROP COLUMN punto_2,
DROP COLUMN colonia,
DROP COLUMN zona_vial,
DROP COLUMN unidad_a_cargo,
DROP COLUMN sentido_circulacion,
DROP COLUMN prioridad,
DROP COLUMN trasladado_lesionados,
DROP COLUMN fecha_captura;

-- B. Convert columns 'fecha' and 'hora_evento' into timestamp
-- Delete rows without 'hora_evento'
UPDATE proyecto.accidentes
SET hora_evento = '00:00:00'
WHERE hora_evento = 'NA';

-- Convert 'fecha_evento' to date type 
ALTER TABLE proyecto.accidentes
ADD COLUMN nueva_fecha DATE;

UPDATE proyecto.accidentes
SET nueva_fecha = TO_DATE(fecha_evento, 'DD/MM/YYYY');

ALTER TABLE proyecto.accidentes
DROP COLUMN fecha_evento;

-- Convert 'hora_evento' to time type 
ALTER TABLE proyecto.accidentes
ADD COLUMN nuevo_tiempo TIME;

UPDATE proyecto.accidentes
SET nuevo_tiempo = hora_evento::TIME;

ALTER TABLE proyecto.accidentes
DROP COLUMN hora_evento;

-- Define new column for the timestamp and delete other two 
ALTER TABLE proyecto.accidentes
ADD COLUMN fecha TIMESTAMP;

UPDATE proyecto.accidentes
SET fecha = CAST(nueva_fecha || ' ' || nuevo_tiempo AS TIMESTAMP);

ALTER TABLE proyecto.accidentes
DROP COLUMN nueva_fecha,
DROP COLUMN nuevo_tiempo;


-- C. Change columns
--- Convert to numeric type
ALTER TABLE proyecto.accidentes
ADD COLUMN nueva_longitud NUMERIC,
ADD COLUMN nueva_latitud NUMERIC;

DELETE FROM proyecto.accidentes
WHERE latitud='NA' or longitud='NA';

UPDATE proyecto.accidentes
SET nueva_longitud = CAST(longitud AS NUMERIC),
    nueva_latitud = CAST(latitud AS NUMERIC);

ALTER TABLE proyecto.accidentes
DROP COLUMN longitud,
DROP COLUMN latitud;

--- Convert to integer type
ALTER TABLE proyecto.accidentes
ALTER COLUMN personas_fallecidas TYPE INTEGER USING personas_fallecidas::INTEGER,
ALTER COLUMN personas_lesionadas TYPE INTEGER USING personas_lesionadas::INTEGER;

-- Add PK restriction
ALTER TABLE proyecto.accidentes ADD PRIMARY KEY (folio);


-- D. Super data cleaner
-- About 'tipo_evento'
UPDATE proyecto.accidentes
SET tipo_evento = INITCAP(tipo_evento),
    alcaldia = INITCAP(alcaldia),
    sector = INITCAP(sector),
    tipo_interseccion = INITCAP(tipo_interseccion),
    interseccion_semaforizada = INITCAP(interseccion_semaforizada),
    clasificacion_vialidad = INITCAP(clasificacion_vialidad),
    origen = INITCAP(origen),
    unidad_medica_de_apoyo=INITCAP(unidad_medica_de_apoyo);

-- About 'sector'
UPDATE proyecto.accidentes
SET sector = 
    CASE 
        WHEN sector ILIKE '%basto%' THEN 'Abastos Reforma'
        WHEN sector ILIKE '%Basto%' THEN 'Abastos Reforma'
        WHEN sector ILIKE '%Taxque%' THEN 'Taxquena'
        WHEN sector ILIKE '%Coyoa%' THEN 'Coyoacan'
        WHEN sector ILIKE '%Rosa%' THEN 'Zona Rosa'
        WHEN sector ILIKE '%Azcapotzalco%' THEN 'Azcapotzalco'
        WHEN sector ILIKE '%Merced%' THEN 'Merced Balbuena'
        WHEN sector ILIKE '%Alvaro Obregon%' THEN 'Alvaro Obregon'
        WHEN sector ILIKE '%Iztapalapa%' THEN 'Iztapalapa'
        WHEN sector ILIKE '%Cuauhtemoc%' THEN 'Cuauhtemoc'
        WHEN sector ILIKE '%Iztapalapa%' THEN 'Iztapalapa'
        ELSE sector
    END;

DELETE FROM proyecto.accidentes
WHERE sector = 'M' or sector='Sd';

-- About 'interseccion_semaforizada' and 'clasificacion_vialidad'
DELETE FROM proyecto.accidentes
WHERE interseccion_semaforizada='NA' or clasificacion_vialidad='NA';

-- About 'origen'
UPDATE proyecto.accidentes
SET origen = 
    CASE 
        WHEN origen ILIKE '%Aux%' THEN 'Boton de Auxilio'
        WHEN origen ILIKE '%911%' THEN 'Llamada del 911'
        WHEN origen ILIKE '%089%' THEN 'Llamada del 089'
        WHEN origen ILIKE '%poli%' THEN 'Policia'
        WHEN origen ILIKE '%redes%' THEN 'Redes sociales'
        WHEN origen ILIKE '%calle%' THEN 'Mi calle'
        WHEN origen ILIKE '%mara%' THEN 'Camara'
        WHEN origen ILIKE '%rum%' THEN 'ERUM'
        ELSE origen
    END;

DELETE FROM proyecto.accidentes
WHERE origen='Pm' or origen='Na' or origen='Sd' or origen='SÃ¡Bado';

-- About 'matricula_unidad_medica'
DELETE FROM proyecto.accidentes
WHERE matricula_unidad_medica='NA';

-- Aboout 'dia'
UPDATE proyecto.accidentes
SET dia = 
    CASE 
        WHEN dia ILIKE '%Mi%' THEN 'Miercoles'
        WHEN dia ILIKE '%bado%' THEN 'Sabado'
        ELSE dia   
    END;

-- Aqui falta borrar los tipos de dia que sobre, rifenselo. 
-- resta unidad mediad
