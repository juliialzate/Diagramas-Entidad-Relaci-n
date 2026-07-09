# Consultas SQL y Álgebra Relacional

**Tablas:**
- `Empleado(CodigoEmpleado, NombreEmpleado, Cargo, CodigoJefe, Sueldo, CodigoDepartamento)`
- `Departamento(CodigoDepartamento, NombreDepartamento, Ubicacion)`

---

## 1. Nombre de todos los empleados del departamento de operaciones junto a su sueldo

**Álgebra relacional:**

```
π NombreEmpleado, Sueldo ( σ NombreDepartamento = 'OPERACIONES' ( Empleado ⋈ Departamento ) )
```

**SQL:**

```sql
SELECT E.NombreEmpleado, E.Sueldo
FROM Empleado E
JOIN Departamento D ON E.CodigoDepartamento = D.CodigoDepartamento
WHERE D.NombreDepartamento = 'OPERACIONES';
```

---

## 2. Nombre de todos los empleados cuyo sueldo es mayor a 2000 y menor a 5000

**Álgebra relacional:**

```
π NombreEmpleado ( σ Sueldo > 2000 ∧ Sueldo < 5000 ( Empleado ) )
```

**SQL:**

```sql
SELECT NombreEmpleado
FROM Empleado
WHERE Sueldo > 2000 AND Sueldo < 5000;
```

---

## 3. Producto cartesiano entre la tabla Empleado y la tabla Departamento

**Álgebra relacional:**

```
Empleado × Departamento
```

**SQL:**

```sql
SELECT *
FROM Empleado, Departamento;
```

---

## 4. Datos de los empleados cuyo código de departamento es menor o igual a 20 y su ubicación es New York

**Álgebra relacional:**

```
π Empleado.* ( σ CodigoDepartamento ≤ 20 ∧ Ubicacion = 'NEW YORK' ( Empleado ⋈ Departamento ) )
```

**SQL:**

```sql
SELECT E.*
FROM Empleado E
JOIN Departamento D ON E.CodigoDepartamento = D.CodigoDepartamento
WHERE E.CodigoDepartamento <= 20
  AND D.Ubicacion = 'NEW YORK';
```
