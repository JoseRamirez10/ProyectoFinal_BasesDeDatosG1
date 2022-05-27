--Triggers que identifican un insert y hacen un update.
--Cada que se agregue un producto a la orden, debe actualizarse los totales(por producto y venta), 
--asi como validar que el producto este disponible.


--Funcion que verifica disponibilidad
create or replace function fn_verificar_disp_producto() returns trigger
as $$
declare
--declaracion de variables y/o constantes
v_disponibilidad platillo_bebida.disponibilidad%type;
v_folio_insertado numeric;
v_folio char(7);
begin
	--REVISA SI HAY ORDENES CON EL FOLIO INSERTADO
	select count(*) into v_folio_insertado from orden 
	where folio=NEW.folio;
	
	--REVISA LA DISPONIBILIDAD DEL PLATILLO O BEBIDA
	select disponibilidad into v_disponibilidad from platillo_bebida 
	where nombre_platillobebida=NEW.nombre_platillobebida;
	
	--VERIFICA SI LA DISPONIBILAD ES MENOR A LA CANTIDAD Y SI EL FOLIO EXISTE EN LA TABLA ORDEN
	if	 v_folio_insertado = 0 then
		RAISE EXCEPTION 'La orden % no existe', NEW.folio;
	elsif v_disponibilidad < NEW.cantidad_platillobebida then
		RAISE EXCEPTION 'La cantidad es mayor a la disponibilidad del producto.';
	else
		RAISE NOTICE 'Se ha verificado la disponibilidad.';
	end if;
	return NEW;
end;
$$
language 'plpgsql'





