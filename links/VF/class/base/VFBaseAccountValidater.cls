<?php
/**
 * BaseAccountValidaterクラス
 *
 * tAccountMのバリデーションを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _AS_CLS_DIR . 'ASValidater.cls';

class BaseAccountValidater extends ASValidater {
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
		if (!AccountValidater::isNumeric($AccountCD))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 名前の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$AccountName		名前
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateAccountName($AccountName = NULL, $IfError = FALSE) {
		if ($AccountName === NULL || $AccountName === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * メールアドレスの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$EMail		メールアドレス
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateEMail($EMail = NULL, $IfError = FALSE) {
		if ($EMail === NULL || $EMail === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * アカウントIDの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$AccountID		アカウントID
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateAccountID($AccountID = NULL, $IfError = FALSE) {
		if ($AccountID === NULL || $AccountID === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * パスワードの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$AccountPW		パスワード
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateAccountPW($AccountPW = NULL, $IfError = FALSE) {
		if ($AccountPW === NULL || $AccountPW === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 認証キーの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$AccountKey		認証キー
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateAccountKey($AccountKey = NULL, $IfError = FALSE) {
		if ($AccountKey === NULL || $AccountKey === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 権限の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$Authority		権限
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateAuthority($Authority = NULL, $IfError = FALSE) {
		if ($Authority === NULL || $Authority === '')
			return TRUE;

		$Flg = TRUE;
		if (!AccountValidater::isNumeric($Authority))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * ログイン禁止の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$Disabled		ログイン禁止
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateDisabled($Disabled = NULL, $IfError = FALSE) {
		if ($Disabled === NULL || $Disabled === '')
			return TRUE;

		$Flg = TRUE;
		if (!AccountValidater::isNumeric($Disabled))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 削除フラグの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$DelFlag		削除フラグ
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateDelFlag($DelFlag = NULL, $IfError = FALSE) {
		if ($DelFlag === NULL || $DelFlag === '')
			return TRUE;

		$Flg = TRUE;
		if (!AccountValidater::isNumeric($DelFlag))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 削除日時の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$DelDate		削除日時
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateDelDate($DelDate = NULL, $IfError = FALSE) {
		if ($DelDate === NULL || $DelDate === '')
			return TRUE;

		$Flg = TRUE;

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

