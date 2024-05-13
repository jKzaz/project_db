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
DROP COLUMN fecha_captura,
DROP COLUMN unidad_medica_de_apoyo;    

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


-- D. Super data cleaner
-- About folio
DELETE FROM proyecto.accidentes
WHERE folio in (
	SELECT folio FROM proyecto.accidentes
	GROUP BY folio
	HAVING COUNT(*) > 1
);

ALTER TABLE proyecto.accidentes ADD PRIMARY KEY (folio);

-- About text columns
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
        WHEN sector ILIKE '%Absto%' THEN 'Abastos Reforma'
        WHEN sector ILIKE '%Taxque%' THEN 'Taxquena'
        WHEN sector ILIKE '%Coyoa%' THEN 'Coyoacan'
        WHEN sector ILIKE '%Rosa%' THEN 'Zona Rosa'
        WHEN sector ILIKE '%Azcapotzalco%' THEN 'Azcapotzalco'
        WHEN sector ILIKE '%Merced%' THEN 'Merced Balbuena'
        WHEN sector ILIKE '%Alvaro Obregon%' THEN 'Alvaro Obregon'
        WHEN sector ILIKE '%Iztapalapa%' THEN 'Iztapalapa'
        WHEN sector ILIKE '%Cuauhtemoc%' THEN 'Cuauhtemoc'
        WHEN sector ILIKE '%Iztapalapa%' THEN 'Iztapalapa'
        WHEN sector ILIKE '%Alamo%' THEN 'Alamos'
        WHEN sector ILIKE '%Alameda%' THEN 'Alameda Revolucion'
        WHEN sector ILIKE '%Cuauhtemoc%' THEN 'Cuauhtemoc'
        WHEN sector ILIKE '%Agel%' THEN 'Angel'
        WHEN sector ILIKE '%Del Vale%' THEN 'Del Valle'
		WHEN sector ILIKE '%Estrela%' THEN 'Estrella Torre'        
        WHEN sector ILIKE '%Estrella%' THEN 'Estrella Torre'		
        WHEN sector ILIKE '%Granja%' THEN 'Granjas'
        WHEN sector ILIKE '%Grnajas%' THEN 'Granjas'
        WHEN sector ILIKE '%Madero%' THEN 'Gustavo Madero'
        WHEN sector ILIKE '%Huipulco%' THEN 'Huipulco'
        WHEN sector ILIKE '%Hospitales%' THEN 'Huipulco'
        WHEN sector ILIKE '%Iztac%' THEN 'Iztaccihuatl'
        WHEN sector ILIKE '%Mixcalco%' THEN 'Mixcalco'
        WHEN sector ILIKE '%ixqui%' THEN 'Mixcoac'
        WHEN sector ILIKE '%orelos%' THEN 'Morelos'
        WHEN sector ILIKE '%Narva%' THEN 'Narvarte Alamos'
        WHEN sector ILIKE '%Nativitas%' THEN 'Navitas'
        WHEN sector ILIKE '%Patitlan%' THEN 'Pantitlan'
        WHEN sector ILIKE '%Nativitas%' THEN 'Navitas'        
        WHEN sector ILIKE '%uxiliar%' THEN 'Policia Auxiliar'        
        WHEN sector ILIKE '%ezal%' THEN 'Quetzal'        
        WHEN sector ILIKE '%Revolucion/Alameda%' THEN 'Revolucion Alameda'  
        WHEN sector ILIKE '%Cruz%' THEN 'Santa Cruz'  
        WHEN sector ILIKE '%Sta Fe%' THEN 'Santa Fe'  
        WHEN sector ILIKE '%Tepeya%' THEN 'Tepeyac'  
        WHEN sector ILIKE '%Tepaya%' THEN 'Tepeyac' 
        WHEN sector ILIKE '%Tlacotal%' THEN 'Tlacoltal' 
        WHEN sector ILIKE '%lolco%' THEN 'Tlatelolco' 
        WHEN sector ILIKE '%Zapoti%' THEN 'Zapotitlan'
        WHEN sector ILIKE '%Fuente%' THEN 'Fuentes'
        WHEN sector ILIKE '%Izaccihuatl%' THEN 'Iztaccihuatl'
        WHEN sector ILIKE '%Izacihuatl%' THEN 'Iztaccihuatl'
        WHEN sector ILIKE '%Iztaccihuatl%' THEN 'Iztaccihuatl'
        WHEN sector ILIKE '%Portles%' THEN 'Portales'
        WHEN sector ILIKE '%Cuatepec%' THEN 'Cuautepec'
        WHEN sector ILIKE '%Cuauhtepec%' THEN 'Cuautepec'
        ELSE sector
    END;

DELETE FROM proyecto.accidentes
WHERE sector = 'M' or sector='Sd' or sector='Crum' or sector='Pbi' or sector='C5';

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

DELETE FROM proyecto.accidentes
WHERE dia='TaxqueÃ±a' or dia='TaxqueÃ±es' or dia='S<c3>Ã©rco' or dia='SiÃ©rco' or dia='1Â° de mayo' or dia='Calz taxqueÃ±a' or dia='CoruÃ±a' or dia='Ruben leÃ±ero';
