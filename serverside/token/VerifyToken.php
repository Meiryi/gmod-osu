<?php
	error_reporting(E_ERROR | E_PARSE);
	$token = $_POST['token'];
	if(!isset($token)) {
		die("ERR_INVALID_DATA");
	}
    if($token == "NULL") {
        die("BANNED");
    }
	$identify = $arr['openid_identity'];
	$steamid64 = str_replace("https://steamcommunity.com/openid/id/", "", $identify);
    $servername = "--";
    $username = "--";
    $password = "--";
    $dbname = "osu";

    try {
        $pdconn = new PDO('mysql:host='.$servername.';dbname='.$dbname.';charset=utf8mb4', $username, $password, array(PDO::ATTR_TIMEOUT => 5));
        $pdconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }   catch(PDOException $e) {
        die("ERR_DATABSE_OFFLINE");
    }

    $pre = $pdconn->prepare("SELECT steamid FROM tokens WHERE token = ?");
    $pre->execute([$token]);
    $ret = $pre->fetchAll();

    $steamid = "null";

    if(count($ret) <= 0) { // not exist
    	die("NON-EXIST");
    }
    else
    { // exists
    	$steamid = $ret[0]['steamid'];
    }

    $pre = $pdconn->prepare("SELECT * FROM banned WHERE steamid = ?");
    $pre->execute([$steamid]);
    $data = $pre->fetchAll();
    if(count($data) > 0) // banned
    {
    	echo("BANNED-".$data[0]['reason']);
    }
    else
    {
    	echo("PASS");
    }
?>