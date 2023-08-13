<?php
require 'connect.php';

$result = $mysqli->query("SELECT routeId, COUNT(*) AS count FROM `vipvisitorsinfo` GROUP BY routeId");
$data = array();

foreach ($result as $row) {
    $data[] = $row;
}

print(json_encode($data));
?>
