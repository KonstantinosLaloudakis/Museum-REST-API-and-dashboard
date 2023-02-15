<?php
require 'connect.php';
// Make the API call
$url = 'https://sensorslab-nodered.cloud-apps.eu/api/v1/visitors/data/';
$data = file_get_contents($url);

// Decode the JSON data
$data = json_decode($data, true);

// Prepare the insert statement
$sql = "INSERT INTO sixSeconds (timestamp, cellID, rssi, visitorID,MaxRssi) VALUES (?, ?, ?, ?, ?)";
$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_bind_param($stmt, "sssss", $timestamp, $cellID, $rssi, $visitorID, $MaxRssi);

// Loop through the data and bind the parameters for each row
foreach ($data as $row) {
	
    $timestamp = date("Y-m-d H:i:s", $row['timestamp']);;
    $cellID = $row['cellID'];
    $rssi = $row['rssi'];
    $visitorID = $row['visitorID'];
    $MaxRssi = $row['MaxRssi'];
    mysqli_stmt_execute($stmt);
}

// Close the statement and the database connection
mysqli_stmt_close($stmt);
mysqli_close($conn);


?>
