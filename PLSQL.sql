--1--luis
-----cuando sea modificado algum parametro de la tabla bodega----
ALTER TABLE BODEGA ADD  usuario VARCHAR2(10);
ALTER TABLE BODEGA ADD tsModific DATE;
ALTER TABLE BODEGA MODIFY tsModific VARCHAR2(50);

CREATE OR REPLACE TRIGGER PUNTOUNO
before INSERT OR UPDATE ON BODEGA
FOR EACH ROW
BEGIN
    SELECT USER INTO :NEW.usuario FROM DUAL;
    SELECT CURRENT_TIMESTAMP INTO :NEW.tsModific FROM DUAL;
END;

select * from bodega;

update bodega set temperatura=temperatura+1 where numerobodega=1;

DROP TRIGGER PUNTOUNO; 



----


--2--natalia

-------CUANDO UN LOTE ENTRE A PEDIDOS, DEBE CAMBIAR SU ESTADO COMERCIAL-----
CREATE OR REPLACE TRIGGER ActPedidos
after INSERT ON Pedidos
FOR EACH ROW
BEGIN
UPDATE Lote SET estadoComercial = 'VENDIDO' WHERE lote.serial=:NEW.serial;
END;

--select * from lote where serial=1111;

---1111----
--INSERT INTO pedidos VALUES (002, 01, 1111, '01-11-2020', 'ENTREGADO', 12345, 4444, 5555);


--3--natalia
---when INSERT LOTE IN LOTE ,BEFORE COMPROBAR QUE HAY ESPACIO SUFICIENTE EN LA BODEGA
CREATE OR REPLACE TRIGGER trValor
BEFORE INSERT ON Lote FOR EACH ROW
DECLARE 
capacitie NUMBER(10);
ocuped NUMBER(10);
DISPO NUMBER(10);
BEGIN
    SELECT capacidad into  capacitie from bodega where bodega.numerobodega=:new.numerobodega;
    select sum(lote.cantidadBarriles) into ocuped from lote where lote.numerobodega=:new.numerobodega;
    dispo:=capacitie- ocuped;
    DBMS_OUTPUT.PUT_LINE('1ST IN:');
    IF :NEW.cantidadBarriles+ocuped > capacitie THEN
        DBMS_OUTPUT.PUT_LINE('NOPO:');
        Raise_application_error(-20100, 'El lote a ingresar tiene un tamaño de ('||:NEW.cantidadBarriles||') barriles, superior al espacio disponible en la bodega
        ('||dispo ||') barriles');
    ELSE
        DBMS_OUTPUT.PUT_LINE('SIPO:');
    END IF;
END;

INSERT INTO lote VALUES (1212, 50000000, '12-03-2022', 'VENDIDO', '28-01-2015', 5000, 300, 03, 0002);
Delete lote where lote.serial=1212;

--4--luis
---RECBE SALUDO Y CUERPO Y UN AÑO, LA SALIDA CONTIENE (NOMBRE,CORREO,CONCATENA SALUDO+ ---NOMBRE---+CUERPO) PARA CLIENTES CON COMPRAS EN  ESE AÑO
CREATE OR REPLACE TYPE t_record1 AS OBJECT
(Nombre VARCHAR2(10),correo VARCHAR2(22) ,Msaje VARCHAR2(100));

CREATE OR REPLACE TYPE t_table1 AS TABLE OF t_record1;

CREATE OR REPLACE FUNCTION punto4(SALUDO CHAR,cuerpo char, ano number)
RETURN t_table1 AS
v_ret t_table1;
BEGIN
v_ret := t_table1(); -- constructor
FOR rec_ape IN (
SELECT individuo.Nombre as name,individuo.correoelectronico as correo
FROM (pedidos natural join detallepago) inner join individuo on individuo.id=pedidos.idcliente
WHERE EXTRACT(year FROM detallepago.fechaPago)= ano)
LOOP
v_ret.extend;
v_ret(v_ret.count):= t_record1(rec_ape.name,rec_ape.correo,concat(concat(SALUDO,rec_ape.name),cuerpo));
END LOOP;
RETURN v_ret;
END;


SELECT * FROM table(punto4('Saludos, estimado señor ','. Nos gustaria saber, ¿que haces?',2020));

--5--ayala
--Realizar una función que aumente el precio de los lotes disponibles,
-- de acuerdo a su cantidad de barriles. los 4 lotes mas pequeños aumentan
--- un 5% en precio, los 5-7: 7% , 7-end: 10%--

CREATE OR REPLACE PROCEDURE Aumento AS 
contador NUMBER(6);
CURSOR precioc(serial_lote NUMBER) IS SELECT lote.*
FROM Lote
WHERE serial = serial_lote
FOR UPDATE OF lote.precio;

BEGIN
contador := 1;
FOR i IN (SELECT serial, cantidadBarriles
FROM Lote where estadocomercial='DISPONIBLE'
GROUP BY serial, cantidadBarriles
ORDER BY cantidadBarriles)
        LOOP
            FOR j IN precioc(i.serial) LOOP
                CASE
                    WHEN contador < 5 THEN            
                        update lote set precio= precio * 1.05 where current of precioc;
                    WHEN contador >= 5 AND contador <= 7 THEN
                        update lote set precio= precio * 1.07 where current of precioc;
                    ELSE
                        update lote set precio= precio * 1.1 where current of precioc;
                END CASE;
            END LOOP;
            contador := contador + 1;            
        END LOOP;
END;

select serial, cantidadBarriles, precio from lote 
GROUP BY serial, cantidadBarriles, precio
ORDER BY cantidadBarriles;

commit;

begin
Aumento();
end;
rollback;
--6--luis, actualizar
---- se necesita una funcion la cual  cambie  de ubicacion TODOS los vinos del tipo n desde la bodega (a) a la bodega (b),
-----se tiene que hacer la transaccion update uno a uno ya que la bodega lote tiene un triger implementado para cuando la bpdega esta llena
CREATE OR REPLACE PROCEDURE  punto6
(bodega_a number,bodega_b number,cvino number)
as
begin
for pers in(
    select serial as serte
    from lote where lote.numerobodega=bodega_a)
    
LOOP
SAVEPOINT cero;
    UPDATE lote
    SET numerobodega=bodega_b
    WHERE serial=pers.serte;
    EXCEPTION WHEN OTHERS THEN ROLLBACK TO cero;
    EXIT;
END LOOP;
COMMIT;
end;

