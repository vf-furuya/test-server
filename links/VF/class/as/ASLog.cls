<?php
/**
 * ASLogクラス
 *
 * 各種ログ記録を担います。
 * includeディレクトリの中にプロパティファイル"log.properties"が必要です。
 *
 * 2004/10/21 FROM 0.1 TO 1.1
 * ログが2GBを超えた場合、RotateするようにcheckFile/rotateLogの各メソッドを追加
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA
 * @create  2003/01/31
 * @version 1.1
 **/

define ("EXIST_CLASS_ASLOG","yes");

class ASLog {
	/**
	 * デバッグ用出力ファイル
	 */
	var $debugFile;
	/**
	 * DB処理出力ファイル
	 */
	var $dbFile;
	/**
	 * 実行SQL出力ファイル
	 */
	var $sqlFile;
	/**
	 * エラー出力ファイル
	 */
	var $errorFile;

	/**
	 * エラーメッセージ
	 */
	var $Err;
	
	/**
	 * コンストラクタ
	 * プロパティファイルからログファイルのパスを読み込み、クラスプロパティにセットします。
	 * directory.propertiesが呼出元で読み込まれていることが必要です。
	 * @access		public
	 */
	function ASLog () {
		// プロパティセット
		$this->debugFile = _DEBUG_LOG;
		$this->dbFile = _DB_LOG;
		$this->sqlFile = _SQL_LOG;
		$this->errorFile = _ERROR_LOG;
		
		// エラー初期化
		$this->Err = "";
	}

	/**
	 * デバッグ出力を記録します。
	 * @access		public
	 * @param		String		$logMsg		ログ出力メッセージ
	 * @return		bool		書込処理の結果
	 */
	function debug($logMsg){
		if ($this->debugFile == "")
			return FALSE;

		if (!$this->write($this->debugFile, $logMsg))
			return FALSE;

		return TRUE;
	}

	/**
	 * DB処理出力ファイルへの記録します。
	 * @access		public
	 * @param		String		$logMsg		ログ出力メッセージ
	 * @return		bool		書込処理の結果
	 */
	function db($logMsg){
		if ($this->dbFile == "")
			return FALSE;

		if (!$this->write($this->dbFile, $logMsg))
			return FALSE;

		return TRUE;
	}

	/**
	 * SQL処理出力ファイルへの記録します。
	 * @access		public
	 * @param		String		$logMsg		ログ出力メッセージ
	 * @return		bool		書込処理の結果
	 */
	function sql($logMsg){
		if ($this->sqlFile == "")
			return FALSE;

		if (!$this->write($this->sqlFile, $logMsg))
			return FALSE;

		return TRUE;
	}

	/**
	 * エラー出力ファイルへの記録します。
	 * @access		public
	 * @param		String		$logMsg		ログ出力メッセージ
	 * @return		bool		書込処理の結果
	 */
	function error($logMsg){
		if ($this->errorFile == "")
			return FALSE;

		if (!$this->write($this->errorFile, $logMsg))
			return FALSE;

		return TRUE;
	}

	/**
	 * メール送信ログファイルへの記録します。
	 * @access		public
	 * @param		String		$logMsg		ログ出力メッセージ
	 * @return		bool		書込処理の結果
	 */
	function mail($logMsg){
		if ($this->mailFile == "")
			return FALSE;

		if (!$this->write($this->mailFile, $logMsg))
			return FALSE;

		return TRUE;
	}

	/**
	 * 会員登録完了メールの送信履歴記録
	 *
	 * @access		public
	 * @param		integer		$MailCD		メールコード
	 * @param		integer		$Gender		性別
	 * @return		bool		書込処理の結果
	 */
	function writeRegistMailLog($MailCD, $SegmentCD, $Gender, $UserCD){
		$Filename = _LOG_DIR . 'registmail/' . date('Ymd') . '.log';

		$logMsg = $MailCD . "\t" . $SegmentCD . "\t" . $Gender . "\t" . $UserCD;

		if (!$this->write($Filename, $logMsg, TRUE))
			return FALSE;

		return TRUE;
	}

	/**
	 * アフィリエイトのクリック記録
	 *
	 * @access		public
	 * @param		string		$AffiliateID		アフィリエイトID
	 * @param		integer		$AffiliateCD		アフィリエイトコード
	 * @return		bool		書込処理の結果
	 */
	function writeAffiliateLog($AffiliateID, $AffiliateCD){
		$Filename = _LOG_DIR . 'affiliate/' . date('Ymd') . '.log';

		$UserAgent = $GLOBALS['_SERVER']['HTTP_USER_AGENT'];
		$CarrierName = $GLOBALS['MY_CARRIER_NAME'][$GLOBALS['MY_CARRIER']];

		$logMsg = sprintf('%08d', $AffiliateCD) . "\t" . $AffiliateID . "\t" . $UserAgent . "\t" . $CarrierName . "\t" . date('Y/m/d H:i:s');

		if (!$this->write($Filename, $logMsg, TRUE))
			return FALSE;

		return TRUE;
	}

	/**
	 * データベースへの接続を開き、その結果を返します。
	 * @access		private
	 * @param		String		$FileName	ログファイル名
	 * @param		String		$logMsg		ログ出力メッセージ
	 * @param		Bool		$SimpleFlg	ファイル名などの出力をするかしないか(するならFALSE)
	 * @return		bool		書込処理の結果
	 */
	function write($FileName = "", $logMsg = "", $SimpleFlg = FALSE) {
		global $PHP_SELF, $DEBUG;

/*		if (!$this->checkLog($FileName)){
			return FALSE;
		}*/

		// ファイル名称チェック
		if ($FileName == NULL) {
			$this->Err = "ファイル名が指定されていません";
			return FALSE;
		}

		if (!file_exists($FileName)) {
/*
			shell_exec("touch " . $FileName);
			shell_exec("chmod 666 " . $FileName);
*/
			return true;
		}

		if (!$fp = fopen($FileName, "a")){
			$this->Err = "ファイルがオープンできませんでした";
			return FALSE;
		}

		if (!flock($fp, LOCK_EX)){
			$this->Err = "ファイルがロックできませんでした";
			return FALSE;
		}

		if ($SimpleFlg) {
			fwrite($fp, date("Y/m/d H:i:s") . "\t" . $logMsg . "\n");
		}
		else {
			fwrite($fp, "[" . date("Y/m/d H:i:s") . "] " . $GLOBALS['_SERVER']['PHP_SELF'] . " \n");
			fwrite($fp, $logMsg . "\n\n");
		}

		if (!flock($fp, LOCK_UN)){
			$this->Err = "ファイルがロックできませんでした";
			return FALSE;
		}

		if (!fclose($fp)){
			$this->Err = "ファイルがクローズできませんでした";
			return FALSE;
		}

		return TRUE;
	}

	/**
	 * ログの容量及びパーミッションを調べます。
	 * @access		public
	 * @param		String		$filename		対象ファイル名
	 * @return		bool		書込処理の結果
	 */
	function checkLog($filename){
		$writableFlg = @is_writable($filename);
		$size = @filesize($filename);

		if ($writableFlg && $size < 1073741824)
			return TRUE;
		else if (!$writableFlg)
			return $this->createLog($filename);
		else if ($size > 1073741824)
			return $this->rotateLog($filename);
	}

	/**
	 * ログファイルを作成します。
	 * @access		public
	 * @param		String		$filename		対象ファイル名
	 * @return		bool		書込処理の結果
	 */
	function createLog($filename){
		// ファイルを作成
		$command = "touch " . $filename;
		$garvage = shell_exec ($command);
		$command = "chmod 666 " . $filename;
		$garvage = shell_exec ($command);

		// ファイルの存在を確認します。
		return is_writable($filename);
	}

	/**
	 * ログファイルを移動し、空のログファイルを作成しなおします。
	 * @access		public
	 * @param		String		$filename		対象ファイル名
	 * @return		bool		書込処理の結果
	 */
	function rotateLog($filename){
		// ファイルを移動
		echo $command = "mv " . $filename . " " . $filename . ".rotated." . date("YmdHis");
		$garvage = shell_exec ($command);

		// ファイルの存在を確認します。
		return $this->createLog($filename);
	}
	
	
	/**
	 * アクセスログファイルへの記録します。
	 * @access		public
	 * @return		bool		書込処理の結果
	 */
	 function writeAccessLog() {

		$AccessLogFilePath = _PROGRAM_ROOT . '_' . $GLOBALS['MySiteID'] . '/log/aclog/' .date('Ymd') .".log";

		$UserCD = ($GLOBALS['MEMBER']['UserCD'] == "") ? -1 : $GLOBALS['MEMBER']['UserCD'];
		$LogFormat = date('Y/m/d H:i:s') ."\t" .basename($_SERVER["SCRIPT_NAME"], ".php") ."\t" .sprintf("%08d", $UserCD);

		// ログ書き込み
		if (!$fp = fopen($AccessLogFilePath, "a")){
			$this->Err = "ファイルがオープンできませんでした";
			return FALSE;
		}

		if (!flock($fp, LOCK_EX)){
			$this->Err = "ファイルがロックできませんでした";
			return FALSE;
		}

		fwrite($fp, $LogFormat . "\n");

		if (!flock($fp, LOCK_UN)){
			$this->Err = "ファイルがロック解除できませんでした";
			return FALSE;
		}

		if (!fclose($fp)){
			$this->Err = "ファイルがクローズできませんでした";
			return FALSE;
		}

		return TRUE;

	 }
	 

}
?>
