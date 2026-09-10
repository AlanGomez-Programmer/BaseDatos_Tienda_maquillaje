# 💄 Base de Datos - Tienda de Maquillaje

## Descripción del proyecto

Esta base de datos fue diseñada para gestionar la operación completa de una tienda de maquillaje: 
- Catálogo de productos (cosméticos, cuidado de la piel, perfumes y accesorios)
- Proveedores y órdenes de compra
- Empleados y sus áreas
- Clientes y el registro de ventas. 

El objetivo es centralizar toda la información del negocio en un solo modelo relacional, que permita generar consultas útiles para la toma de decisiones (control de stock, productos más vendidos, desempeño de empleados, historial de compras de clientes, entre otras).

---

## Diagrama de la base de datos

![Diagrama UML ER](assets/imgs/Diagrama%20UML%20ER.png)

> 📄 La explicación completa del diagrama (distribuciones por color, tablas y atributos, y estándares de tipos de dato utilizados) se encuentra en:
> **[`assets/docs/explicacion-diagrama.md`](assets/docs/explicacion-diagrama.md)**

> 🛠️ Si deseas ver o editar el diagrama de forma interactiva, el archivo fuente de **MySQL Workbench** se encuentra en:
> **[`database/diagrama.mwb`](database/diagrama.mwb)**

---

## Estructura del proyecto

```
BaseDatos_Tienda_maquillaje/
│
├── assets/
│   ├── docs/
│   │   └── explicacion-diagrama.md      # Explicación detallada del diagrama UML ER
│   └── imgs/
│       ├── Diagrama UML ER.png          # Diagrama entidad-relación completo
│       ├── Proveedores_distribucion.png # Distribución del módulo de Proveedores
│       ├── Productos_distribucion.png   # Distribución del módulo de Productos
│       ├── Ventas_distribucion.png      # Distribución del módulo de Ventas
│       ├── Clientes_distribucion.png    # Distribución del módulo de Clientes
│       └── Empleados_distribucion.png   # Distribución del módulo de Empleados
│
├── database/
│   ├── DDL.sql                          # Creación de la base de datos y tablas
│   ├── DML.sql                          # Inserción de datos de prueba
│   ├── FUNCTIONS.sql                    # Funciones auxiliares (validaciones y cálculos)
│   ├── Stored_Procedures.sql            # Procedimientos almacenados (consultas del negocio)
│   ├── DQL.sql                          # Consultas de ejemplo para probar los SP
│   └── diagrama.mwb                     # Archivo fuente de MySQL Workbench
│
├── .gitignore
└── README.md
```

---

## Cómo usar este proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/AlanGomez-Programmer/BaseDatos_Tienda_maquillaje
cd BaseDatos_Tienda_maquillaje
```

### 2. Ejecutar los scripts con MySQL Workbench

1. Abre MySQL Workbench y conéctate a tu servidor local.
2. Ve a **File > Open SQL Script** y abre cada archivo de la carpeta `database/` en el siguiente orden:
   - `DDL.sql`
   - `DML.sql`
   - `FUNCTIONS.sql`
   - `Stored_Procedures.sql`
   - `DQL.sql`
3. Ejecuta cada script con el ícono de rayo (⚡) o presionando `Ctrl + Shift + Enter` para ejecutar todo el archivo.

> ⚠️ Deben ejecutarse en este orden (ver sección [Orden de ejecución](#orden-de-ejecución)), ya que cada script depende de que el anterior se haya ejecutado correctamente.

### 3. Verificar que todo funcionó

Una vez ejecutados todos los scripts, puedes probar cualquiera de los procedimientos almacenados directamente, por ejemplo:

```sql
USE Tienda_maquillaje;
CALL sp_empleados_mas_un_anio();
```

---

## 1. DDL (Data Definition Language)

Archivo: [`database/DDL.sql`](database/DDL.sql)

Aquí se define la estructura completa de la base de datos `Tienda_maquillaje`, organizada en 4 secciones lógicas mediante comentarios dentro del propio script:

- **Sección Productos**: `Categorias`, `Productos`, `Tipos_cosmeticos`, `Colores`, `Tonos`, `Cosmeticos`, `Tipos_pieles`, `Componentes`, `Cuidados_piel`, `Detalles_Componentes`, `Materiales`, `Tipos_accesorios`, `Unidades_medidas`, `Tamanios`, `Accesorios`, `Tipos_Aromas`, `Perfumes`.
- **Sección Proveedores**: `Proveedores`, `Ordenes_Compras`, `Detalles_Ordenes_Compras`.
- **Sección Empleados**: `Areas`, `Empleados`.
- **Sección Clientes**: `Clientes`.
- **Sección Ventas**: `Ventas`, `Detalle_Venta_Productos`.

Cada tabla cuenta con su respectiva `PRIMARY KEY` y las `FOREIGN KEY` necesarias para mantener la integridad referencial entre módulos (por ejemplo, un producto no puede pertenecer a una categoría inexistente, ni una venta a un cliente inexistente). Los tipos de dato se definieron siguiendo un estándar consistente (ver la tabla de estándares en `explicacion-diagrama.md`), por ejemplo `VARCHAR(15)` para teléfonos según la norma E.164, `DECIMAL(10,2)` para valores monetarios, y `DATE`/`DATETIME` según si el dato requiere hora exacta o no.

---

## 2. DML (Data Manipulation Language)

Archivo: [`database/DML.sql`](database/DML.sql)

Este archivo contiene los datos necesarios para poblar todas las tablas de la base de datos y así poder probar los procedimientos almacenados con información real. Incluye:

- Catálogos base (categorías, tipos de cosmético, colores, tonos, tipos de piel, componentes, materiales, tipos de accesorio, unidades de medida, tamaños, tipos de aroma).
- Productos organizados por categoría, usando marcas reconocidas para que los datos sean más fáciles de identificar y entender.
- Registros de proveedores, órdenes de compra y sus detalles.
- Empleados distribuidos en distintas áreas.
- Clientes.
- Ventas y el detalle de productos vendidos en cada una.

Los datos fueron adaptados al contexto de Guatemala (números telefónicos de 8 dígitos, direcciones con nomenclatura de zonas, y precios en Quetzales), para que la información tenga coherencia con el mercado objetivo de la tienda.

---

## 3. Functions (Funciones)

Archivo: [`database/FUNCTIONS.sql`](database/FUNCTIONS.sql)

Antes de construir los procedimientos almacenados, se decidió crear primero las funciones. Esto se hizo para lograr una mejor respuesta ante los datos ingresados y, sobre todo, para tener **modularidad**: en lugar de repetir la misma lógica de validación (por ejemplo, comprobar si un cliente existe) dentro de cada procedimiento, esa lógica se escribe una sola vez en una función y luego se reutiliza en todos los SP que la necesiten.

Funciones existentes:

| Función | Propósito |
|---|---|
| `fn_existencia_tipo_cosmetico` | Verifica si el tipo de cosmético ingresado existe. |
| `fn_existencia_categoria` | Verifica si el ID de categoría ingresado existe. |
| `fn_existencia_cliente` | Verifica si el ID de cliente ingresado existe. |
| `fn_cantidad_compras_cliente` | Calcula la cantidad total de compras realizadas por un cliente. |
| `fn_cantidad_ventas_cliente` | Calcula la cantidad de ventas de un cliente dentro de un rango de fechas. |
| `fn_existencia_empleado` | Verifica si el ID de empleado ingresado existe. |
| `fn_calculo_venta_empleado_mes` | Calcula la cantidad de ventas realizadas por un empleado en un mes y año específicos. |
| `fn_existencia_producto_id` | Verifica si el ID de producto ingresado existe. |
| `fn_existencia_producto_nombre` | Cuenta cuántos productos coinciden con un nombre (búsqueda parcial). |
| `fn_existencia_proveedor` | Verifica si el ID de proveedor ingresado existe. |

---

## 4. Stored Procedures (Procedimientos Almacenados)

Archivo: [`database/Stored_Procedures.sql`](database/Stored_Procedures.sql)

Aquí se encuentran todas las consultas de negocio de la tienda, resueltas mediante procedimientos almacenados. Cada uno utiliza las funciones descritas anteriormente para validar los datos de entrada antes de ejecutar la consulta principal.

| Procedimiento | Propósito |
|---|---|
| `sp_consulta_cosmetico_tipo_especifico` | Lista todos los productos de cosméticos de un tipo específico. |
| `sp_productos_categoria_stockInferior` | Obtiene los productos de una categoría cuyo stock es inferior a un valor dado. |
| `sp_ventas_clientes_rango_fechas` | Muestra las ventas realizadas por un cliente específico dentro de un rango de fechas. |
| `sp_calcular_total_ventas_mes_empleado` | Calcula el total de ventas realizadas por un empleado en un mes y año dados. |
| `sp_productos_mas_vendidos_periodo` | Lista los productos más vendidos dentro de un período determinado. |
| `sp_consultar_stock_producto` | Consulta el stock disponible de un producto, ya sea por su ID o por su nombre. |
| `sp_ordenes_compra_proveedor_ultimo_anio` | Muestra las órdenes de compra realizadas a un proveedor durante el último año. |
| `sp_empleados_mas_un_anio` | Lista los empleados que han trabajado más de un año en la tienda. |
| `sp_cantidad_productos_vendidos_dia` | Obtiene la cantidad total de productos vendidos en un día específico. |
| `sp_ventas_producto_por_id` | Consulta las ventas de un producto específico por su ID y cuántas unidades se vendieron. |

### Manejo de excepciones

Todos los procedimientos almacenados incluyen un `DECLARE EXIT HANDLER FOR SQLSTATE '42S02'`. Esto se agregó para que, si en algún momento se elimina o no existe alguna de las tablas que el procedimiento necesita consultar, en lugar de mostrar un error críptico de MySQL, se le muestre al usuario un mensaje claro indicando que revise si la tabla existe. Esto hace que los procedimientos sean más robustos ante cambios accidentales en la estructura de la base de datos.

---

## 5. DQL (Data Query Language)

Archivo: [`database/DQL.sql`](database/DQL.sql)

Este archivo contiene las consultas de ejemplo para poner a prueba cada uno de los procedimientos almacenados. Cada consulta sigue la misma estructura:

1. Un comentario indicando el número y el propósito de la consulta.
2. Un `SELECT` de apoyo (a modo de consejo) que muestra los datos disponibles antes de ejecutar la consulta principal — por ejemplo, ver los tipos de cosmético existentes antes de buscar por uno específico, o ver los IDs de categorías antes de filtrar por una de ellas. Esto evita tener que adivinar qué valores ingresar como parámetro.
3. La declaración de variables `@` con un comentario explicando qué representa cada una.
4. El `CALL` de ejemplo al procedimiento almacenado, usando esas variables.

**Ejemplo (Consulta 1):**
```sql
-- CONSULTA 1: Listar todos los productos de cosméticos de un tipo especifico
-- Antes de hacer la pregunta en especifico se recomienda ver que tipo de cosmetico se tiene
SELECT tipo_cosmetico FROM Tipos_cosmeticos;
-- Ejemplo consulta:
SET @Tipo_cosmetico = 'Base liquida'; -- Variable de tipo de cosmetico
CALL sp_consulta_cosmetico_tipo_especifico(@Tipo_cosmetico);
```

### ¿Por qué se usan variables `@`?

En lugar de escribir los valores directamente dentro del `CALL` (por ejemplo `CALL sp_consulta_cosmetico_tipo_especifico('Base liquida');`), se optó por declarar primero una variable de usuario con `SET @variable = valor;` y luego pasarla al procedimiento. Esto tiene varias ventajas:

- El script queda **mejor estructurado y más legible**, ya que cada parámetro tiene un nombre descriptivo y un comentario explicando qué representa.
- Es más fácil **modificar los valores de prueba** sin tener que buscar dentro de la llamada al procedimiento.
- Permite **reutilizar la misma variable** en varias consultas sin tener que repetir el valor literal cada vez.

---

## Orden de ejecución

Para que la base de datos funcione correctamente, los scripts deben ejecutarse en el siguiente orden:

1. **`DDL.sql`** → Crea la base de datos y todas las tablas.
2. **`DML.sql`** → Inserta los datos de prueba en las tablas ya creadas.
3. **`FUNCTIONS.sql`** → Crea las funciones auxiliares (deben existir antes que los procedimientos, ya que estos las utilizan).
4. **`Stored_Procedures.sql`** → Crea los procedimientos almacenados que dependen de las funciones anteriores.
5. **`DQL.sql`** → Ejecuta las consultas de ejemplo para probar que todo funcione correctamente.

> ⚠️ Respetar este orden es importante: si se intenta crear los `Stored_Procedures.sql` antes que `FUNCTIONS.sql`, MySQL arrojará un error porque las funciones que utilizan aún no existirían.

---

## 👨 AUTOR
Programador Full-Stack Jr. Alan Gomez

GitHub: [AlanGomez-Programmer](https://github.com/AlanGomez-Programmer)

LinkedIn: alan-gomez-763163320