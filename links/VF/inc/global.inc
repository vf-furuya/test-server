<?php
	// PHP5によるタイムゾーンの設定を追加
	date_default_timezone_set('Asia/Tokyo');

	// 日付・時刻関連
	$TODAY = date("Y/m/d");
	$NOW = date("Y/m/d H:i");
	$NOWFORFILE = date("Ymd_His");
	$BEGINDATE = mktime(0,0,0,4,1,2001);
	$TODAYDATE = mktime(0,0,0,date("m"),date("d"),date("Y"));
	$NOWYEAR = date("Y");

	###############################################
	#SSL対応端末判断
	###############################################

	//include_once("non_ssl_terminals.php");
	function is_NonSSLTerminal(){
		return FALSE;
	}


?>