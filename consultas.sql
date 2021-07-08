----1----

with totales AS(select sum(cantidadbarriles) AS cantidad, EXTRACT (year FROM LOTE.fechaProduccion) AS yea
from Bodega natural join Lote GROUP BY EXTRACT (year FROM LOTE.fechaProduccion))
SELECT yea,numerobodega,cantidad as cantidadTotal
from Bodega natural join Lote,totales
where totales.yea=EXTRACT (year FROM LOTE.fechaProduccion)
GROUP BY yea,numerobodega,cantidad
HAVING sum(Cantidadbarriles)>=0.3*cantidad
ORDER BY yea;

----2----

with totales AS(select AVG(monto)AS prom,EXTRACT (MONTH FROM Pedidos.fechaEntrega) as mont
from pedidos  natural join detallepago
where EXTRACT (year FROM Pedidos.fechaEntrega)=EXTRACT (year FROM sysdate)
GROUP BY EXTRACT (MONTH FROM Pedidos.fechaEntrega))
SELECT nombre,mont,prom
from (pedidos natural join detallepago) inner join individuo on individuo.id=pedidos.idVendedor,totales
where totales.mont=EXTRACT (MONTH FROM Pedidos.fechaEntrega)
GROUP BY nombre,mont,prom
HAVING AVG(monto)>=prom
ORDER BY mont;

-----3------
SELECT individuo.nombre FROM individuo
    WHERE tipo = 'CLI'
    AND (nombre LIKE '% P%'
    OR  nombre LIKE '% D%');
-----4-----

with cositow as (select nombre as namer,count(nombre) as cantcompra,EXTRACT (MONTH FROM pedidos.fechaEntrega) as mes
from pedidos INNER JOIN individuo on individuo.id=pedidos.idCliente
group by nombre,EXTRACT (MONTH FROM pedidos.fechaEntrega))
SELECT 
	namer, mes,RANK() OVER(order BY cantcompra desc ) 
FROM 
	cositow;
-----5----

SELECT nombre,id,lote.serial,lote.precio,lote.tamano
FROM ((select * from individuo where tipo='CLI') left join pedidos on id=pedidos.idCliente) FULL OUTER JOIN LOTE ON pedidos.serial = lote.serial;
----6------
/*Listar el serial, código y número de bodega de todos los lotes de vino que están en estado de disponible y wait, pero no de vendido*/
(SELECT lote.serial, lote.codVino, lote.estadoComercial, numeroBodega
FROM lote NATURAL JOIN bodega
WHERE estadoComercial = 'WAIT'
UNION
SELECT lote.serial, lote.codVino, lote.estadoComercial, numeroBodega
FROM lote NATURAL JOIN bodega
WHERE estadoComercial = 'DISPONIBLE')
MINUS
SELECT lote.serial, lote.codVino, lote.estadoComercial, numeroBodega
FROM lote NATURAL JOIN bodega
WHERE estadoComercial = 'VENDIDO';
------7-----
/*adquirtir los vinos con calidad mayor a 7*/
/*seleccione los lotes  de un vino con calidad mayor a 7 y ademas que el promedio de la cantidad sea mayor a 500(tamaño medio)

SELECT codVino, Calidad,serial
    FROM vino inner join lote using(codvino)
	where vino.calidad>7
        GROUP BY codVino, Calidad,serial
            HAVING avg(tamano) > 500;

----8----
-------Los directivos quieren saber de que pais obtienen mas dinero por pedidos-----

select pais.nombre from pedidos natural join envio natural join pais natural join detallepago
GROUP BY pais.nombre
having sum(monto)>=(select max(monto)
from pedidos natural join detallepago);

