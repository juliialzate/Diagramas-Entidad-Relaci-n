-- ==========================================
-- CREACIÓN DE TABLAS
-- ==========================================

CREATE TABLE Productos (
    Codigo VARCHAR(3) PRIMARY KEY,
    Nombre VARCHAR(50),
    Categoria VARCHAR(50),
    Precio INT
);

CREATE TABLE Clientes (
    IdCliente INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Ciudad VARCHAR(50)
);

CREATE TABLE Compras (
    IdCliente INT,
    CodigoProducto VARCHAR(3),
    PRIMARY KEY (IdCliente, CodigoProducto),
    FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente),
    FOREIGN KEY (CodigoProducto) REFERENCES Productos(Codigo)
);

CREATE TABLE Devoluciones (
    IdCliente INT,
    CodigoProducto VARCHAR(3),
    PRIMARY KEY (IdCliente, CodigoProducto),
    FOREIGN KEY (IdCliente) REFERENCES Clientes(IdCliente),
    FOREIGN KEY (CodigoProducto) REFERENCES Productos(Codigo)
);

-- ==========================================
-- INSERCIÓN DE DATOS
-- ==========================================

-- Productos
INSERT INTO Productos (Codigo, Nombre, Categoria, Precio) VALUES
('P01', 'Cuaderno', 'Papelería', 8000),
('P02', 'Lápiz', 'Papelería', 2000),
('P03', 'Calculadora', 'Tecnología', 45000),
('P04', 'Regla', 'Papelería', 3500),
('P05', 'Marcador', 'Oficina', 5000);

-- Clientes
INSERT INTO Clientes (IdCliente, Nombre, Ciudad) VALUES
(1, 'Ana', 'Bogotá'),
(2, 'Luis', 'Medellín'),
(3, 'Carlos', 'Bogotá'),
(4, 'Sofía', 'Cali');

-- Compras
INSERT INTO Compras (IdCliente, CodigoProducto) VALUES
(1, 'P01'),
(1, 'P03'),
(2, 'P02'),
(3, 'P04'),
(4, 'P05');

-- Devoluciones
INSERT INTO Devoluciones (IdCliente, CodigoProducto) VALUES
(1, 'P03'),
(4, 'P05');
