# Taller de Clase: Reunión Externa (JOIN) en una Tienda de Cosméticos

## 1. Identifique cuál cosmético no ha sido vendido

### Tabla COSMETICOS

| id_cosmetico | producto |
|--------------|-----------------------|
| 101 | Labial Mate |
| 102 | Base Líquida |
| 103 | Máscara de Pestañas |

### Tabla VENTAS

| id_cosmetico | cliente |
|--------------|----------|
| 101 | Laura |
| 102 | Andrés |
| 104 | Sofía |

Comparando los **id_cosmetico** de ambas tablas:

- El **101** aparece en ambas tablas.
- El **102** aparece en ambas tablas.
- El **103** solo aparece en la tabla **COSMETICOS**.

### Respuesta

El cosmético que aún no ha sido vendido es:

| id_cosmetico | producto |
|--------------|-----------------------|
| 103 | Máscara de Pestañas |

---

# 2. Identifique cuál venta corresponde a un producto que no existe en la tabla COSMETICOS

Ahora observamos la tabla **VENTAS**.

- El producto **101** existe en COSMETICOS.
- El producto **102** existe en COSMETICOS.
- El producto **104** no existe en COSMETICOS.

### Respuesta

| id_cosmetico | cliente |
|--------------|----------|
| 104 | Sofía |

La venta registrada para Sofía corresponde a un producto que ya no existe en el inventario.

---

# 3. Expresiones en Álgebra Relacional

## INNER JOIN (Reunión Natural)

### Expresión

\[
COSMETICOS \;\bowtie_{id\_cosmetico}\; VENTAS
\]

### Significado

Une ambas tablas mostrando únicamente los registros cuyo **id_cosmetico** coincide en las dos relaciones.

---

## LEFT JOIN (Reunión Externa Izquierda)

### Expresión

\[
COSMETICOS \;\⟕_{id\_cosmetico}\; VENTAS
\]

### Significado

Conserva todos los registros de la tabla **COSMETICOS** y agrega la información de **VENTAS** cuando exista coincidencia.

---

## RIGHT JOIN (Reunión Externa Derecha)

### Expresión

\[
COSMETICOS \;\⟖_{id\_cosmetico}\; VENTAS
\]

### Significado

Conserva todos los registros de la tabla **VENTAS** y agrega la información de **COSMETICOS** cuando exista coincidencia.

---

## FULL OUTER JOIN (Reunión Externa Completa)

### Expresión

\[
COSMETICOS \;\⟗_{id\_cosmetico}\; VENTAS
\]

### Significado

Conserva todos los registros de ambas tablas, tengan o no coincidencias.

---

# 4. Consultas SQL

## INNER JOIN

```sql
SELECT C.producto, V.cliente
FROM Cosmeticos C
INNER JOIN Ventas V
ON C.id_cosmetico = V.id_cosmetico;
```

---

## LEFT JOIN

```sql
SELECT C.producto, V.cliente
FROM Cosmeticos C
LEFT JOIN Ventas V
ON C.id_cosmetico = V.id_cosmetico;
```

---

## RIGHT JOIN

```sql
SELECT C.producto, V.cliente
FROM Cosmeticos C
RIGHT JOIN Ventas V
ON C.id_cosmetico = V.id_cosmetico;
```

---

## FULL OUTER JOIN

```sql
SELECT C.producto, V.cliente
FROM Cosmeticos C
FULL OUTER JOIN Ventas V
ON C.id_cosmetico = V.id_cosmetico;
```

---

# 5. Resultados de cada consulta

## INNER JOIN

Solo muestra los registros que existen en ambas tablas.

| producto | cliente |
|----------|----------|
| Labial Mate | Laura |
| Base Líquida | Andrés |

---

## LEFT JOIN

Conserva todos los cosméticos, aunque no tengan ventas.

| producto | cliente |
|----------|----------|
| Labial Mate | Laura |
| Base Líquida | Andrés |
| Máscara de Pestañas | NULL |

**Interpretación:**

El producto **Máscara de Pestañas** aparece porque existe en el inventario, pero como no tiene una venta registrada, el cliente aparece como **NULL**.

---

## RIGHT JOIN

Conserva todas las ventas, aunque el producto no exista.

| producto | cliente |
|----------|----------|
| Labial Mate | Laura |
| Base Líquida | Andrés |
| NULL | Sofía |

**Interpretación:**

La venta realizada a **Sofía** corresponde al producto **104**, el cual no existe en la tabla **COSMETICOS**. Por eso el nombre del producto aparece como **NULL**.

---

## FULL OUTER JOIN

Conserva todos los registros de ambas tablas.

| producto | cliente |
|----------|----------|
| Labial Mate | Laura |
| Base Líquida | Andrés |
| Máscara de Pestañas | NULL |
| NULL | Sofía |

**Interpretación:**

En este resultado aparecen:

- Los productos vendidos.
- El producto que no ha sido vendido.
- La venta cuyo producto ya no existe.

---

# 6. Diferencias entre los tipos de JOIN

## INNER JOIN

Muestra únicamente los registros que tienen coincidencia en ambas tablas.

En este ejercicio aparecen únicamente los productos **101** y **102**, ya que existen tanto en la tabla **COSMETICOS** como en **VENTAS**.

---

## LEFT JOIN

Conserva todos los registros de la tabla izquierda (**COSMETICOS**).

Si un producto no tiene una venta registrada, igualmente aparece en el resultado y las columnas provenientes de **VENTAS** toman el valor **NULL**.

En este caso aparece **Máscara de Pestañas**, ya que existe en el inventario pero no ha sido vendida.

---

## RIGHT JOIN

Conserva todos los registros de la tabla derecha (**VENTAS**).

Si una venta corresponde a un producto inexistente en **COSMETICOS**, el nombre del producto aparecerá como **NULL**.

En este ejemplo aparece la venta realizada a **Sofía**, ya que el producto **104** no existe en el inventario.

---

## FULL OUTER JOIN

Combina el comportamiento del **LEFT JOIN** y del **RIGHT JOIN**.

Muestra todos los registros de ambas tablas.

Los registros que coinciden se unen y aquellos que no tienen coincidencia muestran **NULL** en las columnas faltantes.

En este ejercicio aparecen tanto el producto **Máscara de Pestañas** (sin venta) como la venta realizada a **Sofía** (sin producto registrado).

---

# Resumen

| Tipo de JOIN | ¿Qué conserva? | Resultado en este ejercicio |
|--------------|----------------|-----------------------------|
| **INNER JOIN** | Solo los registros que coinciden en ambas tablas. | Productos 101 y 102. |
| **LEFT JOIN** | Todos los registros de la tabla izquierda (COSMETICOS). | Productos 101, 102 y 103. |
| **RIGHT JOIN** | Todos los registros de la tabla derecha (VENTAS). | Ventas 101, 102 y 104. |
| **FULL OUTER JOIN** | Todos los registros de ambas tablas. | Productos 101, 102, 103 y la venta 104. |

## Forma fácil de recordarlos

- **INNER JOIN** → Solo las coincidencias.
- **LEFT JOIN** → Todo lo de la izquierda.
- **RIGHT JOIN** → Todo lo de la derecha.
- **FULL OUTER JOIN** → Todo de ambas tablas.
