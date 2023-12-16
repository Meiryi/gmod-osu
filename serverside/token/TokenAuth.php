<?php
	$login_url_params = [
	    'openid.ns'         => 'http://specs.openid.net/auth/2.0',
	    'openid.mode'       => 'checkid_setup',
	    'openid.return_to'  => 'https://osu.gmaniaserv.xyz/token/TokenRedist.php',
	    'openid.identity'   => 'http://specs.openid.net/auth/2.0/identifier_select',
	    'openid.claimed_id' => 'http://specs.openid.net/auth/2.0/identifier_select',
	];
	$steam_login_url = 'https://steamcommunity.com/openid/login'.'?'.http_build_query($login_url_params, '', '&');
	header("location: $steam_login_url");
	exit();
?>