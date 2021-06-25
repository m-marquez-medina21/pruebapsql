\c postgres
DROP DATABASE biblioteca;

CREATE DATABASE biblioteca;
\c biblioteca
-- crear tabla socio
CREATE TABLE socios( 
rut VARCHAR(10) , 
nombre VARCHAR(25), 
apellido VARCHAR(25), 
direccion VARCHAR(255), 
telefono VARCHAR(10),
PRIMARY KEY(rut)
);
-- 2. Crear Tabla Libro
CREATE TABLE libros(
isbn VARCHAR(20),
titulo VARCHAR(255),
paginas INT,
dias_prestamos INT,
PRIMARY KEY(isbn)
);

-- 3. Crear Tabla Prestamo
CREATE TABLE prestamos(
id_prestamo SERIAL,
rut_socios VARCHAR(10),
isbn VARCHAR(20),
fecha_prestamo DATE,
fecha_devolucion DATE,
PRIMARY KEY(id_prestamo),
FOREIGN KEY(rut_socios) REFERENCES socios(rut),
FOREIGN KEY(isbn) REFERENCES libros(isbn)
);

-- 4. Crear Tabla Autor
CREATE TABLE autor(
cod_autor SERIAL,
nombre_autor VARCHAR(50),
apellido_autor VARCHAR(50),
nacimiento INT,
defuncion VARCHAR(20),
tipo_autor VARCHAR(10),
PRIMARY KEY(cod_autor)
);

-- 5. Crear Tabla Libro_Autor
CREATE TABLE libro_autor(
cod_autor INT,
isbn VARCHAR(20),
FOREIGN KEY(cod_autor) REFERENCES autor(cod_autor),
FOREIGN KEY(isbn) REFERENCES libros(isbn)
);

-- agregar csv
\copy socios FROM '/Users/mauriciomarquezmedina/OneDrive - Gestion Agricola/DesafioLatam/postgreSQL/modelamientoyNormalizacion/pruebapostgres/socios.csv' csv header; 

\copy libros FROM '/Users/mauriciomarquezmedina/OneDrive - Gestion Agricola/DesafioLatam/postgreSQL/modelamientoyNormalizacion/pruebapostgres/libros.csv' csv header; 

\copy prestamos FROM '/Users/mauriciomarquezmedina/OneDrive - Gestion Agricola/DesafioLatam/postgreSQL/modelamientoyNormalizacion/pruebapostgres/historialprestamos.csv' csv header; 

\copy autor FROM '/Users/mauriciomarquezmedina/OneDrive - Gestion Agricola/DesafioLatam/postgreSQL/modelamientoyNormalizacion/pruebapostgres/autor.csv' NULL AS 'NULL' csv header; 

\copy libro_autor FROM '/Users/mauriciomarquezmedina/OneDrive - Gestion Agricola/DesafioLatam/postgreSQL/modelamientoyNormalizacion/pruebapostgres/libro_autor.csv' csv header; 

--consultas

-- Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)
SELECT * FROM libros WHERE paginas <300;

--Mostrar todos los autores que hayan nacido después del 1970 (0.5 puntos)
SELECT * FROM autor WHERE nacimiento > 1970;

--¿Cuál es el libro más solicitado? (0.5 puntos).

SELECT COUNT(p.isbn), l.titulo FROM prestamos p INNER JOIN libros l ON p.isbn = l.isbn GROUP BY l.titulo limit 1;

--Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días.(0.5 puntos)


SELECT rut_socios, ((fecha_devolucion - fecha_prestamo)-7)*100 AS MULTA FROM prestamos p
WHERE (fecha_devolucion - fecha_prestamo) > 7;
