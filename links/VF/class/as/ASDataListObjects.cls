<?php
/**
 * ASDataListObjects基底クラス
 *
 * リスト取扱クラスの基底クラスになります。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2005/04/25
 * @version 1.3
 **/

// 依存
include_once _AS_CLS_DIR . "ASLog.cls";
include_once _AS_CLS_DIR . "ASListView.cls";

class ASDataListObjects {
	/**
	 * 対象テーブル名称
	 */
	var $TableName;
	/**
	 * 抽出条件
	 */
	var $Condition;
	/**
	 * 抽出順
	 */
	var $Order;
	/**
	 * GroupBy
	 */
	var $Group;
	/**
	 * 総行数(総数)
	 */
	var $CountOfAll;
	/**
	 * 総ページ数
	 */
	var $PagesOfAll;
	/**
	 * リミット(1ページあたりの指定行数)
	 */
	var $Limit;
	/**
	 * 前ページがあるかないか
	 */
	var $IfPrevious;
	/**
	 * 次ページがあるかないか
	 */
	var $IfNext;
	/**
	 * 前ページ番号
	 */
	var $PreviousPage;
	/**
	 * 次ページ番号
	 */
	var $NextPage;
	/**
	 * 抽出結果のあるなし
	 */
	var $IfResults;

	/**
	 * リストクラスへのインスタンス
	 */
	var $myListView;

	/**
	 * データベースクラスのインスタンス
	 */
	var $myDB;
	/**
	 * レコードカウント
	 */
	var $RecCnt;
	/**
	 * クエリ実行結果セット
	 */
	var $tmprtn;

	/**
	 * コンストラクタ
	 * 現状処理なし
	 * 
	 * @access		public
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function ASDataListObjects() {
		return TRUE;
	}

	/**
	 * オブジェクトをPUBLISHします。
	 * 
	 * @access		private
	 */
	function serializeThis($Filename){
		$Obj = serialize($this);
		$filename = $this->getPublishFilename($Filename);
		ASTools::putFile($filename, $Obj);
		exec ('chmod 666 ' . $filename);

		//SiteControl::syncFile('www', $filename);
	}

	/**
	 * PUBLISHされたオブジェクトを戻して自身に反映します。
	 * 
	 * @param		integer		$PrimaryKey		プライマリキー
	 * @access		private
	 */
	function unserializeThis($Filename){
		// $myDBはRESOURCE型なので、一度退避しないとunserializeで失われてしまう。
		/*$myDB = $this->myDB;

		$filename = $this->getPublishFilename($Filename);
		if (file_exists($filename)) {
			$Obj = ASTools::getFile($filename);
			$this = unserialize($Obj);
			$this->myDB = $myDB;
			return TRUE;
		}
		else
			return FALSE;*/
	}

	/**
	 * PUBLISHされたオブジェクトを削除します。
	 * 
	 * @access		private
	 * @param		integer		$PrimaryKey		プライマリキー
	 */
	function removeSerializedFile($Filename = NULL){
		$filename = $this->getPublishFilename($Filename);
		exec ('rm -f ' . $filename);
	}

	/**
	 * PUBLISH保管用ファイル名を返します。
	 * 
	 * @param		integer		$PrimaryKey		プライマリキー
	 * @access		private
	 */
	function getPublishFilename($Filename = NULL){
		$filename = _PUBLISH_DIR . $Filename . '.obj';

		return $filename;
	}

	/**
	 * 次ページの存在確認
	 * 現在のページに対して、次ページが存在すればTRUEを返します。
	 * 
	 * @access		public
	 * @param		integer		$myPage		取得対象のページ番号
	 * @return		boolean		次ページがあればTRUE、なければFALSE
	 */
	function hasNextPage($myPage){
		if ($myPage < $this->PagesOfAll)
			return TRUE;
		else
			return FALSE;
	}

	/**
	 * 前ページの存在確認
	 * 現在のページに対して、前ページが存在すればTRUEを返します。
	 * 
	 * @access		public
	 * @param		integer		$myPage		取得対象のページ番号
	 * @return		boolean		前ページがあればTRUE、なければFALSE
	 */
	function hasPreviousPage($myPage){
		if ($myPage > 1)
			return TRUE;
		else
			return FALSE;
	}

	/**
	 * 次ページの番号取得
	 * 次ページの番号を計算して返します。
	 * 
	 * @access		public
	 * @param		integer		$myPage		取得対象のページ番号
	 * @return		integer		次ページのページ番号
	 */
	function getNextPage($myPage){
			return $myPage + 1;
	}

	/**
	 * 前ページの番号取得
	 * 前ページの番号を計算して返します。
	 * 
	 * @access		public
	 * @param		integer		$myPage		取得対象のページ番号
	 * @return		integer		前ページのページ番号
	 */
	function getPreviousPage($myPage){
			return $myPage - 1;
	}

	/**
	 * データ取得結果の判定
	 * データ取得の結果、データが抽出されていればTRUE、ゼロ件であればFALSEを返します。
	 * 
	 * @access		public
	 * @return		boolean		データが1件以上あればTRUE、ゼロ件ならFALSE
	 */
	function hasResults(){
		if ($this->CountOfAll > 0)
			return TRUE;
		else
			return FALSE;
	}

	/**
	 * フラグ変換
	 * フラグをSQLに適した文字列に変換します。
	 * 
	 * @access		public
	 * @param		string		$flg		変換対象のフラグ
	 * @return		string		変換後の文字列
	 */
	function convertFlgToString($flg){
		if ($flg == "true" || $flg == "t")
			return "TRUE";
		else if ($flg == "false" || $flg == "f")
			return "FALSE";

		if ($flg == true || $flg == 1)
			return "TRUE";
		else if ($flg == false || $flg == 0)
			return "FALSE";

		return "FALSE";
	}

	/**
	 * フラグ変換
	 * SQLが返すフラグ表現を2値表現に変換します。
	 * 
	 * @access		public
	 * @param		string		$flg		変換対象のフラグ
	 * @return		boolean		2値化されたフラグ
	 */
	function convertFlgToBoolean($flg){
		if ($flg == "t" || $flg == 1)
			return TRUE;
		else if ($flg == "f" || $flg == 0)
			return FALSE;
	}

	/**
	 * 整数変換
	 * カラム値が空の場合に、SQLに明示的に示すため、NULL文字列を返します。
	 * 
	 * @access		public
	 * @param		integer		$value		対象となる数値
	 * @return		string		変換後の文字列
	 */
	function convertNullIntValue($value){
		if ($value == "")
			return "NULL";
		else
			return $value;
	}

	/**
	 * 文字列変換
	 * カラム値が空の場合に、SQLに明示的に示すため、NULL文字列を返します。
	 * また、不正なSQLを防ぐため、文字列がある場合には処理をして返します。
	 * 
	 * @access		public
	 * @param		string		$value		対象となる文字列
	 * @return		string		変換後の文字列
	 */
	function convertNullStringValue($value){
		if ($value == "")
			return "NULL";
		else
			return "'" . DBConnection::escapeString($value) . "'";
	}

	/**
	 * SQL条件生成
	 * 完全一致の条件SQLを生成します。
	 * 
	 * @access		public
	 * @param		string		$ColumnName		カラム名称
	 * @param		string		$Value			条件値
	 * @param		string		$Attribute		カラム属性
	 * @param		string		$Operator		演算子
	 * @return		string		生成されたSQL
	 */
	function getConditionByOperator($ColumnName = NULL, $Value, $Attribute = 'INT', $Operator = '='){
		if ($ColumnName == NULL) {
			$this->Err = "Variable ColumnName Must Be Required.";
			return FALSE;
		}
		if ($Value === NULL) {
			return NULL;
		}

		$Attribute = strtoupper($Attribute);

		if ($Attribute == 'INT8')
			$condition = $ColumnName . " " . $Operator . " " . $Value . "::INT8";
		else if ($Attribute == 'INT2')
			$condition = $ColumnName . " " . $Operator . " " . $Value . "::INT2";
		else if ($Attribute == 'TEXT')
			$condition = $ColumnName . " " . $Operator . " '" . DBConnection::escapeString($Value) . "'";
		else if ($Attribute == 'TIMESTAMP')
			$condition = $ColumnName . " " . $Operator . " '" . DBConnection::escapeString($Value) . "'";
		else if ($Attribute == 'DATE')
			$condition = $ColumnName . "::DATE " . $Operator . " '" . DBConnection::escapeString($Value) . "'::DATE";
		else if ($Attribute == 'BOOLEAN')
			$condition = $ColumnName . " " . $Operator . " " . $Value . "::BOOLEAN";
		else
			$condition = $ColumnName . " " . $Operator . " " . $Value . "";

		return $condition;
	}

	/**
	 * SQL条件生成
	 * 部分一致の条件SQLを生成します。
	 * 
	 * @access		public
	 * @param		string		$ColumnName		カラム名称
	 * @param		string		$Value			条件値
	 * @return		string		生成されたSQL
	 */
	function getPartlyEqualCondition($ColumnName = NULL, $Value = NULL){
		if ($ColumnName == NULL) {
			$this->Err = "Variable ColumnName Must Be Required.";
			return FALSE;
		}
		if ($Value == NULL)
			return NULL;

		$condition = $ColumnName . " LIKE '%" . DBConnection::escapeString($Value) . "%'";

		return $condition;
	}

	/**
	 * 複数選択SQL
	 * 複数選択の条件SQLを生成します。
	 * 
	 * @access		public
	 * @param		string		$ColumnName		カラム名称
	 * @param		array		$Value			条件値
	 * @return		string		生成されたSQL
	 */
	function getORCondition($ColumnName = NULL, $Value = NULL){
		if ($ColumnName == NULL) {
			$this->Err = "Variable ColumnName Must Be Required.";
			return FALSE;
		}
		if ($Value == NULL)
			return NULL;

		for ($i = 0; $i < count($Value); $i++){
			if ($Value[$i] > 0){
				if ($i == 0) $condition = "(";
				if ($i > 0) $condition .= " OR ";
				$condition .= $ColumnName . " = " . $Value[$i];
				if ($i == count($Value) - 1) $condition .= ")";
			}
		}

		return $condition;
	}

	/**
	 * 複数選択SQL
	 * 複数の条件をOR連結したSQLを返します。
	 * 
	 * @access		public
	 * @param		string		$ColumnName			カラム名称
	 * @param		array		$Value				条件値
	 * @param		array		$ConditionArray		条件節配列
	 * @return		string		生成されたSQL
	 */
	function getORConnected($Value = NULL, $ConditionArray){
		if ($Value == NULL)
			return NULL;

		for ($i = 0; $i < count($Value); $i++){
			if ($Value[$i] != NULL){
				if ($i == 0) $condition = "(";
				if ($i > 0) $condition .= " OR ";
				$condition .= $ConditionArray[$Value[$i]];
				if ($i == count($Value) - 1) $condition .= ")";
			}
		}

		return $condition;
	}

	/**
	 * SQL条件生成
	 * 年齢条件のSQLを生成します。
	 * 
	 * @access		public
	 * @param		string		$ColumnName		カラム名称
	 * @param		string		$Value			条件値
	 * @param		string		$Attribute		カラム属性
	 * @param		string		$Operator		演算子
	 * @return		string		生成されたSQL
	 */
	function getAgeCondition($ColumnName = NULL, $Now = 'NOW()', $Value = NULL, $Operator = '='){
		if ($ColumnName == NULL) {
			$this->Err = "Variable ColumnName Must Be Required.";
			return FALSE;
		}
		if ($Value == NULL)
			return NULL;

		$condition = "date_part('year', age('" . $Now . "', " . $ColumnName . ")::INTERVAL) " . $Operator . " " . $Value;

		return $condition;
	}
}
?>