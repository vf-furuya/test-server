<?php
	header("Content-Type: text/html; charset=UTF-8");
	$get_site = split(";", $_GET['files']);
	//$site_cnt = count($get_site);
	foreach ($get_site as $site_url) {
		//echo $site_url;
		//$_ = $site_url;
		if (!empty($site_url)) {
			$_ = 'http://' .  $_SERVER['HTTP_HOST'] . $site_url;
			$_ = file_get_contents($_);
			mb_convert_variables('UTF-8', 'SJIS', $_);
			
			echo $_;
		}
	}
?>
