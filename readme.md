# Taller de Modelo Entidad Relación

## 1. Biblioteca

```mermaid
erDiagram
	direction TB
	LIBRO {
		int id_libro PK ""  
		string titulo  ""  
		string autores  "" 
    date año_publicacion 
	}

	USUARIO {
		int id_uSuario PK ""  
		string nombre  ""  
		string direccion  ""  
		int telefono  ""  
	}

	PRESTAMO {
		int id_prestamo PK ""  
		int id_usuario PK, FK ""  
		int id_libro PK, FK ""  
		date fecha_prestamo  ""  
		date fecha_devolucion  ""  
	}

    USUARIO ||--|{ PRESTAMO : solicita
    LIBRO }|--|{ PRESTAMO : tiene 
```

## 2. Compra
```mermaid
erDiagram
	direction TB
	PRODUCTO {
		int id_producto PK ""  
		string nombre  ""  
		int precio  "" 
    int stock
	}

	CLIENTE {
		int id_cliente PK ""  
		string nombre  ""  
		string correo  ""  
		int telefono  ""  
	}

	FACTURA {
		int id_factura PK ""  
		date fecha_venta  ""  
		int cantidad_comprada ""  
    int id_cliente PK, FK
    int id_producto PK, FK
	}

    CLIENTE ||--|{ FACTURA : tener
    FACTURA }|--|{ PRODUCTO : tiene 
```   

FACTURA es la entidad asociativa porque resuelve la relación muchos a muchos (M:N) entre CLIENTE y PRODUCTO, descomponiéndola en dos relaciones 1:N (CLIENTE–FA…FACTURA es la entidad asociativa porque resuelve la relación muchos a muchos (M:N) entre CLIENTE y PRODUCTO, descomponiéndola en dos relaciones 1:N (CLIENTE–FACTURA y FACTURA–PRODUCTO). Además, la venta tiene atributos propios (número de factura, fecha y cantidad comprada) que no pertenecen ni al cliente ni al producto, sino a la transacción en sí, por lo que esa relación debe modelarse como entidad. Su clave primaria compuesta (id_cliente + id_producto, ambas FK) permite registrar cada compra específica con su cantidad correspondiente.
