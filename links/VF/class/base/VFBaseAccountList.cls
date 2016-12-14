<?php
/**
 * Accountクラス
 *
 * tAccountMのリスティングを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _AS_CLS_DIR . 'ASDataObjects.cls';
include_once _AS_CLS_DIR . 'ASDataListObjects.cls';

class BaseAccountList extends ASDataListObjects {
	/**
	 * アカウントCD
	 */
	public $AccountCD;
	/**
	 * 名前
	 */
	public $AccountName;
	/**
	 * メールアドレス
	 */
	public $EMail;
	/**
	 * アカウントID
	 */
	public $AccountID;
	/**
	 * パスワード
	 */
	public $AccountPW;
	/**
	 * 認証キー
	 */
	public $AccountKey;
	/**
	 * 権限
	 */
	public $Authority;
	/**
	 * ログイン禁止
	 */
	public $Disabled;
	/**
	 * 削除フラグ
	 */
	public $DelFlag;
	/**
	 * 削除日時
	 */
	public $DelDate;
	/**
	 * 作成日時
	 */
	public $CreateDate;
	/**
	 * 更新日時
	 */
	public $UpdateDate;

	/**
	 * コンストラクタ
	 * DB接続を確認し、そのオブジェクトとテーブル名称をプロパティへ格納します。
	 * 
	 * @access		public
	 * @param		resource	$myDB		DB接続ID
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function __construct ($myDB = "") {
		if ($myDB == "") {
			$GLOBALS['ExecuteError'][] = get_class($this) . "データベースへのコネクションがありません";
			return FALSE;
		}

		$this->myDB = $myDB;
		$this->TableName = 'tAccountM';
		$this->AllCountCheck = TRUE;// 総数チェックフラグ

		return TRUE;
	}

	/**
	 * 初期化メソッド
	 * プロパティを初期化します。
	 * 
	 * @access		public
	 */
	function initialize(){
		$this->AccountCD = array();
		$this->AccountName = array();
		$this->EMail = array();
		$this->AccountID = array();
		$this->AccountPW = array();
		$this->AccountKey = array();
		$this->Authority = array();
		$this->Disabled = array();
		$this->DelFlag = array();
		$this->DelDate = array();
		$this->CreateDate = array();
		$this->UpdateDate = array();

		$this->Condition = NULL;
		$this->Order = NULL;
		$this->Group = NULL;
		$this->CountOfAll = NULL;
		$this->PagesOfAll = NULL;
		$this->Limit = NULL;
	}

	/**
	 * 抽出メソッド
	 * プロパティ値などからSQLの生成を行い、リストを抽出するSQLの作成を発行を行います。
	 * 
	 * @access		public
	 * @param		integer		$myPage		取得対象のページ番号
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function executeSelect($myPage){
		if ($myPage == NULL || !is_numeric($myPage) || $myPage < 1){
			$GLOBALS['ExecuteError'][] = get_class($this) . "Variable myPage is invalid. ";
			return FALSE;
		}
		if ($this->Limit == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . "Variable limit is invalid. ";
			return FALSE;
		}

		$this->myListView = new ASListView($this->myDB);

		$sqlMoji = "SELECT ";
		$sqlMoji .= "`AccountCD`";
		$sqlMoji .= ", `AccountName`";
		$sqlMoji .= ", `EMail`";
		$sqlMoji .= ", `AccountID`";
		$sqlMoji .= ", `AccountPW`";
		$sqlMoji .= ", `AccountKey`";
		$sqlMoji .= ", `Authority`";
		$sqlMoji .= ", `Disabled`";
		$sqlMoji .= ", `DelFlag`";
		$sqlMoji .= ", `DelDate`";
		$sqlMoji .= ", `CreateDate`";
		$sqlMoji .= ", `UpdateDate`";
		$this->myListView->SelectSQL = $sqlMoji;

		$sqlMoji = " FROM " . $this->TableName . " ";
		if ($this->Condition != NULL)
			$sqlMoji .= " WHERE " . $this->Condition;
		$this->myListView->Condition = $sqlMoji;

		// 表示順を指定
		if ($this->Order != NULL)
			$this->myListView->Order = $this->Order;

		// 件数
		$this->myListView->Limit = $this->Limit;

		// 総数チェックフラグ
		$this->myListView->AllCountCheck = $this->AllCountCheck;

		// 検索実行
		if (!($this->myListView->GetList($myPage))) {
			$GLOBALS['ExecuteError'][] = get_class($this) . "Listing is failed. ";
			return FALSE;
		}

		// 取得された件数などを格納
		$this->RecCnt = $this->myListView->Rows;
		$this->PagesOfAll = $this->myListView->Pages;
		$this->CountOfAll = $this->myListView->Count;

		// データ格納
		$this->getDataSet();

		// 表示用の加工等
		$this->modifyDataSet();

		// ページ判定
		if ($this->Limit != 'allpage'){
			$this->IfNext = $this->hasNextPage($myPage);
			$this->IfPrevious = $this->hasPreviousPage($myPage);
			$this->PreviousPage = $this->getPreviousPage($myPage);
			$this->NextPage = $this->getNextPage($myPage);
		}

		$this->IfResults = $this->hasResults();

		// リストオブジェクトの破棄
		unset($this->myListView);

		return TRUE;
	}

	/**
	 * データ取得
	 * 取得したリストをプロパティに配列として格納します。
	 * 
	 * @access		public
	 */
	function getDataSet(){
		for ($i = 0; $i < $this->RecCnt; $i++){
			$this->AccountCD[$i] = $this->myListView->getValue($i, 0);
			$this->AccountName[$i] = $this->myListView->getValue($i, 1);
			$this->EMail[$i] = $this->myListView->getValue($i, 2);
			$this->AccountID[$i] = $this->myListView->getValue($i, 3);
			$this->AccountPW[$i] = $this->myListView->getValue($i, 4);
			$this->AccountKey[$i] = $this->myListView->getValue($i, 5);
			$this->Authority[$i] = $this->myListView->getValue($i, 6);
			$this->Disabled[$i] = $this->myListView->getValue($i, 7);
			$this->DelFlag[$i] = $this->myListView->getValue($i, 8);
			$this->DelDate[$i] = $this->myListView->getValue($i, 9);
			$this->CreateDate[$i] = $this->myListView->getValue($i, 10);
			$this->UpdateDate[$i] = $this->myListView->getValue($i, 11);

		}
	}

	/**
	 * データ加工
	 * 値に対応する言葉などがある場合には、表示用にその変換を行います。
	 * 
	 * @access		public
	 */
	function modifyDataSet(){
		for ($i = 0; $i < $this->RecCnt; $i++){
		}
	}

	/**
	 * プライマリキーによるリスト抽出
	 * プライマリキーをキーとして、そのテーブルに登録されているデータを抽出します。
	 * 
	 * @access		public
	 * @param		integer		$AccountCD		プライマリキー
	 * @param		integer		$SortBy		リスト順指定
	 * @param		integer		$myPage		抽出すべきページ番号(すべてなら"1")
	 * @param		integer		$limit		1ページ当たりのレコード数(すべてなら"allpage")
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function getAccountListByAccountCD($AccountCD, $SortBy, $myPage, $limit = 10){
		if ($AccountCD == NULL || !is_numeric($AccountCD)){
			$GLOBALS['ExecuteError'][] = get_class($this) . "Variable AccountCD is required or must be numeric";
			return FALSE;
		}
		if ($SortBy == NULL || !is_numeric($SortBy)){
			$GLOBALS['ExecuteError'][] = get_class($this) . "Variable SortBy is required or must be numeric";
			return FALSE;
		}
		if ($myPage == NULL || !is_numeric($myPage) || $myPage < 1){
			$GLOBALS['ExecuteError'][] = get_class($this) . "Variable myPage is required or must be numeric";
			return FALSE;
		}
		if ($limit == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . "Variable limit is required.";
			return FALSE;
		}

		$SortByStr[1] = array("プライマリキー", "AccountCD");

		$condition = "`AccountCD` > 0 AND `AccountCD` = " . $LogCD . " AND MukouFlg = FALSE";
		$this->Condition = $condition;

		$this->Limit = $limit;

		$this->Order = $SortByStr[ceil($SortBy / 2)][1];
		$this->Order .= ($SortBy % 2 != 0) ? "" : " desc";

		if (!$this->executeSelect($myPage)){
			$GLOBALS['ExecuteError'][] = get_class($this) . 'Getting AccountList Failed. ' . $this->Err;
			return FALSE;
		}

		return TRUE;
	}

	/**
	 * 任意条件による抽出
	 * パラメータオブジェクト$SearchObj(主としてWEBからのPOSTパラメータ)から条件節を生成して抽出します。
	 * 
	 * @access		public
	 * @param		object		$SearchObj	検索パラメータ
	 * @param		integer		$SortBy		リスト順指定
	 * @param		integer		$myPage		抽出すべきページ番号(すべてなら"1")
	 * @param		integer		$limit		1ページ当たりのレコード数(すべてなら"allpage")
	 * @param		object		$Operator	演算子パラメータ
	 * @param		boolean		$AllCountCheck		総数を求めるならTRUE
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function getAccountList($SearchObj, $SortBy, $myPage, $limit = 10, $Operator = array(), $AllCountCheck = TRUE){
		if ($SortBy == NULL || !is_numeric($SortBy)){
			$GLOBALS['ExecuteError'][] = get_class($this) . 'Variable SortBy is required or must be numeric. ' . $this->Err;
			return FALSE;
		}
		if ($myPage == NULL || !is_numeric($myPage) || $myPage < 1){
			$GLOBALS['ExecuteError'][] = get_class($this) . 'Variable myPage is required or must be numeric. ' . $this->Err;
			return FALSE;
		}
		if ($limit == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . 'Variable limit is required. ' . $this->Err;
			return FALSE;
		}

		$SortByStr[] = NULL;

		$condition = $this->getConditionSQL($SearchObj, $Operator);
		$this->Condition = $condition;
		$this->Limit = $limit;

		$this->Order = $SortByStr[ceil($SortBy / 2)][1];
		$this->Order .= ($SortBy % 2 != 0) ? "" : " desc";

		$this->AllCountCheck = $AllCountCheck;

		if (!$this->executeSelect($myPage)){
			$GLOBALS['ExecuteError'][] = get_class($this) . 'Getting AccountList Failed. ' . $this->Err;
			return FALSE;
		}

		return TRUE;
	}

	/**
	 * 任意条件の生成
	 * パラメータオブジェクト$SearchObj(主としてWEBからのPOSTパラメータ)から条件節を生成します。
	 * 
	 * @access		private
	 * @param		object		$SearchObj	検索パラメータ
	 * @param		object		$Operator	演算子
	 * @return		string		条件節SQL
	 */ 
	public function getConditionSQL($SearchObj, $Operator = array()) { 
		if (isset($SearchObj['AccountCD'])) $Conditions[] = ASDataObjects::getConditionByOperator('AccountCD', $SearchObj['AccountCD'], 'int', $Operator['AccountCD']);
		if (isset($SearchObj['AccountName'])) $Conditions[] = ASDataObjects::getConditionByOperator('AccountName', $SearchObj['AccountName'], 'text', $Operator['AccountName']);
		if (isset($SearchObj['EMail'])) $Conditions[] = ASDataObjects::getConditionByOperator('EMail', $SearchObj['EMail'], 'text', $Operator['EMail']);
		if (isset($SearchObj['AccountID'])) $Conditions[] = ASDataObjects::getConditionByOperator('AccountID', $SearchObj['AccountID'], 'text', $Operator['AccountID']);
		if (isset($SearchObj['AccountPW'])) $Conditions[] = ASDataObjects::getConditionByOperator('AccountPW', $SearchObj['AccountPW'], 'text', $Operator['AccountPW']);
		if (isset($SearchObj['AccountKey'])) $Conditions[] = ASDataObjects::getConditionByOperator('AccountKey', $SearchObj['AccountKey'], 'text', $Operator['AccountKey']);
		if (isset($SearchObj['Authority'])) $Conditions[] = ASDataObjects::getConditionByOperator('Authority', $SearchObj['Authority'], 'int', $Operator['Authority']);
		if (isset($SearchObj['Disabled'])) $Conditions[] = ASDataObjects::getConditionByOperator('Disabled', $SearchObj['Disabled'], 'int2', $Operator['Disabled']);
		if (isset($SearchObj['DelFlag'])) $Conditions[] = ASDataObjects::getConditionByOperator('DelFlag', $SearchObj['DelFlag'], 'int2', $Operator['DelFlag']);
		if (isset($SearchObj['DelDate'])) $Conditions[] = ASDataObjects::getConditionByOperator('DelDate', $SearchObj['DelDate'], 'datetime', $Operator['DelDate']);
		if (isset($SearchObj['CreateDate'])) $Conditions[] = ASDataObjects::getConditionByOperator('CreateDate', $SearchObj['CreateDate'], 'datetime', $Operator['CreateDate']);
		if (isset($SearchObj['UpdateDate'])) $Conditions[] = ASDataObjects::getConditionByOperator('UpdateDate', $SearchObj['UpdateDate'], 'datetime', $Operator['UpdateDate']);

		// 条件のみ直接記入
		if (is_array($SearchObj['free'])) {
			foreach ($SearchObj['free'] as $k => $v) {
				$Conditions[] = $v;
			}
		}

		for ($i = 0; $i < count($Conditions); $i++) {
			if ($Conditions[$i] != NULL) {
				if (strlen($ConditionSQL) == 0)
					$ConditionSQL = $Conditions[$i];
				else
					$ConditionSQL .= " AND " . $Conditions[$i] . " ";
			}
		}

		return $ConditionSQL;
	}
}

