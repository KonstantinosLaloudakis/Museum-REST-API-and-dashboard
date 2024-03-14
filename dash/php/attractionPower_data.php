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


// Retrieve attractionPower data
$result = $mysqli->query("SELECT
cellId,
SUM(daily_distinct_count) AS attraction
FROM (
SELECT
	cellId,
	DATE(FROM_UNIXTIME(timeIn)) AS visitDate,
	COUNT(DISTINCT visitorId) AS daily_distinct_count
FROM groupeddata
GROUP BY cellId, visitDate
) AS subquery
GROUP BY cellId;
");

$data = array();
foreach ($result as $row) {
	$row['attraction'] = $row['attraction'] / $totalUniqueVisitors; // Calculate attraction power
	$data[] = $row;
}

print(json_encode($data));
?>