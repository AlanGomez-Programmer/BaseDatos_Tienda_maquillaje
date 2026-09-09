-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS Tienda_maquillaje;
USE Tienda_maquillaje;

-- Creación de las tablas
/*
	Sección Productos
*/

CREATE TABLE Categorias(
	id_categoria INT AUTO_INCREMENT,
    categoria VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_categoria)
);

CREATE TABLE Productos(
	id_producto INT AUTO_INCREMENT,
    categoria_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_producto),
    FOREIGN KEY (categoria_id) REFERENCES Categorias(id_categoria)
);

CREATE TABLE Tipos_cosmeticos(
	id_tipo_cosmetico INT AUTO_INCREMENT,
    tipo_cosmetico VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_tipo_cosmetico)
);

CREATE TABLE Colores(
	id_color INT AUTO_INCREMENT, 
    color VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_color)
);

CREATE TABLE Tonos(
	id_tono INT AUTO_INCREMENT, 
    color_id INT NOT NULL,
    tono VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_tono),
    FOREIGN KEY (color_id) REFERENCES Colores(id_color)
);

CREATE TABLE Cosmeticos(
	id_cosmetico INT AUTO_INCREMENT,
    producto_id INT NOT NULL,
    tipo_cosmetico_id INT NOT NULL,
	tono_id INT NOT NULL,
    fecha_expiracion DATE NOT NULL,
    PRIMARY KEY (id_cosmetico),
    FOREIGN KEY (producto_id) REFERENCES Productos(id_producto),
    FOREIGN KEY (tipo_cosmetico_id) REFERENCES Tipos_cosmeticos(id_tipo_cosmetico),
	FOREIGN KEY (tono_id) REFERENCES Tonos(id_tono)
);

CREATE TABLE Tipos_pieles(
	id_tipo_piel INT AUTO_INCREMENT,
    tipo_piel VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_tipo_piel)
);

CREATE TABLE Componentes(
	id_componente INT AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_componente)
);

CREATE TABLE Cuidados_piel(
	id_cuidado_piel INT AUTO_INCREMENT,
    producto_id INT NOT NULL,
    tipo_piel_id INT NOT NULL,
	fecha_expiracion DATE NOT NULL,
    PRIMARY KEY (id_cuidado_piel),
    FOREIGN KEY (producto_id) REFERENCES Productos(id_producto),
    FOREIGN KEY (tipo_piel_id) REFERENCES Tipos_pieles(id_tipo_piel)
);

CREATE TABLE Detalles_Componentes(
	cuidado_piel_id INT NOT NULL,
    componente_id INT NOT NULL,
    PRIMARY KEY (cuidado_piel_id, componente_id),
    FOREIGN KEY (cuidado_piel_id) REFERENCES Cuidados_piel(id_cuidado_piel),
    FOREIGN KEY (componente_id) REFERENCES Componentes(id_componente)
);

CREATE TABLE Materiales(
	id_material INT AUTO_INCREMENT,
    material VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_material)
);

 CREATE TABLE Tipos_accesorios(
	id_tipo_accesorio INT AUTO_INCREMENT,
    tipo_accesorio VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_tipo_accesorio)
 );
 
 CREATE TABLE Unidades_medidas(
	id_unidad_medida INT AUTO_INCREMENT,
    medida VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_unidad_medida)
 );
 
 CREATE TABLE Tamanios(
	id_tamanio INT AUTO_INCREMENT,
    tamanio DECIMAL(5, 2) NOT NULL,
    unidad_medida_id INT NOT NULL,
    PRIMARY KEY (id_tamanio),
    FOREIGN KEY (unidad_medida_id) REFERENCES Unidades_medidas(id_unidad_medida)
 );
 
 CREATE TABLE Accesorios(
	id_accesorio INT AUTO_INCREMENT,
    producto_id INT NOT NULL,
    tipo_accesorio INT NOT NULL,
    material_id INT NOT NULL,
    tamanio_id INT NOT NULL,
    PRIMARY KEY (id_accesorio),
    FOREIGN KEY (producto_id) REFERENCES Productos(id_producto),
    FOREIGN KEY (tipo_accesorio) REFERENCES Tipos_accesorios(id_tipo_accesorio),
    FOREIGN KEY (material_id) REFERENCES Materiales(id_material),
    FOREIGN KEY (tamanio_id) REFERENCES Tamanios(id_tamanio)
 );

CREATE TABLE Tipos_Aromas(
	id_tipo_aroma INT AUTO_INCREMENT,
    tipo_aroma VARCHAR(50) NOT NULL,
	PRIMARY KEY (id_tipo_aroma)
);

CREATE TABLE Perfumes(
	id_perfume INT AUTO_INCREMENT,
    producto_id INT NOT NULL,
    tipo_aroma_id INT NOT NULL,
    tamanio_id INT NOT NULL,
    PRIMARY KEY (id_perfume),
    FOREIGN KEY (producto_id) REFERENCES Productos(id_producto),
    FOREIGN KEY (tipo_aroma_id) REFERENCES Tipos_Aromas(id_tipo_aroma),
    FOREIGN KEY (tamanio_id) REFERENCES Tamanios(id_tamanio)
);

/*
	Sección Proveedores
*/

CREATE TABLE Proveedores(
	id_proveedor INT AUTO_INCREMENT,
    nombre_empresa VARCHAR(100) NOT NULL,
    nombre_contacto VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    direccion VARCHAR(60) NOT NULL,
    PRIMARY KEY (id_proveedor)
);

CREATE TABLE Ordenes_Compras(
	id_orden_compra INT AUTO_INCREMENT,
	proveedor_id INT NOT NULL,
    fecha_orden DATE NOT NULL,
    PRIMARY KEY (id_orden_compra),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id_proveedor)
);

CREATE TABLE Detalles_Ordenes_Compras(
	orden_compra_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad_producto_recibido INT NOT NULL,
    PRIMARY KEY (orden_compra_id, producto_id),
    FOREIGN KEY (orden_compra_id) REFERENCES Ordenes_Compras(id_orden_compra),
    FOREIGN KEY (producto_id) REFERENCES Productos(id_producto)
);

/*
	Sección Empleados
*/

CREATE TABLE Areas(
	id_area INT AUTO_INCREMENT,
    nombre_area VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_area)
);

CREATE TABLE Empleados(
	id_empleado INT AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    area_id INT NOT NULL,
    PRIMARY KEY (id_empleado),
    FOREIGN KEY (area_id) REFERENCES Areas(id_area)
);

/*
	Sección Clientes
*/

CREATE TABLE Clientes(
	id_cliente INT AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(50) NOT NULL,
    direccion VARCHAR(60) NOT NULL,
    numero_telefono VARCHAR(15) NOT NULL,
    PRIMARY KEY (id_cliente)
);


/*
	Sección Ventas
*/

CREATE TABLE Ventas(
	id_venta INT AUTO_INCREMENT,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    cliente_id INT NOT NULL,
    empleado_id INT NOT NULL,
    PRIMARY KEY (id_venta),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (empleado_id) REFERENCES Empleados(id_empleado)
);

CREATE TABLE Detalle_Venta_Productos(
	ventas_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad_producto INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (ventas_id, producto_id),
    FOREIGN KEY (ventas_id) REFERENCES Ventas(id_venta),
    FOREIGN KEY (producto_id) REFERENCES Productos(id_producto)
);
