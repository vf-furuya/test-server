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

/**
 * staticな呼び出しに特化したログクラス
 * ログってそもそもそういうもんだと思う。
 * 
 */
class Logger {
	function &getInstance() {
		static $singleton;

		if ($GLOBALS['DISABLE_LOGGING']) return NULL;

		if ($singleton == NULL) {
			$singleton = new ASLog();
		}
		return $singleton;
	}
/**
	function __call($func, $args) {
		$log = self::getInstance();
		$log->{$func}($args[0]);
	}
	function __callStatic($func, $args) {
		$log = self::getInstance();
		$log->{$func}($args[0]);
	}
*/
	function getMessage($message) {
		if (!is_string($message)) {
			ob_start();
			var_dump($message);
			$message = ob_get_contents();
			ob_end_clean();
		}
		return $message;
	}

	function log() {
		$argc = func_num_args();
		$argv = func_get_args();
		if ($argc<2) {
			self::error(sprintf("%s (%d) : 引数の数が少ない", __FILE__, __LINE__));
			return false;
		}
		$facility = strtolower(trim($argv[0]));
		switch($facility) {
			case 'debug':
			case 'error':
			case 'db':
			case 'sql':
			case 'module':
			case 'test':
			case 'mail':
				break;
			default:
				self::error(sprintf("%s (%d) : ログタイプの指定が不正", __FILE__, __LINE__, $facility));
				return FALSE;
		}


		$message = $argv[1];
		$argarray = array(self::getMessage($message));
		if ($argc>2) {
			for ($i=2; $i<$argc; $i++) {
				$argarray[] = self::getMessage($argv[$i]);
			}
			$message = call_user_func_array('sprintf', $argarray);
		}
		self::$facility($message);
	}

	// 5.2～非対応の場合
	function db($message) {
		$log = self::getInstance();
		if (!$log) return;
		$log->db(self::getMessage($message));
	}
	function debug($message) {
		$log = self::getInstance();
		if (!$log) return;
		$log->debug(self::getMessage($message));
	}
	function error($message) {
		$log = self::getInstance();
		if (!$log) return;
		$log->error(self::getMessage($message));
	}
	function module($message) {
		$log = self::getInstance();
		if (!$log) return;
		$log->module(self::getMessage($message));
	}
	function sql($message) {
		$log = self::getInstance();
		if (!$log) return;
		$log->sql(self::getMessage($message));
	}
	function test($message) {
		$log = self::getInstance();
		if (!$log) return;
		$log->test(self::getMessage($message));
	}
	function mail($message) {
		$log = self::getInstance();
		if (!$log) return;
		$log->mail(self::getMessage($message));
	}
	function request($message) {
		$log = self::getInstance();
		if (!$log) return;
		$log->request(self::getMessage($message));
	}

}
?>
