-- Poner en uso la base de datos
USE Tienda_maquillaje;

-- Función para verificar si existe el tipo de cosmético ingresado
DELIMITER $$
CREATE FUNCTION fn_existencia_tipo_cosmetico(p_tipo_cosmetico VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
	-- Variable de tipo cosmetico existente
	DECLARE cosmetico_encontrado VARCHAR(50) DEFAULT NOT NULL;
    
    -- Buscar si el tipo de cosmetico existe
	SELECT TC.tipo_cosmetico INTO cosmetico_encontrado
	FROM Tipos_cosmeticos TC
	WHERE TC.tipo_cosmetico = p_tipo_cosmetico;
    
    RETURN cosmetico_encontrado;
END $$
DELIMITER ; 

-- Función para verificar la existencia de la categoría ingresada
DELIMITER $$
CREATE FUNCTION fn_existencia_categoria(p_id_categoria INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	-- Variable de id categoría existente
    DECLARE id_categoria_encontrada INT DEFAULT NULL;
    
    -- Buscar el id de la categoría
	SELECT C.id_categoria INTO id_categoria_encontrada
    FROM Categorias C
    WHERE C.id_categoria = p_id_categoria;
    
    RETURN id_categoria_encontrada;
END $$
DELIMITER ;

-- Función para verificar la existencia del cliente ingresado
 DELIMITER $$
CREATE FUNCTION fn_existencia_cliente(p_id_cliente INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	-- Variable para buscar el id del cliente
    DECLARE cliente_existe INT DEFAULT NULL;
    
	-- Buscar el Id del cliente 
	SELECT C.id_cliente INTO cliente_existe
    FROM Clientes C
    WHERE C.id_cliente = p_id_cliente;
    
    RETURN cliente_existe;
END $$
DELIMITER; 

-- Función para calcular la cantidad de compras realizadas por el cliente que se ingresa
DELIMITER $$
CREATE FUNCTION fn_cantidad_compras_cliente(p_id_cliente INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	-- Variable para tener la cantidad de compras
    DECLARE cantidad_ventas INT DEFAULT 0;
    
	-- Obtener la cantidad de compras
	SELECT COUNT(V.cliente_id) INTO cantidad_ventas
    FROM Ventas V
    WHERE V.cliente_id = p_id_cliente;
    
    RETURN cantidad_ventas;
END $$
DELIMITER; 

-- Función para calcular la cantidad de ventas a un cliente en un rango
-- de fechas ingresadas
DELIMITER $$
CREATE FUNCTION fn_cantidad_ventas_cliente(
	p_id_cliente INT,
    p_fecha_inicial DATE,
    p_fecha_final DATE
)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN

	-- Variable para la cantidad de ventas en el rango determinado
	DECLARE cantidad_ventas_rango INT DEFAULT 0;
      
	SELECT COUNT(V.id_venta) INTO cantidad_ventas_rango
	FROM Ventas V
	INNER JOIN Clientes C ON C.id_cliente = V.cliente_id
	WHERE CAST(fecha_venta AS DATE) BETWEEN CAST(p_fecha_inicial AS DATE) AND CAST(p_fecha_final AS DATE)
	AND V.cliente_id = p_id_cliente;
        
	RETURN cantidad_ventas_rango;
END $$
DELIMITER ;

-- Función para calcular la existencia del empleado ingresado
DELIMITER $$
CREATE FUNCTION fn_existencia_empleado(p_id_empleado INT)
RETURNS INT
DETERMINISTIC 
READS SQL DATA
BEGIN
	-- Declaramos la variable para obtener el id del empleado
    DECLARE existe_empleado INT DEFAULT NULL;
    
    -- Buscar el id del empleado y almacenarlo en la variable
    SELECT E.id_empleado INTO existe_empleado
    FROM Empleados E
    WHERE E.id_empleado = p_id_empleado;
    
    RETURN existe_empleado;
END $$
DELIMITER ;

-- Función para calcular las ventas de un empleado en un mes y año en especifico
DELIMITER $$
CREATE FUNCTION fn_calculo_venta_empleado_mes(
	p_id_empleado INT,
    p_mes INT,
    p_anio INT
)
RETURNS INT
DETERMINISTIC 
READS SQL DATA
BEGIN
	-- Declaramos la variable para obtener la cantidad de ventas
    DECLARE cantidad_ventas INT DEFAULT NULL;
    
    -- Buscar el id del empleado y almacenarlo en la variable
    SELECT COUNT(V.id_venta) INTO cantidad_ventas
	FROM Ventas V
	INNER JOIN Empleados E ON E.id_empleado = V.empleado_id
	WHERE MONTH(V.fecha_venta) = p_mes AND YEAR(V.fecha_venta) = p_anio
	AND V.empleado_id = p_id_empleado;
    
    RETURN cantidad_ventas;
END $$
DELIMITER ;

-- Función para verificar si existe un producto por su ID
DELIMITER $$
CREATE FUNCTION fn_existencia_producto_id(p_id_producto INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    -- Declaramos la variable para obtener el id del producto
    DECLARE existe_producto INT DEFAULT NULL;

    -- Buscar el id del producto y almacenarlo en la variable
    SELECT P.id_producto INTO existe_producto
    FROM Productos P
    WHERE P.id_producto = p_id_producto;

    RETURN existe_producto;
END $$
DELIMITER ;

-- Función para verificar cuántos productos coinciden con un nombre
DELIMITER $$
CREATE FUNCTION fn_existencia_producto_nombre(p_nombre_producto VARCHAR(100))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    -- Declaramos la variable para contar coincidencias
    DECLARE cantidad_encontrada INT DEFAULT 0;

    -- Contar cuantos productos coinciden con el nombre ingresado
    SELECT COUNT(*) INTO cantidad_encontrada
    FROM Productos P
    WHERE P.nombre LIKE CONCAT('%', p_nombre_producto, '%');

    RETURN cantidad_encontrada;
END $$
DELIMITER ;

-- Función para verificar si existe un proveedor por su ID
DELIMITER $$
CREATE FUNCTION fn_existencia_proveedor(p_id_proveedor INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    -- Declaramos la variable para obtener el id del proveedor
    DECLARE existe_proveedor INT DEFAULT NULL;

    -- Buscar el id del proveedor y almacenarlo en la variable
    SELECT P.id_proveedor INTO existe_proveedor
    FROM Proveedores P
    WHERE P.id_proveedor = p_id_proveedor;

    RETURN existe_proveedor;
END $$
DELIMITER ;

-- Stored Procedure para consultar las ventas de un producto especifico por id y cuantas unidades se vendieron
DELIMITER $$
CREATE PROCEDURE sp_ventas_producto_por_id(
    IN p_id_producto INT
)
BEGIN
    -- Declarar las variables
    DECLARE v_existe_producto INT DEFAULT NULL;
    DECLARE v_cantidad_registros INT DEFAULT 0;

    -- Excepción de errores
    DECLARE EXIT HANDLER FOR SQLSTATE '42S02'
    BEGIN
        SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;

    -- Validar que el id no sea negativo o cero
    IF p_id_producto <= 0 THEN
        SELECT 'No se aceptan valores menores o iguales a 0' AS 'Mensaje Error';
    ELSE
        -- Usar la funcion para verificar si el producto existe
        SET v_existe_producto = fn_existencia_producto_id(p_id_producto);

        IF v_existe_producto IS NULL THEN
            SELECT 'El producto ingresado no existe' AS 'Mensaje Error';
        ELSE
            -- Contar cuantos registros de venta tiene ese producto
            SELECT COUNT(*) INTO v_cantidad_registros
            FROM Detalle_Venta_Productos D
            WHERE D.producto_id = p_id_producto;

            IF v_cantidad_registros = 0 THEN
                SELECT 'El producto ingresado no tiene ventas registradas' AS 'Mensaje Error';
            ELSE
                SELECT 
                    V.id_venta AS 'ID Venta',
                    P.nombre AS 'Nombre del Producto',
                    CAST(V.fecha_venta AS DATE) AS 'Fecha de Venta',
                    D.cantidad_producto AS 'Unidades Vendidas',
                    D.precio_unitario AS 'Precio Unitario',
                    D.subtotal AS 'Subtotal'
                FROM Detalle_Venta_Productos D
                INNER JOIN Ventas V ON V.id_venta = D.ventas_id
                INNER JOIN Productos P ON P.id_producto = D.producto_id
                WHERE D.producto_id = p_id_producto
                ORDER BY V.fecha_venta DESC;
            END IF;
        END IF;
    END IF;
END $$
DELIMITER ;
