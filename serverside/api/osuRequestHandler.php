<?php
    error_reporting(E_ERROR | E_PARSE);
    include("../UserManagement.php");
    $beatmapid = $_POST["beatmapid"];
    $token = $_POST['token'];

    function DoesTableExists($pdo, $table) {
        try {
            $result = $pdo->query("SELECT 1 FROM {$table} LIMIT 1");
        } catch (Exception $e) {
            return FALSE;
        }

        return $result !== FALSE;
    }

    $servername = "--";
    $username = "--";
    $password = "--";
    $dbname = "osu";

    if(!isset($beatmapid) || !isset($token)) {
        die("ERR_INVALID_DATA");
    }

    try {
        $pdconn = new PDO('mysql:host='.$servername.';dbname='.$dbname.';charset=utf8mb4', $username, $password, array(PDO::ATTR_TIMEOUT => 5));
        $pdconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }   catch(PDOException $e) {
        die("ERR_DATABSE_OFFLINE");
    }

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

    $pre = $pdconn->prepare("SELECT name, steamid, score, combo, beatmapid, date, h300, h100, h50, hmiss, accuracy, ez, nf, hr, sd, hd, rid, rep FROM leaderboard WHERE beatmapid = ?");
    $pre->execute([$beatmapid]);
    $data = $pre->fetchAll();
    $jsonData = json_encode($data, JSON_PRETTY_PRINT);
    echo $jsonData;
?>