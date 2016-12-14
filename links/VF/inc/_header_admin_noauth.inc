<?php
	$isAdminMode = TRUE;

	########################################################
	# 各種INCLUDE処理
	########################################################

	include_once 'setting.properties';
	include_once _INC_DIR . 'global.inc';
	include_once _INC_DIR . 'carrier.inc';
	include_once _INC_DIR . 'function.inc';

	include_once _INC_DIR . 'classloader.php';

	########################################################
	# データベース接続
	########################################################

	$myDB = new DBConnection(_MAIN_DB, _HOST_NAME, _USER_NAME, _PASSWD, _PORT);
	if (!$myDB->Connection) {
		trigger_error('DBConnection Failed.', E_USER_ERROR);
	}

?>