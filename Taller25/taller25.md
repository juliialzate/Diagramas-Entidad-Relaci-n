# Taller de Álgebra Relacional — Solución

**Contexto:** Tienda de útiles escolares con las tablas *Productos*, *Clientes*, *Compras* y *Devoluciones*.

---

## 1. Selección (σ)

**Enunciado:** Todos los productos cuya categoría sea 'Papelería'.

**Álgebra Relacional:**
```
σ Categoría='Papelería' (Productos)
```

**SQL:**
```sql
SELECT *
FROM Productos
WHERE Categoria = 'Papelería';
```

**Resultado esperado:**

| Código | Nombre   | Categoría | Precio |
|--------|----------|-----------|--------|
| P01    | Cuaderno | Papelería | 8000   |
| P02    | Lápiz    | Papelería | 2000   |
| P04    | Regla    | Papelería | 3500   |

---

## 2. Proyección (Π)

**Enunciado:** Nombre y precio de todos los productos.

**Álgebra Relacional:**
```
Π Nombre, Precio (Productos)
```

**SQL:**
```sql
SELECT Nombre, Precio
FROM Productos;
```

**Resultado esperado:**

| Nombre     | Precio |
|------------|--------|
| Cuaderno   | 8000   |
| Lápiz      | 2000   |
| Calculadora| 45000  |
| Regla      | 3500   |
| Marcador   | 5000   |

---

## 3. Composición (selección + proyección)

**Enunciado:** Nombre de los productos cuya categoría sea 'Papelería'.

**Álgebra Relacional:**
```
Π Nombre (σ Categoría='Papelería' (Productos))
```

**SQL:**
```sql
SELECT Nombre
FROM Productos
WHERE Categoria = 'Papelería';
```

**Resultado esperado:**

| Nombre   |
|----------|
| Cuaderno |
| Lápiz    |
| Regla    |

*(Se aplica primero σ para filtrar filas y luego Π para quedarse solo con la columna Nombre.)*

---

## 4. Unión (∪)

**Enunciado:** Clientes que realizaron una compra o una devolución (nota: el esquema del taller no incluye una tabla "Pedidos" independiente; se usan las tablas *Compras* y *Devoluciones*, ambas relacionadas con Clientes por IdCliente, para ilustrar la operación UNION).

Se construyen dos relaciones intermedias con la misma estructura (Nombre):

- **T1** = clientes que compraron
- **T2** = clientes que hicieron devolución

**Álgebra Relacional:**
```
T1 = Π Nombre (Clientes ⋈ Compras)
T2 = Π Nombre (Clientes ⋈ Devoluciones)

Resultado = T1 ∪ T2
```

**SQL:**
```sql
SELECT Nombre FROM Clientes
WHERE IdCliente IN (SELECT IdCliente FROM Compras)
UNION
SELECT Nombre FROM Clientes
WHERE IdCliente IN (SELECT IdCliente FROM Devoluciones);
```

**Resultado esperado:**

| Nombre |
|--------|
| Ana    |
| Luis   |
| Carlos |
| Sofía  |

*(UNION elimina duplicados; como todos los clientes compraron algo, el resultado final incluye a los 4, sin repetir a Ana y Sofía que además devolvieron.)*

---

## 5. Diferencia (−)

**Enunciado:** Clientes que realizaron compras, pero no hicieron devoluciones.

**Álgebra Relacional:**
```
Π Nombre (Clientes ⋈ (Π IdCliente(Compras) − Π IdCliente(Devoluciones)))
```

**SQL:**
```sql
SELECT Nombre
FROM Clientes
WHERE IdCliente IN (SELECT IdCliente FROM Compras)
  AND IdCliente NOT IN (SELECT IdCliente FROM Devoluciones);
```

**Resultado esperado:**

| Nombre |
|--------|
| Luis   |
| Carlos |

*(Compradores: {Ana, Luis, Carlos, Sofía}. Con devolución: {Ana, Sofía}. Diferencia: {Luis, Carlos}.)*

---

## 6. Producto Cartesiano (×)

**Enunciado:** Todas las combinaciones posibles entre clientes y productos.

**Álgebra Relacional:**
```
Clientes × Productos
```

**SQL:**
```sql
SELECT *
FROM Clientes
CROSS JOIN Productos;
```

**Resultado esperado:** 4 clientes × 5 productos = **20 filas** (combinación de cada cliente con cada producto). Ejemplo de las primeras filas:

| IdCliente | Nombre | Ciudad  | Código | Nombre Prod | Categoría | Precio |
|-----------|--------|---------|--------|-------------|-----------|--------|
| 1         | Ana    | Bogotá  | P01    | Cuaderno    | Papelería | 8000   |
| 1         | Ana    | Bogotá  | P02    | Lápiz       | Papelería | 2000   |
| 1         | Ana    | Bogotá  | P03    | Calculadora | Tecnología| 45000  |
| 1         | Ana    | Bogotá  | P04    | Regla       | Papelería | 3500   |
| 1         | Ana    | Bogotá  | P05    | Marcador    | Oficina   | 5000   |
| 2         | Luis   | Medellín| P01    | Cuaderno    | Papelería | 8000   |
| ...       | ...    | ...     | ...    | ...         | ...       | ...    |

*(y así sucesivamente hasta completar las 20 combinaciones: 4 clientes × 5 productos cada uno.)*

---

## 7. Renombramiento (ρ)

**Enunciado:** Comparar los precios de los productos usando alias sobre la misma tabla.

**Álgebra Relacional:**
```
ρ P1(Productos), ρ P2(Productos)

Resultado = Π P1.Nombre, P1.Precio, P2.Nombre, P2.Precio
            (P1 ⋈ (P1.Precio > P2.Precio) P2)
```

**SQL:**
```sql
SELECT P1.Nombre AS Producto1, P1.Precio AS Precio1,
       P2.Nombre AS Producto2, P2.Precio AS Precio2
FROM Productos P1, Productos P2
WHERE P1.Precio > P2.Precio;
```

**Resultado esperado** (10 pares donde el precio del primer producto supera al segundo):

| Producto1   | Precio1 | Producto2 | Precio2 |
|-------------|---------|-----------|---------|
| Cuaderno    | 8000    | Lápiz     | 2000    |
| Cuaderno    | 8000    | Regla     | 3500    |
| Cuaderno    | 8000    | Marcador  | 5000    |
| Calculadora | 45000   | Cuaderno  | 8000    |
| Calculadora | 45000   | Lápiz     | 2000    |
| Calculadora | 45000   | Regla     | 3500    |
| Calculadora | 45000   | Marcador  | 5000    |
| Regla       | 3500    | Lápiz     | 2000    |
| Marcador    | 5000    | Lápiz     | 2000    |
| Marcador    | 5000    | Regla     | 3500    |

*(ρ es necesario porque en un self-join se necesitan dos alias distintos, P1 y P2, para referenciar la misma tabla dos veces sin ambigüedad.)*

---

## 8. Expresión completa

**Enunciado:** Nombre de los productos con precio mayor a $3.000 y categoría Papelería.

**Álgebra Relacional:**
```
Π Nombre (σ Precio>3000 ∧ Categoría='Papelería' (Productos))
```

**SQL:**
```sql
SELECT Nombre
FROM Productos
WHERE Precio > 3000
  AND Categoria = 'Papelería';
```

**Resultado esperado:**

| Nombre   |
|----------|
| Cuaderno |
| Regla    |

*(Lápiz queda excluido porque su precio, 2000, no supera 3000.)*

---

## Preguntas de reflexión

**1. ¿Qué diferencia existe entre selección y proyección?**

La **selección (σ)** filtra **filas** (tuplas) de una relación según una condición lógica, sin cambiar el número de columnas — por ejemplo, quedarse solo con los productos de categoría 'Papelería'. La **proyección (Π)** filtra **columnas**, mostrando solo los atributos indicados y eliminando duplicados si los hay, sin afectar el número de filas relevantes — por ejemplo, mostrar solo Nombre y Precio de todos los productos. En resumen: σ recorta filas (horizontal), Π recorta columnas (vertical).

**2. ¿Para qué sirve el producto cartesiano?**

Sirve para combinar cada tupla de una relación con cada tupla de otra, generando todas las combinaciones posibles entre ambas. Es la base teórica sobre la que se construyen los **joins**: normalmente no se usa solo, sino seguido de una selección que filtra las combinaciones válidas (por ejemplo, emparejar clientes con productos que realmente compraron). También es útil para análisis exploratorios donde se necesitan todas las combinaciones posibles entre dos conjuntos (como una matriz de posibilidades).

**3. ¿Cuándo utilizaría la unión?**

Cuando se necesita combinar los resultados de dos consultas (con el mismo esquema de columnas) en un solo conjunto, eliminando duplicados. Es útil, por ejemplo, para obtener una lista consolidada de clientes que aparecen en distintas tablas o condiciones (compras, devoluciones, pedidos), o para juntar resultados de consultas similares sobre distintas fuentes de datos que comparten estructura.

**4. ¿Cuál es la utilidad del renombramiento?**

El renombramiento (ρ) permite asignar un alias a una relación o a sus atributos. Es indispensable en operaciones como el **self-join** (unir una tabla consigo misma), donde de otro modo habría ambigüedad al referirse dos veces a la misma tabla y a sus columnas. También ayuda a hacer más legibles los resultados, evitar conflictos de nombres cuando se combinan varias tablas con columnas iguales, y dar nombres más descriptivos a los resultados finales de una consulta.
