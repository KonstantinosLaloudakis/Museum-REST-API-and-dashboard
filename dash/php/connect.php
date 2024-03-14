 <?php
$servername = "localhost";
$username = "user";
$password = "ware17gera$";
$database = "mea";

try {
    //$conn = $mysqli = new mysqli("localhost", "root", "", "tracksystem");
    $conn = $mysqli = new mysqli($servername, $username, $password, $database);
	 /*new PDO("mysqli:host=$servername;dbname=$database", $username, $password);*/
    // set the PDO error mode to exception
    /*$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);*/
    } catch(PDOException $e) {    
    echo "Connection failed: " . $e->getMessage();
    }
?>