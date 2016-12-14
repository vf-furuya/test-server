<?php
/**
 * Tagクラス
 *
 * tTagMテーブルを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _AS_CLS_DIR . 'ASDataObjects.cls';

class BaseTag extends ASDataObjects {
	/**
	 * 連番
	 */
	public $TagCD;
	/**
	 * Site
	 */
	public $SiteCD;
	/**
	 * 表示順
	 */
	public $TagIndex;
	/**
	 * タグ
	 */
	public $Tag;
	/**
	 * head領域内に記載する
	 */
	public $HeadFlag;
	/**
	 * 出力抑制
	 */
	public $Disabled;
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
	 * @param		integer		$TagCD		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	function __construct ($myDB = NULL,$TagCD = -1) {
		if ($myDB == NULL) {
			$GLOBALS['ExecuteError'][] = get_class($this) . " : データベースへのコネクションがありません";
			return FALSE;
		}

		$this->myDB = $myDB;
		$this->TableName = "tTagM";

		return TRUE;
	}

	/**
	 * プロパティ初期化処理
	 * 全てのプロパティを初期化します。
	 * 
	 * @access		public
	 */
	public function initialize(){
		$this->TagCD = NULL;
		$this->SiteCD = NULL;
		$this->TagIndex = NULL;
		$this->Tag = NULL;
		$this->HeadFlag = NULL;
		$this->Disabled = NULL;
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
		$sqlMoji .= "`TagCD`";
		$sqlMoji .= ", `SiteCD`";
		$sqlMoji .= ", `TagIndex`";
		$sqlMoji .= ", `Tag`";
		$sqlMoji .= ", `HeadFlag`";
		$sqlMoji .= ", `Disabled`";
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
				$this->TagCD,
				$this->SiteCD,
				$this->TagIndex,
				$this->Tag,
				$this->HeadFlag,
				$this->Disabled,
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
		if ($this->TagCD < 0) {
			// プライマリキー取得とデフォルト値セット
			//$maxCD = $this->myDB->getSequence('tTagM_seq');

			$this->Created = 'NOW()';
			$this->Modified = 'NOW()';

			// インサート
			$sqlMoji = "INSERT INTO $this->TableName (";
			$sqlMoji .= "`SiteCD`";
			if ($this->TagIndex != NULL) $sqlMoji .= ", `TagIndex`";
			if ($this->Tag != NULL) $sqlMoji .= ", `Tag`";
			if ($this->HeadFlag != NULL) $sqlMoji .= ", `HeadFlag`";
			if ($this->Disabled != NULL) $sqlMoji .= ", `Disabled`";
			if ($this->CreateDate != NULL) $sqlMoji .= ", `CreateDate`";
			if ($this->UpdateDate != NULL) $sqlMoji .= ", `UpdateDate`";
			$sqlMoji .= ") VALUES (";
			$sqlMoji .= "$this->SiteCD";
			if ($this->TagIndex != NULL) $sqlMoji .= ", $this->TagIndex";
			if ($this->Tag != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->Tag) . "'";
			if ($this->HeadFlag != NULL) $sqlMoji .= ", $this->HeadFlag";
			if ($this->Disabled != NULL) $sqlMoji .= ", $this->Disabled";
			if ($this->CreateDate != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->CreateDate) . "'";
			if ($this->UpdateDate != NULL) $sqlMoji .= ", '" . DBConnection::escapeString($this->UpdateDate) . "'";
			$sqlMoji .= ")";

			$rtn = $this->myDB->executeQuery($sqlMoji);
			if (!$rtn){
				$GLOBALS['ExecuteError'][] = get_class($this) . " : 追加処理に失敗しました。";
				return FALSE;
			}

			$this->TagCD = mysql_insert_id();
			//$this->TagCD = $maxCD;
		} else {
			// プライマリキー取得とデフォルト値セット
			$this->Modified = 'NOW()';

			// アップデート
			$sqlMoji = "UPDATE $this->TableName SET ";
			$sqlMoji .= "`TagCD` = $this->TagCD";
			$sqlMoji .= ", `SiteCD` = " . $this->convertNullIntValue($this->SiteCD);
			$sqlMoji .= ", `TagIndex` = " . $this->convertNullIntValue($this->TagIndex);
			$sqlMoji .= ", `Tag` = " . $this->convertNullStringValue($this->Tag);
			$sqlMoji .= ", `HeadFlag` = " . $this->convertNullIntValue($this->HeadFlag);
			$sqlMoji .= ", `Disabled` = " . $this->convertNullIntValue($this->Disabled);
			$sqlMoji .= ", `CreateDate` = " . $this->convertNullStringValue($this->CreateDate);
			$sqlMoji .= ", `UpdateDate` = " . $this->convertNullStringValue($this->UpdateDate);
			$sqlMoji .= " WHERE `TagCD` = $this->TagCD";

			$rtn = $this->myDB->executeQuery($sqlMoji);
			if (!$rtn){
				$GLOBALS['ExecuteError'][] = get_class($this) . " : 更新処理に失敗しました。";
				return FALSE;
			}
		}

		if ($SerializeFlg) {
			$this->RecCnt = 1;
			$this->serializeThis($this->TagCD);
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
	 * @param		integer		$TagCD		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function getTagByTagCD($TagCD, $ForUpdateFlg = FALSE, $UnserializeFlg = FALSE){
		if ($TagCD == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : Variable TagCD is required. ";
			return FALSE;
		}

		// シリアル化されたオブジェクトを戻す場合に利用
		if ($UnserializeFlg) {
			if ($this->unserializeThis($TagCD))
				return TRUE;
		}

		if (!$this->executeSelect('TagCD = ' . $TagCD, NULL, $ForUpdateFlg)){
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
	 * @param		integer		$TagCD		プライマリキー
	 * @return		boolean		処理に成功すればTRUE、失敗すればFALSE
	 */
	public function dropTagByTagCD($TagCD){
		if ($TagCD == NULL){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : Variable TagCD is required. ";
			return FALSE;
		}

		if (!$this->executeDelete('TagCD = ' . $TagCD)){
			$GLOBALS['ExecuteError'][] = get_class($this) . " : プライマリキーによる削除に失敗しました。";
			return FALSE;
		}

		$this->removeSerializedFile($TagCD);

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
		if (isset($SearchObj['TagCD'])) $Conditions[] = ASDataObjects::getConditionByOperator('TagCD', $SearchObj['TagCD'], 'int', $Operator['TagCD']);
		if (isset($SearchObj['SiteCD'])) $Conditions[] = ASDataObjects::getConditionByOperator('SiteCD', $SearchObj['SiteCD'], 'int', $Operator['SiteCD']);
		if (isset($SearchObj['TagIndex'])) $Conditions[] = ASDataObjects::getConditionByOperator('TagIndex', $SearchObj['TagIndex'], 'int2', $Operator['TagIndex']);
		if (isset($SearchObj['Tag'])) $Conditions[] = ASDataObjects::getConditionByOperator('Tag', $SearchObj['Tag'], 'blob', $Operator['Tag']);
		if (isset($SearchObj['HeadFlag'])) $Conditions[] = ASDataObjects::getConditionByOperator('HeadFlag', $SearchObj['HeadFlag'], 'int2', $Operator['HeadFlag']);
		if (isset($SearchObj['Disabled'])) $Conditions[] = ASDataObjects::getConditionByOperator('Disabled', $SearchObj['Disabled'], 'int2', $Operator['Disabled']);
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
	public function getTagByCondition($SearchObj, $Operator = array(), $NewestFlg = FALSE){
		$Condition = $this->getConditionSQL($SearchObj, $Operator);

		$Order = NULL;
		if ($NewestFlg)
			$Order = "TagCD DESC LIMIT 1 OFFSET 0";

		if (!$this->executeSelect($Condition, $Order))
			return FALSE;

		return TRUE;
	}
}
