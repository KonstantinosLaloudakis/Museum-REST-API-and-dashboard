<?php
require __DIR__ . "/inc/bootstrap.php";
 
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri = explode( '/', $uri );
if ((isset($uri[2]) && $uri[2] != 'setVIP' && $uri[2] != 'unsetVIP' && $uri[2] != 'visitorData' && $uri[2] != 'linkUuid')) {
    header("HTTP/1.1 404 Not Found");
    exit();
}
 
require PROJECT_ROOT_PATH . "/Controller/Api/UserController.php";
 
$objFeedController = new UserController();
$strMethodName = $uri[2] . 'Action';
$objFeedController->{$strMethodName}();
?>

<!DOCTYPE html>
<html>
   <head>
      <meta http-equiv = "refresh" content = "0; url = https://museumrestapi.000webhostapp.com/dash/index.php" />
   </head>
   <body>
   </body>
</html>