<?php
require 'connect.php';
$dateFrom = $_GET['dateFrom'];
$dateTo = $_GET['dateTo'];

$dateFromTimestamp = strtotime($dateFrom);
$dateToTimestamp = strtotime($dateTo);

$result = $mysqli->query("SELECT
visitHour,
SUM(visitorsPerHour) AS totalVisitorsPerHour
FROM (
SELECT
	DATE(FROM_UNIXTIME(timeIn)) AS visitDate,
	HOUR(FROM_UNIXTIME(timeIn)) AS visitHour,
	COUNT(DISTINCT visitorId) AS visitorsPerHour
FROM groupeddata
WHERE timeIn >= '$dateFromTimestamp' 
AND timeIn <= '$dateToTimestamp'
GROUP BY visitDate, visitHour
) AS subquery
GROUP BY visitHour
ORDER BY visitHour;
");
$data = array();
foreach ($result as $row) {
	$data[] = $row;
}
print(json_encode($data));


?>