<?php
/**
 * AccessLogクラス
 *
 * tAccessLogFのリスティングを扱うクラスです。
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

class BaseAccessLogList extends ASDataListObjects {
	/**
	 * 連番
	 */
	public $LogCD;
	/**
	 * リモートアドレス
	 */
	public $RemoteIP;
	/**
	 * アクセスページURI
	 */
	public $RequestUri;
	/**
	 * アクセス日時
	 */
	public $AccessDate;
	/**
	 * コンバージョン
	 */
	public $ConversionFlag;

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
		$this->TableName = 'tAccessLogF';
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
		$this->LogCD = array();
		$this->RemoteIP = array();
		$this->RequestUri = array();
		$this->AccessDate = array();
		$this->ConversionFlag = array();

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
		$sqlMoji .= "`LogCD`";
		$sqlMoji .= ", `RemoteIP`";
		$sqlMoji .= ", `RequestUri`";
		$sqlMoji .= ", `AccessDate`";
		$sqlMoji .= ", `ConversionFlag`";
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
			$this->LogCD[$i] = $this->myListView->getValue($i, 0);
			$this->RemoteIP[$i] = $this->myListView->getValue($i, 1);
			$this->RequestUri[$i] = $this->myListView->getValue($i, 2);
			$this->AccessDate[$i] = $this->myListView->getValue($i, 3);
			$this->ConversionFlag[$i] = $this->myListView->getValue($i, 4);

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
	 * @param		integer		$LogCD		プライマリキー
	 * @param		integer		$SortBy		リスト順指定
	 * @param		integer		$myPage		抽出すべきページ番号(すべてなら"1")
	 * @param		integer		$limit		1ページ当たりのレコード数(すべてなら"allpage")
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function getAccessLogListByLogCD($LogCD, $SortBy, $myPage, $limit = 10){
		if ($LogCD == NULL || !is_numeric($LogCD)){
			$GLOBALS['ExecuteError'][] = get_class($this) . "Variable LogCD is required or must be numeric";
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

		$SortByStr[1] = array("プライマリキー", "LogCD");

		$condition = "`LogCD` > 0 AND `LogCD` = " . $LogCD . " AND MukouFlg = FALSE";
		$this->Condition = $condition;

		$this->Limit = $limit;

		$this->Order = $SortByStr[ceil($SortBy / 2)][1];
		$this->Order .= ($SortBy % 2 != 0) ? "" : " desc";

		if (!$this->executeSelect($myPage)){
			$GLOBALS['ExecuteError'][] = get_class($this) . 'Getting AccessLogList Failed. ' . $this->Err;
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
	function getAccessLogList($SearchObj, $SortBy, $myPage, $limit = 10, $Operator = array(), $AllCountCheck = TRUE){
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
			$GLOBALS['ExecuteError'][] = get_class($this) . 'Getting AccessLogList Failed. ' . $this->Err;
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
		if (isset($SearchObj['LogCD'])) $Conditions[] = ASDataObjects::getConditionByOperator('LogCD', $SearchObj['LogCD'], 'int', $Operator['LogCD']);
		if (isset($SearchObj['RemoteIP'])) $Conditions[] = ASDataObjects::getConditionByOperator('RemoteIP', $SearchObj['RemoteIP'], 'text', $Operator['RemoteIP']);
		if (isset($SearchObj['RequestUri'])) $Conditions[] = ASDataObjects::getConditionByOperator('RequestUri', $SearchObj['RequestUri'], 'text', $Operator['RequestUri']);
		if (isset($SearchObj['AccessDate'])) $Conditions[] = ASDataObjects::getConditionByOperator('AccessDate', $SearchObj['AccessDate'], 'datetime', $Operator['AccessDate']);
		if (isset($SearchObj['ConversionFlag'])) $Conditions[] = ASDataObjects::getConditionByOperator('ConversionFlag', $SearchObj['ConversionFlag'], 'int2', $Operator['ConversionFlag']);

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

