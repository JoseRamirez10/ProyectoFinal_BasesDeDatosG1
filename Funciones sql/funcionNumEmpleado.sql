--Dado un número de empleado, mostrar la cantidad de órdenes que ha registrado
--en el dia asi como el total que se ha pagado por dichas ordenes.
create or replace function fn_ordenes_empleado(p_num_empleado in numeric) 
returns table (num_empleado integer,cant_ordenes bigint,total money) as $$
declare
--declaracion de variables
v_cant_ordenes numeric;
v_total_dia numeric; 
v_es_mesero numeric;
begin

	--VERIFICA SI HAY REGISTROS EN MESERO CON EL NUMERO DE EMPLEADO PROPORCIONADO
	select count(*) into v_es_mesero from empleado e join mesero m on e.num_empleado=m.num_empleado
	where e.num_empleado=p_num_empleado;
	
	if v_es_mesero != 0 then
		--VERIFICA LAS ORDENES QUE HA HECHO ESE EMPLEADO EN ESE DIA
		select  count(*) into v_cant_ordenes 
		from empleado e join orden o on e.num_empleado=o.num_empleado
		where e.num_empleado=p_num_empleado and o.fecha=current_date;
		
		select  sum(o.total) into v_total_dia 
		from empleado e join orden o on e.num_empleado=o.num_empleado
		where e.num_empleado=p_num_empleado and o.fecha=current_date;
		--VERIFICA SI NO HA HECHO ALGUNA ORDEN ESE DIA
		if v_cant_ordenes = 0 then
			RAISE NOTICE 'El empleado con el numero % ha registrado 0 ordenes hoy.',
			p_num_empleado;
		else
			return query select e.num_empleado,count(*),sb.tot
			from empleado e join orden o on e.num_empleado=o.num_empleado join (select e.num_empleado as nm,sum(o.total) as tot
			from empleado e join orden o on e.num_empleado=o.num_empleado where e.num_empleado=p_num_empleado and o.fecha=current_date 
			group by e.num_empleado 
			) sb on sb.nm=e.num_empleado
			where e.num_empleado=p_num_empleado and o.fecha=current_date
			group by e.num_empleado,sb.tot;
			RAISE NOTICE 'El empleado con el numero % ha registrado % orden(es) hoy y su total es %.',
			p_num_empleado,v_cant_ordenes,v_total_dia;
		end if;
	else
		RAISE EXCEPTION 'El empleado con el numero % no es un mesero.', p_num_empleado;
	end if;
end;
$$
language plpgsql;