<?php
require_once PROJECT_ROOT_PATH . "/Model/Database.php";
 
class UserModel extends Database
{
    public function changeVIPStatus($visitorType, $routeId, $id)
    {
		// Check if the visitor already has a non-zero routeId or visitorType
		$existingData = $this->getVisitorData($id);

		if ($existingData['routeId'] != null || $existingData['visitorType'] != 0) {
			$response = array(
				"status" => "false",
				"message" => "Visitor already has non-zero routeId or visitorType"
			);
			echo json_encode($response);
			return; // Exit the function early
		}
		$query = "UPDATE visitorids SET visitorType = ?, routeId = ? WHERE id = ?";
        $params = ['isi', $visitorType, $routeId, $id];
        return $this->executeStatement($query, $params);
    	//$stmt = mysqli_prepare($this->connection, "UPDATE visitorids SET visitorType = ?, routeId = ? WHERE id = ?");
    	//mysqli_stmt_bind_param($stmt, "isi", $visitorType, $routeId, $id);
    	//if (mysqli_stmt_execute($stmt)) {
       	//	// Query executed successfully, do something if needed
    	//} else {
        //	// Handle query execution error
        //	echo "Error updating VIP status: " . mysqli_error($this->connection);
    	//}
    }

	public function getVisitorData($id)
    {
        $query = "SELECT visitorType, routeId FROM visitorids WHERE id = ?";
        $params = ['i', $id];
        $result = $this->executeStatement($query, $params);

        if ($result && mysqli_num_rows($result) > 0) {
            $row = mysqli_fetch_assoc($result);
            return $row;
        }

        return null; // Visitor data not found
    }

	public function InsertToVipVisitorsInfo($visitorType, $routeId)
	{
		$query = "INSERT INTO vipvisitorsinfo (visitorType, routeId) VALUES (?, ?)";
		$params = ['is', $visitorType, $routeId];
		return $this->executeStatement($query, $params);
		//echo "Inserting to new table";
		//$stmt = mysqli_prepare($this->connection, "INSERT INTO vipvisitorsinfo (visitorType, routeId) VALUES (?, ?)");
		//mysqli_stmt_bind_param($stmt, "is", $visitorType, $routeId);
		//if (mysqli_stmt_execute($stmt)) {
		//    // Query executed successfully, do something if needed

		//    // Explicitly commit the changes to the database
		//    mysqli_commit($this->connection);
		//} else {
		//    // Handle query execution error
		//    echo "Error inserting data to new table: " . mysqli_error($this->connection);
		//}
	}

	public function linkUuidWithVisitorId($uuid, $visitorid)
    {
		$query = "INSERT INTO link_app (visitorId, uuid, timestamp) VALUES (?, ?, now())";
        $params = ['is', $visitorid, $uuid];
        return $this->executeStatement($query, $params);
        ////return $this->select("SELECT * FROM mock_date ORDER BY id ASC LIMIT ?", ["i", $limit]);
		//mysqli_query($this->connection,"INSERT INTO link_app VALUES (NULL, $visitorid, $uuid, now())");

    }
	public function visitorIdExists($id)
    {
		$query = "SELECT id FROM visitorids WHERE id = ?";
        $params = ['i', $id];

        $stmt = $this->executeStatement($query, $params);
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            return true;
        } else {
            $newVisitorIdQuery = "INSERT INTO visitorids (id, visitorType, routeId) VALUES (?, 0, NULL)";
            $params = ['i', $id];

            $stmt = $this->executeStatement($newVisitorIdQuery, $params);

            if ($stmt->affected_rows > 0) {
                return "You are now registered";
            } else {
                return "Error adding user in database";
            }
        }

        ////return $this->select("SELECT * FROM mock_date ORDER BY id ASC LIMIT ?", ["i", $limit]);
		//$result = mysqli_query($this->connection,"SELECT * FROM visitorids WHERE id = $id");
		//$data = mysqli_fetch_array($result, MYSQLI_NUM);
		//if($data) {
		//	//echo "visitorId already exists<br/>";
		//}
		//else
		//{
    	//	$newVisitorId="INSERT INTO visitorids(id, visitorType, routeId) values($id, 0, NULL)";
		//	if (mysqli_query($this->connection,$newVisitorId))
		//	{
		//		echo "You are now registered";
		//	}
		//	else
		//	{
		//		echo "Error adding user in database";
		//	}
		//}

    }
	public function updateCounter()
    {
		$query = "CALL UpdateVipCounter()";

        $stmt = $this->executeStatement($query);

        if ($stmt === false) {
            return "Error updating counter: " . $this->connection->error;
        }

        $stmt->free_result();
        $this->connection->next_result();

        return $stmt->affected_rows;
        ////return $this->select("SELECT * FROM mock_date ORDER BY id ASC LIMIT ?", ["i", $limit]);
		//$result = mysqli_query($this->connection,"CALL UpdateVipCounter()") or die(mysqli_error($this->connection));
		//$row = mysqli_fetch_array($result, MYSQLI_ASSOC);
		//$result->close();
		//$this->connection->next_result();
		//return $row['new_vipVisitorsCount'];
		

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

        if ($response === false) {
            $error = curl_error($curl);
            curl_close($curl);
            throw new Exception("cURL error: $error");
        }

        curl_close($curl);
        return $response;
		
		//$curl = curl_init();

		//curl_setopt_array($curl, array(
		//CURLOPT_URL => 'https://sensorslab-nodered.cloud-apps.eu/api/v1/visitors/data/' . $visitor,
		//CURLOPT_RETURNTRANSFER => true,
		//CURLOPT_ENCODING => '',
		//CURLOPT_MAXREDIRS => 10,
		//CURLOPT_TIMEOUT => 0,
		//CURLOPT_FOLLOWLOCATION => true,
		//CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
		//CURLOPT_CUSTOMREQUEST => 'GET',
		//));

		//$response = curl_exec($curl);

		//// Check for errors
		//if ($response === false) {
		//	$error = curl_error($curl);
		//	curl_close($curl);
		//	return "cURL error: $error";
		//}

		//curl_close($curl);
		//return $response;
	}


	public function getVipVisitorLatestData($visitor)
	{
		$vipData = json_decode($this->callAPI($visitor), true);

        $timestamp = new DateTime();
        $timestamp->setTimestamp($vipData[0]['timestamp']);
        $formattedTimestamp = $timestamp->format('Y-m-d H:i:s');

        $date = date("Y-m-d H:i:s", $vipData[0]['timestamp']);

        $query = "INSERT INTO vipvisitorsdata (time, rssi, visitor_id, sensor_id) VALUES (?, ?, ?, ?)";
        $params = ['ssss', $date, strval(intval($vipData[0]['rssi'])), strval($vipData[0]['visitorID']), strval($vipData[0]['cellID'])];

        $stmt = $this->executeStatement($query, $params);

        if ($stmt === false) {
            return mysqli_error($this->connection);
        }

        return $vipData[0];
		//		$vipData = json_decode($this->callAPI($visitor),true);

		//		// Create a new instance of DateTime and format it
		//		$timestamp = new DateTime();
		//		$timestamp->setTimestamp($vipData[0]['timestamp']);
		//		$timestamp = $timestamp->format('Y-m-d H:i:s');

		//		$date = date("Y-m-d H:i:s", $vipData[0]['timestamp']);
		//$result = mysqli_query($this->connection, "INSERT INTO vipvisitorsdata(time, rssi, visitor_id, sensor_id) values('$date', '".strval(intval($vipData[0]['rssi']))."', '".strval($vipData[0]['visitorID'])."', '".strval($vipData[0]['cellID'])."')");

		//		// Check for errors
		//		if (!$result) {
		//			return mysqli_error($this->connection);
		//		}

		//		return $vipData[0];
	}

	public function changeEventStatus($num, $VIPAdded)
    {
		if ($num == 1 && $VIPAdded) {
            $dropEventQuery = "DROP EVENT IF EXISTS `call_procedure_every_10_seconds`;";
            $createEventQuery = "CREATE EVENT `call_procedure_every_10_seconds` ON SCHEDULE EVERY 5 SECOND STARTS NOW() ON COMPLETION PRESERVE ENABLE DO CALL GetNewVipVisitorsData();";
        } elseif ($num == 0) {
            $dropEventQuery = "DROP EVENT IF EXISTS `call_procedure_every_10_seconds`;";
            $createEventQuery = "CREATE EVENT `call_procedure_every_10_seconds` ON SCHEDULE EVERY 5 SECOND STARTS NOW() ON COMPLETION PRESERVE DISABLE DO CALL GetNewVipVisitorsData();";
        } else {
            return; // Handle other cases or return an error message if needed
        }

        $this->executeStatement($dropEventQuery);
        $this->executeStatement($createEventQuery);
        //if($num == 1 && $VIPAdded){
			
		//	mysqli_query($this->connection,"DROP EVENT IF EXISTS `call_procedure_every_10_seconds`;") or die(mysqli_error($this->connection));
		//	mysqli_query($this->connection,"CREATE EVENT `call_procedure_every_10_seconds` ON SCHEDULE EVERY 5 SECOND STARTS NOW() ON COMPLETION PRESERVE ENABLE DO CALL GetNewVipVisitorsData();") or die(mysqli_error($this->connection));
		
		//}
		//else if($num == 0){
		//	mysqli_query($this->connection,"DROP EVENT IF EXISTS `call_procedure_every_10_seconds`;") or die(mysqli_error($this->connection));
		//	mysqli_query($this->connection,"CREATE EVENT `call_procedure_every_10_seconds` ON SCHEDULE EVERY 5 SECOND STARTS NOW() ON COMPLETION PRESERVE DISABLE DO CALL GetNewVipVisitorsData();") or die(mysqli_error($this->connection));
		//	}

    }
}
?>