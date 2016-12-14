<?php
/**
 * ASBenchMarkクラス
 *
 * 所要時間計測クラス
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA
 * @create  2003/10/24
 * @version 0.1
 **/

define ("EXIST_CLASS_ASBENCHMARK","yes");

class ASBenchMark {
	/**
	 * エラーメッセージ
	 */
	var $Err;

	/**
	 * 開始時刻
	 */
	var $StartTime;

	/**
	 * コンストラクタ
	 * 開始時刻を記録します。
	 *
	 * @access		public
	 */
	function ASBenchMark (){
		$this->StartTime = $this->getMicroTime();
	}

	/**
	 * コンストラクタ
	 * 開始時刻を記録します。
	 *
	 * @access		private
	 * @return		float		所要時間
	 */
	function getTime (){
		return $this->getMicroTime() - $this->StartTime;
	}

	/**
	 * マイクロ秒を得ます
	 *
	 * @access		public
	 * @return		float		UNIXTIMEのマイクロ秒換算
	 */
	function getMicroTime(){ 
		list($usec, $sec) = explode(" ",microtime());
		return ((float)$sec + (float)$usec);
	}
}
?>
