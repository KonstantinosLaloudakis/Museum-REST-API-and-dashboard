<?php
require 'connect.php';
$result = $mysqli->query("SELECT grouped_data.sensor_id AS sensor,COUNT(grouped_data.sensor_id) AS sensorCount
	FROM (SELECT id,MIN(time_in) as time_in,MIN(time_out) as time_out,visitor_id,sensor_id 
   FROM `beacon_data_test` GROUP BY visitor_id,sensor_id) AS grouped_data 
   GROUP BY grouped_data.sensor_id;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));

?>