<?php
/**
 * ASHtmlTagsクラス
 *
 * 独自タグ入りテンプレートの変換を行います。
 *
 * 1. 2004/10/28 - M.Samekawa
 *    ASHtmlクラス内のメソッドからCLASSへと独立しました。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA
 * @create  2004/10/28
 * @version 1.1
 **/

define ("EXIST_CLASS_ASHTMLTAGS","yes");

include_once _AS_CLS_DIR . 'ASDate.cls';
include_once _AS_CLS_DIR . 'ASString.cls';
include_once _AS_CLS_DIR . 'ASLanguage.cls';

class ASHtmlTags {
	/**
	 * 独自タグ入りHTML原稿
	 */
	var $Body;
	/**
	 * 独自タグの識別子
	 */
	var $Separator;
	/**
	 * 独自タグの識別子
	 */
	var $IgnoreTags;

	/**
	 * コンストラクタ
	 * HTMLが引数として渡っていればそのままCONVERTを実行
	 *
	 * @param		String		$Body		HTML原稿
	 * @access		public
	 */
	function ASHtmlTags ($Body = NULL, $Separator = '__'){
		$this->Body = $Body;
		$this->Separator = $Separator;

		$this->IgnoreTags = array('GenerationTime');

		if ($Body != NULL)
			$this->convertHtml();
	}

	/**
	 * 変換メソッド
	 * 一連の変換を整合の取れる順番で行います
	 *
	 * @param		String		$Body		HTML原稿
	 * @access		public
	 */
	function convertHtml (){
		// 無視すべき独自タグを退避
		$this->saveIgnoreTags();

		// 一連の置換を行う
		$this->processList();
		$this->processDoubleLoop();
		$this->processLoop();
		$this->processIf();
		$this->processNormalTags();

		// 退避したタグを戻す
		$this->restoreIgnoreTags();
	}
	
	/**
	 * 標準リスト処理メソッド
	 * Listクラスのインスタンスに対応するメソッド。
	 *
	 * @access		public
	 */
	function processList (){
		// 独自タグ部分をマッチングして取り出し
		preg_match_all("/(" . $this->Separator . ")(.*?List)(" . $this->Separator . ")/", $this->Body, $regs);

		// 標準リストを見つければ処理
		for ($i = 0; $i < count($regs[0]); $i++){
			$tag = $regs[2][$i];

			if (strstr($tag, 'List')){
				$className = $tag;
				$LoopCount = $this->getValue($className . '.RecCnt');

				// 該当独自タグ
				$writtenTag = $this->Separator . $className  . $this->Separator;

				// リスト部分(Loopの中身)をマッチングして取り出し
				$tmpMsg = ASString::partOfString($this->Body, $writtenTag);
				$listString = $tmpMsg;

				// リスト部分から全ての独自タグを抜き出す
				preg_match_all("/(" . $this->Separator . ")(.*?)(" . $this->Separator . ")/", $listString, $listElements);

				// リストブロック初期化(この変数に最終的な処理後のLOOP部分が入る)
				$listBlock = NULL;

				for ($j = 0; $j < $LoopCount; $j++){
					$tmpString = $listString;
					for ($k = 0; $k < count($listElements[0]); $k++){
						// 要素のひとつを確定
						$listTag = $listElements[2][$k];

						if (strstr($listTag, "If"))
							$tmpString = $this->convertIfTagForLoop($listTag, $tmpString, $j);
					}

					for ($k = 0; $k < count($listElements[0]); $k++){
						// 要素のひとつを確定
						$listTag = $listElements[2][$k];

						// 該当独自タグ
						$eachWrittenTag = $this->Separator . "" . $listTag . "" . $this->Separator;

						// 置換する
						$tmpString = str_replace($eachWrittenTag, $this->getValue($listTag, $j), $tmpString);
					}

					$listBlock .= $tmpString;
				}
			}

			$this->Body = str_replace($writtenTag . $listString . $writtenTag, $listBlock, $this->Body);
		}

		return TRUE;
	}

	/**
	 * 二重LOOP処理メソッド
	 * 二重LOOPを単一ループの群れに置き換える
	 *
	 * @access		public
	 */
	function processDoubleLoop (){
/*		// 独自タグ部分をマッチングして取り出し
		preg_match_all("/(" . $this->Separator . ")(.*?DoubleLoop)(" . $this->Separator . ")/", $this->Body, $regs);

		// DoubleLoopタグを処理
		for ($i = 0; $i < count($regs[0]); $i++){
			$finalBlock = "";

			$tag = $regs[2][$i];
			if (strstr($tag, "DoubleLoop")){
				global $$tag;

				// リスト部分(Loopの中身)をマッチングして取り出し
				$tmpMsg = ASString::partOfString($this->Body, "" . $this->Separator . "" . $tag . "" . $this->Separator . "");

				// リスト部分(Loopの中身)のエレメント確定
				$listString = $tmpMsg;

				// リスト部分から全ての独自タグを抜き出す
				preg_match_all("/(" . $this->Separator . ")(.*?)(" . $this->Separator . ")/", $listString, $listElements);

				// リストブロック作成
				$listBlock = "";

				// ループの開始値(デフォルト0)
				$beginValueStr = $tag . "Begin";
				$beginValue = ($this->getValue($beginValueStr) == NULL) ? 0 : $this->getValue($beginValueStr);

				for ($j = $beginValue; $j < $$tag; $j++){
					$loopBlock[$j] = $listString;

					for ($k = 0; $k < count($listElements[0]); $k++){
						// 要素のひとつを確定
						$listTag = $listElements[2][$k];
						$loopBlock[$j] = str_replace("" . $this->Separator . "" . $listTag . "" . $this->Separator . "", "" . $this->Separator . "" . $listTag . $j . "" . $this->Separator . "", $loopBlock[$j]);

						// 変数を用意
						global $$listTag;
						global ${$listTag . $j};
						${$listTag . $j} = ${$listTag}[$j];
					}

					$finalBlock .= $loopBlock[$j];
				}

				$this->Body = str_replace($listString, $finalBlock, $this->Body);
				$this->Body = str_replace("" . $this->Separator . "" . $tag . "" . $this->Separator . "", "", $this->Body);
			}
		}*/

		return TRUE;
	}
	
	/**
	 * 単一LOOP処理メソッド
	 * 通常のLOOPを置換します
	 *
	 * @access		public
	 */
	function processLoop (){

		// 独自タグ部分をマッチングして取り出し
		preg_match_all("/(" . $this->Separator . ")(.*?Loop.*?)(" . $this->Separator . ")/", $this->Body, $regs);

		// 最初にLoopタグを処理
		for ($i = 0; $i < count($regs[0]); $i++){
			$tag = $regs[2][$i];

			if (strstr($tag, "Loop")){
				// 該当独自タグ
				$writtenTag = $this->Separator . $tag  . $this->Separator;

				$LoopCount = $this->getValue($tag);

				// リスト部分(Loopの中身)をマッチングして取り出し
				$tmpMsg = ASString::partOfString($this->Body, $writtenTag);

				// リスト部分(Loopの中身)のエレメント確定
				$listString = $tmpMsg;

				// リスト部分から全ての独自タグを抜き出す
				preg_match_all("/(" . $this->Separator . ")(.*?)(" . $this->Separator . ")/", $listString, $listElements);

				// リストブロック初期化(この変数に最終的な処理後のLOOP部分が入る)
				$listBlock = NULL;

				// ループの開始値(デフォルト0)
				$beginValueStr = $tag . "Begin";
				$beginValue = ($this->getValue($beginValueStr) == NULL) ? 0 : $this->getValue($beginValueStr);

				for ($j = $beginValue; $j < $LoopCount; $j++){
					$tmpString = $listString;

					for ($k = 0; $k < count($listElements[0]); $k++){
						// 要素のひとつを確定
						$listTag = $listElements[2][$k];
	
						if (strstr($listTag, "If"))
							$tmpString = $this->convertIfTagForLoop($listTag, $tmpString, $j);
					}

					for ($k = 0; $k < count($listElements[0]); $k++){
						// 要素のひとつを確定
						$listTag = $listElements[2][$k];

						// 該当独自タグ
						$eachWrittenTag = $this->Separator . "" . $listTag . "" . $this->Separator;

						// 置換する
						$tmpString = str_replace($eachWrittenTag, $this->getValue($listTag, $j), $tmpString);
					}

					$listBlock .= $tmpString;
				}
			}

			$this->Body = str_replace($writtenTag . $listString . $writtenTag, $listBlock, $this->Body);
		}

		return TRUE;
	}
	
	/**
	 * 条件判断タグ処理メソッド
	 *
	 * @access		public
	 */
	function processIf (){
		// 独自タグ部分をマッチングして取り出し
		$regs = array();
		preg_match_all("/(" . $this->Separator . ")(If.[^_]*?|.[^_]*?\.If.[^_]*?)(" . $this->Separator . ")/", $this->Body, $regs);

		// 次にIfタグを処理
		for ($i = 0; $i < count($regs[0]); $i++){
			$tag = $regs[2][$i];

			// 該当独自タグ
			$writtenTag = $this->Separator . $tag  . $this->Separator;

			if (strstr($tag, "If")){
				$myLog = new ASLog();
				//$myLog->debug("TAG : " . $tag);

				// 否定タグに自動対応(1)
				if (!is_bool($this->getValue($tag)) && (strstr($tag, 'IfNo') || strstr($tag, 'IfNot') || strstr($tag, 'IfNon'))) {
					$judgeTagName = str_replace('IfNot', 'If', $tag);
					$judgeTagName = str_replace('IfNon', 'If', $judgeTagName);
					$judgeTagName = str_replace('IfNo', 'If', $judgeTagName);

					if (isset($GLOBALS[$tag])) {
						$judgeTagName = $tag;
						$NoAutoNegative = TRUE;
					} else {
						$NoAutoNegative = FALSE;
					}
				}
				else{
					$judgeTagName = $tag;
					$NoAutoNegative = TRUE;
				}
				//$myLog->debug("JUDGE TAG : " . $judgeTagName);

				// リスト部分(Loopの中身)をマッチングして取り出し
				$tmpMsg = ASString::partOfString($this->Body, $writtenTag);

				// リスト部分(Loopの中身)のエレメント確定
				$listString = $tmpMsg;

				// 判定フラグを格納
				$judge = $this->getValue($judgeTagName);

				// 否定タグに自動対応(2)
				if (!$NoAutoNegative && (strstr($tag, 'IfNo') || strstr($tag, 'IfNot') || strstr($tag, 'IfNot')) && substr($tag, 0, 7) != 'IfNotes'){
					//$myLog->debug("OPPOSITE");
					$judge = !$judge;
				}

				If ($judge)
					$this->Body = str_replace($writtenTag, NULL, $this->Body);
				else
					$this->Body = str_replace($writtenTag . $listString . $writtenTag, NULL, $this->Body);
			}
		}
	}
	
	/**
	 * 通常タグの処理メソッド
	 *
	 * @access		public
	 */
	function processNormalTags (){
		// 独自タグ部分をマッチングして取り出し
		preg_match_all("/(" . $this->Separator . ")(.*?)(" . $this->Separator . ")/", $this->Body, $regs);

		// 次に通常のタグを処理
		for ($i = 0; $i < count($regs[0]); $i++){
			$tag = $regs[2][$i];

			if (strstr($tag, '..')) {
				$arrayregs = explode('..', $tag);
				$tagname = $arrayregs[0];
				$index = $arrayregs[1];
				$this->Body = str_replace("" . $this->Separator . "" . $tag . "" . $this->Separator . "", $this->getValue($tagname, $index), $this->Body);
			}
			else
				$this->Body = str_replace("" . $this->Separator . "" . $tag . "" . $this->Separator . "", $this->getValue($tag), $this->Body);
		}
	}

	/**
	 * 無視すべきタグを退避する
	 *
	 * @access		public
	 */
	function saveIgnoreTags (){
		for ($i = 0; $i < count($this->IgnoreTags); $i++){
			$tag = $this->Separator . $this->IgnoreTags[$i] . $this->Separator;
			$saved = '@saved@' . $this->IgnoreTags[$i] . '@saved@';

			$this->Body = str_replace($tag, $saved, $this->Body);
		}
	}

	/**
	 * 退避させたタグたちを元に戻す
	 *
	 * @access		public
	 */
	function restoreIgnoreTags (){
		for ($i = 0; $i < count($this->IgnoreTags); $i++){
			$tag = $this->Separator . $this->IgnoreTags[$i] . $this->Separator;
			$saved = '@saved@' . $this->IgnoreTags[$i] . '@saved@';

			$this->Body = str_replace($saved, $tag, $this->Body);
		}
	}

	/**
	 * 指定された変数名の値を返す
	 *
	 * @access		private
	 * @param		string		$name		変数名
	 * @param		integer		$index		配列の場合にはその配列のINDEX
	 * @return		string		その名前の変数の値
	 */
	function getValue ($name, $index = NULL){
		if (strstr($name, 's::')) {
			$SanitizingFlg = TRUE;
			$name = str_replace('s::', NULL, $name);
		}
		if (strstr($name, 'r::')) {
			$ReturnFlg = TRUE;
			$name = str_replace('r::', NULL, $name);
		}
		if (strstr($name, 'u::')) {
			$IgnoreUnderscore = TRUE;
			$name = str_replace('u::', NULL, $name);
		}

		/** ↓ 山崎拡張 ↓ */
		// triming
		if (strstr($name, 't::')) {
			$TrimingFlg = TRUE;
			$name = str_replace('t::', NULL, $name);
		}
		// USD形式に金額フォーマット (1,234.56)
		if (strstr($name, 'm::')) {
			$MoneyFormatFlg = TRUE;
			$name = str_replace('m::', NULL, $name);
		}
		// 数値フォーマット
		if (strstr($name, 'n::')) {
			$NumberFormatFlg = TRUE;
			$name = str_replace('n::', NULL, $name);
		}
		// 日付整形
		if (strstr($name, 'date::')) {
			$DateFormatFlg = TRUE;
			$name = str_replace('date::', NULL, $name);
		}
		// インクルード
		if (strstr($name, 'i::')) {
			$IncludeFlg = TRUE;
			$name = str_replace('i::', NULL, $name);
		}
		// 0はNULL表示にするnumber_format...
		if (strstr($name, 'p::')) {
			$PriceFlg = TRUE;
			$name = str_replace('p::', NULL, $name);
		}


		// 引数指定がある場合は分離する
		if (($tpos=strpos($name, ":")) !== FALSE) {
			$variables = substr($name, $tpos+1, strlen($name));
			$name = str_replace(":".$variables, NULL, $name);
		}

		/** ↑ 山崎拡張 ↑ */


		// 定数定義されていればそれを返す
		if (defined($name)) 
			$value = constant($name);
		// クラスのプロパティならそれを返す
		else if (strstr($name, '.')) {
			$classTags = explode('.', $name);
			$className = $classTags[0];
			$classProperty = $classTags[1];
			if ($index === NULL) {
				if (is_object($GLOBALS[$className])) {
					$value = $GLOBALS[$className]->{$classProperty};
				} else if (is_array($GLOBALS[$className])) {
					$value = $GLOBALS[$className][$classProperty];
				} else {
					$value = NULL;
				}
			} else {
				if (is_object($GLOBALS[$className])) {
					$value = $GLOBALS[$className]->{$classProperty}[$index];
				} else if (is_array($GLOBALS[$className])) {
					$value = $GLOBALS[$className][$classProperty][$index];
				} else {
					$value = NULL;
				}
			}
		}
		// 通常の変数であればそれを返す
		else {
			if ($index === NULL)
				$value = $GLOBALS[$name];
			else
				$value = $GLOBALS[$name][$index];
		}


		/** ↓ 山崎拡張 ↓ */
		if ($IncludeFlg) {
			if (!$value) $value = $name;
			if ($this->Parent!=NULL) {
				$includePath = $this->Parent->Path;
			} else {
				global $MY_CARRIER;
				$includePath = _PATH . ASHtml::getCarrierPath($MY_CARRIER);
			}
			$includeName = $includePath."/".$value;

			$value = ASTools::getFile($includeName);
		}
		/** ↑ 山崎拡張 ↑ */

		/** escape */
		if ($SanitizingFlg) {
			$value = htmlspecialchars($value, ENT_QUOTES);
			$value = str_replace('[BR]', '<br />', $value);
		}
		/** nl2br */
		if ($ReturnFlg) {
			$value = nl2br($value);
		}
		/** "_" */
		if ($IgnoreUnderscore) {
			$value = str_replace('__', '%%IgnoredUnderscore%%', $value);
		}

		/* 日付関連（とりあえず・・・） */
		if ($DateFormatFlg) {
			if ($value) {
				// YYYY/MM/DD
				if ($variables == 1) {
					$value = date('Y/m/d', strtotime($value));
				}
				// YYYY-MM-DD
				 else if ($variables == 2) {
					$value = date('Y-m-d', strtotime($value));
				}
				// MM月DD日
				 else if ($variables == 3) {
					$value = date('m月d日', strtotime($value));
				}
				//YYYY年 MM月DD日
				 else if ($variables == 4) {
					$value = date('Y年m月d日', strtotime($value));
				}
				//YYYY年 MM月DD日　HH:ii
				 else if ($variables == 5) {
					$value = date('Y年m月d日 H:i', strtotime($value));
				}
				//YYYY年 MM月DD日　HH:ii
				 else if ($variables == 6) {
					$value = date('Y年m月d日 H時i分', strtotime($value));
				}
				//MM月DD日（曜日）
				 else if ($variables == 7) {
					$value = date('n月j日', strtotime($value)) . '(' . ASDate::getDayOfWeek($value, 2) . ')';
				}
				//YYYY年 MM月DD日　HH時
				 else if ($variables == 8) {
					$value = date('Y年m月d日 H時', strtotime($value));
				}
				// デフォルト
				 else {
					$value = date('Y/m/d', strtotime($value));
				}
			}
		}

		/** ↓ 山崎拡張 ↓ */
		if ($MoneyFormatFlg && is_numeric($value)) {
			/** 各国のロケールに合わせたければ、settingなどで setlocaleすること */
			$currentLocale = setlocale(LC_MONETARY, 0);
			if (empty($currentLocale)) {
				setlocale(LC_MONETARY, 'ja_JP');
			}
			if (empty($variables)) {
				$value = money_format("%.0n", $value);
			} else {
				$value = money_format($variables, $value);
			}
		}
		if ($NumberFormatFlg) {
			if (empty($variables)) {
				$value = number_format($value);
			} else {
				$value = number_format($value, $variables);
			}
		}
		if ($PriceFlg) {
			if ($value) {
				$value = number_format($value);
			} else {
				$value = "";
			}
		}
		if ($TrimingFlg) {
			if (strpos($variables, ":")!==FALSE) {
				list($length, $separate) = explode(":", $variables);
			}
			else {
				$length = $variables;
				$separate = "middle";
			}

			if (empty($length) || !preg_match("/[0-9]+/", $length)) {
				$length = 255;
			}
			$value = self::trimText($value, $length, $separate);
		}
		/** ↑ 山崎拡張 ↑ */

		return $value;
	}

	/**
	 * テキストを任意の長さでトリミング
	 *
	 */
	function trimText($text, $maxlength, $separateType="middle") {
		$length = mb_strlen($text, mb_internal_encoding());
		if ($length>$maxlength) {
			switch (strtolower($separateType)) {
				case "right":
					return mb_substr($text, 0, $maxlength) . "…";
				case "left":
					return "…" . mb_substr($text, 0, $maxlength);
				case "middle":
				default:
					$partlength = $maxlength%2==0 ? floor($maxlength/2)-1 : ($maxlength-1)/2;
					return mb_substr($text, 0, $partlength) . "…" . mb_substr($text, -$partlength);
			}
		}
		return $text;
	}

	/**
	 * Ifタグの置換を行う
	 *
	 * @access		private
	 * @param		string		$name		変数名
	 * @param		string		$block		処理すべき原稿
	 * @param		integer		$index		配列の場合にはその配列のINDEX
	 * @return		string		処理後の原稿
	 */
	function convertIfTagForLoop ($name, $block, $index){
		// 否定タグに自動対応(1)
		if (strstr($name, 'IfNo') || strstr($name, 'IfNot') || strstr($name, 'IfNon')) 
			$Negative = TRUE;
		else
			$Positive = TRUE;

		// 該当するifタグ
		$ifTag = $this->Separator . $name . $this->Separator;

		// 否定タグ対応の場合
		if ($Negative){
			$name = str_replace('IfNon', 'If', $name);
			$name = str_replace('IfNot', 'If', $name);
			$name = str_replace('IfNo', 'If', $name);
		}

		// 対応するIf変数を取得
		if (strstr($name, '.')) {
			$classTags = explode('.', $name);
			$className = $classTags[0];
			$classProperty = $classTags[1];
			$ifTagObject = $GLOBALS[$className]->{$classProperty};
		}
		else 
			$ifTagObject = $GLOBALS[$name];

		// リスト部分(Loopの中身)をマッチングして取り出し
		$ifBlock = ASString::partOfString($block, $ifTag);

		If (is_array($ifTagObject) && $ifTagObject[$index] && $Positive)
			$block = str_replace($ifTag, NULL, $block);
		else If (is_array($ifTagObject) && !$ifTagObject[$index] && $Negative)
			$block = str_replace($ifTag, NULL, $block);
		else If (!is_array($ifTagObject) && $ifTagObject && $Positive)
			$block = str_replace($ifTag, NULL, $block);
		else If (!is_array($ifTagObject) && !$ifTagObject && $Negative)
			$block = str_replace($ifTag, NULL, $block);
		else
			$block = str_replace($ifTag . $ifBlock . $ifTag, NULL, $block);

		return $block;
	}

	/**
	 * チェックすべき、しないべきを判定する
	 *
	 * @access		private
	 * @param		string		$Value			判定対象値
	 * @param		string		$Type			チェック判定OK時の文言タイプ(1:ラジオボタン・チェックボックス 2:プルダウンリスト)
	 * @return		string		チェック文字列
	 */
	function isChosen ($Value, $Type = 1){
		if ($Type == 1)
			$HIT = ' CHECKED';
		else if ($Type == 2)
			$HIT = ' SELECTED';

		$Judge = ($Value == 't' || ($Value != 'f' && $Value == TRUE)) ? $HIT : NULL;

		return $Judge;
	}

	/**
	 * Loopタグ用の処理を行う
	 *
	 * @access		private
	 * @param		string		$LoopName		LOOP名称(XxxxLoopのXxxx)
	 * @param		string		$MasterName	LOOPで利用するマスタ値名称
	 * @param		string		$ValueName		LOOPのチェック判定に利用する変数名
	 * @param		string		$LoopBegin		LOOPの開始値
	 * @param		string		$Type			チェック判定OK時の文言タイプ(1:ラジオボタン・チェックボックス 2:プルダウンリスト)
	 * @return		string		処理後の原稿
	 */
	function prepareLoop ($LoopName, $MasterName = NULL, $ValueName = NULL, $LoopBegin = 0, $Type = 1, $ShowDefault = FALSE){
		if ($MasterName == NULL)
			$MasterName = strtoupper($LoopName);
		if ($ValueName == NULL)
			$ValueName = 'w' . $LoopName;

		if ($Type == 1) {
			$HIT = ' CHECKED';
			$HitTag = 'Checked';
		}
		else if ($Type == 2) {
			$HIT = ' SELECTED';
			$HitTag = 'Selected';
		}

		$GLOBALS[$LoopName . 'Loop'] = count($GLOBALS[$MasterName . '_VALUE']);
		$GLOBALS[$LoopName . 'LoopBegin'] = $LoopBegin;
		for ($i = 0; $i < $GLOBALS[$LoopName . 'Loop']; $i++) {
			$GLOBALS[$LoopName . 'Value'][$i] = $GLOBALS[$MasterName . '_VALUE'][$i];
			$GLOBALS[$LoopName . 'Name'][$i] = $GLOBALS[$MasterName . '_NAME'][$i];
			$DefaultFlg = $GLOBALS[$MasterName . '_DEFAULT'][$i];
			$GLOBALS['Index'][$i] = $i - $LoopBegin;

			if ($ShowDefault) {
				$GLOBALS[$LoopName . $HitTag][$i] = ($DefaultFlg == 1) ? $HIT : NULL;
			}
			else {
				if (is_array($GLOBALS[$ValueName]))
					$GLOBALS[$LoopName . $HitTag][$i] = (array_search($GLOBALS[$MasterName . '_VALUE'][$i], $GLOBALS[$ValueName]) !== FALSE) ? $HIT : NULL;
				else
					$GLOBALS[$LoopName . $HitTag][$i] = ($GLOBALS[$MasterName . '_VALUE'][$i] == $GLOBALS[$ValueName]) ? $HIT : NULL;
			}
		}
	}

	/**
	 * Loopタグ用の処理を行う
	 *
	 * @access		private
	 * @param		string		$LoopName		LOOP名称(XxxxLoopのXxxx)
	 * @param		string		$TagName		置き換えられる値のタグ名
	 * @param		string		$MasterName	値が入っているマスタ値の名称のプリフィックス(CARRIER_VALUEとCARRIER_NAMEなら「CARRIER」)
	 * @param		string		$ValueName		マスタ値の取り出しに利用する値配列
	 * @param		string		$LoopBegin		LOOPの開始値
	 * @return		string		処理後の原稿
	 */
	function prepareSimpleMasterLoop ($LoopName, $TagName = NULL, $MasterName = NULL, $Value = NULL, $LoopBegin = 0){
		if ($MasterName == NULL)
			$MasterName = strtoupper($LoopName);

		$MASTER_VALUE = $GLOBALS[$MasterName . '_VALUE'];
		$MASTER_NAME = $GLOBALS[$MasterName . '_NAME'];

		$GLOBALS[$LoopName . 'Loop'] = count($Value);
		$GLOBALS[$LoopName . 'LoopBegin'] = $LoopBegin;
		for ($i = 0; $i < $GLOBALS[$LoopName . 'Loop']; $i++) {
			$GLOBALS['Index'][$i] = $i - $LoopBegin;
			$GLOBALS[$TagName][$i] = $MASTER_NAME[array_search($Value[$i], $MASTER_VALUE)];
		}
	}

	/**
	 * マスタ値のセットを行う。
	 * $pSample = $SAMPLE_NAME[array_search($wSample, $SAMPLE_VALUE)];
	 * をカプセル化するメソッドです。
	 *
	 * @access		private
	 * @param		string		$TagName		置き換えられる値のタグ名
	 * @param		string		$MasterName	置き換えられる値のマスタ名
	 */
	function setValueFromMaster ($TagName = NULL, $MasterName = NULL){
		if ($MasterName == NULL)
			$MasterName = strtoupper($TagName);

		$MASTER_VALUE = $GLOBALS[$MasterName . '_VALUE'];
		$MASTER_NAME = $GLOBALS[$MasterName . '_NAME'];

		if ($GLOBALS['isAdminMode'])
			$GLOBALS['c' . $TagName] = $MASTER_NAME[array_search($GLOBALS['w' . $TagName], $MASTER_VALUE)];
		else
			$GLOBALS['c' . $TagName] = $MASTER_NAME[array_search($GLOBALS['i' . $TagName], $MASTER_VALUE)];
	}

	/**
	 * マスタ値の取得を行う。
	 * $pSample = $SAMPLE_NAME[array_search($wSample, $SAMPLE_VALUE)];
	 * をカプセル化するメソッドです。
	 *
	 * @access		private
	 * @param		string		$TagName		置き換えられる値のタグ名
	 * @param		string		$MasterName	置き換えられる値のマスタ名
	 */
	function getValueFromMaster ($Value = NULL, $MasterName = NULL){
		if ($MasterName == NULL)
			$MasterName = strtoupper($TagName);

		$MASTER_VALUE = $GLOBALS[$MasterName . '_VALUE'];
		$MASTER_NAME = $GLOBALS[$MasterName . '_NAME'];

		return $MASTER_NAME[array_search($Value, $MASTER_VALUE)];
	}
}
?>
