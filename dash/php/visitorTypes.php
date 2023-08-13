<?php
require 'connect.php';

$result = $mysqli->query("SELECT visitorType, COUNT(*) AS count FROM `vipvisitorsinfo` GROUP BY visitorType");
$data = array();

foreach ($result as $row) {
    $data[] = $row;
}

print(json_encode($data));
?>