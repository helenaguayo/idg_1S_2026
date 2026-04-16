
/* Comentario largo

*/

-- Comentario corto

-- Consultar todos los registros de la tabla de artistas

SELECT * --Seleccionar todas las columnas
FROM "Artist"--desde que tabla

-- Seleccionar nombre y apellido de los clientes

SELECT "FirstName" AS "Nombre", "LastName" AS "Apellido"
FROM "Customer"

-- Seleccionar todos los clientes de Canada
SELECT *
FROM "Customer"
WHERE "Country" = 'Canada' -- Filtro
ORDER BY "LastName" DESC

-- Generar consulta que seleccione todos los empleados que trabajen como 'IT Staff',
-- ordenados por su primer nombre

SELECT *
FROM "Employee"
WHERE "Title" = 'IT Staff'
ORDER BY "FirstName"

-- Generar consulta que contenga unicamente el nombre de la canción y su duración,
-- ordenados según duración.

SELECT "Name", "Milliseconds"
FROM "Track"
ORDER BY "Milliseconds"

-- Contar total de clientes

SELECT COUNT(*) AS "Total Clientes"
FROM "Customer"

-- Seleccionar número de clientes por país

SELECT "Country" AS "País", COUNT(*) AS "Total Clientes"
FROM "Customer"
GROUP BY "Country" 
ORDER BY "Total Clientes" DESC
LIMIT 3 -- Para ver solo el top 3 

-- Seleccionar top 5 de países con más ventas
-- Pista, usar SUM()

SELECT "BillingCountry" AS "País", SUM("Total") AS "Ventas totales"
FROM "Invoice"
GROUP BY "BillingCountry"
ORDER BY "Ventas totales" DESC
LIMIT 5

-- Seleccionar albumes y sus artistas
SELECT "Album"."Title" AS "Album", "Artist"."Name" AS "Artista"
FROM "Artist" AS -- Tabla 1 de consulta
JOIN "Album" AS -- Tabla 2 de consulta
ON "Artist"."ArtistId" = "Album"."ArtistId"
ORDER BY "Artista"

SELECT al."Title" AS "Album", ar."Name" AS "Artista"
FROM "Artist" AS ar -- Tabla 1 de consulta
JOIN "Album" AS al -- Tabla 2 de consulta
ON ar."ArtistId" = al."ArtistId"
ORDER BY "Artista"

-- Mostrar nombre de la pista, nombre del álbum y nombre del artista
-- Ordenar alfabeticamente por nombre del artista

SELECT tr."Name" AS "Nombre", al."Title" AS "Album", ar."Name" AS "Artista"
FROM "Track" AS tr
JOIN "Album" AS al
ON tr."AlbumId" = al."AlbumId"
JOIN "Artist" AS ar
ON al."ArtistId" = ar."ArtistId"
ORDER BY "Artista"
