<?php
/***************************************************************************************
 ** リダイレクタ (2) 
 **   ⇒ パラメータを少し加工する
 **   ⇒ インバウンドを記録、COMにリダイレクトする
 ** 
 ** links/client/com?s=1:2:1
 **             ↓
 ** http://別ドメイン/redirect.php?ret=http://ドメイン/links/client/com?s=1:2:1
 ** 
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
	$wUID		= ASParameter::getStringValue('uid');
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

	/*========================================================
	 *= リダイレクト先のURL作成
	 *========================================================*/
	$doRedirect = FALSE;

	// リダイレクトには最低 SiteCD が必要
	while (!empty($wSiteCD)) {

		// UIDが設定されていたら siteコードと uidを渡して最終リダイレクトに突入

		if (empty($wUID)) {
			$RedirectUrl = str_replace("%%SiteCD%%",	$wSiteCD,				_REDIRECT_URL3);
			$RedirectUrl = str_replace("%%AccountCD%%",	$wAccountCD,			$RedirectUrl);
			$RedirectUrl = str_replace("%%SiteIndex%%",	$wSiteIndex,			$RedirectUrl);

			// 基本的には SiteCD 以外は気にせずリダイレクト
			$ReturnUrl = str_replace("%%SiteCD%%",		$wSiteCD,				_REDIRECT_URL4);
			$ReturnUrl = str_replace("%%AccountCD%%",	$wAccountCD,			$ReturnUrl);
			$ReturnUrl = str_replace("%%SiteIndex%%",	$wSiteIndex,			$ReturnUrl);

/* ジャンル追加 ADD START */
			$RedirectUrl .= ($wGenruCD > 0) ? "&g=".$wGenruCD : "";
/* ジャンル追加 ADD END */

			$RedirectUrl = str_replace("%%BACK%%",		urlencode($ReturnUrl),	$RedirectUrl);

		}
		else {
			$RedirectUrl = str_replace("%%SiteName%%",	urlencode(_SITE_DOMAIN),_REDIRECT_URL5);
			$RedirectUrl = str_replace("%%UID%%",		$wUID,					$RedirectUrl);
		}

/* 広告パラメータ引継ぎ ADD START */
//		$RedirectUrl .= (($wParamName) ? "&amp;pn=".$wParamName : "") . (($wParamVal) ? "&amp;pv=".$wParamVal : ""); //パラメータ調整2015.02
		$RedirectUrl .= (($wParamName) ? "&amp;pn=".$wParamName : "") . ((count($getAllParamVal) == 2 ) ? "&amp;pv=".$getAllParamVal[1] : "");
/* 広告パラメータ引継ぎ ADD END */
		$doRedirect = TRUE;
		break;
	}

	if (!$doRedirect) {
		header("HTTP/1.0 404 Not Found");
		die (file_get_contents(_ERROR_PAGE_404));
	}

	/*========================================================
	 *= リダイレクト実行
	 *========================================================*/
	header ("Location: $RedirectUrl");
	exit;
?>