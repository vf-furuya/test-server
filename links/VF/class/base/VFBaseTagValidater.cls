<?php
/**
 * BaseTagValidaterクラス
 *
 * tTagMのバリデーションを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _AS_CLS_DIR . 'ASValidater.cls';

class BaseTagValidater extends ASValidater {
	/**
	 * 連番の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$TagCD		連番
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateTagCD($TagCD = NULL, $IfError = FALSE) {
		if ($TagCD === NULL || $TagCD === '')
			return TRUE;

		$Flg = TRUE;
		if (!TagValidater::isNumeric($TagCD))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * Siteの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$SiteCD		Site
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateSiteCD($SiteCD = NULL, $IfError = FALSE) {
		if ($SiteCD === NULL || $SiteCD === '')
			return TRUE;

		$Flg = TRUE;
		if (!TagValidater::isNumeric($SiteCD))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 表示順の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$TagIndex		表示順
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateTagIndex($TagIndex = NULL, $IfError = FALSE) {
		if ($TagIndex === NULL || $TagIndex === '')
			return TRUE;

		$Flg = TRUE;
		if (!TagValidater::isNumeric($TagIndex))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * タグの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$Tag		タグ
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateTag($Tag = NULL, $IfError = FALSE) {
		if ($Tag === NULL || $Tag === '')
			return TRUE;

		$Flg = TRUE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * head領域内に記載するの値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$HeadFlag		head領域内に記載する
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateHeadFlag($HeadFlag = NULL, $IfError = FALSE) {
		if ($HeadFlag === NULL || $HeadFlag === '')
			return TRUE;

		$Flg = TRUE;
		if (!TagValidater::isNumeric($HeadFlag))
			$Flg = FALSE;

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
	/**
	 * 出力抑制の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$Disabled		出力抑制
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validateDisabled($Disabled = NULL, $IfError = FALSE) {
		if ($Disabled === NULL || $Disabled === '')
			return TRUE;

		$Flg = TRUE;
		if (!TagValidater::isNumeric($Disabled))
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

