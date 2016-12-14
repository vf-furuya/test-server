<?php
/**
 * DBConnectionクラス
 *
 * PostgreSQLへの接続とSQL実行を担うクラスです。
 *
 * 2004/10/20 FROM 0.1 TO 1.1
 * BEGIN/COMMIT/ROLLBACKの各処理を行うメソッド追加。このメソッドを使うことで、二重にBEGINされることはなくなる。
 * QUERY実行時のベンチマーク処理を行い、ログに記録される際に書き込まれるようにした。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA
 * @create  2003/01/31
 * @version 1.11
 **/

define ("EXIST_CLASS_DBCONNECTION","yes");

// 依存
include_once _AS_CLS_DIR . "ASLog.cls";

class DBConnection {
	/**
	 * コネクションID
	 */
	var $Connection;
	/**
	 * データベース名称
	 */
	var $DBNAME;
	/**
	 * ホスト名
	 */
	var $HOSTNAME;
	/**
	 * ポート番号
	 */
	var $PORT;
	/**
	 * 持続的接続の指定
	 */
	var $PERSISTENT;
	/**
	 * ログクラスへのインスタンス
	 */
	var $myLog;

	/**
	 * トランザクションフラグ
	 */
	var $TransactionFlg;
	/**
	 * トランザクションタイミング外部制御フラグ
	 */
	var $ExternalControl;

	/**
	 * コンストラクタ
	 * @access		public
	 * @param		String		$DBNAME		データベース名称
	 * @param		String		$HOSTNAME	接続先ホスト名称
	 * @param		String		$USERNAME	接続ユーザ名
	 * @param		String		$PASSWORD	接続パスワード
	 * @param		String		$PERSISTENT	持続的接続の指定
	 */
	function DBConnection ($DBNAME = NULL, $HOSTNAME = NULL, $USERNAME = NULL, $PASSWORD = NULL, $PORT = "5432", $PERSISTENT = FALSE) {
		// プロパティセット
		$this->DBNAME = $DBNAME;
		$this->HOSTNAME = $HOSTNAME;
		$this->PERSISTENT = $PERSISTENT;
		$this->PORT = $PORT;

		$this->myLog = new ASLog();

		// データベースの指定なし
		if ($DBNAME == NULL) {
			$GLOBALS['ExecuteError'][] = "データベースが指定されていません";
		} else {
			$this->open($USERNAME, $PASSWORD);

			// フラグを立ててる場合のみ行う(system.properties)
			if (_MYSQL_SET_NAMES_UTF8) {
				$this->executeQuery('set names utf8');
			}
		}

		$this->TransactionFlg = FALSE;
		$this->ExternalControl = FALSE;
	}
	
	/**
	 * データベースへの接続を開き、その結果を返します。
	 * @access		public
	 * @param		String		$USERNAME	接続ユーザ名
	 * @param		String		$PASSWORD	接続パスワード
	 * @return		bool		接続処理の結果
	 */
	function open($USERNAME = NULL, $PASSWORD = NULL) {
		$this->myLog->db("Open Connection for Database \"" . $this->DBNAME . "\".");

		// データベース名称チェック
		if ($this->DBNAME == NULL) {
			$GLOBALS['ExecuteError'][] = "データベースが指定されていません";
			$this->myLog->db("Open Connection for \"" . $this->DBNAME . "\" Failed.\n");
			return FALSE;
		}
		
		// USERNAME あり？(認証あり？)
		if ($USERNAME != NULL) {
			// 認証あり
			if ($this->HOSTNAME == "")
				$this->HOSTNAME = "localhost";

			// Persistent or Normal Connect
			$con = mysql_connect($this->HOSTNAME, $USERNAME, $PASSWORD) or die(mysql_error());
		}
		else {
			$con = mysql_connect($this->HOSTNAME) or die(mysql_error());
		}

		if (!$con) {
			$GLOBALS['ExecuteError'][] = "データベースに接続できませんでした";
			$this->myLog->db("Open Connection for \"" . $this->DBNAME . "\" Failed.\n");
			$this->Connection = FALSE;
			return FALSE;
		}
		else {
			$this->myLog->db("Open Connection for \"" . $this->DBNAME . "\" Successful.");
		}

		if (!mysql_select_db($this->DBNAME)) {
			$GLOBALS['ExecuteError'][] = "データベースを選択できませんでした";
			$this->myLog->db("Choose Database \"" . $this->DBNAME . "\" Failed.\n" . $this->Err);
			unset ($myLog);
			$this->Connection = FALSE;
			return FALSE;
		} else {
			$this->Connection = $con;
			$this->myLog->db("Choose Database \"" . $this->DBNAME . "\" Successful.");
			unset ($myLog);
			return TRUE;
		}
	} // end of function Open()

	/**
	 * データベースへの接続を閉じ、その結果を返します。
	 * @access		public
	 * @return		bool		接続クローズ処理の結果
	 */
	function close() {
		$this->myLog->db("Close Connection for Database \"" . $this->DBNAME . "\".");

		mysql_close($this->Connection);

		$this->myLog->db("Close Connection for \"" . $this->DBNAME . "\" Successful.");

		return TRUE;
	}

	/**
	 * 与えられたSQLを実行し、その結果を返します。
	 * @access		public
	 * @param		String		$sql	実行対象SQLステートメント
	 * @return		resource	クエリの実行結果
	 */
	function executeQuery($sql) {
		// SQLチェック
		if ($sql == NULL) {
			$GLOBALS['ExecuteError'][] = "SQLが指定されていません";
			$this->myLog->sql("executeQuery Failed : " . $sql . "\n");
			return FALSE;
		}

		// SQLが規定サイズより大きければエラー
		define('_MAX_SQL_SIZE', 1048576);
		if (strlen($sql) > _MAX_SQL_SIZE) {
			$GLOBALS['ExecuteError'][] = "SQLが長すぎます";
			$this->myLog->sql("executeQuery Failed : " . $sql . "\n");
			return FALSE;
		}

		$sql = $this->adjustQuery($sql);

		// ベンチマーク処理
		list($usec, $sec) = explode(" ",microtime());

		$this->myLog->sql("executeQuery : " . $sql);

		// 実行
		if (!($rtn = mysql_query($sql))){
			// ベンチマーク処理
			list($usec2, $sec2) = explode(" ",microtime()); 
			$leadtime = ((float) $sec2 + (float) $usec2) - ((float) $sec + (float) $usec);

			$GLOBALS['ExecuteError'][] = "SQL実行に失敗しました。" . $this->getError($rtn);
			$this->myLog->sql("executeQuery Failed [" . $leadtime . "] : " . $sql . "\n" . $this->getError($rtn));

			$this->transactionRollback(TRUE);
			$this->ExternalControl = FALSE;
			return FALSE;
		}

		// ベンチマーク処理
		list($usec2, $sec2) = explode(" ",microtime()); 
		$leadtime = ((float) $sec2 + (float) $usec2) - ((float) $sec + (float) $usec);

		$this->myLog->sql("executeQuery Successful [" . $leadtime . "] : " . $sql);

		return $rtn;
	}

	// MaxやCountを使うときに利用 1件だけ値を返す
	function getOneValue($sql) {
		$rtn = $this->executeQuery($sql);

		if (!$rtn) {
			$GLOBALS['ExecuteError'][] = "レコード取得に失敗しました" . $this->getError($rtn);
			return FALSE;
		}

		if ($this->getNumberOfRows($rtn) > 0) {
			$tmp = mysql_result($rtn,0,0);

			if ($tmp == NULL)
				return 0;
			else
				return mysql_result($rtn, 0, 0);
		}

		return 0;
	}

	/**
	 * 与えられたPostgreSQL用記法のSQLをMySQLで実行可能なよう調整します
	 *
	 * @access		private
	 * @param		String		$sql	実行対象SQLステートメント
	 * @return		String		加工後SQLステートメント
	 */
	function adjustQuery($sql) {
		$sql = str_replace(" = FALSE", " = 0", $sql);
		$sql = str_replace(" = false", " = 0", $sql);
		$sql = str_replace(", false,", ", 0,", $sql);
		$sql = str_replace(", false)", ", 0)", $sql);

		$sql = str_replace(" = TRUE", " = 1", $sql);
		$sql = str_replace(" = true", " = 1", $sql);
		$sql = str_replace(", true,", ", 1,", $sql);
		$sql = str_replace(", true)", ", 1)", $sql);

		$sql = str_replace("'now()'", "NOW()", $sql);
		$sql = str_replace("'NOW()'", "NOW()", $sql);

		return $sql;
	}

	/**
	 * 結果オブジェクトを参照して、抽出されたレコード数を調べます。
	 * 
	 * @access		public
	 * @param		string		$rtn	SQL実行結果オブジェクト
	 * @return		integer		抽出レコード数
	 */
	function getNumberOfRows($rtn) {
		return mysql_numrows($rtn);
	}

	/**
	 * 結果オブジェクトを参照して、抽出されたカラム数を調べます。
	 * 
	 * @access		public
	 * @param		string		$rtn	SQL実行結果オブジェクト
	 * @return		integer		抽出カラム数
	 */
	function getNumberOfColumns($rtn) {
		return mysql_numfields($rtn);
	}

	/**
	 * 結果オブジェクトからデータを取り出します。
	 * 
	 * @access		public
	 * @param		string		$rtn	SQL実行結果オブジェクト
	 * @param		integer		$RowNo	結果番号
	 * @return		object		結果配列
	 */
	function fetchRowData($rtn, $RowNo) {
		mysql_data_seek($rtn,$RowNo);
		return mysql_fetch_row($rtn);
	}

	/**
	 * 結果オブジェクトから結果を取り出します。
	 * 
	 * @access		public
	 * @param		string		$rtn	SQL実行結果オブジェクト
	 * @param		integer		$col	カラム番号
	 * @param		integer		$row	行番号
	 * @return		object		結果配列
	 */
	function getResult($rtn, $col, $row) {
		return mysql_result($rtn, $col, $row);
	}

	/**
	 * 結果オブジェクトを参照して、影響を受けたレコード数を調べます。
	 * 主にUPDATE実行について利用されます。
	 * 
	 * @access		public
	 * @param		string		$rtn	SQL実行結果オブジェクト
	 * @return		integer		被影響レコード数
	 */
	function getAffectedRows($rtn) {
		return mysql_affected_rows($rtn);
	}

	/**
	 * 結果セットについて、エラーを返す。
	 * 
	 * @access		public
	 * @param		string		$rtn	SQL実行結果オブジェクト
	 * @return		integer		被影響レコード数
	 */
	function getError() {
		return mysql_error($this->Connection);
	}

	/**
	 * 指定されたシーケンスの次の値を求める
	 * 
	 * @access		public
	 * @param		string		$Sequence	シーケンス名
	 * @return		int			求めた値
	 */
	function getSequence($Sequence) {
		$sql = "UPDATE " . $Sequence . " SET ID=LAST_INSERT_ID(ID + 1)";
		if (!$this->executeQuery($sql))
			return FALSE;

		$sql = "SELECT LAST_INSERT_ID()";

		return $this->getOneValue($sql);
	}

	/**
	 * TRANSACTIONを開始します
	 * 各データクラス内でINSERTを行う場合、自動的にBEGINなどがかかりますが、クラス外部から複数の連続したINSERTを行いたい場合、多重BEGINとなってしまい、また、意図せずCOMMITしてしまうため、そういう場合には、$this->ExternalControlをTRUEにします。この時点でBEGINとCOMMITについては、明示的な指示がない限り実行されなくなります。"明示的な指示"とは、メソッドの引数がTRUEであることで、各クラス内のINSERTにおける呼び出しは、引数がFALSEなため無力化されます。
	 *
	 * @access		public
	 * @return		resource	クエリの実行結果
	 */
	function transactionBegin($doanyway = FALSE) {
		$okToDo = FALSE;

		// 既にBEGINされていれば無条件却下
		if ($this->TransactionFlg)
			$okToDo = FALSE;
		// 外部制御になっていて、明示的な指示が来ていればOK
		else if ($GLOBALS['ExternalControl'] && $doanyway)
			$okToDo = TRUE;
		// 外部制御になっていなければ無条件OK
		else if (!$GLOBALS['ExternalControl'])
			$okToDo = TRUE;

		if ($okToDo){
			$sql = "BEGIN";

			$rtn = $this->executeQuery($sql);

			if (!$rtn) {
				$GLOBALS['ExecuteError'][] = "TRANSACTION開始処理に失敗しました。" . $this->getError($rtn);
				return FALSE;
			}
		}

		$this->TransactionFlg = TRUE;

		return TRUE;
	}

	/**
	 * TRANSACTIONを正常終了します
	 *
	 * @access		public
	 * @return		resource	クエリの実行結果
	 */
	function transactionCommit($doanyway = FALSE) {
		$okToDo = FALSE;

		if ($GLOBALS['ExternalControl'] && $doanyway)
			$okToDo = TRUE;
		else if (!$GLOBALS['ExternalControl'])
			$okToDo = TRUE;

		if ($okToDo){
			$sql = "COMMIT";

			$rtn = $this->executeQuery($sql);

			if (!$rtn) {
				$GLOBALS['ExecuteError'][] = "TRANSACTION終了処理に失敗しました。" . $this->getError($rtn);
				return FALSE;
			}

			$this->TransactionFlg = FALSE;
		}

		return TRUE;
	}

	/**
	 * TRANSACTIONを中断します
	 *
	 * @access		public
	 * @return		resource	クエリの実行結果
	 */
	function transactionRollback() {
		$sql = "ROLLBACK";

		$rtn = $this->executeQuery($sql);

		if (!$rtn) {
			$GLOBALS['ExecuteError'][] = "TRANSACTION中断処理に失敗しました。" . $this->getError($rtn);
			return FALSE;
		}

		$this->TransactionFlg = FALSE;

		// ROLLBACKなので、外部制御フラグを倒す
		$GLOBALS['ExternalControl'] = FALSE;

		return TRUE;
	}

	/**
	 * トランザクションの外部コントロールを有効化します。
	 *
	 * @access		public
	 */
	function setExternalControl() {
		$GLOBALS['ExternalControl'] = TRUE;
	}

	/**
	 * トランザクションの外部コントロールを無効化します。
	 *
	 * @access		public
	 */
	function cancelExternalControl() {
		$GLOBALS['ExternalControl'] = FALSE;
	}

	/**
	 * 文字列をエスケープします。
	 *
	 * @access		public
	 */
	function escapeString($Value) {
		return mysql_escape_string($Value);
	}

	function getLastInsertId() {
		return mysql_insert_id();
	}
}
?>
