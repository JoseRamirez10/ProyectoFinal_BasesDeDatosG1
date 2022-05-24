let totalPlatillosOrdenados = 0;
let total = 0;
let orden = [];
let precioPlatillo = [];
let totalPlatillo = [];
let platilloBloqueado = false;

document.addEventListener('DOMContentLoaded',function(){

    // Se ejecuta cuando el usuario selecciona un empleado
    $('#orden').submit(function (e){
        e.preventDefault(); // Previene el evento
        platillo = e.target.id; // Obtiene el nombre del platillo
        let datos = $(`#${platillo}`).serializeArray();
        let cantidad = datos[0]['value'];
        if (cantidad == 0){
            errorSeleccion();
        }else{
            obtenerPlatillo(platillo, cantidad);
        } 
        
    }); 
});

function obtenerPlatillo(platillo, cantidad){
    $.ajax({ // Manda una solicitud por ajax
        type: "POST",
        url: "src/php/orden.php",
        data: 'platillo='+platillo, // Manda el nombre del empleado
        success: function(response){
            datos = JSON.parse(response); // Obtiene los datos en json y los transforma
            //imprimirDatos(datos); // Imprime los datos en pantalla
            precio = datos[0]['Precio'][0];
            precio = parseFloat(precio.replace('$',''));
            let total_orden_platillo = 0;
            for(i = 0; i < cantidad;i++){
                total_orden_platillo += precio;
            }
            
            total+=total_orden_platillo;
            precioPlatillo.push(platillo+' = '+precio)
            orden.push(platillo+' x '+cantidad);
            totalPlatillo.push(total_orden_platillo);

            mostrarOrden(platillo);
            
        }
    });
}

function mostrarOrden(platillo){
    let cuenta = document.querySelector('.cuenta');
    cuenta.classList.remove('oculto');

    let cuenta_platillo = document.querySelector('.cuenta-platillo');
    
    let contenedor = document.createElement('DIV');
    contenedor.classList.add('contenedor-platillo');

    let info_cuenta = document.createElement('LI');
    info_cuenta.textContent = platillo;

    let detalles_cuenta = document.createElement('UL');
    let precio_platillo = document.createElement('LI');
    precio_platillo.textContent = precioPlatillo.pop();
    detalles_cuenta.appendChild(precio_platillo);
    let orden_platillo = document.createElement('LI');
    orden_platillo.textContent = orden.pop();
    detalles_cuenta.appendChild(orden_platillo);
    let total_platillo = document.createElement('LI');
    let totalPlt = totalPlatillo.pop();
    total_platillo.textContent = totalPlt;
    detalles_cuenta.appendChild(total_platillo);

    let eliminar = document.createElement('BUTTON');
    eliminar.textContent = "Eliminar";
    
    info_cuenta.appendChild(detalles_cuenta);
    contenedor.appendChild(info_cuenta);
    contenedor.appendChild(eliminar);
    cuenta_platillo.appendChild(contenedor);
    
    let total_orden = document.querySelector('.cuenta-total');
    total_orden.textContent = total;

    platilloAgregado();
    totalPlatillosOrdenados++;

    if (totalPlatillosOrdenados == 3){
        bloquearPedido(); 
    }

    eliminar.onclick = function(){
        contenedor.parentNode.removeChild(contenedor);
        total = total - totalPlt;
        total_orden.textContent = total;
        platilloEliminado();

        if(platilloBloqueado){
            desbloquearPlatillo();
        }
       
        totalPlatillosOrdenados--;
        if (totalPlatillosOrdenados == 0){
            cuenta.classList.add('oculto');
        }
    };
}

function errorSeleccion(){
    alert('La cantidad del platillo seleccionado no puede ser 0.');
}

function platilloAgregado(){

    document.querySelector('.cuenta').focus();
    const body = document.querySelector('body');
    let contenedor = document.createElement('DIV');
    contenedor.classList.add('texto-centro');
    let mensaje = document.createElement('h2');
    mensaje.textContent = 'Correctamente agregado a la orden';

    contenedor.appendChild(mensaje)
    body.appendChild(contenedor);
    mensaje.classList.add('platillo-confirmacion');
    
    setTimeout(function(){
        body.removeChild(contenedor);
    }, 1500); // El mensaje desaparece despues de un segundo y medio
}

function platilloEliminado(){
    const body = document.querySelector('body');
    let contenedor = document.createElement('DIV');
    contenedor.classList.add('texto-centro');
    let mensaje = document.createElement('h2');
    mensaje.textContent = 'Correctamente eliminado de la orden';

    contenedor.appendChild(mensaje)
    body.appendChild(contenedor);
    mensaje.classList.add('platillo-eliminado');
    
    setTimeout(function(){
        body.removeChild(contenedor);
    }, 1500); // El mensaje desaparece despues de un segundo y medio
}

function bloquearPedido(){
    inputs = document.querySelectorAll('.informacion');
    inputs.forEach(input => {
        input.disabled = true;
    });
    platilloBloqueado = true;
}

function desbloquearPlatillo(){
    inputs = document.querySelectorAll('.informacion');
    inputs.forEach(input => {
        input.disabled = false;
    });
    platilloBloqueado = false;
}