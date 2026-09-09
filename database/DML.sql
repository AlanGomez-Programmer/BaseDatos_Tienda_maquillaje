USE Tienda_maquillaje;

-- Catalogos generales

INSERT INTO Categorias (categoria) VALUES
    ('Cosmeticos'),
    ('Cuidado de la piel'),
    ('Perfumes'),
    ('Accesorios');

INSERT INTO Tipos_cosmeticos (tipo_cosmetico) VALUES
    ('Base liquida'),
    ('Corrector'),
    ('Rubor'),
    ('Iluminador'),
    ('Sombra'),
    ('Delineador'),
    ('Mascara de pestanas'),
    ('Labial'),
    ('Brillo labial'),
    ('Polvo compacto');

INSERT INTO Colores (color) VALUES
    ('Rojo'),
    ('Rosa'),
    ('Naranja'),
    ('Amarillo'),
    ('Verde'),
    ('Azul'),
    ('Morado'),
    ('Cafe'),
    ('Negro'),
    ('Dorado');

INSERT INTO Tonos (color_id, tono) VALUES
    (1, 'Rojo cereza'),
    (2, 'Rosa petalo'),
    (3, 'Coral'),
    (4, 'Champagne'),
    (5, 'Oliva'),
    (6, 'Azul noche'),
    (7, 'Ciruela'),
    (8, 'Cafe cacao'),
    (9, 'Negro intenso'),
    (10, 'Dorado suave');

INSERT INTO Tipos_pieles (tipo_piel) VALUES
    ('Seca'),
    ('Grasa'),
    ('Mixta'),
    ('Normal');

INSERT INTO Componentes (nombre) VALUES
    ('Acido hialuronico'),
    ('Niacinamida'),
    ('Vitamina C'),
    ('Aloe vera'),
    ('Acido salicilico'),
    ('Ceramidas'),
    ('Colageno'),
    ('Te verde'),
    ('Manteca de karite'),
    ('Protector solar');

INSERT INTO Materiales (material) VALUES
    ('Acero inoxidable'),
    ('Aluminio'),
    ('Plastico'),
    ('Silicona'),
    ('Madera'),
    ('Algodon'),
    ('Nailon'),
    ('Vidrio'),
    ('Acrilico'),
    ('Bambu');

INSERT INTO Tipos_accesorios (tipo_accesorio) VALUES
    ('Brocha'),
    ('Esponja'),
    ('Pinza'),
    ('Rizador'),
    ('Espejo'),
    ('Organizador'),
    ('Neceser'),
    ('Lima'),
    ('Cepillo'),
    ('Aplicador');

INSERT INTO Unidades_medidas (medida) VALUES
    ('Cm'),
    ('Ml');

INSERT INTO Tamanios (tamanio, unidad_medida_id) VALUES
    (50.00, 2),
    (75.00, 2),
    (100.00, 2),
    (90.00, 2),
    (80.00, 2),
    (18.00, 1),
    (5.00, 1),
    (9.00, 1),
    (12.00, 1),
    (20.00, 1);

INSERT INTO Tipos_Aromas (tipo_aroma) VALUES
    ('Floral'),
    ('Citrico'),
    ('Frutal'),
    ('Amaderado'),
    ('Oriental'),
    ('Acuatico'),
    ('Dulce'),
    ('Fresco'),
    ('Herbal'),
    ('Almizclado');

-- Productos

INSERT INTO Productos (categoria_id, nombre, descripcion, precio, stock) VALUES
    (1, 'Maybelline Fit Me Base Liquida', 'Base liquida de cobertura media con acabado natural', 145.00, 40),
    (1, 'MAC Ruby Woo', 'Labial mate de alta pigmentacion tono rojo clasico', 285.00, 25),
    (1, 'L''Oreal Infallible Corrector', 'Corrector cremoso de larga duracion para ojeras', 110.00, 35),
    (1, 'NYX Paleta Sunset', 'Paleta de sombras en tonos calidos y terrosos', 195.00, 20),
    (1, 'Rimmel Volumen Mascara', 'Mascara de pestanas con efecto volumen intenso', 95.00, 45),
    (2, 'Nivea Crema Hidratante', 'Crema facial hidratante para piel seca', 65.00, 50),
    (2, 'Neutrogena Gel Limpiador', 'Gel limpiador facial para piel grasa', 75.00, 48),
    (2, 'CeraVe Crema Facial', 'Crema hidratante con ceramidas para piel mixta', 160.00, 30),
    (2, 'The Ordinary Serum Niacinamida', 'Serum concentrado de niacinamida al 10%', 135.00, 33),
    (2, 'Cetaphil Locion Corporal', 'Locion corporal hidratante de uso diario', 110.00, 28),
    (3, 'Chanel No. 5', 'Fragancia floral clasica de larga duracion', 1850.00, 10),
    (3, 'Dior Sauvage', 'Fragancia amaderada fresca para hombre', 1650.00, 12),
    (3, 'Carolina Herrera 212', 'Fragancia citrica juvenil y energizante', 890.00, 15),
    (3, 'Paco Rabanne Invictus', 'Fragancia acuatica deportiva para hombre', 780.00, 14),
    (3, 'Versace Bright Crystal', 'Fragancia frutal floral luminosa', 950.00, 11),
    (4, 'Real Techniques Brocha Base', 'Brocha profesional para aplicar base liquida', 165.00, 22),
    (4, 'Beautyblender Esponja Original', 'Esponja de maquillaje para difuminado perfecto', 120.00, 40),
    (4, 'Tweezerman Pinza Slant', 'Pinza de precision para depilacion de cejas', 195.00, 18),
    (4, 'Revlon Rizador de Pestanas', 'Rizador de pestanas de uso profesional', 85.00, 35),
    (4, 'Sephora Neceser Organizador', 'Neceser organizador de maquillaje de tela', 225.00, 16);

-- Cosmeticos

INSERT INTO Cosmeticos (producto_id, tipo_cosmetico_id, tono_id, fecha_expiracion) VALUES
    (1, 1, 4, '2028-01-31'),
    (2, 8, 1, '2028-02-29'),
    (3, 2, 4, '2028-03-31'),
    (4, 5, 5, '2028-04-30'),
    (5, 7, 9, '2028-05-31');

-- Cuidados de la piel

INSERT INTO Cuidados_piel (producto_id, tipo_piel_id, fecha_expiracion) VALUES
    (6, 1, '2028-06-30'),
    (7, 2, '2028-07-31'),
    (8, 3, '2028-08-31'),
    (9, 4, '2028-09-30'),
    (10, 1, '2028-10-31');

INSERT INTO Detalles_Componentes (cuidado_piel_id, componente_id) VALUES
    (1, 9),
    (2, 5),
    (3, 6),
    (4, 2),
    (5, 4);

-- Perfumes

INSERT INTO Perfumes (producto_id, tipo_aroma_id, tamanio_id) VALUES
    (11, 1, 1),
    (12, 4, 2),
    (13, 2, 3),
    (14, 6, 4),
    (15, 3, 5);

-- Accesorios

INSERT INTO Accesorios (producto_id, tipo_accesorio, material_id, tamanio_id) VALUES
    (16, 1, 7, 6),
    (17, 2, 4, 7),
    (18, 3, 1, 8),
    (19, 4, 1, 9),
    (20, 7, 6, 10);

-- Proveedores

INSERT INTO Proveedores (nombre_empresa, nombre_contacto, telefono, direccion) VALUES
    ('Cosmetica Chapina S.A.', 'Laura Gomez', '2234-5601', '5a Avenida 6-34 Zona 1, Guatemala'),
    ('Belleza Integral GT', 'Andres Ruiz', '2234-5602', '12 Calle 3-45 Zona 10, Guatemala'),
    ('Distribuciones Prisma', 'Camila Torres', '2234-5603', '6a Avenida 12-20 Zona 9, Guatemala'),
    ('Laboratorios Aura', 'Mateo Silva', '2234-5604', '3a Calle 8-15 Zona 4, Guatemala'),
    ('Importadora Venus', 'Sofia Castro', '2234-5605', 'Boulevard Los Proceres 20-11 Zona 10, Guatemala'),
    ('Mundo Cosmetico', 'Daniel Perez', '2234-5606', '15 Avenida 22-40 Zona 13, Guatemala'),
    ('Esencia Natural GT', 'Valentina Leon', '2234-5607', '4a Calle 14-09 Zona 2, Guatemala'),
    ('Pro Makeup Supply', 'Nicolas Rojas', '2234-5608', '7a Avenida 18-22 Zona 11, Guatemala'),
    ('Luna Beauty', 'Mariana Vidal', '2234-5609', 'Calzada Roosevelt 14-06 Zona 7, Guatemala'),
    ('Cuidado y Color', 'Juan Molina', '2234-5610', '10a Calle 27-16 Zona 12, Guatemala');

INSERT INTO Ordenes_Compras (proveedor_id, fecha_orden) VALUES
    (1, '2026-01-05'),
    (2, '2026-01-12'),
    (3, '2026-01-19'),
    (4, '2026-02-02'),
    (5, '2026-02-09'),
    (6, '2026-02-16'),
    (7, '2026-02-23'),
    (8, '2026-03-02'),
    (9, '2026-03-09'),
    (10, '2026-03-16');

INSERT INTO Detalles_Ordenes_Compras (orden_compra_id, producto_id, cantidad_producto_recibido) VALUES
    (1, 1, 20),
    (2, 2, 15),
    (3, 6, 25),
    (4, 11, 10),
    (5, 16, 30),
    (6, 4, 18),
    (7, 9, 22),
    (8, 13, 12),
    (9, 18, 20),
    (10, 7, 28);

-- Empleados

INSERT INTO Areas (nombre_area) VALUES
    ('Administracion'),
    ('Ventas'),
    ('Bodega'),
    ('Compras'),
    ('Contabilidad'),
    ('Marketing'),
    ('Servicio al cliente'),
    ('Recursos humanos'),
    ('Logistica'),
    ('Gerencia');

INSERT INTO Empleados (nombre_compelto, fecha_contratacion, area_id) VALUES
    ('Ana Martinez', '2022-01-10', 1),
    ('Carlos Rodriguez', '2022-03-15', 2),
    ('Paula Sanchez', '2022-06-20', 3),
    ('Diego Hernandez', '2023-02-01', 4),
    ('Juliana Ramirez', '2023-04-18', 5),
    ('Sebastian Moreno', '2023-08-07', 6),
    ('Natalia Vargas', '2024-01-22', 7),
    ('Felipe Castillo', '2024-05-13', 8),
    ('Laura Ortiz', '2024-09-30', 9),
    ('Andres Mendoza', '2025-02-17', 10),
    ('Gabriela Fuentes', '2022-05-11', 2),
    ('Roberto Estrada', '2022-09-25', 3),
    ('Karla Morales', '2023-01-30', 7),
    ('Luis Alvarado', '2023-06-14', 2),
    ('Fernanda Barrios', '2024-03-08', 7);

-- Clientes

INSERT INTO Clientes (nombre_completo, correo_electronico, direccion, numero_telefono) VALUES
    ('Isabella Rojas', 'isabella.rojas@email.com', '3a Avenida 11-21 Zona 1, Guatemala', '5512-3401'),
    ('Maria Fernanda Lopez', 'maria.lopez@email.com', '8a Calle 16-32 Zona 10, Guatemala', '5512-3402'),
    ('Valeria Gomez', 'valeria.gomez@email.com', '6a Avenida 30-05 Zona 4, Guatemala', '5512-3403'),
    ('Santiago Perez', 'santiago.perez@email.com', '19 Avenida 22-14 Zona 7, Guatemala', '5512-3404'),
    ('Lucia Torres', 'lucia.torres@email.com', 'Calzada San Juan 13-09 Zona 7, Guatemala', '5512-3405'),
    ('Daniela Castro', 'daniela.castro@email.com', '2a Avenida 40-18 Zona 11, Guatemala', '5512-3406'),
    ('Camilo Ruiz', 'camilo.ruiz@email.com', 'Diagonal 6 6-27 Zona 10, Guatemala', '5512-3407'),
    ('Gabriela Silva', 'gabriela.silva@email.com', '11 Avenida 35-44 Zona 12, Guatemala', '5512-3408'),
    ('Martin Leon', 'martin.leon@email.com', '18 Calle 25-30 Zona 5, Guatemala', '5512-3409'),
    ('Sara Molina', 'sara.molina@email.com', '28 Avenida 12-08 Zona 9, Guatemala', '5512-3410');

-- Ventas

INSERT INTO Ventas (fecha_venta, cliente_id, empleado_id) VALUES
    ('2026-03-20 09:15:00', 1, 2),
    ('2026-03-20 10:30:00', 2, 11),
    ('2026-03-21 11:00:00', 3, 7),
    ('2026-03-21 14:20:00', 4, 14),
    ('2026-03-22 09:45:00', 5, 13),
    ('2026-03-22 16:10:00', 6, 2),
    ('2026-03-23 12:35:00', 7, 15),
    ('2026-03-23 15:50:00', 8, 12),
    ('2026-03-24 10:05:00', 9, 7),
    ('2026-03-24 17:25:00', 10, 11),
    ('2026-03-25 08:50:00', 1, 12),
    ('2026-03-25 13:10:00', 3, 13),
    ('2026-03-26 10:40:00', 5, 14),
    ('2026-03-26 15:30:00', 7, 15),
    ('2026-03-27 09:20:00', 9, 2);

INSERT INTO Detalle_Venta_Productos (ventas_id, producto_id, cantidad_producto, precio_unitario, subtotal) VALUES
    (1, 1, 1, 145.00, 145.00),
    (2, 2, 2, 285.00, 570.00),
    (3, 6, 1, 65.00, 65.00),
    (4, 11, 1, 1850.00, 1850.00),
    (5, 16, 1, 165.00, 165.00),
    (6, 4, 1, 195.00, 195.00),
    (7, 9, 2, 135.00, 270.00),
    (8, 13, 1, 890.00, 890.00),
    (9, 18, 1, 195.00, 195.00),
    (10, 7, 3, 75.00, 225.00);