-- Creating raw schema
DROP SCHEMA IF EXISTS proyecto CASCADE;
CREATE SCHEMA IF NOT EXISTS proyecto;

-- Creating table for raw data
DROP TABLE IF EXISTS proyecto.accidentes;
CREATE TABLE proyecto.accidentes (
	fecha_evento TEXT, 
	hora_evento TEXT,
	tipo_evento TEXT, 
	fecha_captura TEXT, 
	folio TEXT,
	latitud TEXT, 
	longitud TEXT, 
	punto_1 TEXT, 
	punto_2 TEXT, 
	colonia text, 
	alcaldia text, 
	zona_vial TEXT,
	sector text, 
	unidad_a_cargo text, 
	tipo_interseccion text, 
	interseccion_semaforizada text, 
	clasificacion_vialidad text, 
	sentido_circulacion text, 
	dia text, 
	prioridad text, 
	origen text, 
	unidad_medica_de_apoyo text, 
	matricula_unidad_medica text,
	trasladado_lesionados text, 
	personas_fallecidas text, 
	personas_lesionadas text
); 
