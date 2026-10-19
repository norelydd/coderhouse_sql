/*  PROYECTO RETAIL  
 * ====================================
 * Coderhouse
 * Curso: SQL
 * Estudiante: Norely Diaz
 * Entregable 2 
 */


/* 1. CREACION DE BASE DE DATOS*/

CREATE DATABASE IF NOT EXISTS coderhouse;


CREATE SCHEMA IF NOT EXISTS retail_project;


/* 2. DDL - CREACION DE TABLAS PRINCIPALES*/

CREATE TABLE IF NOT EXISTS retail_project.clientes(
	id       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nombre   VARCHAR(30)  NOT NULL,
	apellido VARCHAR(30)  NOT NULL,
	email    VARCHAR(150) UNIQUE NOT NULL, -- email único
	telefono VARCHAR(20)  NOT NULL,
	edad     INTEGER      CHECK(edad >=18)
);

CREATE TABLE IF NOT EXISTS retail_project.empleados(
	id       INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	dni      INTEGER     NOT NULL UNIQUE, -- dni único
	nombre   VARCHAR(30) NOT NULL,
	apellido VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS retail_project.categorias(
	id          INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	categoria   VARCHAR(100) NOT NULL UNIQUE, -- categoría única
	descripcion VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS retail_project.productos (
    id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku           VARCHAR(50)    NOT NULL,
    producto      VARCHAR(100)   NOT NULL,
    precio        NUMERIC(10,2)  NOT NULL,
    marca         VARCHAR(100)   NOT NULL,
    stock         INTEGER        NOT NULL,
    id_categoria  INTEGER        NOT NULL,

    CONSTRAINT uq_productos_sku        UNIQUE (sku),   -- evita sku repetidos
    CONSTRAINT ck_productos_precio     CHECK (precio > 0),    -- precio mayor a cero
    CONSTRAINT ck_productos_stock      CHECK (stock >= 0),     -- stock no negativo
    CONSTRAINT fk_productos_categoria  FOREIGN KEY (id_categoria)
        REFERENCES retail_project.categorias (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT    -- no permite borrar una categoría con productos
);

CREATE TABLE IF NOT EXISTS retail_project.ventas(
	id          INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	fecha       DATE     NOT NULL DEFAULT CURRENT_DATE, -- fecha actual por defecto
	id_cliente  INTEGER  NOT NULL,
	id_empleado INTEGER  NOT NULL,
	
	CONSTRAINT fk_ventas_cliente  FOREIGN KEY (id_cliente)
        REFERENCES retail_project.clientes (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_empleado FOREIGN KEY (id_empleado)
        REFERENCES retail_project.empleados (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS retail_project.detalle( 
	id_venta        INTEGER NOT NULL, 
	id_producto     INTEGER NOT NULL,
	cantidad        INTEGER NOT NULL,  
	precio_unitario NUMERIC(10,2) NOT NULL,
	PRIMARY KEY (id_venta, id_producto), 

  	CONSTRAINT ck_detalle_cantidad  CHECK (cantidad > 0),
    CONSTRAINT ck_detalle_precio    CHECK (precio_unitario > 0),
    CONSTRAINT fk_detalle_venta    FOREIGN KEY (id_venta)
        REFERENCES retail_project.ventas (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto)
        REFERENCES retail_project.productos (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

/* 3. DML - CARGA DE REGISTROS*/

BEGIN;

TRUNCATE retail_project.detalle,
         retail_project.ventas,
         retail_project.productos,
         retail_project.categorias,
         retail_project.empleados,
         retail_project.clientes
RESTART IDENTITY;

	/* registro de clientes*/
	INSERT INTO retail_project.clientes (nombre, apellido, email, telefono, edad)
	VALUES
	    ('Juana',     'Gonzalez',  'juana.gonzalez@gmail.com',    '+5491156895689', 31),
	    ('Martín',    'Rodríguez', 'martin.rodriguez@gmail.com',  '+5491145782301', 42),
	    ('Lucía',     'Fernández', 'lucia.fernandez@outlook.com', '+5491162340987', 27),
	    ('Santiago',  'López',     'santiago.lopez@yahoo.com',    '+5491133458812', 35),
	    ('Valentina', 'Martínez',  'valentina.martinez@gmail.com','+5491178923456', 23),
	    ('Mateo',     'Sánchez',   'mateo.sanchez@hotmail.com',   '+5491154127730', 51),
	    ('Camila',    'Romero',    'camila.romero@gmail.com',     '+5491167781209', 29),
	    ('Nicolás',   'Díaz',      'nicolas.diaz@outlook.com',    '+5491141996985', 38),
	    ('Sofía',     'Torres',    'sofia.torres@gmail.com',      '+5491189034475', 19),
	    ('Facundo',   'Álvarez',   'facundo.alvarez@yahoo.com',   '+5491152268843', 46);
	
	/* registro de empleados*/
	INSERT INTO retail_project.empleados (dni, nombre, apellido)
	VALUES
	    (25489125, 'Micaela',   'Parra'),
    	(30127845, 'Rodrigo',   'Benítez'),
    	(27956310, 'Carolina',  'Suárez'),
    	(33418276, 'Gabriel',   'Acosta'),
    	(29674302, 'Florencia', 'Medina')
	ON CONFLICT (dni) DO NOTHING;
	
	/* lista de categorías de productos*/
INSERT INTO retail_project.categorias (categoria, descripcion)
VALUES
    ('Vasos y Copas',              'Vasos, copas y jarras de vidrio y cristal'),
    ('Accesorios de Cocina',       'Complementos y organizadores para la cocina'),
    ('Primera Infancia',           'Artículos para bebés y niños pequeños'),
    ('Bolsas y Papeles de Regalo', 'Packaging, bolsas y papeles para obsequios'),
    ('Utencilios de Cocina',       'Utensilios para cocinar y servir'),
    ('Ferretería y Herramientas',  'Herramientas manuales y artículos de ferretería'),
    ('Textiles',                   'Mantelería, repasadores y ropa de cama');
	
	/* listado de productos*/
INSERT INTO retail_project.productos (sku, producto, precio, marca, stock, id_categoria)
VALUES
    -- Vasos y Copas
    ('VAS-001', 'Vaso de vidrio 350 ml',              1850.00, 'Rigolleau',   120, 1),
    ('VAS-002', 'Copa de vino tinto 450 ml',          2900.00, 'Nadir',        80, 1),
    ('VAS-003', 'Jarra de vidrio 1,5 L',              6400.00, 'Luminarc',     45, 1),

    -- Accesorios de Cocina
    ('ACC-001', 'Organizador de cubiertos',           4200.00, 'Tramontina',   60, 2),
    ('ACC-002', 'Escurridor de platos',               9800.00, 'Plasutil',     35, 2),
    ('ACC-003', 'Set de frascos herméticos x3',       7600.00, 'Rigolleau',    50, 2),

    -- Primera Infancia
    ('INF-001', 'Mamadera 240 ml',                    5300.00, 'Mundo Bebé',   70, 3),
    ('INF-002', 'Set de platos infantiles x4',        6900.00, 'Baby Innovation', 40, 3),
    ('INF-003', 'Babero impermeable',                 2100.00, 'Mundo Bebé',  100, 3),

    -- Bolsas y Papeles de Regalo
    ('BOL-001', 'Bolsa de regalo mediana',             950.00, 'Cotillón Sur', 200, 4),
    ('BOL-002', 'Rollo de papel de regalo 10 m',      1400.00, 'Cotillón Sur', 150, 4),
    ('BOL-003', 'Caja de regalo con tapa',            2300.00, 'Pack Total',    90, 4),

    -- Utensilios de Cocina (escrito como en tu INSERT de categorias)
    ('UTE-001', 'Cuchillo de chef 20 cm',             8700.00, 'Tramontina',   55, 5),
    ('UTE-002', 'Espátula de silicona',               3100.00, 'Tramontina',   85, 5),
    ('UTE-003', 'Tabla de cortar de bambú',           5600.00, 'Bambú Home',   65, 5),

    -- Ferretería y Herramientas
    ('FER-001', 'Destornillador Phillips Nº2',        2600.00, 'Stanley',      75, 6),
    ('FER-002', 'Martillo de carpintero 500 g',       7900.00, 'Stanley',      30, 6),
    ('FER-003', 'Cinta métrica 5 m',                  3400.00, 'Truper',       95, 6),

    -- Textiles
    ('TEX-001', 'Repasador de algodón x2',            2800.00, 'Arredo',      110, 7),
    ('TEX-002', 'Mantel rectangular 150x220 cm',      8900.00, 'Arredo',       40, 7)

ON CONFLICT (sku) DO NOTHING;

/* registro de ventas*/

INSERT INTO retail_project.ventas (fecha, id_cliente, id_empleado)
VALUES
    ('2026-08-03', 1 ,1),
    ('2026-08-05', 5, 2),
    ('2026-08-08', 6, 2),
    ('2026-08-11', 2, 1),
    ('2026-08-14', 4, 3),
    ('2026-08-18', 3, 3),
    ('2026-08-21', 9, 5),
    ('2026-08-25', 8, 4),
    ('2026-08-29', 7, 2),
    ('2026-09-02', 6, 3),
    ('2026-09-06', 10,4),
    ('2026-09-10', 10,1),
    ('2026-09-13', 10,4),
    ('2026-09-17', 6, 2),
    ('2026-09-21', 8, 2),
    ('2026-09-24', 9, 4),
    ('2026-09-28', 2, 5),
    ('2026-10-02', 6, 1),
    ('2026-10-07', 3, 3),
    ('2026-10-12', 1, 5);

/* registro de detalle*/
INSERT INTO retail_project.detalle (id_venta, id_producto, cantidad, precio_unitario)
VALUES
    (1,  1,  6, 1850.00), (1,  2,  4, 2900.00),
    (2,  4,  1, 4200.00), (2, 14,  2, 3100.00), (2, 15,  1, 5600.00),
    (3,  7,  2, 5300.00), (3,  9,  3, 2100.00),
    (4, 16,  1, 2600.00), (4, 17,  1, 7900.00), (4, 18,  2, 3400.00),
    (5, 19,  2, 2800.00), (5, 20,  1, 8900.00),
    (6, 10, 10,  950.00), (6, 11,  4, 1400.00),
    (7,  5,  1, 9800.00), (7,  6,  2, 7600.00),
    (8, 13,  1, 8700.00), (8, 15,  1, 5600.00),
    (9,  8,  1, 6900.00), (9,  7,  1, 5300.00), (9, 12,  2, 2300.00),
    (10, 3,  2, 6400.00), (10, 1,  8, 1850.00),
    (11, 20, 2, 8900.00), (11, 19, 4, 2800.00),
    (12, 6,  3, 7600.00), (12, 4,  2, 4200.00),
    (13, 18, 1, 3400.00), (13, 16, 3, 2600.00),
    (14, 14, 3, 3100.00), (14, 13, 1, 8700.00), (14, 2, 2, 2900.00),
    (15, 11, 6, 1400.00), (15, 10, 12, 950.00),
    (16, 9,  4, 2100.00), (16, 8,  2, 6900.00),
    (17, 17, 2, 7900.00), (17, 16, 2, 2600.00),
    (18, 2,  6, 2900.00), (18, 3,  1, 6400.00), (18, 5,  1, 9800.00),
    (19, 19, 3, 2800.00), (19, 12, 5, 2300.00),
    (20, 15, 2, 5600.00), (20, 4,  1, 4200.00)
    
ON CONFLICT (id_venta, id_producto) DO NOTHING;
   
	
COMMIT;

/*4. DML - UPDATE MASIVO DE PRECIOS DE LA CATEGORÍA "Ferretería y Herramientas*/

UPDATE retail_project.productos 
SET precio = precio * 1.20
WHERE id_categoria = 6;

/*5. DML - DELETE de un registro de empleado*/

BEGIN;

-- empleados nuevos
INSERT INTO retail_project.empleados (dni, nombre, apellido)
VALUES
    (31245678, 'Tomás',  'Herrera'),
    (28963451, 'Julieta', 'Ramírez');

-- ejercicio DELETE
DELETE FROM retail_project.empleados
WHERE dni = 28963451;

COMMIT;


