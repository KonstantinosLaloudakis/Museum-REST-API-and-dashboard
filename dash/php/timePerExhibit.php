<?php
require 'connect.php';
$result = $mysqli->query("SELECT AVG(TIMESTAMPDIFF(MINUTE,grouped_data.time_in,grouped_data.time_out)) AS avg_time, 
	SUM(TIMESTAMPDIFF(MINUTE,grouped_data.time_in,grouped_data.time_out)) AS sum, 
	MAX(TIMESTAMPDIFF(MINUTE,grouped_data.time_in,grouped_data.time_out)) AS max_time, 
	MIN(TIMESTAMPDIFF(MINUTE,grouped_data.time_in,grouped_data.time_out)) AS min_time,
	 COUNT(grouped_data.sensor_id) AS no_of_visits, grouped_data.sensor_id AS exhibit_no
	FROM (SELECT id,MIN(time_in) as time_in,MIN(time_out) as time_out,visitor_id,sensor_id FROM `beacon_data_test`
	 where sensor_id !=0 GROUP BY visitor_id,sensor_id) AS grouped_data GROUP BY grouped_data.sensor_id;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));
?>