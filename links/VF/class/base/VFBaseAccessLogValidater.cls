<?php
/**
 * BaseAccessLogValidaterクラス
 *
 * tAccessLogFのバリデーションを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _AS_CLS_DIR . 'ASValidater.cls';

class BaseAccessLogValidater extends ASValidater {
	/**
	 * 連番の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$LogCD		連番
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateLogCD($LogCD = NULL, $IfError = FALSE) {
		if ($LogCD === NULL || $LogCD === '')
			return TRUE;

		$Flg = TRUE;
		if (!AccessLogValidater::isNumeric($LogCD))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * リモートアドレスの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$RemoteIP		リモートアドレス
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateRemoteIP($RemoteIP = NULL, $IfError = FALSE) {
		if ($RemoteIP === NULL || $RemoteIP === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * アクセスページURIの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$RequestUri		アクセスページURI
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateRequestUri($RequestUri = NULL, $IfError = FALSE) {
		if ($RequestUri === NULL || $RequestUri === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * アクセス日時の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$AccessDate		アクセス日時
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateAccessDate($AccessDate = NULL, $IfError = FALSE) {
		if ($AccessDate === NULL || $AccessDate === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}

}

