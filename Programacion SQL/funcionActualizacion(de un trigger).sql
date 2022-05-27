--Triggers que identifican un insert y hacen un update.
--Cada que se agregue un producto a la orden, debe actualizarse los totales(por producto y venta), 
--asi como validar que el producto este disponible.

--Funcion para actualizar disponibilidad y el total
create or replace function fn_act_disp_total() returns trigger as $$
begin
	--REALIZA EL UPDATE DE DISPONIBILAD EN PLATILLO_BEBIDA
	update platillo_bebida
	set disponibilidad = platillo_bebida.disponibilidad-NEW.cantidad_platillobebida 
	where nombre_platillobebida=NEW.nombre_platillobebida;
	--REALIZA EL UPDATE DE TOTAL EN LA ORDEN
	update orden
	set total = total+NEW.precio_platillobebida
	where folio = NEW.folio;
	return NEW;
end;
$$
language 'plpgsql'





