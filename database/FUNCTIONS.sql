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