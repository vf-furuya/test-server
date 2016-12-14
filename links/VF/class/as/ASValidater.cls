<?php
/**
 * ASValidaterクラス
 *
 * 入力チェックに用いる静的メソッドの集合クラス。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2003/01/31
 * @version 0.1
 **/

include_once _AS_CLS_DIR . "ASDate.cls";

class ASValidater {
	/**
	 * コンストラクタ
	 * このコンストラクタは何もしていません。
	 * 
	 * @access		public
	 */
	public function ASValidater () {
	}

	/**
	 * $inputが数字列かどうかを判定します。
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function isNumeric($input, $IfError = FALSE, $LimitToIntegerFlg = FALSE, $LimitToNumberFlg = FALSE){
		if (is_array($input)) {
			for ($i = 0; $i < count($input); $i++) {
				$Flg = ASValidater::checkNumeric($input[$i], $IfError, $LimitToIntegerFlg, $LimitToNumberFlg);
				$IfError = ($IfError || !$Flg) ? TRUE : FALSE;
			}
		}
		else {
			$Flg = ASValidater::checkNumeric($input, $IfError, $LimitToIntegerFlg, $LimitToNumberFlg);
			$IfError = ($IfError || !$Flg) ? TRUE : FALSE;
		}

		return $Flg;
	}

	/**
	 * $inputが数字列かどうかを判定します。
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function checkNumeric($input, $IfError = FALSE, $LimitToIntegerFlg = FALSE, $LimitToNumberFlg = FALSE){
		$Flg = TRUE;

		// 半角のみで構成されていなければエラー
		if (strlen($input) != mb_strlen($input))
			$Flg = FALSE;

		for( $i = 0 ; $i < strlen( $input ) ; $i++ ){
			$a_char = substr( $input, $i, 1 );
			if ($LimitToIntegerFlg) {
				if((ord("0") <= ord($a_char) && ord("9") >= ord($a_char)) || $a_char == "-"){
				}
				else{
					$Flg = FALSE;
				}
			}
			else if ($LimitToNumberFlg) {
				if(ord("0") <= ord($a_char) && ord("9") >= ord($a_char)){
				}
				else{
					$Flg = FALSE;
				}
			}
			else {
				if((ord("0") <= ord($a_char) && ord("9") >= ord($a_char)) || $a_char == "-" || $a_char == "."){
				}
				else{
					$Flg = FALSE;
				}
			}
		}

		if (!$Flg)
			$IfError = TRUE;

		return $Flg;
	}

	/**
	 * 入力が半角英字かどうかを判定します。
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function isAlphabet($input, $IfError = FALSE){
		$Flg = TRUE;

		// 半角のみで構成されていなければエラー
		if (strlen($input) != mb_strlen($input))
			$Flg = FALSE;

		for( $i = 0 ; $i < strlen( $input ) ; $i++ ){
			$a_char = substr( $input, $i, 1 );
			if( ( (ord("a") <= ord($a_char) ) && (ord("z") >= ord($a_char) ) ) ||
				( (ord("A") <= ord($a_char) ) && (ord("Z") >= ord($a_char) ) ) ){
			}else{
				$Flg = FALSE;
			}
		}

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力が半角英数字及び半角記号かどうかを判定します。
	 * 現在記号として許可されているのは「@」「:」「;」「<」「>」「.」「-」「_」「?」「/」です。
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function isAlphaNumeric($input, $IfError = FALSE){
		$Flg = TRUE;

		for( $i = 0 ; $i < strlen( $input ) ; $i++ ){
			$a_char = substr( $input, $i, 1 );
			if( ( (ord("a") <= ord($a_char) ) && (ord("z") >= ord($a_char) ) ) ||
				( (ord("A") <= ord($a_char) ) && (ord("Z") >= ord($a_char) ) ) ||
				( (ord("0") <= ord($a_char) ) && (ord("9") >= ord($a_char) ) ) ||
				( $a_char == "@" ) ||
				( $a_char == ":" ) ||
				( $a_char == ";" ) ||
				( $a_char == "<" ) ||
				( $a_char == ">" ) ||
				( $a_char == "." ) ||
				( $a_char == "-" ) ||
				( $a_char == "/" ) ||
				( $a_char == "\\") ||
				( $a_char == "?" ) ||
				( $a_char == "&" ) ||
				( $a_char == "=" ) ||
				( $a_char == "%" ) ||
				( $a_char == "$" ) ||
				( $a_char == "#" ) ||
				( $a_char == "'" ) ||
				( $a_char == "+" ) ||
				( $a_char == "_" ) ){
			}else{
				$Flg = FALSE;
			}
		}

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力が半角英数字かどうかを判定します。
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function isCompletelyAlphaNumeric($input, $IfError = FALSE, $Minimum = -1, $Maximum = -1){
		$Flg = TRUE;

		for( $i = 0 ; $i < strlen( $input ) ; $i++ ){
			$a_char = substr( $input, $i, 1 );
			if( ( (ord("a") <= ord($a_char) ) && (ord("z") >= ord($a_char) ) ) ||
				( (ord("A") <= ord($a_char) ) && (ord("Z") >= ord($a_char) ) ) ||
				( (ord("0") <= ord($a_char) ) && (ord("9") >= ord($a_char) ) ) ) {
			}
			else{
				$Flg = FALSE;
			}
		}

		if ($Minimum != -1 && strlen($input) < $Minimum)
			$Flg = FALSE;
		if ($Maximum != -1 && strlen($input) > $Maximum)
			$Flg = FALSE;

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * ふたつの入力が同一かチェックします(どちらかがNULLの場合には判定を放棄します)
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function isSame($input1, $input2, $IfError = FALSE){
		$Flg = TRUE;

		if ($input1 == NULL || $input2 == NULL)
			return TRUE;

		if ($input1 != $input2)
			$Flg = FALSE;

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力がe-mailとして適しているかどうかを判定します。
	 * 利用可能文字はisAlphaNumericに準拠し、さらに@およびピリオド「.」が最低ひとつ含まれていることが条件となる。
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function isRightEMail($input, $IfError = FALSE){
		$Flg = TRUE;

		if (!ASValidater::isAlphaNumeric($input))
			$Flg = FALSE;

		$Check = str_replace('@', NULL, $input);
		if (strlen($input) - strlen($Check) != 1)
			$Flg = FALSE;

		if (!strstr($input, "."))
			$Flg = FALSE;

		$regs = explode('@', $input);
		$Domain = $regs[1];

		//if (!eregi('[a-z0-9-]+([\.][a-z0-9-]+)+$', $Domain))
		if (!preg_match('/[a-z0-9-]+([\.][a-z0-9-]+)+$/i', $Domain))
			$Flg = FALSE;

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力が日付として適しているかどうかを判定します。
	 * @access		public
	 * @param		String		$input	YYYY/MM/DD hh:mm:ss形式の日付
	 * @return		boolean		チェック結果
	 */
	public static function isRightDate($input, $separator = NULL, $IfError = FALSE){
		if ($separator == NULL)
			$myTimestamp = ASDate::getPiecesOfTimestamp($input);
		else {
			$regs = explode($separator, $input);
			$myTimestamp['Year'] = $regs[0];
			$myTimestamp['Month'] = $regs[1];
			$myTimestamp['Day'] = $regs[2];
		}

		// YAMAZAKI modified 2011.08.19
		if (empty($myTimestamp['Month']) || empty($myTimestamp['Day']) || empty($myTimestamp['Year'])) {
			$Flg = FALSE;
		}
		else {
			$Flg = checkdate($myTimestamp['Month'], $myTimestamp['Day'], $myTimestamp['Year']);
		}

		if (!is_numeric($myTimestamp['Year']))
			$Flg = FALSE;
		if (!is_numeric($myTimestamp['Month']))
			$Flg = FALSE;
		if (!is_numeric($myTimestamp['Day']))
			$Flg = FALSE;

		if ($myTimestamp['Hour'] != NULL && ($myTimestamp['Hour'] < 0 || $myTimestamp['Hour'] > 24))
			$Flg = FALSE;
		if ($myTimestamp['Minute'] != NULL && ($myTimestamp['Minute'] < 0 || $myTimestamp['Minute'] > 60))
			$Flg = FALSE;
		if ($myTimestamp['Second'] != NULL && ($myTimestamp['Second'] < 0 || $myTimestamp['Second'] > 60))
			$Flg = FALSE;

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力が時間として適しているかどうかを判定します。
	 * @access		public
	 * @param		String		$input	時間
	 * @return		boolean		チェック結果
	 */
	public static function isRightHour($input, $IfError = FALSE){
		$Flg = TRUE;

		if (!is_numeric($input))
			$Flg = FALSE;

		if ($input < 0 || $input > 23)
			$Flg = FALSE;

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力が時刻として適しているかどうかを判定します。
	 * @access		public
	 * @param		String		$input	hh:mm(:ss)形式の日付
	 * @return		boolean		チェック結果
	 */
	public static function isRightTime($input, $IfError = FALSE){
		$regs = explode(":", $input);

		$Index = array('Hour', 'Minute', 'Second');

		$myTimestamp['Hour'] = $regs[0];
		$myTimestamp['Minute'] = $regs[1];
		$myTimestamp['Second'] = ($regs[2] === NULL) ? 0 : $regs[2];

		$Flg = TRUE;

		if (!is_numeric($myTimestamp['Hour']))
			$Flg = FALSE;
		if (!is_numeric($myTimestamp['Minute']))
			$Flg = FALSE;
		if (!is_numeric($myTimestamp['Second']))
			$Flg = FALSE;

		if ($myTimestamp['Hour'] !== NULL && ($myTimestamp['Hour'] < 0 || $myTimestamp['Hour'] > 24))
			$Flg = FALSE;
		if ($myTimestamp['Minute'] !== NULL && ($myTimestamp['Minute'] < 0 || $myTimestamp['Minute'] > 60))
			$Flg = FALSE;
		if ($myTimestamp['Second'] !== NULL && ($myTimestamp['Second'] < 0 || $myTimestamp['Second'] > 60))
			$Flg = FALSE;

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	* 日時チェック
	*
	* $itemが日時として正しいかどうかをチェックします。
	*
	* @access	public
	* @param	string		$item	チェックする項目
	* @return	boolean		不適切ならTRUE
	*/
	public static function isProperDatetime($item, &$IfError = FALSE){
		$Flg = TRUE;

		$regs = explode(" ", $item);

		if (!ASValidater::isRightDate($regs[0]) || !ASValidater::isRightTime($regs[1]))
			$Flg = FALSE;

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力の文字数を返します。
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @return		Integer		文字列長
	 */
	public static function getStringLength($input){
		return strlen($input);
	}

	/**
	 * 入力のバイト数をチェックします。
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @param		Integer		最小値
	 * @param		Integer		最大値
	 * @return		boolean		チェック結果
	 */
	public static function checkLength($input, $min = NULL, $max = NULL, $IfError = FALSE){
		$Flg = TRUE;

		if ($min > 0 && strlen($input) < $min)
			$Flg = FALSE;
		if ($max > 0 && strlen($input) > $max)
			$Flg = FALSE;

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力の文字数をチェックします。(mb)
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @param		Integer		最小値
	 * @param		Integer		最大値
	 * @return		boolean		チェック結果
	 */
	public static function mb_checkLength($input, $min = NULL, $max = NULL, $IfError = FALSE){
		$Flg = TRUE;

		if ($min > 0 && mb_strlen($input) < $min)
			$Flg = FALSE;
		if ($max > 0 && mb_strlen($input) > $max)
			$Flg = FALSE;

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力が電話番号として正しいかどうかを判定します。
	 * 半角数値・ハイフンだけかどうかのチェックですが、本来は桁数チェックも必要かも
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function isRightTelephoneNumber($input, $IfError = FALSE){
		$Flg = TRUE;

/*
		for( $i = 0 ; $i < strlen( $input ) ; $i++ ){
			$a_char = substr( $input, $i, 1 );
			if( ( (ord("0") <= ord($a_char) ) && (ord("9") >= ord($a_char) ) ) ||
				( $a_char == "-" )){
			}else{
				$Flg = FALSE;
				break;
			}
		}
*/

		if(!preg_match("/^0\d{1,5}-\d{0,4}-?\d{3,4}$/", $input) && !preg_match("/^\d{10,13}$/", $input)) {
			$Flg = FALSE;
		}

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}


	/**
	 * 入力数値の各種チェックを行ないます。
	 * 
	 * @access		public
	 * @param		String		$input		チェック対象文字列
	 * @param		Integer		$rangeFrom	整数範囲開始値
	 * @param		Integer		$rangeTo	整数範囲終了値
	 * @return		Integer		チェック結果
	 */
	public static function isProperNumber($input, $rangeFrom = NULL, $rangeTo = NULL){
		define('_IS_PROPER', 1);
		define('_NOT_NUMERIC', 2);
		define('_LESS_THAN_RANGE', 3);
		define('_MORE_THAN_RANGE', 4);

		$judge = _IS_PROPER;
		if (!ASValidater::isNumeric($input))
			$judge = _NOT_NUMERIC;
		else if ($rangeFrom !== NULL && $input < $rangeFrom)
			$judge = _LESS_THAN_RANGE;
		else if ($rangeTo !== NULL && $input > $rangeTo)
			$judge = _MORE_THAN_RANGE;

		return $judge;
	}

	/**
	 * 入力がカタカナのみかどうか判定します。
	 * 
	 * @access		public
	 * @param		String		$input		チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function isKatakana($input, $IfError = FALSE){
		$Flg = TRUE;

		// 入力の調整
		// $input = mb_convert_kana($input, 'KV');
		$Katakana = array('キャ', 'キュ', 'キョ', 'ギャ', 'ギュ', 'ギョ', 'シャ', 'シュ', 'ショ', 'ジャ', 'ジュ', 'ジョ', 'チャ', 'チュ', 'チョ', 'ヂャ', 'ヂュ', 'ヂョ', 'ニャ', 'ニュ', 'ニョ', 'ヒャ', 'ヒュ', 'ヒョ', 'ビャ', 'ビュ', 'ビョ', 'ピャ', 'ピュ', 'ピョ', 'リャ', 'リュ', 'リョ', 'ア', 'イ', 'ウ', 'エ', 'オ', 'カ', 'キ', 'ク', 'ケ', 'コ', 'サ', 'シ', 'ス', 'セ', 'ソ', 'タ', 'チ', 'ツ', 'テ', 'ト', 'ナ', 'ニ', 'ヌ', 'ネ', 'ノ', 'ハ', 'ヒ', 'フ', 'ヘ', 'ホ', 'マ', 'ミ', 'ム', 'メ', 'モ', 'ヤ', 'ユ', 'ヨ', 'ラ', 'リ', 'ル', 'レ', 'ロ', 'ワ', 'ヲ', 'ン', 'ヴ', 'ガ', 'ギ', 'グ', 'ゲ', 'ゴ', 'ザ', 'ジ', 'ズ', 'ゼ', 'ゾ', 'ダ', 'ヂ', 'ヅ', 'デ', 'ド', 'バ', 'ビ', 'ブ', 'ベ', 'ボ', 'パ', 'ピ', 'プ', 'ペ', 'ポ', 'ァ', 'ィ', 'ゥ', 'ェ', 'ォ', 'ッ', 'ャ', 'ュ', 'ョ', 'ー', '　');

		for ($i = 0; $i < mb_strlen($input); $i++){
			$character = mb_substr($input, $i, 1);
			if (array_search($character, $Katakana) === FALSE || array_search($character, $Katakana) === NULL)
				$Flg = FALSE;
		}

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力がひらがなのみかどうか判定します。
	 * 
	 * @access		public
	 * @param		String		$input		チェック対象文字列
	 * @return		boolean		チェック結果
	 */
	public static function isHiragana($input, $IfError = FALSE){
		$Flg = TRUE;

		// 入力の調整
		// $input = mb_convert_kana($input, 'KV');
		$Hiragana = array('きゃ', 'きゅ', 'きょ', 'ぎゃ', 'ぎゅ', 'ぎょ', 'しゃ', 'しゅ', 'しょ', 'じゃ', 'じゅ', 'じょ', 'ちゃ', 'ちゅ', 'ちょ', 'ぢゃ', 'ぢゅ', 'ぢょ', 'にゃ', 'にゅ', 'にょ', 'ひゃ', 'ひゅ', 'ひょ', 'びゃ', 'びゅ', 'びょ', 'ぴゃ', 'ぴゅ', 'ぴょ', 'りゃ', 'りゅ', 'りょ', 'あ', 'い', 'う', 'え', 'お', 'か', 'き', 'く', 'け', 'こ', 'さ', 'し', 'す', 'せ', 'そ', 'た', 'ち', 'つ', 'て', 'と', 'な', 'に', 'ぬ', 'ね', 'の', 'は', 'ひ', 'ふ', 'へ', 'ほ', 'ま', 'み', 'む', 'め', 'も', 'や', 'ゆ', 'よ', 'ら', 'り', 'る', 'れ', 'ろ', 'わ', 'を', 'ん', 'う゛', 'が', 'ぎ', 'ぐ', 'げ', 'ご', 'ざ', 'じ', 'ず', 'ぜ', 'ぞ', 'だ', 'ぢ', 'づ', 'で', 'ど', 'ば', 'び', 'ぶ', 'べ', 'ぼ', 'ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ', 'ぁ', 'ぃ', 'ぅ', 'ぇ', 'ぉ', 'っ', 'ゃ', 'ゅ', 'ょ', 'ー', '　');
		for ($i = 0; $i < mb_strlen($input); $i++){
			$character = mb_substr($input, $i, 1);
			if (array_search($character, $Hiragana) === FALSE || array_search($character, $Hiragana) === NULL)
				$Flg = FALSE;
		}

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	* 全角文字チェック
	*
	* $itemが全角文字で構成されているかチェックをする。
	*
	* @access	public
	* @param	string		$item	チェックする項目
	* @return	boolean		チェック結果
	*/
	public static function isZenkaku($item, $IfError = FALSE){
		$Flg = TRUE;

		if(strlen($item) != mb_strlen($item) * 2){
			$Flg = FALSE;
		}

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	* NULLチェック
	*
	* $itemがNULL(空)かどうかをチェックします。
	*
	* @access	public
	* @param	string		$item	チェックする項目
	* @return	boolean		NULLならTRUE
	*/
	public static function isEmpty($item, $IfError = FALSE, $ZeroNGFlg = FALSE){
		$item=preg_replace('/\s|　/','',$item); 
		
		if ($item == NULL) {
			$Flg = TRUE;
		}
//		else if (strlen($item) == 0) {
//			$Flg = TRUE;
//		}
		else if ($ZeroNGFlg && $item == 0) {
			$Flg = TRUE;
		}
		else {
			$Flg = FALSE;
		}

		$IfError = ($IfError || $Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	 * 入力の改行数をチェックします。(\n)
	 * 
	 * @access		public
	 * @param		String		$input	チェック対象文字列
	 * @param		Integer		最大値
	 * @return		boolean		チェック結果
	 */
	public static function checkRows($input, $max = NULL, $IfError = FALSE){
		$Flg = TRUE;

		$InputArr = explode("\n", $input);

		if (is_array($InputArr) && count($InputArr) > 0) {
			if (count($InputArr) > $max) {
				$Flg = FALSE;
			}
		}

		$IfError = ($IfError || !$Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	* 文字数チェック(セキュリティチェック)
	*
	* $itemがtextboxの最大文字数を超えていないかどうかをチェックします。
	*
	* @access	public
	* @param	string		$item	チェックする項目
	* @return	boolean		NULLならTRUE
	*/
	public static function isTextboxSizeError($item, $IfError = FALSE){
		if (strlen($item) > _TEXTBOX_LIMIT_LENGTH) {
			$Flg = TRUE;
		} else {
			$Flg = FALSE;
		}

		$IfError = ($IfError || $Flg) ? TRUE : FALSE;

		return $Flg;
	}

	/**
	* 文字数チェック(セキュリティチェック)
	*
	* $itemがtextareaの最大文字数を超えていないかどうかをチェックします。
	*
	* @access	public
	* @param	string		$item	チェックする項目
	* @return	boolean		NULLならTRUE
	*/
	public static function isTextareaSizeError($item, $IfError = FALSE){
		if (strlen($item) > _TEXTAREA_LIMIT_LENGTH) {
			$Flg = TRUE;
		} else {
			$Flg = FALSE;
		}

		$IfError = ($IfError || $Flg) ? TRUE : FALSE;

		return $Flg;
	}

}
?>
