WITH agg AS (
SELECT 
c.nom_comuna, 
z.geocodigo::DOUBLE PRECISION AS geocodigo,

ROUND((COUNT(*) FILTER (WHERE p.p15a = 1 AND p.p09 >= 15) * 100.0) / NULLIF(COUNT(*) FILTER (WHERE p.p09 >= 15), 0), 2) AS tasa_alfabetizacion,

ROUND((COUNT(*) FILTER (WHERE p.p09 <= 4) * 1000.0) / NULLIF(COUNT(*) FILTER (WHERE p.p08 = 2 AND p.p09 BETWEEN 15 AND 49), 0), 2) AS tasa_natalidad

FROM public.personas AS p
JOIN public.hogares AS h 
ON p.hogar_ref_id = h.hogar_ref_id
JOIN public.viviendas AS v 
ON h.vivienda_ref_id = v.vivienda_ref_id
JOIN public.zonas AS z 
ON v.zonaloc_ref_id = z.zonaloc_ref_id
JOIN public.comunas AS c 
ON z.codigo_comuna = c.codigo_comuna
JOIN public.provincias AS pr 
ON pr.provincia_ref_id = c.provincia_ref_id
WHERE pr.nom_provincia = 'MAIPO'
GROUP BY c.nom_comuna, z.geocodigo
)
SELECT a.*, shp.geom
FROM agg AS a
JOIN dpa.zonas_censales_rm AS shp 
ON shp.geocodigo = a.geocodigo;