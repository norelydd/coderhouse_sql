# Consultas multicapa para análisis de negocio (SQL)

Entregable 4 · Curso de SQL, Coderhouse · Comisión #93635
Estudiante: Norely Diaz

## Descripción

Script en PostgreSQL que crea un modelo de datos de retail, lo carga con datos de prueba y resuelve tres consultas de análisis de negocio: rentabilidad por categoría, clientes sin compras y top de compras por cliente.

## Tecnología

Motor de base de datos: PostgreSQL
Lenguaje: SQL

## Modelo de datos

```
categorias (1) ──< productos (1) ──< ventas >── (1) clientes
```

| Tabla | Descripción | Clave |
|---|---|---|
| `clientes` | Datos de contacto y edad (mayores de 18) | `id` |
| `categorias` | Categorías de productos | `id` |
| `productos` | Catálogo con precio, costo y stock | `id`, FK a `categorias` |
| `ventas` | Una fila por producto vendido en cada venta | PK `(id_venta, id_producto)`, FK a `clientes` y `productos` |

Detalles de `ventas`:

- `precio_unitario` guarda el precio cobrado en la venta, que puede diferir de `productos.precio`.
- `descuento_promocional` es un monto en pesos por unidad, no un porcentaje.
- `importe` es una columna generada: `cantidad * (precio_unitario - descuento_promocional)`.

## Ejecución

1. Conéctate a la base `postgres` en modo Auto-commit y ejecuta la sección **1** (`CREATE DATABASE retail_project`).
2. Crea una conexión a `retail_project`. El script no incluye `\c`, que no funciona en DBeaver.
3. Ejecuta el resto del script con **Alt + X**:
   - Sección 2: creación de tablas.
   - Sección 3: carga de datos, dentro de `BEGIN ... COMMIT`.
   - Secciones 4 a 6: consultas.

Las tablas se crean en el esquema `public`.

## Datos de prueba

- 10 clientes
- 7 categorías
- 28 productos
- 45 líneas de venta repartidas en 20 ventas

## Consultas

### 1. Rentabilidad por categoría

- **Problema de negocio:** optimizar el mix de productos y la asignación del presupuesto.
- **Resuelve con:** `JOIN` entre `ventas`, `productos` y `categorias`, y `HAVING` con un umbral de ingreso de 45.000.
- **Columnas:** categoría, unidades vendidas, ingreso total y rentabilidad (`ingreso - cantidad * costo`).
- **Nulos:** `COALESCE(NULLIF(TRIM(...), ''), 'Sin Categorizar')` cubre categorías nulas o vacías.

### 2. Clientes sin compras

- **Problema de negocio:** identificar a quién dirigir una campaña de reactivación.
- **Resuelve con:** subconsulta agregada + `LEFT JOIN` y filtro `IS NULL`.
- **Nulos:** `COALESCE` muestra "Sin Compras".

### 3. Top de compras por cliente

- **Problema de negocio:** conocer los productos preferidos para diseñar venta cruzada.
- **Resuelve con:** subconsulta correlacionada en el `SELECT`. Agrupa las ventas del cliente por producto, ordena por `COUNT(*)` descendente y usa `LIMIT 1`. La última compra sale con `MAX(fecha)`.
- **Desempate:** unidades vendidas (`SUM(cantidad)`).
- **Alcance:** solo incluye clientes con al menos una compra.

## Estructura del repositorio

```
.
├── README.md
└── script.sql
```
