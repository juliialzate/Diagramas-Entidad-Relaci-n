-- ============================================
-- CREAR BASE DE DATOS (Opcional)
-- ============================================

CREATE DATABASE TiendaTecnologia;
GO

USE TiendaTecnologia;
GO

-- ============================================
-- ELIMINAR TABLAS SI EXISTEN
-- ============================================

DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Sucursales;

-- ============================================
-- CREACIÓN DE TABLAS
-- ============================================

CREATE TABLE Clientes (
    IdCliente INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Productos (
    IdProducto INT PRIMARY KEY,
    NombreProducto VARCHAR(100) NOT NULL,
    Precio DECIMAL(12,2) NOT NULL
);

CREATE TABLE Sucursales (
    IdSucursal INT PRIMARY KEY,
    NombreSucursal VARCHAR(50) NOT NULL
);

CREATE TABLE Ventas (
    IdVenta INT PRIMARY KEY,
    IdCliente INT NOT NULL,
    IdProducto INT NOT NULL,
    IdSucursal INT NOT NULL,

    CONSTRAINT FK_Ventas_Clientes
        FOREIGN KEY (IdCliente)
        REFERENCES Clientes(IdCliente),

    CONSTRAINT FK_Ventas_Productos
        FOREIGN KEY (IdProducto)
        REFERENCES Productos(IdProducto),

    CONSTRAINT FK_Ventas_Sucursales
        FOREIGN KEY (IdSucursal)
        REFERENCES Sucursales(IdSucursal)
);

-- ============================================
-- INSERTAR DATOS EN CLIENTES
-- ============================================

INSERT INTO Clientes (IdCliente, Nombre)
VALUES
(1, 'Ana'),
(2, 'Juan'),
(3, 'María'),
(4, 'Pedro');

-- ============================================
-- INSERTAR DATOS EN PRODUCTOS
-- ============================================

INSERT INTO Productos (IdProducto, NombreProducto, Precio)
VALUES
(101, 'Computador Portátil', 3200000),
(102, 'Mouse Inalámbrico', 85000),
(103, 'Teclado Mecánico', 250000),
(104, 'Monitor LED', 980000);

-- ============================================
-- INSERTAR DATOS EN SUCURSALES
-- ============================================

INSERT INTO Sucursales (IdSucursal, NombreSucursal)
VALUES
(1, 'Centro'),
(2, 'Norte'),
(3, 'Sur');

-- ============================================
-- INSERTAR DATOS EN VENTAS
-- ============================================

INSERT INTO Ventas
(IdVenta, IdCliente, IdProducto, IdSucursal)
VALUES
(1, 1, 101, 1),
(2, 1, 102, 2),
(3, 1, 103, 3),
(4, 2, 101, 1),
(5, 2, 104, 3),
(6, 3, 102, 2),
(7, 4, 101, 1),
(8, 4, 102, 2);

-- ============================================
-- VERIFICACIÓN
-- ============================================

SELECT * FROM Clientes;
SELECT * FROM Productos;
SELECT * FROM Sucursales;
SELECT * FROM Ventas;

CODIGO CONSULTAS SQL PUNTO 26
/*=========================================================
TALLER
Otras Operaciones del Álgebra Relacional con SQL
=========================================================*/


/*=========================================================
1. INTERSECCIÓN (∩)
Clientes que compraron un Computador Portátil (101)
y también un Mouse Inalámbrico (102).
En MySQL se simula utilizando IN.
=========================================================*/

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


/*=========================================================
2. REUNIÓN NATURAL (INNER JOIN)
Mostrar:
- Nombre del cliente
- Nombre del producto
- Nombre de la sucursal
=========================================================*/

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


/*=========================================================
3. DIVISIÓN (÷)
Cliente que ha realizado compras en todas las sucursales.
=========================================================*/

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


/*=========================================================
4. ASIGNACIÓN (←)
Crear una CTE con los productos cuyo precio
sea superior a $500.000.
=========================================================*/

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
