<?php

    $platillo = $_POST['platillo'];
    include "conexion.php";

    $psql = pg_query($conexion, "SELECT precio FROM platillo_bebida where nombre_platillobebida = '$platillo'");
    $data = array();
    $resultado = pg_fetch_row($psql);
        $data[] = array('Platillo'=>$platillo, 'Precio'=>$resultado);
    echo json_encode($data);

?>