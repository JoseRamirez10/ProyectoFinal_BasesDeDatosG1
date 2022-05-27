--Triggers que identifican un insert y hacen un update.
--Cada que se agregue un producto a la orden, debe actualizarse los totales(por producto y venta), 
--asi como validar que el producto este disponible.


--Trigger encargado de actualizar datos despues de la insercion
create or replace trigger trg_act_disp_total 
after insert on enlista
for each row
execute procedure fn_act_disp_total();


--Trigger que evalua si el producto esta disponible, asi como si la orden existe
create or replace trigger trg_verificar_disp_producto 
before insert on enlista
for each row
execute procedure fn_verificar_disp_producto();


