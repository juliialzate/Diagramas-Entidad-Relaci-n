CREATE TABLE BANCO 
    ( 
     codigo_banco            INTEGER  NOT NULL , 
     nombre                  VARCHAR (4000) , 
     tasa_interes            DOUBLE , 
     comision_administracion DOUBLE , 
     PAIS_codigo_pais        VARCHAR (4000) 
    ) 
;

ALTER TABLE BANCO 
    ADD CONSTRAINT BANCO_PK PRIMARY KEY ( codigo_banco ) ;

CREATE TABLE CARACTER_EMPRESA 
    ( 
     codigo_caracter INTEGER  NOT NULL 
    ) 
;

ALTER TABLE CARACTER_EMPRESA 
    ADD CONSTRAINT CARACTER_EMPRESA_PK PRIMARY KEY ( codigo_caracter ) ;

CREATE TABLE CREDITO 
    ( 
     codigo_prestamo        INTEGER  NOT NULL , 
     anios_plazo            INTEGER , 
     BANCO_codigo_banco     INTEGER  NOT NULL , 
     EMPRESA_codigo_empresa INTEGER  NOT NULL 
    ) 
;

ALTER TABLE CREDITO 
    ADD CONSTRAINT CREDITO_PK PRIMARY KEY ( codigo_prestamo ) ;

CREATE TABLE CREDITO_MONEDA 
    ( 
     CREDITO_codigo_prestamo INTEGER  NOT NULL , 
     MONEDA_codigo_moneda    INTEGER  NOT NULL , 
     monto                   DOUBLE 
    ) 
;

ALTER TABLE CREDITO_MONEDA 
    ADD CONSTRAINT CREDITO_MONEDA_PK PRIMARY KEY ( CREDITO_codigo_prestamo, MONEDA_codigo_moneda ) ;

CREATE TABLE EMPRESA 
    ( 
     codigo_empresa                   INTEGER  NOT NULL , 
     nombre                           VARCHAR (4000) , 
--  ERROR: Column name length exceeds maximum allowed length(30) 
     CARACTER_EMPRESA_codigo INTEGER , 
     GRUPO_EMPRESA_codigo_grupo       INTEGER 
    ) 
;

ALTER TABLE EMPRESA 
    ADD CONSTRAINT EMPRESA_PK PRIMARY KEY ( codigo_empresa ) ;

CREATE TABLE GRUPO_EMPRESA 
    ( 
     codigo_grupo INTEGER  NOT NULL , 
     grupo        VARCHAR (4000) 
    ) 
;

ALTER TABLE GRUPO_EMPRESA 
    ADD CONSTRAINT GRUPO_EMPRESA_PK PRIMARY KEY ( codigo_grupo ) ;

CREATE TABLE MONEDA 
    ( 
     codigo_moneda INTEGER  NOT NULL , 
     nombre_moneda VARCHAR (4000)  
--  ERROR: Datatype UNKNOWN is not allowed 
	
    ) 
;

ALTER TABLE MONEDA 
    ADD CONSTRAINT MONEDA_PK PRIMARY KEY ( codigo_moneda ) ;

CREATE TABLE MONEDA_PAIS 
    ( 
     MONEDA_codigo_moneda INTEGER  NOT NULL , 
     PAIS_codigo_pais     VARCHAR (4000)  NOT NULL , 
     tasa_cambio          DOUBLE , 
     porcentaje_cambio    DOUBLE 
    ) 
;

ALTER TABLE MONEDA_PAIS 
    ADD CONSTRAINT MONEDA_PAIS_PK PRIMARY KEY ( MONEDA_codigo_moneda, PAIS_codigo_pais ) ;

CREATE TABLE PAIS 
    ( 
     codigo_pais VARCHAR (10)  NOT NULL , 
     pais        VARCHAR (4000) 
    ) 
;

ALTER TABLE PAIS 
    ADD CONSTRAINT PAIS_PK PRIMARY KEY ( codigo_pais ) ;

ALTER TABLE BANCO 
    ADD CONSTRAINT BANCO_PAIS_FK FOREIGN KEY 
    ( 
     PAIS_codigo_pais
    ) 
    REFERENCES PAIS 
    ( 
     codigo_pais
    ) 
;

ALTER TABLE CREDITO 
    ADD CONSTRAINT CREDITO_BANCO_FK FOREIGN KEY 
    ( 
     BANCO_codigo_banco
    ) 
    REFERENCES BANCO 
    ( 
     codigo_banco
    ) 
;

ALTER TABLE CREDITO 
    ADD CONSTRAINT CREDITO_EMPRESA_FK FOREIGN KEY 
    ( 
     EMPRESA_codigo_empresa
    ) 
    REFERENCES EMPRESA 
    ( 
     codigo_empresa
    ) 
;

ALTER TABLE CREDITO_MONEDA 
    ADD CONSTRAINT CREDITO_MONEDA_CREDITO_FK FOREIGN KEY 
    ( 
     CREDITO_codigo_prestamo
    ) 
    REFERENCES CREDITO 
    ( 
     codigo_prestamo
    ) 
;

ALTER TABLE CREDITO_MONEDA 
    ADD CONSTRAINT CREDITO_MONEDA_MONEDA_FK FOREIGN KEY 
    ( 
     MONEDA_codigo_moneda
    ) 
    REFERENCES MONEDA 
    ( 
     codigo_moneda
    ) 
;

ALTER TABLE EMPRESA 
    ADD CONSTRAINT EMPRESA_CARACTER_EMPRESA_FK FOREIGN KEY 
    ( 
     CARACTER_EMPRESA_codigo
    ) 
    REFERENCES CARACTER_EMPRESA 
    ( 
     codigo_caracter
    ) 
;

ALTER TABLE EMPRESA 
    ADD CONSTRAINT EMPRESA_GRUPO_EMPRESA_FK FOREIGN KEY 
    ( 
     GRUPO_EMPRESA_codigo_grupo
    ) 
    REFERENCES GRUPO_EMPRESA 
    ( 
     codigo_grupo
    ) 
;

ALTER TABLE MONEDA_PAIS 
    ADD CONSTRAINT MONEDA_PAIS_MONEDA_FK FOREIGN KEY 
    ( 
     MONEDA_codigo_moneda
    ) 
    REFERENCES MONEDA 
    ( 
     codigo_moneda
    ) 
;

ALTER TABLE MONEDA_PAIS 
    ADD CONSTRAINT MONEDA_PAIS_PAIS_FK FOREIGN KEY 
    ( 
     PAIS_codigo_pais
    ) 
    REFERENCES PAIS 
    ( 
     codigo_pais
    ) 
;
