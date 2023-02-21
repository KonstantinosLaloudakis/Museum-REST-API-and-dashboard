<?php
require '../connect.php';
$result = $mysqli->query("SELECT COUNT(*) as no_of_visits,
	DATE_FORMAT(time_in, \"%d/%m/%Y\") as date
	FROM `times` WHERE sensor_id !=0 GROUP BY DAY(time_in) ORDER BY time_in asc;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));

?>