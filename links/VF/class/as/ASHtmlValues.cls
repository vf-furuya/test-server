<?php
/**
 * ASHtmlValuesクラス
 *
 * ページ間で引き継ぐべき値の制御を司るクラスです。
 *
 * 1. 2004/10/28 - M.Samekawa
 *    ASHtmlクラス内のメソッドからCLASSへと独立しました。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA
 * @create  2004/10/29
 * @version 1.1
 **/

define ("EXIST_CLASS_ASHTMLVALUES","yes");

class ASHtmlValues {
	/**
	 * コンストラクタ
	 * 何もしない
	 *
	 * @access		public
	 */
	function ASHtmlValues (){
		$this->initialize();
	}

	/**
	 * 初期化
	 *
	 * @access		public
	 */
	function initialize (){
		$GLOBALS['PARAMETERS'] = array();
	}
	
	/**
	 * 現在の_GETと_POSTをデフォルトパラメータとしてセットする
	 *
	 * @access		public
	 */
	function setReceivedParameter (){
		if ($_SERVER['REQUEST_METHOD'] == 'GET')
			$GLOBALS['PARAMETERS'] = array_merge($_POST, $_GET);
		else if ($_SERVER['REQUEST_METHOD'] == 'POST')
			$GLOBALS['PARAMETERS'] = array_merge($_GET, $_POST);
	}

	/**
	 * パラメータを引継ぎ可能な形で返す
	 * 
	 * @access		public
	 * @param		String		$method		FORMならinputタグを、QUERYならURLパラメータを生成
	 * @return		String		HIDDEN値群
	 */
	function getThrowParameters($method = 'FORM') {
		if (is_array($GLOBALS['PARAMETERS'])) {
			reset ($GLOBALS['PARAMETERS']);

			while(list ($key, $value) = each($GLOBALS['PARAMETERS'])) {
				if (is_array($value)){
					$keys = array_keys($value);
					for ($i = 0; $i < count($keys); $i++){
						if ($key != "") {
							if ($method == 'FORM')
								$ValuesToThrow .= "<input type=\"hidden\" name=\"" . $key . "[" . $keys[$i] . "]\" value=\"" . htmlspecialchars($value[$keys[$i]]) . "\">\n";
							else
								$ValuesToThrow .= "&" . $key . "[" . $keys[$i] . "]=" . urlencode($value[$keys[$i]]) . "";
						}
					}
				}
				else{
					if ($key != ""){
						if ($method == 'FORM')
							$ValuesToThrow .= "<input type=\"hidden\" name=\"" . $key . "\" value=\"" . htmlspecialchars($value) . "\">\n";
						else
							$ValuesToThrow .= "&" . $key . "=" . urlencode($value) . "";
					}
				}
			}
		}

		return $ValuesToThrow;
	}

	/**
	 * 引き継ぐ値から指定されたものを除去する
	 * 
	 * @access		public
	 * @param		String		$name		除去すべきパラメータ名
	 */
	function dropParameter($name){
		unset ($GLOBALS['PARAMETERS'][$name]);
	}

	/**
	 * 引き継ぐ値をすべて除去する
	 * 
	 * @access		public
	 */
	function dropAllParameters(){
		unset ($GLOBALS['PARAMETERS']);
	}

	/**
	 * 引き継ぐ値に任意の追加を行う
	 * 
	 * @access		public
	 * @param		String		$name		追加すべきパラメータ名
	 * @param		String		$value		追加すべき値
	 */
	function addParameter($name, $value){
		$GLOBALS['PARAMETERS'][$name] = $value;
	}
}
?>
