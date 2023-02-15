<?php

//Get Heroku ClearDB connection information
//$cleardb_url = parse_url(getenv("CLEARDB_DATABASE_URL"));
//$cleardb_server = $cleardb_url["host"];
//$cleardb_username = $cleardb_url["user"];
//$cleardb_password = $cleardb_url["pass"];
//$cleardb_db = substr($cleardb_url["path"],1);
$active_group = 'default';
$query_builder = TRUE;

define("DB_HOST", 'localhost');
define("DB_USERNAME", 'id20059529_user');
define("DB_PASSWORD", 'u6T9<0t(I_wB6N50');
define("DB_DATABASE_NAME", 'id20059529_restapidatabase');


/*define("DB_HOST", 'localhost');
define("DB_USERNAME", 'root');
define("DB_PASSWORD", '');
define("DB_DATABASE_NAME", 'tracksystem');*/

/*define("DB_HOST", $cleardb_server);
define("DB_USERNAME", $cleardb_username);
define("DB_PASSWORD", $cleardb_password);
define("DB_DATABASE_NAME", $cleardb_db);*/
?>