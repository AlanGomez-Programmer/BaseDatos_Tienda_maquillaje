-- Poner en uso la base de datos
USE Tienda_maquillaje;

-- CONSULTA 1: Listar todos los productos de cosméticos de un tipo especifico
-- Antes de hacer la pregunta en especifico se recomienda ver que tipo de cosmetico se tiene
SELECT tipo_cosmetico FROM Tipos_cosmeticos;
-- Ejemplo consulta:
SET @Tipo_cosmetico = 'Base liquida'; -- Variable de tipo de cosmetico
CALL sp_consulta_cosmetico_tipo_especifico(@Tipo_cosmetico);

-- CONSULTA 2: Obtener todos los productos en una categoria en especifica cuyo stock sea inferior a un valor dado
-- Antes de hacer la pregunta en especifico se recomienda ver los ids de las categorías existentes
SELECT * FROM Categorias;
-- Ejemplo consulta:
SET @Id_categoria = 2; -- Variable de id de categoria
SET @Stock = 40; -- Variable de valor de stock
CALL sp_productos_categoria_stockInferior(@Id_categoria, @Stock);

-- CONSULTA 3: Mostrar todas las ventas realizadas por un cliente especifico en un rango de fechas
-- Antes de hacer la pregunta en especifico se recomienda ver los ids de los clientes y las fechas de ventas existentes
SELECT id_venta, DATE(fecha_venta) FROM Ventas;
-- Ejemplo consulta:
SET @Id_cliente = 1; -- Variable de id de cliente
SET @Fecha_inicio = '2026-01-01'; -- Variable de fecha inicio
SET @Fecha_fin = '2026-03-30'; -- Variable de fecha fin
CALL sp_ventas_clientes_rango_fechas(@Id_cliente, @Fecha_inicio, @Fecha_fin);

-- CONSULTA 4: Calcular el total de ventas realizadas por un empleado en un mes dado
-- Antes de hacer la pregunta en especifico se recomienda ver los ids de los empleados existentes
SELECT id_empleado, nombre_completo FROM Empleados;
-- Ejemplo consulta:
SET @Id_empleado = 1; -- Variable de id de empleado
SET @Mes = 3; -- Variable de mes
SET @Anio = 2026; -- Variable de año
CALL sp_calcular_total_ventas_mes_empleado(@Id_empleado, @Mes, @Anio);

-- CONSULTA 5: Listar los productos mas vendidos en un periodo determinado
-- Antes de hacer la pregunta en especifico se recomienda ver las fechas de ventas existentes
SELECT id_venta, DATE(fecha_venta) FROM Ventas;
-- Ejemplo consulta:
SET @Fecha_inicio = '2026-01-01'; -- Variable de fecha inicio
SET @Fecha_fin = '2026-03-30'; -- Variable de fecha fin
CALL sp_productos_mas_vendidos_periodo(@Fecha_inicio, @Fecha_fin);

-- CONSULTA 6: Consultar el stock disponible de un producto por su nombre o identificador
-- Antes de hacer la pregunta en especifico se recomienda ver los productos existentes
SELECT id_producto, nombre FROM Productos;
-- Ejemplo consulta (busqueda por ID):
SET @Id_producto = 1; -- Variable de id de producto
SET @Nombre_producto = NULL; -- Variable de nombre de producto
CALL sp_consultar_stock_producto(@Id_producto, @Nombre_producto);
-- Ejemplo consulta (busqueda por nombre):
SET @Id_producto = NULL; -- Variable de id de producto
SET @Nombre_producto = 'Chanel'; -- Variable de nombre de producto
CALL sp_consultar_stock_producto(@Id_producto, @Nombre_producto);

-- CONSULTA 7: Mostrar las ordenes de compra realizadas a un proveedor en el ultimo año
-- Antes de hacer la pregunta en especifico se recomienda ver los ids de los proveedores existentes
SELECT id_proveedor, nombre_empresa FROM Proveedores;
-- Ejemplo consulta:
SET @Id_proveedor = 1; -- Variable de id de proveedor
CALL sp_ordenes_compra_proveedor_ultimo_anio(@Id_proveedor);

-- CONSULTA 8: Listar los empleados que han trabajado mas de un año en la tienda
-- Ejemplo consulta:
CALL sp_empleados_mas_un_anio();

-- CONSULTA 9: Obtener la cantidad total de productos vendidos en un dia especifico
-- Antes de hacer la pregunta en especifico se recomienda ver las fechas de ventas existentes
SELECT id_venta, DATE(fecha_venta) FROM Ventas;
-- Ejemplo consulta:
SET @Fecha = '2026-03-20'; -- Variable de fecha
CALL sp_cantidad_productos_vendidos_dia(@Fecha);

-- CONSULTA 10: Consultar las ventas de un producto especifico por id y cuantas unidades se vendieron
-- Antes de hacer la pregunta en especifico se recomienda ver los ids de los productos existentes
SELECT id_producto, nombre FROM Productos;
-- Ejemplo consulta:
SET @Id_producto = 1; -- Variable de id de producto
CALL sp_ventas_producto_por_id(@Id_producto);