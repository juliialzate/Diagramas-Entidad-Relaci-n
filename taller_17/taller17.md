# Lectura: Descomposición de Relaciones en Bases de Datos 

## Tema 1. Primera Forma Normal (1FN) 

### Ejercicio 1

#### 1. Explique por qué la tabla no cumple con la Primera Forma Normal (1FN).  

El atributo Idiomas contiene varios valores en una sola celda. Los valores no son atómicos, por lo tanto, la tabla no está en **Primera Forma Normal**.

#### 2. Transforme la tabla para que cumpla con la 1FN.  

|Código |	Estudiante |	Idiomas | 
| :---: | :---: | :---: |
|E001 |	Laura |	Inglés|
|E001 |	Laura |	Francés|
|E002 |	Andrés |	Inglés| 
|E003 |	Sofía |	Alemán |
|E003 |	Sofía |	Italiano|
|E003 |	Sofía |	Portugués| 


#### 3. Identifique cuáles fueron los cambios realizados.

En este caso los cambios que se hicieron fueron, fue que ahora cada celda tiene un solo valor, no como antes donde en la misma celda había muchos valores. Ahora los valores son **atomicos**.

### Ejercicio 2

#### 1. Identifique el problema de diseño.  

El atributo Productos contiene varios valores en una sola celda. Los valores no son atómicos, por lo tanto, la tabla no está en **Primera Forma Normal**.

#### 2. Convierta la tabla a Primera Forma Normal.  

| Factura |	Cliente 	| Productos |
| :---: | :---: | :---: |
|F001| 	Juan |	Mouse|
|F001| 	Juan |	Teclado| 
|F002| 	Ana |	Monitor |
|F003| 	Carlos |	Laptop |
|F003| 	Carlos |	Impresora |
|F003| 	Carlos | Cámara |


#### 3. Explique por qué el nuevo diseño es mejor.  

Ahora cada celda tiene un solo valor, no como antes donde en la misma celda habían muchas valores. Ahora los valores con **atomicos**.

## Tema 2. Dependencias Funcionales 

### Ejercicio 1

#### 1. Identifique las dependencias funcionales existentes.  

La dependencia funcional principal es:

- El **Código_Estudiante** determina el **Nombre**. 
-	El **Código_Estudiante** determina el **Programa**.

Esto ocurre porque cada estudiante tiene un código único que identifica toda su información.


#### 2. Escriba las dependencias utilizando la notación con flechas (→).  

Las dependencias funcionales son:

-	**Código_Estudiante → Nombre**
-	**Código_Estudiante → Programa** 

#### 3. Justifique por qué existen esas dependencias.  

- **Código_Estudiante → Nombre:** Cada código de estudiante es único y corresponde a un solo estudiante, por lo que al conocer el código se conoce exactamente su nombre. 
- **Código_Estudiante → Programa:** Cada estudiante registrado tiene asociado un único programa académico. Por ello, conociendo el código del estudiante se puede determinar el programa al que pertenece.


### Ejercicio 2

#### 1. Determine qué atributos dependen funcionalmente del Código_Producto.  

Las dependencias funcionales son:
-	**Código_Producto → Producto** 
-	**Código_Producto → Precio**
-	**Código_Producto → Proveedor**


#### 2. Indique una dependencia que no se cumpla.  

Una dependencia que no se cumple es:
-	**Proveedor → Producto**

#### 3. Explique el motivo.  

La dependencia **Proveedor → Producto** no es válida porque un mismo proveedor puede suministrar varios productos diferentes.

## Tema 3. Problemas de un Mal Diseño de Bases de Datos 

### Ejercicio 1

#### 1. Identifique la información repetida.  

En la tabla se repiten varios datos:
-	Para el Código 1001, se repiten:
     -	Estudiante: Ana
     -	Carrera: Ingeniería 
-	La materia Bases de Datos aparece en dos registros. 
-	El docente Carlos Gómez aparece en dos registros. 


#### 2. Explique qué problemas pueden presentarse al actualizar la información.  

Al almacenar toda la información en una sola tabla pueden presentarse varios problemas:
-	**Inconsistencia de datos:** Si Ana cambia de carrera, habría que actualizar todas las filas donde aparece. Si se olvida alguna, existirán datos diferentes para el mismo estudiante. 
- **Anomalía de actualización:** Cambiar el nombre de un docente requiere modificar todas las filas donde esté registrado. 
-	**Mayor riesgo de errores:** Al repetir la misma información muchas veces, aumenta la posibilidad de escribir datos diferentes o incorrectos.

#### 3. Mencione al menos tres desventajas de este diseño.  

-	**Redundancia de datos:** La información de estudiantes, carreras y docentes se almacena repetidamente. 
-	**Mayor consumo de espacio:** Al repetir datos innecesariamente, la base de datos ocupa más almacenamiento. 
-	**Anomalías de actualización:**  Es necesario modificar varias filas para actualizar un solo dato. 
-	**Anomalías de inserción:** No se puede registrar un estudiante o un docente si aún no está asociado a una materia. 
- **Anomalías de eliminación:** Si se elimina la última materia de un estudiante, también podría perderse toda su información personal.


### Ejercicio 2

#### 1. Identifique la redundancia existente.  

#### 2. Explique qué ocurriría si cambia la especialidad del médico.  

#### 3. ¿Cómo afectaría esto la consistencia de los datos?  

## Tema 4. Descomposición de Relaciones 

### Ejercicio 1

#### 1. Identifique la redundancia.  

#### 2. Descomponga la tabla en varias relaciones.  

#### 3. Dibuje el esquema relacional resultante.  

### Ejercicio 2

#### 1.¿Qué información se encuentra repetida?  

#### 2. Proponga una descomposición de la tabla.  

#### 3. Explique cómo se relacionan las nuevas tablas.  

#### 4. Indique los beneficios obtenidos con la descomposición.  

## Tema 5. Descomposición sin pérdida y Conservación de Dependencias 

### Ejercicio 1
#### 1. Proponga una descomposición en dos tablas.  

#### 2. Explique si la información puede recuperarse mediante una operación JOIN.  

#### 3. ¿Se trata de una descomposición sin pérdida? Justifique.  

### Ejercicio 2

#### 1. Descomponga la relación en tablas más pequeñas.  

#### 2. Indique si las dependencias funcionales se conservan.  

#### 3. Explique por qué esta descomposición mejora el diseño.  

## Pregunta de reflexión 

### ¿Por qué la normalización y la descomposición son fundamentales para diseñar bases de datos eficientes? Mencione al menos cuatro beneficios y apoye su respuesta con un ejemplo. 

La **normalización** y la **descomposición** son fundamentales porque organizan los datos de forma eficiente y reducen problemas en la base de datos.

**Beneficios:**

1. Eliminan la redundancia de datos.
2. Evitan anomalías de inserción, actualización y eliminación.
3. Mejoran la integridad y consistencia de la información.
4. Facilitan el mantenimiento y la escalabilidad de la base de datos.

**Ejemplo:**
En lugar de guardar el nombre del estudiante en cada registro de materias, se crea una tabla **Estudiante** y otra **Matrícula**. Así, si el estudiante cambia de nombre, solo se actualiza una vez y la información permanece consistente.
