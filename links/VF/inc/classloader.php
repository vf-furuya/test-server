<?php
	/**
	 * クラスファイルの読み込み処理
	 */

	include_once _AS_CLS_DIR . 'ASLog.cls';
	include_once _AS_CLS_DIR . 'ASError.cls';
	include_once _AS_CLS_DIR . 'ASTools.cls';
	include_once _AS_CLS_DIR . 'ASHtml.cls';
	include_once _AS_CLS_DIR . 'ASParameter.cls';
	include_once _AS_CLS_DIR . 'ASValidater.cls';
	include_once _AS_CLS_DIR . 'ASMailSend.cls';
	include_once _AS_CLS_DIR . 'ASDataObjects.cls';
	include_once _AS_CLS_DIR . 'DBConnection.cls';
	include_once _AS_CLS_DIR . 'reload.cls';

	include_once _AS_CLS_DIR . 'Logger.cls';
	include_once _AS_CLS_DIR . 'ASCrypt.cls';
	include_once _AS_CLS_DIR . 'reload.cls';


function AST__autoload($class_name) {
	$table_class = _CLS_DIR . "common/VF" . $class_name . ".cls";
	if (file_exists($table_class)) {
		include_once ($table_class);
		return;
	}

	$table_class = _CLS_DIR . "base/VF" . $class_name . ".cls";
	if (file_exists($table_class)) {
		include_once ($table_class);
		return;
	}

	$table_class = _CLS_DIR . "as/" . $class_name . ".cls";
	if (file_exists($table_class)) {
		include_once ($table_class);
		return;
	}
}
spl_autoload_register("AST__autoload");
?>