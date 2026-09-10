-- Stored Procedure para consulta de productos de un tipo de cosmetico en especifico
DELIMITER $$
CREATE PROCEDURE sp_consulta_cosmetico_tipo_especifico(
	IN p_tipo_cosmetico VARCHAR(50)
)
BEGIN 
	-- Variable de tipo cosmetico existente
    DECLARE cosmetico_encontrado VARCHAR(50) DEFAULT NOT NULL;
    DECLARE cantidad_de_producto INT DEFAULT 0;

	-- Excepción de erroes
	DECLARE EXIT HANDLER FOR SQLSTATE '42S02' # Si no se encuentra la tabla
    BEGIN
		SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;
   
    -- Buscar si el tipo de cosmetico existe
    SET cosmetico_encontrado = fn_existencia_tipo_cosmetico(p_tipo_cosmetico);
    
    -- Contar la cantidad de productos
    SELECT COUNT(P.id_producto) INTO cantidad_de_producto
	FROM Productos P
	INNER JOIN Categorias C ON C.id_categoria = P.categoria_id
	INNER JOIN Tipos_cosmeticos TC ON TC.tipo_cosmetico = p_tipo_cosmetico
	INNER JOIN Cosmeticos CM ON CM.tipo_cosmetico_id = TC.id_tipo_cosmetico
	WHERE CM.producto_id = P.id_producto;

	IF cosmetico_encontrado IS NULL THEN 
		SELECT 'No existe ese tipo de cosmético' AS 'Mensaje de error';
	ELSEIF cantidad_de_producto = 0 THEN
		SELECT CONCAT(p_tipo_cosmetico, ' No tiene productos registrados aún') AS 'Mensaje de error';
	ELSE
		-- Consulta
		SELECT P.id_producto, P.nombre AS 'Nombre Producto', P.descripcion AS 'Descripción', P.precio AS 'Precio', P.stock AS 'Stock'
		FROM Productos P
		INNER JOIN Categorias C ON C.id_categoria = P.categoria_id
		INNER JOIN Tipos_cosmeticos TC ON TC.tipo_cosmetico = p_tipo_cosmetico
		INNER JOIN Cosmeticos CM ON CM.tipo_cosmetico_id = TC.id_tipo_cosmetico
		WHERE CM.producto_id = P.id_producto;
	END IF;
END $$
DELIMITER ;

-- Stored Procedure para obtener todos los productos en una categoría en específica cuyo stock sea inferior a un valor dado
DELIMITER $$
CREATE PROCEDURE sp_productos_categoria_stockInferior(
	IN p_id_categoria INT,
    IN p_stock INT
)
BEGIN
	-- Variable de id categoría existente
    DECLARE v_id_categoria_encontrada INT DEFAULT NULL;
    
    -- Excepción de erroes
	DECLARE EXIT HANDLER FOR SQLSTATE '42S02' # Si no se encuentra la tabla
    BEGIN
		SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;
    
    -- Buscar el id de la categoría
	SET v_id_categoria_encontrada = fn_existencia_categoria(p_id_categoria);
    
    IF p_stock <= 0 THEN
		SELECT 'No se aceptan valores menores a 0' AS 'Mensaje Error';
	ELSEIF v_id_categoria_encontrada IS NULL THEN
		SELECT 'No existen productos con el ID de la categoría que ingreso' AS 'Mensaje error';
	ELSE
		SELECT P.id_producto, P.nombre AS 'Nombre del producto', C.categoria 'Categoría', P.stock AS 'Stock'
        FROM Productos P
        INNER JOIN Categorias C ON C.id_categoria = P.categoria_id
        WHERE P.stock < p_stock AND P.categoria_id = p_id_categoria;
	END IF;
END $$
DELIMITER ;


-- Stored Procedure para mostrar todas las ventas realizadas por un cliente especifico en un rango de fechas
DELIMITER $$
CREATE PROCEDURE sp_ventas_clientes_rango_fechas(
	IN p_id_cliente INT,
    IN p_fecha_inicial DATE,
    IN p_fecha_final DATE
)
BEGIN
	
    -- Variable para buscar el id del cliente
    DECLARE v_cliente_existe INT DEFAULT NULL;
    DECLARE v_cantidad_ventas INT DEFAULT 0;
    DECLARE v_cantidad_ventas_rango INT DEFAULT 0;
    
     -- Excepción de erroes
	DECLARE EXIT HANDLER FOR SQLSTATE '42S02' # Si no se encuentra la tabla
    BEGIN
		SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;
    
    -- Buscar el Id del cliente 
   SET v_cliente_existe = fn_existencia_cliente(p_id_cliente);
    
    -- Revisar si el cliente tiene compras
    SET v_cantidad_ventas = fn_cantidad_compras_cliente(p_id_cliente);
    
    IF v_cliente_existe IS NULL THEN 
		SELECT 'El cliente ingresado no existe' AS 'Mensaje error';
	ELSEIF v_cantidad_ventas = 0 THEN
		SELECT 'El cliente ingresado no tiene compras' AS 'Mensaje error';
	ELSE
		
        SET v_cantidad_ventas_rango = fn_cantidad_ventas_cliente(p_id_cliente, p_fecha_inicial, p_fecha_final);
        
        IF v_cantidad_ventas_rango = 0 THEN
			SELECT 'El cliente ingresado no tiene compras en ese rango de fechas' AS 'Mensaje error';
		ELSE
			SELECT V.id_venta, C.id_cliente, C.nombre_completo AS 'Nombre Cliente', CAST(fecha_venta AS DATE) AS 'Fecha'
			FROM Ventas V
			INNER JOIN Clientes C ON C.id_cliente = V.cliente_id
			WHERE CAST(fecha_venta AS DATE) BETWEEN CAST(p_fecha_inicial AS DATE) AND CAST(p_fecha_final AS DATE)
            AND V.cliente_id = p_id_cliente;
		END IF;
    END IF;
END $$
DELIMITER ;

-- Stored Procedure para mostrar todas las ventas realizadas por empleado especifico en un mes dado
DELIMITER $$
CREATE PROCEDURE sp_calcular_total_ventas_mes_empleado(
	IN p_id_empleado INT,
    IN p_mes INT,
    IN p_anio INT
)
BEGIN
    -- Declarar las variables
    DECLARE existe_empleado INT DEFAULT NULL;
    DECLARE cantidad_ventas INT DEFAULT 0;
    
	-- Excepción de erroes
	DECLARE EXIT HANDLER FOR SQLSTATE '42S02' # Si no se encuentra la tabla
    BEGIN
		SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;
    
    DECLARE EXIT HANDLER FOR SQLSTATE '42S22' # Si no se encuentra la tabla
    BEGIN
		SELECT 'Algo salio mal, porfavor revisa las tablas' AS 'Mensaje Error';
    END;
    
    SET existe_empleado = fn_existencia_empleado(p_id_empleado);
    SET cantidad_ventas = fn_calculo_venta_empleado_mes(p_id_empleado, p_mes, p_anio);
    
    IF p_id_empleado <= 0 OR p_mes <= 0 OR p_anio <= 0 THEN
		SELECT 'No se aceptan valores menores a 0' AS 'Mensaje error';
    ELSEIF existe_empleado IS NULL THEN
		SELECT 'El empleado ingresado no existe' AS 'Mensaje error';
	ELSEIF cantidad_ventas = 0 THEN
		SELECT 'El empleado ingresado no tiene ventas' AS 'Mensaje error';
    ELSE
		SELECT V.empleado_id, E.nombre_completo, COUNT(V.id_venta) AS 'Cantidad Ventas'
		FROM Ventas V
		INNER JOIN Empleados E ON E.id_empleado = V.empleado_id
		WHERE MONTH(V.fecha_venta) = p_mes AND YEAR(V.fecha_venta) = p_anio
		AND V.empleado_id = p_id_empleado
        GROUP BY V.empleado_id, E.nombre_completo;
	END IF;
END $$
DELIMITER ;

-- Stored Procedure para listar los productos más vendidos en un período determinado
DELIMITER $$
CREATE PROCEDURE sp_productos_mas_vendidos_periodo(
    IN p_fecha_inicial DATE,
    IN p_fecha_final DATE
)
BEGIN
    -- Excepción de errores
    DECLARE EXIT HANDLER FOR SQLSTATE '42S02'
    BEGIN
        SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;

    IF p_fecha_inicial > p_fecha_final THEN
        SELECT 'La fecha inicial no puede ser mayor a la fecha final' AS 'Mensaje Error';
    ELSE
        SELECT 
            P.id_producto, 
            P.nombre AS 'Nombre del producto', 
            SUM(D.cantidad_producto) AS 'Cantidad Vendida'
        FROM Detalle_Venta_Productos D
        INNER JOIN Ventas V ON V.id_venta = D.ventas_id
        INNER JOIN Productos P ON P.id_producto = D.producto_id
        WHERE CAST(V.fecha_venta AS DATE) BETWEEN p_fecha_inicial AND p_fecha_final
        GROUP BY P.id_producto, P.nombre
        ORDER BY SUM(D.cantidad_producto) DESC;
    END IF;
END $$
DELIMITER ;

-- Stored Procedure para consultar el stock disponible de un producto por su nombre o identificador
DELIMITER $$
CREATE PROCEDURE sp_consultar_stock_producto(
    IN p_id_producto INT,
    IN p_nombre_producto VARCHAR(100)
)
BEGIN
    -- Declarar las variables
    DECLARE v_existe_producto_id INT DEFAULT NULL;
    DECLARE v_cantidad_producto_nombre INT DEFAULT 0;

    -- Excepción de errores
    DECLARE EXIT HANDLER FOR SQLSTATE '42S02'
    BEGIN
        SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;

    IF p_id_producto IS NULL AND p_nombre_producto IS NULL THEN
        SELECT 'Debe ingresar un ID o un nombre de producto' AS 'Mensaje Error';
    ELSE
        -- Usar la funcion correspondiente segun el parametro que venga
        IF p_id_producto IS NOT NULL THEN
            SET v_existe_producto_id = fn_existencia_producto_id(p_id_producto);
        END IF;

        IF p_nombre_producto IS NOT NULL THEN
            SET v_cantidad_producto_nombre = fn_existencia_producto_nombre(p_nombre_producto);
        END IF;

        IF p_id_producto IS NOT NULL AND v_existe_producto_id IS NULL THEN
            SELECT 'No existe ningun producto con ese ID' AS 'Mensaje Error';
        ELSEIF p_nombre_producto IS NOT NULL AND v_cantidad_producto_nombre = 0 THEN
            SELECT 'No existe ningun producto con ese nombre' AS 'Mensaje Error';
        ELSE
            SELECT 
                id_producto AS 'ID Producto', 
                nombre AS 'Nombre del producto', 
                stock AS 'Stock disponible'
            FROM Productos
            WHERE (p_id_producto IS NOT NULL AND id_producto = p_id_producto)
               OR (p_nombre_producto IS NOT NULL AND nombre LIKE CONCAT('%', p_nombre_producto, '%'));
        END IF;
    END IF;
END $$
DELIMITER ;

-- Stored Procedure para mostrar las ordenes de compra realizadas a un proveedor en el ultimo año. 
DELIMITER $$
CREATE PROCEDURE sp_ordenes_compra_proveedor_ultimo_anio(
    IN p_id_proveedor INT
)
BEGIN
    -- Declarar las variables
    DECLARE v_existe_proveedor INT DEFAULT NULL;
    DECLARE v_cantidad_ordenes INT DEFAULT 0;

    -- Excepción de errores
    DECLARE EXIT HANDLER FOR SQLSTATE '42S02'
    BEGIN
        SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;

    -- Validar que el id no sea negativo o cero
    IF p_id_proveedor <= 0 THEN
        SELECT 'No se aceptan valores menores o iguales a 0' AS 'Mensaje Error';
    ELSE
        -- Usar la funcion para verificar si el proveedor existe
        SET v_existe_proveedor = fn_existencia_proveedor(p_id_proveedor);

        IF v_existe_proveedor IS NULL THEN
            SELECT 'El proveedor ingresado no existe' AS 'Mensaje Error';
        ELSE
            -- Contar cuantas ordenes tiene ese proveedor en el ultimo anio
            SELECT COUNT(*) INTO v_cantidad_ordenes
            FROM Ordenes_Compras OC
            WHERE OC.proveedor_id = p_id_proveedor
              AND OC.fecha_orden >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

            IF v_cantidad_ordenes = 0 THEN
                SELECT 'El proveedor no tiene ordenes de compra en el ultimo anio' AS 'Mensaje Error';
            ELSE
                SELECT 
                    OC.id_orden_compra AS 'ID Orden', 
                    P.nombre_empresa AS 'Proveedor', 
                    OC.fecha_orden AS 'Fecha de Orden'
                FROM Ordenes_Compras OC
                INNER JOIN Proveedores P ON P.id_proveedor = OC.proveedor_id
                WHERE OC.proveedor_id = p_id_proveedor
                  AND OC.fecha_orden >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
                ORDER BY OC.fecha_orden DESC;
            END IF;
        END IF;
    END IF;
END $$
DELIMITER ;

-- Stored Procedure para listar los empleados que han trabajado mas de un año en la tienda
DELIMITER $$
CREATE PROCEDURE sp_empleados_mas_un_anio()
BEGIN
    -- Declarar las variables
    DECLARE v_cantidad_empleados INT DEFAULT 0;

    -- Excepción de errores
    DECLARE EXIT HANDLER FOR SQLSTATE '42S02'
    BEGIN
        SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;

    -- Contar cuantos empleados cumplen la condicion
    SELECT COUNT(*) INTO v_cantidad_empleados
    FROM Empleados E
    WHERE E.fecha_contratacion <= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

    IF v_cantidad_empleados = 0 THEN
        SELECT 'No hay empleados con mas de un año trabajando en la tienda' AS 'Mensaje Error';
    ELSE
        SELECT 
            E.id_empleado AS 'ID Empleado', 
            E.nombre_completo AS 'Nombre del Empleado', 
            E.fecha_contratacion AS 'Fecha de Contratacion',
            TIMESTAMPDIFF(YEAR, E.fecha_contratacion, CURDATE()) AS 'Años Trabajados'
        FROM Empleados E
        WHERE E.fecha_contratacion <= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
        ORDER BY E.fecha_contratacion ASC;
    END IF;
END $$
DELIMITER ;

-- Stored Procedure para obtener la cantidad total de productos vendidos en un dia especifico
DELIMITER $$
CREATE PROCEDURE sp_cantidad_productos_vendidos_dia(
    IN p_fecha DATE
)
BEGIN
    -- Declarar las variables
    DECLARE v_cantidad_total INT DEFAULT 0;

    -- Excepción de errores
    DECLARE EXIT HANDLER FOR SQLSTATE '42S02'
    BEGIN
        SELECT 'Algo salio mal, porfavor revisa si existe la tabla' AS 'Mensaje Error';
    END;

    -- Validar que la fecha no sea nula
    IF p_fecha IS NULL THEN
        SELECT 'Debe ingresar una fecha valida' AS 'Mensaje Error';
    ELSE
        -- Sumar la cantidad de productos vendidos en esa fecha
        SELECT SUM(D.cantidad_producto) INTO v_cantidad_total
        FROM Detalle_Venta_Productos D
        INNER JOIN Ventas V ON V.id_venta = D.ventas_id
        WHERE CAST(V.fecha_venta AS DATE) = p_fecha;

        IF v_cantidad_total IS NULL THEN
            SELECT 'No se registraron ventas en la fecha ingresada' AS 'Mensaje Error';
        ELSE
            SELECT 
                p_fecha AS 'Fecha', 
                v_cantidad_total AS 'Cantidad Total de Productos Vendidos';
        END IF;
    END IF;
END $$
DELIMITER ;