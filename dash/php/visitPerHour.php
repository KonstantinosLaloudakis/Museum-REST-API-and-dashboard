<?php
    require 'connect.php';
    $result = $mysqli->query("SELECT COUNT(1) as visits,hour(time_in) as hour FROM times where time_in is not null GROUP BY hour( time_in );");
    $data = array();
    foreach ($result as $row) {
        $data[] = $row;
    }
    print(json_encode($data));
?>