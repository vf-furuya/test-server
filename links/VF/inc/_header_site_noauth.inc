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

	########################################################
	# ssl判定を行い適切なプロトコルでアクセスされていなければリダイレクト
	########################################################

	# https接続の場合
	if($_SERVER['HTTPS'] == 'on'){
		if (!(is_array($HTTPS_PAGE) && in_array(substr($_SERVER['SCRIPT_NAME'], 1), $HTTPS_PAGE))) {
			$RedirectURL = _MAIN_URL . substr($_SERVER['REQUEST_URI'], 1);
			header("location: " . $RedirectURL);
			exit;
		}
	}else{
		if (is_array($HTTPS_PAGE) && in_array(substr($_SERVER['SCRIPT_NAME'], 1), $HTTPS_PAGE)) {
			$RedirectURL = _SSL_MAIN_URL . substr($_SERVER['REQUEST_URI'], 1);
			header("location: " . $RedirectURL);
			exit;
		}
	}

	########################################################
	# データベース接続
	########################################################

	$myDB = new DBConnection(_MAIN_DB, _HOST_NAME, _USER_NAME, _PASSWD, _PORT);
	if (!$myDB->Connection) {
		trigger_error('DBConnection Failed.', E_USER_ERROR);
	}

	########################################################
	# セッションキーチェック
	########################################################

	$COOKIEDATA->Sessionkey = $_COOKIE[_CART_COOKIE_NAME];// カート用Cookieデータ
	$COOKIEDATA->AccessSessionkey = $_COOKIE[_ACCESS_COOKIE_NAME];// アクセス情報用Cookieデータ

	# 無ければ生成&保存
	if (!$COOKIEDATA->Sessionkey) {
		########################################################
		# カート情報生成
		########################################################

		$clsCarts = new Carts($myDB);

		if (!$COOKIEDATA->Sessionkey = $clsCarts->getNewKey()) {
			trigger_error("セッションキーの生成に失敗しました。", E_USER_ERROR);
			exit;
		}

		unset($clsCarts);

		########################################################
		# クッキーにセッションキー保存	
		########################################################

		if (!$res = setcookie (_CART_COOKIE_NAME, $COOKIEDATA->Sessionkey, _CART_COOKIE_TIME, _COOKIE_PATH, _COOKIE_DOMAIN)) {
			trigger_error("クッキーの設定に失敗しました。");
			exit;
		}

		$CartServiceCount = 0;
		$IfNewCartSessionkey = TRUE;

	}
	# ページをアクセスした度にCookie有効期限を更新させる
	else {
		########################################################
		# クッキーにセッションキー保存	
		########################################################

		if (!$res = setcookie (_CART_COOKIE_NAME, $COOKIEDATA->Sessionkey, _CART_COOKIE_TIME, _COOKIE_PATH, _COOKIE_DOMAIN)) {
			trigger_error("クッキーの設定に失敗しました。");
			exit;
		}
	}

	# 無ければ生成&保存
	if (!$COOKIEDATA->AccessSessionkey) {
		########################################################
		# セッションキー作成
		########################################################

		$clsSessions = new Sessions($myDB);

		if (!$COOKIEDATA->AccessSessionkey = $clsSessions->getNewKey()) {
			trigger_error("セッションキーの生成に失敗しました。", E_USER_ERROR);
			exit;
		}

		unset($clsSessions);

		########################################################
		# セッション情報生成
		########################################################

		$clsSessions = new Sessions($myDB);

		$clsSessions->ID = -1;
		$clsSessions->Sessionkey = $COOKIEDATA->AccessSessionkey;

		if (!$clsSessions->executeUpdate()){
			trigger_error("登録処理が完了出来ませんでした。データの更新ができませんでした。Updating Sessions Failed.", E_USER_ERROR);
			exit;
		}

		unset($clsSessions);

		########################################################
		# クッキーにセッションキー保存	
		########################################################

		if (!$res = setcookie (_ACCESS_COOKIE_NAME, $COOKIEDATA->AccessSessionkey, _ACCESS_COOKIE_TIME, _COOKIE_PATH, _COOKIE_DOMAIN)) {
			trigger_error("クッキーの設定に失敗しました。");
			exit;
		}

		$IfNewAccessSessionkey = TRUE;
	}
	# ページをアクセスした度にCookie有効期限を更新させる
	else {
		########################################################
		# クッキーにセッションキー保存	
		########################################################

		if (!$res = setcookie (_ACCESS_COOKIE_NAME, $COOKIEDATA->AccessSessionkey, _ACCESS_COOKIE_TIME, _COOKIE_PATH, _COOKIE_DOMAIN)) {
			trigger_error("クッキーの設定に失敗しました。");
			exit;
		}
	}

	########################################################
	# カート内情報取得
	########################################################

	if (!$IfNewCartSessionkey) {
		########################################################
		# カート情報取得
		########################################################

		$clsCartsList = new CartsList($myDB);

		$Condition = "t1.Session = '" . mysql_real_escape_string($COOKIEDATA->Sessionkey) . "'";

		if (!$clsCartsList->getCartsListByCondition($Condition)) {
			trigger_error("Searching Carts Failed: ", E_USER_ERROR);
			exit;
		}

		$CartServiceCount = $clsCartsList->RecCnt;
		$CARTDATA->CartServiceID = $clsCartsList->Service_id;

		$IfCartServiceCount = ($CartServiceCount > 0) ? TRUE : FALSE;

		unset($clsCartsList);
	}

	########################################################
	# セッション情報取得
	########################################################

	if (!$IfNewAccessSessionkey) {
		########################################################
		# セッション情報取得
		########################################################

		$clsSessions = new Sessions($myDB);

		if (!$clsSessions->getSessionsBySessionkey($COOKIEDATA->AccessSessionkey)){
			trigger_error("セッションデータが見つかりませんでした。", E_USER_ERROR);
			exit;
		}

		if ($clsSessions->RecCnt == 1) {
			$SESSIONDATA = unserialize($clsSessions->Data);
		}

		# 情報がなければ再度作成する
		else {
			# 複数データが存在する場合には削除
			if ($clsSessions->RecCnt > 1) {
				$Condition = "Sessionkey = " . mysql_real_escape_string($COOKIEDATA->AccessSessionkey) . "'";
				if (!$clsSessions->executeDelete($Condition)){
					trigger_error("登録処理が完了出来ませんでした。データの更新ができませんでした。Updating Sessions Failed.", E_USER_ERROR);
					exit;
				}
			}

			# セッション情報生成
			$clsSessions->initialize();

			$clsSessions->ID = -1;
			$clsSessions->Sessionkey = $COOKIEDATA->AccessSessionkey;

			if (!$clsSessions->executeUpdate()){
				trigger_error("登録処理が完了出来ませんでした。データの更新ができませんでした。Updating Sessions Failed.", E_USER_ERROR);
				exit;
			}
		}

		unset($clsSessions);
	}

