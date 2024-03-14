<?php
require 'connect.php';
$dateFrom = $_GET['dateFrom'];
$dateTo = $_GET['dateTo'];

$dateFromTimestamp = strtotime($dateFrom);
$dateToTimestamp = strtotime($dateTo);

$result = $mysqli->query("SELECT
    DATE(FROM_UNIXTIME(timeIn)) AS visitDate,
    COUNT(*) AS visitsPerDay
    FROM groupeddata
    WHERE timeIn >= '$dateFromTimestamp' 
    AND timeOut <= '$dateToTimestamp'
    GROUP BY visitDate
    ORDER BY visitDate;
");
$data = array();
foreach ($result as $row) {
	$data[] = $row;
}
print(json_encode($data));

?>