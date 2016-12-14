<?php
/**
 * ASStringクラス
 *
 * ちょっとした文字列関連ツールたち
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2004/10/27
 * @version 1.1
 **/

define ("EXIST_CLASS_ASSTRING","yes");

class ASString {
	/**
	 * エラーメッセージ
	 */
	var $Err;
	
	/**
	 * コンストラクタ
	 * 処理は特にナシ
	 * @access		public
	 */
	function ASString(){
	}
	
	/**
	 * 文字列全体から、ある文字列で囲まれた部分を取り出します。
	 * 
	 * @param		String		$str		処理対象文字列
	 * @param		String		$separator	囲んでいる文字列
	 * @return		String		抜き出した文字列
	 * @access		public
	 */
	function partOfString($str, $separator){
		$tmp = strstr($str, $separator);
		$tmp = substr($tmp, strlen($separator));
		$point = strpos($tmp, $separator);
		$tmp = substr($tmp, 0, $point);

		return $tmp;
	}
}
?>
