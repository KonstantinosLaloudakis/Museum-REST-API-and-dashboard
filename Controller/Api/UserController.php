<?php
class UserController extends BaseController
{
    /**
     * "/user/list" Endpoint - Get list of users
     */
    public function setVIPAction()
    {
        $strErrorDesc = '';
        $requestMethod = $_SERVER["REQUEST_METHOD"];
 
        if (strtoupper($requestMethod) == 'POST') {
            try {
                $userModel = new UserModel();
 
                $id = $_POST['visitorId'];
				if(empty($id)){
					echo "VisitorId is empty";
				}

				$visitorType = $_POST['visitorType'];
				if(empty($visitorType)){
					echo "VisitorType is empty";
				}
				if (isset($_POST['routeId'])) {
				echo "routeId exists";

					$routeId = $_POST['routeId'];
				}
				else{
				echo "routeId not exists";

					$routeId = NULL;
				}

				$userModel->visitorIdExists($id);
				echo "Checked if exists";

                $userModel->changeVIPStatus($visitorType, $routeId, $id);
				echo "Changed status";

                $userModel->InsertToVipVisitorsInfo($visitorType, $routeId);
				echo "Inserted to new table";

                $num = $userModel->updateCounter();
				echo "Updated counter";

				$userModel->changeEventStatus($num, true);
				echo "Changed event status";

                //$responseData = json_encode($arrUsers);
            } catch (Error $e) {
                $strErrorDesc = $e->getMessage().'Something went wrong! Please contact support.';
                $strErrorHeader = 'HTTP/1.1 500 Internal Server Error';
            }
        } else {
            $strErrorDesc = 'Method not supported';
            $strErrorHeader = 'HTTP/1.1 422 Unprocessable Entity';
        }
 
        // send output
        if (!$strErrorDesc) {
            $this->sendOutput(
                array('Content-Type: application/json', 'HTTP/1.1 200 OK')
            );
        } else {
            $this->sendOutput(json_encode(array('error' => $strErrorDesc)), 
                array('Content-Type: application/json', $strErrorHeader)
            );
        }
    }

	public function unsetVIPAction()
    {
        $strErrorDesc = '';
        $requestMethod = $_SERVER["REQUEST_METHOD"];
 
        if (strtoupper($requestMethod) == 'POST') {
            try {
                $userModel = new UserModel();
 
				$id = $_POST['visitorId'];
				if(empty($id)){
					echo "VisitorId is empty";
				}
 
                $userModel->changeVIPStatus(0, null, $id);
                $num = $userModel->updateCounter();
				$userModel->changeEventStatus($num, false);
                //$responseData = json_encode($arrUsers);
            } catch (Error $e) {
                $strErrorDesc = $e->getMessage().'Something went wrong! Please contact support.';
                $strErrorHeader = 'HTTP/1.1 500 Internal Server Error';
            }
        } else {
            $strErrorDesc = 'Method not supported';
            $strErrorHeader = 'HTTP/1.1 422 Unprocessable Entity';
        }
 
        // send output
        if (!$strErrorDesc) {
            $this->sendOutput(
                array('Content-Type: application/json', 'HTTP/1.1 200 OK')
            );
        } else {
            $this->sendOutput(json_encode(array('error' => $strErrorDesc)), 
                array('Content-Type: application/json', $strErrorHeader)
            );
        }
    }

	public function visitorDataAction()
    {
        $strErrorDesc = '';
        $requestMethod = $_SERVER["REQUEST_METHOD"];
        $arrQueryStringParams = $this->getQueryStringParams($_SERVER['REQUEST_URI'],"id");
 
        if (strtoupper($requestMethod) == 'GET') {
            try {
				$userModel = new UserModel();
							
				$id = '' ;
				if (isset($arrQueryStringParams["id"]) && $arrQueryStringParams["id"]) {
					$id = $arrQueryStringParams["id"];
				}
			
				$vipData = $userModel->getVipVisitorLatestData($id);
				
				if(empty($vipData)){
					$response["status"] = "false";
					$response["message"] = "No existant visitor!";
				 }
				 else{
					$timestamp = new DateTime();
					$timestamp->setTimestamp($vipData['timestamp']);
					$timestamp = $timestamp->format('Y-m-d H:i:s');
			
					$Data['time'] = $timestamp;
					$Data['rssi'] = $vipData['rssi'];
					$Data['visitor_id'] = $vipData['visitorID'];
					$Data['sensor_id'] = $vipData['cellID'];
			
					$response["status"] = "true";
					$response["message"] = "Visitor Details";
					$response["visitor"] = $Data;
				 }
				
				echo json_encode($response);
			} catch (Error $e) {
				$strErrorDesc = $e->getMessage().'Something went wrong! Please contact support.';
				$strErrorHeader = 'HTTP/1.1 500 Internal Server Error';
			}
        } else {
            $strErrorDesc = 'Method not supported';
            $strErrorHeader = 'HTTP/1.1 422 Unprocessable Entity';
        }
 
        // send output
        if (!$strErrorDesc) {
            $this->sendOutput(json_encode($response),
                array('Content-Type: application/json', 'HTTP/1.1 200 OK')
            );
        } else {
            $this->sendOutput(json_encode(array('error' => $strErrorDesc)), 
                array('Content-Type: application/json', $strErrorHeader)
            );
        }
    }

	public function linkUuidAction()
    {
        $strErrorDesc = '';
        $requestMethod = $_SERVER["REQUEST_METHOD"];
 
        if (strtoupper($requestMethod) == 'POST') {
            try {
                $userModel = new UserModel();
 
				$uuid = $_POST['uuid'];
				if(empty($uuid)){
					echo "Uuid is empty";
				}

				$visitorId = $_POST['visitorId'];
				if(empty($visitorId)){
					echo "VisitorId is empty";
				}

				$userModel->linkUuidWithVisitorId($uuid,$visitorId);

				//echo json_encode($response);
                //$responseData = json_encode($arrUsers);
            } catch (Error $e) {
                $strErrorDesc = $e->getMessage().'Something went wrong! Please contact support.';
                $strErrorHeader = 'HTTP/1.1 500 Internal Server Error';
            }
        } else {
            $strErrorDesc = 'Method not supported';
            $strErrorHeader = 'HTTP/1.1 422 Unprocessable Entity';
        }
 
        // send output
        if (!$strErrorDesc) {
            $this->sendOutput(array('Content-Type: application/json', 'HTTP/1.1 200 OK'));
        } else {
            $this->sendOutput(json_encode(array('error' => $strErrorDesc)), 
                array('Content-Type: application/json', $strErrorHeader)
            );
        }
    }
}
?>