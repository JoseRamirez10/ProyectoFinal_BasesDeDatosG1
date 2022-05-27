--Dada una fecha, o una fecha de inicio y fecha de fin, regresar el total del
--número de ventas y el monto total por las ventas en ese periodo de tiempo.

create or replace function fn_ventas_intervalo(
	p_fecha_inicial in varchar,
	p_fecha_final in varchar
) returns table(cantidad bigint, total money) as $$
declare
--declaracion de variables
v_cantidad numeric;
v_total numeric;
begin
	--CUENTA LAS ORDENES Y EL TOTAL QUE SE GENERARON EN ESAS FECHAS
	select count(*) into v_cantidad from orden
	where fecha between to_date(p_fecha_inicial,'dd-mm-yyyy') 
	and to_date(p_fecha_final,'dd-mm-yyyy');  
	
	select sum(orden.total) into v_total from orden
	where fecha between to_date(p_fecha_inicial,'dd-mm-yyyy') 
	and to_date(p_fecha_final,'dd-mm-yyyy');  
	--IMPRIME LOS VALORES OBTENIDOS
	if v_cantidad = 0 then
		RAISE NOTICE 'No se realizaron ordenes en el intervalo % / % .',
		to_date(p_fecha_inicial,'dd-mm-yyyy'),to_date(p_fecha_final,'dd-mm-yyyy');
	else
		return query select count(*), sum(orden.total) from orden
		where fecha between to_date(p_fecha_inicial,'dd-mm-yyyy') 
		and to_date(p_fecha_final,'dd-mm-yyyy'); 
		RAISE NOTICE 'La cantidad de ordenes en ese intervalo % / % es % y el total es % .',
		to_date(p_fecha_inicial,'dd-mm-yyyy'),to_date(p_fecha_final,'dd-mm-yyyy'),v_cantidad,v_total;
	end if;
end;
$$
language plpgsql;