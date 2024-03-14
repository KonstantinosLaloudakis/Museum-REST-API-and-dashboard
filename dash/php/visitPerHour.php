<?php
require 'connect.php';
$dateFrom = $_GET['dateFrom'];
$dateTo = $_GET['dateTo'];

$dateFromTimestamp = strtotime($dateFrom);
$dateToTimestamp = strtotime($dateTo);


$result = $mysqli->query("SELECT
    HOUR(FROM_UNIXTIME(g.timeIn)) AS visitHour,
    COUNT(*) AS visitsPerHour
    FROM groupeddata AS g
    WHERE g.timeIn >= '$dateFromTimestamp' 
    AND g.timeIn <= '$dateToTimestamp'
    GROUP BY visitHour
    ORDER BY visitHour;
");

$data = array();
foreach ($result as $row) {
	$data[] = $row;
}
print(json_encode($data));
?>