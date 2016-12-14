<?php
/**
 * BaseSiteValidaterクラス
 *
 * tSiteMのバリデーションを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _AS_CLS_DIR . 'ASValidater.cls';

class BaseSiteValidater extends ASValidater {
	/**
	 * 連番の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$SiteCD		連番
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateSiteCD($SiteCD = NULL, $IfError = FALSE) {
		if ($SiteCD === NULL || $SiteCD === '')
			return TRUE;

		$Flg = TRUE;
		if (!SiteValidater::isNumeric($SiteCD))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * アカウントCDの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$AccountCD		アカウントCD
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateAccountCD($AccountCD = NULL, $IfError = FALSE) {
		if ($AccountCD === NULL || $AccountCD === '')
			return TRUE;

		$Flg = TRUE;
		if (!SiteValidater::isNumeric($AccountCD))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * サイトインデックスNoの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$SiteIndex		サイトインデックスNo
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateSiteIndex($SiteIndex = NULL, $IfError = FALSE) {
		if ($SiteIndex === NULL || $SiteIndex === '')
			return TRUE;

		$Flg = TRUE;
		if (!SiteValidater::isNumeric($SiteIndex))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * リダイレクト先の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$RedirectUrl		リダイレクト先
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateRedirectUrl($RedirectUrl = NULL, $IfError = FALSE) {
		if ($RedirectUrl === NULL || $RedirectUrl === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * リダイレクト深度の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$RedirectDepth		リダイレクト深度
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateRedirectDepth($RedirectDepth = NULL, $IfError = FALSE) {
		if ($RedirectDepth === NULL || $RedirectDepth === '')
			return TRUE;

		$Flg = TRUE;
		if (!SiteValidater::isNumeric($RedirectDepth))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * リダイレクト用UIDの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$UID		リダイレクト用UID
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateUID($UID = NULL, $IfError = FALSE) {
		if ($UID === NULL || $UID === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 利用禁止の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$Disabled		利用禁止
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateDisabled($Disabled = NULL, $IfError = FALSE) {
		if ($Disabled === NULL || $Disabled === '')
			return TRUE;

		$Flg = TRUE;
		if (!SiteValidater::isNumeric($Disabled))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 作成日時の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$CreateDate		作成日時
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateCreateDate($CreateDate = NULL, $IfError = FALSE) {
		if ($CreateDate === NULL || $CreateDate === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 更新日時の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$UpdateDate		更新日時
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateUpdateDate($UpdateDate = NULL, $IfError = FALSE) {
		if ($UpdateDate === NULL || $UpdateDate === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}

}

