select * from aduanas;
select * from aereolinea;
select * from aeropuerto;
select * from aviones;
select * from boletos;
select * from copiloto;
select * from empleados_aereopuerto;
select * from estacionamiento_aviones;
select * from estacionamiento_pasajeros;
select * from hangares;
select * from llegadas;
select * from locales;
select * from nacionalidades;
select * from paises;
select * from pasajeros;
select * from piloto;
select * from pistas;
select * from puesto;
select * from terminales;
select * from tipo_servicios;
select * from tipo_vuelos;
select * from vuelos;

-- Consulta 1:
-- Muestra el nombre completo del pasajero y asiento que tiene asignado, usando INNER JOIN en la consulta para poder obtener los datos de las tablas: pasajeros y boletos.
-- Tambien al momento de obtener los datos, concatena 3 campos en uno solo para mostrar el nombre completo del pasajero.
select 
concat_ws(' ',pasajeros.nombre, pasajeros.ap_paterno, pasajeros.ap_materno) as nombre_completo, boletos.asiento from pasajeros
INNER JOIN boletos ON pasajeros.id_pasajero = boletos.id_cliente;

-- Consulta 2:
-- Obtiene la cantidad de litros de combustible depositados en los aviones en el mes de Junio del 2021, a su vez, limita la cantidad de decimales que puede mostrar la consulta a unicamente 2:
select truncate(sum(litros),2) as litros_junio from servicio_combustible where fecha > '2021-06-01 00:00:00' and fecha < '2021-06-30 23:59:59';
 
-- Consulta 3: 
-- Muestra el pais el pais del que viene el pasajero basandose en su vuelo asociado a su boleto de avion

select 
concat_ws(' ',pasajeros.nombre, pasajeros.ap_paterno, pasajeros.ap_materno) as nombre_completo, llegadas.origen from pasajeros
left join boletos on pasajeros.id_pasajero = boletos.id_boleto
left join llegadas on boletos.id_vuelo = llegadas.id_vuelo;

-- Consulta 4
-- Muestra la cantidad de vuelos que ha realizado un avion conforme a su repeticion en la tabla vuelos mostrando su numero de serie ordenandolos de menor a mayor cantidad
-- ordenandolos de menor a mayor cantidad de vuelos realizados
select numero_serie, count(vuelos.id_avion) as numero_de_vuelos from aviones 
inner join vuelos on aviones.id_avion = vuelos.id_avion group by numero_serie order by numero_de_vuelos
;

-- Consulta 5 
-- Muestra la cantidad de vuelos que ha realizado un piloto de acuerdo a su repeticion en la tabla vuelos
select concat_ws(' ',piloto.nombre, piloto.ap_paterno, piloto.ap_materno) as nombre_completo, count(piloto.id_piloto) as numero_de_vuelos from piloto
inner join vuelos on piloto.id_piloto = vuelos.id_piloto group by nombre_completo order by numero_de_vuelos;

-- Consulta 6 
-- Muestra una lista de todos los aviones que superen el 90% de capacidad de carga, tambien se indicara la cantidad de veces que lo hizo
select aviones.id_avion, numero_serie, count(vuelos.id_avion) as veces_supera from aviones 
inner join vuelos on aviones.id_avion = vuelos.id_avion where capacidad_carga >= 90 group by numero_serie order by veces_supera;

-- Consulta 7 
-- Muestra en una sola tabla, la informacion de pilotos y copilotos indicando lo que son, ordenando por mayor cantidad de años de experiencia.
select concat_ws(' ',piloto.nombre, piloto.ap_paterno, piloto.ap_materno) as nombre_completo, YEAR(CURDATE()) - YEAR(fecha) as experiencia, curp, sexo, ('piloto') tipo from piloto
union 
select concat_ws(' ',copiloto.nombre, copiloto.ap_paterno, copiloto.ap_materno) as nombre_completo, YEAR(CURDATE()) - YEAR(fecha) as experiencia, curp, sexo, ('copiloto') tipo from copiloto
order by experiencia desc;

-- Consulta 8 
-- Muestra la cantidad de pasajeros por edad
select (YEAR(CURDATE()) - YEAR(fecha)) as edad, count(YEAR(CURDATE()) - YEAR(fecha)) as cantidad_pasajeros from pasajeros group by edad; 

-- Trigger Delete
-- Al eliminar un dato de la tabla llegadas, inserta los datos eliminados en una tabla temporal llamada "temporal_llegadas"
delimiter //
create temporary table if not exists llegadas_respaldos like llegadas;

drop trigger if exists bd_llegadas;

create trigger bd_llegadas
	before delete
    on llegadas
    for each row
    begin 
		insert into llegadas_respaldos values(old.id_llegada,old.id_vuelo,old.fecha_estimada,old.origen,old.id_pista);
	end;//

-- Trigger update
delimiter //
drop trigger if exists bu_update; 

create trigger bu_update;
	before update
    on estacionamiento_pasajeros
    for each row 
    begin 
		if new.id_aeropuerto = 15 then
			set new.ocupado = 0;
		end if;
	end;//











