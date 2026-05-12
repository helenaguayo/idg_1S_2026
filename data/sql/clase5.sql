
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
CREATE TABLE output.menores_comuna AS
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
CREATE TABLE output.tasa_profesionales AS
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
ORDER BY "Tasa de profesionales" DESC

-- Unir la geometría a la tabla de profesionales
CREATE TABLE output.tot_prof_geom AS
SELECT shp.geocodigo::double precision, shp.geom, tp."Zona censal", nom_comuna, "Tasa de profesionales"
FROM output.tasa_profesionales AS tp
JOIN dpa.zonas_censales_v AS shp
ON tp."Zona censal"::double precision = shp.geocodigo


SELECT  ST_SRID(geom)
FROM output.tot_prof_geom

-- Porcentaje de viviendas hacinadas por zona censal
CREATE TABLE output.tasa_hacin AS
SELECT z.geocodigo AS "Zona censal", c.nom_comuna AS "Comuna",
ROUND(((COUNT(*) FILTER(WHERE ind_hacin_rec>=3))*100.0/COUNT(*)),2) AS "Porcentaje de viviendas hacinadas"
FROM public.personas AS p
JOIN public.hogares AS h
ON p.hogar_ref_id = h.hogar_ref_id
JOIN public.viviendas AS v
ON h.vivienda_ref_id = v.vivienda_ref_id
JOIN public.zonas AS z
ON v.zonaloc_ref_id = z.zonaloc_ref_id
JOIN public.comunas AS c
ON z.codigo_comuna = c.codigo_comuna
GROUP BY z.zonaloc_ref_id, c.nom_comuna;

-- Unir la geometría a la tabla de HACINAMIENTO
CREATE TABLE output.tasa_hacin_geom AS
SELECT shp.geocodigo::double precision, shp.geom, th."Zona censal", nom_comuna, th.round
FROM output.tasa_hacin AS th
JOIN dpa.zonas_censales_v AS shp
ON th."Zona censal"::double precision = shp.geocodigo