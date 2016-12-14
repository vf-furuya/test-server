<?php
	$isAdminMode = TRUE;

	ini_set( 'display_errors', 1 ); 
	ini_set('error_reporting', E_ALL ^ E_NOTICE);

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

	########################################################
	# ログイン判定処理
	########################################################

	# クッキーが保存されていなければ即ログイン画面
	$LOGINDATA->LoginType = $_COOKIE[_LOGINTYPE_COOKIE_NAME];
	$LOGINDATA->AccountKey = $_COOKIE[_LOGIN_COOKIE_NAME];

	if (!$LOGINDATA->LoginType || !$LOGINDATA->AccountKey) {
		header("Location: login.php?d");
		exit;
	}

	# ログイン状態の場合には権限を取得する
	else {
		########################################################
		# アドミン管理者用処理
		########################################################
		$clsAccount = new Account($myDB);

		$SearchObj = $Operator = array();
		$SearchObj['AccountKey'] = $LOGINDATA->AccountKey;
		$Operator['AccountKey'] = '=';
		$SearchObj['Disabled'] = 0;
		$Operator['Disabled'] = '=';
		$SearchObj['DelFlag'] = 0;
		$Operator['DelFlag'] = '=';

		if (!$clsAccount->getAccountByCondition($SearchObj, $Operator)) {
			trigger_error("Searching Account Failed: ", E_USER_ERROR);
			exit;
		}

		# 1件でなければログアウト
		if ($clsAccount->RecCnt != 1) {
			header("Location: login.php?e");
			exit;
		}

		$LOGINDATA->AccountCD = $clsAccount->AccountCD;
		$LOGINDATA->AccountID = $clsAccount->AccountID;
		$LOGINDATA->AccountName = $clsAccount->AccountName;
		if ($clsAccount->Authority == _LOGIN_TYPE_ADMIN_ROOT) {
			$IfAdminRoot = TRUE;
		} else if ($clsAccount->Authority == _LOGIN_TYPE_ADMIN) {
			$IfAdmin = TRUE;
		} else {
			$IfAdmin = FALSE;
		}

		unset($clsAccount);
	}

	########################################################
	# ページ毎にログイン有効期限を更新させる
	########################################################

	# LoginType
	if (!$res = setcookie (_LOGINTYPE_COOKIE_NAME, $LOGINDATA->LoginType, _LOGIN_COOKIE_TIME, _COOKIE_PATH, _COOKIE_DOMAIN)) {
		trigger_error("クッキーの設定に失敗しました。");
		exit;
	}
	# Sessionkey
	if (!$res = setcookie (_LOGIN_COOKIE_NAME, $LOGINDATA->AccountKey, _LOGIN_COOKIE_TIME, _COOKIE_PATH, _COOKIE_DOMAIN)) {
		trigger_error("クッキーの設定に失敗しました。");
		exit;
	}

	########################################################
	# その他権限条件タグを生成
	########################################################

	$IfAdminRootORAdmin = ($IfAdminRoot || $IfAdmin) ? TRUE : FALSE;
	$IfClientDummy = ($IfClient || $IfDummy) ? TRUE : FALSE;

	########################################################
	# アクセス許可チェック
	########################################################

	if ($IfAdminRoot) {
		$PageAccessAllowKey = 0;
	} else if ($IfAdmin) {
		$PageAccessAllowKey = 1;
	} else {
		$PageAccessAllowKey = 2;
	}

	if ($PAGE_ACCESS_ALLOW[basename($_SERVER['SCRIPT_NAME'])][$PageAccessAllowKey] != 1) {
		$ErrorMsg = "不正なアクセスです。正規の手順を踏んでください。" . basename($_SERVER['SCRIPT_NAME']) . ":" . $PageAccessAllowKey;
		showAdminSorryPage($ErrorMsg);
		exit;
	}



