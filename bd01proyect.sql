CREATE TABLE pais(
codPais NUMBER(5) PRIMARY KEY,
nombre VARCHAR2(10) NOT NULL,
costoEnvio NUMBER(12));

CREATE TABLE ciudad(
codCiudad NUMBER(6) PRIMARY KEY,
nombre VARCHAR2(10) NOT NULL);

CREATE TABLE individuo (
usuario VARCHAR2(10) PRIMARY KEY NOT NULL,
nombre VARCHAR2(10) NOT NULL,
cpais NUMBER(5) NOT NULL REFERENCES pais(codPais),
correoElectronico VARCHAR2(22),
contrasena VARCHAR2(22) NOT NULL,
tipo VARCHAR2(3) CHECK(tipo IN('ADM','VEN','DES','CLI')),
tipoID VARCHAR2(3) CHECK(tipoID IN('CC','NIT')),
id NUMBER(14) UNIQUE);

CREATE TABLE Vino (
codVino NUMBER(8) PRIMARY KEY,
calidad NUMBER(2),
pH NUMBER(6,2),
densidad NUMBER(6,2),
sulfato NUMBER(6,2),
cloruro NUMBER(6,2),
azucar NUMBER(6,2),
alcohol NUMBER(6,2));


CREATE TABLE Bodega (
numeroBodega NUMBER(5) PRIMARY KEY,
temperatura NUMBER(5),
humedad NUMBER(5),
capacidad NUMBER(5));

CREATE TABLE Lote (
serial NUMBER(5) PRIMARY KEY,
precio NUMBER(15),
fechaSalida DATE,
estadoComercial VARCHAR2(10) CHECK(estadoComercial IN('VENDIDO','DISPONIBLE','WAIT')) NOT NULL,
fechaProduccion DATE,
cantidadBarriles NUMBER(5),
tamano NUMBER(5),
numeroBodega NUMBER(5) REFERENCES Bodega(numeroBodega),
codVino NUMBER(8) REFERENCES Vino(codVino));

CREATE TABLE Envio (
codPais NUMBER(6) REFERENCES Pais,
codCiudad NUMBER(6) REFERENCES Ciudad,
numEnvio NUMBER(8) PRIMARY KEY NOT NULL,
direccionEntrega VARCHAR2(50) NOT NULL);

CREATE TABLE Pedidos (
codPedido NUMBER(8) PRIMARY KEY,
numEnvio NUMBER(8) REFERENCES Envio(numEnvio),
serial NUMBER(5) REFERENCES Lote(serial),
fechaEntrega DATE,
estadoEntrega VARCHAR2(10) CHECK(estadoEntrega IN('ENTREGADO','CAMINO','SALIENDO')) NOT NULL,
idVendedor NUMBER(14) REFERENCES individuo(ID),
idCliente NUMBER(14) REFERENCES individuo(ID),
idDespachador NUMBER(14) REFERENCES individuo(ID));

CREATE TABLE DetallePago (
codPedido NUMBER(8) REFERENCES Pedidos,
monto NUMBER(12),
fechaPago DATE);




