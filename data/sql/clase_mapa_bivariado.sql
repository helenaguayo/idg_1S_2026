WITH agg AS
(
SELECT z.geocodigo::double precision AS geocodigo, c.nom_comuna,
ROUND(((COUNT(*) FILTER(WHERE p.p15>=12 AND p.p15<=14))*100.0/COUNT(*)),2) AS ptje_esc_mayor_16,
ROUND(((COUNT(*) FILTER(WHERE p.p12pais<>998))*100.0/COUNT(*)),2) AS ptje_migrantes
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
WHERE pr.nom_provincia = 'SAN ANTONIO'
GROUP BY z.zonaloc_ref_id, c.nom_comuna
)
SELECT a.*, shp.geom
FROM agg AS a
JOIN dpa.zonas_censales_v AS shp
ON shp.geocodigo = a.geocodigo;
