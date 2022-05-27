--Permitir obtener el nombre de aquellos productos que no esten disponibles.
create or replace function fn_prod_no_disp(producto_no_disponible out varchar)
returns setof character varying as $$
--declaracion de variables
declare
	reg record;
begin
	--REVISA LOS PRODUCTOS CUYA DISPONIBILIDAD ESTA EN 0 Y LOS VA REGISTRANDO
	for reg in select nombre_platillobebida from platillo_bebida 
	where disponibilidad = 0 loop
		producto_no_disponible := reg.nombre_platillobebida;
		return next;
	end loop;
	return;
end;
$$
language plpgsql;