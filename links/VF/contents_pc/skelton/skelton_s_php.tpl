<?php
	########################################################
	# 各種INCLUDE処理
	########################################################

	// 基本読み込み
	include_once '_header_admin.inc';

	include_once _COMMON_CLS_DIR . '__wSuffix____ClassName__.cls';
	include_once _COMMON_CLS_DIR . '__wSuffix____ClassName__List.cls';

	########################################################
	# パラメータ受け取り
	########################################################

	$work = ASParameter::getNumericValue('work');
	$myPage = ASParameter::getNumericValue('myPage');
	$SortBy = ASParameter::getNumericValue('SortBy');
	$cRowsPerPage = ASParameter::getNumericValue('cRowsPerPage');
	$edit__PrimaryKey__ = ASParameter::getNumericValue('edit__PrimaryKey__');

	########################################################
	# 編集時用処理
	########################################################

	if ($work == _WORK_EDIT) {
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
	}
	########################################################
	# 確認画面からの戻り時
	########################################################
	else if ($work == _WORK_BACK) {
__LinesLoop__		$w__ColumnName__ = ASParameter::getStringValue('w__ColumnName__');
__LinesLoop__
__TimestampLoop__		$w__TimestampColumnName__Year = ASParameter::getStringValue('w__TimestampColumnName__Year');
		$w__TimestampColumnName__Month = ASParameter::getStringValue('w__TimestampColumnName__Month');
		$w__TimestampColumnName__Day = ASParameter::getStringValue('w__TimestampColumnName__Day');
		$w__TimestampColumnName__Hour = ASParameter::getStringValue('w__TimestampColumnName__Hour');
		$w__TimestampColumnName__Minute = ASParameter::getStringValue('w__TimestampColumnName__Minute');
__TimestampLoop__
__Timestamp2Loop__		$w__Timestamp2ColumnName__Year = ASParameter::getStringValue('w__Timestamp2ColumnName__Year');
		$w__Timestamp2ColumnName__Month = ASParameter::getStringValue('w__Timestamp2ColumnName__Month');
		$w__Timestamp2ColumnName__Day = ASParameter::getStringValue('w__Timestamp2ColumnName__Day');
		$w__Timestamp2ColumnName__Hour = ASParameter::getStringValue('w__Timestamp2ColumnName__Hour');
		$w__Timestamp2ColumnName__Minute = ASParameter::getStringValue('w__Timestamp2ColumnName__Minute');
		$w__Timestamp2ColumnName__Second = ASParameter::getStringValue('w__Timestamp2ColumnName__Second');
__Timestamp2Loop__
__DateLoop__		$w__DateColumnName__Year = ASParameter::getStringValue('w__DateColumnName__Year');
		$w__DateColumnName__Month = ASParameter::getStringValue('w__DateColumnName__Month');
		$w__DateColumnName__Day = ASParameter::getStringValue('w__DateColumnName__Day');
__DateLoop__
	}

	########################################################
	# 表示用整形
	########################################################

__LinesLoop____IfShow__	$p__ColumnName__ = $w__ColumnName__;
__IfShow____LinesLoop__

	########################################################
	# 新規作成時文言
	########################################################

	if (!($edit__PrimaryKey__ > 0)) {
		$p__PrimaryKey__ = '---';
		$pDelete_flag = '---';
		$pCreated = '---';
		$pModified = '---';
	}

	########################################################
	# 表示処理
	########################################################

__MasterLoop__	// __MasterColumnTitle__
	$__MasterColumnName__Loop = count($__MasterName__);
	$__MasterColumnName__LoopBegin = 1;
	for ($i = 0; $i < $__MasterColumnName__Loop; $i++){
__IfMasterRadio__		$__MasterColumnName__Checked[$i] = ($w__MasterColumnName__ == $i || ($w__MasterColumnName__ == NULL && $i == 1)) ? " checked" : "";
		$__MasterColumnName__[$i] = $__MasterName__[$i];
		$__MasterColumnName__Value[$i] = $i;
__IfMasterRadio____IfMasterSelect__		$__MasterColumnName__Selected[$i] = ($w__MasterColumnName__ == $i || ($w__MasterColumnName__ == NULL && $i == 1)) ? " selected" : "";
		$__MasterColumnName__[$i] = $__MasterName__[$i];
		$__MasterColumnName__Value[$i] = $i;
__IfMasterSelect____IfMasterCheckbox__		$__MasterColumnName__Checked[$i] = (is_array($w__MasterColumnName__) && array_search($i, $w__MasterColumnName__) !== FALSE) ? " checked" : "";
		$__MasterColumnName__[$i] = $__MasterName__[$i];
		$__MasterColumnName__Value[$i] = $i;
__IfMasterCheckbox__	}
__MasterLoop__

	########################################################
	# 表示プロセス
	########################################################

	ASHtml::setValue('edit__PrimaryKey__');
	ASHtml::setValue('work', NULL);
	ASHtml::setValue('myPage');
	ASHtml::setValue('SortBy');
	ASHtml::setValue('cRowsPerPage');

__LinesLoop____IfShow__	ASHtml::setValue('w__ColumnName__');
__IfShow____LinesLoop__

	$myHtml = new ASHtml('default', $MY_CARRIER, TRUE);
	unset($myHtml);

