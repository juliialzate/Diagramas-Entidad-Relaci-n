# Taller: Otras Operaciones del Álgebra Relacional con SQL

## 1. Intersección

### Álgebra Relacional

```text
πNombre(CLIENTES ▷◁ σIdProducto=101(VENTAS))
∩
πNombre(CLIENTES ▷◁ σIdProducto=102(VENTAS))
```

### Explicación del Álgebra Relacional

La intersección obtiene únicamente los clientes que aparecen en ambos conjuntos, es decir, quienes compraron el **Computador Portátil** y también el **Mouse Inalámbrico**.

### Código SQL

```sql
SELECT Nombre
FROM CLIENTES
WHERE IdCliente IN (
    SELECT IdCliente
    FROM VENTAS
    WHERE IdProducto = 101
)
AND IdCliente IN (
    SELECT IdCliente
    FROM VENTAS
    WHERE IdProducto = 102
);
```

### Explicación del SQL

La consulta busca los clientes que están en las dos listas de compras, una para el producto **101** y otra para el producto **102**.

---

# 2. Reunión Natural (INNER JOIN)

### Álgebra Relacional

```text
CLIENTES ▷◁ VENTAS ▷◁ PRODUCTOS ▷◁ SUCURSALES

πNombre, NombreProducto, NombreSucursal
```

### Explicación del Álgebra Relacional

La reunión natural une las tablas relacionadas para obtener información completa de cada venta.

### Código SQL

```sql
SELECT
    CLIENTES.Nombre,
    PRODUCTOS.NombreProducto,
    SUCURSALES.NombreSucursal
FROM VENTAS
INNER JOIN CLIENTES
    ON VENTAS.IdCliente = CLIENTES.IdCliente
INNER JOIN PRODUCTOS
    ON VENTAS.IdProducto = PRODUCTOS.IdProducto
INNER JOIN SUCURSALES
    ON VENTAS.IdSucursal = SUCURSALES.IdSucursal;
```

### Explicación del SQL

Se unen las tablas mediante **INNER JOIN** para mostrar el cliente, el producto comprado y la sucursal donde se realizó la compra.

---

# 3. División

### Álgebra Relacional

```text
VENTAS ÷ SUCURSALES
```

### Explicación del Álgebra Relacional

La división encuentra los clientes que tienen relación con todas las sucursales existentes.

### Código SQL

```sql
SELECT CLIENTES.Nombre
FROM CLIENTES
INNER JOIN VENTAS
    ON CLIENTES.IdCliente = VENTAS.IdCliente
GROUP BY CLIENTES.Nombre
HAVING COUNT(DISTINCT VENTAS.IdSucursal) =
(
    SELECT COUNT(*)
    FROM SUCURSALES
);
```

### Explicación del SQL

Se cuenta en cuántas sucursales compró cada cliente y se compara con el número total de sucursales para encontrar quienes compraron en todas.

---

# 4. Asignación (CTE)

### Álgebra Relacional

```text
ProductosCaros ← σPrecio>500000(PRODUCTOS)

πNombreProducto, Precio(ProductosCaros)
```

### Explicación del Álgebra Relacional

La asignación crea un resultado temporal con los productos de mayor precio y luego muestra únicamente la información necesaria.

### Código SQL

```sql
WITH ProductosCaros AS
(
    SELECT *
    FROM PRODUCTOS
    WHERE Precio > 500000
)

SELECT
    NombreProducto,
    Precio
FROM ProductosCaros;
```

### Explicación del SQL

La **CTE** guarda temporalmente los productos con precio superior a **$500.000** y luego muestra únicamente su nombre y precio.

---

# 5. Análisis

## a) ¿Cuál es la diferencia entre la Intersección y la Reunión Natural?

La **intersección** devuelve únicamente los registros que pertenecen a dos conjuntos al mismo tiempo.

En cambio, la **reunión natural** une tablas relacionadas para combinar su información en un solo resultado.

---

## b) ¿En qué situaciones resulta útil la operación División?

Es útil cuando se necesita encontrar elementos que cumplen una condición para **todos** los registros de otro conjunto.

Por ejemplo:

- Identificar clientes que compraron en todas las sucursales.
- Encontrar vendedores que realizaron ventas en todas las regiones.

---

## c) ¿Qué ventajas ofrece utilizar una CTE (`WITH`) en SQL?

Las CTE ofrecen varias ventajas:

- Hacen que las consultas sean más fáciles de leer.
- Permiten dividir problemas complejos en partes más simples.
- Facilitan el mantenimiento del código.
- Evitan repetir la misma consulta varias veces.

---

## d) ¿Cuál de las operaciones estudiadas considera más útil para administrar una base de datos de una tienda de tecnología? Justifique su respuesta.

Considero que la **Reunión Natural (`INNER JOIN`)** es la más útil, ya que la mayoría de las consultas en una tienda requieren combinar información de varias tablas, como **clientes**, **productos**, **ventas** y **sucursales**.

Esto permite generar reportes completos y obtener información útil para la toma de decisiones.
