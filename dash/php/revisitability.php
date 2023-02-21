<?php
    require 'connect.php';
    $result = $mysqli->query("SELECT sensor_id, COUNT(*) AS revisitability, COUNT(*)/(SELECT COUNT(*) FROM `revisitability` WHERE sensor_id<=>0) AS power_of_attraction FROM `revisitability` WHERE revisitability_counter>0 GROUP BY sensor_id;");
    $data = array();
    foreach ($result as $row) {
        $data[] = $row;
    }
    print(json_encode($data));
?>