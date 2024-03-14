<?php
require 'connect.php';

// Calculate the total number of unique visitors for each day
$uniqueVisitorsResult = $mysqli->query("SELECT
    SUM(uniqueVisitors) AS totalUniqueVisitors
    FROM (
        SELECT
            DATE(FROM_UNIXTIME(timeIn)) AS visitDate,
            COUNT(DISTINCT visitorId) AS uniqueVisitors
        FROM groupeddata
        GROUP BY visitDate
    ) AS subquery;
");

$uniqueVisitorsRow = $uniqueVisitorsResult->fetch_assoc();
$totalUniqueVisitors = $uniqueVisitorsRow['totalUniqueVisitors'];



// Retrieve revisitability data
$result = $mysqli->query("SELECT
    g.cellId,
    COUNT(DISTINCT CASE WHEN visitCount >= 2 THEN g.visitorId ELSE NULL END) AS revisitability
    FROM (
        SELECT
            cellId,
            visitorId,
            COUNT(*) AS visitCount
        FROM groupeddata
        GROUP BY cellId, visitorId, DATE(FROM_UNIXTIME(timeIn))
    ) AS g
    GROUP BY g.cellId;
");

$data = array();
foreach ($result as $row) {
	$row['revisitability'] = $row['revisitability'] / $totalUniqueVisitors; // Calculate revisitability
	$data[] = $row;
}

print(json_encode($data));
?>