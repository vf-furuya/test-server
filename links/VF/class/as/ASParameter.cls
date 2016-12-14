<?php
/**
 * ASParameterクラス
 *
 * パラメータの入力・出力に関する調整などを行なうクラス。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2005/02/07
 * @version 1.1
 **/

class ASParameter {
	/**
	 * コンストラクタ
	 * このコンストラクタは何もしていません。
	 * 
	 * @access		public
	 */
	function ASParameter () {
	}

	/**
	 * 拡張パスによるパラメータを取得します。
	 * 
	 * @access		public
	 * @return		array		取得値
	 */
	function getPathValue($index=0){
		$path = preg_replace("!^/!", "", $_SERVER["PATH_INFO"]);
		$pathArray = explode("/", $path);
/**
		$retArray = array();
		$index = 0;
		foreach ($pathArray as $p) {
			if (preg_match("!([^=]+)=([^=]*?)!", $p, $matches)) {
				$retArray[$matches[1]] = $matches[2];
			} else {
				$retArray[] = $p;
			}
		}
*/
		return $pathArray[$index];
	}

	/**
	 * HTMLタグを含む文字列をフォーム出力用にします。
	 * 
	 * @access		public
	 * @param		String		$input	処理対象文字列
	 * @return		String		処理後文字列
	 */
	function adjustForPrint($input){
		$prosessed = htmlspecialchars($input, ENT_COMPAT, mb_internal_encoding());

		return $prosessed;
	}

	/**
	 * 数値パラメータを取得します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		Integer		取得値
	 */
	function getNumericValue($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';

		$value = $GLOBALS[$Method][$name];

		if (!($value === NULL || $value === ''))
			$value = intval($value);

		return $value;
	}

	/**
	 * 文字列パラメータを取得します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		String		取得値
	 */
	function getStringValue($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';

		$GLOBALS['_POST'][$name] = stripslashes($GLOBALS['_POST'][$name]);
		$GLOBALS{$name} = $GLOBALS['_POST'][$name];
		$HTTP_POST_VARS[$name] = $GLOBALS['_POST'][$name];

		$value = $GLOBALS[$Method][$name];

		return $value;
	}

	/**
	 * 文字列パラメータを取得します。
	 * 
	 * php.ini設定の "magic_quotes_gpc" の値を見て、addslashes() されているようなら stripslashes() します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		String		取得値
	 */
	function getStringValueNonQuoted($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';

		if (ini_get('magic_quotes_gpc')) {
			$GLOBALS['_POST'][$name] = stripslashes($GLOBALS['_POST'][$name]);
			$GLOBALS{$name} = $GLOBALS['_POST'][$name];
			$HTTP_POST_VARS[$name] = $GLOBALS['_POST'][$name];
		}

		$value = $GLOBALS[$Method][$name];

		return $value;
	}

	/**
	 * 配列パラメータを取得します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		String		取得値
	 */
	function getArrayValue($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';
		if (!is_array($GLOBALS[$Method][$name])) return '';
		for ($i = 0; $i < count($GLOBALS[$Method][$name]); $i++) {
			$GLOBALS[$Method][$name][$i] = stripslashes($GLOBALS[$Method][$name][$i]);
			$GLOBALS[$name][$i] = $GLOBALS[$Method][$name][$i];
			$HTTP_POST_VARS[$name][$i] = $GLOBALS[$Method][$name][$i];
		}

		$value = $GLOBALS[$Method][$name];

		return $value;
	}

	/**
	 * データ内容がカンマ区切りの数値の配列パラメータを数値変換処理を実行しつつ取得します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		String		取得値
	 */
	function getArrayNumberFormatValue($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';
		for ($i = 0; $i < count($GLOBALS[$Method][$name]); $i++) {
			$GLOBALS['_POST'][$name][$i] = stripslashes($GLOBALS['_POST'][$name][$i]);
			$GLOBALS['_POST'][$name][$i] = mb_convert_kana($GLOBALS['_POST'][$name][$i], "n");
			$GLOBALS['_POST'][$name][$i] = str_replace(',', '', $GLOBALS['_POST'][$name][$i]);
			$GLOBALS[$name][$i] = $GLOBALS['_POST'][$name][$i];
			$HTTP_POST_VARS[$name][$i] = $GLOBALS['_POST'][$name][$i];
		}

		$value = $GLOBALS[$Method][$name];

		return $value;
	}

	/**
	 * 値段やサイズなどのカンマ区切りのデータを数字に直して取得します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		String		取得値
	 */
	function getNumberFormatValue($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';

		$GLOBALS['_POST'][$name] = stripslashes($GLOBALS['_POST'][$name]);
		$GLOBALS['_POST'][$name] = mb_convert_kana($GLOBALS['_POST'][$name], "n");
		$GLOBALS['_POST'][$name] = str_replace(',', '', $GLOBALS['_POST'][$name]);
		$GLOBALS{$name} = $GLOBALS['_POST'][$name];
		$HTTP_POST_VARS[$name] = $GLOBALS['_POST'][$name];

		$value = $GLOBALS[$Method][$name];

		return $value;
	}

	/**
	 * 日付データを「Y-m-d H:i:s」フォーマットで取得します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		String		取得値
	 */
	function getDateValue($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';

		if ($GLOBALS[$Method][$name])
			$GLOBALS[$Method][$name] = date('Y-m-d H:i:s', strtotime($GLOBALS[$Method][$name]));
		$GLOBALS{$name} = $GLOBALS[$Method][$name];
		$HTTP_POST_VARS[$name] = $GLOBALS[$Method][$name];

		$value = $GLOBALS[$Method][$name];

		return $value;
	}

	/**
	 * データ内容に全角カナが含まれていた場合は、半角ｶﾅ変換処理を実行しつつ取得します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		String		取得値
	 */
	function getStringValueToHankakuKana($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';

		$GLOBALS['_POST'][$name] = mb_convert_kana(stripslashes($GLOBALS['_POST'][$name]), 'k');
		$GLOBALS{$name} = $GLOBALS['_POST'][$name];
		$HTTP_POST_VARS[$name] = $GLOBALS['_POST'][$name];

		$value = $GLOBALS[$Method][$name];

		return $value;
	}

	/**
	 * データ内容に半角ｶﾅが含まれていた場合は、全角カナ変換処理を実行しつつ取得します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		String		取得値
	 */
	function getStringValueToZenkakuKana($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';

		$GLOBALS['_POST'][$name] = mb_convert_kana(stripslashes($GLOBALS['_POST'][$name]), 'KSV');
		$GLOBALS{$name} = $GLOBALS['_POST'][$name];
		$HTTP_POST_VARS[$name] = $GLOBALS['_POST'][$name];

		$value = $GLOBALS[$Method][$name];

		return $value;
	}

	/**
	 * データ内容に全角英数字が含まれていた場合は、半角英数字変換処理を実行しつつ取得します。
	 * 
	 * @access		public
	 * @param		String		$name	取得パラメータ名称
	 * @return		String		取得値
	 */
	function getStringValueToHankakuAlphaNumeric($name){
		if (isset($GLOBALS['_GET'][$name]))
			$Method = '_GET';
		else
			$Method = '_POST';

		$GLOBALS['_POST'][$name] = mb_convert_kana(stripslashes($GLOBALS['_POST'][$name]), 'as');
		$GLOBALS{$name} = $GLOBALS['_POST'][$name];
		$HTTP_POST_VARS[$name] = $GLOBALS['_POST'][$name];

		$value = $GLOBALS[$Method][$name];

		return $value;
	}

	/**
	 * 必須入力チェック
	 * 
	 * @access		public
	 * @param		String		$value	処理対象文字列
	 * @return		Bool		処理結果(不適切ならTRUE)
	 */
	function isEmpty($value){
		if ($value == NULL)
			return TRUE;

		return FALSE;
	}

	/**
	 * 数値→アルファベットマッピング
	 * 
	 * @access		public
	 * @param		String		$value	処理対象文字列
	 * @return		String		処理結果
	 */
	function encodeMapping($value){
		for ($i = 0; $i < strlen($value); $i++)
			$result = $result . $GLOBALS['MAPPING'][$value[$i]];

		return $result;
	}

	/**
	 * アルファベット→数値マッピング
	 * 
	 * @access		public
	 * @param		String		$value	処理対象文字列
	 * @return		String		処理結果
	 */
	function decodeMapping($value){
		for ($i = 0; $i < strlen($value); $i++)
			$result = $result . $GLOBALS['MAPPING_C'][$value[$i]];

		return $result;
	}
}
?>
