/*datos pais*/
INSERT INTO pais VALUES(57, 'Colombia', 0);
INSERT INTO pais VALUES(39, 'Italia', 9);
INSERT INTO pais VALUES(54,'Argentina', 10);
INSERT INTO pais VALUES(49,'Alemania', 12);
INSERT INTO pais VALUES(91,'India', 20);
SELECT * FROM pais;

/*datos ciudad*/
INSERT INTO ciudad VALUES (76001, 'Cali');
INSERT INTO ciudad VALUES (10121, 'Turing');

/*datos individuo*/
INSERT INTO individuo VALUES('ind01', 'Natalia', 57, 'natalia@gmail.com', 'bd01', 'VEN', 'CC', 12345);
INSERT INTO individuo VALUES('ind02', 'Luis', 57, 'luis@gmail.com', 'bd02', 'DES', 'CC', 5555);
INSERT INTO individuo VALUES('ind03', 'Alejandro', 39, 'alejandro@gmail.com', 'bd03', 'CLI', 'NIT', 4444);

/*datos vino*/
-- Calidad (0-10), PH (3-4), Densidad (0.5-1.5)g/ml, Sulfato (5-200)mg/l, Cloruro (500-2000)mg/l, Azucar (5-50)g/l, Alcohol (10-15)grados de alcohol
INSERT INTO vino VALUES (0001, 8, 3.5, 0.98, 5, 600, 10, 12);
INSERT INTO vino VALUES (0002, 10, 3.7, 1.5, 5, 100, 50, 15);

/*bodega*/
-- Temperatura (8-40)C°, Humedad (50-90)%humedad relativa, Capacidad (100-10000)barriles
INSERT INTO bodega VALUES (01, 15, 70, 2000);
INSERT INTO bodega VALUES (02, 20, 50, 3000);

/*lote*/
--Tamaño (50-500)
INSERT INTO lote VALUES (1111, 10000000, '01-10-2020', 'DISPONIBLE', '01-10-1989', 300, 50, 01, 0002);
INSERT INTO lote VALUES (2222, 25000000, '01-06-2021', 'WAIT', '01-10-2015', 1000, 500, 01, 0001);
INSERT INTO lote VALUES (3333, 30000000, '01-07-2021', 'WAIT', '01-10-2015', 200, 500, 01, 0002);

INSERT INTO lote VALUES (4444, 35000000, '01-07-2022', 'WAIT', '11-11-2016', 1000, 500, 02, 0002);
INSERT INTO lote VALUES (5555, 40000000, '01-07-2022', 'WAIT', '01-07-2013', 2000, 500, 02, 0002);
INSERT INTO lote VALUES (6666, 45000000, '03-06-2022', 'WAIT', '01-08-2012', 4000, 500, 01, 0001);
INSERT INTO lote VALUES (7777, 50000000, '12-03-2012', 'VENDIDO', '28-01-2000', 500, 300, 02, 0002);

/*envio*/
INSERT INTO envio VALUES (39, 10121, 01, 'Via Giuseppe Grassi, 2-4');

/*pedidos*/
INSERT INTO pedidos VALUES (001, 01, 1111, '01-11-2020', 'ENTREGADO', 12345, 4444, 5555);

/*detalle pago*/
INSERT INTO detallePago VALUES (001, 10000000, '02-10-2020');

