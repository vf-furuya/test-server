<?php
/**
 * ASMobileクラス
 *
 * モバイル用の関数群です。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2003/05/09
 * @version 0.1
 **/

define ("EXIST_CLASS_ASMobile","yes");

define ("_CARRIER_ETC", "1");
define ("_CARRIER_DOCOMO", "2");
define ("_CARRIER_SOFTBANK", "3");
define ("_CARRIER_EZWEB", "4");
$CARRIER_NAME = array(NULL, 'PC', 'DoCoMo', 'SoftBank', 'EZWEB');

class ASMobile {

	/**
	 * コンストラクタ
	 * 
	 * @access		public
	 */
	function ASMobile(){
	}

	/**
	 * 端末名称抽出
	 * UserAgentから機種名の部分を抽出します。
	 * @param		String		$UA		UserAgent
	 * @return		String		機種名
	 * @access		public
	 */
	function getHandSetName($UA){
		if(preg_match("/^DoCoMo\/1\.0/",$UA)){
			list($x,$x,$UA) = explode("/",$UA);
		}
		else if(preg_match("/^DoCoMo\/2\.0\s([^\(]+)\(/",$UA,$m)){
			$UA = $m[1];
		}
		else if(preg_match("/^J-PHONE/",$UA)){
			list($x,$x,$UA,$x) = explode("/",$UA);
		}
		else if(preg_match("/^KDDI-/",$UA)){
			list($x,$UA) = explode("-",$UA);
			$UA = substr($UA, 0, strpos($UA, " "));
		}
		else if(preg_match("/^UP.Browser\//",$UA)){
			list($x,$UA) = explode("-",$UA);
			$UA = substr($UA, 0, strpos($UA, " "));
		}
		else
			$UA = "";

		$UA = preg_replace("/<>\"&/","",$UA);

		return $UA;
	}

	/**
	 * キャリア名称抽出
	 * UserAgentからキャリア名を生成します。
	 * @param		String		$UA		UserAgent
	 * @return		int			キャリアコード
	 * @access		public
	 */
	function getCarrierCode($UA){
		// 変数 
		$myCarrier = 0;

		// 判別用
		$JudgeString[_CARRIER_DOCOMO] = array('DoCoMo');
		$JudgeString[_CARRIER_SOFTBANK] = array('J-PHONE', 'Vodafone', 'SoftBank', 'MOT-V980', 'MOT-C980');
		$JudgeString[_CARRIER_EZWEB] = array('UP.Browser');

		// UserAgentからキャリアを判別
		for ($i = 2; $i < 5; $i++) {
			$UpTo = count($JudgeString[$i]);

			for ($j = 0; $j < $UpTo; $j++) {
				if (stristr($UA, $JudgeString[$i][$j])) {
					$myCarrier = $i;
					break;
				}
			}

			if ($myCarrier > 0)
				break;
		}

		// どのキャリアとも判別されなかった場合
		if ($myCarrier == 0)
			$myCarrier = _CARRIER_ETC;

		return $myCarrier;
	}

	/**
	 * キャリア名称抽出
	 * UserAgentからキャリア名を生成します。
	 * @param		String		$EMail		メールアドレス
	 * @return		int			キャリアコード
	 * @access		public
	 */
	function getCarrierCodeByEMail($EMail){
		// 変数 
		$MY_CARRIER = 0;

		// 判別用
		$JudgeString[_CARRIER_DOCOMO] = array('docomo.ne.jp');
		$JudgeString[_CARRIER_SOFTBANK] = array('d.vodafone.ne.jp', 'h.vodafone.ne.jp', 't.vodafone.ne.jp', 'c.vodafone.ne.jp', 'k.vodafone.ne.jp', 'r.vodafone.ne.jp', 'n.vodafone.ne.jp', 's.vodafone.ne.jp', 'q.vodafone.ne.jp', 'jp-d.ne.jp', 'jp-h.ne.jp', 'jp-t.ne.jp', 'jp-c.ne.jp', 'jp-k.ne.jp', 'jp-r.ne.jp', 'jp-n.ne.jp', 'jp-s.ne.jp', 'jp-q.ne.jp', 'softbank.ne.jp');
		$JudgeString[_CARRIER_EZWEB] = array('ezweb.ne.jp', 'ido.ne.jp', 'sky.tu-ka.ne.jp', 'sky.tkc.ne.jp', 'sky.tkk.ne.jp');

		// ドメイン切り出し
		$regs = explode('@', $EMail);
		$Domain = $regs[1];

		// UserAgentからキャリアを判別
		for ($i = 2; $i < 5; $i++) {
			$UpTo = count($JudgeString[$i]);

			for ($j = 0; $j < $UpTo; $j++) {
				if (substr($Domain, -1 * strlen($JudgeString[$i][$j])) == $JudgeString[$i][$j]) {
					$MY_CARRIER = $i;
					break;
				}
			}

			if ($MY_CARRIER > 0)
				break;
		}

		// どのキャリアとも判別されなかった場合
		if ($MY_CARRIER == 0)
			$MY_CARRIER = _CARRIER_ETC;

		return $MY_CARRIER;
	}

	/**
	 * キャリア判定と各キャリア用処理
	 * 
	 * @return		int			キャリアコード
	 * @access		public
	 */
	function getCarrierCodeByUserAgent(){
		$MY_CARRIER = ASMobile::getCarrierCode($GLOBALS['_SERVER']['HTTP_USER_AGENT']);

		switch ($MY_CARRIER){
			case _CARRIER_ETC:
				mb_http_output("SJIS");
				//header("Content-Type: text/html; charset=euc-jp");
				$METHOD = "POST";
				break;
			case _CARRIER_DOCOMO:
				mb_http_output("SJIS");
				//header("Content-Type: text/html; charset=euc-jp");
				$METHOD = "POST";
				break;
			case _CARRIER_SOFTBANK:
				mb_http_output("SJIS");
				//header("Content-Type: text/html; charset=euc-jp");
				$METHOD = "POST";
				break;
			case _CARRIER_EZWEB:
				mb_http_output("SJIS");
				//header("Content-Type: text/html; charset=euc-jp");
				$METHOD = "POST";
				break;
		}

		ob_start('mb_output_handler');

		return $MY_CARRIER;
	}

	/**
	 * 非対応端末判定処理
	 * 非対応端末をPROPERTIESファイルなどで array $UNSUPPORTED_TERMINAL[CARRIER_CODE][INDEX] に格納しておくことが前提。
	 * 
	 * @access		public
	 * @return		Bool			非対応端末ならTRUE
	 */
	function isNGTerminal(){
		$HTTP_USER_AGENT = $GLOBALS['_SERVER']['HTTP_USER_AGENT'];
		$MY_CARRIER = $GLOBALS['MY_CARRIER'];
		$UNSUPPORTED_TERMINAL = $GLOBALS['UNSUPPORTED_TERMINAL'];

		for ($i = 0; $i < count($UNSUPPORTED_TERMINAL[$MY_CARRIER]); $i++) {
			if (stristr($HTTP_USER_AGENT, $UNSUPPORTED_TERMINAL[$MY_CARRIER][$i]))
				return TRUE;
		}

		return FALSE;
	}

	function getUID(){
		$UserAgent = $GLOBALS['_SERVER']["HTTP_USER_AGENT"];

		if ($GLOBALS['MY_CARRIER'] == 2) {
			if (strstr($UserAgent, "(") !== FALSE) {
				$Step1 = strstr($UserAgent, "ser");
				$Step2 = explode(";", $Step1);
				$UID =  trim(str_replace("ser", "", $Step2[0]));
			}
			else {
				$UserAgentParts = explode("/", $UserAgent);
				for ($i = 0; $i < count($UserAgentParts); $i++) {
					if (strstr($UserAgentParts[$i], "ser") !== FALSE)
						$UID = trim(str_replace("ser", "", $UserAgentParts[$i]));
				}
			}

			if (strstr($UserAgent, "(") !== FALSE) {
				$Step1 = strstr($UserAgent, "icc");
				$Step2 = explode(";", $Step1);
				$ICC =  trim(str_replace("icc", "", $Step2[0]));

				$ICC = str_replace(')', NULL, $ICC);
			}
		}
		else if ($GLOBALS['MY_CARRIER'] == 3) {
			$UserAgentParts = explode("/", $UserAgent);
			for ($i = 0; $i < count($UserAgentParts); $i++) {
				if (strstr($UserAgentParts[$i], "SN") !== FALSE) {
					$UID = trim($UserAgentParts[$i]);
					$regs = explode(' ', $UID);
					$UID = $regs[0];
				}
			}
		}
		else if ($GLOBALS['MY_CARRIER'] == 4)
			$UID = $GLOBALS['_SERVER']["HTTP_X_UP_SUBNO"];

		return $UID;
	}
}
?>
