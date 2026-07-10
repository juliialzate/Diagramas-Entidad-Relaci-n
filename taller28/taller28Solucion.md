# Ejercicios de Álgebra Relacional y SQL

# Caso Tienda de Tecnología

## Descripción del caso

La tienda de tecnología administra las tablas:

- `PRODUCTO`
- `CATEGORIA`
- `SUCURSAL`
- `INVENTARIO`

### Las relaciones principales son:

```text
PRODUCTO(IdProducto, Nombre, Precio, IdCategoria)

CATEGORIA(IdCategoria, NombreCategoria)

SUCURSAL(IdSucursal, NombreSucursal, Ciudad)

INVENTARIO(IdProducto, IdSucursal)
```

---

# 1. Ejercicio 1. Intersección (∩)

## Enunciado

Obtenga los productos que se encuentran tanto en la sucursal **Centro** como en la sucursal **Norte**.

### Álgebra Relacional

Primero obtenemos los productos de cada sucursal:

```text
Centro = πIdProducto(σIdSucursal=1(INVENTARIO))

Norte = πIdProducto(σIdSucursal=2(INVENTARIO))
```

La intersección es:

```text
πIdProducto(σIdSucursal=1(INVENTARIO))
∩
πIdProducto(σIdSucursal=2(INVENTARIO))
```

### SQL

```sql
SELECT IdProducto
FROM INVENTARIO
WHERE IdSucursal = 1

INTERSECT

SELECT IdProducto
FROM INVENTARIO
WHERE IdSucursal = 2;
```

---

# 2. Ejercicio 2. Reunión Natural (▷◁)

## Enunciado

Mostrar el nombre del producto junto con el nombre de su categoría.

### Álgebra Relacional

Se unen las tablas mediante el atributo común **IdCategoria**:

```text
πNombre, NombreCategoria
(PRODUCTO ▷◁ CATEGORIA)
```

### SQL

```sql
SELECT
    Nombre,
    NombreCategoria
FROM PRODUCTO
JOIN CATEGORIA
ON PRODUCTO.IdCategoria = CATEGORIA.IdCategoria;
```

---

# 3. Ejercicio 3. División (÷)

## Enunciado

Obtener los productos disponibles en todas las sucursales.

### Explicación

La división permite encontrar los elementos que están relacionados con todos los elementos de otro conjunto.

En este caso buscamos productos relacionados con todas las sucursales.

### Álgebra Relacional

```text
πIdProducto, IdSucursal(INVENTARIO)
÷
πIdSucursal(SUCURSAL)
```

### SQL

```sql
SELECT IdProducto
FROM INVENTARIO
GROUP BY IdProducto
HAVING COUNT(DISTINCT IdSucursal) =
(
    SELECT COUNT(*)
    FROM SUCURSAL
);
```

---

# 4. Ejercicio 4. Asignación (←)

## Enunciado

Guardar temporalmente productos con precio superior a un millón y luego mostrar nombre y precio.

### Álgebra Relacional

Asignación:

```text
TEMP ← σPrecio>1000000(PRODUCTO)
```

Después:

```text
πNombre, Precio(TEMP)
```

### SQL

```sql
WITH ProductosCaros AS
(
    SELECT *
    FROM PRODUCTO
    WHERE Precio > 1000000
)

SELECT
    Nombre,
    Precio
FROM ProductosCaros;
```

---

# 5. Ejercicio 5. Proyección Generalizada

## Enunciado

Mostrar nombre, precio y precio con IVA del **19 %**.

### Álgebra Relacional

El precio final se calcula:

```text
Precio_Final = Precio * 1,19
```

Por lo tanto:

```text
πNombre,
 Precio,
 Precio*1,19 → Precio_Final
(PRODUCTO)
```

### SQL

```sql
SELECT
    Nombre,
    Precio,
    Precio * 1.19 AS Precio_Final
FROM PRODUCTO;
```

---

# 6. Ejercicio 6. Funciones de Agregación

## Álgebra Relacional

### Cantidad de productos

```text
COUNT(IdProducto)(PRODUCTO)
```

### Precio promedio

```text
AVG(Precio)(PRODUCTO)
```

### Precio máximo

```text
MAX(Precio)(PRODUCTO)
```

### Precio mínimo

```text
MIN(Precio)(PRODUCTO)
```

### Valor total

```text
SUM(Precio)(PRODUCTO)
```

## SQL

```sql
SELECT COUNT(*) AS CantidadProductos
FROM PRODUCTO;

SELECT AVG(Precio) AS PrecioPromedio
FROM PRODUCTO;

SELECT MAX(Precio) AS PrecioMaximo
FROM PRODUCTO;

SELECT MIN(Precio) AS PrecioMinimo
FROM PRODUCTO;

SELECT SUM(Precio) AS ValorTotal
FROM PRODUCTO;
```

# 7. Ejercicio 7. Análisis

## ¿Qué diferencia existe entre proyección y proyección generalizada?

La proyección normal solamente selecciona columnas existentes.

La proyección generalizada permite crear nuevos atributos mediante cálculos.

---

## ¿Para qué sirve la división?

Sirve para obtener elementos que cumplen una condición para **todos** los elementos de otro conjunto.

---

## ¿Qué ventaja ofrece la reunión natural?

Permite combinar información de tablas relacionadas usando atributos comunes.

---

## ¿Por qué la asignación facilita consultas complejas?

Porque permite guardar resultados intermedios y reutilizarlos.

---

## ¿Qué función obtiene el precio promedio?

La función **AVG**.

---

# 8. Ejercicio 8. Reto

## Enunciado

Mostrar nombre del producto, categoría, precio y precio con IVA, ordenados del más costoso al más económico.

### Álgebra Relacional

```text
πNombre,
 NombreCategoria,
 Precio,
 Precio*1,19 → PrecioFinal
(PRODUCTO ▷◁ CATEGORIA)
```

### SQL

```sql
SELECT
    P.Nombre,
    C.NombreCategoria,
    P.Precio,
    P.Precio * 1.19 AS Precio_Final
FROM PRODUCTO P
JOIN CATEGORIA C
ON P.IdCategoria = C.IdCategoria
ORDER BY P.Precio DESC;
```

---

# 9. Preguntas de análisis final

## ¿Por qué es importante conocer las operaciones del álgebra relacional antes de aprender SQL?

El álgebra relacional permite entender la lógica de las consultas antes de escribir código SQL.

Ayuda a comprender qué datos se necesitan obtener y cómo se deben organizar las operaciones.

---

## Explica cómo el álgebra relacional ayuda a comprender la forma en que una base de datos procesa las consultas.

Permite visualizar los pasos que realiza una consulta, como seleccionar, unir o filtrar información.

Esto facilita entender cómo la base de datos transforma los datos para obtener un resultado.

---

## ¿Qué ventajas ofrece utilizar la reunión natural (▷◁) en lugar del producto cartesiano (×) seguido de una selección (σ)? Argumenta tu respuesta con un ejemplo.

La reunión natural une directamente tablas relacionadas mediante atributos comunes, evitando combinaciones innecesarias.

Por ejemplo, unir **PRODUCTO** y **CATEGORIA** usando **IdCategoria** es más eficiente que combinar todas las filas y luego filtrar.

---

## ¿En qué situaciones de la vida real sería útil utilizar la operación división (÷)?

Es útil cuando se necesitan consultas que incluyan la expresión **"para todos"**.

Por ejemplo, encontrar empleados que hayan completado todos los cursos obligatorios de una empresa.

---

## ¿Cómo contribuyen la proyección generalizada y las funciones de agregación a la toma de decisiones en una empresa?

Permiten crear nuevos cálculos y resumir grandes cantidades de datos.

Por ejemplo, calcular ventas totales, precios promedio o cantidad de productos disponibles.

---

## Después de desarrollar este taller, ¿cuál de las operaciones del álgebra relacional consideras más útil o interesante y por qué?

Considero que la **división** es una de las operaciones más interesantes porque permite resolver consultas con condiciones de **"todos"**.

Un ejemplo sería encontrar productos disponibles en todas las sucursales de una empresa.

---

# 10. Script completo SQL

El siguiente script permite crear la base de datos, crear las tablas, insertar los datos del caso de estudio y ejecutar las consultas correspondientes a los ejercicios desarrollados.

## Creación de base de datos y tablas

```sql
-- =====================================================
-- CREACION DE LA BASE DE DATOS
-- =====================================================

CREATE DATABASE TiendaTecnologia;

USE TiendaTecnologia;

-- =====================================================
-- CREACION DE TABLAS
-- =====================================================

CREATE TABLE CATEGORIA (
    IdCategoria INT PRIMARY KEY,
    NombreCategoria VARCHAR(50) NOT NULL
);

CREATE TABLE PRODUCTO (
    IdProducto INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    IdCategoria INT,
    FOREIGN KEY (IdCategoria) REFERENCES CATEGORIA(IdCategoria)
);

CREATE TABLE SUCURSAL (
    IdSucursal INT PRIMARY KEY,
    NombreSucursal VARCHAR(50) NOT NULL,
    Ciudad VARCHAR(50) NOT NULL
);

CREATE TABLE INVENTARIO (
    IdProducto INT,
    IdSucursal INT,
    PRIMARY KEY (IdProducto, IdSucursal),
    FOREIGN KEY (IdProducto) REFERENCES PRODUCTO(IdProducto),
    FOREIGN KEY (IdSucursal) REFERENCES SUCURSAL(IdSucursal)
);

-- =====================================================
-- INSERCION DE DATOS
-- =====================================================

INSERT INTO CATEGORIA VALUES
(1, 'Computadores'),
(2, 'Accesorios'),
(3, 'Impresion');

INSERT INTO PRODUCTO VALUES
(1, 'Portatil', 2500000, 1),
(2, 'Celular', 1800000, 1),
(3, 'Tablet', 900000, 2),
(4, 'Monitor', 1200000, 2),
(5, 'Impresora', 850000, 3);

INSERT INTO SUCURSAL VALUES
(1, 'Centro', 'Bogota'),
(2, 'Norte', 'Bogota'),
(3, 'Sur', 'Bogota');

INSERT INTO INVENTARIO VALUES
(1,1),
(1,2),
(1,3),
(2,1),
(2,2),
(3,1),
(4,2),
(5,3);

-- =====================================================
-- EJERCICIO 1
-- INTERSECCION
-- =====================================================

SELECT IdProducto
FROM INVENTARIO
WHERE IdSucursal = 1

INTERSECT

SELECT IdProducto
FROM INVENTARIO
WHERE IdSucursal = 2;

-- =====================================================
-- EJERCICIO 2
-- REUNION NATURAL
-- =====================================================

SELECT
    P.Nombre,
    C.NombreCategoria
FROM PRODUCTO P
JOIN CATEGORIA C
ON P.IdCategoria = C.IdCategoria;

-- =====================================================
-- EJERCICIO 3
-- DIVISION
-- =====================================================

SELECT IdProducto
FROM INVENTARIO
GROUP BY IdProducto
HAVING COUNT(DISTINCT IdSucursal) =
(
    SELECT COUNT(*)
    FROM SUCURSAL
);

-- =====================================================
-- EJERCICIO 4
-- ASIGNACION
-- =====================================================

WITH ProductosCaros AS
(
    SELECT *
    FROM PRODUCTO
    WHERE Precio > 1000000
)

SELECT
    Nombre,
    Precio
FROM ProductosCaros;

-- =====================================================
-- EJERCICIO 5
-- PROYECCION GENERALIZADA
-- =====================================================

SELECT
    Nombre,
    Precio,
    Precio * 1.19 AS Precio_Final
FROM PRODUCTO;

-- =====================================================
-- EJERCICIO 6
-- FUNCIONES DE AGREGACION
-- =====================================================

SELECT COUNT(*) AS CantidadProductos
FROM PRODUCTO;

SELECT AVG(Precio) AS PrecioPromedio
FROM PRODUCTO;

SELECT MAX(Precio) AS PrecioMaximo
FROM PRODUCTO;

SELECT MIN(Precio) AS PrecioMinimo
FROM PRODUCTO;

SELECT SUM(Precio) AS ValorTotal
FROM PRODUCTO;

-- =====================================================
-- EJERCICIO 8
-- RETO
-- =====================================================

SELECT
    P.Nombre,
    C.NombreCategoria,
    P.Precio,
    P.Precio * 1.19 AS Precio_Final
FROM PRODUCTO P
JOIN CATEGORIA C
ON P.IdCategoria = C.IdCategoria
ORDER BY P.Precio DESC;
```
