<?php
/**
 * Accountクラス
 *
 * tAccountMテーブルを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _BASE_CLS_DIR . 'VFBaseAccount.cls';

class Account extends BaseAccount {
	#
	# ログイン判定関数
	#
	function checkLogin($ID, $Password) {

		$SearchObj['AccountID'] = $ID;
		$Operator['AccountID'] = '=';
		$SearchObj['AccountPW'] = $Password;
		$Operator['AccountPW'] = '=';
		$SearchObj['Disabled'] = 0;
		$Operator['Disabled'] = '=';
		$SearchObj['DelFlag'] = 0;
		$Operator['DelFlag'] = '=';

		if (!$this->getAccountByCondition($SearchObj, $Operator)) {
			$GLOBALS['ExecuteError'][] = " : ログイン判定に失敗しました。";
			return FALSE;
		}

		if ($this->RecCnt == 1) {
			# Sessionkey Update
			$this->AccountKey = $this->getNewKey();

			if (!$this->executeUpdate()){
				$GLOBALS['ExecuteError'][] = " : Updateに失敗しました。";
				return FALSE;
			}

			return TRUE;
		}
		return FALSE;
	}

	#
	# セッションキー生成関数
	#
	function getNewKey() {

		// 候補文字配列を作る
		// 英小文字
		for ($i = ord("a"); $i < ord("z") + 1; $i++) {
			$charArray[] = chr($i);
		}
		// 英大文字
		for ($i = ord("A"); $i < ord("Z") + 1; $i++) {
			$charArray[] = chr($i);
		}
		// 数字
		for ($i = ord("0"); $i < ord("9") + 1; $i++) {
			$charArray[] = chr($i);
		}

		$FlgOK = FALSE;
		$cnt = 20;// 桁数指定
		while ($FlgOK == FALSE) {

			// ランダム文字列生成
			srand((double)microtime()*1000000);
			// $cnt 文字を小文字で生成
			for ($i = 0; $i < $cnt; $i++) {
				$strW[$i] = $charArray[rand(0, count($charArray) - 1)];
			}

			// シャッフル
			srand((double)microtime()*1000000);
			shuffle($strW);

			// 出力
			$strKey = "";
			for ($i = 0; $i < $cnt; $i++) {
				$strKey .= $strW[$i];
			}

			$Condition = "AccountKey = '" . mysql_real_escape_string($strKey) . "'";
			$FlgOK = ($this->getCount($Condition) == 0) ? TRUE : FALSE;
		}

		return $strKey;
	}
}

