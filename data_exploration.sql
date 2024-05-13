-- 1.
SELECT * 
FROM desarrollo.evento;


-- 2.
SELECT MIN(fecha) fecha_inicio, MAX(fecha) fecha_fin, 
		SUM(personas_fallecidas) AS total_fallecidos, SUM(personas_lesionadas) AS total_lesionados
FROM desarrollo.evento;


-- 3.
SELECT l.alcaldia, COUNT(*) cantidad_eventos
FROM desarrollo.evento e
INNER JOIN desarrollo.lugar l ON e.lugar_id = l.id
GROUP BY l.alcaldia
ORDER BY cantidad_eventos DESC;


-- 4.
WITH CTE as ( 
	SELECT tipo_evento, COUNT(*) AS total_eventos
	FROM desarrollo.evento e 
	INNER JOIN desarrollo.lugar l ON e.lugar_id = l.id
	GROUP BY tipo_evento
	ORDER BY total_eventos DESC
)
SELECT *
FROM CTE
WHERE total_eventos = (SELECT MAX(total_eventos) FROM CTE);


-- 5.
SELECT *
FROM desarrollo.evento
WHERE fecha BETWEEN '2021-03-10' AND '2021-05-10'
ORDER BY fecha;


-- 6.
SELECT DISTINCT
    AVG(personas_fallecidas) OVER () AS promedio_fallecidos,
    AVG(personas_lesionadas) OVER () AS promedio_lesionados
FROM desarrollo.evento;


-- 7.
SELECT
    e.*,
    MAX(personas_fallecidas) OVER () AS max_fallecidos,
    MAX(personas_lesionadas) OVER () AS max_lesionados
FROM desarrollo.evento e;


-- 8.
SELECT *,
     COUNT(*) OVER (PARTITION BY origen) AS cantidad_eventos_por_origen
FROM desarrollo.evento;


-- 9.
SELECT
    origen,
    COUNT(*) AS cantidad_eventos,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking_eventos_por_origen
FROM desarrollo.evento
GROUP BY origen;


-- 10.
SELECT
    fecha,
    personas_fallecidas,
    LAG(personas_fallecidas) OVER (ORDER BY fecha) AS fallecidos_evento_anterior,
    personas_lesionadas,
    LAG(personas_lesionadas) OVER (ORDER BY fecha) AS lesionados_evento_anterior
FROM desarrollo.evento;

-- 11.
SELECT
    *,
    SUM(personas_fallecidas) OVER () AS total_fallecidos,
    SUM(personas_lesionadas) OVER () AS total_lesionados
FROM desarrollo.evento;
