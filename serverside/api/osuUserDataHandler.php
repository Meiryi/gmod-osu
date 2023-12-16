<?php
    include('../UserManagement.php');
    error_reporting(E_ERROR | E_PARSE);
    $token = $_POST["token"];

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

    if(!isset($token)) {
        die("ERR_INVALID_DATA");
    }

    try {
        $pdconn = new PDO('mysql:host='.$servername.';dbname='.$dbname.';charset=utf8mb4', $username, $password, array(PDO::ATTR_TIMEOUT => 5));
        $pdconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    }   catch(PDOException $e) {
        die("ERR_DATABSE_OFFLINE");
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

    $rqd = "SELECT * FROM userdata WHERE steamid = '$steamid'";
    $result = $pdconn->query($rqd);
    if($result->rowCount() == 0) // User doesn't exists
    {
        $apd = "INSERT INTO userdata (steamid, totalplays, accuracy, rankingscore)
        VALUES ('$steamid', 0, 0, 0)";
        $pdconn->query($apd);
    }

    $req = "SELECT * FROM userdata ORDER BY `rankingscore` DESC";
    $ret = $pdconn->query($req);
    $_ret = $ret->fetchAll(PDO::FETCH_ASSOC);
    $userRanking = 0;

    foreach($_ret as $key => $value) {
        $stop = false;
        foreach($value as $x => $y) {
            if($x == "steamid") {
                if($y == $steamid) {
                    $userRanking = $key + 1;
                    $stop = true;
                    break;
                }
            }
        }
        if($stop) { break; }
    }

    $query = "SELECT accuracy, rankingscore, totalplays FROM userdata WHERE steamid = '$steamid'";
    $stmt = $pdconn->query($query);
    $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $data[0]['ranking'] = $userRanking;
    $jsonData = json_encode($data, JSON_PRETTY_PRINT);
    echo $jsonData;
?>