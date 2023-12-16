<?php
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
	function CheckUserStatus($steamid)
	{
		global $pdconn;
		$pre = $pdconn->prepare("SELECT * FROM banned WHERE steamid = ?");
		$pre->execute([$steamid]);
		$ret = $pre->fetchAll();
		if(count($ret) > 0) {
			return true;
		}
	}
	function ApplyBan($steamid, $reason)
	{
		global $pdconn;
		$pre = $pdconn->prepare("INSERT INTO banned (steamid, reason)
        VALUES (?, ?)");
        $pre->execute([$steamid, $reason]);
	}
?>