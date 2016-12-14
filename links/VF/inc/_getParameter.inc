<?php
	########################################################
	# 各種INCLUDE処理
	########################################################


	########################################################
	# リファラーが当サイト以外のURLか調べる
	########################################################

	if ($_SERVER['HTTP_REFERER']) {
		$IfReferer = TRUE;
		foreach ($NO_REFERER_URL as $val) {
			if (preg_match("{^" . $val . "}", $_SERVER['HTTP_REFERER'])) {
				$IfReferer = FALSE;
				break;
			}
		}
	}

	########################################################
	# リファラー情報をセッションへ追加
	########################################################

	if ($IfReferer) {
		$SESSIONDATA['referer'] = $_SERVER['HTTP_REFERER'];
		$IfSessionUpdate = TRUE;
	}

	########################################################
	# 検索エンジン・キーワード処理
	########################################################

	# 外部URLだった場合
	if ($IfReferer) {
		$res = SE_get_search_word($_SERVER['HTTP_REFERER']);
		$SearchEngine = $res['se'];
		$SearchWords = $res['kword'];

		if ($SearchEngine && $SearchWords) {
			$SESSIONDATA['engine'] = $SearchEngine;
			$SESSIONDATA['searchword'] = $SearchWords;
			$IfSessionUpdate = TRUE;
		}
	}

	########################################################
	# コラボ処理
	########################################################
/*
	if ($_GET['v']) {
		$v_code = $_GET['v'];

		if ($v_code == 'clear') {
			$COLLABO_SESSIONDATA = '';

			# クッキーを削除
			if (!$res = setcookie (_COLLABO_COOKIE_NAME, '', -3600, _COOKIE_PATH, _COOKIE_DOMAIN)) {
				trigger_error("クッキーの設定に失敗しました。");
				exit;
			}
		} else {
			$clsCollaborations = new Collaborations($myDB);

			$SearchObj = $Operator = array();
			$SearchObj['ID'] = 0;
			$Operator['ID'] = '>';
			$SearchObj['Code'] = $v_code;
			$Operator['Code'] = '=';
			$SearchObj['Delete_flag'] = FALSE;
			$Operator['Delete_flag'] = '=';

			if (!$clsCollaborations->getCollaborationsByCondition($SearchObj, $Operator)) {
				trigger_error("Searching Collaborations Failed: ", E_USER_ERROR);
				exit;
			}

			if ($clsCollaborations->RecCnt == 1) {
				$COLLABO_SESSIONDATA = $v_code;
				$CollaborationsLogoImagePath = _getUploadImgPath(_UPLOAD_COLLABO_DIR, _UPLOAD_COLLABO_URL, $clsCollaborations->LogoImage);
				$IfCollaborationsLogoImageFlg = ($CollaborationsLogoImagePath) ? TRUE : FALSE;

				# クッキーにセッションキー保存	
				if (!$res = setcookie (_COLLABO_COOKIE_NAME, $v_code, _COLLABO_COOKIE_TIME, _COOKIE_PATH, _COOKIE_DOMAIN)) {
					trigger_error("クッキーの設定に失敗しました。");
					exit;
				}

				# コラボアクセス数をカウントアップ
				if (!_coutUpAccessLog('collabo', $clsCollaborations->ID)) {
					trigger_error("Update Log Failed: ", E_USER_ERROR);
					exit;
				}

				$NewCollaboFlg = TRUE;
			}

			unset($clsCollaborations);
		}
	}
	// 元の処理はapp_controller.php


	########################################################
	# コラボ状態でタイアップ用画像が保存されているか判定
	########################################################

	if (!$NewCollaboFlg && $COLLABO_SESSIONDATA) {
		$clsCollaborations = new Collaborations($myDB);

		$SearchObj = $Operator = array();
		$SearchObj['ID'] = 0;
		$Operator['ID'] = '>';
		$SearchObj['Code'] = $COLLABO_SESSIONDATA;
		$Operator['Code'] = '=';
		$SearchObj['Delete_flag'] = FALSE;
		$Operator['Delete_flag'] = '=';

		if (!$clsCollaborations->getCollaborationsByCondition($SearchObj, $Operator)) {
			trigger_error("Searching Collaborations Failed: ", E_USER_ERROR);
			exit;
		}

		if ($clsCollaborations->RecCnt == 1) {
			$CollaborationsLogoImagePath = _getUploadImgPath(_UPLOAD_COLLABO_DIR, _UPLOAD_COLLABO_URL, $clsCollaborations->LogoImage);
			$IfCollaborationsLogoImageFlg = ($CollaborationsLogoImagePath) ? TRUE : FALSE;
		}

		unset($clsCollaborations);
	}

	########################################################
	# セッションデータ更新
	########################################################

	if ($IfSessionUpdate) {
		$clsSessions = new Sessions($myDB);

		if (!$clsSessions->updateSessionsBySessionkey($COOKIEDATA->Sessionkey)){
			trigger_error("登録処理が完了出来ませんでした。データの更新ができませんでした。Updating Session Failed.", E_USER_ERROR);
			exit;
		}

		unset($clsSessions);
	}
/

	/**
	 * ■■■検索キーワード取得■■■
	 *
	 * @param	string	$url	検索結果ページURL
	 * @return	string		検索キーワード（失敗時:""）
	 */

	function SE_get_search_word($url)
	{
		//■検索エンジンURLパターン設定
		// array(検索エンジン名, ドメイン・ホスト, 検索キーワード変数名, エンコーディング変数名, デフォルトエンコーディング)
		$url_pattern_array = array(
					array("google", "google.co.jp", "q", "ie", "UTF-8"),
					array("google", "google.com", "q", "ie", "UTF-8"),
					array("yahoo", "yahoo.co.jp", "p", "ei", "UTF-8"),
					array("msn", "search.msn.co.jp", "q", false, "UTF-8"),
					array("infoseek", "infoseek.co.jp", "qt", false, "UTF-8"),
					array("excite", "excite.co.jp", "search", false, "Shift_JIS"),
					array("goo", "goo.ne.jp", "MT", "IE", "EUC-JP"),
					array("nifty", "nifty.com", "q", false, "UTF-8"),
					array("livedoor", "search.livedoor.com", "q", "ie", "UTF-8"),
					array("bing", "bing.com", "q", false, "UTF-8"),
					array("Luna.TV", "luna.tv", "q", "ie", "UTF-8"),
					・・・
					);

		//■検索エンジン取得

		// URL解析
		$urlinfo = parse_url($url);
		if ($urlinfo === false || !isset($urlinfo["host"], $urlinfo["query"])) {
			return "";
		}
		$host  = strtolower($urlinfo["host"]);	// ホスト名
		$query = $urlinfo["query"];		// クエリー文字列
		$host_len = strlen($host);		// ホスト名長

		// ホストから検索エンジンドメイン検索
		$match = false;
		foreach ($url_pattern_array as $array) {
			list($se, $domain, $kword_var, $encoding_var, $encoding) = $array;
			$domain_len = strlen($domain);	// 検索エンジンドメイン名長

			if (($host_len === $domain_len && $host === $domain)
			 || ($host_len > $domain_len && substr($host, "-".$domain_len - 1) === ".".$domain)) {
				$match = true;
				break;
			}
		}

		// 検索エンジン特定できず
		if (!$match) {
			return "";
		}

		//■検索ワード取得
		parse_str($query, $qstr_array);
		if (!isset($qstr_array[$kword_var])) {
			return "";
		}

		//■検索ワードエンコーディング取得
		if (isset($qstr_array[$encoding_var])) {
			$encoding = $qstr_array[$encoding_var];
		}

		$kword = $qstr_array[$kword_var];

		//■エンコーディング変換
		if ($encoding && strtolower($encoding) !== "utf-8") {
			$kword = @mb_convert_encoding($kword, "UTF-8", $encoding);
			if ($kword === false) {
				return "";
			}
		}
		$res = array('se'=>$se, 'kword'=>$kword);
		return  $res;
	}


?>