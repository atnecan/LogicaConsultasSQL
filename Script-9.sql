-- 1. Ya he creado el esquema.


-- 1. Selecciona los clientes cuyo país comienza con 'U' o que están en NY, ordenados por estado en orden descendente

SELECT c.first_name AS "NOMBRE",
       c.last_name AS "APELLIDO",
       ci.city AS "CIUDAD",
       co.country AS "PAIS"
FROM customer AS c
JOIN address AS a ON c.address_id = a.address_id
JOIN city AS ci ON a.city_id = ci.city_id
JOIN country AS co ON ci.country_id = co.country_id
WHERE co.country ILIKE 'U%'
ORDER BY co.country DESC
LIMIT 20;


-- 2. Muestra los nombres de todas las aplicaciones con clasificación 'R'

SELECT "rating", "title"
FROM film
WHERE "rating" = 'R';

-- 3. Encuentra los nombres de los actores cuyo 'actor_id' está entre 30 y 40

SELECT "first_name", "last_name"
FROM actor
WHERE "actor_id" BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con su idioma original

SELECT COUNT(*) AS "TOTAL_PELICULAS"
FROM film
WHERE "language_id" = "original_language_id";

-- 5. Ordena las películas por duración de forma ascendente

SELECT "length", "title"
FROM film
ORDER BY "length" ASC;

-- 6. Encuentra el nombre y apellido de los actores que contienen 'Allen' en su apellido

SELECT "first_name", "last_name"
FROM actor
WHERE LOWER("last_name") LIKE '%allen%';

-- 7. Cantidad total de películas en cada clasificación

SELECT "rating", COUNT(*) AS "TOTAL_PELICULAS"
FROM film
GROUP BY "rating";

-- 8. Títulos de películas con clasificación 'PG-13' o duración mayor a 3 horas

SELECT "title"
FROM film
WHERE "rating" = 'PG-13' OR "length" > 180;

-- 9. Variabilidad del costo de reemplazo de películas

SELECT 
    ROUND(STDDEV("replacement_cost"), 2) AS "DESVIACION_ESTANDAR",
    ROUND(VARIANCE("replacement_cost"), 2) AS "VARIANZA",
    ROUND(MAX("replacement_cost") - MIN("replacement_cost"), 2) AS "RANGO"
FROM film;

-- 10. Mayor y menor duración de una película

SELECT 
    MAX("length") AS "MAYOR_DURACION", 
    MIN("length") AS "MENOR_DURACION"
FROM film;

-- 11. Costo del antepenúltimo alquiler ordenado por fecha

SELECT "amount" AS "COSTO_ALQUILER", "rental_date"
FROM rental r
JOIN payment p ON r."rental_id" = p."rental_id"
ORDER BY r."rental_date" DESC
LIMIT 1 OFFSET 2;

-- 12. Películas que no tienen clasificación 'NC-17' ni 'G'

SELECT "rating", "title"
FROM film
WHERE "rating" NOT IN ('NC-17', 'G');

-- 13. Encuentra el promedio de duración de las películas para cada clasificación

SELECT "rating", ROUND(AVG("length"), 2) AS "PROMEDIO_DE_DURACION"
FROM film
GROUP BY "rating";

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos

SELECT "length", "title"
FROM film
WHERE "length" > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?

SELECT SUM("amount") AS "TOTAL_INGRESOS"
FROM payment;

-- 16. Muestra los 10 clientes con mayor valor ID

SELECT *
FROM customer
ORDER BY "customer_id" DESC
LIMIT 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título 'Egg Igby'

SELECT a."first_name", a."last_name"
FROM actor a
JOIN film_actor fa ON a."actor_id" = fa."actor_id"
JOIN film f ON fa."film_id" = f."film_id"
WHERE f."title" = 'EGG IGBY';

-- 18. Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT "title"
FROM film;

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos

SELECT f."title"
FROM film f
JOIN film_category fc ON f."film_id" = fc."film_id"
JOIN category c ON fc."category_id" = c."category_id"
WHERE c."name" = 'Comedy' AND f."length" > 180;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos

SELECT c."name" AS "CATEGORIA", ROUND(AVG(f."length"), 2) AS "PROMEDIO_DURACION"
FROM film f
JOIN film_category fc ON f."film_id" = fc."film_id"
JOIN category c ON fc."category_id" = c."category_id"
GROUP BY c."name"
HAVING AVG(f."length") > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT ROUND(AVG("rental_duration"), 2) AS "MEDIA_DURACION_ALQUILER"
FROM film;

-- 22. Crea una columna con el nombre y apellidos de todos los actores

SELECT CONCAT("first_name", ' ', "last_name") AS "NOMBRE_COMPLETO"
FROM actor;

-- 23. Número de alquileres por día, ordenados por cantidad de alquiler de forma descendente

SELECT "rental_date", COUNT(*) AS "CANTIDAD_ALQUILERES"
FROM rental
GROUP BY "rental_date"
ORDER BY "CANTIDAD_ALQUILERES" DESC;

-- 24. Encuentra las películas con una duración superior al promedio

SELECT "title", "length"
FROM film
WHERE "length" > (SELECT AVG("length") FROM film);

-- 25. Averigua el número de alquileres registrados por mes

SELECT DATE_TRUNC('month', "rental_date") AS "ALQUILERES_MES", COUNT(*) AS "CONTADOR_ALQUILERES"
FROM rental
GROUP BY "ALQUILERES_MES"
ORDER BY "ALQUILERES_MES" DESC;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado

SELECT 
    ROUND(AVG("amount"), 2) AS "PROMEDIO_TOTAL_PAGADO",
    ROUND(STDDEV("amount"), 2) AS "DESVIACION_ESTANDAR_TOTAL_PAGADO",
    ROUND(VARIANCE("amount"), 2) AS "VARIANZA_TOTAL_PAGADO"
FROM payment;


-- 27. ¿Qué películas se alquilan por encima del precio medio?

WITH promedio_precio AS (
    SELECT ROUND(AVG(p."amount"), 2) AS "PRECIO_MEDIO"
    FROM payment p
)
SELECT f."title" AS "TITULO_PELICULA", p."amount" AS "PRECIO_ALQUILER"
FROM rental r
JOIN payment p ON r."rental_id" = p."rental_id"
JOIN inventory i ON r."inventory_id" = i."inventory_id"
JOIN film f ON i."film_id" = f."film_id"
WHERE p."amount" > (SELECT "PRECIO_MEDIO" FROM promedio_precio);

-- 28. Muestra el ID de los actores que hayan participado en más de 40 películas

SELECT a."actor_id" AS "ID_ACTOR", a."first_name" AS "NOMBRE", a."last_name" AS "APELLIDO", COUNT(fa."film_id") AS "NUMERO_DE_PELICULAS"
FROM actor a
JOIN film_actor fa ON a."actor_id" = fa."actor_id"
GROUP BY a."actor_id", a."first_name", a."last_name"
HAVING COUNT(fa."film_id") > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario actualmente (no alquiladas), mostrar la cantidad disponible

SELECT f."title" AS "TITULO_PELICULA", COUNT(i."inventory_id") AS "CANTIDAD_DISPONIBLE"
FROM film f
LEFT JOIN inventory i ON f."film_id" = i."film_id"
LEFT JOIN rental r ON i."inventory_id" = r."inventory_id" AND r."return_date" IS NULL
WHERE r."rental_id" IS NULL
GROUP BY f."title";

-- 30. Obtener los actores y el número de películas en las que ha actuado

SELECT a."actor_id" AS "ID_ACTOR", a."first_name" AS "NOMBRE", a."last_name" AS "APELLIDO", COUNT(fa."film_id") AS "NUMERO_DE_PELICULAS"
FROM actor a
JOIN film_actor fa ON a."actor_id" = fa."actor_id"
GROUP BY a."actor_id", a."first_name", a."last_name";

-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados

SELECT DISTINCT f."title" AS "TITULO_PELICULA", a."first_name" AS "NOMBRE_ACTOR", a."last_name" AS "APELLIDO_ACTOR"
FROM film f
LEFT JOIN film_actor fa ON f."film_id" = fa."film_id"
LEFT JOIN actor a ON fa."actor_id" = a."actor_id"
ORDER BY f."title", a."last_name", a."first_name";

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película

SELECT a."actor_id" AS "ID_ACTOR", a."first_name" AS "NOMBRE_ACTOR", a."last_name" AS "APELLIDO_ACTOR", f."title" AS "TITULO_PELICULA"
FROM actor a
LEFT JOIN film_actor fa ON a."actor_id" = fa."actor_id"
LEFT JOIN film f ON fa."film_id" = f."film_id"
ORDER BY a."actor_id", f."title";


 -- 33. Obtener todas las películas y mostrar los registros de alquiler

SELECT f."title" AS "TITULO_PELICULA", r."rental_id" AS "ID_ALQUILER", r."rental_date" AS "FECHA_ALQUILER"
FROM film f
LEFT JOIN inventory i ON f."film_id" = i."film_id"
LEFT JOIN rental r ON i."inventory_id" = r."inventory_id"
ORDER BY f."title", r."rental_date";

-- 34. Encuentra los 5 clientes que más dinero han gastado

SELECT c."customer_id" AS "ID_CLIENTE", c."first_name" AS "NOMBRE_CLIENTE", c."last_name" AS "APELLIDO_CLIENTE", SUM(p."amount") AS "TOTAL_GASTADO"
FROM customer c
JOIN rental r ON c."customer_id" = r."customer_id"
JOIN payment p ON r."rental_id" = p."rental_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
ORDER BY "TOTAL_GASTADO" DESC
LIMIT 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'

SELECT a."actor_id" AS "ID_ACTOR", a."first_name" AS "NOMBRE", a."last_name" AS "APELLIDO"
FROM actor a
WHERE a."first_name" = 'JOHNNY';

-- 36. Encuentra el ID del actor más bajo y más alto en la tabla actor

SELECT MIN(a."actor_id") AS "ID_ACTOR_MAS_BAJO", MAX(a."actor_id") AS "ID_ACTOR_MAS_ALTO"
FROM actor a;

-- 37. Cuenta cuántos actores hay en la tabla "actor"

SELECT COUNT(*) AS "NUMERO_DE_ACTORES"
FROM actor;

-- 38. Selecciona todos los actores y ordénalos por apellido en orden ascendente

SELECT a."actor_id" AS "ID_ACTOR", a."first_name" AS "NOMBRE", a."last_name" AS "APELLIDO"
FROM actor a
ORDER BY a."last_name" ASC;

-- 39. Selecciona las primeras 5 películas de la tabla "film"

SELECT f."film_id" AS "ID_PELICULA", f."title" AS "TITULO_PELICULA"
FROM film f
ORDER BY f."title"
LIMIT 5;

-- 40. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre

SELECT a."first_name" AS "NOMBRE", COUNT(*) AS "CANTIDAD"
FROM actor a
GROUP BY a."first_name"
ORDER BY "CANTIDAD" DESC
LIMIT 1;

-- 41. Encuentra todos los alquileres y los nombres de los clientes que los realizaron

SELECT r."rental_id" AS "ID_ALQUILER", r."rental_date" AS "FECHA_ALQUILER", f."title" AS "TITULO_PELICULA", c."first_name" AS "NOMBRE_CLIENTE", c."last_name" AS "APELLIDO_CLIENTE"
FROM rental r
JOIN inventory i ON r."inventory_id" = i."inventory_id"
JOIN film f ON i."film_id" = f."film_id"
JOIN customer c ON r."customer_id" = c."customer_id"
ORDER BY r."rental_date", c."last_name", c."first_name";

-- 42. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres

SELECT c."customer_id" AS "ID_CLIENTE", c."first_name" AS "NOMBRE_CLIENTE", c."last_name" AS "APELLIDO_CLIENTE", r."rental_id" AS "ID_ALQUILER", r."rental_date" AS "FECHA_ALQUILER"
FROM customer c
LEFT JOIN rental r ON c."customer_id" = r."customer_id"
ORDER BY c."customer_id", r."rental_date";

-- 43. Encuentra los actores que han participado en películas de la categoría 'Action'

SELECT DISTINCT a."actor_id" AS "ID_ACTOR", a."first_name" AS "NOMBRE_ACTOR", a."last_name" AS "APELLIDO_ACTOR"
FROM actor a
JOIN film_actor fa ON a."actor_id" = fa."actor_id"
JOIN film f ON fa."film_id" = f."film_id"
JOIN film_category fc ON f."film_id" = fc."film_id"
JOIN category c ON fc."category_id" = c."category_id"
WHERE c."name" = 'Action'
ORDER BY a."last_name", a."first_name";

-- 44. Encuentra todos los actores que no han participado en películas

SELECT a."actor_id" AS "ID_ACTOR", a."first_name" AS "NOMBRE_ACTOR", a."last_name" AS "APELLIDO_ACTOR"
FROM actor a
LEFT JOIN film_actor fa ON a."actor_id" = fa."actor_id"
WHERE fa."film_id" IS NULL
ORDER BY a."last_name", a."first_name";

-- 45. Encuentra el nombre de los actores y la cantidad de películas en las que han participado

SELECT a."first_name" AS "NOMBRE", a."last_name" AS "APELLIDO", COUNT(fa."film_id") AS "NUMERO_DE_PELICULAS"
FROM actor a
JOIN film_actor fa ON a."actor_id" = fa."actor_id"
GROUP BY a."first_name", a."last_name";

-- 46. Encuentra los clientes que han alquilado al menos 7 películas distintas

SELECT c."customer_id" AS "ID_CLIENTE", c."first_name" AS "NOMBRE", c."last_name" AS "APELLIDO", COUNT(DISTINCT i."film_id") AS "TOTAL_PELICULAS_ALQUILADAS"
FROM customer c
JOIN rental r ON c."customer_id" = r."customer_id"
JOIN inventory i ON r."inventory_id" = i."inventory_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
HAVING COUNT(DISTINCT i."film_id") >= 7
ORDER BY c."last_name", c."first_name";

-- 47. Encuentra la cantidad total de películas alquiladas por cada categoría

SELECT c."name" AS "NOMBRE_CATEGORIA", COUNT(r."rental_id") AS "TOTAL_ALQUILERES"
FROM category c
JOIN film_category fc ON c."category_id" = fc."category_id"
JOIN film f ON fc."film_id" = f."film_id"
JOIN inventory i ON f."film_id" = i."film_id"
JOIN rental r ON i."inventory_id" = r."inventory_id"
GROUP BY c."name"
ORDER BY "TOTAL_ALQUILERES" DESC;

-- 48. Encuentra el número de películas por categoría estrenadas en 2006

SELECT c."name" AS "NOMBRE_CATEGORIA", COUNT(f."film_id") AS "TOTAL_PELICULAS"
FROM category c
JOIN film_category fc ON c."category_id" = fc."category_id"
JOIN film f ON fc."film_id" = f."film_id"
WHERE f."release_year" = 2006
GROUP BY c."name"
ORDER BY "TOTAL_PELICULAS" DESC;

-- 49. Encuentra la cantidad total de películas alquiladas por cada cliente

SELECT c."customer_id" AS "ID_CLIENTE", c."first_name" AS "NOMBRE_CLIENTE", c."last_name" AS "APELLIDO_CLIENTE", COUNT(r."rental_id") AS "TOTAL_PELICULAS_ALQUILADAS"
FROM customer c
JOIN rental r ON c."customer_id" = r."customer_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
ORDER BY "TOTAL_PELICULAS_ALQUILADAS" DESC;

-- 50. Encuentra el nombre y apellido de los actores que han actuado en películas alquiladas después de la primera fecha de alquiler de 'Spartacus Cheaper'

WITH PrimerAlquilerSpartacus AS (
  SELECT MIN(r."rental_date") AS "PRIMERA_FECHA_ALQUILER"
  FROM rental r
  JOIN inventory i ON r."inventory_id" = i."inventory_id"
  JOIN film f ON i."film_id" = f."film_id"
  WHERE f."title" = 'SPARTACUS CHEAPER'
)
SELECT DISTINCT a."actor_id" AS "ID_ACTOR", a."first_name" AS "NOMBRE_ACTOR", a."last_name" AS "APELLIDO_ACTOR"
FROM actor a
JOIN film_actor fa ON a."actor_id" = fa."actor_id"
JOIN film f ON fa."film_id" = f."film_id"
JOIN inventory i ON f."film_id" = i."film_id"
JOIN rental r ON i."inventory_id" = r."inventory_id"
WHERE r."rental_date" > (SELECT "PRIMERA_FECHA_ALQUILER" FROM PrimerAlquilerSpartacus)
ORDER BY a."last_name", a."first_name";

-- 51. Encuentra el título de todas las películas alquiladas por el cliente 'Tammy Sanders' y que aún no se han devuelto

SELECT f."title" AS "TITULO_PELICULA"
FROM customer c
JOIN rental r ON c."customer_id" = r."customer_id"
JOIN inventory i ON r."inventory_id" = i."inventory_id"
JOIN film f ON i."film_id" = f."film_id"
WHERE c."first_name" = 'TAMMY'
AND c."last_name" = 'SANDERS'
AND r."return_date" IS NULL
ORDER BY f."title";

-- 52. Crea una tabla temporal llamada "cliente_rentas_temporal" para almacenar el total de alquileres por cliente

CREATE TEMP TABLE cliente_rentas_temporal AS
SELECT c."customer_id" AS "ID_CLIENTE", c."first_name" AS "NOMBRE_CLIENTE", c."last_name" AS "APELLIDO_CLIENTE", COUNT(r."rental_id") AS "TOTAL_ALQUILERES"
FROM customer c
JOIN rental r ON c."customer_id" = r."customer_id"
GROUP BY c."customer_id", c."first_name", c."last_name";

-- 53. Crea una tabla temporal llamada "peliculas_alquiladas" que almacene las películas que han sido alquiladas al menos 10 veces

CREATE TEMP TABLE peliculas_alquiladas AS
SELECT f."film_id" AS "ID_PELICULA", f."title" AS "TITULO_PELICULA", COUNT(r."rental_id") AS "TOTAL_ALQUILERES"
FROM film f
JOIN inventory i ON f."film_id" = i."film_id"
JOIN rental r ON i."inventory_id" = r."inventory_id"
GROUP BY f."film_id", f."title"
HAVING COUNT(r."rental_id") >= 10;

-- 54. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días

SELECT f."title" AS "TITULO_PELICULA", EXTRACT(DAY FROM AGE(r."return_date", r."rental_date")) AS "DIAS_ALQUILER"
FROM film f
JOIN inventory i ON f."film_id" = i."film_id"
JOIN rental r ON i."inventory_id" = r."inventory_id"
WHERE EXTRACT(DAY FROM AGE(r."return_date", r."rental_date")) > 8
ORDER BY f."title";

-- 55. Encuentra los nombres de los actores que han actuado en películas de la categoría 'Sci-Fi'

SELECT DISTINCT a."actor_id" AS "ID_ACTOR", a."first_name" AS "NOMBRE_ACTOR", a."last_name" AS "APELLIDO_ACTOR"
FROM actor a
JOIN film_actor fa ON a."actor_id" = fa."actor_id"
JOIN film f ON fa."film_id" = f."film_id"
JOIN film_category fc ON f."film_id" = fc."film_id"
JOIN category c ON fc."category_id" = c."category_id"
WHERE c."name" = 'Sci-Fi'
ORDER BY a."last_name", a."first_name";

-- 56. Encuentra las películas que tienen la misma duración que la película 'DANCING FEVER'

WITH DuracionDancingFever AS (
    SELECT f."length" AS "DURACION"
    FROM film f
    WHERE f."title" = 'DANCING FEVER'
)
SELECT f."title" AS "TITULO_PELICULA"
FROM film f
WHERE f."length" = (SELECT "DURACION" FROM DuracionDancingFever)
ORDER BY f."title";

-- 57. Encuentra las películas con una duración superior al promedio

SELECT "title", "length"
FROM film
WHERE "length" > (SELECT AVG("length") FROM film);

-- 58. Encuentra la cantidad total de películas alquiladas por cada categoría

SELECT c."name" AS "NOMBRE_CATEGORIA", COUNT(r."rental_id") AS "TOTAL_ALQUILERES"
FROM category c
JOIN film_category fc ON c."category_id" = fc."category_id"
JOIN film f ON fc."film_id" = f."film_id"
JOIN inventory i ON f."film_id" = i."film_id"
JOIN rental r ON i."inventory_id" = r."inventory_id"
GROUP BY c."name"
ORDER BY "TOTAL_ALQUILERES" DESC;

-- 59. Encuentra la cantidad total de películas alquiladas por cada cliente

SELECT c."customer_id" AS "ID_CLIENTE", c."first_name" AS "NOMBRE_CLIENTE", c."last_name" AS "APELLIDO_CLIENTE", COUNT(r."rental_id") AS "TOTAL_PELICULAS_ALQUILADAS"
FROM customer c
JOIN rental r ON c."customer_id" = r."customer_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
ORDER BY "TOTAL_PELICULAS_ALQUILADAS" DESC;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas

SELECT c."customer_id" AS "ID_CLIENTE", c."first_name" AS "NOMBRE", c."last_name" AS "APELLIDO", COUNT(DISTINCT i."film_id") AS "TOTAL_PELICULAS_ALQUILADAS"
FROM customer c
JOIN rental r ON c."customer_id" = r."customer_id"
JOIN inventory i ON r."inventory_id" = i."inventory_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
HAVING COUNT(DISTINCT i."film_id") >= 7
ORDER BY c."last_name", c."first_name";

-- 61. Encuentra el número de películas por categoría estrenadas en 2006

SELECT c."name" AS "NOMBRE_CATEGORIA", COUNT(f."film_id") AS "TOTAL_PELICULAS"
FROM category c
JOIN film_category fc ON c."category_id" = fc."category_id"
JOIN film f ON fc."film_id" = f."film_id"
WHERE f."release_year" = 2006
GROUP BY c."name"
ORDER BY "TOTAL_PELICULAS" DESC;

-- 62. Encuentra la cantidad total de películas alquiladas por cada categoría

SELECT c."name" AS "NOMBRE_CATEGORIA", COUNT(r."rental_id") AS "TOTAL_ALQUILERES"
FROM category c
JOIN film_category fc ON c."category_id" = fc."category_id"
JOIN film f ON fc."film_id" = f."film_id"
JOIN inventory i ON f."film_id" = i."film_id"
JOIN rental r ON i."inventory_id" = r."inventory_id"
GROUP BY c."name"
ORDER BY "TOTAL_ALQUILERES" DESC;

-- 63. Encuentra las películas con una duración superior al promedio

SELECT "title", "length"
FROM film
WHERE "length" > (SELECT AVG("length") FROM film);

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente

SELECT c."customer_id" AS "ID_CLIENTE", c."first_name" AS "NOMBRE_CLIENTE", c."last_name" AS "APELLIDO_CLIENTE", COUNT(r."rental_id") AS "TOTAL_PELICULAS_ALQUILADAS"
FROM customer c
JOIN rental r ON c."customer_id" = r."customer_id"
GROUP BY c."customer_id", c."first_name", c."last_name"
ORDER BY "TOTAL_PELICULAS_ALQUILADAS" DESC;




















































