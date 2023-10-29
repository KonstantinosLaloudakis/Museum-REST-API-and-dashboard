<?php
require 'connect.php';
$result = $mysqli->query("SELECT
aggregated.sensor_id AS exhibit_no,
AVG(aggregated.time_diff) AS avg_time,
SUM(aggregated.time_diff) AS total_time,
MAX(aggregated.time_diff) AS max_time,
MIN(aggregated.time_diff) AS min_time,
COUNT(aggregated.sensor_id) AS no_of_visits
FROM (
SELECT
	sensor_id,
	TIMESTAMPDIFF(MINUTE, time_in, time_out) AS time_diff
FROM beacon_data_test
WHERE sensor_id != 0
) AS aggregated
GROUP BY aggregated.sensor_id;
");
$data = array();
foreach ($result as $row) {
	$data[] = $row;
}
print(json_encode($data));
?>