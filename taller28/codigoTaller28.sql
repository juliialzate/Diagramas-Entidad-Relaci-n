codigo completo taller 28

-- =====================================================
-- CREACIÓN DE LA BASE DE DATOS
-- =====================================================

CREATE DATABASE TiendaTecnologia;

USE TiendaTecnologia;


-- =====================================================
-- CREACIÓN DE TABLAS
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
-- INSERCIÓN DE DATOS
-- =====================================================


INSERT INTO CATEGORIA VALUES
(1, 'Computadores'),
(2, 'Accesorios'),
(3, 'Impresión');


INSERT INTO PRODUCTO VALUES
(1, 'Portátil', 2500000, 1),
(2, 'Celular', 1800000, 1),
(3, 'Tablet', 900000, 2),
(4, 'Monitor', 1200000, 2),
(5, 'Impresora', 850000, 3);


INSERT INTO SUCURSAL VALUES
(1, 'Centro', 'Bogotá'),
(2, 'Norte', 'Bogotá'),
(3, 'Sur', 'Bogotá');


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
-- INTERSECCIÓN (∩)
-- Productos que están en Centro y Norte
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
-- REUNIÓN NATURAL (⨝)
-- Producto con nombre de categoría
-- =====================================================


SELECT 
    P.Nombre,
    C.NombreCategoria
FROM PRODUCTO P
JOIN CATEGORIA C
ON P.IdCategoria = C.IdCategoria;



-- =====================================================
-- EJERCICIO 3
-- DIVISIÓN (÷)
-- Productos disponibles en todas las sucursales
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
-- ASIGNACIÓN (←)
-- Productos con precio mayor a 1.000.000
-- =====================================================


WITH ProductosCaros AS
(
    SELECT *
    FROM PRODUCTO
    WHERE Precio > 1000000
)

SELECT Nombre, Precio
FROM ProductosCaros;



-- =====================================================
-- EJERCICIO 5
-- PROYECCIÓN GENERALIZADA
-- Precio con IVA del 19%
-- =====================================================


SELECT
    Nombre,
    Precio,
    Precio * 1.19 AS Precio_Final
FROM PRODUCTO;



-- =====================================================
-- EJERCICIO 6
-- FUNCIONES DE AGREGACIÓN
-- =====================================================


-- a) Cantidad de productos

SELECT COUNT(*) AS CantidadProductos
FROM PRODUCTO;


-- b) Precio promedio

SELECT AVG(Precio) AS PrecioPromedio
FROM PRODUCTO;


-- c) Precio máximo

SELECT MAX(Precio) AS PrecioMaximo
FROM PRODUCTO;


-- d) Precio mínimo

SELECT MIN(Precio) AS PrecioMinimo
FROM PRODUCTO;


-- e) Valor total de los productos

SELECT SUM(Precio) AS ValorTotal
FROM PRODUCTO;



-- =====================================================
-- EJERCICIO 7
-- ANÁLISIS
-- (No requiere consulta SQL)
-- =====================================================



-- =====================================================
-- EJERCICIO 8
-- RETO
-- Producto, categoría, precio y precio con IVA
-- Ordenados de mayor a menor precio
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
