 <?php
/*$servername = "localhost";
$username = "id20059529_user";
$password = "u6T9<0t(I_wB6N50";
$database = "id20059529_restapidatabase";*/

$servername = "localhost";
$username = "root";
$password = "";
$database = "tracksystem";

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