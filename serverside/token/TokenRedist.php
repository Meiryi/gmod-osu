<?php
	function pArr($arr) {
		return '<pre>'.print_r($arr, true).'</pre>';
	}
	function generateToken($len = 32) {
		$char = "0123456789abcdef";
		$clen = strlen($char);
		$ret = '';
		for($i = 0; $i < $len; $i++)
		{
			$ret .= $char[random_int(0, $clen - 1)];
		}
		return $ret;
	}

	$arr = $_GET;
	if(count($arr) <= 0)
		{
			die("ERR_INVALID_RETURN");
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
    $ret = $pdconn->query("SELECT * FROM banned WHERE steamid = '$steamid64'");
    $data = $ret->fetchAll(PDO::FETCH_ASSOC);
    echo "<body style='background-color:white'>";
    if(count($data) > 0) // banned
    {
 		echo "<script>";
		echo "console.log('RUNLUA:OSU.ClientToken = \"NULL\"');";
		echo "console.log('RUNLUA:OSU.LoggedIn = true');";
		echo "console.log('RUNLUA:OSU.UserBanned = true');";
		echo "console.log('RUNLUA:OSU:WriteToken()');";
		echo "</script>";

		echo("This account is banned.");
		echo("     ->Appeal your ban with Meika, or playing as a guest.");
    }
    else
    { // not banned
    	$date = date("Y-m-d H:i:s");
    	$ret = $pdconn->query("SELECT * FROM tokens WHERE steamid = '$steamid64'");
	    $data = $ret->fetchAll(PDO::FETCH_ASSOC);
	    if(count($data) > 0) // banned
	    {
	    	$token = $data[0]['token'];
			echo "<script>";
			echo "console.log('RUNLUA:OSU.ClientToken = \"".$token."\"');";
			echo "console.log('RUNLUA:OSU.LoggedIn = true');";
			echo "console.log('RUNLUA:OSU:WriteToken()');";
			echo "</script>";

			echo("Token :".$token);
	    }
	    else
	    {
	    	$token = generateToken();
	        $sth = $pdconn->prepare("INSERT INTO tokens (token, steamid, createdate)
        	VALUES(?, ?, ?)");
			$sth->execute([
			  $token,
			  $steamid64,
			  $date
			]);
			echo "<script>";
			echo "console.log('RUNLUA:OSU.ClientToken = \"".$token."\"');";
			echo "console.log('RUNLUA:OSU.LoggedIn = true');";
			echo "console.log('RUNLUA:OSU:WriteToken()');";
			echo "</script>";

			echo("Token :".$token);
	    }
    }
?>