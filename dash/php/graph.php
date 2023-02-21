<?php
require 'connect.php';

$queryId = $_GET['query'];
if ($queryId == 1) {
	$result = $mysqli->query("SELECT COUNT(1) as visits,hour(time_in) as hour FROM times where time_in is not null GROUP BY hour( time_in );");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));
}

if ($queryId == 2) {
	$result = $mysqli->query("SELECT SUM(TIMESTAMPDIFF(MINUTE,grouped_data.time_in,grouped_data.time_out)) as sum_time, grouped_data.sensor_id as sensor_id 
	FROM (SELECT id,MIN(time_in) as time_in,MIN(time_out) as time_out,visitor_id,sensor_id 
	FROM `beacon_data_test` GROUP BY visitor_id,sensor_id) AS grouped_data 
	GROUP BY grouped_data.sensor_id;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));
}

if ($queryId == 3) {
	$result = $mysqli->query("SELECT AVG(TIMESTAMPDIFF(MINUTE,grouped_data.time_in,grouped_data.time_out)) AS avg_time, 
	COUNT(grouped_data.sensor_id) AS no_of_visits, grouped_data.sensor_id AS exhibit_no
	 FROM (SELECT id,MIN(time_in) as time_in,MIN(time_out) as time_out,visitor_id,sensor_id FROM `beacon_data_test`
	 GROUP BY visitor_id,sensor_id) AS grouped_data
	GROUP BY grouped_data.sensor_id;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));
}

if ($queryId == 4) {
	$result = $mysqli->query("SELECT MAX(TIMESTAMPDIFF(MINUTE,time_in, time_out)) AS time_max,AVG(TIMESTAMPDIFF(MINUTE,time_in, time_out)) AS time_avg, MIN(TIMESTAMPDIFF(MINUTE,time_in, time_out)) AS time_min ,sensor_id FROM `times` WHERE sensor_id !=0 GROUP BY sensor_id;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));
}

if ($queryId == 5) {
	$result = $mysqli->query("SELECT COUNT(*), COUNT(IF (isVIP=1,1,null)) AS vipcount, COUNT(IF (isVIP=0,1,null)) AS regcount FROM visitorids;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));

}

if ($queryId == 6) {
	$result = $mysqli->query("SELECT grouped_data.sensor_id AS sensor,COUNT(grouped_data.sensor_id) AS sensorCount
	FROM (SELECT id,MIN(time_in) as time_in,MIN(time_out) as time_out,visitor_id,sensor_id 
   FROM `beacon_data_test` GROUP BY visitor_id,sensor_id) AS grouped_data 
   GROUP BY grouped_data.sensor_id;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));

}

if ($queryId == 7) {
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


}


if ($queryId == 8) {
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


}

if ($queryId == 9) {
	$result = $mysqli->query("SELECT sensor_id, COUNT(*) AS revisitability, COUNT(*)/(SELECT COUNT(*) FROM `revisitability` WHERE sensor_id<=>0) AS power_of_attraction FROM `revisitability` WHERE revisitability_counter>0 GROUP BY sensor_id;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));


}

if ($queryId == 10) {
	$result = $mysqli->query("SELECT COUNT(*) as no_of_visits,
	DATE_FORMAT(time_in, \"%d/%m/%Y\") as date
	FROM `times` WHERE sensor_id !=0 GROUP BY DAY(time_in) ORDER BY time_in asc;");
	$data = array();
	foreach ($result as $row) {
		$data[] = $row;
	}
	print(json_encode($data));


}

//echo json_encode($data);
$mysqli->close();

?>