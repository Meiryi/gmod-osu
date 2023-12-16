<?php
	error_reporting(E_ERROR | E_PARSE);

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

    $pre = $pdconn->prepare("SELECT * FROM userdata");
    $pre->execute();
    $ret = $pre->fetchAll();
    $jsonData = json_encode($ret, JSON_PRETTY_PRINT);
    echo($jsonData);
?>