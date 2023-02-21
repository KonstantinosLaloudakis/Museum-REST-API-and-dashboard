<?php
require '../connect.php';
$result = $mysqli->query("SELECT MAX(TIMESTAMPDIFF(MINUTE,time_in, time_out)) AS maxTime,
	 AVG(TIMESTAMPDIFF(MINUTE,time_in, time_out)) AS avgTime,
	 AVG(TIMESTAMPDIFF(MINUTE,time_in, time_out)) AS minTime,
	 AVG(TIMESTAMPDIFF(MINUTE,time_in, time_out)) AS avgTime,
	  sensor_id FROM `times` WHERE sensor_id !=0 GROUP BY sensor_id;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));


?>