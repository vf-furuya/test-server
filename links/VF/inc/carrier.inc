<?php
	// 変数
	$MY_CARRIER = 0;
	$ISPC = FALSE; // PC ブラウザ

	// 定数
	$C_ETC = 1;
	$C_DOCOMO = 2;
	$C_VODAFONE = 3;
	$C_EZWEB = 4;

	// 判別用
	$S_DOCOMO = "DoCoMo";
	$S_VODAFONE = "J-PHONE";
	$S_EZWEB = "UP.Browser";
	
	// 簡単判別
	$DOCOMO = FALSE;
	$VODAFONE = FALSE;
	$EZ = FALSE;

	$MY_CARRIER_NAME[1] = "PC";
	$MY_CARRIER_NAME[2] = "DoCoMo";
	$MY_CARRIER_NAME[3] = "vodafone";
	$MY_CARRIER_NAME[4] = "ezweb";

	$CARRIER_SUFFIX[1] = '4pc';
	$CARRIER_SUFFIX[2] = '4i';
	$CARRIER_SUFFIX[3] = '4v';
	$CARRIER_SUFFIX[4] = '4k';

	$HTTP_USER_AGENT = $_SERVER['HTTP_USER_AGENT'];

	if (stristr($HTTP_USER_AGENT,$S_DOCOMO) != FALSE) {
		header("Content-Type: text/html; charset=SJIS");
		header("Expires: Sat, 01 Jan 2000 00:00:00 GMT");				// Date in the past
		header("Last-Modified: ". gmdate("D, d M Y H:i:s"). " GMT");		// always modified
		header("Cache-Control: no-cache, must-revalidate");			// HTTP/1.1
		header("Pragma: no-cache");									// HTTP/1.0

		$MY_CARRIER = $C_DOCOMO;
		$ENCODING = 'SJIS';
		$DOCOMO = TRUE;
	}
	else if (stristr($HTTP_USER_AGENT,$S_VODAFONE) != FALSE  || stristr($HTTP_USER_AGENT,"Vodafone") != FALSE || stristr($HTTP_USER_AGENT,"MOT-V980") != FALSE || stristr($HTTP_USER_AGENT,"MOT-C980") != FALSE) {
		header("Cache-Control: no-cache, must-revalidate");			// HTTP/1.1
		header("Pragma: no-cache");									// HTTP/1.0

		$MY_CARRIER = $C_VODAFONE;
		$ENCODING = 'SJIS';
		$VODAFONE = TRUE;
	}
	else if (stristr($HTTP_USER_AGENT,$S_EZWEB) != FALSE) {
		//Header("Content-type: multipart/mixed");
		//Header("Content-type: application/x-up-casheop");
		//Header("Content-type: text/x-hdml; charset=Shift_JIS");
		header("Cache-Control: no-cache");           // HTTP/1.1
		header("Expires: Sat, 01 Jan 2000 00:00:00 GMT");				// Date in the past
		header("Last-Modified: ". gmdate("D, d M Y H:i:s"). " GMT");		// always modified
		header("Pragma: no-cache");									// HTTP/1.0

		$MY_CARRIER = $C_EZWEB;
		$ENCODING = 'SJIS';
		$EZ = TRUE;
	}
	else {
		#header("Content-Type: text/html; charset=utf-8");

		$MY_CARRIER = $C_ETC;
		$ENCODING = 'UTF-8';
		$ISPC = TRUE;
	}

	mb_http_output($ENCODING);
	//ob_start('mb_output_handler');
?>
