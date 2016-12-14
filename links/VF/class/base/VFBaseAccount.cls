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
include_once _AS_CLS_DIR . 'ASDataObjects.cls';

class BaseAccount extends ASDataObjects {
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
	 * データベースインスタンスのプロパティへの格納等を行なっています。
	 * 
	 * @access		public
	 * @param		object		$myDB		データベースへのインスタンス
	 * @param		integer		$AccountCD		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function __construct ($myDB = NULL,$AccountCD = -1) {
		if ($myDB == NULL) {
			$GLOBALS['ExecuteError'][] = get_class($this) . " : データベースへのコネクションがありません";
			return FALSE;
		}

		$this->myDB = $myDB;
		$this->TableName = "tAccountM";

		return TRUE;
	}

	/**
	 * プロパティ初期化処理
	 * 全てのプロパティを初期化します。
	 * 
	 * @access		public
	 */
	public function initialize(){
		$this->AccountCD = NULL;
		$this->AccountName = NULL;
		$this->EMail = NULL;
		$this->AccountID = NULL;
		$this->AccountPW = NULL;
		$this->AccountKey = NULL;
		$this->Authority = NULL;
		$this->Disabled = NULL;
		$this->DelFlag = NULL;
		$this->DelDate = NULL;
		$this->CreateDate = NULL;
		$this->UpdateDate = NULL;
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
			list(
				$this->AccountCD,
				$this->AccountName,
				$this->EMail,
				$this->AccountID,
				$this->AccountPW,
				$this->AccountKey,
				$this->Authority,
				$this->Disabled,
				$this->DelFlag,
				$this->DelDate,
				$this->CreateDate,
				$this->UpdateDate,
			) = $this->myDB->fetchRowData($this->tmprtn,$RowNo);

		}
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
		if ($this->AccountCD < 0) {
			// プライマリキー取得とデフォルト値セット
			//$maxCD = $this->myDB->getSequence('tAccountM_seq');

			$this->Created = 'NOW()';
			$this->Modified = 'NOW()';

			// インサート
			$sqlMoji = "INSERT INTO $this->TableName (";
			$sqlMoji .= "`AccountName`";
			if ($this->EMail != NULL) $sqlMoji .= ", `EMail`";
			if ($this->AccountID != NULL) $sqlMoji .= ", `AccountID`";
			if ($this->AccountPW != NULL) $sqlMoji .= ", `AccountPW`";
			if ($this->AccountKey != NULL) $sqlMoji .= ", `AccountKey`";
			if ($this->Authority != NULL) $sqlMoji .= ", `Authority`";
			if ($this->Disabled != NULL) $sqlMoji .= ", `Disabled`";
			if ($this->DelFlag != NULL) $sqlMoji .= ", `DelFlag`";
			if ($this->DelDate != NULL) $sqlMoji .= ", `DelDate`";
			if ($this->CreateDate != NULL) $sqlMoji .= ", `CreateDate`";
			if ($this->UpdateDate != NULL) $sqlMoji .= ", `UpdateDate`";
			$sqlMoji .= ") VALUES (";
			$sqlMoji .= "'" . DBConnection::escapeString($this->AccountName) . "'";
			if ($this->EMail != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->EMail) . "'";
			if ($this->AccountID != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->AccountID) . "'";
			if ($this->AccountPW != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->AccountPW) . "'";
			if ($this->AccountKey != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->AccountKey) . "'";
			if ($this->Authority != NULL) $sqlMoji .= ", $this->Authority";
			if ($this->Disabled != NULL) $sqlMoji .= ", $this->Disabled";
			if ($this->DelFlag != NULL) $sqlMoji .= ", $this->DelFlag";
			if ($this->DelDate != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->DelDate) . "'";
			if ($this->CreateDate != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->CreateDate) . "'";
			if ($this->UpdateDate != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->UpdateDate) . "'";
			$sqlMoji .= ")";

			$rtn = $this->myDB->executeQuery($sqlMoji);
			if (!$rtn){
				$GLOBALS['ExecuteError'][] = get_class($this) . " : 追加処理に失敗しました。";
				return FALSE;
			}

			$this->AccountCD = mysql_insert_id();
			//$this->AccountCD = $maxCD;
		} else {
			// プライマリキー取得とデフォルト値セット
			$this->Modified = 'NOW()';

			// アップデート
			$sqlMoji = "UPDATE $this->TableName SET ";
			$sqlMoji .= "`AccountCD` = $this->AccountCD";
			$sqlMoji .= ", `AccountName` = " . $this->convertNullStringValue($this->AccountName);
			$sqlMoji .= ", `EMail` = " . $this->convertNullStringValue($this->EMail);
			$sqlMoji .= ", `AccountID` = " . $this->convertNullStringValue($this->AccountID);
			$sqlMoji .= ", `AccountPW` = " . $this->convertNullStringValue($this->AccountPW);
			$sqlMoji .= ", `AccountKey` = " . $this->convertNullStringValue($this->AccountKey);
			$sqlMoji .= ", `Authority` = " . $this->convertNullIntValue($this->Authority);
			$sqlMoji .= ", `Disabled` = " . $this->convertNullIntValue($this->Disabled);
			$sqlMoji .= ", `DelFlag` = " . $this->convertNullIntValue($this->DelFlag);
			$sqlMoji .= ", `DelDate` = " . $this->convertNullStringValue($this->DelDate);
			$sqlMoji .= ", `CreateDate` = " . $this->convertNullStringValue($this->CreateDate);
			$sqlMoji .= ", `UpdateDate` = " . $this->convertNullStringValue($this->UpdateDate);
			$sqlMoji .= " WHERE `AccountCD` = $this->AccountCD";

			$rtn = $this->myDB->executeQuery($sqlMoji);
			if (!$rtn){
				$GLOBALS['ExecuteError'][] = get_class($this) . " : 更新処理に失敗しました。";
				return FALSE;
			}
		}

		if ($SerializeFlg) {
			$this->RecCnt = 1;
			$this->serializeThis($this->AccountCD);
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
	 * @param		integer		$AccountCD		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function getAccountByAccountCD($AccountCD, $ForUpdateFlg = FALSE, $UnserializeFlg = FALSE){
		if ($AccountCD == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : Variable AccountCD is required. ";
			return FALSE;
		}

		// シリアル化されたオブジェクトを戻す場合に利用
		if ($UnserializeFlg) {
			if ($this->unserializeThis($AccountCD))
				return TRUE;
		}

		if (!$this->executeSelect('AccountCD = ' . $AccountCD, NULL, $ForUpdateFlg)){
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
	 * @param		integer		$AccountCD		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function dropAccountByAccountCD($AccountCD){
		if ($AccountCD == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : Variable AccountCD is required. ";
			return FALSE;
		}

		if (!$this->executeDelete('AccountCD = ' . $AccountCD)){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : プライマリキーによる削除に失敗しました。";
			return FALSE;
		}

		$this->removeSerializedFile($AccountCD);

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

	/**
	 * 任意条件で検索
	 * 
	 * @access		private
	 * @param		object		$SearchObj	検索パラメータ
	 * @param		object		$Operator	演算子
	 * @return		boolean		検索に成功すればTRUE
	 */ 
	public function getAccountByCondition($SearchObj, $Operator = array(), $NewestFlg = FALSE){
		$Condition = $this->getConditionSQL($SearchObj, $Operator);

		$Order = NULL;
		if ($NewestFlg)
			$Order = "AccountCD DESC LIMIT 1 OFFSET 0";

		if (!$this->executeSelect($Condition, $Order))
			return FALSE;

		return TRUE;
	}
}
