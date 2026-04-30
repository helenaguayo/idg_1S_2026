-- Total de personas por comuna

SELECT c.nom_comuna, COUNT(*)
FROM public.personas AS p
JOIN public.hogares AS h
ON p.hogar_ref_id = h.hogar_ref_id
JOIN public.viviendas AS v
ON h.vivienda_ref_id = v.vivienda_ref_id
JOIN public.zonas AS z
ON v.zonaloc_ref_id = z.zonaloc_ref_id
JOIN public.comunas AS c
ON z.codigo_comuna = c.codigo_comuna
GROUP BY c.nom_comuna

-- Zona censal

SELECT z.geocodigo AS "Zona censal", c.nom_comuna AS "Comuna", COUNT(*) AS "Total de personas"
FROM public.personas AS p
JOIN public.hogares AS h
ON p.hogar_ref_id = h.hogar_ref_id
JOIN public.viviendas AS v
ON h.vivienda_ref_id = v.vivienda_ref_id
JOIN public.zonas AS z
ON v.zonaloc_ref_id = z.zonaloc_ref_id
JOIN public.comunas AS c
ON z.codigo_comuna = c.codigo_comuna
GROUP BY z.zonaloc_ref_id, c.nom_comuna

-- Población menor de edad por comuna

SELECT c.nom_comuna, COUNT(*) FILTER(WHERE p.p09<18) AS "Menores de edad", 
					COUNT(*) AS "Total población", 
					ROUND(((COUNT(*) FILTER(WHERE p.p09<18))*100.0/COUNT(*)),2) AS "Porcentaje de menores de edad"
FROM public.personas AS p
JOIN public.hogares AS h
ON p.hogar_ref_id = h.hogar_ref_id
JOIN public.viviendas AS v
ON h.vivienda_ref_id = v.vivienda_ref_id
JOIN public.zonas AS z
ON v.zonaloc_ref_id = z.zonaloc_ref_id
JOIN public.comunas AS c
ON z.codigo_comuna = c.codigo_comuna
GROUP BY c.nom_comuna

-- Tasa de profesionales por zona censal, ordenados de mayor a menor

SELECT z.geocodigo AS "Zona censal", c.nom_comuna AS "Comuna", 
ROUND(((COUNT(*) FILTER(WHERE(p.p15>=12 AND p.p15<=14)))*100.0/COUNT(*)),2) AS "Tasa de profesionales"
FROM public.personas AS p
JOIN public.hogares AS h
ON p.hogar_ref_id = h.hogar_ref_id
JOIN public.viviendas AS v
ON h.vivienda_ref_id = v.vivienda_ref_id
JOIN public.zonas AS z
ON v.zonaloc_ref_id = z.zonaloc_ref_id
JOIN public.comunas AS c
ON z.codigo_comuna = c.codigo_comuna
GROUP BY z.zonaloc_ref_id, c.nom_comuna

