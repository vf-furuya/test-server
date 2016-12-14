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
	# エラートラップ (文字数・形式チェック)（削除処理の場合除く）
	########################################################

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
			$GLOBALS['_SERVER']['SCRIPT_FILENAME'] = 'admin/__FilePrefix___s.php';
			include_once '__FilePrefix___s.php';
			exit;
		} else {
			$IfComplete = TRUE;
		}
	}

	######################################################
	#リロードチェック準備（削除処理の場合除く）
	######################################################

	if ($work != _WORK_DELETE) {
		$_r_e_l_o_a_d_ = ASParameter::getStringValue('_r_e_l_o_a_d_');

		$myReload = new reload();
		$myReload->setLifetime(3600);
		$myReload->gc();
		$isReload = FALSE;

		//リロードチェック
		if ($myReload->isReload())
			$isReload = TRUE;
		unset($myReload);
	}

	if (!$isReload) {
		########################################################
		# 更新処理
		########################################################
		if ($work != _WORK_DELETE) {
			########################################################
			# トランザクション 開始
			########################################################

			$myDB->setExternalControl();// 外部コントロールを有効
			$myDB->transactionBegin(TRUE);

			########################################################
			# データ取得
			########################################################

			$my__ClassName__ = new __ClassName__($myDB);

			if ($edit__PrimaryKey__ > 0){
				if (!$my__ClassName__->get__ClassName__By__PrimaryKey__($edit__PrimaryKey__) || $my__ClassName__->RecCnt != 1){
					$myDB->transactionRollback();
					trigger_error("データを抽出出来ませんでした。 Searching __ClassName__ Failed. edit__PrimaryKey__:" . $edit__PrimaryKey__, E_USER_ERROR);
					exit;
				}
			}
			else {
				$my__ClassName__->__PrimaryKey__ = -1;
			}

			########################################################
			# 更新データセット
			########################################################

	__PropertyLoop__		$my__ClassNameArr__->__PropertyColumnName__ = $w__PropertyColumnName__;
	__PropertyLoop__
			if (!$my__ClassName__->executeUpdate()){
				$myDB->transactionRollback();
				trigger_error("登録処理が完了出来ませんでした。データの更新ができませんでした。Updating __ClassName__ Failed.", E_USER_ERROR);
				exit;
			}

			########################################################
			# トランザクション 終了
			########################################################

			$myDB->cancelExternalControl();// 外部コントロールを無効化
			$myDB->transactionCommit();

			$IfUpdate = TRUE;
		}
		########################################################
		# 削除処理
		########################################################
		else if ($work == _WORK_DELETE) {
			########################################################
			# トランザクション 開始
			########################################################

			$myDB->setExternalControl();// 外部コントロールを有効
			$myDB->transactionBegin(TRUE);

			########################################################
			# 更新データセット
			########################################################

			$my__ClassName__ = new __ClassName__($myDB);

			if (!$my__ClassName__->get__ClassName__By__PrimaryKey__($edit__PrimaryKey__) || $my__ClassName__->RecCnt != 1){
				$myDB->transactionRollback();
				trigger_error("データを抽出出来ませんでした。 Searching __ClassName__ Failed. edit__PrimaryKey__:" . $edit__PrimaryKey__, E_USER_ERROR);
				exit;
			}

			$my__ClassName__->Delete_flag = TRUE;

			if (!$my__ClassName__->executeUpdate()){
				$myDB->transactionRollback();
				trigger_error("登録処理が完了出来ませんでした。データの更新ができませんでした。Updating __ClassName__ Failed.", E_USER_ERROR);
				exit;
			}

			########################################################
			# トランザクション 終了
			########################################################

			$myDB->cancelExternalControl();// 外部コントロールを無効化
			$myDB->transactionCommit();

			$IfDelete = TRUE;
		}
	}
	else {
		ASHtml::setValue("work", NULL);
		$ErrorMsg = "リロードです。初めから処理をやり直して下さい。";
		showAdminSorryPage($ErrorMsg);
		exit;
	}

	########################################################
	# 表示プロセス
	########################################################

	ASHtml::setValue('edit__PrimaryKey__');
	ASHtml::setValue('work', NULL);
	ASHtml::setValue('myPage');
	ASHtml::setValue('SortBy');
	ASHtml::setValue('cRowsPerPage');

	$myHtml = new ASHtml('default', $MY_CARRIER, TRUE);
	unset($myHtml);

