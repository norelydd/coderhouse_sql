/* CONSULTAS MULTICAPA PARA ANÁLISIS DE NEGOCIO
 * ===============================================
 * Coderhouse
 * Curso: SQL Comisión #93635
 * Estudiante: Norely Diaz
 * Entregable 4
 */


/*1. CREACION DE BASE DE DATOS*/
--nota: Conectado a postgres (Auto-commit)

CREATE DATABASE retail_project
    WITH OWNER = postgres
    ENCODING = 'UTF8'
    TEMPLATE = template0
    CONNECTION LIMIT = -1;


/*2. CREACION DE TABLAS: Clientes, Categorias, Productos, Ventas*/
-- nota:se crean en public.

CREATE TABLE clientes (
    id       INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    nombre   VARCHAR(30)  NOT NULL,
    apellido VARCHAR(30)  NOT NULL,
    email    VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20)  NOT NULL,
    edad     INTEGER      CHECK (edad >= 18)
);

CREATE TABLE categorias (
    id          INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    categoria   VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(200) NOT NULL
);

CREATE TABLE productos (
    id           INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1) PRIMARY KEY,
    sku          VARCHAR(50)   NOT NULL,
    producto     VARCHAR(100)  NOT NULL,
    precio       NUMERIC(10,2) NOT NULL,
    costo        NUMERIC(10,2) NOT NULL,
    marca        VARCHAR(100)  NOT NULL,
    stock        INTEGER       NOT NULL,
    id_categoria INTEGER       NOT NULL,

    CONSTRAINT uq_productos_sku       UNIQUE (sku),
    CONSTRAINT ck_productos_precio    CHECK (precio > 0),
    CONSTRAINT ck_productos_costo     CHECK (costo > 0),
    CONSTRAINT ck_productos_stock     CHECK (stock >= 0),
    CONSTRAINT fk_productos_categoria FOREIGN KEY (id_categoria)
        REFERENCES categorias (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE ventas (
    id_venta              INTEGER       NOT NULL,
    fecha                 DATE          NOT NULL,
    id_cliente            INTEGER       NOT NULL,
    id_producto           INTEGER       NOT NULL,
    cantidad              INTEGER       NOT NULL,
    precio_unitario       NUMERIC(10,2) NOT NULL,
    descuento_promocional NUMERIC(10,2) NOT NULL DEFAULT 0,  -- monto en pesos por unidad
    importe               NUMERIC(12,2) GENERATED ALWAYS AS
                              (cantidad * (precio_unitario - descuento_promocional)) STORED,

    CONSTRAINT pk_ventas           PRIMARY KEY (id_venta, id_producto),
    CONSTRAINT ck_ventas_cantidad  CHECK (cantidad > 0),
    CONSTRAINT ck_ventas_precio    CHECK (precio_unitario > 0),
    CONSTRAINT ck_ventas_descuento CHECK (descuento_promocional >= 0
                                          AND descuento_promocional < precio_unitario),
    CONSTRAINT fk_ventas_cliente   FOREIGN KEY (id_cliente)
        REFERENCES clientes (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_producto  FOREIGN KEY (id_producto)
        REFERENCES productos (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


/* 3. CARGA DE DATOS*/

BEGIN;

/* Datos de clientes */
INSERT INTO clientes (nombre, apellido, email, telefono, edad)
VALUES
    ('Juana',     'Gonzalez',  'juana.gonzalez@gmail.com',     '+5491156895689', 31),
    ('Martín',    'Rodríguez', 'martin.rodriguez@gmail.com',   '+5491145782301', 42),
    ('Lucía',     'Fernández', 'lucia.fernandez@outlook.com',  '+5491162340987', 27),
    ('Santiago',  'López',     'santiago.lopez@yahoo.com',     '+5491133458812', 35),
    ('Valentina', 'Martínez',  'valentina.martinez@gmail.com', '+5491178923456', 23),
    ('Mateo',     'Sánchez',   'mateo.sanchez@hotmail.com',    '+5491154127730', 51),
    ('Camila',    'Romero',    'camila.romero@gmail.com',      '+5491167781209', 29),
    ('Nicolás',   'Díaz',      'nicolas.diaz@outlook.com',     '+5491141996985', 38),
    ('Sofía',     'Torres',    'sofia.torres@gmail.com',       '+5491189034475', 19),
    ('Facundo',   'Álvarez',   'facundo.alvarez@yahoo.com',    '+5491152268843', 46);

/* Datos de categorías de productos */
INSERT INTO categorias (categoria, descripcion)
VALUES
    ('Vasos y Copas',              'Vasos, copas y jarras de vidrio y cristal'),
    ('Accesorios de Cocina',       'Complementos y organizadores para la cocina'),
    ('Primera Infancia',           'Artículos para bebés y niños pequeños'),
    ('Bolsas y Papeles de Regalo', 'Packaging, bolsas y papeles para obsequios'),
    ('Utencilios de Cocina',       'Utensilios para cocinar y servir'),
    ('Ferretería y Herramientas',  'Herramientas manuales y artículos de ferretería'),
    ('Textiles',                   'Mantelería, repasadores y ropa de cama');

/* Datos de productos*/
INSERT INTO productos (sku, producto, precio, costo, marca, stock, id_categoria)
VALUES
    ('VAS-001', 'Vaso de vidrio 350 ml',          1850.00, 1000.00, 'Rigolleau',      120, 1),
    ('VAS-002', 'Copa de vino tinto 450 ml',      2900.00, 1600.00, 'Nadir',           80, 1),
    ('VAS-003', 'Jarra de vidrio 1,5 L',          6400.00, 3500.00, 'Luminarc',        45, 1),
    ('ACC-001', 'Organizador de cubiertos',       4200.00, 2300.00, 'Tramontina',      60, 2),
    ('ACC-002', 'Escurridor de platos',           9800.00, 5400.00, 'Plasutil',        35, 2),
    ('ACC-003', 'Set de frascos herméticos x3',   7600.00, 4200.00, 'Rigolleau',       50, 2),
    ('INF-001', 'Mamadera 240 ml',                5300.00,  950.00, 'Mundo Bebé',      70, 3),
    ('INF-002', 'Set de platos infantiles x4',    6900.00,  700.00, 'Baby Innovation', 40, 3),
    ('INF-003', 'Babero impermeable',             2100.00, 1000.00, 'Mundo Bebé',     100, 3),
    ('BOL-001', 'Bolsa de regalo mediana',         950.00,  500.00, 'Cotillón Sur',   200, 4),
    ('BOL-002', 'Rollo de papel de regalo 10 m',  1400.00,  950.00, 'Cotillón Sur',   150, 4),
    ('BOL-003', 'Caja de regalo con tapa',        2300.00,  500.00, 'Pack Total',      90, 4),
    ('UTE-001', 'Cuchillo de chef 20 cm',         8700.00, 3750.00, 'Tramontina',      55, 5),
    ('UTE-002', 'Espátula de silicona',           3100.00, 1250.00, 'Tramontina',      85, 5),
    ('UTE-003', 'Tabla de cortar de bambú',       5600.00, 2480.00, 'Bambú Home',      65, 5),
    ('FER-001', 'Destornillador Phillips Nº2',    2600.00, 1100.00, 'Stanley',         75, 6),
    ('FER-002', 'Martillo de carpintero 500 g',   7900.00, 4800.00, 'Stanley',         30, 6),
    ('FER-003', 'Cinta métrica 5 m',              3400.00, 1700.00, 'Truper',          95, 6),
    ('TEX-001', 'Repasador de algodón x2',        2800.00, 1500.00, 'Arredo',         110, 7),
    ('TEX-002', 'Mantel rectangular 150x220 cm',  8900.00, 4400.00, 'Arredo',          40, 7),
    ('FER-004', 'Pilas AA x4',                    2400.00, 1400.00, 'Duracell',       150, 6),
    ('BOL-004', 'Cinta adhesiva transparente',     900.00,  500.00, 'Scotch',         200, 4),
    ('ACC-004', 'Bolsas de residuos x30',         1750.00,  950.00, 'Consorcio',      120, 2),
    ('ACC-005', 'Esponja multiuso x3',            1300.00,  700.00, 'Scotch-Brite',   180, 2),
    ('BOL-005', 'Velas aromáticas x2',            3800.00, 2100.00, 'Aromanza',        60, 4),
    ('FER-005', 'Linterna LED',                   6200.00, 3400.00, 'Energizer',       40, 6),
    ('FER-006', 'Alargue eléctrico 3 m',          5100.00, 2800.00, 'Philips',         55, 6),
    ('FER-007', 'Pegamento universal 50 g',       1100.00,  600.00, 'La Gotita',      130, 6);

/* Datos de ventas */
INSERT INTO ventas (id_venta, fecha, id_cliente, id_producto, cantidad, precio_unitario, descuento_promocional)
VALUES
    (10, '2026-09-02', 9, 1,  8,  1850.00,  278.00),
    (1,  '2026-08-03', 1, 1,  6,  1850.00,  278.00),
    (18, '2026-10-02', 1, 2,  6,  2900.00,  435.00),
    (1,  '2026-08-03', 1, 2,  4,  2900.00,  435.00),
    (14, '2026-09-17', 1, 2,  2,  2900.00,  435.00),
    (10, '2026-09-02', 9, 3,  2,  6400.00,  960.00),
    (18, '2026-10-02', 1, 3,  1,  6400.00,  960.00),
    (12, '2026-09-10', 2, 4,  2,  4200.00,  630.00),
    (2,  '2026-08-05', 5, 4,  1,  4200.00,  630.00),
    (20, '2026-10-12', 1, 4,  1,  4200.00,  630.00),
    (18, '2026-10-02', 1, 5,  1,  9800.00, 1470.00),
    (7,  '2026-08-21', 9, 5,  1,  9800.00, 1470.00),
    (12, '2026-09-10', 2, 6,  3,  7600.00, 1140.00),
    (7,  '2026-08-21', 9, 6,  2,  7600.00, 1140.00),
    (9,  '2026-08-29', 7, 7,  1,  5300.00,  795.00),
    (3,  '2026-08-08', 2, 7,  2,  5300.00,  795.00),
    (9,  '2026-08-29', 7, 8,  1,  6900.00, 1035.00),
    (16, '2026-09-24', 9, 8,  2,  6900.00, 1035.00),
    (16, '2026-09-24', 9, 9,  4,  2100.00,  315.00),
    (3,  '2026-08-08', 2, 9,  3,  2100.00,  315.00),
    (6,  '2026-08-18', 3, 10, 10,  950.00,  143.00),
    (15, '2026-09-21', 8, 10, 12,  950.00,  143.00),
    (15, '2026-09-21', 8, 11, 6,  1400.00,  210.00),
    (6,  '2026-08-18', 3, 11, 4,  1400.00,  210.00),
    (19, '2026-10-07', 3, 12, 5,  2300.00,  345.00),
    (9,  '2026-08-29', 7, 12, 2,  2300.00,  345.00),
    (14, '2026-09-17', 1, 13, 1,  8700.00, 1305.00),
    (8,  '2026-08-25', 8, 13, 1,  8700.00, 1305.00),
    (14, '2026-09-17', 1, 14, 3,  3100.00,  465.00),
    (2,  '2026-08-05', 5, 14, 2,  3100.00,  465.00),
    (20, '2026-10-12', 1, 15, 2,  5600.00,  840.00),
    (2,  '2026-08-05', 5, 15, 1,  5600.00,  840.00),
    (8,  '2026-08-25', 8, 15, 1,  5600.00,  840.00),
    (13, '2026-09-13', 5, 16, 3,  2600.00,  390.00),
    (17, '2026-09-28', 2, 16, 2,  2600.00,  390.00),
    (4,  '2026-08-11', 2, 16, 1,  2600.00,  390.00),
    (4,  '2026-08-11', 2, 17, 1,  7900.00, 1185.00),
    (17, '2026-09-28', 2, 17, 2,  7900.00, 1185.00),
    (13, '2026-09-13', 5, 18, 1,  3400.00,  510.00),
    (4,  '2026-08-11', 2, 18, 2,  3400.00,  510.00),
    (5,  '2026-08-14', 4, 19, 2,  2800.00,  420.00),
    (11, '2026-09-06', 8, 19, 4,  2800.00,  420.00),
    (19, '2026-10-07', 3, 19, 3,  2800.00,  420.00),
    (5,  '2026-08-14', 4, 20, 1,  8900.00, 1335.00),
    (11, '2026-09-06', 8, 20, 2,  8900.00, 1335.00);

COMMIT;


/*4. CONSULTA 1: Rentabilidad por Categoría*/
--Problema de Negocio: Se necesita optimizar el mix de productos y la asignación del presupuesto.

SELECT
    COALESCE(NULLIF(TRIM(c.categoria), ''), 'Sin Categorizar') AS categoria,
    SUM(v.cantidad)  AS unidades_vendidas,
    SUM(v.importe) AS ingreso_total,
    SUM(v.importe) - SUM(v.cantidad * COALESCE(p.costo, 0)) AS rentabilidad
FROM ventas v
LEFT JOIN productos  p ON p.id = v.id_producto
LEFT JOIN categorias c ON c.id = p.id_categoria
GROUP BY COALESCE(NULLIF(TRIM(c.categoria), ''), 'Sin Categorizar')
HAVING SUM(v.importe) > 45000 -- umbral definido en 45.000. Con los datos usados, deja afuera las categorías de menor venta y conserva las de mayor peso.
ORDER BY rentabilidad DESC;


/*5 CONSULTA 2. Clientes sin Compras*/
-- Problema de Negocio: Identificar hacia quien va dirigida una campaña de reactivación y proporcionar información para auditar efectividad de los canales de adquisición.

SELECT
    c.id AS codigo_cliente,
    CONCAT(c.nombre, ' ', c.apellido)  AS cliente,
    COALESCE(cp.compras::text, 'Sin Compras') AS estado
FROM clientes c
LEFT JOIN (
    SELECT v.id_cliente, COUNT(DISTINCT v.id_venta) AS compras
    FROM ventas v
    GROUP BY v.id_cliente
) cp ON cp.id_cliente = c.id
WHERE cp.compras IS NULL
ORDER BY c.id;


/*6 CONSULTA 3.Top de Compras por Cliente*/
--Problema de Negocio: Identificar los productos preferidos por los clientes para diseñar estrategias personalizadas de venta cruzada.

SELECT
    c.id AS codigo_cliente,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    (SELECT p.producto
     FROM ventas v
     INNER JOIN productos p ON p.id = v.id_producto
     WHERE v.id_cliente = c.id
     GROUP BY p.id, p.producto
     ORDER BY COUNT(*) DESC, SUM(v.cantidad) DESC, p.producto
     LIMIT 1) AS producto_mas_comprado,
    (SELECT MAX(v.fecha)
     FROM ventas v
     WHERE v.id_cliente = c.id
     GROUP BY v.id_cliente) AS ultima_compra
FROM clientes c
WHERE EXISTS (SELECT 1 FROM ventas v WHERE v.id_cliente = c.id)
ORDER BY c.id;
