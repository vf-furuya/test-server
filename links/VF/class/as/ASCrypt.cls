<?php
/**
 * Crypt クラス
 *
 * 暗号化/復号化を行う。
 *
 * 初期バージョン：英数字のみに対応
 *
 * @package
 * @access  public
 * @author  TakanoriYAMAZAKI (yamazaki@assiette.co.jp)
 * @create  2005/03/25
 * @version 1.0
 */
class ASCrypt {
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//           ユーザーコードの暗号化と復号化
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// 各桁を暗号化するためのリスト
//	var	$ORGSTR = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#\$%&'*-/=?^_`{|}~@.";
	var	$NUMTABLES = "16";

	var	$ORGSTR			 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	var	$ENCODESTR00 = "6t3sU8HDpNSkoILqdxGWKybrVJF2YP0cvnO9uai5TgefzChQjl14mwMABERXZ7";
	var	$ENCODESTR01 = "kd5CPuMNLHIXbW3GRh9SBynm02loQKjO7YvxJfsUag81FZecATri6pqwtz4DEV";
	var	$ENCODESTR02 = "IlWPFjd9usVTXr1DMgOKLBHhYaZR2pzen6CxNtvbcfqQ84ikAmSowyEJG5U037";
	var	$ENCODESTR03 = "xAsPjUIYDSomOvZrL749fcqBzNHRtgaWCh1KykXuEJ5bVGdMnT62eFilpw3Q08";
	var	$ENCODESTR04 = "NMnR2xKlhdryBgYFADtIiVkmHwEosqTSLQac5J8u694jzP3bpCO0fGveUWZX17";
	var	$ENCODESTR05 = "YUOWxvEDn0Z1k4QyiCAX6eSTKqmNbR3gdfBhwGHpFVzacrjlu9PJso7tILM258";
	var	$ENCODESTR06 = "MUBXbh1N56LAjKFEY4xHozrGWR9CDemyqVg8I3f20vOQSaZic7dklsnptuTwJP";
	var	$ENCODESTR07 = "D8RxY97MoPyptCXlZs5krJiGIV1QOebU6Ez4NfLch0adgWjBmHnqvw3SAu2FKT";
	var	$ENCODESTR08 = "mhtW5gzM8jc3E0DAsOFVLavie29oIlJb6TXqfPpHZdGyknRQS74ruwxBCKNUY1";
	var	$ENCODESTR09 = "DaqZoR5HYQyKFE3M1CWgi2N7nU8ru4pPAmGXjf9swLbkcId6t0ehJxlSvzBOTV";
	var	$ENCODESTR10 = "BHen65MpcwV2fzv7u4PbDOCmrAiLFNxShsWQYgt31Jq9RlXadKjIkoE0yZGTU8";
	var	$ENCODESTR11 = "XPEiamQon7GO2hVA5eCbRIrxgpuTKyvlHBYNMjUJ1ZwcSDFd8sf6kWqtLz0349";
	var	$ENCODESTR12 = "DKwGi71WIZVSjTOnv3mz6RJAfaU85ElNLgHcQbhYrt2deqFxskp4o9PuyBCMX0";
	var	$ENCODESTR13 = "IJ53LjkhNqOmZoK6EFQCaH0is1zB2PlAcuynMpbxfTGtRD8Yde74gXrv9SWwUV";
	var	$ENCODESTR14 = "V04Dfqp762iGQyMgKRULkYO95HuhrNs8baEeJlPT1wWdcoBXjztCmZnAxvSFI3";
	var	$ENCODESTR15 = "cKGFvnp3flNsoOE7Vb6XahdB9trkzCuwxRg8JT021eHLqijPYZmSyDAI54WMQU";

	var	$ENCODESTR00_ARRAY = array("6","t","3","s","U","8","H","D","p","N","S","k","o","I","L","q","d","x","G","W","K","y","b","r","V","J","F","2","Y","P","0","c","v","n","O","9","u","a","i","5","T","g","e","f","z","C","h","Q","j","l","1","4","m","w","M","A","B","E","R","X","Z","7");
	var	$ENCODESTR01_ARRAY = array("k","d","5","C","P","u","M","N","L","H","I","X","b","W","3","G","R","h","9","S","B","y","n","m","0","2","l","o","Q","K","j","O","7","Y","v","x","J","f","s","U","a","g","8","1","F","Z","e","c","A","T","r","i","6","p","q","w","t","z","4","D","E","V");
	var	$ENCODESTR02_ARRAY = array("I","l","W","P","F","j","d","9","u","s","V","T","X","r","1","D","M","g","O","K","L","B","H","h","Y","a","Z","R","2","p","z","e","n","6","C","x","N","t","v","b","c","f","q","Q","8","4","i","k","A","m","S","o","w","y","E","J","G","5","U","0","3","7");
	var	$ENCODESTR03_ARRAY = array("x","A","s","P","j","U","I","Y","D","S","o","m","O","v","Z","r","L","7","4","9","f","c","q","B","z","N","H","R","t","g","a","W","C","h","1","K","y","k","X","u","E","J","5","b","V","G","d","M","n","T","6","2","e","F","i","l","p","w","3","Q","0","8");
	var	$ENCODESTR04_ARRAY = array("N","M","n","R","2","x","K","l","h","d","r","y","B","g","Y","F","A","D","t","I","i","V","k","m","H","w","E","o","s","q","T","S","L","Q","a","c","5","J","8","u","6","9","4","j","z","P","3","b","p","C","O","0","f","G","v","e","U","W","Z","X","1","7");
	var	$ENCODESTR05_ARRAY = array("Y","U","O","W","x","v","E","D","n","0","Z","1","k","4","Q","y","i","C","A","X","6","e","S","T","K","q","m","N","b","R","3","g","d","f","B","h","w","G","H","p","F","V","z","a","c","r","j","l","u","9","P","J","s","o","7","t","I","L","M","2","5","8");
	var	$ENCODESTR06_ARRAY = array("M","U","B","X","b","h","1","N","5","6","L","A","j","K","F","E","Y","4","x","H","o","z","r","G","W","R","9","C","D","e","m","y","q","V","g","8","I","3","f","2","0","v","O","Q","S","a","Z","i","c","7","d","k","l","s","n","p","t","u","T","w","J","P");
	var	$ENCODESTR07_ARRAY = array("D","8","R","x","Y","9","7","M","o","P","y","p","t","C","X","l","Z","s","5","k","r","J","i","G","I","V","1","Q","O","e","b","U","6","E","z","4","N","f","L","c","h","0","a","d","g","W","j","B","m","H","n","q","v","w","3","S","A","u","2","F","K","T");
	var	$ENCODESTR08_ARRAY = array("m","h","t","W","5","g","z","M","8","j","c","3","E","0","D","A","s","O","F","V","L","a","v","i","e","2","9","o","I","l","J","b","6","T","X","q","f","P","p","H","Z","d","G","y","k","n","R","Q","S","7","4","r","u","w","x","B","C","K","N","U","Y","1");
	var	$ENCODESTR09_ARRAY = array("D","a","q","Z","o","R","5","H","Y","Q","y","K","F","E","3","M","1","C","W","g","i","2","N","7","n","U","8","r","u","4","p","P","A","m","G","X","j","f","9","s","w","L","b","k","c","I","d","6","t","0","e","h","J","x","l","S","v","z","B","O","T","V");
	var	$ENCODESTR10_ARRAY = array("B","H","e","n","6","5","M","p","c","w","V","2","f","z","v","7","u","4","P","b","D","O","C","m","r","A","i","L","F","N","x","S","h","s","W","Q","Y","g","t","3","1","J","q","9","R","l","X","a","d","K","j","I","k","o","E","0","y","Z","G","T","U","8");
	var	$ENCODESTR11_ARRAY = array("X","P","E","i","a","m","Q","o","n","7","G","O","2","h","V","A","5","e","C","b","R","I","r","x","g","p","u","T","K","y","v","l","H","B","Y","N","M","j","U","J","1","Z","w","c","S","D","F","d","8","s","f","6","k","W","q","t","L","z","0","3","4","9");
	var	$ENCODESTR12_ARRAY = array("D","K","w","G","i","7","1","W","I","Z","V","S","j","T","O","n","v","3","m","z","6","R","J","A","f","a","U","8","5","E","l","N","L","g","H","c","Q","b","h","Y","r","t","2","d","e","q","F","x","s","k","p","4","o","9","P","u","y","B","C","M","X","0");
	var	$ENCODESTR13_ARRAY = array("I","J","5","3","L","j","k","h","N","q","O","m","Z","o","K","6","E","F","Q","C","a","H","0","i","s","1","z","B","2","P","l","A","c","u","y","n","M","p","b","x","f","T","G","t","R","D","8","Y","d","e","7","4","g","X","r","v","9","S","W","w","U","V");
	var	$ENCODESTR14_ARRAY = array("V","0","4","D","f","q","p","7","6","2","i","G","Q","y","M","g","K","R","U","L","k","Y","O","9","5","H","u","h","r","N","s","8","b","a","E","e","J","l","P","T","1","w","W","d","c","o","B","X","j","z","t","C","m","Z","n","A","x","v","S","F","I","3");
	var	$ENCODESTR15_ARRAY = array("c","K","G","F","v","n","p","3","f","l","N","s","o","O","E","7","V","b","6","X","a","h","d","B","9","t","r","k","z","C","u","w","x","R","g","8","J","T","0","2","1","e","H","L","q","i","j","P","Y","Z","m","S","y","D","A","I","5","4","W","M","Q","U");


	var	$ORGSTRNUM = "0123456789";
	var	$ENCODESTRNUM00="5390278164";
	var	$ENCODESTRNUM01="9126845037";
	var	$ENCODESTRNUM02="2586943017";
	var	$ENCODESTRNUM03="7491562308";
	var	$ENCODESTRNUM04="3769802154";
	var	$ENCODESTRNUM05="1564983207";
	var	$ENCODESTRNUM06="8975164032";
	var	$ENCODESTRNUM07="5360128749";
	var	$ENCODESTRNUM08="5830296741";
	var	$ENCODESTRNUM09="7136852490";
	var	$ENCODESTRNUM10="7251860349";
	var	$ENCODESTRNUM11="5312784960";
	var	$ENCODESTRNUM12="6527431908";
	var	$ENCODESTRNUM13="0146397258";
	var	$ENCODESTRNUM14="0476295813";
	var	$ENCODESTRNUM15="6382095147";

	// 最初の文字のテーブル番号文字
	var	$TABLECODE = array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z");

	var	$ERROR = "";

	function code() {
	}

	/**
	 * 暗号化実行
	 * @param string 暗号化する文字列
	 * @return string 暗号化された文字列
	 */
	function encrypt($plain) {
		return $this->encryptString($plain);
	}
	function encryptString($plain) {
		$crypted = "";
		$mojiNums = array();
		// 対象外の文字列が含まれてないか確認しながら文字番号に変換
		for ($i=0; $i<strlen($plain); $i++) {
			$pnum = strpos($this->ORGSTR, substr($plain, $i, 1));
			if ($pnum===FALSE) {
				$this->ERROR = "暗号化対象外の文字が含まれています。";
				return NULL;
			} else {
				$mojiNums[$i] = $pnum;
			}
		}

		// 暗号化に使用する最初のテーブル番号を取得
		list($usec, $sec) = explode(' ', microtime());
		srand((float) $sec + ((float) $usec * 100000));
		$startTable = rand(0, $this->NUMTABLES-1);

		$crypted .= $this->TABLECODE[$startTable];

		// 順番に1文字ずつ暗号化
		$plainText = $this->str_split($plain);
		$tableNum = $startTable;
		for ($i=0; $i<count($plainText); $i++) {
			$tableCode = sprintf("%02d", $tableNum);
			$npos = strpos($this->ORGSTR, $plainText[$i]);
			$crypted .= $this->{"ENCODESTR".$tableCode}[$npos];
			// 順番に文字を取得するテーブルをずらす
			if (++$tableNum>=$this->NUMTABLES) {
				$tableNum = 0;
			}
		}

		return urlencode($crypted);
	}


	function decrypt($plain) {
		return $this->decryptString($plain);
	}
	function decryptString($crypted) {
		$plain = "";
		$crypted = urldecode($crypted);
		$cryptedText = $this->str_split($crypted);

		$startTable = $this->array_search($cryptedText[0], $this->TABLECODE);
		if ($startTable===FALSE) {
			//-- コードが不正
			$this->ERROR = "復号化できない文字が含まれています。[code=0]";
			return NULL;
		}

		// 順番に1文字ずつ復号化
		$tableNum = $startTable;
		for ($i=1; $i<count($cryptedText); $i++) {
			$tableCode = sprintf("%02d", $tableNum);
			$chr1 = $cryptedText[$i];
			$npos = strpos($this->{"ENCODESTR".$tableCode}, $chr1);
			if ($npos===FALSE) {
				//-- コードが不正
				$this->ERROR = "復号化できない文字が含まれています。[code=10.$i] ".$chr1."/".$tableCode;
				return NULL;
			}
			$plain .= $this->ORGSTR[$npos];

			// 順番に文字を取得するテーブルをずらす
			if (++$tableNum>=$this->NUMTABLES) {
				$tableNum = 0;
			}
		}

		return $plain;
	}


	/**
	 * 暗号化実行(数値=>数値)
	 * @param string 暗号化する文字列
	 * @return string 暗号化された文字列
	 */
	function encryptNum($plain) {
		$crypted = "";
		$mojiNums = array();
		// 対象外の文字列が含まれてないか確認しながら文字番号に変換
		for ($i=0; $i<strlen($plain); $i++) {
			$pnum = strpos($this->ORGSTRNUM, substr($plain, $i, 1));
			if ($pnum===FALSE) {
				$this->ERROR = "暗号化対象外の文字が含まれています。";
				return NULL;
			} else {
				$mojiNums[$i] = $pnum;
			}
		}

		// 暗号化に使用する最初のテーブル番号を取得
		list($usec, $sec) = explode(' ', microtime());
		srand((float) $sec + ((float) $usec * 100000));
		$startTable = rand(0, 9);

		$crypted .= $this->TABLECODE[$startTable];

		// 順番に1文字ずつ暗号化
		$plainText = $this->str_split($plain);
		$tableNum = $startTable;
		for ($i=0; $i<count($plainText); $i++) {
			$tableCode = sprintf("%02d", $tableNum);
			$npos = strpos($this->ORGSTRNUM, $plainText[$i]);
			$crypted .= $this->{"ENCODESTRNUM".$tableCode}[$npos];
			// 順番に文字を取得するテーブルをずらす
			if (++$tableNum>=$this->NUMTABLES) {
				$tableNum = 0;
			}
		}

		return urlencode($crypted);
	}


	function decryptNum($crypted) {
		$plain = "";
		$crypted = urldecode($crypted);
		$cryptedText = $this->str_split($crypted);

		$startTable = $this->array_search($cryptedText[0], $this->TABLECODE);
		if ($startTable===FALSE) {
			//-- コードが不正
			$this->ERROR = "復号化できない文字が含まれています。[code=0]";
			return NULL;
		}

		// 順番に1文字ずつ復号化
		$tableNum = $startTable;
		for ($i=1; $i<count($cryptedText); $i++) {
			$tableCode = sprintf("%02d", $tableNum);
			$chr1 = $cryptedText[$i];
			$npos = strpos($this->{"ENCODESTRNUM".$tableCode}, $chr1);
			if ($npos===FALSE) {
				//-- コードが不正
				$this->ERROR = "復号化できない文字が含まれています。[code=10] ".$chr1."/".$tableCode;
				return NULL;
			}
			$plain .= $this->ORGSTRNUM[$npos];

			// 順番に文字を取得するテーブルをずらす
			if (++$tableNum>=$this->NUMTABLES) {
				$tableNum = 0;
			}
		}

		return $plain;
	}




	//--------------------------------------------------------------------

	function array_search($needle, $heystack) {
		for ($i=0; $i<count($heystack); $i++) {
			if ($heystack[$i] == $needle) {
				return $i;
			}
		}
		return FALSE;
	}

	function str_split($str,$num = '1') {
		if($num < 1) return FALSE;
		$arr = array();
		for ($j = 0; $j < strlen($str); $j= $j+$num) {
			$arr[] = substr($str,$j,$num);
		}
		return $arr;
	}

	//--------------------------------------------------------------------

	function createRandomKey($len=32, $useKigou=FALSE) {
		// 候補文字配列を作る
		// 英小文字
		for ($i = ord("a"); $i < ord("z") + 1; $i++)
			$charArray[] = chr($i);
		// 英大文字
		for ($i = ord("A"); $i < ord("Z") + 1; $i++)
			$charArray[] = chr($i);
		// 数字
		for ($i = ord("0"); $i < ord("9") + 1; $i++)
			$charArray[] = chr($i);
		if ($useKigou) {
			$charArray[] = '@';
			$charArray[] = '*';
			$charArray[] = '+';
			$charArray[] = '-';
			$charArray[] = '#';
			$charArray[] = '(';
			$charArray[] = ')';
		}

		// $len 文字を小文字で生成
		for ($i = 0; $i < $len; $i++)
			$strW[$i] = $charArray[mt_rand(0, count($charArray) - 1)];

		// シャッフル
		shuffle($strW);

		// 出力
		$strKey = "";
		for ($i = 0; $i < $len; $i++) $strKey .= $strW[$i];

		return $strKey;
	}

}
?>