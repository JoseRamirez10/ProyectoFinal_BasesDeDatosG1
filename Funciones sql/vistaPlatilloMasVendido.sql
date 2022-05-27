--Vista que muestre todos los detalles del platillo mas vendido
create or replace view vista_platillo_mas_vendido(nombre,precio,descripcion,receta,
disponibilidad,categoria) as
	select pb.nombre_platillobebida,pb.precio,pb.descripcion,pb.receta,
	pb.disponibilidad,pb.nombre_categoria from platillo_bebida pb
	join enlista e on pb.nombre_platillobebida=e.nombre_platillobebida
	natural join (
		select max(sb.suma) as maximo from platillo_bebida pb 
		join enlista e on pb.nombre_platillobebida=e.nombre_platillobebida 
		join (select sum(cantidad_platillobebida) as suma,
		pb.nombre_platillobebida as nm from platillo_bebida pb 
		join enlista e on pb.nombre_platillobebida=e.nombre_platillobebida
		group by pb.nombre_platillobebida) sb on sb.nm=pb.nombre_platillobebida
	) sbn
	group by pb.nombre_platillobebida,sbn.maximo
	having sum(e.cantidad_platillobebida)=sbn.maximo;