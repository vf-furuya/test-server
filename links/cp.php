<?php
/***************************************************************************************
 ** リダイレクタ (1) 
 **   タグで効果測定を行うため、サイト設定で入力したタグを設置したページを表示、
 **   JavaScriptで強制リフレッシュ
 ***************************************************************************************/

	include_once ("_set_includepath.inc");
	/*========================================================
	 *= 初期化：インクルードファイルは .htaccess の include_path
	 *=         から読み込まれます
	 *========================================================*/
	include_once ("_header_site_nodb.inc");
	include_once ("_adjust_query.inc");

	/*========================================================
	 *= パラメータ受け取り
	 *========================================================*/
	$wSiteCD	= ASParameter::getStringValue('s');
	$wAccountCD	= ASParameter::getStringValue('a');
	$wSiteIndex	= ASParameter::getStringValue('si');
/* 広告パラメータ引継ぎ ADD START */
	$wParamName	= ASParameter::getStringValue('pn');
	$wParamVal	= ASParameter::getStringValue('pv');
	$getAllParamVal = explode("pv=", $_SERVER["REQUEST_URI"]); //パラメータ調整2015.02
/* 広告パラメータ引継ぎ ADD END */
/* ジャンル追加 ADD START */
	$wGenruCD	= ASParameter::getStringValue('g');
/* ジャンル追加 ADD END */

	/*========================================================
	 *= アクセス情報の記録
	 *=   ⇒ 初期バージョンは実施しない
	 *========================================================*/
//	if (!$_COOKIE[_ACCESS_COOKIE_NAME] || $_COOKIE[_ACCESSTIME_COOKIE_NAME] < time()-60*5) {
	//	$LogCD = AccessLog::writeLog($myDB, $NOW, $_SERVER['REMOTE_ADDR'], $_SERVER['REQUEST_URI']);
//	}
	setcookie (_ACCESS_COOKIE_NAME, intval($_COOKIE[_ACCESS_COOKIE_NAME])+1, _ACCESS_COOKIE_TIME, _COOKIE_PATH, _COOKIE_DOMAIN);
	setcookie (_ACCESSTIME_COOKIE_NAME, time(), _ACCESS_COOKIE_TIME, _COOKIE_PATH, _COOKIE_DOMAIN);

	/*========================================================
	 *= リダイレクト先のURL作成
	 *========================================================*/
	$doRedirect = FALSE;

	// リダイレクトには最低 SiteCD が必要
	while (!empty($wSiteCD)) {
		// 基本的には SiteCD 以外は気にせずリダイレクト
		$RedirectUrl = str_replace("%%SiteCD%%",	$wSiteCD,				_REDIRECT_URL2);
		$RedirectUrl = str_replace("%%AccountCD%%",	$LogCD>0 ? $LogCD : '',	$RedirectUrl);
		$RedirectUrl = str_replace("%%SiteIndex%%",	$wSiteIndex,			$RedirectUrl);

/* ジャンル追加 ADD START */
		$RedirectUrl .= ($wGenruCD > 0) ? "&g=".$wGenruCD : "";
/* ジャンル追加 ADD END */

/* 広告パラメータ引継ぎ ADD START */
//		$RedirectUrl .= (($wParamName) ? "&amp;pn=".$wParamName : "") . (($wParamVal) ? "&amp;pv=".$wParamVal : ""); //パラメータ調整2015.02
		$RedirectUrl .= (($wParamName) ? "&amp;pn=".$wParamName : "") . ((count($getAllParamVal) == 2 ) ? "&amp;pv=".urlencode($getAllParamVal[1]) : "");
/* 広告パラメータ引継ぎ ADD END */

		$doRedirect = TRUE;

		break;
	}
	if (!$doRedirect || !$RedirectUrl) {
		header("HTTP/1.0 404 Not Found");
		die (file_get_contents(_ERROR_PAGE_404));
	}
	
/* タグ出力処理追加 ADD START 2013.12 */

	/*========================================================
	 *= タグの取得
	 *========================================================*/
	$getTagURL = str_replace("%%SiteCD%%",	$wSiteCD, _GETTAG_APIURL);
/* ジャンル追加 ADD START */
	$getTagURL = str_replace("%%GenruCD%%",	$wGenruCD, $getTagURL);
/* ジャンル追加 ADD END */

	$result = file_get_contents($getTagURL);
	$getTagArr = json_decode($result);
	
	$HeadTag = $getTagArr->head;
	$BodyTag = $getTagArr->body;

/* タグ出力処理追加 ADD END 2013.12 */

	/*========================================================
	 *= 遷移用JS画面出力
	 *========================================================*/

	$myHtml = new ASHtml('cp.tpl', $MY_CARRIER, TRUE);
	unset($myHtml);

