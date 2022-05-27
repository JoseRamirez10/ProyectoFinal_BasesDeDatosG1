--De manera automatica se genere una vista que contenga 
--información necesaria para asemejarse a una factura de una orden
--Funcion que devuelve lo que devolveria una vista, dada una orden.
create or replace function fn_vista_factura_orden(p_folio in char(7)) returns table(
	folio char(7),fecha date,rfc_cliente char(13),producto varchar,precio money,
	cantidad integer,total money
) as $$
begin
	return query
	select o.folio,o.fecha,o.rfc_cliente,e.nombre_platillobebida,
	pb.precio,e.cantidad_platillobebida,o.total 
	from orden o join enlista e on o.folio=e.folio 
	join platillo_bebida pb on pb.nombre_platillobebida=e.nombre_platillobebida
	where o.folio=p_folio;
end;
$$
language 'plpgsql'
