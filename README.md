# coderhouse_sql
Portafolio de ejercicios

# Proyecto Retail — Base de datos SQL con PostgreSQL

## Descripción

Proyecto de modelado y gestión de una base de datos relacional para un negocio minorista (*retail*), desarrollado como parte del curso de SQL de Coderhouse.

El proyecto permite gestionar información de clientes, empleados, categorías, productos y ventas mediante consultas SQL en PostgreSQL.

## Tecnologías

- **Motor de base de datos:** PostgreSQL
- **Lenguaje:** SQL
- **Operaciones:** DDL y DML

## Modelo de datos

La base de datos está organizada en seis tablas relacionadas:

- `clientes`: información de los clientes.
- `empleados`: datos del personal.
- `categorias`: clasificación de los productos.
- `productos`: catálogo de productos, precios y stock.
- `ventas`: registro de las operaciones de venta.
- `detalle`: productos, cantidades y precios unitarios asociados a cada venta.

## Implementación

El script SQL incluye:

- Creación de la base de datos `coderhouse`.
- Creación del esquema `retail_project`.
- Creación de tablas con claves primarias (PK) y claves foráneas (FK).
- Definición de restricciones de integridad mediante `NOT NULL`, `UNIQUE` y `CHECK`.
- Configuración de relaciones entre tablas.
- Inserción de datos de ejemplo mediante `INSERT INTO`.
- Prevención de registros duplicados mediante `ON CONFLICT`.
- Actualización masiva de precios mediante `UPDATE`.
- Eliminación de registros mediante `DELETE`.
- Gestión de transacciones mediante `BEGIN` y `COMMIT`.

## Ejecución

1. Abrir PostgreSQL mediante una herramienta compatible, como pgAdmin o DBeaver.
2. Ejecutar el script SQL desde postgres (localhost:5432)
3. Verificar la creación del esquema, las tablas y la carga de los registros.

## Contexto

Proyecto académico desarrollado como parte del entregable 2 del curso de SQL de Coderhouse para aplicar conceptos de bases de datos relacionales y SQL para estructurar información.
