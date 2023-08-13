<?php
require 'connect.php';

// Retrieve dateFrom and dateTo from query parameters
$dateFrom = isset($_GET['dateFrom']) ? $_GET['dateFrom'] : null;
$dateTo = isset($_GET['dateTo']) ? $_GET['dateTo'] : null;

// Convert the date format to match your database date format
$dateFrom = date("Y-m-d H:i:s", strtotime($dateFrom . " 00:00:00"));
$dateTo = date("Y-m-d H:i:s", strtotime($dateTo . " 23:59:59"));

$result = $mysqli->query("SELECT COUNT(1) as visits, HOUR(time_in) as hour 
    FROM times
    WHERE time_in BETWEEN '$dateFrom' AND '$dateTo'
    GROUP BY HOUR(time_in);");

$data = array();
foreach ($result as $row) {
    $data[] = $row;
}
print(json_encode($data));
?>


<!-- $result = $mysqli->query("SELECT COUNT(1) as visits,hour(time_in) as hour FROM times where time_in is not null GROUP BY hour( time_in );");
    $data = array();
    foreach ($result as $row) {
        $data[] = $row;
    }
    print(json_encode($data)); 


            
            require 'connect.php';
            // Retrieve dateFrom and dateTo from query parameters
            $dateFrom = isset($_GET['dateFrom']) ? $_GET['dateFrom'] : null;
            $dateTo = isset($_GET['dateTo']) ? $_GET['dateTo'] : null;
            
            // Convert the date format to match your database date format
            $dateFrom = date("Y-m-d H:i:s", strtotime($dateFrom . " 00:00:00"));
            $dateTo = date("Y-m-d H:i:s", strtotime($dateTo . " 23:59:59"));

            $result = $mysqli->query("SELECT COUNT(1) as visits,hour(time_in) as hour FROM times where time_in is not null GROUP BY hour( time_in );");
            $data = array();
            foreach ($result as $row) {
                $data[] = $row;
            }
            print(json_encode($data));
      
        -->