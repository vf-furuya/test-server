<?php
/**
 * ASErrorクラス
 *
 * 各種エラーハンドリングを担います。
 *
 * 2004/10/22 CREATED AS 1.1
 * これまでincludeだったのをクラス化
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA
 * @create  2004/10/22
 * @version 1.1
 **/

define("EXIST_CLASS_ASERROR","yes");

// 動作モード定義
define('_MODE_NORMAL', 1);
define('_MODE_ADMIN', 2);
define('_MODE_MODULE', 3);

// エラー区分と対応テンプレート(ユーザ向け)
define("_ILLEGAL_ACCESS", 1);
define("_SORRY_TERMINAL", 2);
define("_UNIVERSAL_ERROR", 3);
define("_PC_ONLY", 4);
define("_MOBILE_ONLY", 5);
define("_SORRY_MAINTENANCE", 6);
define("_SORRY_PROJECTLIMIT", 7);
define("_SORRY_ALREADY", 8);

$TEMPLATE[_ILLEGAL_ACCESS] = "_sorry_illegal.tpl";
$TEMPLATE[_SORRY_TERMINAL] = "redirect:corres.php";
$TEMPLATE[_UNIVERSAL_ERROR] = "_systemerror.tpl";
$TEMPLATE[_PC_ONLY] = "_sorry_pc_only.tpl";
$TEMPLATE[_MOBILE_ONLY] = "_sorry_mobile_only.tpl";
$TEMPLATE[_SORRY_MAINTENANCE] = "_sorry_maintenance.tpl";
$TEMPLATE[_SORRY_PROJECTLIMIT] = "_sorry_projectlimit.tpl";
$TEMPLATE[_SORRY_ALREADY] = "_sorry_already.tpl";

// エラー時の挙動定義
define('_SORRY_USER', 1);
define('_SORRY_ADMIN', 2);
define('_SORRY_MAIL', 3);
$BEHAVIER[_MODE_NORMAL] = array(NULL, TRUE, FALSE, FALSE);
$BEHAVIER[_MODE_ADMIN] = array(NULL, FALSE, TRUE, FALSE);
$BEHAVIER[_MODE_MODULE] = array(NULL, FALSE, FALSE, TRUE);

/**
 * 前バージョンのモード定義と互換性を持たせるため、モード判定関数を用意
 **/
if ($isAdminMode)
	$ERROR_HANDLING_MODE = _MODE_ADMIN;
else if ($isModuleMode)
	$ERROR_HANDLING_MODE = _MODE_MODULE;
else
	$ERROR_HANDLING_MODE = _MODE_NORMAL;

// エラーハンドリング後終了するかどうか
$TERMINATE = TRUE;

include_once _AS_CLS_DIR . "ASLightHtml.cls";
include_once _AS_CLS_DIR . "ASLog.cls";

class ASError {

	/**
	 * コンストラクタ
	 * エラー処理のトリガとなります。
	 *
	 * @param		Integer		$errNo		エラー番号
	 * @param		String		$errStr		エラー文字列
	 * @param		String		$errFile	エラー発生ファイル
	 * @param		String		$errLine	エラー発生行番号
	 * @access		public
	 */
	function ASError ($errNo, $errStr, $errFile, $errLine) {
		global $ERROR_HANDLING_MODE, $TERMINATE, $BEHAVIER;

		// 出力メッセージの生成
		$ErrorMessage = ASError::processError($errNo, $errStr, $errFile, $errLine);

		if ($ErrorMessage == NULL)
			return TRUE;

		// エラー内容のログへの記録
		ASError::recordError($ErrorMessage);

		// 複数の告知処理を行いたい場合に、各告知処理の最後でexitされてしまうのを回避するため、$TERMINATEを一度FALSEにして退避させる
		$HideTerminate = $TERMINATE;
		$TERMINATE = FALSE;

		// エラー告知処理
		if ($BEHAVIER[$ERROR_HANDLING_MODE][_SORRY_USER])
			ASError::showSorryPage(_UNIVERSAL_ERROR, $ErrorMessage);
		if ($BEHAVIER[$ERROR_HANDLING_MODE][_SORRY_ADMIN]) {
			$ErrorString[0] = "システムエラーが発生しました。以下のメッセージをコピーしてシステム管理者にメール等でご連絡ください。";
			$ErrorString[1] = "[" . $ErrorMessage . "]";
			ASError::showAdminSorryPage($ErrorString);
		}
		if ($BEHAVIER[$ERROR_HANDLING_MODE][_SORRY_MAIL])
			ASError::notifyByMail($ErrorMessage, $errFile);

		$TERMINATE = $HideTerminate;

		// 終了処理
		if ($TERMINATE)
			exit;
	}

	/**
	 * エラーレベルによってエラー文字列を生成して返します。
	 *
	 * @param		Integer		$errNo		エラー番号
	 * @param		String		$errStr		エラー文字列
	 * @param		String		$errFile	エラー発生ファイル
	 * @param		String		$errLine	エラー発生行番号
	 * @return		String		生成エラーメッセージ
	 * @access		public
	 */
	function processError($errNo, $errStr, $errFile, $errLine) {
		switch ($errNo) {
			case E_USER_ERROR:
				$ErrorMessage = "ERROR: [" . $errNo . "] " . $errStr . " at line " . $errLine . " in " . $errFile;
				break;
			case E_USER_WARNING:
				$ErrorMessage = "ERROR: [" . $errNo . "] " . $errStr . " at line " . $errLine . " in " . $errFile;
				break;
			case E_USER_NOTICE:
				$ErrorMessage = "ERROR: [" . $errNo . "] " . $errStr . " at line " . $errLine . " in " . $errFile;
				break;
			case E_PARSE:
				$ErrorMessage = "ERROR: [" . $errNo . "] " . $errStr . " at line " . $errLine . " in " . $errFile;
				break;
			case E_NOTICE:
				//$ErrorMessage = "ERROR: [" . $errNo . "] " . $errStr . " at line " . $errLine . " in " . $errFile;
				break;
			case E_WARNING:
				$ErrorMessage = "ERROR: [" . $errNo . "] " . $errStr . " at line " . $errLine . " in " . $errFile;
				break;
			case E_ERROR:
				$ErrorMessage = "ERROR: [" . $errNo . "] " . $errStr . " at line " . $errLine . " in " . $errFile;
				break;
			case E_STRICT:
				//$ErrorMessage = "ERROR: [" . $errNo . "] " . $errStr . " at line " . $errLine . " in " . $errFile;
				break;
			default:
				$ErrorMessage = "ERROR: [" . $errNo . "] " . $errStr . " at line " . $errLine . " in " . $errFile;
				break;
		}

		for ($i = 0;$i < count($GLOBALS['ExecuteError']); $i++)
			$ErrorMessage .= $GLOBALS['ExecuteError'][$i] . "\n";

		if ($ErrorMessage != NULL) {
			$errinfo = "\n>>>>> DEBUG TRACE OUTPUT IS FOLLOWING. <<<<<\n";
			$da=debug_backtrace();
			$dstep=count($da);
			for($i=3;$i<$dstep;$i++){
				$errinfo .= sprintf("[%d]%s%s%s():%s:%d \n%s \n",$i-3,$da[$i]['class'],$da[$i]['type'],$da[$i]['function'],basename($da[$i-1]['file']),$da[$i-1]['line'],var_export($da[$i]['args'],true));
			}
			$errinfo .= sprintf("[%d]%s:%d \n",$dstep-3,basename($da[$dstep-1]['file']),$da[$dstep-1]['line']);
			if(count($GLOBALS['argv'])>0) {
				$errinfo .= "== argv == \n".var_export($GLOBALS['argv'],true). "== argv == \n";
			}else if(count($_REQUEST)>0){
				$errinfo .= "== _REQUEST == \n".var_export($_REQUEST,true)."== _REQUEST == \n";
			}
			$ErrorMessage .= $errinfo;
		}

		return $ErrorMessage;
	}

	/**
	 * ログへの記録を行います。
	 *
	 * @param		String		$ErrorMessage	生成エラーメッセージ
	 * @access		public
	 */
	function recordError($ErrorMessage) {
		$myLog = new ASLog();
		for ($i = 0;$i < count($GLOBALS['ExecuteError']); $i++)
			$Errors .= $GLOBALS['ExecuteError'][$i] . "\n";
		$Errors .= $ErrorMessage;
		$myLog->error($Errors);
		unset($myLog);
	}

	/**
	 * エラーの告知処理を行います(ユーザ向け)
	 *
	 * @param		String		$errType	エラー画面の種類
	 * @access		public
	 */
	function showSorryPage($errType, $ErrorMessage) {
		global $TEMPLATE, $MY_CARRIER, $TERMINATE;

		if (strstr($TEMPLATE[$errType], 'redirect:')) {
			$URL = _MAIN_URL . str_replace('redirect:', NULL, $TEMPLATE[$errType]);
			header('Location: ' . $URL);
			exit;
		}
		else {
			/*
			// エラー出力
			for ($i = 0;$i < count($GLOBALS['ExecuteError']); $i++) {
				$Errors .= $GLOBALS['ExecuteError'][$i] . "\n";
			}
			*/
			$GLOBALS['ErrorMsg'] = "不正なアクセスがありました。";
			$CNT_FILE = '_error.tpl';
			$errHtml = new ASHtml($CNT_FILE, $MY_CARRIER, TRUE);
			unset($errHtml);
		}

		// 終了処理
		if ($TERMINATE)
			exit;
	}

	/**
	 * エラーの告知処理を行います(管理者向け)
	 *
	 * @param		String		$ErrorMessage	生成エラーメッセージ
	 * @access		public
	 */
	function showAdminSorryPage($ErrorMessage, $CloseFlg = FALSE) {
		global $TEMPLATE, $MY_CARRIER, $ErrorLoop, $ErrorString, $TERMINATE;

		// エラー出力
		$ErrorString = array();
		if (is_array($ErrorMessage))
			$ErrorString = $ErrorMessage;
		else
			$ErrorString[] = $ErrorMessage;
		$ErrorLoop = count($ErrorString);

		$GLOBALS['IfClose'] = $CloseFlg;
		$GLOBALS['IfNotClose'] = !$CloseFlg;

		ASHtml::setValue('work', NULL);
		$errHtml = new ASHtml('admin/_systemerror.tpl', $MY_CARRIER, TRUE);
		unset($errHtml);

		// 終了処理
		if ($TERMINATE)
			exit;
	}

	/**
	 * エラーのメール送信を行います。
	 *
	 * @param		String		$ErrorMessage	生成エラーメッセージ
	 * @param		String		$errFile		エラー発生ファイル
	 * @access		public
	 */
	function notifyByMail($ErrorMessage, $errFile) {
		global $TERMINATE;

		// エラー出力
		$MailText = $errFile . "での処理中に以下のエラーが発生しました。処理は中断しています。\n\n";
		$MailText .= "" . $ErrorMessage . "";

		mb_send_mail(_MODULE_ERROR_MAILTO, "Modules Error Notice - " . _MAIN_URL, $MailText);

		// 終了処理
		if ($TERMINATE)
			exit;
	}
}

/**
 * エラーが発生した際に呼び出される関数
 **/

function error_handling ($errNo, $errStr, $errFile, $errLine) {
	$myError = new ASError($errNo, $errStr, $errFile, $errLine);
}

/**
 * 前バージョンのフレームワークが関数として呼び出しているため、互換性保持用のステップ関数を用意
 **/

function showSorryPage($errType){
	ASError::showSorryPage ($errType);
}

function showAdminSorryPage($errorMessage, $CloseFlg = FALSE){
	ASError::showAdminSorryPage($errorMessage, $CloseFlg);
}

function myErrorHandler($errNo, $errStr, $errFile, $errLine) {
	ASError::ASError($errNo, $errStr, $errFile, $errLine);
}

function moduleErrorHandler($errNo, $errStr, $errFile, $errLine) {
	ASError::ASError($errNo, $errStr, $errFile, $errLine);
}

function adminErrorHandler($errNo, $errStr, $errFile, $errLine) {
	ASError::ASError($errNo, $errStr, $errFile, $errLine);
}

// エラー通知レベル制御
//error_reporting (E_ERROR | E_WARNING | E_PARSE | E_NOTICE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_USER_ERROR | E_USER_WARNING | E_USER_NOTICE);
error_reporting(E_ALL ^ E_NOTICE);
set_error_handler("error_handling");
?>
