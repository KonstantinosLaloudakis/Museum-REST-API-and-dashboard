<?php
class UserController extends BaseController
{
	/**
	 * "/user/list" Endpoint - Get list of users
	 */
	public function setVIPAction()
	{
		$strErrorDesc = '';
		$responseHeaders = array('Content-Type: application/json');
		$responseCode = 200;

		$requestMethod = $_SERVER["REQUEST_METHOD"];

		if (strtoupper($requestMethod) == 'POST') {
			try {
				$userModel = new UserModel();

				$id = $_POST['visitorId'];
				if (empty($id)) {
					$strErrorDesc = "VisitorId is empty";
				}

				$visitorType = $_POST['visitorType'];
				if (empty($visitorType)) {
					$strErrorDesc = "VisitorType is empty";
				}

				if (isset($_POST['routeId'])) {
					$routeId = $_POST['routeId'];
				} else {
					$routeId = NULL;
				}

				if (!$strErrorDesc) {
					$userModel->visitorIdExists($id);
					if ($userModel->changeVIPStatus($visitorType, $routeId, $id, false)) {
						$userModel->InsertToVipVisitorsInfo($visitorType, $routeId);
						$num = $userModel->updateCounter();
						$userModel->changeEventStatus($num, true);
					}
				}
			} catch (Exception $e) {
				$strErrorDesc = 'Something went wrong! Please contact support.';
				$responseCode = 500;
			}
		} else {
			$strErrorDesc = 'Method not supported';
			$responseCode = 422;
		}

		// Send output
		if (!$strErrorDesc) {
			$this->sendOutput($responseHeaders, 'HTTP/1.1 200 OK');
		} else {
			$this->sendOutput(
				array_merge($responseHeaders, array('HTTP/1.1 ' . $responseCode)),
				json_encode(array('error' => $strErrorDesc))
			);
		}
	}

	public function unsetVIPAction()
	{
		$strErrorDesc = '';
		$responseHeaders = array('Content-Type: application/json');
		$responseCode = 200;

		$requestMethod = $_SERVER["REQUEST_METHOD"];

		if (strtoupper($requestMethod) == 'POST') {
			try {
				$userModel = new UserModel();

				$id = $_POST['visitorId'];
				if (empty($id)) {
					$strErrorDesc = "VisitorId is empty";
				} else {
					$userModel->changeVIPStatus(0, null, $id, true);
					$num = $userModel->updateCounter();
					$userModel->changeEventStatus($num, false);
				}
			} catch (Exception $e) {
				$strErrorDesc = 'Something went wrong! Please contact support.';
				$responseCode = 500;
			}
		} else {
			$strErrorDesc = 'Method not supported';
			$responseCode = 422;
		}

		// Send output
		if (!$strErrorDesc) {
			$this->sendOutput($responseHeaders, 'HTTP/1.1 200 OK');
		} else {
			$this->sendOutput(
				array_merge($responseHeaders, array('HTTP/1.1 ' . $responseCode)),
				json_encode(array('error' => $strErrorDesc))
			);
		}
	}

	public function visitorDataAction()
	{
		$strErrorDesc = '';
		$responseHeaders = array('Content-Type: application/json');
		$responseCode = 200;

		$requestMethod = $_SERVER["REQUEST_METHOD"];
		$arrQueryStringParams = $this->getQueryStringParams($_SERVER['REQUEST_URI'], "id");

		if (strtoupper($requestMethod) == 'GET') {
			try {
				$userModel = new UserModel();

				$id = isset($arrQueryStringParams["id"]) ? $arrQueryStringParams["id"] : '';

				$vipData = $userModel->getVipVisitorLatestData($id);

				if (empty($vipData)) {
					$response = array(
						"status" => "false",
						"message" => "No existent visitor!"
					);
				} else {
					$timestamp = new DateTime();
					$timestamp->setTimestamp($vipData['timestamp']);
					$formattedTimestamp = $timestamp->format('Y-m-d H:i:s');

					$data = array(
						'time' => $formattedTimestamp,
						//'rssi' => $vipData['rssi'],
						'visitor_id' => $vipData['userID'],
						'sensor_id' => $vipData['cellID']
					);

					$response = array(
						"status" => "true",
						"message" => "Visitor Details",
						"visitor" => $data
					);
				}

			} catch (Exception $e) {
				$strErrorDesc = 'Something went wrong! Please contact support.';
				$responseCode = 500;
			}
		} else {
			$strErrorDesc = 'Method not supported';
			$responseCode = 422;
		}

		// Send output
		if (!$strErrorDesc) {
			$this->sendOutput(
				array_merge($responseHeaders, array('HTTP/1.1 ' . $responseCode)),
				json_encode($response)
			);
		} else {
			$this->sendOutput(
				array_merge($responseHeaders, array('HTTP/1.1 ' . $responseCode)),
				json_encode(array('error' => $strErrorDesc))
			);
		}
	}

	public function linkUuidAction()
	{
		$strErrorDesc = '';
		$responseHeaders = array('Content-Type: application/json');
		$responseCode = 200;

		$requestMethod = $_SERVER["REQUEST_METHOD"];

		if (strtoupper($requestMethod) == 'POST') {
			try {
				$userModel = new UserModel();

				$uuid = $_POST['uuid'];
				if (empty($uuid)) {
					$strErrorDesc = "Uuid is empty";
				}

				$visitorId = $_POST['visitorId'];
				if (empty($visitorId)) {
					$strErrorDesc = "VisitorId is empty";
				}

				if (!$strErrorDesc) {
					$userModel->linkUuidWithVisitorId($uuid, $visitorId);
				}
			} catch (Exception $e) {
				$strErrorDesc = 'Something went wrong! Please contact support.';
				$responseCode = 500;
			}
		} else {
			$strErrorDesc = 'Method not supported';
			$responseCode = 422;
		}

		// Send output
		if (!$strErrorDesc) {
			$this->sendOutput($responseHeaders, 'HTTP/1.1 200 OK');
		} else {
			$this->sendOutput(
				array_merge($responseHeaders, array('HTTP/1.1 ' . $responseCode)),
				json_encode(array('error' => $strErrorDesc))
			);
		}
	}
}
?>