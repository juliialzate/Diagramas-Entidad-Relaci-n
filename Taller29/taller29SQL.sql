-- ============================
-- Tabla: Departamento
-- ============================
CREATE TABLE Departamento (
    CodigoDepartamento INT PRIMARY KEY,
    NombreDepartamento VARCHAR(50),
    Ubicacion VARCHAR(50)
);

INSERT INTO Departamento (CodigoDepartamento, NombreDepartamento, Ubicacion) VALUES
(10, 'CONTABILIDAD', 'NEW YORK'),
(20, 'INVESTIGACION', 'DALLAS'),
(30, 'VENTAS', 'CHICAGO'),
(40, 'OPERACIONES', 'BOSTON');

-- ============================
-- Tabla: Empleado
-- ============================
CREATE TABLE Empleado (
    CodigoEmpleado INT PRIMARY KEY,
    NombreEmpleado VARCHAR(50),
    Cargo VARCHAR(50),
    CodigoJefe INT,
    Sueldo DECIMAL(10,2),
    CodigoDepartamento INT,
    FOREIGN KEY (CodigoDepartamento) REFERENCES Departamento(CodigoDepartamento)
);

INSERT INTO Empleado (CodigoEmpleado, NombreEmpleado, Cargo, CodigoJefe, Sueldo, CodigoDepartamento) VALUES
(7839, 'KING', 'PRESIDENT', 7838, 5000, 10),
(7698, 'BLAKE', 'GERENTE', 7839, 2850, 30),
(7782, 'CLARK', 'GERENTE', 7839, 2450, 10),
(7566, 'JONES', 'GERENTE', 7839, 2975, 20),
(7654, 'MARTIN', 'VENDEDOR', 7698, 1250, 30);
