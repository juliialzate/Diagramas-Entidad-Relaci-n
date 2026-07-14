# DISEÑO FÍSICO Y DESARROLLO DE BASES DE DATOS
## Proyecto: **Adóptame** — Sistema de Gestión de Adopciones Caninas

---

## 5. DISEÑO FÍSICO DE BASES DE DATOS

### 5.1 Conversión del Diseño Lógico al Diseño Físico

El diseño lógico del proyecto **Adóptame** fue elaborado mediante un modelo Entidad-Relación (E-R) que identifica las entidades principales del sistema de adopción canina: `Persona`, `Mascota`, `Rescatista`, `Adoptante`, `Rescate`, `Adopta`, `ValoracionMedica` y `Vacuna`, junto con sus respectivas tablas de catálogo (Sexo, Raza, Rol, Ocupacion, EstadoAdopcion, EstadoProcesoAdopcion, EstadoHabilitacion).

La conversión al diseño físico consistió en transformar esas entidades y relaciones abstractas en estructuras concretas y ejecutables dentro del DBMS seleccionado, definiendo tipos de datos precisos, claves primarias, claves foráneas, restricciones de integridad y mecanismos de almacenamiento.

---

#### 5.1.1 Modelo Relacional al Modelo Computacional (DBMS)

**DBMS utilizado:** MySQL 8.x (gestionado a través de XAMPP / phpMyAdmin)

El modelo relacional se trasladó directamente al motor de base de datos MySQL, usando el lenguaje DDL (Data Definition Language). Cada entidad del diagrama E-R se convirtió en una tabla con las siguientes consideraciones de implementación:

| Entidad lógica | Tabla física | Clave Primaria | Tipo de PK |
|---|---|---|---|
| Sexo | `Sexo` | `id_sexo` | INT AUTO_INCREMENT |
| Raza | `Raza` | `id_raza` | INT AUTO_INCREMENT |
| Rol | `Rol` | `id_rol` | INT AUTO_INCREMENT |
| Ocupación | `Ocupacion` | `id_ocupacion` | INT AUTO_INCREMENT |
| Estado Adopción | `EstadoAdopcion` | `id_estado_adopcion` | INT AUTO_INCREMENT |
| Estado Proceso | `EstadoProcesoAdopcion` | `id_estado_proceso` | INT AUTO_INCREMENT |
| Estado Habilitación | `EstadoHabilitacion` | `id_estado_habilitacion` | INT AUTO_INCREMENT |
| Persona | `Persona` | `id_persona` | INT AUTO_INCREMENT |
| Mascota | `Mascota` | `id_mascota` | INT AUTO_INCREMENT |
| Rescatista | `Rescatista` | `id_persona` (FK) | INT (hereda de Persona) |
| Adoptante | `Adoptante` | `id_persona` (FK) | INT (hereda de Persona) |
| Valoración Médica | `ValoracionMedica` | `id_valoracion` | INT AUTO_INCREMENT |
| Vacuna | `Vacuna` | `id_vacuna` | INT AUTO_INCREMENT |
| Rescate | `Rescate` | `id_rescate` | INT AUTO_INCREMENT |
| Adopción | `Adopta` | `id_adopcion` | INT AUTO_INCREMENT |

**Decisiones de implementación clave:**

- **Herencia de especialización:** `Rescatista` y `Adoptante` son especializaciones de `Persona`. En el modelo físico se implementaron como tablas separadas que comparten la misma PK (`id_persona`) referenciando a la tabla padre `Persona`. Esto permite que una misma persona pueda actuar tanto como rescatista como adoptante.
- **Campo imagen:** La tabla `Mascota` incluye el campo `imagen VARCHAR(255)` para almacenar la ruta relativa del archivo de imagen subido al servidor (directorio `uploads/mascotas/`).
- **Tipos de datos:** Se utilizaron `VARCHAR` para textos cortos, `TEXT` para textos largos (diagnóstico, historia de rescate), `DATE` para fechas, e `INT` para identificadores numéricos.
- **Charset:** La base de datos opera con charset `utf8` para soporte completo de caracteres especiales del español (tildes, ñ).
- **Motor de almacenamiento:** InnoDB, que soporta claves foráneas, transacciones y recuperación ante fallos.

**Fragmento de implementación DDL:**

```sql
-- Tabla Mascota (con campo imagen)
CREATE TABLE Mascota (
    id_mascota         INT PRIMARY KEY AUTO_INCREMENT,
    nombre             VARCHAR(50) NOT NULL,
    id_sexo            INT,
    id_raza            INT,
    fecha_nacimiento   DATE,
    id_estado_adopcion INT,
    imagen             VARCHAR(255) NULL,
    FOREIGN KEY (id_sexo)             REFERENCES Sexo(id_sexo),
    FOREIGN KEY (id_raza)             REFERENCES Raza(id_raza),
    FOREIGN KEY (id_estado_adopcion)  REFERENCES EstadoAdopcion(id_estado_adopcion)
);

-- Tabla Adopta (relación N:M entre Mascota y Persona)
CREATE TABLE Adopta (
    id_adopcion       INT PRIMARY KEY AUTO_INCREMENT,
    id_mascota        INT,
    id_persona        INT,
    fecha_solicitud   DATE NOT NULL,
    fecha_entrega     DATE,
    id_estado_proceso INT,
    FOREIGN KEY (id_mascota)        REFERENCES Mascota(id_mascota),
    FOREIGN KEY (id_persona)        REFERENCES Persona(id_persona),
    FOREIGN KEY (id_estado_proceso) REFERENCES EstadoProcesoAdopcion(id_estado_proceso)
);
```

---

#### 5.1.2 Organización Física de los Datos

##### 5.1.2.1 Almacenamiento (Centralizado o Distribuido)

El sistema **Adóptame** utiliza un modelo de **almacenamiento centralizado**.

Todos los datos residen en un único servidor de base de datos MySQL instalado localmente mediante XAMPP en el servidor de desarrollo. La estructura de almacenamiento es la siguiente:

```
Servidor Local (XAMPP)
├── MySQL Server (Puerto 3307)
│   └── Base de datos: adoptame
│       ├── Tablas de catálogo  (Sexo, Raza, Rol, Ocupacion, ...)
│       ├── Tablas principales  (Persona, Mascota, Rescatista, Adoptante)
│       └── Tablas transaccionales (Rescate, Adopta, ValoracionMedica, Vacuna)
└── Servidor Web Apache (Puerto 80)
    └── Directorio: c:\xampp\htdocs\adoptame\
        └── uploads\mascotas\   <- imágenes almacenadas en filesystem
```

**Justificación del almacenamiento centralizado:**
- El sistema es de escala pequeña/mediana, orientado a una fundación canina local.
- No se requiere replicación geográfica ni alta disponibilidad distribuida.
- Simplifica la administración, los respaldos y el mantenimiento de la integridad referencial.
- El acceso concurrente esperado es bajo, lo que hace innecesaria la distribución.

Los archivos de imágenes de mascotas no se guardan en la base de datos sino en el sistema de archivos (`uploads/mascotas/`), y solo se almacena la ruta en el campo `imagen VARCHAR(255)` de la tabla `Mascota`. Esto optimiza el rendimiento de la BD evitando almacenar datos binarios pesados.

##### 5.1.2.2 Procesamiento (Centralizado o Distribuido)

El procesamiento del proyecto **Adóptame** es **centralizado**, siguiendo una arquitectura de **tres capas** en un único servidor físico:

```
+----------------------------------------------------------+
|                  SERVIDOR ÚNICO (localhost)               |
|                                                          |
|  +--------------+   +--------------+   +-------------+  |
|  |  Capa Web    | → |  Capa Lógica | → |  Capa Datos |  |
|  |   (Apache)   |   |    (PHP)     |   |   (MySQL)   |  |
|  +--------------+   +--------------+   +-------------+  |
|      Puerto 80           PHP 8.x          Puerto 3307   |
+----------------------------------------------------------+
         ^
  Navegador del cliente (PC local o red LAN)
```

**Descripción del flujo de procesamiento:**

1. **Capa de presentación:** El navegador del usuario envía solicitudes HTTP al servidor Apache.
2. **Capa de lógica de negocio:** PHP procesa la solicitud, ejecuta las consultas SQL y aplica la lógica del negocio (validaciones, cálculo de edades con `TIMESTAMPDIFF`, gestión de estados de adopción, subida de imágenes).
3. **Capa de datos:** MySQL recibe las consultas, las ejecuta sobre las tablas y retorna los resultados a PHP.

Todo el procesamiento ocurre en la misma máquina, lo que garantiza latencia mínima entre capas y simplifica la configuración. La conexión entre PHP y MySQL se realiza mediante `mysqli` en el puerto `3307`.

```php
// config.php — Conexión centralizada
$conexion = new mysqli('localhost', 'root', '', 'adoptame', 3307);
$conexion->set_charset("utf8");
```

---

#### 5.1.3 Recursos Hardware, Software, Aplicaciones y BD, Comunicaciones, Ingeniería Web

##### Hardware

| Componente | Especificación para el proyecto |
|---|---|
| Servidor de desarrollo | PC con Windows (mínimo 4 GB RAM, disco HDD/SSD >= 20 GB libres) |
| Almacenamiento BD | Filesystem local — archivos `.ibd` de InnoDB por tabla |
| Almacenamiento imágenes | Directorio local `uploads/mascotas/` (máx. 5 MB por imagen) |
| Acceso de clientes | Red LAN local o acceso directo en `localhost` |

##### Software

| Categoría | Herramienta / Versión |
|---|---|
| Sistema Operativo | Windows (desarrollo) |
| Servidor Web | Apache HTTP Server (incluido en XAMPP) |
| Motor de BD | MySQL 8.x (puerto 3307) |
| Lenguaje backend | PHP 8.x |
| Administrador BD | phpMyAdmin (vía XAMPP) |
| Control de versiones | Git (repositorio `.git` en el proyecto) |
| Editor de código | Visual Studio Code u otro editor compatible |

##### Aplicaciones y Base de Datos

| Módulo de la aplicación | Archivo PHP | Función |
|---|---|---|
| Página principal | `index.php` | Panel de acceso a módulos y consultas |
| Gestión de mascotas | `mascotas.php`, `mascota_agregar.php`, `mascota_editar.php` | CRUD de mascotas con carga de imagen |
| Gestión de adopciones | `adopciones.php`, `vista_adopciones.php` | Registro y seguimiento de adopciones |
| Gestión de adoptantes | `adoptantes.php` | Listado y habilitación de adoptantes |
| Gestión de rescatistas | `rescatistas.php` | Listado de rescatistas y roles |
| Panel administrador | `vista_admin.php` | Estadísticas globales del sistema |
| Panel veterinario | `vista_veterinario.php` | Revisiones médicas y vacunación |
| Panel rescatista | `vista_rescatista.php` | Mascotas rescatadas asignadas |
| Consultas SQL | `consultas.php` | Visualización de las 15 consultas especiales |
| Configuración BD | `config.php` | Parámetros de conexión MySQL |
| Cabecera y pie | `header.php`, `footer.php` | Componentes reutilizables de UI |
| Script SQL | `CodigoSQL/Create_Insert.sql` | DDL + DML completo (tablas, datos, vistas) |
| Consultas SQL | `CodigoSQL/consultas.sql` | 15 vistas de consultas especiales |

**Base de datos:** `adoptame`
- **15 tablas** (7 catálogos + 8 tablas principales/transaccionales)
- **4 vistas de roles** (administrador, veterinario, adopciones, rescatista)
- **15 vistas de consultas** (INNER JOIN, GROUP BY, SUBQUERY, MULTIPLE JOIN, etc.)

##### Comunicaciones

| Protocolo / Tecnología | Uso en el proyecto |
|---|---|
| HTTP / Apache | Comunicación entre navegador y servidor web en puerto 80 |
| TCP/IP (localhost) | Comunicación interna entre Apache (PHP) y MySQL en puerto 3307 |
| mysqli (PHP extension) | Driver de comunicación PHP → MySQL |
| UTF-8 | Charset para transferencia de datos con caracteres especiales |
| LAN (opcional) | Acceso multiusuario en red de área local mediante IP del servidor |

##### Ingeniería Web

El frontend del sistema sigue una arquitectura **MPA (Multi-Page Application)** basada en PHP con renderizado del lado del servidor:

| Tecnología | Rol en el proyecto |
|---|---|
| HTML5 semántico | Estructura de las páginas |
| CSS3 (estilo pastel personalizado) | Diseño visual con paleta rosa/azul pastel |
| Bootstrap (CDN) | Grid responsive y componentes de UI |
| Font Awesome (CDN) | Iconografía del sistema |
| PHP 8.x | Lógica de negocio, consultas y renderizado de vistas |
| JavaScript (básico) | Interactividad del lado del cliente |

La ingeniería web aplica el patrón de **vistas por rol**: cada tipo de usuario (Administrador, Veterinario, Personal de Adopciones, Rescatista, Adoptante) accede a una vista específica que muestra únicamente la información relevante para su función, consultando las vistas SQL definidas en la BD.

---

## 6. DESARROLLO PROYECTO DE BASES DE DATOS

### 6.1 Álgebra Relacional de Consultas MySQL

El sistema **Adóptame** implementa 15 consultas SQL que cubren las principales operaciones del álgebra relacional. A continuación se describe la equivalencia entre el álgebra relacional y la implementación MySQL de cada consulta:

---

#### Consulta 1 — INNER JOIN (Reunión / bowtie)

**Álgebra relacional:**
> π(mascota, sexo, raza, adoptante, telefono, fecha_solicitud, estado)
> σ(Adopta ⋈ Mascota ⋈ Persona ⋈ EstadoProcesoAdopcion ⋈ Sexo ⋈ Raza)

**SQL MySQL:**
```sql
SELECT m.nombre AS mascota, s.descripcion AS sexo, raza.descripcion AS raza,
       p.nombre AS adoptante, p.telefono, a.fecha_solicitud, ep.descripcion AS estado
FROM Adopta a
INNER JOIN Mascota m ON a.id_mascota = m.id_mascota
INNER JOIN Persona p ON a.id_persona = p.id_persona
INNER JOIN EstadoProcesoAdopcion ep ON a.id_estado_proceso = ep.id_estado_proceso
LEFT JOIN Sexo s ON m.id_sexo = s.id_sexo
LEFT JOIN Raza raza ON m.id_raza = raza.id_raza
ORDER BY a.fecha_solicitud DESC;
```
**Descripción:** Muestra todas las adopciones activas vinculando mascota, adoptante y estado del proceso.

---

#### Consulta 2 — GROUP BY (Agregación / γ)

**Álgebra relacional:**
> γ(ea.descripcion; COUNT(*), AVG(edad), COUNT(DISTINCT raza))
> (Mascota ⋈ EstadoAdopcion)

**SQL MySQL:**
```sql
SELECT ea.descripcion AS estado, COUNT(*) AS cantidad,
       AVG(TIMESTAMPDIFF(YEAR, m.fecha_nacimiento, CURDATE())) AS edad_promedio,
       COUNT(DISTINCT m.id_raza) AS razas_diferentes
FROM Mascota m
JOIN EstadoAdopcion ea ON m.id_estado_adopcion = ea.id_estado_adopcion
GROUP BY ea.descripcion
ORDER BY cantidad DESC;
```
**Descripción:** Estadísticas de mascotas agrupadas por su estado de adopción (Disponible, En proceso, Adoptada).

---

#### Consulta 3 — SUBQUERY (Subconsulta / σ con expresión anidada)

**Álgebra relacional:**
> σ(total_revisiones > 2)
> (Mascota ⋈ (γ id_mascota; COUNT(*) ValoracionMedica))

**SQL MySQL:**
```sql
SELECT m.nombre, s.descripcion AS sexo, raza.descripcion AS raza,
       (SELECT COUNT(*) FROM ValoracionMedica WHERE id_mascota = m.id_mascota) AS total_revisiones
FROM Mascota m
LEFT JOIN Sexo s ON m.id_sexo = s.id_sexo
LEFT JOIN Raza raza ON m.id_raza = raza.id_raza
WHERE (SELECT COUNT(*) FROM ValoracionMedica WHERE id_mascota = m.id_mascota) > 2;
```
**Descripción:** Obtiene las mascotas que tienen más de 2 revisiones médicas registradas.

---

#### Consulta 4 — MULTIPLE JOIN (Reunión múltiple)

**Álgebra relacional:**
> π(id_adopcion, mascota, adoptante, rescatista, ubicacion, fechas, estado, sexo, raza)
> (Adopta ⋈ Mascota ⋈ Persona ⋈ Rescate ⋈ Persona ⋈ Sexo ⋈ Raza ⋈ EstadoProcesoAdopcion)

**SQL MySQL:**
```sql
SELECT a.id_adopcion, m.nombre AS mascota, p.nombre AS adoptante,
       pe.nombre AS rescatista, re.ubicacion_rescate, re.fecha_rescate,
       a.fecha_solicitud, a.fecha_entrega, ep.descripcion AS estado_proceso,
       s.descripcion AS sexo, raza.descripcion AS raza
FROM Adopta a
JOIN Mascota m ON a.id_mascota = m.id_mascota
JOIN Persona p ON a.id_persona = p.id_persona
LEFT JOIN Rescate re ON m.id_mascota = re.id_mascota
LEFT JOIN Persona pe ON re.id_persona = pe.id_persona
LEFT JOIN Sexo s ON m.id_sexo = s.id_sexo
LEFT JOIN Raza raza ON m.id_raza = raza.id_raza
LEFT JOIN EstadoProcesoAdopcion ep ON a.id_estado_proceso = ep.id_estado_proceso
ORDER BY a.fecha_solicitud DESC;
```
**Descripción:** Vista completa de adopciones que integra datos del rescate original, el adoptante y el estado del proceso.

---

#### Consulta 5 — REUNIÓN NATURAL (NATURAL JOIN)

**Álgebra relacional:**
> Persona ⋈ Adoptante ⋈ Rescatista ⋈ Ocupacion ⋈ Rol

**SQL MySQL:**
```sql
SELECT p.id_persona, p.nombre, p.telefono, p.correo_electronico,
       CASE WHEN a.id_persona IS NOT NULL THEN 'Adoptante'
            WHEN re.id_persona IS NOT NULL THEN 'Rescatista'
            ELSE 'Sin rol' END AS rol,
       a.direccion, o.descripcion AS ocupacion, ro.descripcion AS rol_rescatista
FROM Persona p
NATURAL LEFT JOIN Adoptante a
NATURAL LEFT JOIN Rescatista re
LEFT JOIN Ocupacion o ON a.id_ocupacion = o.id_ocupacion
LEFT JOIN Rol ro ON re.id_rol = ro.id_rol;
```
**Descripción:** Une Persona con sus posibles roles (Adoptante / Rescatista) usando atributos comunes del esquema.

---

#### Consulta 6 — PRODUCTO CARTESIANO (×)

**Álgebra relacional:**
> σ(estado = 'Disponible')(Mascota) × Persona

**SQL MySQL:**
```sql
SELECT m.nombre AS mascota, m.id_mascota, p.nombre AS adoptante, p.id_persona
FROM Mascota m, Persona p
WHERE m.id_estado_adopcion = 1
LIMIT 20;
```
**Descripción:** Genera todas las combinaciones posibles entre mascotas disponibles y personas, simulando el producto cartesiano controlado.

---

#### Consulta 7 — DIFERENCIA (−)

**Álgebra relacional:**
> Mascota − π(id_mascota)(Adopta)

**SQL MySQL:**
```sql
SELECT m.id_mascota, m.nombre, s.descripcion AS sexo,
       raza.descripcion AS raza, ea.descripcion AS estado
FROM Mascota m
LEFT JOIN Adopta a ON m.id_mascota = a.id_mascota
LEFT JOIN Sexo s ON m.id_sexo = s.id_sexo
LEFT JOIN Raza raza ON m.id_raza = raza.id_raza
LEFT JOIN EstadoAdopcion ea ON m.id_estado_adopcion = ea.id_estado_adopcion
WHERE a.id_mascota IS NULL;
```
**Descripción:** Identifica mascotas que nunca han tenido una solicitud de adopción registrada.

---

#### Consulta 8 — INTERSECT (∩)

**Álgebra relacional:**
> π(id_mascota)(Rescate) ∩ π(id_mascota)(Adopta)

**SQL MySQL:**
```sql
SELECT DISTINCT m.id_mascota, m.nombre, s.descripcion AS sexo, raza.descripcion AS raza
FROM Mascota m
JOIN Rescate re ON m.id_mascota = re.id_mascota
JOIN Adopta a ON m.id_mascota = a.id_mascota
LEFT JOIN Sexo s ON m.id_sexo = s.id_sexo
LEFT JOIN Raza raza ON m.id_raza = raza.id_raza;
```
**Descripción:** Mascotas que han pasado por ambos procesos: fueron rescatadas Y tienen una adopción registrada.

---

#### Consulta 9 — PROYECCIÓN GENERALIZADA (π extendida)

**Álgebra relacional:**
> π(id, nombre, sexo, raza, edad_anios, edad_meses, dia, mes, anio, total_adopciones, total_revisiones, total_rescates)
> (Mascota ⋈ Sexo ⋈ Raza ⋈ EstadoAdopcion)

**SQL MySQL:**
```sql
SELECT m.id_mascota, m.nombre, s.descripcion AS sexo, raza.descripcion AS raza,
       m.fecha_nacimiento,
       TIMESTAMPDIFF(YEAR, m.fecha_nacimiento, CURDATE()) AS edad_anios,
       TIMESTAMPDIFF(MONTH, m.fecha_nacimiento, CURDATE()) AS edad_meses,
       DAY(m.fecha_nacimiento) AS dia_nacimiento,
       MONTH(m.fecha_nacimiento) AS mes_nacimiento,
       YEAR(m.fecha_nacimiento) AS anio_nacimiento,
       ea.descripcion AS estado,
       (SELECT COUNT(*) FROM Adopta WHERE id_mascota = m.id_mascota) AS total_adopciones,
       (SELECT COUNT(*) FROM ValoracionMedica WHERE id_mascota = m.id_mascota) AS total_revisiones,
       (SELECT COUNT(*) FROM Rescate WHERE id_mascota = m.id_mascota) AS total_rescates
FROM Mascota m
LEFT JOIN Sexo s ON m.id_sexo = s.id_sexo
LEFT JOIN Raza raza ON m.id_raza = raza.id_raza
LEFT JOIN EstadoAdopcion ea ON m.id_estado_adopcion = ea.id_estado_adopcion;
```
**Descripción:** Proyección ampliada con campos calculados: edad en años/meses, y conteo de actividades por mascota.

---

#### Consulta 10 — ASIGNACIÓN / RENOMBRAMIENTO (ρ)

**Álgebra relacional:**
> ρ("Nombre Adoptante" ← nombre, "Nombre Mascota" ← nombre, ...)
> (Adopta ⋈ Persona ⋈ Mascota ⋈ Sexo ⋈ Raza ⋈ EstadoAdopcion ⋈ EstadoProcesoAdopcion)

**SQL MySQL:**
```sql
SELECT p.nombre AS "Nombre Adoptante", p.telefono AS "Telefono Adoptante",
       m.nombre AS "Nombre Mascota", s.descripcion AS "Sexo Mascota",
       raza.descripcion AS "Raza Mascota", ea.descripcion AS "Estado Mascota",
       a.fecha_solicitud AS "Fecha Solicitud", ep.descripcion AS "Estado Proceso"
FROM Adopta a
JOIN Persona p ON a.id_persona = p.id_persona
JOIN Mascota m ON a.id_mascota = m.id_mascota
LEFT JOIN Sexo s ON m.id_sexo = s.id_sexo
LEFT JOIN Raza raza ON m.id_raza = raza.id_raza
LEFT JOIN EstadoAdopcion ea ON m.id_estado_adopcion = ea.id_estado_adopcion
LEFT JOIN EstadoProcesoAdopcion ep ON a.id_estado_proceso = ep.id_estado_proceso;
```
**Descripción:** Renombra los atributos del resultado para mayor claridad en informes y reportes.

---

#### Consulta 11 — DIVISIÓN (÷)

**Álgebra relacional:**
> Mascota ÷ Ocupacion (a través de Adopta ⋈ Adoptante)
> → mascotas con adoptantes de al menos 2 ocupaciones distintas

**SQL MySQL:**
```sql
SELECT m.id_mascota, m.nombre,
       COUNT(DISTINCT a.id_persona) AS total_adoptantes,
       COUNT(DISTINCT o.id_ocupacion) AS ocupaciones_diferentes
FROM Mascota m
JOIN Adopta a ON m.id_mascota = a.id_mascota
JOIN Adoptante ad ON a.id_persona = ad.id_persona
JOIN Ocupacion o ON ad.id_ocupacion = o.id_ocupacion
GROUP BY m.id_mascota, m.nombre
HAVING COUNT(DISTINCT o.id_ocupacion) >= 2;
```
**Descripción:** Identifica mascotas que han tenido interés de adoptantes de múltiples ocupaciones profesionales.

---

#### Consultas 12–15 — Operaciones de Control (DCL/DDL)

| # | Operación | Descripción |
|---|---|---|
| 12 | REVOKE (simulado) | Reporte estático de permisos por tipo de usuario del sistema |
| 13 | ALTER (historial) | Historial de cambios de estado de adopción por mascota (CASE WHEN) |
| 14 | GRANT (resumen) | Resumen de accesos y privilegios especiales agrupados por rol |
| 15 | DROP (incompletos) | Detección de mascotas con campos NULL o sin imagen asignada |

---

### 6.2 Tablas, Relaciones, Consultas, Informes

#### Tablas del sistema

El sistema cuenta con **15 tablas** organizadas en tres categorías:

**Tablas de catálogo (7):**

| Tabla | Columnas principales | Registros de prueba |
|---|---|---|
| `Sexo` | id_sexo, descripcion | 10 (Macho, Hembra, Esterilizado/a) |
| `Raza` | id_raza, descripcion | 10 (Labrador, Pastor Alemán, Golden, etc.) |
| `Rol` | id_rol, descripcion | 10 (Voluntario, Veterinario, Coordinador, etc.) |
| `Ocupacion` | id_ocupacion, descripcion | 10 (Ingeniero, Médico, Docente, etc.) |
| `EstadoAdopcion` | id_estado_adopcion, descripcion | 10 (Disponible, En proceso, Adoptada) |
| `EstadoProcesoAdopcion` | id_estado_proceso, descripcion | 10 (Solicitada, En evaluación, Aprobada, etc.) |
| `EstadoHabilitacion` | id_estado_habilitacion, descripcion | 10 (Habilitado, No habilitado, En evaluación) |

**Tablas principales (4):**

| Tabla | Columnas principales | Registros de prueba |
|---|---|---|
| `Persona` | id_persona, nombre, telefono, correo_electronico | 10 |
| `Mascota` | id_mascota, nombre, id_sexo, id_raza, fecha_nacimiento, id_estado_adopcion, imagen | 10 |
| `Rescatista` | id_persona (PK+FK), id_rol | 10 |
| `Adoptante` | id_persona (PK+FK), direccion, id_ocupacion, id_estado_habilitacion | 10 |

**Tablas transaccionales (4):**

| Tabla | Columnas principales | Registros de prueba |
|---|---|---|
| `ValoracionMedica` | id_valoracion, id_mascota, fecha_revision, diagnostico, tratamiento, observaciones | 10 |
| `Vacuna` | id_vacuna, id_valoracion, nombre_vacuna, dosis, fecha_aplicacion | 10 |
| `Rescate` | id_rescate, id_mascota, id_persona, fecha_rescate, ubicacion_rescate, historia_rescate | 10 |
| `Adopta` | id_adopcion, id_mascota, id_persona, fecha_solicitud, fecha_entrega, id_estado_proceso | 10 |

#### Relaciones principales

```
Persona         ────────  Rescatista      (1:1, especialización — hereda id_persona)
Persona         ────────  Adoptante       (1:1, especialización — hereda id_persona)
Persona         ────────  Rescate         (1:N, un rescatista rescata muchas mascotas)
Persona         ────────  Adopta          (1:N, un adoptante solicita varias adopciones)
Mascota         ────────  Rescate         (1:N, historial de rescates por mascota)
Mascota         ────────  Adopta          (1:N, varias solicitudes por mascota)
Mascota         ────────  ValoracionMedica (1:N, múltiples revisiones médicas)
ValoracionMedica ───────  Vacuna          (1:N, una revisión registra múltiples vacunas)
Mascota         ────────  Sexo            (N:1, catálogo)
Mascota         ────────  Raza            (N:1, catálogo)
Mascota         ────────  EstadoAdopcion  (N:1, catálogo)
Rescatista      ────────  Rol             (N:1, catálogo)
Adoptante       ────────  Ocupacion       (N:1, catálogo)
Adoptante       ────────  EstadoHabilitacion (N:1, catálogo)
Adopta          ────────  EstadoProcesoAdopcion (N:1, catálogo)
```

#### Vistas — Informes predefinidos

El sistema define **19 vistas SQL** que actúan como informes reutilizables:

**Vistas de rol (4):**

| Vista | Público objetivo | Datos mostrados |
|---|---|---|
| `vista_administrador` | Administrador | Totales globales: mascotas, adoptantes, rescatistas, adopciones con subtotales por estado |
| `vista_veterinario` | Veterinario | Mascotas con última revisión médica, diagnóstico, tratamiento, vacunas y edad calculada |
| `vista_adopciones` | Personal adopciones | Adopciones con mascota, adoptante, contacto, estado y días en proceso |
| `vista_rescatista` | Rescatista | Mascotas rescatadas con historial, rescatista asignado y total de revisiones médicas |

**Vistas de consultas especiales (15):**

`consulta_inner_join`, `consulta_group_by`, `consulta_subquery`, `consulta_multiple_join`,
`consulta_reunion_natural`, `consulta_producto_cartesiano`, `consulta_diferencia`,
`consulta_intersect`, `consulta_proyeccion`, `consulta_asignacion`, `consulta_division`,
`consulta_revoke`, `consulta_alter`, `consulta_grant`, `consulta_drop`.

---

### 6.3 Prototipo Funcional de la Base de Datos

El prototipo funcional del sistema **Adóptame** está completamente implementado y operativo. Se describe a continuación cada componente funcional:

#### Estado de implementación

| Componente | Estado | Detalle |
|---|---|---|
| Esquema de BD completo | IMPLEMENTADO | 15 tablas con FK, constraints e índices |
| Datos de prueba | IMPLEMENTADO | 10 registros por tabla (160+ registros totales) |
| Vistas por rol | IMPLEMENTADO | 4 vistas activas (admin, veterinario, adopciones, rescatista) |
| Consultas especiales | IMPLEMENTADO | 15 vistas SQL cubriendo álgebra relacional completa |
| CRUD Mascotas | IMPLEMENTADO | Alta, edición, eliminación y listado con imagen |
| CRUD Adopciones | IMPLEMENTADO | Registro y seguimiento de solicitudes de adopción |
| Listado Adoptantes | IMPLEMENTADO | Con estado de habilitación visible |
| Listado Rescatistas | IMPLEMENTADO | Con rol asignado |
| Subida de imágenes | IMPLEMENTADO | JPG/PNG/GIF/WEBP, máximo 5 MB por archivo |
| Panel administrador | IMPLEMENTADO | Estadísticas globales en tiempo real |
| Panel veterinario | IMPLEMENTADO | Historial médico y vacunación por mascota |
| Panel rescatista | IMPLEMENTADO | Mascotas rescatadas y total de revisiones |
| Panel adopciones | IMPLEMENTADO | Estado y días transcurridos de cada adopción |

#### Estructura del prototipo

```
adoptame/
├── config.php                  <- Configuracion y conexion MySQL (puerto 3307)
├── index.php                   <- Portal principal con acceso a todos los modulos
├── header.php                  <- Cabecera reutilizable (Bootstrap + Font Awesome)
├── footer.php                  <- Pie de pagina
├── mascotas.php                <- Listado de mascotas con imagenes
├── mascota_agregar.php         <- Formulario para añadir mascota
├── mascota_editar.php          <- Formulario para editar mascota existente
├── adopciones.php              <- Gestion de adopciones
├── adoptantes.php              <- Gestion de adoptantes
├── rescatistas.php             <- Gestion de rescatistas
├── consultas.php               <- Visualizador de 15 consultas SQL especiales
├── vista_admin.php             <- Panel administrador (estadisticas globales)
├── vista_adopciones.php        <- Panel personal de adopciones
├── vista_veterinario.php       <- Panel veterinario (revisiones medicas)
├── vista_rescatista.php        <- Panel rescatista
├── uploads/mascotas/           <- Directorio de imagenes de mascotas
└── CodigoSQL/
    ├── Create_Insert.sql       <- DDL completo + DML (datos) + Vistas de rol
    └── consultas.sql           <- 15 vistas de consultas especiales
```

#### Instrucciones de despliegue del prototipo

1. Instalar **XAMPP** y activar los módulos Apache y MySQL.
2. Copiar la carpeta `adoptame/` en `c:\xampp\htdocs\`.
3. Acceder a **phpMyAdmin** (`http://localhost/phpmyadmin`) y crear la base de datos `adoptame`.
4. Importar y ejecutar `CodigoSQL/Create_Insert.sql` para crear las tablas, insertar datos y crear las vistas de rol.
5. Importar y ejecutar `CodigoSQL/consultas.sql` para crear las 15 vistas de consultas especiales.
6. Navegar a: `http://localhost/adoptame/`

#### URLs de acceso al sistema

| Módulo | URL |
|---|---|
| Inicio / Panel principal | `http://localhost/adoptame/index.php` |
| Mascotas | `http://localhost/adoptame/mascotas.php` |
| Adopciones | `http://localhost/adoptame/adopciones.php` |
| Adoptantes | `http://localhost/adoptame/adoptantes.php` |
| Rescatistas | `http://localhost/adoptame/rescatistas.php` |
| Vista Administrador | `http://localhost/adoptame/vista_admin.php` |
| Vista Veterinario | `http://localhost/adoptame/vista_veterinario.php` |
| Vista Rescatista | `http://localhost/adoptame/vista_rescatista.php` |
| Vista Adopciones | `http://localhost/adoptame/vista_adopciones.php` |
| Consultas SQL (1-15) | `http://localhost/adoptame/consultas.php?vista=consulta_inner_join` |

---

*Documento generado para el proyecto Adoptame — Sistema de Gestion de Adopciones Caninas*
*Base de datos: `adoptame` | Motor: MySQL 8.x | Backend: PHP 8.x | Servidor: Apache/XAMPP*
