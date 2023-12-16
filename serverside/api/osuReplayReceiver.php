<?php
	$ReplayID = $_GET['rID'];
	$MapID = $_GET['uID'];
	$token = $_GET['token'];
	include("../UserManagement.php");

	if(!isset($ReplayID) || !isset($MapID)) {
		die("ERR_INVALID_DATA");
	}
	
    $steamid = "-1";
    $pre = $pdconn->prepare("SELECT * FROM tokens WHERE token = ?");
    $pre->execute([$token]);
    $ret = $pre->fetchAll();
    if(count($ret) <= 0) {
        die("ERR_TOKEN_INVALID");
    }
    else
    {
        $steamid = $ret[0]['steamid'];
        if(CheckUserStatus($steamid)) { // Banned
            die("ERR_BANNED");
        }
    }
    if($steamid == "-1") {
        die("ERR_INVALID_USER");
    }

	$requestBody = file_get_contents('php://input');
	$fnPath = "Replay/".$MapID."/".$ReplayID.".gosr";
	if (file_exists("Replay/".$MapID)) {
		$f = fopen($fnPath, "w");
		fwrite($f, $requestBody);
		fclose($f);
	} else {
		mkdir("Replay/".$MapID);
		$f = fopen($fnPath, "w");
		fwrite($f, $requestBody);
		fclose($f);
	}

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
    $pre = $pdconn->prepare("UPDATE leaderboard SET rep = '1' WHERE rid = ?");
    $pre->execute([
        $ReplayID
    ]);
?>