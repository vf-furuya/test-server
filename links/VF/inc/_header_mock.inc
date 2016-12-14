<?php
	########################################################
	# 各種INCLUDE処理
	########################################################

	include_once 'setting.properties';
	include_once _INC_DIR . 'global.inc';
	include_once _INC_DIR . 'carrier.inc';
	include_once _INC_DIR . 'function.inc';

	include_once _INC_DIR . 'classloader.php';

	########################################################
	# 携帯アクセスをはじく
	########################################################

	if (!$ISPC) {
		$myHtml = new ASHtml('_sorry_busy_mobile.tpl', $C_ETC, TRUE);
		unset($myHtml);
		exit;
	}

