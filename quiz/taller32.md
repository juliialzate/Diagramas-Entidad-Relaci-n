# Taller de Clase: SQL Avanzado, DDL y DCL

## Empresa: **Moda Total**

---

# README - Solución completa del taller

## 1. Introducción

La empresa **Moda Total** desea organizar la información de su almacén de ropa mediante una base de datos.
Para ello se manejarán cuatro tablas principales:

* **Clientes**: almacena los datos de los clientes.
* **Categorias**: guarda las categorías de las prendas.
* **Productos**: registra las prendas con su precio y categoría.
* **Ventas**: almacena las ventas realizadas, relacionando clientes y productos.

En este taller se aplican temas de:

* **DDL (Data Definition Language)**: `CREATE`, `ALTER`, `DROP`
* **DML (Data Manipulation Language)**: `INSERT`
* **Consultas SQL**: `JOIN`, `GROUP BY`, `HAVING`, subconsultas
* **Vistas**: `CREATE VIEW`
* **DCL (Data Control Language)**: `GRANT`, `REVOKE`

---

# 2. Estructura del problema

## Tablas dadas

### Clientes

| Campo      | Tipo        |
| ---------- | ----------- |
| id_cliente | INT         |
| nombre     | VARCHAR(50) |
| ciudad     | VARCHAR(50) |

### Categorias

| Campo        | Tipo        |
| ------------ | ----------- |
| id_categoria | INT         |
| categoria    | VARCHAR(50) |

### Productos

| Campo        | Tipo          |
| ------------ | ------------- |
| id_producto  | INT           |
| nombre       | VARCHAR(50)   |
| precio       | DECIMAL(10,2) |
| id_categoria | INT           |

### Ventas

| Campo       | Tipo |
| ----------- | ---- |
| id_venta    | INT  |
| id_cliente  | INT  |
| id_producto | INT  |
| fecha       | DATE |

---

# 3. Solución punto por punto

---

# Punto 1. Crear las tablas Clientes, Categorías, Productos y Ventas con sus llaves primarias y foráneas

## Explicación

### Relaciones del modelo

* `Productos.id_categoria` → referencia a `Categorias.id_categoria`
* `Ventas.id_cliente` → referencia a `Clientes.id_cliente`
* `Ventas.id_producto` → referencia a `Productos.id_producto`

---

## Script SQL de creación de tablas

```sql
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50),
    ciudad VARCHAR(50)
);

CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY,
    categoria VARCHAR(50)
);

CREATE TABLE Productos (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(50),
    precio DECIMAL(10,2),
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);

CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    fecha DATE,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);
```

---

# Punto 2. Insertar mínimo 5 clientes, 5 categorías, 10 productos y 10 ventas

## Explicación


---

## Script de inserción de datos

## 2.1 Insertar clientes

```sql
INSERT INTO Clientes (id_cliente, nombre, ciudad) VALUES
(1, 'Ana Torres', 'Bogotá'),
(2, 'Carlos Ruiz', 'Medellín'),
(3, 'Laura Gómez', 'Cali'),
(4, 'Mateo Díaz', 'Barranquilla'),
(5, 'Sofía Pérez', 'Bucaramanga');
```

## 2.2 Insertar categorías

```sql
INSERT INTO Categorias (id_categoria, categoria) VALUES
(1, 'Camisas'),
(2, 'Pantalones'),
(3, 'Chaquetas'),
(4, 'Vestidos'),
(5, 'Accesorios');
```

## 2.3 Insertar productos

```sql
INSERT INTO Productos (id_producto, nombre, precio, id_categoria) VALUES
(1, 'Camisa Blanca', 85000.00, 1),
(2, 'Camisa Negra', 92000.00, 1),
(3, 'Jean Azul', 120000.00, 2),
(4, 'Pantalón Formal', 150000.00, 2),
(5, 'Chaqueta Cuero', 250000.00, 3),
(6, 'Chaqueta Jean', 180000.00, 3),
(7, 'Vestido Rojo', 210000.00, 4),
(8, 'Vestido Negro', 230000.00, 4),
(9, 'Correa Casual', 45000.00, 5),
(10, 'Bufanda Lana', 60000.00, 5);
```

## 2.4 Insertar ventas

```sql
INSERT INTO Ventas (id_venta, id_cliente, id_producto, fecha) VALUES
(1, 1, 1, '2026-07-01'),
(2, 2, 3, '2026-07-01'),
(3, 3, 5, '2026-07-02'),
(4, 4, 7, '2026-07-02'),
(5, 5, 9, '2026-07-03'),
(6, 1, 2, '2026-07-03'),
(7, 2, 4, '2026-07-04'),
(8, 3, 6, '2026-07-04'),
(9, 4, 8, '2026-07-05'),
(10, 5, 10, '2026-07-05');
```

---

## Consultas

```sql
/* 
   PUNTO 3. JOIN MÚLTIPLE
   Mostrar: cliente, producto, categoría y fecha de la venta
    */

SELECT 
    C.nombre AS cliente,
    P.nombre AS producto,
    CA.categoria AS categoria,
    V.fecha AS fecha_venta
FROM Ventas V
INNER JOIN Clientes C 
    ON V.id_cliente = C.id_cliente
INNER JOIN Productos P 
    ON V.id_producto = P.id_producto
INNER JOIN Categorias CA 
    ON P.id_categoria = CA.id_categoria;


/* 
   PUNTO 4. GROUP BY
   Contar cuántas prendas hay por categoría
    */

SELECT 
    CA.categoria,
    COUNT(*) AS total_prendas
FROM Productos P
INNER JOIN Categorias CA
    ON P.id_categoria = CA.id_categoria
GROUP BY CA.categoria;


/* 
   PUNTO 5. HAVING
   Mostrar solo las categorías con más de 2 productos
    */

SELECT 
    CA.categoria,
    COUNT(*) AS total_prendas
FROM Productos P
INNER JOIN Categorias CA
    ON P.id_categoria = CA.id_categoria
GROUP BY CA.categoria
HAVING COUNT(*) > 2;


/* 
   PUNTO 6. SUBCONSULTA
   Mostrar las prendas cuyo precio sea mayor al promedio
    */

SELECT 
    nombre,
    precio
FROM Productos
WHERE precio > (
    SELECT AVG(precio)
    FROM Productos
);


/* 
   PUNTO 7. CREAR UNA VISTA LLAMADA VistaProductos
   con nombre y precio, y consultarla
    */

CREATE VIEW VistaProductos AS
SELECT nombre, precio
FROM Productos;

SELECT * FROM VistaProductos;


/* 
   PUNTO 8. ALTER TABLE
   Agregar la columna talla a Productos
    */

ALTER TABLE Productos
ADD talla VARCHAR(10);





/* 
   PUNTO 9. ELIMINAR LA VISTA VistaProductos
   y luego la tabla Ventas usando DROP
    */

DROP VIEW VistaProductos;
DROP TABLE Ventas;


/* 
   PUNTO 10. CONCEDER PERMISO SELECT AL USUARIO Laura
   sobre Productos con GRANT
    */

GRANT SELECT ON Productos TO 'Laura'@'localhost';


/* 
   PUNTO 11. QUITAR EL PERMISO SELECT A Laura con REVOKE
    */

REVOKE SELECT ON Productos FROM 'Laura'@'localhost';

```

### Punto 7 
``` sql 
-- PUNTO 7. Crear una vista llamada VistaProductos con nombre y precio, y consultarla

CREATE VIEW VistaProductos AS
SELECT nombre, precio
FROM Productos;
```
