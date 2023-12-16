<?php
    error_reporting(E_ERROR | E_PARSE);
    include("../UserManagement.php");
    $score = $_POST["score"];
    $combo = $_POST["combo"];
    $accuracy = $_POST["accuracy"];
    $beatmapid = $_POST["beatmapid"];
    $h3 = $_POST["h3"];
    $h1 = $_POST['h1'];
    $h5 = $_POST['h5'];
    $hm = $_POST['hm'];
    $name = $_POST['name'];
    $token = $_POST['token'];
    $ez = $_POST['ez'];
    $nf = $_POST['nf'];
    $hr = $_POST['hr'];
    $sd = $_POST['sd'];
    $hd = $_POST['hd'];
    $rid = $_POST['rid'];
    date_default_timezone_set('Asia/Taipei');
    date_default_timezone_get();
    $date_ = date('m/d/Y h:i:s a', time());

    $servername = "--";
    $username = "--";
    $password = "--";
    $dbname = "osu";

    if(!isset($score) || !isset($combo) || !isset($accuracy) || !isset($beatmapid) || !isset($h3) || !isset($h1) || !isset($h5) || !isset($hm) || !isset($name) || !isset($token) || !isset($rid))
    {
        die("ERR_INVALID_DATA");
    }

    function DoesTableExists($pdo, $table) {
        try {
            $result = $pdo->query("SELECT 1 FROM {$table} LIMIT 1");
        } catch (Exception $e) {
            return FALSE;
        }

        return $result !== FALSE;
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
    if($steamid == "-1") {
        die("ERR_INVALID_USER");
    }

    $pScore = intval($score);
    $pCombo = intval($combo);
    $p300 = intval($h3);
    $p100 = intval($h1);
    $p50 = intval($h5);
    $pMiss = intval($hm);
    $pBaseScore = ($p300 * 300) + ($p100 * 100) + ($p50 * 50);
    if($ez == "false" && $nf == "false")
    {
        if($pScore < $pBaseScore) {
            ApplyBan($steamid, "Autoban - suspicious result data");
            die("ERR_BANNED (Autoban - suspicious result data)");
        }
    }
    if($pScore < 0 || $pCombo < 0 || $pScore >= 2147010000) {
         ApplyBan($steamid, "Autoban - suspicious result data");
        die("ERR_BANNED (Autoban - suspicious result data)");
    }

    if(DoesTableExists($pdconn, "leaderboard")) {
        $pre = $pdconn->prepare("INSERT INTO leaderboard (name, steamid, score, combo, beatmapid, date, h300, h100, h50, hmiss, accuracy, ez, nf, hr, sd, hd, rid)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $pre->execute([
            $name, $steamid, $score, $combo, $beatmapid, $date_, $h3, $h1, $h5, $hm, $accuracy, $ez, $nf, $hr, $sd, $hd, $rid
        ]);
    }
    else
    {
        $sql = "CREATE TABLE IF NOT EXISTS leaderboard (
            id INT AUTO_INCREMENT primary key NOT NULL,
            name VARCHAR(64) NOT NULL,
            steamid VARCHAR(64) NOT NULL,
            score INT NOT NULL,
            combo INT NOT NULL,
            beatmapid INT NOT NULL,
            date VARCHAR(64) NOT NULL,
            h300 INT NOT NULL,
            h100 INT NOT NULL,
            h50 INT NOT NULL,
            hmiss INT NOT NULL,
            accuracy FLOAT NOT NULL
        )";
        $pdconn->query($sql);

        $pre = $pdconn->prepare("INSERT INTO leaderboard (name, steamid, score, combo, beatmapid, date, h300, h100, h50, hmiss, accuracy)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $pre->execute([
            $name, $steamid, $score, $combo, $beatmapid, $date_, $h3, $h1, $h5, $hm, $accuracy
        ]);
    }
    if(intval($score) <= 0) {
        $score = 100;
    }
    $rkscore = (intval($score) / 5000);
    $req = "UPDATE userdata SET
            totalplays = totalplays + 1,
            accuracy = accuracy + '$accuracy',
            rankingscore = rankingscore + '$rkscore'
            WHERE steamid = '$steamid';";
    $pdconn->query($req);
    echo("PASS_REPLAY");
?>