<?php
/**
 * ASHtmlクラス
 *
 * テンプレートの出力制御を行います。
 * includeディレクトリの中にプロパティファイル"template.properties"が必要です。
 *
 * 1. 2004/09/10 - M.Samekawa
 *    getHiddenValuesを_GETにも対応させた。
 *
 * 2. 2004/09/22 - M.Samekawa
 *    FORMのenctypeがmultipart/form-dataな場合には文字コードの自動変換が行われないので、これを一括して行うメソッドを新設
 *
 * 3. 2004/09/28 - M.Samekawa  FROM 0.1 TO 1.1
 *    getHiddenValuesのGETパラメータ版"getHiddenQueries"を追加
 *
 * 4. 2004/10/28 - M.Samekawa  FROM 0.1 TO 1.1
 *    タグ関連部分を別クラス化
 *
 * 5. 2004/10/28 - M.Samekawa  FROM 0.1 TO 1.1
 *    ソースをリファクタリングすると共に、ベンチマーク機能を付与
 *
 * 5. 2004/10/29 - M.Samekawa  FROM 0.1 TO 1.1
 *    引き継ぎ用QUERY / POSTパラメータ制御について別クラス化
 *
 * 6. 2004/10/29 - M.Samekawa  FROM 1.1 TO 1.11
 *    デフォルトテンプレートに対応
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA
 * @create  2003/01/31
 * @version 1.11
 **/

define ("EXIST_CLASS_ASHTML","yes");

include_once _AS_CLS_DIR . 'ASHtmlTags.cls';
include_once _AS_CLS_DIR . 'ASHtmlValues.cls';
include_once _AS_CLS_DIR . 'ASTools.cls';
include_once _AS_CLS_DIR . 'ASLog.cls';
include_once _AS_CLS_DIR . 'ASBenchMark.cls';

########################################################
# 処理時間計測
########################################################
// 本来クラスの外でやるべきものではないが、各ソース冒頭で読み込まれるので、ここでベンチマークを開始する。
$myBenchMark = new ASBenchMark();

class ASHtml {
	/**
	 * テンプレート共通パス
	 */
	var $Path;
	/**
	 * テンプレートファイル(フル)
	 */
	var $FileName;
	/**
	 * キャリア
	 */
	var $Carrier;
	/**
	/**
	 * カタカナの半角変換を行うかどうかを決めるフラグ
	 */
	var $convertKatakanaFlg;
	/**
	 * エラーメッセージ
	 */
	var $Err;
	/**
	 * 読込テンプレート内容
	 */
	var $Msg;

	/**
	 * コンストラクタ
	 * プロパティファイルからログファイルのパスを読み込み、クラスプロパティにセットします。
	 * directory.propertiesが呼出元で読み込まれていることが必要です。
	 * @param		int			$carrier	キャリアコード
	 * @param		String		$filename	読込ファイル
	 * @param		bool		$outputFlg	TRUEならコンストラクタ内ですべて処理して出力
	 * @access		public
	 */
	function ASHtml($filename = NULL, $carrier = 1, $outputFlg = FALSE) {
		// プロパティセット
		$this->Carrier = ($carrier == NULL) ? 1 : $carrier;

		// 6. デフォルトテンプレートの指定に対応
		if ($filename == 'default') {
			$filename = str_replace(_DOCUMENT_ROOT, NULL, $GLOBALS['_SERVER']['SCRIPT_FILENAME']);
			$filename = str_replace('.php', '.tpl', $filename);
		}

		if ($filename != NULL) {
			// テンプレート読み込み
			$this->prepareTemplate($filename);

			// 出力処理
			if ($outputFlg) $this->doHanPrint();
		}

		return TRUE;
	}

	/**
	 * 一連のテンプレート読み込み処理
	 * 
	 * @param		String		$filename	読込ファイル
	 * @access		public
	 */
	function prepareTemplate($filename){
		// ディレクトリ名を確定
		$this->Path = _PATH;
		$this->getDirectoryByCarrier($this->Carrier);

		// 最終的なテンプレートファイル名を確定
		$this->FileName = $this->Path . $filename;

		// テンプレート読込
		if (!$this->getTemplate($this->FileName))
			return FALSE;

		return TRUE;
	}

	/**
	 * ディレクトリ名称確定
	 * キャリアによってディレクトリ名称を確定します。
	 * @param		int		$carrier	キャリアコード
	 * @access		public
	 */
	function getDirectoryByCarrier($carrier){
		global $HTTP_USER_AGENT;

		$KatakanaFlg = array (NULL, FALSE, FALSE, FALSE, FALSE);

		$this->Path = $this->Path . $this->getCarrierPath($carrier);
		$this->convertKatakanaFlg = $KatakanaFlg[$carrier];
	}

	/** Static呼び出しに対応 */
	function getCarrierPath($carrier) {
		$PathSuffix = array (NULL, '_pc/', '_docomo/', '_vodafone/', '_ezweb/');
		return $PathSuffix[$carrier];
	}

	/**
	 * テンプレートを読み込み、内容を返します。
	 * @access		public
	 * @param		String		$filename	読込ファイル
	 * @return		String		テンプレート内容
	 */
	function getTemplate($filename){
		$this->Msg = ASTools::getFile($filename);

		return TRUE;
	}

	/**
	 * テンプレート中の独自タグを全て置換する
	 * 
	 * @access		public
	 */
	function convertTags() {
		preg_match_all("/(__File::)(.*?)(__)/", $this->Msg, $regs);
		$Counter = count($regs[0]);
		for ($i = 0; $i < $Counter; $i++){
			$Tag = $regs[2][$i];

			$Filename = str_replace('File::', NULL, $Tag);
			$Filename = $this->Path . $Filename;
			if (file_exists($Filename))
				$Body = ASTools::getFile($Filename);
			else
				$Body = NULL;

			$this->Msg = str_replace("__" . $Tag . "__", $Body, $this->Msg);
		}

		$counter = 0;
		while(strstr($this->Msg, "__") && $counter < 5){
			$myHtmlTags = new ASHtmlTags($this->Msg);
			$this->Msg = $myHtmlTags->Body;

			$counter++;
		}

		unset ($myHtmlTags);

		$this->Msg = str_replace('%%IgnoredUnderscore%%', '__', $this->Msg);
	}

	/**
	 * 引き継ぎ用パラメータ変換
	 * 
	 * @access		public
	 * @return		String		HIDDEN値群
	 */
	function convertHtmlValues() {
		if (strstr($this->Msg, '__HiddenValues__')) {
			$values = ASHtmlValues::getThrowParameters('FORM');
			$this->Msg = str_replace('__HiddenValues__', $values, $this->Msg);
		}
	}

	/**
	 * 半角変換を行って出力します
	 * @access		public
	 */
	function doHanPrint() {
		$this->convertHtmlValues();
		$this->convertTags();

		if ($this->convertKatakanaFlg)
			$hmsg = i18n_ja_jp_hantozen($this->Msg,"k");
		else
			$hmsg = $this->Msg;

		// ベンチマーク終了
		global $myBenchMark;
		$GenerationTime = $myBenchMark->getTime();
		unset($myBenchMark);
		$hmsg = str_replace('__GenerationTime__', $GenerationTime, $hmsg);

		print ("$hmsg");
	}

	/**
	 * 前ページからのパラメータ引継用HIDDEN値生成
	 * Version 1.1 以前との互換用
	 *
	 * @access		public
	 * @return		String		HIDDEN値群
	 */
	function getHiddenValues() {
		$values = ASHtmlValues::getThrowParameters('FORM');
		return $values;
	}

	/**
	 * 前ページからのパラメータ引継用QUERY値生成
	 * Version 1.1 以前との互換用
	 *
	 * @access		public
	 * @return		String		HIDDEN値群
	 */
	function getHiddenQueries() {
		$values = ASHtmlValues::getThrowParameters('QUERY');
		return $values;
	}

	/**
	 * パラメータ引継用HIDDEN値生成に値追加(旧ソース互換用)
	 * Version 1.1 以前との互換用
	 *
	 * @access		public
	 * @param		String		$key		追加対象パラメータ名称
	 * @param		String		$value	消去対象パラメータ値
	 */
	function putHiddenValues($key, $value = "") {
		ASHtml::setValue($key);
	}

	/**
	 * 前ページからのパラメータについて特定のものを消し去る
	 * 
	 * @param		String		$tmpvalue	消去対象パラメータ名称
	 * @access		public
	 */
	function dropValue($key) {
		ASHtmlValues::dropParameter($key);
	}

	/**
	 * 前ページからのパラメータについて全て消し去る
	 * 
	 * @access		public
	 */
	function dropAllValues() {
		ASHtmlValues::dropAllParameters();
	}

	/**
	 * 引き継ぎ用パラメータ生成メソッド
	 * 
	 * @access		public
	 */
	function setValue($key, $value = 'default') {
		if ($value === 'default') $value = $GLOBALS[$key];

		ASHtmlValues::addParameter($key, $value);
	}

	/**
	 * 与えられた配列の文字コードを指定されたように変換する
	 * 
	 * @param		array		$obj			変換対象の配列
	 * @param		String		$toEncoding		変換先の文字コード
	 * @param		String		$fromEncoding	変換元の文字コード
	 * @return		bool		処理が成功すれば変換後の配列、失敗すればFALSE
	 * @access		public
	 */
	function convertEncodingArray($obj, $toEncoding, $fromEncoding) {
		if (!is_array($obj)){
			$this->Err = "Parameter \"Obj\" has to be array.";
			return FALSE;
		}
		if (strlen($toEncoding) == 0){
			$this->Err = "Parameter \"toEncoding\" is required.";
			return FALSE;
		}
		if (strlen($fromEncoding) == 0){
			$this->Err = "Parameter \"fromEncoding\" is required.";
			return FALSE;
		}

		reset($obj);
		while(list ($key,$value) = each($obj)) {
			if (is_Array($value)){
				$keys = array_keys($value);
				for ($i = 0; $i < count($keys); $i++)
					$obj[$key][$keys[$i]] = mb_convert_encoding($value[$keys[$i]], $toEncoding, $fromEncoding);
			}
			else
				if ($key != "")
					$obj[$key] = mb_convert_encoding($value, $toEncoding, $fromEncoding);
		}

		return $obj;
	}
}
?>
