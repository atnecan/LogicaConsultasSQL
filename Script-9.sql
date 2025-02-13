-- 1. Ya he creado el esquema.


-- 2. Muestra los nombres de todas las aplicaciones con clasificación por
--    edades de 'R'

SELECT rating , title 
FROM film AS fw
WHERE rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un 'actor_id' entre
--    30 y 40

SELECT first_name , last_name 
FROM actor AS a 
WHERE actor_id BETWEEN 30 AND 40;

-- 4. Obtén las películas cuyo idioma coincide con el dioma original

SELECT count(*) 
FROM film AS f
WHERE language_id = original_language_id ;

-- 5. Ordena las películas por duración de forma ascendente

SELECT length , title 
FROM film AS f 
ORDER BY length ASC ;

-- 6. Encuentra el nombre y apellido de los actores que tengan 'Allen' en 
--    su apellido

SELECT first_name, last_name
FROM actor AS a 
WHERE last_name = 'ALLEN';

-- 7. Encuentra la cantidad total de películas en cada clasificación de 
--    la tabla "film" y muestra la clasificación junto con el recuento

SELECT rating,
	count(*) AS "total_peliculas"
FROM film AS f 
GROUP BY rating ;

-- 8. Encuentra el título de todas las películas que son 'PG-13' o tienen
--    una duración mayor a 3 horas en la tabla film.

SELECT title 
FROM film AS f 
WHERE rating = 'PG-13' OR length > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas

-- Desviación estándar:

SELECT STDDEV(replacement_cost) AS desviacion_estandar
FROM film AS f ;

-- Varianza:

SELECT VARIANCE(replacement_cost) AS varianza
FROM film AS f ;

-- Rango:

SELECT MAX(replacement_cost) - MIN(replacement_cost) AS rango
FROM film AS f ;


-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD

SELECT MAX(length) AS mayor_duración, MIN(length) AS menor_duración
FROM film AS f ;

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día

WITH alquiler_ordenado AS (
    SELECT rental_rate, last_update,
           ROW_NUMBER() OVER (ORDER BY last_update DESC) AS fila_ordenada
    FROM film
)
SELECT rental_rate, last_update
FROM alquiler_ordenado
WHERE fila_ordenada = 3;

-- 12. Encuentra el título de las películas en la tabla "film" que no sean
--     ni 'NC-17' ni 'G' en cuanto a su clasificación

SELECT rating , title 
FROM film AS f 
WHERE NOT (rating = 'NC-17' OR rating = 'G')

-- 13. Encuentra el promedio de duración de las películas para cada
--     clasificación de la tabla film y muestra la clasificación junto 
--     con el promedio de duración

SELECT rating, avg(length) AS promedio_de_duración 
FROM film AS f 
GROUP BY  rating ;

-- 14. Encuentra el título de todas las películas que tengan una duración
--     mayor a 180 mintuos

SELECT length , title 
FROM film AS f 
WHERE length >180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?


SELECT sum(amount) AS total_ingresos 
FROM payment AS p 

-- 16. Muestra los 10 clientes con mayor valor id


SELECT *
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la
--     película con título 'Egg lgby'

SELECT a.first_name , a.last_name 
FROM actor AS a 
JOIN film_actor ON a.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id 
WHERE film.title = 'EGG IGBY';

-- 18. Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT title 
FROM film AS f ;

-- 19. Encuentra el título de las películas que son comedias y tienen una 
--     una duración mayor a 180 minutos en la tabla "film"

SELECT f.title 
FROM film AS f
JOIN film_category ON f.film_id = film_category.film_id
JOIN category AS c ON film_category.category_id = c.category_id 
WHERE c.category_id = 5 AND f.length > 180;

-- 20. Encuentra las categorías de películas que tienen un promedio de 
--     duración superior a 110 minutos y muestra el nombre de la categoría
--     junto con el promedio de duración

SELECT c.name AS categoria, AVG(f.length) AS promedio_duracion
FROM film AS f
JOIN film_category ON f.film_id = film_category.film_id
JOIN category AS c ON film_category.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT avg(rental_duration) AS media_duración_alquiler 
FROM film AS f ;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y
--     actrices

SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor;

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de
--     forma descendente

SELECT rental_date, COUNT(*) AS cantidad_alquileres
FROM rental
GROUP BY rental_date
ORDER BY cantidad_alquileres DESC;

-- 24. Encuentra las películas con una duración superior al promedio

SELECT title , length 
FROM film AS f 
WHERE length > (SELECT avg(length) FROM film);

-- 25. Averigua el número de alquileres registrados por mes


SELECT 
  DATE_TRUNC('month', rental_date) AS alquileres_mes, 
  COUNT(*) AS contador_alquileres
FROM rental
GROUP BY alquileres_mes
ORDER BY alquileres_mes DESC ;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total
--     pagado

SELECT 
  AVG(amount) AS promedio_total_pagado,
  STDDEV(amount) AS desviacion_estandar_total_pagado,
  VARIANCE(amount) AS varianza_total_pagado
FROM payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?

WITH promedio_precio AS (
  SELECT AVG(p.amount) AS precio_medio
  FROM payment p
)
SELECT
  f.title AS titulo_pelicula,
  p.amount AS precio_alquiler
FROM 
  rental r
JOIN 
  payment p
ON 
  r.rental_id = p.rental_id
JOIN
  inventory i
ON
  r.inventory_id = i.inventory_id
JOIN
  film f
ON
  i.film_id = f.film_id
WHERE 
  p.amount > (SELECT precio_medio FROM promedio_precio);
 

 -- 28. Muestra el id de los actores que hayan participado en más de 40
 --     películas
 
SELECT 
  a.actor_id,
  a.first_name,
  a.last_name,
  COUNT(fa.film_id) AS numero_de_peliculas
FROM 
  actor a
JOIN 
  film_actor fa
ON 
  a.actor_id = fa.actor_id
GROUP BY 
  a.actor_id, a.first_name, a.last_name
HAVING 
  COUNT(fa.film_id) > 40;

 -- 29. Obtener todas las películas y, si están disponibles en el inventario,
 --     mostrar la cantidad disponible
 
SELECT 
  f.title AS titulo_pelicula,
  COUNT(i.inventory_id) AS cantidad_disponible
FROM 
  film f
LEFT JOIN
  inventory i
ON 
  f.film_id = i.film_id
GROUP BY 
  f.title;
 
 -- 30. Obtener los actores y el número de películas en las que ha actuado
 
SELECT 
  a.actor_id AS id_actor,
  a.first_name AS nombre,
  a.last_name AS apellido,
  COUNT(fa.film_id) AS numero_de_peliculas
FROM 
  actor a
JOIN 
  film_actor fa
ON 
  a.actor_id = fa.actor_id
GROUP BY 
  a.actor_id, a.first_name, a.last_name;
 
 -- 31. Obtener todas las películas y mostrar los actores que han actuado en
 --     ellas, incluso si algunas películas no tienen actores asociados
 
SELECT DISTINCT 
  f.title AS titulo_pelicula,
  a.first_name AS nombre_actor,
  a.last_name AS apellido_actor
FROM 
  film f
LEFT JOIN 
  inventory i
ON 
  f.film_id = i.film_id
LEFT JOIN 
  rental r
ON 
  i.inventory_id = r.inventory_id
LEFT JOIN 
  film_actor fa
ON 
  f.film_id = fa.film_id
LEFT JOIN 
  actor a
ON 
  fa.actor_id = a.actor_id
ORDER BY 
  titulo_pelicula, nombre_actor, apellido_actor;

-- 32. Obtener todos los actores y mostrar las películas en las que han
--     actuado, incluso si algunos actores no han actuado en ninguna película
 
 SELECT 
  a.actor_id AS id_actor,
  a.first_name AS nombre_actor,
  a.last_name AS apellido_actor,
  f.title AS titulo_pelicula
FROM 
  actor a
LEFT JOIN 
  film_actor fa
ON 
  a.actor_id = fa.actor_id
LEFT JOIN 
  film f
ON 
  fa.film_id = f.film_id
ORDER BY 
  a.actor_id, f.title;

 -- 33. Obtener todas las películas que tenemos y todos los registros de
 --     alquiler
 
 SELECT 
  f.title AS titulo_pelicula,
  r.rental_id AS id_alquiler,
  r.rental_date AS fecha_alquiler,
  r.inventory_id AS id_inventario,
  r.customer_id AS id_cliente,
  r.return_date AS fecha_devolucion,
  r.staff_id AS id_personal
FROM 
  film f
LEFT JOIN 
  inventory i
ON 
  f.film_id = i.film_id
LEFT JOIN 
  rental r
ON 
  i.inventory_id = r.inventory_id
ORDER BY 
  f.title, r.rental_date;

 
 -- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nostros
 
 SELECT 
  c.customer_id AS id_cliente,
  c.first_name AS nombre_cliente,
  c.last_name AS apellido_cliente,
  SUM(p.amount) AS total_gastado
FROM 
  customer c
JOIN 
  rental r
ON 
  c.customer_id = r.customer_id
JOIN 
  payment p
ON 
  r.rental_id = p.rental_id
GROUP BY 
  c.customer_id, c.first_name, c.last_name
ORDER BY 
  total_gastado DESC
LIMIT 5;

 -- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'

SELECT 
  a.actor_id AS id_actor,
  a.first_name AS nombre,
  a.last_name AS apellido
FROM 
  actor a
WHERE 
  a.first_name = 'JOHNNY';


-- 36. Renombra la columna "first_name" como Nombre y "last_name" como
--     Apellido
 
                 -- Ya está hecho anteiormente.
 
-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor
 
SELECT 
  MIN(a.actor_id) AS id_actor_mas_bajo,
  MAX(a.actor_id) AS id_actor_mas_alto
FROM 
  actor a;

-- 38. Cuenta cuántos actores hay en la tabla "actor"
 
 SELECT 
  COUNT(*) AS numero_de_actores
FROM 
  actor;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden 
--     ascendente
 
SELECT 
  a.actor_id AS id_actor,
  a.first_name AS nombre,
  a.last_name AS apellido
FROM 
  actor a
ORDER BY 
  a.last_name ASC;

 -- 40. Selecciona las primeras 5 películas de la tabla "film"

 SELECT 
  f.film_id AS id_pelicula,
  f.title AS titulo_pelicula,
  f.description AS descripcion_pelicula
FROM 
  film f
ORDER BY 
  f.title
LIMIT 5;

-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
--     mismo nombre. ¿Cuál es el nombre más repetido?

SELECT 
  a.first_name AS nombre,
  COUNT(*) AS cantidad
FROM 
  actor a
GROUP BY 
  a.first_name
ORDER BY 
  cantidad DESC
LIMIT 1;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los
--     realizaron
SELECT 
  r.rental_id AS id_alquiler,
  r.rental_date AS fecha_alquiler,
  f.title AS titulo_pelicula,
  c.first_name AS nombre_cliente,
  c.last_name AS apellido_cliente
FROM 
  rental r
JOIN 
  inventory i
ON 
  r.inventory_id = i.inventory_id
JOIN 
  film f
ON 
  i.film_id = f.film_id
JOIN 
  customer c
ON 
  r.customer_id = c.customer_id
ORDER BY 
  r.rental_date, c.last_name, c.first_name;

 -- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo 
 --     aquellos que no tienen alquileres.
 
 SELECT 
  c.customer_id AS id_cliente,
  c.first_name AS nombre_cliente,
  c.last_name AS apellido_cliente,
  r.rental_id AS id_alquiler,
  r.rental_date AS fecha_alquiler
FROM 
  customer c
LEFT JOIN 
  rental r
ON 
  c.customer_id = r.customer_id
ORDER BY 
  c.customer_id, r.rental_date;

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
--     esta consulta?¿Por qué? Deja después de la consulta la contestación.
 
 SELECT 
  f.title AS titulo_pelicula,
  c.name AS nombre_categoria
FROM 
  film f
CROSS JOIN 
  category c;
 
-- la consulta resulta poco práctica ya que no todos los pares de películas
--  y categorías son relevantes, y el resultado contiene datos redundantes.
-- Para un análisis más útil, utilizaria un JOIN con condiciones específicas
 
-- 45. Encuentra los actores que han participado en películas de la categoría
--     'Action'
 
SELECT DISTINCT 
  a.actor_id AS id_actor,
  a.first_name AS nombre_actor,
  a.last_name AS apellido_actor
FROM 
  actor a
JOIN 
  film_actor fa
ON 
  a.actor_id = fa.actor_id
JOIN 
  film f
ON 
  fa.film_id = f.film_id
JOIN 
  film_category fc
ON 
  f.film_id = fc.film_id
JOIN 
  category c
ON 
  fc.category_id = c.category_id
WHERE 
  c.name = 'Action'
ORDER BY 
  a.last_name, a.first_name;

-- 46. Encuentra todos los actores que no han participado en películas

 SELECT 
  a.actor_id AS id_actor,
  a.first_name AS nombre_actor,
  a.last_name AS apellido_actor
FROM 
  actor a
LEFT JOIN 
  film_actor fa
ON 
  a.actor_id = fa.actor_id
WHERE 
  fa.film_id IS NULL
ORDER BY 
  a.last_name, a.first_name;

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las
--     que han participado

SELECT 
  a.first_name AS nombre,
  a.last_name AS apellido,
  COUNT(fa.film_id) AS numero_de_peliculas
FROM 
  actor a
JOIN 
  film_actor fa
ON 
  a.actor_id = fa.actor_id
GROUP BY 
  a.first_name, a.last_name;

-- 48. Crea una vista llamada "actor_num_peliculas" que muestre los nombres
--     de los actores y el número de películas en las que han participado

 CREATE VIEW actor_num_peliculas AS
SELECT 
  a.first_name AS nombre,
  a.last_name AS apellido,
  COUNT(fa.film_id) AS numero_de_peliculas
FROM 
  actor a
JOIN 
  film_actor fa
ON 
  a.actor_id = fa.actor_id
GROUP BY 
  a.first_name, a.last_name;

 SELECT 
  nombre,
  apellido,
  numero_de_peliculas
FROM 
  actor_num_peliculas;

 -- 49. Calcula el número total de alquileres realizados por cada cliente
 
 SELECT 
  c.customer_id AS id_cliente,
  c.first_name AS nombre_cliente,
  c.last_name AS apellido_cliente,
  COUNT(r.rental_id) AS total_alquileres
FROM 
  customer c
JOIN 
  rental r
ON 
  c.customer_id = r.customer_id
GROUP BY 
  c.customer_id, c.first_name, c.last_name
ORDER BY 
  total_alquileres DESC;

-- 50. Calcula la duración de las películas en la categoría 'Action'
 
SELECT 
  c.name AS categoria,
  SUM(f.length) AS duracion_total
FROM 
  film f
JOIN 
  film_category fc
ON 
  f.film_id = fc.film_id
JOIN 
  category c
ON 
  fc.category_id = c.category_id
WHERE 
  c.name = 'Action'
GROUP BY 
  c.name;
 
 -- 51. Crea una tabla temporal llamada "cliente_rentas_temporal" para
 --     almacenar el total de alquileres por cliente

CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT 
  c.customer_id AS id_cliente,
  c.first_name AS nombre_cliente,
  c.last_name AS apellido_cliente,
  COUNT(r.rental_id) AS total_alquileres
FROM 
  customer c
JOIN 
  rental r
ON 
  c.customer_id = r.customer_id
GROUP BY 
  c.customer_id, c.first_name, c.last_name;

-- 52. Crea una tabla temporal llamada "peliculas_alquiladas" que almacene
--     las películas que han sido alquiladas al menos 10 veces

CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT 
  f.film_id AS id_pelicula,
  f.title AS titulo_pelicula,
  COUNT(r.rental_id) AS total_alquileres
FROM 
  film f
JOIN 
  inventory i
ON 
  f.film_id = i.film_id
JOIN 
  rental r
ON 
  i.inventory_id = r.inventory_id
GROUP BY 
  f.film_id, f.title
HAVING 
  COUNT(r.rental_id) >= 10;

 SELECT 
  id_pelicula,
  titulo_pelicula,
  total_alquileres
FROM 
  peliculas_alquiladas;
 
-- 53. Encuentra el título de las películas que han sido alquiladas por el 
--     cliente con el nombre 'Tammy Sanders' y que aún no se han devuelto.
--     Ordena los resultados alfabéticamente por título de película.

 SELECT 
  f.title AS titulo_pelicula
FROM 
  customer c
JOIN 
  rental r
ON 
  c.customer_id = r.customer_id
JOIN 
  inventory i
ON 
  r.inventory_id = i.inventory_id
JOIN 
  film f
ON 
  i.film_id = f.film_id
WHERE 
  c.first_name = 'TAMMY'
AND 
  c.last_name = 'SANDERS'
AND 
  r.return_date IS NULL
ORDER BY 
  f.title;

-- 54. Encuentra los nombres de los actores que han actuado en al menos una
--     película que pertenece a la catgoría 'Sci-Fi'. Ordena los resultados
--     alfabéticamente por apellido

 SELECT 
  DISTINCT a.actor_id AS id_actor,
  a.first_name AS nombre_actor,
  a.last_name AS apellido_actor
FROM 
  actor a
JOIN 
  film_actor fa
ON 
  a.actor_id = fa.actor_id
JOIN 
  film f
ON 
  fa.film_id = f.film_id
JOIN 
  film_category fc
ON 
  f.film_id = fc.film_id
JOIN 
  category c
ON 
  fc.category_id = c.category_id
WHERE 
  c.name = 'Sci-Fi'
ORDER BY 
  a.last_name, a.first_name;

 -- 55. Encuentra el nombre y apellido de los actores que han actuado en películas
 --     que se alquilaron después de que la película 'Spartacus Cheaper' se alquilara
 --     por primera vez. Ordena los resultados alfabéticamente por apellido
 
 WITH PrimerAlquilerSpartacus AS (
  SELECT 
    MIN(r.rental_date) AS primera_fecha_alquiler
  FROM 
    rental r
  JOIN 
    inventory i
  ON 
    r.inventory_id = i.inventory_id
  JOIN 
    film f
  ON 
    i.film_id = f.film_id
  WHERE 
    f.title = 'SPARTACUS CHEAPER'
)

SELECT 
  DISTINCT a.actor_id AS id_actor,
  a.first_name AS nombre_actor,
  a.last_name AS apellido_actor
FROM 
  actor a
JOIN 
  film_actor fa
ON 
  a.actor_id = fa.actor_id
JOIN 
  film f
ON 
  fa.film_id = f.film_id
JOIN 
  inventory i
ON 
  f.film_id = i.film_id
JOIN 
  rental r
ON 
  i.inventory_id = r.inventory_id
WHERE 
  r.rental_date > (SELECT primera_fecha_alquiler FROM PrimerAlquilerSpartacus)
ORDER BY 
  a.last_name, a.first_name;

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna
--     película de la categoría 'Music'
 
 SELECT 
  a.actor_id AS id_actor,
  a.first_name AS nombre_actor,
  a.last_name AS apellido_actor
FROM 
  actor a
WHERE 
  a.actor_id NOT IN (
    SELECT 
      fa.actor_id
    FROM 
      film_actor fa
    JOIN 
      film_category fc
    ON 
      fa.film_id = fc.film_id
    JOIN 
      category c
    ON 
      fc.category_id = c.category_id
    WHERE 
      c.name = 'Music'
  )
ORDER BY 
  a.last_name, a.first_name;

 
-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de
 --    8 días
 
SELECT 
  f.title AS titulo_pelicula,
  EXTRACT(DAY FROM AGE(r.return_date, r.rental_date)) AS dias_alquiler
FROM 
  film f
JOIN 
  inventory i
ON 
  f.film_id = i.film_id
JOIN 
  rental r
ON 
  i.inventory_id = r.inventory_id
WHERE 
  EXTRACT(DAY FROM AGE(r.return_date, r.rental_date)) > 8
ORDER BY 
  f.title;

 -- 58. Encuentra el título de todas las películas que son de la misma categoría
 --     que 'Animation'
 
 SELECT 
  f.film_id AS id_pelicula,
  f.title AS titulo_pelicula
FROM 
  film f
JOIN 
  film_category fc
ON 
  f.film_id = fc.film_id
JOIN 
  category c
ON 
  fc.category_id = c.category_id
WHERE 
  c.name = 'Animation'
ORDER BY 
  f.title;

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la
--     película con el título 'DANCING FEVER'. Ordena los resultados alfabéticamente
--     por título de película

 WITH DuracionDancingFever AS (
  SELECT 
    f.length AS duracion
  FROM 
    film f
  WHERE 
    f.title = 'DANCING FEVER'
)
SELECT 
  f.title AS titulo_pelicula
FROM 
  film f
WHERE 
  f.length = (SELECT duracion FROM DuracionDancingFever)
ORDER BY 
  f.title;

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas
--     distintas. Ordena los resultados alfabéticamente por apellido.
 
SELECT 
  c.customer_id AS id_cliente,
  c.first_name AS nombre,
  c.last_name AS apellido,
  COUNT(DISTINCT i.film_id) AS total_peliculas_alquiladas
FROM 
  customer c
JOIN 
  rental r
ON 
  c.customer_id = r.customer_id
JOIN 
  inventory i
ON 
  r.inventory_id = i.inventory_id
GROUP BY 
  c.customer_id, c.first_name, c.last_name
HAVING 
  COUNT(DISTINCT i.film_id) >= 7
ORDER BY 
  c.last_name, c.first_name;

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra
 --    el nombre de la categoría junto con el recuento de alquileres
 
 SELECT 
  c.name AS nombre_categoria,
  COUNT(r.rental_id) AS total_alquileres
FROM 
  category c
JOIN 
  film_category fc
ON 
  c.category_id = fc.category_id
JOIN 
  film f
ON 
  fc.film_id = f.film_id
JOIN 
  inventory i
ON 
  f.film_id = i.film_id
JOIN 
  rental r
ON 
  i.inventory_id = r.inventory_id
GROUP BY 
  c.name
ORDER BY 
  total_alquileres DESC;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006
 
SELECT 
  c.name AS nombre_categoria,
  COUNT(f.film_id) AS total_peliculas
FROM 
  category c
JOIN 
  film_category fc
ON 
  c.category_id = fc.category_id
JOIN 
  film f
ON 
  fc.film_id = f.film_id
WHERE 
  f.release_year = 2006
GROUP BY 
  c.name
ORDER BY 
  total_peliculas DESC;

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas 
--     que tenemos.

SELECT
  s.staff_id AS id_trabajador,
  s.first_name AS nombre_trabajador,
  s.last_name AS apellido_trabajador,
  st.store_id AS id_tienda,
  st.address_id
FROM
  staff s
CROSS JOIN
  store st
ORDER BY
  s.last_name, s.first_name, st.store_id;

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y 
 --    muestra el ID del cliente, su nombre y apellido junto con la cantidad de
 --    películas alquiladas
 
SELECT 
  c.customer_id AS id_cliente,
  c.first_name AS nombre_cliente,
  c.last_name AS apellido_cliente,
  COUNT(r.rental_id) AS total_peliculas_alquiladas
FROM 
  customer c
JOIN 
  rental r
ON 
  c.customer_id = r.customer_id
GROUP BY 
  c.customer_id, c.first_name, c.last_name
ORDER BY 
  total_peliculas_alquiladas DESC, c.last_name, c.first_name;
 



















































