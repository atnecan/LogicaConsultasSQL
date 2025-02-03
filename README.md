LógicaConsultasSQL

# Proyecto de Consultas SQL para Base de Datos de Películas

## Introducción

Este proyecto está diseñado para demostrar habilidades avanzadas en SQL mediante la interacción con una base de datos de películas. Las consultas fueron desarrolladas y probadas utilizando DBeaver y Progress, herramientas de administración de bases de datos.

El objetivo principal es extraer y analizar datos relevantes relacionados con películas, actores, categorías y más, proporcionando resultados útiles y perspicaces.

## Requisitos

Para replicar este proyecto, necesitarás lo siguiente:

- **Base de datos de películas:** Un esquema de base de datos que incluya tablas como `film`, `actor`, `category`, `payment`, entre otras.
- **DBeaver:** Herramienta de administración de bases de datos. Puedes descargarla [aquí](https://dbeaver.io/download/).
- **Progress:** Sistema de gestión de bases de datos. Puedes encontrar más información [aquí](https://www.progress.com/).

## Instalación y Configuración

### DBeaver

1. **Descarga e instalación de DBeaver:**
    - Dirígete al [sitio web de DBeaver](https://dbeaver.io/download/) y descarga la versión correspondiente a tu sistema operativo.
    - Sigue las instrucciones de instalación proporcionadas en el sitio.

2. **Configuración de la conexión a la base de datos:**
    - Abre DBeaver y crea una nueva conexión a tu base de datos de películas.
    - Proporciona los detalles necesarios, como el nombre del servidor, el puerto, el nombre de la base de datos, el usuario y la contraseña.
    - Verifica la conexión para asegurarte de que DBeaver puede acceder a la base de datos.

### Progress

1. **Descarga e instalación de Progress:**
    - Dirígete al [sitio web de Progress](https://www.progress.com/) y descarga la versión correspondiente a tu sistema operativo.
    - Sigue las instrucciones de instalación proporcionadas en el sitio.

2. **Configuración de la conexión a la base de datos:**
    - Abre Progress y configura una nueva conexión a tu base de datos de películas.
    - Proporciona los detalles necesarios y verifica la conexión.
    - 
## Script Principal

En DBeaver, hay varios scripts disponibles, pero **el Script 9 contiene todo el contenido necesario**. Se recomienda utilizar el Script 9 para ejecutar 
todas las consultas descritas en este proyecto.

## Consultas SQL

### Consultas Incluidas

1. **Mostrar nombres de todas las aplicaciones con clasificación 'R':**
    ```sql
    SELECT rating, title 
    FROM film 
    WHERE rating = 'R';
    ```

2. **Nombres de los actores con 'actor_id' entre 30 y 40:**
    ```sql
    SELECT first_name, last_name 
    FROM actor 
    WHERE actor_id BETWEEN 30 AND 40;
    ```

3. **Películas cuyo idioma coincide con el idioma original:**
    ```sql
    SELECT COUNT(*) 
    FROM film 
    WHERE language_id = original_language_id;
    ```

4. **Ordenar las películas por duración de forma ascendente:**
    ```sql
    SELECT length, title 
    FROM film 
    ORDER BY length ASC;
    ```

5. **Nombre y apellido de los actores con 'Allen' en su apellido:**
    ```sql
    SELECT first_name, last_name 
    FROM actor 
    WHERE last_name = 'ALLEN';
    ```

6. **Cantidad total de películas en cada clasificación:**
    ```sql
    SELECT rating, COUNT(*) AS total_peliculas 
    FROM film 
    GROUP BY rating;
    ```

7. **Título de películas 'PG-13' o con duración mayor a 3 horas:**
    ```sql
    SELECT title 
    FROM film 
    WHERE rating = 'PG-13' OR length > 180;
    ```

8. **Variabilidad de lo que costaría reemplazar las películas:**
    - Desviación estándar:
        ```sql
        SELECT STDDEV(replacement_cost) AS desviacion_estandar 
        FROM film;
        ```
    - Varianza:
        ```sql
        SELECT VARIANCE(replacement_cost) AS varianza 
        FROM film;
        ```
    - Rango:
        ```sql
        SELECT MAX(replacement_cost) - MIN(replacement_cost) AS rango 
        FROM film;
        ```

9. **Mayor y menor duración de una película:**
    ```sql
    SELECT MAX(length) AS mayor_duración, MIN(length) AS menor_duración 
    FROM film;
    ```

10. **Costo del antepenúltimo alquiler ordenado por día:**
    ```sql
    WITH alquiler_ordenado AS (
        SELECT rental_rate, last_update,
               ROW_NUMBER() OVER (ORDER BY last_update DESC) AS fila_ordenada
        FROM film
    )
    SELECT rental_rate, last_update 
    FROM alquiler_ordenado 
    WHERE fila_ordenada = 3;
    ```

### Consultas Adicionales

Puedes agregar más consultas siguiendo el mismo formato mostrado anteriormente. Esto facilita la organización y comprensión del código.

## Ejecución de las Consultas

1. **Abre DBeaver o Progress y conéctate a tu base de datos de películas.**
2. **Copia y pega cada consulta SQL en el editor de consultas de la herramienta que estés utilizando.**
3. **Ejecuta las consultas para obtener los resultados deseados.** Verifica que los resultados coincidan con las expectativas.

## Conclusión

Este proyecto demuestra un amplio rango de técnicas y consultas SQL avanzadas para manejar y analizar datos de una base de datos de películas. Al utilizar DBeaver y Progress, se facilita la gestión y ejecución de estas consultas, proporcionando una interfaz amigable y poderosa para trabajar con SQL.

Para más información y contribuciones, consulta la sección de contribuciones y licencia.

## Contribuciones

Si deseas contribuir a este proyecto, por favor, crea un fork del repositorio, realiza tus cambios y envía un pull request. Las contribuciones son bienvenidas y apreciadas.

## Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para obtener más detalles.

