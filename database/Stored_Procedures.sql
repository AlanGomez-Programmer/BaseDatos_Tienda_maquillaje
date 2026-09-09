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
	SELECT TC.tipo_cosmetico INTO cosmetico_encontrado
	FROM Tipos_cosmeticos TC
	WHERE TC.tipo_cosmetico = p_tipo_cosmetico;
    
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
    SELECT C.id_categoria INTO v_id_categoria_encontrada
    FROM Categorias C
    WHERE C.id_categoria = p_id_categoria;
    
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