-- en caso de tener problemas al momento de crear el trigger o los procedimientos o las funciones entonces ejecutar el siguiente script
SET GLOBAL log_bin_trust_function_creators = 1;

-- ======================================================================

/*
Para comprender estos 5 puntos de la prueba, se debe leer el documento Test MySQL.pdf, donde se explica que se desea realizar en cada uno de estos puntos
*/

-- ======================================================================

-- 1. estructura trigger
drop trigger if exists documentTypeNew;

DELIMITER //
create trigger documentTypeNew
    after insert on documenttypes
    for each row
begin
    -- la solución debe ir aquí
end; //
DELIMITER ;

-- =======================================================================

/* 2 estructrura función: crear factura
    - nombre del cliente
    - nombre del tipo de documento
*/
drop function if exists guardarFactura;

DELIMITER //

CREATE function guardarFactura(_persona VARCHAR(50), _tipoDocumento VARCHAR(50)) RETURNS VARCHAR(250)
BEGIN
    
    DECLARE IdNew int; -- esta variable es para asiganar el id de la factura que se guardó
    DECLARE salida varchar(250); -- variable de respuesta

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIn
       RETURN  'Error al tratar de guarda la factura';
    END;

    -- la solución va aquí
    
    IF EXISTS (SELECT * FROM documenttypes WHERE name = _tipoDocumento)
    BEGIN
        -- Obtener el ID del tipo de documento existente
        SET @tipo_documento_id = (SELECT id FROM documenttypes WHERE name = _tipoDocumento)
    END
    ELSE
    BEGIN
        -- Si no existe, crear el nuevo tipo de documento
        INSERT INTO documenttypes (name) VALUES (_tipoDocumento)
        SET @tipo_documento_id = SCOPE_IDENTITY()
    END
    
    -- Insertar la factura en la tabla invoices
    INSERT INTO invoices (person, document_type_id) VALUES (_persona, @tipo_documento_id)
    DECLARE @invoice_id int
    SET @invoice_id = SCOPE_IDENTITY()
    
    -- Retornar el ID de la factura
    RETURN @invoice_id
    
    
    -- SET salida = concat('La factura se almacenó correctamente con el ID: ', CONVERT(IdNew, CHAR(50)));
    -- RETURN salida;
END
//

-- =============================================================

/* 3 agregar productos 
    - nombre del producto
    - valor del producto
    - id de la factura
*/
drop function if exists agregarProductos;

DELIMITER //

CREATE function agregarProductos(_producto VARCHAR(50), _valor DECIMAL(16, 4), _idFactura int) RETURNS VARCHAR(250)
BEGIN
    DECLARE salida varchar(250);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIn
       RETURN  'Error al tratar de agregar productos a la factura';
    END;

    -- la solución va aquí

    SET salida = concat('El producto: ', _producto, ', fue agregado correctamente.');
    RETURN salida;
END
//

-- ===================================================================

/* 4 modificar o quitar productos de la factura
    - nombre del producto
    - valor del producto
    - id de la factura
    - acción: U = Modificar / D = Eliminar
*/
drop function if exists modificarQuitarProductos;

DELIMITER //

CREATE function modificarQuitarProductos(_producto VARCHAR(50), _valor DECIMAL(16, 4), _idFactura int, _action char(1)) RETURNS VARCHAR(250)
BEGIN
    DECLARE salida varchar(250);
    DECLARE nuevoValor DECIMAL(16, 4);

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
       RETURN  'Error al tratar de agregar productos a la factura';
    END;
    
    -- la solución va aquí

    SET salida = concat('El producto: ', _producto, ', fue ', if(_action = 'U', 'modificado', 'eliminado'), ' correctamente.');
    RETURN salida;
END
//

-- ===========================================================================

/* 5. Crear una vista llamada reports
- fecha de la factura
- numero de la factura
- persona o cliente de la factura
- tipo de factura
- producto
- valor del producto
 */

create or replace view reports as
    -- la solución va aquí


-- ==================================
--         validar resultados
-- ==================================
/*De la siguiente forma se hacen los llamados a las funciones*/
SELECT guardarFactura('Andres Baragan','pago') as Resultado;
SELECT agregarProductos('Pago de servicio', 113000, 6) as Resultado;
SELECT modificarQuitarProductos('Laptop', 0, 2, 'D') as Resultado;

/*Asi llamamos la vista del punto 5*/
select * from reports;