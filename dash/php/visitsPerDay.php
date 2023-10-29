<?php
require 'connect.php';
$result = $mysqli->query("SELECT COUNT(*) as no_of_visits,
DATE_FORMAT(ANY_VALUE(day), '%d/%m/%Y') as date
FROM (
SELECT COUNT(*) as no_of_visits, DATE(time_in) as day
FROM `times`
WHERE sensor_id != 0
GROUP BY day
) as cte
ORDER BY day asc;
");
$data = array();
foreach ($result as $row) {
	$data[] = $row;
}
print(json_encode($data));

?>