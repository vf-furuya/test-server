<?php
/**
 * Base__ClassName__Validaterクラス
 *
 * __TableName__のバリデーションを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _AS_CLS_DIR . 'ASValidater.cls';

class Base__ClassName__Validater extends ASValidater {
__LinesLoop__	/**
	 * __ColumnTitle__の値の正当性を検証します。
	 * 
	 * @access		public
	 * @param		variable	$__ColumnName__		__ColumnTitle__
	 * @return		boolean		正当な値であればTRUE、違えばFALSE
	 */
	public static function validate__ColumnName__($__ColumnName__ = NULL, $IfError = FALSE) {
		if ($__ColumnName__ === NULL || $__ColumnName__ === '')
			return TRUE;

		$Flg = TRUE;
__IfInt__		if (!__ClassNameArr__Validater::isNumeric($__ColumnName__))
			$Flg = FALSE;
__IfInt____IfLimit__		if (!__ClassNameArr__Validater::is__ColumnLimit__($__ColumnName__))
			$Flg = FALSE;
__IfLimit____IfLengthLimit__		if (!__ClassNameArr__Validater::checkLength($__ColumnName__, __ColumnMin__, __ColumnMax__))
			$Flg = FALSE;
__IfLengthLimit____IfTimestamp__		if (!__ClassNameArr__Validater::isProperDatetime($__ColumnName__))
			$Flg = FALSE;
__IfTimestamp____IfDate__		if (!__ClassNameArr__Validater::isRightDate($__ColumnName__))
			$Flg = FALSE;
__IfDate__
		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}
__LinesLoop__
}

