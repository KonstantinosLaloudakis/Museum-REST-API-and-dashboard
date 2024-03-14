<?php
require 'connect.php';
$dateFrom = $_GET['dateFrom'];
$dateTo = $_GET['dateTo'];
$building = $_GET['building']; // Get the selected building value from the query parameter

$dateFromTimestamp = strtotime($dateFrom);
$dateToTimestamp = strtotime($dateTo);

// Modify the SQL query to filter based on the selected building
$result = $mysqli->query("SELECT
    g.cellId,
    SUM(1) AS totalVisits,
    c.roomName as roomName
    FROM groupeddata AS g
    INNER JOIN cellids AS c ON g.cellId = c.id
    WHERE g.timeIn >= '$dateFromTimestamp' 
    AND g.timeOut <= '$dateToTimestamp'
    AND c.roomName LIKE '$building%'  -- Use LIKE to match the building
    GROUP BY g.cellId, c.roomName
    ORDER BY c.roomName;
");

$data = array();
foreach ($result as $row) {
	$data[] = $row;
}
print(json_encode($data));

?>