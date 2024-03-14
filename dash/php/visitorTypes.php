<?php
require 'connect.php';
$dateFrom = $_GET['dateFrom'];
$dateTo = $_GET['dateTo'];

$result = $mysqli->query(
	"SELECT 
visitorType,
COUNT(*) AS count
FROM `vipvisitorsinfo` 
WHERE DATE(createdAt) BETWEEN DATE('$dateFrom') AND DATE('$dateTo')
GROUP BY visitorType"
);
$data = array();

foreach ($result as $row) {
	$data[] = $row;
}

print(json_encode($data));
?>