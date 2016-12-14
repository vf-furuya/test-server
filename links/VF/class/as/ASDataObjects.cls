<?php
/**
 * データオブジェクト用基底クラス
 *
 * データオブジェクトクラス群共通のメソッドを備えた基底クラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2005/04/25
 * @version 1.3
 **/

// 依存
include_once _AS_CLS_DIR . "ASLog.cls";
include_once _AS_CLS_DIR . "ASTools.cls";

class ASDataObjects {
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
	 * 対象テーブル名称
	 */
	var $TableName;

	/**
	 * コンストラクタ
	 * 現状処理なし。
	 * 
	 * @access		public
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function ASDataObjects() {
		return TRUE;
	}

	/**
	 * オブジェクトをPUBLISHします。
	 * 
	 * @access		private
	 */
	function serializeThis($PrimaryKey){
		$Obj = serialize($this);
		$filename = $this->getPublishFilename($PrimaryKey);
		ASTools::putFile($filename, $Obj);
		exec ('chmod 666 ' . $filename);

		//SiteControl::syncFile($filename);
	}

	/**
	 * PUBLISHされたオブジェクトを戻して自身に反映します。
	 * 
	 * @param		integer		$PrimaryKey		プライマリキー
	 * @access		private
	 */
	function unserializeThis($PrimaryKey){
		// $myDBはRESOURCE型なので、一度退避しないとunserializeで失われてしまう。
		/*$myDB = $this->myDB;

		$filename = $this->getPublishFilename($PrimaryKey);
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
	function removeSerializedFile($PrimaryKey = NULL){
		$filename = $this->getPublishFilename($PrimaryKey);
		exec ('rm -f ' . $filename);
	}

	/**
	 * PUBLISH保管用ファイル名を返します。
	 * 
	 * @param		integer		$PrimaryKey		プライマリキー
	 * @access		private
	 */
	function getPublishFilename($PrimaryKey = NULL){
		$filename = _PUBLISH_DIR . $this->TableName . '_' . sprintf('%08d', $PrimaryKey) . '.obj';

		return $filename;
	}

	/**
	 * フラグプロパティを更新用のSQLとして適切なように変換します。
	 * 
	 * @access		public
	 * @param		boolean		$value		処理対象フラグ
	 * @return		boolean		変換後フラグ
	 */
	function convertFlgToString($flg){
		if ($flg == "true" || $flg == "t")
			return "true";
		else if ($flg == "false" || $flg == "f")
			return "false";

		if ($flg == true || $flg == 1)
			return "true";
		else if ($flg === false || $flg === 0)
			return "false";

		return "false";
	}

	/**
	 * SQLから取得したフラグプロパティをBool判定できる値として適切なように変換します。
	 * 
	 * @access		public
	 * @param		boolean		$value		処理対象フラグ
	 * @return		boolean		変換後フラグ
	 */
	function convertFlgToBoolean($flg){
		if ($flg == "t" || $flg == "1")
			return TRUE;
		else if ($flg == "f" || $flg == "0")
			return FALSE;
	}

	/**
	 * 整数プロパティを更新用のSQLとして適切なように変換します。
	 * 
	 * @access		public
	 * @param		integer		$value		処理対象数値
	 * @return		integer		変換後数値
	 */
	function convertNullIntValue($value){
		if ($value === "" || $value === NULL)
			return "NULL";
		else
			return intval($value);
	}

	/**
	 * 文字列プロパティを更新用のSQLとして適切なように変換します。
	 * 
	 * @access		public
	 * @param		string		$value		処理対象文字列
	 * @return		string		変換後文字列
	 */
	function convertNullStringValue($value){
		if ($value == "")
			return "NULL";
		else
			return "'" . DBConnection::escapeString($value) . "'";
	}

	/**
	 * テーブルロック
	 * 排他的処理ロックをテーブルに対してかけます。
	 * ロックレベルは引数によって指定することが可能です。
	 * 
	 * @access		public
	 * @param		string		$locklevel		ロックレベル
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function lockTable($lockLevel = "EXCLUSIVE"){
		// ログ準備
		$myLog = new ASLog();

		$lockString = "LOCK TABLE " . $this->TableName . " IN SHARE ROW " . $lockLevel . " MODE";
		$rtn = $this->myDB->executeQuery($lockString);
		if (!$rtn){
			$this->Err = "テーブルのロックに失敗しました。" . $this->myDB->Err;
			$myLog->error("ClassName : " . get_class($this) . " : " . $this->Err);
			unset($myLog);
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * 複数値をエンコードします。
	 * 
	 * @access		public
	 * @param		string		$Value		処理対象値
	 * @return		string		処理後値
	 */
	function encodePluralValue($Value, $Separator = '|'){
		if (is_array($Value)) {
			for ($i = 0; $i < count($Value); $i++) {
				if ($i > 0)
					$Encoded .= $Separator;
				$Encoded .= $Value[$i];
			}
		}
		else
			$Encoded = $Value;

		$Encoded = '|' . $Encoded . '|';

		return $Encoded;
	}

	/**
	 * 複数値をデコードします。
	 * 
	 * @access		public
	 * @param		string		$value		処理対象値
	 * @return		string		処理後値
	 */
	function decodePluralValue($Value, $Separator = '|'){
		if (substr($Value, 0, 1) == '|')
			$Value = substr($Value, 1, -1);

		$Decoded = explode($Separator, $Value);

		return $Decoded;
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
	function getConditionByOperator($ColumnName = NULL, $Value = NULL, $Attribute = 'INT', $Operator = '='){
		if ($ColumnName === NULL) {
			$this->Err = "Variable ColumnName Must Be Required.";
			return FALSE;
		}
		if ($Value === NULL) {
			return NULL;
		}

		$Attribute = strtoupper($Attribute);

		/*
		if ($Attribute == 'INT8')
			$condition = $ColumnName . " " . $Operator . " " . $Value . "::INT8";
		else if ($Attribute == 'INT2')
			$condition = $ColumnName . " " . $Operator . " " . $Value . "::INT2";
		else 
		*/
		if ($Attribute == 'TEXT') {
			if ($Operator == 'LIKE')
				$condition = $ColumnName . " " . $Operator . " '%" . DBConnection::escapeString($Value) . "%'";
			else
				$condition = $ColumnName . " " . $Operator . " '" . DBConnection::escapeString($Value) . "'";
		}
		else if ($Attribute == 'TIMESTAMP')
			$condition = $ColumnName . " " . $Operator . " '" . DBConnection::escapeString($Value) . "'";
		else if ($Attribute == 'DATE')
			$condition = $ColumnName . "::DATE " . $Operator . " '" . DBConnection::escapeString($Value) . "'::DATE";
		else if ($Attribute == 'BOOLEAN' || $Attribute == 'BOOL') {
			if ($Value == 't' || $Value == TRUE || $Value == 1)
				$condition = $ColumnName . " " . $Operator . " TRUE";
			else
				$condition = $ColumnName . " " . $Operator . " FALSE";
		}
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
		if ($ColumnName === NULL) {
			$this->Err = "Variable ColumnName Must Be Required.";
			return FALSE;
		}
		if ($Value === NULL)
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
	function getORCondition($ColumnName = NULL, $Value = NULL, $PartlyFlg = FALSE){
		if ($ColumnName == NULL) {
			$this->Err = "Variable ColumnName Must Be Required.";
			return FALSE;
		}
		if ($Value == NULL)
			return NULL;

		for ($i = 0; $i < count($Value); $i++){
			if ($Value[$i] != NULL){
				if ($i == 0) $condition = "(";
				if ($i > 0) $condition .= " OR ";
				if ($PartlyFlg)
					$condition .= ASDataObjects::getPartlyEqualCondition($ColumnName, $Value[$i]);
				else
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
