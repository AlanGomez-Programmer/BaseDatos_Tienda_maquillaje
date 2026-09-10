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
