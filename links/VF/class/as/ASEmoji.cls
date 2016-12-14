<?php
/**
 * 絵文字変換処理クラス
 *
 * 各キャリアの文字列を相互に変換するクラスです。
 *
 *
 * @package
 * @access public
 * @author M.Sasaki
 * @create 2003/02/18
 * @version 0.1
 **/
class ASEmoji {
	/**
	 * エラー
	 */
	var $Err;

	/**
	 * コンストラクタ
	 * 属性の初期値設定を行います。
	 * @access	public
	 */
	function ASEmoji() {
		$this->Err = "";
	}


	/**
	 * 絵文字変換関数
	 * 各キャリアの文字列を相互に変換 $outputTypeに"pc1"追加 03.03.07 ishige
	 * @param	String	$inputString
	 * @param	String	$inputType
	 * @param	String	$outputType
	 * @access	public
	 */
	function doEmojiConv($inputString, $inputType, $outputType) {
		global $imodeTable, $imodeNum, $jskyTable, $jskyNum, $ezwebTable, $ezwebNum, $extendImodeTable, $SITE_ROOT;

		// ログ準備
		$this->Err = "";
		$myLog = new ASLog();

		// 引数のチェック
		// 入力文字のチェック
		if (0 == strlen($inputString)) {
			$this->Err = "変換の対象となる文字列長が0です";
			$myLog->error("ClassName : ".get_class($this)." : ".$this->Err);
			return $inputString;
		}
		// "imode1", "imode2", "jsky1", "jsky2", "ezweb1", "ezweb2"
		// 上記以外エラー
		if ($inputType == $outputType) {
//			$this->Err = "変換前の絵文字タイプと変換後の絵文字タイプが同一です";
//			$myLog->error("ClassName : ".get_class($this)." : ".$this->Err);
			return $inputString;
		}
		// $inputTypeの解析
		if ("imode1" == $inputType or "imode2" == $inputType) {
			$inputTable = $imodeTable;
			$inputCarrier = "imode";
			$inputMaxNum = $imodeNum;
		}
		else if ("jsky1" == $inputType or "jsky2" == $inputType) {
			$inputTable = $jskyTable;
			$inputCarrier = "jsky";
			$inputMaxNum = $jskyNum;
		}
		else if ("ezweb1" == $inputType or "ezweb2" == $inputType) {
			$inputTable = $ezwebTable;
			$inputCarrier = "ezweb";
			$inputMaxNum = $ezwebNum;
		}
		else {
			// 引数エラー
			$this->Err = "変換前絵文字タイプが不正です";
			$myLog->error("ClassName : ".get_class($this)." : ".$this->Err);
			return $inputString;
		}

		// $outputTypeの解析
		if ("imode1" == $outputType or "imode2" == $outputType) {
			$outputTable = $imodeTable;
			$outputCarrier = "imode";
			$outputMaxNum = $imodeNum;
		}
		else if ("jsky1" == $outputType or "jsky2" == $outputType) {
			$outputTable = $jskyTable;
			$outputCarrier = "jsky";
			$outputMaxNum = $jskyNum;
		}
		else if ("ezweb1" == $outputType or "ezweb2" == $outputType) {
			$outputTable = $ezwebTable;
			$outputCarrier = "ezweb";
			$outputMaxNum = $ezwebNum;
		}
		//<<<<<03.03.07 ishige
		else if ("pc1" == $outputType) {
			$outputCarrier = "pc";
		}
		//>>>>>
		else {
			// 引数エラー
			$this->Err = "変換後絵文字タイプが不正です";
			$myLog->error("ClassName : ".get_class($this)." : ".$this->Err);
			return $inputString;
		}

		// 同一キャリア 1->2 or 2->1 の場合
		if ($inputCarrier == $outputCarrier) {
			for ($cnt = 1; $cnt < $inputMaxNum; $cnt++) {
				$inputArray = $inputTable[$cnt];
				$outputString = str_replace($inputArray[$inputType], $inputArray[$outputType], $inputString);
				$inputString = $outputString;
			}
		}
		//<<<<<03.03.07 ishige
		// PC出力の場合 imode1/jsky1 -> pc のみ考慮
		else if("pc" == $outputCarrier) {				// PC用(画像タグ）
			if ($inputCarrier == "imode") {		
				for ($cnt = 1; $cnt < $imodeNum; $cnt++) {		// Imode -> PCへの変換
					$inputArray = $inputTable[$cnt];
					if (strstr($inputString, $inputArray[$inputType])) {
						$outputArray = "<img src=\"" . $SITE_ROOT . "emoji/" . $cnt . ".gif\" border=\"0\">";
						$outputString = str_replace($inputArray[$inputType], $outputArray, $inputString);
						$inputString = $outputString;
					}
				}
				// Modified By M.Samekawa 2003/05/26
				// PC用に拡張絵文字の出力を追加
				for ($cnt = 0; $cnt < count($extendImodeTable); $cnt++) {		// Imode -> PCへの変換
					$inputArray = $extendImodeTable[$cnt];
					if (strstr($inputString, $inputArray['unicode'])) {
						$outputArray = "<img src=\"" . $SITE_ROOT . "emoji/ex" . $cnt . ".gif\" border=\"0\">";
						$outputString = str_replace($inputArray['unicode'], $outputArray, $inputString);
						$inputString = $outputString;
					}
				}
			}
			else if ($inputCarrier == "jsky") {					// JPhone -> PCへの変換
				for ($cnt = 1; $cnt < $jskyNum; $cnt++) {
					$inputArray = $inputTable[$cnt];
					if (strstr($inputString, $inputArray[$inputType])) {
						$outputIndex = $inputArray["imode"];
						if ($imodeNum - 1 < $outputIndex or 0 > $outputIndex) {
							// データエラー
							$this->Err = "変換テーブル中の変換先インデックスが範囲外です";
							$myLog->error("ClassName : ".get_class($this)." : ".$this->Err);
							continue;
						}

						$outputArray = "<img src=\"" . $SITE_ROOT . "emoji/" . $outputIndex . ".gif\" border=\"0\">";
						$outputString = str_replace($inputArray[$inputType], $outputArray, $inputString);
						$inputString = $outputString;
					}
				}
			}
		}
		//>>>>>
		// 同一キャリア以外
		else {
			for ($cnt = 1; $cnt < $inputMaxNum; $cnt++) {
				$inputArray = $inputTable[$cnt];
				if (strstr($inputString, $inputArray[$inputType])) {
					// インデックスチェック
					$outputIndex = $inputArray[$outputCarrier];
					if ($outputMaxNum - 1 < $outputIndex or 0 > $outputIndex) {
						// データエラー
						$this->Err = "変換テーブル中の変換先インデックスが範囲外です";
						$myLog->error("ClassName : ".get_class($this)." : ".$this->Err);
						return $inputString;
					}
					$outputArray = $outputTable[$outputIndex];
					$outputString = str_replace($inputArray[$inputType], $outputArray[$outputType], $inputString);
					$inputString = $outputString;
				}
			}
		}

		return $inputString;
	}

	/**
	 * <INPUT> <TEXTAREA>タグ内の絵文字表記 &#63999; &#99;を&amp;#xxxにリプレース
	 * 03.03.08 ishige
	 * @param	String	$instr
	 * @access	private
	 */
	function ampReplaceInForm($instr) {
		while(ereg("(<[Ii][Nn][Pp][Uu][Tt])([^>]+)&#(>)",$instr))
			$instr = ereg_replace("(<[Ii][Nn][Pp][Uu][Tt])([^>]+)&#(>)","\\1\\2&amp;#\\3",$instr);
		while(ereg("(<[Tt][Ee][Xx][Tt][Aa][Rr][Ee][Aa])([^(</)]+)&#(.+</)",$instr))
			$instr = ereg_replace("(<[Tt][Ee][Xx][Tt][Aa][Rr][Ee][Aa])([^(</)]+)&#(.+</)","\\1\\2&amp;#\\3",$instr);
		return $instr;
	}

}
?>
