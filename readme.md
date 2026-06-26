#Biblioteca

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
    
