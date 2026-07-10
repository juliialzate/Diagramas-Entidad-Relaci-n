# Taller de Clase: SQL Avanzado, DDL y DCL

## 1. Crear las tablas Clientes, Categorías, Productos y Ventas con sus llaves primarias y foráneas. 

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

## 2. Insertar mínimo 5 clientes, 5 categorías, 10 productos y 10 ventas. 

```sql
INSERT INTO Clientes (id_cliente, nombre, ciudad) VALUES
(1, 'Juan Pérez', 'Bogotá'),
(2, 'María Gómez', 'Medellín'),
(3, 'Carlos Ruiz', 'Cali'),
(4, 'Ana Torres', 'Barranquilla'),
(5, 'Luis Martínez', 'Cartagena');


INSERT INTO Categorias (id_categoria, categoria) VALUES
(1, 'Electrónica'),
(2, 'Ropa'),
(3, 'Hogar'),
(4, 'Alimentos'),
(5, 'Juguetes');


INSERT INTO Productos (id_producto, nombre, precio, id_categoria) VALUES
(1, 'Televisor', 1500000.00, 1),
(2, 'Celular', 2000000.00, 1),
(3, 'Camisa', 50000.00, 2),
(4, 'Pantalón', 80000.00, 2),
(5, 'Sofá', 1200000.00, 3),
(6, 'Lámpara', 90000.00, 3),
(7, 'Arroz', 5000.00, 4),
(8, 'Aceite', 12000.00, 4),
(9, 'Muñeca', 35000.00, 5),
(10, 'Carro RC', 120000.00, 5);


INSERT INTO Ventas (id_venta, id_cliente, id_producto, fecha) VALUES
(1, 1, 1, '2024-01-15'),
(2, 2, 3, '2024-01-16'),
(3, 3, 5, '2024-01-17'),
(4, 4, 7, '2024-01-18'),
(5, 5, 9, '2024-01-19'),
(6, 1, 2, '2024-01-20'),
(7, 2, 4, '2024-01-21'),
(8, 3, 6, '2024-01-22'),
(9, 4, 8, '2024-01-23'),
(10, 5, 10, '2024-01-24');
```

## 3. Realizar un JOIN múltiple que muestre: cliente, producto, categoría y fecha de la venta. 

### Consulta

```sql
SELECT 
    c.nombre AS cliente,
    p.nombre AS producto,
    ca.categoria AS categoria,
    v.fecha AS fecha_venta
FROM Ventas v
INNER JOIN Clientes c ON v.id_cliente = c.id_cliente
INNER JOIN Productos p ON v.id_producto = p.id_producto
INNER JOIN Categorias ca ON p.id_categoria = ca.id_categoria;
```


## 4. Realizar una consulta GROUP BY para contar cuántas prendas hay por categoría. 

### Consulta

```sql
SELECT 
    ca.categoria,
    COUNT(p.id_producto) AS cantidad_productos
FROM Categorias ca
LEFT JOIN Productos p ON ca.id_categoria = p.id_categoria
GROUP BY ca.categoria;
```


## 5. Usar HAVING para mostrar solo las categorías con más de dos productos. 

### Consulta

```sql
SELECT 
    ca.categoria,
    COUNT(p.id_producto) AS cantidad_productos
FROM Categorias ca
INNER JOIN Productos p ON ca.id_categoria = p.id_categoria
GROUP BY ca.categoria
HAVING COUNT(p.id_producto) > 2;
```

## 6. Realizar una subconsulta para mostrar las prendas cuyo precio sea mayor al promedio. 

### Consulta

```sql
SELECT 
    id_producto,
    nombre,
    precio
FROM Productos
WHERE precio > (SELECT AVG(precio) FROM Productos);
```


## 7. Crear una vista llamada VistaProductos con nombre y precio, y consultarla. 

### Consulta

```sql
CREATE VIEW VistaProductos AS
SELECT nombre, precio
FROM Productos;

-- Consultar la vista
SELECT * FROM VistaProductos;

```

### Captura Resultado

## 8. Modificar la tabla Productos agregando la columna talla con ALTER TABLE. 

### Consulta

```sql
ALTER TABLE Productos
ADD talla VARCHAR(10);
```

## 9. Eliminar la vista VistaProductos y luego la tabla Ventas usando DROP. 

### Consulta

```sql
DROP VIEW VistaProductos;

DROP TABLE Ventas;
```
## 10. Conseder permiso

### Consulta

```sql
  GRANT SELECT ON punto32.Productos TO 'Laura'@'localhost';
FLUSH PRIVILEGES;
```


## 11. Quitar el permiso SELECT al usuario Laura usando REVOKE. 

### Consulta

```sql
REVOKE SELECT ON punto32.Productos FROM 'Laura'@'localhost';
FLUSH PRIVILEGES;
```

## Conclusión de 5 a 10 líneas sobre los temas trabajados. 

El manejo de bases de datos relacionales requiere dominar consultas que combinan múltiples tablas mediante JOIN, agrupen información con GROUP BY y HAVING, y filtren resultados usando subconsultas. Asimismo, es fundamental saber crear vistas para simplificar accesos, modificar estructuras con ALTER TABLE, eliminar objetos con DROP, y administrar permisos mediante GRANT y REVOKE para garantizar la seguridad e integridad de los datos.
