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
	# パラメータ受け取り
	########################################################

	$work = ASParameter::getNumericValue('work');

	########################################################
	# パラメータ取得処理
	########################################################

	include_once '_getParameter.inc';

