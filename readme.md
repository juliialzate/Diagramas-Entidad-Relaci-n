# Taller de Modelo Entidad Relación

## 1. Biblioteca

```mermaid
erDiagram
    direction TB

    LIBRO {
        int id_libro PK
        string titulo
        string autores
        date ano_publicacion
    }

    USUARIO {
        int id_usuario PK
        string nombre
        string direccion
        int telefono
    }

    PRESTAMO {
        int id_usuario FK
        int id_libro FK
        date fecha_prestamo
        date fecha_devolucion
    }

    USUARIO ||--|{ PRESTAMO : solicita
    LIBRO ||--|{ PRESTAMO : incluye
```

![biblioteca](biblioteca.png)

## 2. Compra
```mermaid
erDiagram
    CLIENTE {
        int id_cliente PK
        string nombre
        string correo
        int telefono
    }

    FACTURA {
        int id_factura PK
        date fecha_venta
        int id_cliente FK
    }

    PRODUCTO {
        int id_producto PK
        string nombre
        int precio
        int stock
    }

    DETALLE_FACTURA {
        int id_factura  FK
        int id_producto  FK
        int cantidad_comprada
    }

    CLIENTE ||--o{ FACTURA : realiza
    FACTURA ||--|{ DETALLE_FACTURA : contiene
    PRODUCTO ||--|{ DETALLE_FACTURA : aparece_en
```   
![compra](compra.png)


FACTURA es la entidad asociativa porque resuelve la relación muchos a muchos (M:N) entre CLIENTE y PRODUCTO, descomponiéndola en dos relaciones 1:N (CLIENTE–FA…FACTURA es la entidad asociativa porque resuelve la relación muchos a muchos (M:N) entre CLIENTE y PRODUCTO, descomponiéndola en dos relaciones 1:N (CLIENTE–FACTURA y FACTURA–PRODUCTO). Además, la venta tiene atributos propios (número de factura, fecha y cantidad comprada) que no pertenecen ni al cliente ni al producto, sino a la transacción en sí, por lo que esa relación debe modelarse como entidad. Su clave primaria compuesta (id_cliente + id_producto, ambas FK) permite registrar cada compra específica con su cantidad correspondiente.


## 3. Universidad
```mermaid
erDiagram
	direction TB
	MATRICULA {
		int id_matricula UK ""  
		string semestre  ""  
		double nota_final  "" 
    int id_estudiante FK
    int id_asignatura FK
    int id_profesor FK 
	}

	ASIGNATURA {
		int id_asignatura PK ""  
		string nombre  ""  
		int creditos  ""   
	}

	PROFESOR {
		int id_profesor PK ""  
		string nombre  ""
    string especialidad  
		
	}

  ESTUDIANTE {
    int id_estudiante
    string nombre
    string carrera
  }

    
    ASIGNATURA ||--|{ MATRICULA : tiene
    ASIGNATURA }|--|{ PROFESOR : dicta
    PROFESOR ||--|{ MATRICULA : dicta
    ESTUDIANTE ||--|{ MATRICULA : realiza
```  
![universidad](universidad.png)
    
¿Relación binaria o ternaria?
En este modelo existe una relación ternaria, conformada por ESTUDIANTE, ASIGNATURA y PROFESOR, las cuales convergen en la entidad asociativa MATRICULA. Esto se debe a que cada registro de matrícula no depende de solo dos entidades, sino de la combinación simultánea de las tres: un estudiante específico, cursando una asignatura específica, con un profesor específico (ya que una misma asignatura puede ser impartida por varios profesores, por lo que es necesario saber con cuál de ellos la cursó el estudiante). Además, persiste una relación binaria M:N entre ASIGNATURA y PROFESOR, ya que un profesor puede impartir varias asignaturas y una asignatura puede ser impartida por varios profesores, independientemente de las matrículas.
