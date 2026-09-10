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

