<?php
/**
 * ASLightHtmlクラス
 *
 * テンプレートの出力制御を行います。
 * 本クラスは、既存ASHtmlクラスの大幅機能削減・軽量化版であり、タグの自動変換機能などは基本的に備えていない。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA
 * @create  2005/05/11
 * @version 1.00
 **/

class ASLightHtml {
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
	function ASLightHtml($filename = NULL, $carrier = 1, $outputFlg = FALSE, $PreviewFlg = NULL) {
		// プロパティセット
		$this->Carrier = ($carrier == NULL) ? 1 : $carrier;

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

		$PathSuffix = array (NULL, '_pc/', '_docomo/', '_softbank/', '_ez/');
		$KatakanaFlg = array (NULL, FALSE, FALSE, FALSE, FALSE);

		$this->Path = $this->Path . $PathSuffix[$carrier];
		$this->convertKatakanaFlg = $KatakanaFlg[$carrier];
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
	 * 半角変換を行って出力します
	 * @access		public
	 */
	function doHanPrint() {
		
		$this->convertHtml();
		
		if (is_NonSSLTerminal())
			$this->Msg = str_replace("ssl:__MAIN_URL__", _MAIN_URL, $this->Msg);
		else
			$this->Msg = str_replace("ssl:__MAIN_URL__", _SSL_MAIN_URL, $this->Msg);

		$this->Msg = str_replace("__MAIN_URL__", _MAIN_URL, $this->Msg);
		$this->Msg = str_replace("__PassQuery__", "?e=" . $GLOBALS['RegistKey'], $this->Msg);

		print ($this->Msg);
	}

	/**
	 * 変換メソッド
	 * 一連の変換を整合の取れる順番で行います
	 *
	 * @param		String		$Body		HTML原稿
	 * @access		public
	 */
	function convertHtml (){
		// 一連の置換を行う
		$this->processCommonTags();
		$this->processLoop();
		$this->processIf();
		$this->processNormalTags();
	}

	/**
	 * 単一LOOP処理メソッド
	 * 通常のLOOPを置換します
	 *
	 * @access		public
	 */
	function processLoop (){
		$LoopTags = $GLOBALS['LoopTags'];
		$LoopTagsInner = $GLOBALS['LoopTagsInner'];

		// 最初にLoopタグを処理
		for ($i = 0; $i < count($LoopTags); $i++){
			$tag = $LoopTags[$i];

			// 該当独自タグ
			$writtenTag = "__" . $tag  . "__";

			if (substr($tag, -4) == 'List') {
				$ListClassFlg = TRUE;
				$myListClass = $GLOBALS[$tag];
			}

			if ($ListClassFlg)
				$LoopCount = $myListClass->RecCnt;
			else
				$LoopCount = $GLOBALS[$tag];

			// リスト部分(Loopの中身)のエレメント確定
			$tmp = strstr($this->Msg, $writtenTag);
			$tmp = substr($tmp, strlen($writtenTag));
			$point = strpos($tmp, $writtenTag);
			$listString = substr($tmp, 0, $point);

			// リスト部分から全ての独自タグを抜き出す
			$listElements = $LoopTagsInner[$i];

			// リストブロック初期化(この変数に最終的な処理後のLOOP部分が入る)
			$listBlock = NULL;

			// ループの開始値(デフォルト0)
			$beginValueStr = $tag . "Begin";
			$beginValue = ($GLOBALS[$beginValueStr] == NULL) ? 0 : $GLOBALS[$beginValueStr];

			for ($j = $beginValue; $j < $LoopCount; $j++){
				$tmpString = $listString;

				for ($k = 0; $k < count($listElements); $k++){
					// 要素のひとつを確定
					$listTag = $listElements[$k];

					// 該当独自タグ
					$eachWrittenTag = "__" . "" . $listTag . "" . "__";

					// 置換する
					if (!strstr($listTag, '.'))
						$tmpString = str_replace($eachWrittenTag, $GLOBALS[$listTag][$j], $tmpString);
					else {
						$classTags = explode('.', $name);
						$className = $classTags[0];
						$classProperty = $classTags[1];
						$value = $GLOBALS[$className]->{$classProperty}[$j];
					}
				}

				$listBlock .= $tmpString;
			}

			$this->Msg = str_replace($writtenTag . $listString . $writtenTag, $listBlock, $this->Msg);

			if (strstr($this->Msg, $LoopTags[$i]))
				$i--;
		}

		return TRUE;
	}
	
	/**
	 * 条件判断タグ処理メソッド
	 *
	 * @access		public
	 */
	function processIf (){
		$IfTags = $GLOBALS['IfTags'];

		// 次にIfタグを処理
		for ($i = 0; $i < count($IfTags); $i++){
			$tag = $IfTags[$i];

			// 該当独自タグ
			$writtenTag = "__" . $tag  . "__";

			// リスト部分(Loopの中身)をマッチングして取り出し
			$tmp = strstr($this->Msg, $writtenTag);
			$tmp = substr($tmp, strlen($writtenTag));
			$point = strpos($tmp, $writtenTag);
			$tmpMsg = substr($tmp, 0, $point);

			// リスト部分(Loopの中身)のエレメント確定
			$listString = $tmpMsg;

			// 判定フラグを格納
			$judge = $GLOBALS[$tag];

			If ($judge)
				$this->Msg = str_replace($writtenTag, NULL, $this->Msg);
			else
				$this->Msg = str_replace($writtenTag . $listString . $writtenTag, NULL, $this->Msg);
		}
	}
	
	/**
	 * 通常タグの処理メソッド
	 *
	 * @access		public
	 */
	function processNormalTags (){
		$NormalTags = $GLOBALS['NormalTags'];

		// 次に通常のタグを処理
		for ($i = 0; $i < count($NormalTags); $i++){
			$tag = $NormalTags[$i];
			if ($tag == 'HiddenValues' || $tag == 'PassQuery')
				$this->Msg = str_replace("" . "__" . "" . $tag . "" . "__" . "", $GLOBALS[$tag], $this->Msg);
			else {
				if (!is_array($GLOBALS[$tag])) {
					if (substr($tag, 0, 1) == 'w')
						$this->Msg = str_replace("" . "__" . "" . $tag . "" . "__" . "", @htmlspecialchars($GLOBALS[$tag], ENT_QUOTES), $this->Msg);
					else
						$this->Msg = str_replace("" . "__" . "" . $tag . "" . "__" . "", $GLOBALS[$tag], $this->Msg);
				}
				else {
					$this->Msg = str_replace("" . "__" . "" . $tag . "" . "__" . "", $GLOBALS[$tag], $this->Msg);
				}
			}
		}
	}
	
	/**
	 * 共通タグを仕込むメソッド
	 *
	 * @access		public
	 */
	function processCommonTags (){
		$NormalTags = $GLOBALS['NormalTags'];

		$NormalTags[] = 'MyPageURL';

		$GLOBALS['NormalTags'] = $NormalTags;
	}

	/**
	 * 前ページからのパラメータ引継用HIDDEN値生成
	 * @access		public
	 * @return		String		HIDDEN値群
	 */
	function getHiddenValues($Method = 'POST') {
		$PassValues = $GLOBALS['PassValues'];

		if (is_array($PassValues)) {
			while(list ($key,$value) = each($PassValues)) {
				if (is_Array($value)){
					$keys = array_keys($value);
					for ($i = 0; $i < count($keys); $i++){
						if ($key != "") {
							if ($Method == 'POST')
								$PassValuesString .= "<input type=\"hidden\" name=\"" . $key . "[" . $keys[$i] . "]\" value=\"" .htmlspecialchars($value[$keys[$i]], ENT_QUOTES) . "\">\n";
							else
								$PassValuesQuery[] = $key . "[" . $keys[$i] . "]=" .htmlspecialchars($value[$keys[$i]], ENT_QUOTES);
						}
					}
				}
				else{
					if ($key != "") {
						if ($Method == 'POST')
							$PassValuesString .= "<input type=\"hidden\" name=\"" . $key . "\" value=\"" .htmlspecialchars($value, ENT_QUOTES) . "\">\n";
						else
							$PassValuesQuery[] = $key . "=" .htmlspecialchars($value, ENT_QUOTES);
					}
				}
			}
		}

		if ($Method == 'GET') {
			for ($i = 0; $i < count($PassValuesQuery); $i++) {
				if ($i == 0)
					$PassQuery .= "?" . $PassValuesQuery[$i];
				else
					$PassQuery .= "&" . $PassValuesQuery[$i];
			}
			return $PassQuery;
		}
		else
			return $PassValuesString;
	}

	/**
	 * 共通パラメータをセットします。
	 *
	 * @access		public
	 * @return		String		HIDDEN値群
	 */
	function setCommonParameter() {
		if ($GLOBALS['RegistKey'] != NULL)
			$GLOBALS['PassValues']['e'] = $GLOBALS['RegistKey'];
	}
}
?>
