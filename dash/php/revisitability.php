<?php
require 'connect.php';
$dateFrom = $_GET['dateFrom'];
$dateTo = $_GET['dateTo'];
$building = $_GET['building']; // Get the selected building value from the query parameter

$dateFromTimestamp = strtotime($dateFrom);
$dateToTimestamp = strtotime($dateTo);

// Calculate the total number of unique visitors for each day
$uniqueVisitorsResult = $mysqli->query("SELECT
    SUM(uniqueVisitors) AS totalUniqueVisitors
    FROM (
        SELECT
            DATE(FROM_UNIXTIME(timeIn)) AS visitDate,
            COUNT(DISTINCT visitorId) AS uniqueVisitors
        FROM groupeddata
        WHERE timeIn >= '$dateFromTimestamp'
        AND timeOut <= '$dateToTimestamp'
        GROUP BY visitDate
    ) AS subquery;
");

$uniqueVisitorsRow = $uniqueVisitorsResult->fetch_assoc();
$totalUniqueVisitors = $uniqueVisitorsRow['totalUniqueVisitors'];

// Calculate revisitability and attraction power for each cellId
$result = $mysqli->query("SELECT
    g.cellId,
    COUNT(DISTINCT CASE WHEN visitCount >= 2 THEN g.visitorId ELSE NULL END) AS revisitability,
    COUNT(DISTINCT g.visitorId) AS uniqueVisitorsInCell,
    c.roomName AS roomName
    FROM (
        SELECT
            cellId,
            visitorId,
            COUNT(*) AS visitCount
        FROM groupeddata
        WHERE timeIn >= '$dateFromTimestamp' 
        AND timeOut <= '$dateToTimestamp'
        GROUP BY cellId, visitorId, DATE(FROM_UNIXTIME(timeIn))
    ) AS g
    INNER JOIN cellids AS c ON g.cellId = c.id
    WHERE c.roomName LIKE '%$building%'  -- Add this line to filter by roomName containing $building
   	GROUP BY g.cellId, c.roomName;
");

$data = array();
foreach ($result as $row) {
	$row['revisitability'] = $row['revisitability'] / $totalUniqueVisitors; // Calculate revisitability
	$row['attractionPower'] = $row['uniqueVisitorsInCell'] / $totalUniqueVisitors; // Calculate attraction power
	$data[] = $row;
}

print(json_encode($data));
?>