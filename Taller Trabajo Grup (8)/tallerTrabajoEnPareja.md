# Taller Trabajo en pareja 

## Actividad

### Segundo punto

```mermaid
erDiagram
    AUTOR {
        string nombre PK
        string direccion PK
    }

    EDITOR {
        string nombre PK
        string direccion
        string telefono
        string URL
    }

    LIBRO {
        string ISBN PK
        string titulo
        int anio
        float precio
        string nombre_autor FK
        string direccion_autor FK
        string nombre_editor FK
    }

    CLIENTE {
        string nombre PK
        string direccion PK
        string direccion_correo_electronico
        string telefono
    }

    CESTA_DE_LA_COMPRA {
        string IDcesta PK
        string nombre_cliente FK
        string direccion_cliente FK
    }

    ALMACEN {
        string codigo PK
        string direccion
        string telefono
    }

    CONTIENE {
        string ISBN_libro PK,FK
        string IDcesta PK,FK
        int numero
    }

    ALMACENA {
        string ISBN_libro PK,FK
        string codigo_almacen PK,FK
        int numero
    }

    AUTOR ||--o{ LIBRO : "escrito-por"
    EDITOR ||--o{ LIBRO : "editado-por"
    CLIENTE ||--o{ CESTA_DE_LA_COMPRA : "cesta-de"
    LIBRO ||--o{ CONTIENE : ""
    CESTA_DE_LA_COMPRA ||--o{ CONTIENE : ""
    LIBRO ||--o{ ALMACENA : ""
    ALMACEN ||--o{ ALMACENA : ""
```

## Ejercicio propuesto


### Punto a 
![puntoA](puntoA.png)
```mermaid
erDiagram
    Fabricante {
        int id_fabricante PK
        string nombre
        string pais
        string sitio_web
    }

    Producto {
        int codigo PK
        string nombre
        string tipo
        decimal precio
        int cantidad_stock
        int id_fabricante FK
    }

    Cliente {
        int id_cliente PK
        string nombre
    }

    OrdenDeCompra {
        int numero PK
        date fecha
        string estado
        int id_cliente FK
    }

    DetalleOrden {
        int numero FK
        int codigo FK
        int cantidad
    }




    Fabricante ||--|{ Producto : fabrica
    Cliente ||--|{ OrdenDeCompra : realiza
    OrdenDeCompra ||--|{ DetalleOrden : contiene
    Producto ||--|{ DetalleOrden : aparece
```



### Punto b
![puntoB](puntoB.png)
```mermaid
erDiagram
    Fabricante {
        int id_fabricante PK
        string nombre
        string pais
        string sitio_web
    }

    Producto {
        int codigo PK
        string nombre
        string tipo
        decimal precio
        int cantidad_stock
        int id_fabricante FK
        string caracteristica_dispositivo
    }

    Cliente {
        int id_cliente PK
        string nombre
    }

    OrdenDeCompra {
        int numero PK
        date fecha
        string estado
        int id_cliente FK
    }

    DetalleOrden {
        int numero FK
        int codigo FK
        int cantidad
    }




    Fabricante ||--|{ Producto : fabrica
    Cliente ||--|{ OrdenDeCompra : realiza
    OrdenDeCompra ||--|{ DetalleOrden : contiene
    Producto ||--|{ DetalleOrden : aparece
```


### Punto c
![puntoC](puntoC.png)
```mermaid

erDiagram
    CLIENTE ||--o{ ORDEN_COMPRA : "realiza"
    ORDEN_COMPRA ||--o{ DETALLE_ORDEN : "contiene"
    PRODUCTO ||--o{ DETALLE_ORDEN : "incluido_en"
    FABRICANTE ||--o{ PRODUCTO : "fabrica"
    PRODUCTO ||--o| COMPUTADORES : "es_un"
    PRODUCTO ||--o| TABLETAS : "es_un"
    PRODUCTO ||--o| TELEFONOS_INTELIGENTES : "es_un"
    PRODUCTO ||--o| RELOJES : "es_un"

    CLIENTE {
        int id_cliente PK
        string nombre
    }

    ORDEN_COMPRA {
        int id_orden_compra PK
        date fecha
        string estado
        int id_cliente FK
    }

    DETALLE_ORDEN {
        int numero PK
        string codigo
        int cantidad
        int id_orden_compra FK
        int id_producto FK
    }

    FABRICANTE {
        int id_fabricante PK
        string nombre
        string pais
        string sitio_web
    }

    PRODUCTO {
        int id_producto PK
        string nombre
        string dispositivo
        string infoProducto
        decimal precio
        int cantidad_stock
        int id_fabricante FK
    }

    COMPUTADORES {
        int id_producto PK
        string tamano_pantalla
        string ram
        string tipo
    }

    TABLETAS {
        int id_producto PK
        boolean lapiz_tactil
    }

    TELEFONOS_INTELIGENTES {
        int id_producto PK
        string sim
    }

    RELOJES {
        int id_producto PK
        boolean resistencia_agua
        boolean tiene_gps
        string compatibilidad
    }

```
