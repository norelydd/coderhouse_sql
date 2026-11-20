# Análisis avanzado con Window Functions (SQL)

Entregable 5 · Curso de SQL, Coderhouse · Comisión #93635
Estudiante: Norely Diaz

## Descripción

Script en PostgreSQL que crea un modelo de datos de retail, lo carga con datos de prueba y analiza las ventas mensuales por categoría usando CTE y funciones de ventana.

## Modelo de datos

```
categorias ──< productos ──< ventas >── clientes
```

- `clientes`: datos de contacto y edad.
- `categorias`: categorías de productos.
- `productos`: catálogo con precio, costo y stock.
- `ventas`: una fila por producto vendido en cada venta. El campo `importe` se calcula como `cantidad * (precio_unitario - descuento_promocional)`.

## Cómo ejecutarlo

1. Ejecuta el script completo en `psql`.
2. En DBeaver, `\c` no funciona: crea la base `retail_project` desde `postgres`, conéctate a ella y ejecuta el resto del script con **Alt + X**.

## Análisis

La consulta final muestra, por mes y categoría:

- **Ranking mensual:** `DENSE_RANK()` de las categorías más vendidas de cada mes.
- **Total acumulado:** `SUM() OVER` con la venta acumulada de cada categoría a través del tiempo.
- **Promedio por categoría:** `AVG() OVER` de la venta mensual de cada categoría.
- **Desempeño:** `CASE WHEN` que clasifica cada mes como "Exitoso" (mayor o igual al promedio) o "Bajo el promedio".

## Estructura del repositorio

```
.
├── README.md
└── script.sql
```
