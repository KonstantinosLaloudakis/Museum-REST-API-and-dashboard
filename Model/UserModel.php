<?php
require_once PROJECT_ROOT_PATH . "/Model/Database.php";
 
class UserModel extends Database
{
    public function changeVIPStatus($visitorType, $routeId, $id)
    {
		echo "Changing vip status";
    	$stmt = mysqli_prepare($this->connection, "UPDATE visitorids SET visitorType = ?, routeId = ? WHERE id = ?");
    	mysqli_stmt_bind_param($stmt, "isi", $visitorType, $routeId, $id);
    	if (mysqli_stmt_execute($stmt)) {
       		// Query executed successfully, do something if needed
    	} else {
        	// Handle query execution error
        	echo "Error updating VIP status: " . mysqli_error($this->connection);
    	}
    }

	public function InsertToVipVisitorsInfo($visitorType, $routeId)
{
    echo "Inserting to new table";
    $stmt = mysqli_prepare($this->connection, "INSERT INTO vipvisitorsinfo (visitorType, routeId) VALUES (?, ?)");
    mysqli_stmt_bind_param($stmt, "is", $visitorType, $routeId);
    if (mysqli_stmt_execute($stmt)) {
        // Query executed successfully, do something if needed

        // Explicitly commit the changes to the database
        mysqli_commit($this->connection);
    } else {
        // Handle query execution error
        echo "Error inserting data to new table: " . mysqli_error($this->connection);
    }
}

	public function linkUuidWithVisitorId($uuid, $visitorid)
    {
        //return $this->select("SELECT * FROM mock_date ORDER BY id ASC LIMIT ?", ["i", $limit]);
		mysqli_query($this->connection,"INSERT INTO link_app VALUES (NULL, $visitorid, $uuid, now())");

    }
	public function visitorIdExists($id)
    {
        //return $this->select("SELECT * FROM mock_date ORDER BY id ASC LIMIT ?", ["i", $limit]);
		$result = mysqli_query($this->connection,"SELECT * FROM visitorids WHERE id = $id");
		$data = mysqli_fetch_array($result, MYSQLI_NUM);
		if($data) {
			//echo "visitorId already exists<br/>";
		}
		else
		{
    		$newVisitorId="INSERT INTO visitorids(id, visitorType, routeId) values($id, 0, NULL)";
			if (mysqli_query($this->connection,$newVisitorId))
			{
				echo "You are now registered";
			}
			else
			{
				echo "Error adding user in database";
			}
		}

    }
	public function updateCounter()
    {
        //return $this->select("SELECT * FROM mock_date ORDER BY id ASC LIMIT ?", ["i", $limit]);
		$result = mysqli_query($this->connection,"CALL UpdateVipCounter()") or die(mysqli_error($this->connection));
		$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
		$result->close();
		$this->connection->next_result();
		return $row['new_vipVisitorsCount'];
		

    }


	private function callAPI($visitor){
		$curl = curl_init();

		curl_setopt_array($curl, array(
		CURLOPT_URL => 'https://sensorslab-nodered.cloud-apps.eu/api/v1/visitors/data/' . $visitor,
		CURLOPT_RETURNTRANSFER => true,
		CURLOPT_ENCODING => '',
		CURLOPT_MAXREDIRS => 10,
		CURLOPT_TIMEOUT => 0,
		CURLOPT_FOLLOWLOCATION => true,
		CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
		CURLOPT_CUSTOMREQUEST => 'GET',
		));

		$response = curl_exec($curl);

		// Check for errors
		if ($response === false) {
			$error = curl_error($curl);
			curl_close($curl);
			return "cURL error: $error";
		}

		curl_close($curl);
		return $response;
	}


	public function getVipVisitorLatestData($visitor)
	{
		$vipData = json_decode($this->callAPI($visitor),true);

		// Create a new instance of DateTime and format it
		$timestamp = new DateTime();
		$timestamp->setTimestamp($vipData[0]['timestamp']);
		$timestamp = $timestamp->format('Y-m-d H:i:s');

		$date = date("Y-m-d H:i:s", $vipData[0]['timestamp']);
$result = mysqli_query($this->connection, "INSERT INTO vipvisitorsdata(time, rssi, visitor_id, sensor_id) values('$date', '".strval(intval($vipData[0]['rssi']))."', '".strval($vipData[0]['visitorID'])."', '".strval($vipData[0]['cellID'])."')");

		// Check for errors
		if (!$result) {
			return mysqli_error($this->connection);
		}

		return $vipData[0];
	}

	public function changeEventStatus($num, $VIPAdded)
    {
        if($num == 1 && $VIPAdded){
			
			mysqli_query($this->connection,"DROP EVENT IF EXISTS `call_procedure_every_10_seconds`;") or die(mysqli_error($this->connection));
			mysqli_query($this->connection,"CREATE EVENT `call_procedure_every_10_seconds` ON SCHEDULE EVERY 5 SECOND STARTS NOW() ON COMPLETION PRESERVE ENABLE DO CALL GetNewVipVisitorsData();") or die(mysqli_error($this->connection));
		
		}
		else if($num == 0){
			mysqli_query($this->connection,"DROP EVENT IF EXISTS `call_procedure_every_10_seconds`;") or die(mysqli_error($this->connection));
			mysqli_query($this->connection,"CREATE EVENT `call_procedure_every_10_seconds` ON SCHEDULE EVERY 5 SECOND STARTS NOW() ON COMPLETION PRESERVE DISABLE DO CALL GetNewVipVisitorsData();") or die(mysqli_error($this->connection));
			}

    }
}
?>