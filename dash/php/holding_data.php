<?php
require 'connect.php';

$result = $mysqli->query("SELECT
g.cellId,
AVG(g.timeOut - g.timeIn) AS holding
FROM groupeddata AS g
GROUP BY g.cellId
");

$data = array();
foreach ($result as $row) {
	$data[] = $row;
}

print(json_encode($data));
?>