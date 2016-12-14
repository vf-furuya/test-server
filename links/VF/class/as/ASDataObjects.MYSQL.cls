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

class ASDataObjectsMYSQL {
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
	 * 直近のデータセット
	 */
	var $CurrentDataSet;

	/**
	 * コンストラクタ
	 * 現状処理なし。
	 * 
	 * @access		public
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function ASDataObjectsMYSQL() {
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
	 * 整数プロパティを更新用のSQLとして適切なように変換します。
	 * 
	 * @access		public
	 * @param		integer		$value		処理対象数値
	 * @return		integer		変換後数値
	 */
	function convertNullFloatValue($value){
		if ($value === "" || $value === NULL)
			return "NULL";
		else
			return floatval($value);
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
		if ($Value === NULL)
			return NULL;

		if ($Operator == NULL)
			$Operator = '=';

		/*
		if ($Attribute == 'INT8')
			$condition = $ColumnName . " " . $Operator . " " . $Value . "::INT8";
		else if ($Attribute == 'INT2')
			$condition = $ColumnName . " " . $Operator . " " . $Value . "::INT2";
		else 
		*/
		if ($Attribute == 'TEXT' || $Attribute == 'VARCHAR')
			$condition = $ColumnName . " " . $Operator . " '" . DBConnection::escapeString($Value) . "'";
		else if ($Attribute == 'DATETIME' || $Attribute == 'TIMESTAMP')
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

	/**
	 * 任意条件による物理削除処理
	 * Conditionに入った任意の条件によるDELETE処理を行ないます。
	 * 
	 * @access		public
	 * @param		integer		$Condition		抽出条件SQL
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function executeDelete($Condition = NULL){
		if ($Condition == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : Variable Condition is required. ";
			return FALSE;
		}

		//設定
		if ($this->myDB == NULL) {
			$GLOBALS['ExecuteError'][] = get_class($this) . " : データベースへのコネクションがありません";
			return FALSE;
		}
		
		// SQL セット
		$sqlMoji = "DELETE FROM $this->TableName";
		$sqlMoji .= " WHERE " . $Condition;

		$rtn = $this->myDB->executeQuery($sqlMoji);
		if (!$rtn){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : レコード削除に失敗しました。";
			return FALSE;
		}

		return TRUE;
	}

	/**
	 * 任意条件による件数取得処理
	 * Conditionに入った任意の条件によるCOUNT取得処理を行ないます。
	 * 
	 * @access		public
	 * @param		integer		$Condition		抽出条件SQL
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function getCount($Condition = NULL){
		//設定
		if ($this->myDB == NULL) {
			$GLOBALS['ExecuteError'][] = get_class($this) . " : データベースへのコネクションがありません";
			return FALSE;
		}
		
		// SQL セット
		$sqlMoji = "SELECT COUNT(*) FROM $this->TableName";
		$sqlMoji .= " WHERE " . $Condition;

		$rtn = $this->myDB->getOneValue($sqlMoji);
		if ($rtn === FALSE){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : レコード取得に失敗しました。";
			return FALSE;
		}

		return $rtn;
	}

	/**
	 * 新型SearchObjectで検索
	 * 
	 * @access		private
	 * @param		object		$criteria	検索パラメータ(Criteriaクラス)
	 * @return		boolean		検索に成功すればTRUE
	 */ 
	function search($criteria=NULL, $Order=NULL) {
		$Condition = $criteria!=NULL ? $criteria->getCondition() : NULL;

		if (!$this->executeSelect($Condition, $Order))
			return FALSE;

		return TRUE;

	}

	/**
	 * 任意条件によるレコード抽出処理
	 * WhereStrに入った任意の条件によるSELECT処理を行ないます。
	 * OrderByStrに入った任意の条件による抽出順指定やLIMIT/OFFSETも可能です。。
	 * 
	 * @access		public
	 * @param		string		$WhereStr		抽出条件
	 * @param		string		$OrderByStr		ソート順指定
	 * @param		boolean		$ForUpdateFlg	行ロック付きで抽出の場合TRUE
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function executeSelect($WhereStr = NULL, $OrderByStr = NULL, $ForUpdateFlg = FALSE){
		//設定
		if ($this->myDB == NULL) {
			$GLOBALS['ExecuteError'][] = get_class($this) . " : データベースへのコネクションがありません";
			return FALSE;
		}
		
		// ページプロパティ取得
		$sqlMoji = "SELECT ";

		$fld = $this->getFieldNames();
		for ($i=0; $i<count($fld); $i++) {
			if ($i>0) $sqlMoji .= ", ";
			$sqlMoji .= $fld[$i];
		}
		$sqlMoji .= " FROM $this->TableName";

		if($WhereStr != NULL)
			$sqlMoji = $sqlMoji . " WHERE " . $WhereStr;

		if($OrderByStr != NULL)
			$sqlMoji = $sqlMoji . " ORDER BY " . $OrderByStr;

		if($ForUpdateFlg)
			$sqlMoji = $sqlMoji . " FOR UPDATE";

		$rtn = $this->myDB->executeQuery($sqlMoji);
		if (!$rtn){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : レコード取得に失敗しました。";
			return FALSE;
		}
		else{
			$this->RecCnt = $this->myDB->getNumberOfRows($rtn);
			if ($this->RecCnt == 1){
				$this->tmprtn = $rtn;
				$this->getDataSet(0);
			}
			else if($this->RecCnt > 1){
				$this->tmprtn = $rtn;
			}
		}

		return TRUE;
	}

	/**
	 * 抽出したレコードの格納
	 * タプルの行番号を指定して、そのレコードをプロパティに格納します。
	 * 
	 * @access		public
	 * @param		integer		$RowNo		レコード番号
	 */
	//タプル取得
	public function getDataSet($RowNo){
		if($RowNo >= $this->RecCnt){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : 行番号が不正です";
			return FALSE;
		}
		else{
			$data = $this->myDB->fetchArray($this->tmprtn,$RowNo);

			foreach ($this->FieldMap as $k=>$v) {
				$this->{$k} = $data[$k];
				$this->CurrentDataSet[$k] = $data[$k];

				if ($v=="BOOL") {
					$this->{$k} = $this->convertFlgToBoolean($this->{$k});
					$this->CurrentDataSet[$k] = $this->convertFlgToBoolean($this->{$k});
				}
			}
		}
	}

	public function getCurrentResult($fieldName) {
		return $this->CurrentDataSet[$fieldName];
	}


	/**
	 * レコード更新処理
	 * プライマリキー条件によってINSERTないしはUPDATEの処理を行ないます。
	 * 
	 * @access		public
	 * @param		boolean		$SerializeFlg	シリアル化ファイルを保管する場合TRUE
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function executeUpdate($SerializeFlg = FALSE) {
		// 設定
		if ($this->myDB == NULL) {
			$GLOBALS['ExecuteError'][] = get_class($this) . " : データベースへのコネクションがありません";
			return FALSE;
		}

		$fld = $this->getFieldNames();
		$pk = $this->getPrimaryKey();

		// 新規
		if ($this->{$pk} < 0) {
			// プライマリキー取得とデフォルト値セット
			$maxCD = $this->myDB->getSequence($this->TableName.'_seq');

			$this->Created = 'NOW()';
			$this->Updated = 'NOW()';

			// インサート
			$sqlMoji = "INSERT INTO $this->TableName (";
			$sqlMoji .= $pk;
			for ($i=0; $i<count($fld); $i++) {
				$field = $fld[$i];
//				if (($this->{$fld[$i]}===0 || isset($this->{$fld[$i]})) && $fld[$i]!=$pk) {
				if ($this->{$field}!==NULL && $this->{$field}!=="" && ($this->{$field}===0 || !empty($this->{$field})) && $field!=$pk) {
					$sqlMoji .= ", ".$field;
				}
			}

			$sqlMoji .= ") VALUES (";
			$sqlMoji .= "$maxCD";
			for ($i=0; $i<count($fld); $i++) {
				$field = $fld[$i];
//				if (($this->{$field}===0 || isset($this->{$field})) && $field!=$pk) {
				if ($this->{$field}!==NULL && $this->{$field}!=="" && ($this->{$field}===0 || !empty($this->{$field})) && $field!=$pk) {
					if ($this->FieldMap[$field] == "TEXT" || $this->FieldMap[$field] == "TIMESTAMP"
					  ||$this->FieldMap[$field] == "DATE") {
						$sqlMoji .= ", '" . DBConnection::escapeString($this->{$field}) . "'";
					}
					else if ($this->FieldMap[$field] == "BOOL" || $this->FieldMap[$field] == "BOOLEAN") {
						$sqlMoji .= ", " . $this->convertFlgToString($this->{$field});
					}
					else {
						$sqlMoji .= ", " . $this->{$field};
					}
				}
			}
			$sqlMoji .= ")";

			$rtn = $this->myDB->executeQuery($sqlMoji);
			if (!$rtn){
				$GLOBALS['ExecuteError'][] = get_class($this) . " : 追加処理に失敗しました。";
				return FALSE;
			}

			$this->{$pk} = $maxCD;
		} else {
			// プライマリキー取得とデフォルト値セット
			$this->Updated = 'NOW()';

			// アップデート
			$sqlMoji = "UPDATE $this->TableName SET ";

			$sqlMoji .= "$pk = " . $this->{$pk};
			foreach ($fld as $field) {
				if ($field==$pk) continue;
				switch ($this->FieldMap[$field]) {
					case "VARCHAR":
					case "TEXT":
						$sqlMoji .= ", $field = " . $this->convertNullStringValue($this->{$field}); break;
					case "BIT":
					case "INT4":
					case "INT2":
					case "INT":
					case "FLOAT":
						$sqlMoji .= ", $field = " . $this->convertNullIntValue($this->{$field}); break;
					case "BOOL":
					case "BOOLEAN":
						$sqlMoji .= ", $field = " . $this->convertFlgToString($this->{$field}); break;
					case "TIME":
					case "DATE":
					case "DATETIME":
					case "TIMESTAMP":
						$sqlMoji .= ", $field = " . $this->convertNullStringValue($this->{$field}); break;
					default:
						$sqlMoji .= ", $field = " . $this->convertNullStringValue($this->{$field}); break;
				}
			}

			$sqlMoji .= " WHERE $pk = " . $this->{$pk};

			$rtn = $this->myDB->executeQuery($sqlMoji);
			if (!$rtn){
				$GLOBALS['ExecuteError'][] = get_class($this) . " : 更新処理に失敗しました。";
				return FALSE;
			}
		}

		if ($SerializeFlg) {
			$this->RecCnt = 1;
			$this->serializeThis($this->{$pk});
		}

		return TRUE;
	}

	function is_empty(&$val) {
		if ($val===0) return FALSE;
		if (!isset($val)) return TRUE;
		if ($val===NULL) return TRUE;
		if ($val==="") return TRUE;
		return FALSE;
	}


	/**
	 * 任意条件の生成
	 * パラメータオブジェクト$SearchObj(主としてWEBからのPOSTパラメータ)から条件節を生成します。
	 * 
	 * @access		public
	 * @param		object		$SearchObj	検索パラメータ
	 * @param		object		$Operator	演算子
	 * @return		string		条件節SQL
	 */ 
	public function getConditionSQL($SearchObj, $Operator = array()) {
		foreach ($this->FieldMap as $field=>$type) {
			if (isset($SearchObj[$field])) $Conditions[] = self::getConditionByOperator($field, $SearchObj[$field], $type, $Operator[$field]);
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

	/**
	 * プライマリキーでの抽出
	 * 与えられたプライマリキーを持つレコードを抽出します。
	 * 
	 * @access		public
	 * @param		integer		$LogCD		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function getByPrimaryKey($pk, $ForUpdateFlg = FALSE, $UnserializeFlg = FALSE){
		if ($pk == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : Variable pk is required. ";
			return FALSE;
		}

		// シリアル化されたオブジェクトを戻す場合に利用
		if ($UnserializeFlg) {
			if ($this->unserializeThis($pk))
				return TRUE;
		}

		if (!$this->executeSelect($this->getPrimaryKey().' = ' . $pk, NULL, $ForUpdateFlg)){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : プライマリキーによる抽出に失敗しました。";
			return FALSE;
		}

		return TRUE;
	}

	/**
	 * プライマリキーでの削除
	 * 与えられたプライマリキーを持つレコードを削除します。
	 * 
	 * @access		public
	 * @param		integer		$pk		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function dropByPrimaryKey($pk){
		if ($pk == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : Variable pk is required. ";
			return FALSE;
		}

		if (!$this->executeDelete($this->getPrimaryKey().' = '.$pk)){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : プライマリキーによる削除に失敗しました。";
			return FALSE;
		}

		$this->removeSerializedFile($pk);

		return TRUE;
	}


}
?>