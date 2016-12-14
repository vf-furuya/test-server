<?php
	########################################################
	# 各種INCLUDE処理
	########################################################

	include_once '_header_admin.inc';

	include_once _COMMON_CLS_DIR . '__wSuffix____ClassName__.cls';
	include_once _COMMON_CLS_DIR . '__wSuffix____ClassName__List.cls';

	########################################################
	# パラメータ取得
	########################################################

	$myPage = ASParameter::getNumericValue('myPage');
	$cRowsPerPage = ASParameter::getNumericValue('cRowsPerPage');
	$SortBy = ASParameter::getNumericValue('SortBy');
	$work = ASParameter::getNumericValue('work');
	$edit__PrimaryKey__ = ASParameter::getNumericValue('edit__PrimaryKey__');

	########################################################
	# リスティングのデフォルト設定
	########################################################

	// 現在ページ
	if (!isset($myPage) || $myPage == "" || $myPage < 1) $myPage = 1;

	// 1ページ当たり件数
	if (!isset($cRowsPerPage) || $cRowsPerPage == "" || $cRowsPerPage < 1) $cRowsPerPage = $ROWS_PER_PAGE[_ROWS_PER_PAGE_DEFAULT_INDEX];

	########################################################
	# ソートの定義
	########################################################

	if (!isset($SortBy) || $SortBy == 0) $SortBy = 1;
__ListLoop__	$SortByStr[] = array('__ListColumnTitle__', '__ListColumnNameNormal__');
__ListLoop__
	########################################################
	# パラメータチェック/値加工
	########################################################

	########################################################
	# 検索パラメータに応じた条件SQL生成
	########################################################

	########################################################
	# データ取得
	########################################################

	// リストクラスのインスタンス生成
	$my__ClassName__List = new __ClassName__List($myDB);

	// 抽出条件
	$SearchObj = $Operator = array();
	$SearchObj['__PrimaryKey__'] = 0;
	$Operator['__PrimaryKey__'] = '>';
	$SearchObj['Delete_flag'] = FALSE;
	$Operator['Delete_flag'] = '=';

	if (!$my__ClassName__List->get__ClassName__List($SearchObj, $SortBy, $myPage, $cRowsPerPage, $Operator, TRUE)) {
		trigger_error("Searching __ClassName__ Failed: ", E_USER_ERROR);
		exit;
	}

	$__ClassName__ListLoop = $my__ClassName__List->RecCnt;
	for ($i = 0; $i < $__ClassName__ListLoop; $i++) {
__LinesLoop__		$__ColumnName__[$i] = $my__ClassNameArr__List->__ColumnName__[$i];
__LinesLoop__
__MasterLoop__		$p__MasterColumnName__[$i] = $__MasterName__[$__MasterColumnName__[$i]];
__MasterLoop__
__TimestampLoop__		$__TimestampColumnName__[$i] = substr($__TimestampColumnName__[$i], 0, 16);
__TimestampLoop__
__Timestamp2Loop__		$__Timestamp2ColumnName__[$i] = substr($__Timestamp2ColumnName__[$i], 0, 19);
__Timestamp2Loop__
__DateLoop__		$__DateColumnName__[$i] = substr($__DateColumnName__[$i], 0, 10);
__DateLoop__
	}

	// ページ遷移関連
	$AllPages = $my__ClassName__List->PagesOfAll;
	$PreviousPage = $myPage - 1;
	$NextPage = $myPage + 1;
	$LastPage = $AllPages;
	$CountOfAll = $my__ClassName__List->CountOfAll;
	if (intval($cRowsPerPage) > 0) {
		$CountFrom = ($CountOfAll == 0) ? 0 : ($myPage - 1) * $cRowsPerPage + 1;
		$CountTo = min($myPage * $cRowsPerPage, $CountOfAll);
	} else {
		$CountFrom = 1;
		$CountTo = $CountOfAll;
	}

	$PageData = _getPageData(_MAX_PAGENUM, $AllPages, $myPage);
	$PageListLoop = $PageData['PageListLoop'];
	$PageNum = $PageData['PageNum'];
	$IfMyPage = $PageData['IfMyPage'];

	$IfResults = ($CountOfAll > 0) ? TRUE : FALSE;
	$IfPaging = ($AllPages > 1) ? TRUE : FALSE;
	$IfToTop = ($myPage > 1) ? TRUE : FALSE;
	$IfToPre = ($myPage > 1) ? TRUE : FALSE;
	$IfToNext = ($myPage < $AllPages) ? TRUE : FALSE;
	$IfToLast = ($myPage < $AllPages) ? TRUE : FALSE;

	########################################################
	# 表示処理ほか
	########################################################

	$RowsPerPageLoop = count($ROWS_PER_PAGE);
	for ($i = 0; $i < $RowsPerPageLoop; $i++){
		$RowsPerPage[$i] = $ROWS_PER_PAGE[$i];
		$RowsPerPageSelected[$i] = ($RowsPerPage[$i] == $cRowsPerPage) ? " selected" : "";
	}

	########################################################
	# コンテンツ表示
	########################################################

	ASHtml::setValue('edit__PrimaryKey__');
	ASHtml::setValue('work', NULL);
	ASHtml::setValue('SortBy');
	ASHtml::setValue('myPage');

	$myHtml = new ASHtml('default', $MY_CARRIER, TRUE);
	unset($myHtml);

