<?php
require 'php/connect.php';
// Make the API call
$url = 'https://sensorslab-nodered.cloud-apps.eu/api/v1/visitors/data/';
$data = curl_get_contents($url);

// Decode the JSON data
$data = json_decode($data, true);

// Prepare the insert statement
$sql = "INSERT INTO sixSeconds (timestamp, cellID, rssi, visitorID) VALUES (?, ?, ?, ?)";
$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_bind_param($stmt, "ssss", $timestamp, $cellID, $rssi, $visitorID);

// Loop through the data and bind the parameters for each row
foreach ($data as $row) {
	
    $timestamp = date("Y-m-d H:i:s", $row['timestamp']);;
    $cellID = $row['cellID'];
    $rssi = $row['rssi'];
    $visitorID = $row['visitorID'];
    mysqli_stmt_execute($stmt);
}

// Close the statement and the database connection
mysqli_stmt_close($stmt);
mysqli_close($conn);


function curl_get_contents($url)
{
  $ch = curl_init($url);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
  curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
  $data = curl_exec($ch);
  curl_close($ch);
  return $data;
}

?>
