<?php
require 'connect.php';
$dateFrom = $_GET['dateFrom'];
$dateTo = $_GET['dateTo'];
$building = $_GET['building']; // Get the selected building value from the query parameter

$dateFromTimestamp = strtotime($dateFrom);
$dateToTimestamp = strtotime($dateTo);

$result = $mysqli->query("SELECT
g.cellId,
AVG(g.timeOut - g.timeIn) AS avg_time,
SUM(g.timeOut - g.timeIn) AS total_time,
MAX(g.timeOut - g.timeIn) AS max_time,
MIN(g.timeOut - g.timeIn) AS min_time,
c.roomName AS exhibit_name
FROM groupeddata AS g
INNER JOIN cellids AS c ON g.cellId = c.id
WHERE g.timeIn >= '$dateFromTimestamp' 
AND g.timeOut <= '$dateToTimestamp'
AND c.roomName LIKE '$building%'  -- Use LIKE to match the building
GROUP BY g.cellId
ORDER BY c.roomName;
");
$data = array();
foreach ($result as $row) {
	$data[] = $row;
}
print(json_encode($data));
?>