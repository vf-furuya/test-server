<?php
	########################################################
	# 各種INCLUDE処理
	########################################################

	include_once '_header_admin.inc';

	include_once _COMMON_CLS_DIR . '__wSuffix____ClassName__.cls';
	include_once _COMMON_CLS_DIR . '__wSuffix____ClassName__List.cls';
	include_once _COMMON_CLS_DIR . '__wSuffix____ClassName__Validater.cls';
	include_once _AS_CLS_DIR . 'reload.cls';

	########################################################
	# パラメータ受け取り
	########################################################

	$work = ASParameter::getNumericValue('work');
	$myPage = ASParameter::getNumericValue('myPage');
	$SortBy = ASParameter::getNumericValue('SortBy');
	$cRowsPerPage = ASParameter::getNumericValue('cRowsPerPage');
	$edit__PrimaryKey__ = ASParameter::getNumericValue('edit__PrimaryKey__');

__LinesLoop__	$w__ColumnName__ = ASParameter::getStringValue('w__ColumnName__');
__LinesLoop__
__TimestampLoop__	$w__TimestampColumnName__Year = ASParameter::getStringValue('w__TimestampColumnName__Year');
	$w__TimestampColumnName__Month = ASParameter::getStringValue('w__TimestampColumnName__Month');
	$w__TimestampColumnName__Day = ASParameter::getStringValue('w__TimestampColumnName__Day');
	$w__TimestampColumnName__Hour = ASParameter::getStringValue('w__TimestampColumnName__Hour');
	$w__TimestampColumnName__Minute = ASParameter::getStringValue('w__TimestampColumnName__Minute');
__TimestampLoop__
__Timestamp2Loop__	$w__Timestamp2ColumnName__Year = ASParameter::getStringValue('w__Timestamp2ColumnName__Year');
	$w__Timestamp2ColumnName__Month = ASParameter::getStringValue('w__Timestamp2ColumnName__Month');
	$w__Timestamp2ColumnName__Day = ASParameter::getStringValue('w__Timestamp2ColumnName__Day');
	$w__Timestamp2ColumnName__Hour = ASParameter::getStringValue('w__Timestamp2ColumnName__Hour');
	$w__Timestamp2ColumnName__Minute = ASParameter::getStringValue('w__Timestamp2ColumnName__Minute');
	$w__Timestamp2ColumnName__Second = ASParameter::getStringValue('w__Timestamp2ColumnName__Second');
__Timestamp2Loop__
__DateLoop__	$w__DateColumnName__Year = ASParameter::getStringValue('w__DateColumnName__Year');
	$w__DateColumnName__Month = ASParameter::getStringValue('w__DateColumnName__Month');
	$w__DateColumnName__Day = ASParameter::getStringValue('w__DateColumnName__Day');
__DateLoop__

	########################################################
	# エラートラップ (文字数・形式チェック)
	########################################################

	$ErrorString = array();

	if ($work != _WORK_DELETE) {
		// 必須項目
__RequiredLoop__		$If__RequiredColumnName__Empty = ASValidater::isEmpty($w__RequiredColumnName__, &$IfError);
__RequiredLoop__
__TimestampRequiredLoop__		$If__TimestampRequiredColumnName__Empty = ASValidater::isEmpty($w__TimestampRequiredColumnName__Year, &$IfError)
			|| ASValidater::isEmpty($w__TimestampRequiredColumnName__Month, &$IfError)
			|| ASValidater::isEmpty($w__TimestampRequiredColumnName__Day, &$IfError)
			|| ASValidater::isEmpty($w__TimestampRequiredColumnName__Hour, &$IfError)
			|| ASValidater::isEmpty($w__TimestampRequiredColumnName__Minute, &$IfError);
__TimestampRequiredLoop__
__DateRequiredLoop__		$If__DateRequiredColumnName__Empty = ASValidater::isEmpty($w__DateRequiredColumnName__Year, &$IfError)
			|| ASValidater::isEmpty($w__DateRequiredColumnName__Month, &$IfError)
			|| ASValidater::isEmpty($w__DateRequiredColumnName__Day, &$IfError);
__DateRequiredLoop__
		// 日付関連の記入済み判定(必須とは別)
__TimestampLoop__		$__TimestampColumnName__Filled = !ASValidater::isEmpty($w__TimestampColumnName__Year)
			&& !ASValidater::isEmpty($w__TimestampColumnName__Month)
			&& !ASValidater::isEmpty($w__TimestampColumnName__Day)
			&& !ASValidater::isEmpty($w__TimestampColumnName__Hour)
			&& !ASValidater::isEmpty($w__TimestampColumnName__Minute);
__TimestampLoop__
__DateLoop__		$__DateColumnName__Filled = !ASValidater::isEmpty($w__DateColumnName__Year)
			&& !ASValidater::isEmpty($w__DateColumnName__Month)
			&& !ASValidater::isEmpty($w__DateColumnName__Day);
__DateLoop__
		// TIMESTAMP整形
__TimestampLoop__		if ($__TimestampColumnName__Filled)
			$w__TimestampColumnName__ = ASDate::formatDatetime($w__TimestampColumnName__Year, $w__TimestampColumnName__Month, $w__TimestampColumnName__Day, $w__TimestampColumnName__Hour, $w__TimestampColumnName__Minute, $w__TimestampColumnName__Second);
__TimestampLoop__
		// DATE整形
__DateLoop__		if ($__DateColumnName__Filled)
			$w__DateColumnName__ = ASDate::formatDatetime($w__DateColumnName__Year, $w__DateColumnName__Month, $w__DateColumnName__Day);
__DateLoop__
		// 正当性検証
__LinesLoop__		$If__ColumnName__Error = !__ClassNameArr__Validater::validate__ColumnName__($w__ColumnName__, &$IfError);
__LinesLoop__
		if ($IfError) {
			$_POST['work'] = _WORK_SAVE;
			$GLOBALS['_SERVER']['SCRIPT_FILENAME'] = 'admin/__FilePrefix___s.php';
			include_once '__FilePrefix___s.php';
			exit;
		} else {
			$IfComplete = TRUE;
		}

	}
	else if ($work == _WORK_DELETE) {
		// パラメータチェック
		$edit__PrimaryKey__ = intval($edit__PrimaryKey__);

		if ($edit__PrimaryKey__ == "" || $edit__PrimaryKey__ == NULL) {
			$ErrorMsg = "不正なアクセスです。正規の手順を踏んでください。";
			showAdminSorryPage($ErrorMsg);
			exit;
		}

		########################################################
		# データ取得
		########################################################

		$my__ClassName__ = new __ClassName__($myDB);

		if (!$my__ClassName__->get__ClassName__By__PrimaryKey__($edit__PrimaryKey__) || $my__ClassName__->RecCnt != 1) {
			trigger_error("データを抽出出来ませんでした。 Searching ContentsMaster Failed. edit__PrimaryKey__:" . $edit__PrimaryKey__, E_USER_ERROR);
			exit;
		}

__LinesLoop__		$w__ColumnName__ = $my__ClassNameArr__->__ColumnName__;
__LinesLoop__
__LinesLoop____IfShow__		$p__ColumnName__ = $w__ColumnName__;
__IfShow____LinesLoop__

__TimestampLoop__		$w__TimestampColumnName__Year = substr($w__TimestampColumnName__, 0, 4);
		$w__TimestampColumnName__Month = substr($w__TimestampColumnName__, 5, 2);
		$w__TimestampColumnName__Day = substr($w__TimestampColumnName__, 8, 2);
		$w__TimestampColumnName__Hour = substr($w__TimestampColumnName__, 11, 2);
		$w__TimestampColumnName__Minute = substr($w__TimestampColumnName__, 14, 2);
__TimestampLoop__
__Timestamp2Loop__		$w__Timestamp2ColumnName__Year = substr($w__Timestamp2ColumnName__, 0, 4);
		$w__Timestamp2ColumnName__Month = substr($w__Timestamp2ColumnName__, 5, 2);
		$w__Timestamp2ColumnName__Day = substr($w__Timestamp2ColumnName__, 8, 2);
		$w__Timestamp2ColumnName__Hour = substr($w__Timestamp2ColumnName__, 11, 2);
		$w__Timestamp2ColumnName__Minute = substr($w__Timestamp2ColumnName__, 14, 2);
		$w__Timestamp2ColumnName__Second = substr($w__Timestamp2ColumnName__, 17, 2);
__Timestamp2Loop__
__DateLoop__		$w__DateColumnName__Year = substr($w__DateColumnName__, 0, 4);
		$w__DateColumnName__Month = substr($w__DateColumnName__, 5, 2);
		$w__DateColumnName__Day = substr($w__DateColumnName__, 8, 2);
__DateLoop__

		$IfDelete = TRUE;
	}

	########################################################
	# 表示処理ほか
	########################################################

	// 値表示用
__LinesLoop__	$p__ColumnName__ = $w__ColumnName__;
__LinesLoop__
__MasterLoop__	$p__MasterColumnName__ = $__MasterName__[$w__MasterColumnName__];
__MasterLoop__

	########################################################
	# 新規作成時文言
	########################################################

	if (!($edit__PrimaryKey__ > 0)) {
		$p__PrimaryKey__ = '---';
		$pDelete_flag = '---';
		$pCreated = '---';
		$pModified = '---';
	}
	else {
__LinesLoop____IfShow__		$p__ColumnName__ = $w__ColumnName__;
__IfShow____LinesLoop__
	}

	########################################################
	# 表示プロセス
	########################################################

	ASHtml::setValue('edit__PrimaryKey__');
	ASHtml::setValue('work', NULL);
	ASHtml::setValue('myPage');
	ASHtml::setValue('SortBy');
	ASHtml::setValue('cRowsPerPage');

	if ($work != _WORK_DELETE) {

__LinesLoop__		ASHtml::setValue('w__ColumnName__');
__LinesLoop__
__TimestampLoop__		ASHtml::setValue('w__TimestampColumnName__Year');
		ASHtml::setValue('w__TimestampColumnName__Month');
		ASHtml::setValue('w__TimestampColumnName__Day');
		ASHtml::setValue('w__TimestampColumnName__Hour');
		ASHtml::setValue('w__TimestampColumnName__Minute');
__TimestampLoop__
__Timestamp2Loop__		ASHtml::setValue('w__Timestamp2ColumnName__Year');
		ASHtml::setValue('w__Timestamp2ColumnName__Month');
		ASHtml::setValue('w__Timestamp2ColumnName__Day');
		ASHtml::setValue('w__Timestamp2ColumnName__Hour');
		ASHtml::setValue('w__Timestamp2ColumnName__Minute');
		ASHtml::setValue('w__Timestamp2ColumnName__Second');
__Timestamp2Loop__
__DateLoop__		ASHtml::setValue('w__DateColumnName__Year');
		ASHtml::setValue('w__DateColumnName__Month');
		ASHtml::setValue('w__DateColumnName__Day');
__DateLoop__
	}

	// リロード処理
	$myReload = new reload();
	ASHtml::setValue('_r_e_l_o_a_d_', $myReload->embedValue());

	$myHtml = new ASHtml('default', $MY_CARRIER, TRUE);
	unset($myHtml);

