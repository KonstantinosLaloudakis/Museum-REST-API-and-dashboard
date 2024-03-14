<?php
require 'connect.php';

$result = $mysqli->query("WITH OrderedData AS (
	SELECT
	  timeIn,
	  timeOut,
	  cellId,
	  visitorId,
	  LEAD(cellId) OVER (PARTITION BY visitorId ORDER BY timeIn) AS nextCellId,
	  LEAD(timeIn) OVER (PARTITION BY visitorId ORDER BY timeIn) AS nextTimeIn
	FROM
	  groupeddata
  )
  , PairedData AS (
	SELECT DISTINCT
	  cellId AS firstCellId,
	  nextCellId AS secondCellId,
	  LEAST(timeIn, nextTimeIn) AS firstTimeIn
	FROM
	  OrderedData
	WHERE
	  nextCellId IS NOT NULL
  )
  SELECT
	firstCellId,
	secondCellId,
	MIN(firstTimeIn) AS firstTimeIn,
	COUNT(*) AS totalAppearances
  FROM
	PairedData
  GROUP BY
	firstCellId, secondCellId
  ORDER BY
	totalAppearances DESC, firstTimeIn, firstCellId, secondCellId;  
");

$data = array();
foreach ($result as $row) {
	$data[] = $row;
}
print(json_encode($data));
?>