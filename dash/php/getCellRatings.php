<?php
require 'connect.php';


// Query the database to get unique cells, the number of ratings, and the average rating for each cell
$sql = "SELECT cell, COUNT(*) AS ratingCount, AVG(rating) AS avgRating FROM exhibit_ratings GROUP BY cell";
$result = $mysqli->query($sql);

$data = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

// Close the database connection
$mysqli->close();

// Return the data as JSON
header('Content-Type: application/json');
echo json_encode($data);
?>
