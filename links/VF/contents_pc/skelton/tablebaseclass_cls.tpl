<?php
/**
 * __ClassName__クラス
 *
 * __TableName__テーブルを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _AS_CLS_DIR . 'ASDataObjects.cls';

class Base__ClassName__ extends ASDataObjects {
__LinesLoop__	/**
	 * __ColumnTitle__
	 */
	public $__ColumnName__;
__LinesLoop__
	/**
	 * コンストラクタ
	 * データベースインスタンスのプロパティへの格納等を行なっています。
	 * 
	 * @access		public
	 * @param		object		$myDB		データベースへのインスタンス
	 * @param		integer		$__PrimaryKey__		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function __construct ($myDB = NULL,$__PrimaryKey__ = -1) {
		if ($myDB == NULL) {
			$GLOBALS['ExecuteError'][] = get_class($this) . " : データベースへのコネクションがありません";
			return FALSE;
		}

		$this->myDB = $myDB;
		$this->TableName = "__TableName__";

		return TRUE;
	}

	/**
	 * プロパティ初期化処理
	 * 全てのプロパティを初期化します。
	 * 
	 * @access		public
	 */
	public function initialize(){
__LinesLoop__		$this->__ColumnName__ = NULL;
__LinesLoop__	}

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
__LinesLoop__		__IfFirst__$sqlMoji .= "`__ColumnName__`";__IfFirst____IfNotFirst__$sqlMoji .= ", `__ColumnName__`";__IfNotFirst__
__LinesLoop__		$sqlMoji .= " FROM $this->TableName";

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
			list(
__LinesLoop__				$this->__ColumnName__,
__LinesLoop__			) = $this->myDB->fetchRowData($this->tmprtn,$RowNo);

__LinesLoop____IfBool__			$this->__ColumnName__ = $this->convertFlgToBoolean($this->__ColumnName__);
__IfBool____LinesLoop__		}
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
		
		// 新規
		if ($this->__PrimaryKey__ < 0) {
			// プライマリキー取得とデフォルト値セット
			//$maxCD = $this->myDB->getSequence('__TableName___seq');

			$this->Created = 'NOW()';
			$this->Modified = 'NOW()';

			// インサート
			$sqlMoji = "INSERT INTO $this->TableName (";
__LinesLoop__			__IfFirst__$sqlMoji .= "`__ColumnName__`";__IfFirst____IfNotFirst__if ($this->__ColumnName__ != NULL) $sqlMoji .= ", `__ColumnName__`";__IfNotFirst__
__LinesLoop__			$sqlMoji .= ") VALUES (";
__LinesLoop____IfFirst__			$sqlMoji .= "''";
__IfFirst____IfUsual__			if ($this->__ColumnName__ != NULL) $sqlMoji .= ", $this->__ColumnName__";
__IfUsual____IfText__			if ($this->__ColumnName__ != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->__ColumnName__) . "'";
__IfText____IfBool__			if ($this->__ColumnName__ != NULL) $sqlMoji .= ", " . $this->convertFlgToString($this->__ColumnName__);
__IfBool____LinesLoop__			$sqlMoji .= ")";

			$rtn = $this->myDB->executeQuery($sqlMoji);
			if (!$rtn){
				$GLOBALS['ExecuteError'][] = get_class($this) . " : 追加処理に失敗しました。";
				return FALSE;
			}

			$this->__PrimaryKey__ = mysql_insert_id();
			//$this->__PrimaryKey__ = $maxCD;
		} else {
			// プライマリキー取得とデフォルト値セット
			$this->Modified = 'NOW()';

			// アップデート
			$sqlMoji = "UPDATE $this->TableName SET ";
__LinesLoop____IfFirst__			$sqlMoji .= "`__ColumnName__` = $this->__ColumnName__";
__IfFirst____IfNotFirst____IfUsual__			$sqlMoji .= ", `__ColumnName__` = " . $this->convertNullIntValue($this->__ColumnName__);
__IfUsual____IfText__			$sqlMoji .= ", `__ColumnName__` = " . $this->convertNullStringValue($this->__ColumnName__);
__IfText____IfBool__			$sqlMoji .= ", `__ColumnName__` = " . $this->convertFlgToString($this->__ColumnName__);
__IfBool____LinesLoop__			$sqlMoji .= " WHERE `__PrimaryKey__` = $this->__PrimaryKey__";

			$rtn = $this->myDB->executeQuery($sqlMoji);
			if (!$rtn){
				$GLOBALS['ExecuteError'][] = get_class($this) . " : 更新処理に失敗しました。";
				return FALSE;
			}
		}

		if ($SerializeFlg) {
			$this->RecCnt = 1;
			$this->serializeThis($this->__PrimaryKey__);
		}

		return TRUE;
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
	 * プライマリキーでの抽出
	 * 与えられたプライマリキーを持つレコードを抽出します。
	 * 
	 * @access		public
	 * @param		integer		$__PrimaryKey__		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function get__ClassName__By__PrimaryKey__($__PrimaryKey__, $ForUpdateFlg = FALSE, $UnserializeFlg = FALSE){
		if ($__PrimaryKey__ == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : Variable __PrimaryKey__ is required. ";
			return FALSE;
		}

		// シリアル化されたオブジェクトを戻す場合に利用
		if ($UnserializeFlg) {
			if ($this->unserializeThis($__PrimaryKey__))
				return TRUE;
		}

		if (!$this->executeSelect('__PrimaryKey__ = ' . $__PrimaryKey__, NULL, $ForUpdateFlg)){
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
	 * @param		integer		$__PrimaryKey__		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function drop__ClassName__By__PrimaryKey__($__PrimaryKey__){
		if ($__PrimaryKey__ == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : Variable __PrimaryKey__ is required. ";
			return FALSE;
		}

		if (!$this->executeDelete('__PrimaryKey__ = ' . $__PrimaryKey__)){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : プライマリキーによる削除に失敗しました。";
			return FALSE;
		}

		$this->removeSerializedFile($__PrimaryKey__);

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
__LinesLoop__		if (isset($SearchObj['__ColumnName__'])) $Conditions[] = ASDataObjects::getConditionByOperator('__ColumnName__', $SearchObj['__ColumnName__'], '__DataType__', $Operator['__ColumnName__']);
__LinesLoop__

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

	/**
	 * 任意条件で検索
	 * 
	 * @access		private
	 * @param		object		$SearchObj	検索パラメータ
	 * @param		object		$Operator	演算子
	 * @return		boolean		検索に成功すればTRUE
	 */ 
	public function get__ClassName__ByCondition($SearchObj, $Operator = array(), $NewestFlg = FALSE){
		$Condition = $this->getConditionSQL($SearchObj, $Operator);

		$Order = NULL;
		if ($NewestFlg)
			$Order = "__PrimaryKey__ DESC LIMIT 1 OFFSET 0";

		if (!$this->executeSelect($Condition, $Order))
			return FALSE;

		return TRUE;
	}
}
