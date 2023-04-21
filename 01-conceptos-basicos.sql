/* 
Teniendo en cuenta los archivos:

- softpymes_test.png
- script-prueba-1.sql

Generar scripts que realicen las siguientes consultas:
*/

/* 1. Consultar los items que pertenezcan a la compañia con ID #3 (debe utilizar INNER JOIN) */

SELECT *
FROM items
INNER JOIN companies ON items.companyId = companies.id
WHERE companies.id = 3;


/* 2. Mostrar los items para los cuales su precio se encuentre en el rango 70000 a 90000*/

SELECT *
FROM items
WHERE price BETWEEN 70000 AND 90000;


/* 3. Mostrar los items que en el nombre inicien con la letra "A" */

SELECT *
FROM items
WHERE name LIKE 'A%';

/* 4. Mostrar los items que tengan relacionado el color Rojo */

SELECT items.*
FROM items
INNER JOIN colors ON items.colorId = colors.id
WHERE colors.name = 'ROJO';


/* 5. Se requiere asignar un precio a los items cuyo precio sea NULL, 
el precio a agregar debe ser calculado de la siguiente forma: costo del item + 10.000*/

UPDATE items
SET price = cost + 10000
WHERE price IS NULL;

/* 6. Incrementar el precio de los items en un 20% */

UPDATE items
SET price = price * 1.2;

/* 7. Consultar los items por nombre y limitar la consulta para que sea paginada por un 
limite de 5 registros por página */

SELECT * FROM items WHERE name LIKE '%vestido%' LIMIT 5 OFFSET 0;

/* 8. Eliminar los items que pertenezcan a la compañía con ID #1  (Debe usar inner join)*/

DELETE items
FROM items
INNER JOIN companies
ON items.companyId = companies.id
WHERE companies.id = 1;

/* 9. Eliminar los items que tengan el costo menor a 10.000 */

DELETE FROM items
WHERE cost < 10000;

/* 10. Cree una función que permita insertar registros en la tabla colores*/

DROP FUNCTION IF EXISTS insertar_color;
DELIMITER //

CREATE FUNCTION insertar_color(code_color VARCHAR(3), name_color VARCHAR(25))
RETURNS INT
BEGIN
    DECLARE color_id INT;

    INSERT INTO colors(colors.code, colors.name)  VALUES (code_color, name_color);
    SET color_id = LAST_INSERT_ID();

    RETURN color_id;
END //

DELIMITER ;

SELECT insertar_color('10', 'Red');

/* 11. Eliminar todos los datos de la tabla colores
ALTER TABLE tabla2
ADD CONSTRAINT fk_tabla1
FOREIGN KEY (id_tabla1)
REFERENCES tabla1(id_tabla1)
ON DELETE CASCADE;
La cláusula ON DELETE CASCADE indica que cuando un registro en 'tabla1' se elimina, MySQL también eliminará automáticamente los registros relacionados en 'tabla2'. 

*/

DELETE FROM colors;


/* 12. Agregar un campo llamado "isdelete" en la tabla items, que no permita ser NULL,
debe tener un valor por defecto = 0 debe ser un campo númerico, tener un comentario que diga
(0=No se borra / 1=Se borra) cantidad permitida de caracteres = 1 */

ALTER TABLE items
ADD COLUMN isdelete TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0=No se borra / 1=Se borra';