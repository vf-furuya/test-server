<?php
/**
 * ListViewクラス
 *
 * テーブル内容をリスティングするクラスです
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2003/01/31
 * @update  2008/01/26
 * @version 1.6
 **/

class ASListView {

	/**
	 * データベースコネクション
	 */
	var $myDB;
	/**
	 * 値を求める SQL (select x,y,z,d まで)
	 */
	var $SelectSQL;
	/**
	 * FROM 句以降の SQL (from xxx where yyy)
	 */
	var $Condition;
	/**
	 * Union時のFrom（前半）
	 */
	var $UnionCondition1;
	/**
	 * Union時のFrom（後半）
	 */
	var $UnionCondition2;
	/**
	 * ORDER By
	 */
	var $Order;
	/**
	 * GROUP By //kamiya added 2003-05-06
	 */
	var $Group;
	/**
	 * Distinct By //samekawa added 2003-05-06
	 */
	var $Distinct;
	/**
	 * 総行数(総数)
	 */
	var $Count;
	/**
	 * 総ページ数
	 */
	var $Pages;
	/**
	 * 1ページあたり行数
	 */
	var $Rows;
	/**
	 * 1ページあたりカラム数
	 */
	var $Cols;
	/**
	 * リミット(1ページあたりの指定行数)
	 */
	var $Limit;
	/**
	 * 現在ページ番号
	 */
	var $Page;

	/**
	 * 値(二次元配列) Value[row][col] = value(row,col)
	 */
	var $Value;

	/**
	 * エラーメッセージ
	 */
	var $Err;
	
	/* コンストラクタ */
	function ASListView($myDB = "") {
		global $CLS_DIR;

		// プロパティファイル読込
		include_once $CLS_DIR . "ASLog.cls";

		// ログ準備
		$myLog = new ASLog();

		$this->Err = "";
		
		if ($myDB == "") {
			$this->Err = "データベースへのコネクションがありません";
			$myLog->error("ClassName : " . get_class($this) . " : " . $this->Err);
			unset($myLog);
			return FALSE;
		}

		$this->myDB = $myDB;
		$this->TableName = "";
		$this->ZipCD = $ZipCD;
		$this->Limit = 10;// Limit 初期値
		$this->AllCountCheck = TRUE;// 総数チェックフラグ

		return TRUE;
	
	} // end of ListView(...)
	
	/* リスト取得 */
	function GetList($myPage = 1) {
		global $CLS_DIR;

		// プロパティファイル読込
		include_once $CLS_DIR . "ASLog.cls";

		// ログ準備
		$myLog = new ASLog();

		$this->Err = "";

		//設定
		if ($this->myDB == "") {
			$this->Err = "データベースへのコネクションがありません";
			$myLog->error("ClassName : " . get_class($this) . " : " . $this->Err);
			unset($myLog);
			return FALSE;
		}

		// エラークリア
		$this->Err = "";

		// myPage チェック1
		if ($myPage < 1) {
			$this->Err = "ページ指定は 1 から始めてください";
			$myLog->error("ClassName : " . get_class($this) . " : " . $this->Err);
			unset($myLog);
			return FALSE;
		}

		// SQL チェック
		if ($this->SelectSQL == "") {
			$this->Err = "Select 用の SQL をセットしてください";
			$myLog->error("ClassName : " . get_class($this) . " : " . $this->Err);
			unset($myLog);
			return FALSE;
		}
		
		// Condition チェック
		if ($this->Condition == "") {
			$this->Err = "Condition をセットしてください";
			$myLog->error("ClassName : " . get_class($this) . " : " . $this->Err);
			unset($myLog);
			return FALSE;
		}
		
		// $con
		$con = $this->Connection;
		
		// SQL より総数を求める
		if ($this->Limit != "allpage" && $this->AllCountCheck) {
			$IfAllCountCheck = TRUE;
		}

		if ($IfAllCountCheck) {
			if($this->Group <> ""){
				//GroupBy がで抽出されてるときのページ処理
				$sqlMoji = "select count(*) as cnt ";
				$sqlMoji .= $this->Condition;
				$sqlMoji .= " Group By ";
				$sqlMoji .= $this->Group;
				$rtn = $this->myDB->executeQuery($sqlMoji);
				//$myLog->debug("ページ数SQL2 : " . $sqlMoji);
				if (!$rtn) {
					$this->Err = "$sqlMoji<br>総行数の取得に失敗しました";
					return FALSE;
				} else {
					$this->Count = $this->myDB->getNumberOfRows($rtn); // 総行数
					//$myLog->debug("ページ数 : " . $this->Count . "/" . $this->Limit);
					
					if ($this->Limit != "allpage") {
						$this->Pages = ceil($this->Count / $this->Limit);
					}
					else {
						$this->Pages = ($this->Count > 0) ? 1 : 0;
					}
				}
			}
			else if ($this->Distinct <> ""){
				$sqlMoji = "select count(" . $this->Distinct . ") as cnt ";
				$sqlMoji .= $this->Condition;
				//$myLog->debug("ページ数SQL : " . $sqlMoji);
				$this->Count = $this->myDB->getOneValue($sqlMoji); // 総行数
				if ($this->Limit != "allpage") {
					$this->Pages = ceil($this->Count / $this->Limit);
					//$myLog->debug("ページ数 : " . $this->Count . "/" . $this->Limit);
					//$myLog->debug("ページ数 : " . ceil($this->Count / $this->Limit));
				}
			}
			// UNION対応
			else if ($this->UnionCondition1 <> "" && $this->UnionCondition2 <> "") {
				// 前半
				$sqlMoji = "select count(*) as cnt ";
				$sqlMoji .= $this->UnionCondition1;
				$Cnt1 = $this->myDB->getOneValue($sqlMoji);

				// 後半
				$sqlMoji = "select count(*) as cnt ";
				$sqlMoji .= $this->UnionCondition2;
				$Cnt2 = $this->myDB->getOneValue($sqlMoji);

				$this->Count = $Cnt1 + $Cnt2;
				if ($this->Limit != "allpage") {
					$this->Pages = ceil($this->Count / $this->Limit);
				}
			}
			else{
				$sqlMoji = "select count(*) as cnt ";
				$sqlMoji .= $this->Condition;
				//$myLog->debug("ページ数SQL : " . $sqlMoji);
				$this->Count = $this->myDB->getOneValue($sqlMoji); // 総行数
				if ($this->Limit != "allpage") {
					$this->Pages = ceil($this->Count / $this->Limit);
					//$myLog->debug("ページ数 : " . $this->Count . "/" . $this->Limit);
					//$myLog->debug("ページ数 : " . ceil($this->Count / $this->Limit));
				}
			}
			
			// myPage チェック2
			// 指定ページが総ページ数を超えていた場合、指定ページを変更
			if ($myPage > $this->Pages) {
				$myPage = $this->Pages;
				if ($myPage < 1) $myPage = 1;
			}
		}
		// 総数を求めない場合(全件取得の場合もこちら)
		else {
			$this->Pages = 1;
		}

		$this->Page = $myPage;

		// Offset 計算
		$tmpOffset = ($myPage - 1) * $this->Limit;

		// SQL より値を求める
		$sqlMoji = $this->SelectSQL;
		$sqlMoji .= $this->Condition;
		if ($this->Group != "") { //kamiya added 2003-05-06
			$sqlMoji .= " group by " . $this->Group;
		}
		if ($this->Order != "") {
			$sqlMoji .= " order by " . $this->Order;
		}
		if ($this->Limit != "allpage") {
			$sqlMoji .= " limit " . $this->Limit . " offset " . intval($tmpOffset);
		}
		$rtn = $this->myDB->executeQuery($sqlMoji);
		if (!$rtn) {
			$this->Err = "$sqlMoji<br>データの取得に失敗しました";
			return FALSE;
		} else {
			// step 1. 行数を求める
			$n = $this->myDB->getNumberOfRows($rtn);
			if ($n == 0) {
				// 行数=0 は TRUE リターン
				$this->Rows = 0;
				if (!$IfAllCountCheck) {
					$this->Count = 0;
				}
				return TRUE;
			} else {
				$this->Rows = $n;
				if (!$IfAllCountCheck) {
					$this->Count = $n;
				}
			}
			// step 2. カラム数を求める
			$m = $this->myDB->getNumberOfColumns($rtn);
			$this->Cols = $m;
			// step 3. 配列に格納
			for ($i=0;$i<$n;$i++) {
				for ($j=0;$j<$m;$j++) {
					$this->Value[$i][$j] = $this->myDB->getResult($rtn,$i,$j);
				} // for-loop($j)
			} // for-loop($i)
		} // $rtn?
		
		return TRUE;
	
	} // end of function GetList(...)
	
	/* 値取得関数 */
	function GetValue($row,$col) {
		return $this->Value[$row][$col];
	} // end of function GetValue(...)
	
} // end of class

?>
