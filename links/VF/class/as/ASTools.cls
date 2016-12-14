<?php
/**
 * ASToolsクラス
 *
 * ちょっとしたツールたち
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2003/10/24
 * @version 0.1
 **/

define ("EXIST_CLASS_ASTOOLS","yes");

class ASTools {
	/**
	 * エラーメッセージ
	 */
	var $Err;

	/**
	 * コンストラクタ
	 * 処理は特にナシ
	 * @access		public
	 */
	function ASTools($filename = "", $carrier = ""){
	}

	/**
	 * ファイルを開く
	 * 与えられた名称のファイルを読み込み、その内容を返します。
	 * @param		String		$filename	ファイル名
	 * @return		String		ファイル内容
	 * @access		public
	 */
	function getFile($filename){
		if (!file_exists($filename)) {
			return false;
		}
		if (!$fp = fopen($filename, "r")){
			$this->Err = $filename . "の読込に失敗しました";
			return false;
		}

		$msg = "";		// コンテンツ格納変数を初期化
		while (!feof($fp)){
			$msg .= fgets($fp, 10240);
		}

		fclose ($fp);

		return $msg;
	}

	/**
	 * ファイルへの書き込みを行う
	 * 与えられた名称のファイルを書き込みモードでオープンし、所定の内容を書き込みます
	 * @param		String		$filename	ファイル名
	 * @param		String		$str		ファイル内容
	 * @access		public
	 */
	function putFile($filename, $str){
		if (!$fp = fopen($filename, "w")){
			$Err = $filename . "のオープンに失敗しました";
			return false;
		}

		fwrite($fp, $str);
		fclose ($fp);

		return true;
	}

	/**
	 * ファイルへの書き込みを行う
	 * 与えられた名称のファイルを書き込みモードでオープンし、所定の内容を書き込みます
	 *
	 * @param		String		$filename	ファイル名
	 * @param		String		$str		ファイル内容
	 * @access		public
	 */
	function appendFile($filename, $str){
		if (!$fp = fopen($filename, 'a+')){
			$Err = $filename . "のオープンに失敗しました";
			return FALSE;
		}

		fwrite($fp, $str);
		fclose ($fp);

		return TRUE;
	}

	/**
	 * ファイルの削除と他サーバ同期を行う。
	 * 
	 * @param		String		$filename	ファイル名
	 * @access		public
	 */
	function removeFile($filename){
		// 削除処理
		shell_exec ('rm -f ' . $filename . ' 2>&1');

		return TRUE;
	}

	/**
	 * ファイルへの書き込み及び他サーバとの同期を行う
	 * 
	 * @param		String		$filename	ファイル名
	 * @param		String		$str		ファイル内容
	 * @access		public
	 */
	function putFileWithSync($filename, $str){
		// 書き込み
		ASTools::putFile($filename, $str);
		// 権限変更
		exec ('chmod 666 ' . $filename);
		// 同期処理
		//SiteControl::syncFile('www', $filename);

		return true;
	}

	/**
	 * ファイルの削除と他サーバ同期を行う。
	 * 
	 * @param		String		$filename	ファイル名
	 * @access		public
	 */
	function removeFileWithSync($filename){
		// 削除処理
		shell_exec ('rm -f ' . $filename . ' 2>&1');
		// 同期処理
		SiteControl::syncFile($filename, TRUE);

		return TRUE;
	}
	
	/**
	 * ファイル名の変更と他サーバ同期を行う。
	 * 
	 * @param		String		$FromFilename	変更元ファイル名
	 * @param		String		$ToFilename		変更先ファイル名
	 * @access		public
	 */
	function renameFileWithSync($FromFilename, $ToFilename){
		// リネーム処理
		shell_exec ('mv ' . $FromFilename . ' ' . $ToFilename. ' 2>&1');
		// 同期処理
		//SiteControl::syncFile2('www', $FromFilename, $ToFilename, 'rename');

		return TRUE;
	}
	
	/**
	 * ファイルのコピーと他サーバ同期を行う。
	 * 
	 * @param		String		$FromFilename	コピー元ファイル名
	 * @param		String		$ToFilename	コピー先ファイル名
	 * @access		public
	 */
	function copyFileWithSync($FromFilename, $ToFilename){
		// コピー処理
		shell_exec ('cp ' . $FromFilename . ' ' . $ToFilename. ' 2>&1');
		// 同期処理
		//SiteControl::syncFile2('www', $FromFilename, $ToFilename, 'copy');

		return TRUE;
	}
	
	/**
	 * ファイルのシボリックリンクと他サーバ同期を行う。
	 * 
	 * @param		String		$FromFilename	リンク元ファイル名
	 * @param		String		$ToFilename		リンク先ファイル名
	 * @access		public
	 */
	function symboliclinkFileWithSync($FromFilename, $ToFilename){
		// コピー処理
		shell_exec ('ln -s ' . $FromFilename . ' ' . $ToFilename. ' 2>&1');
		// 同期処理
		//SiteControl::syncFile2('www', $FromFilename, $ToFilename, 'slink');

		return TRUE;
	}

	function nl2br($Value){
		$Value = str_replace("\n", "[BR]", $Value);

		return $Value;
	}

	function sendMailFromText($Identifier, $EMail, $myHtml){
		$Filename = _TEXT_DIR . $Identifier . '_subject.txt';
		if (file_exists($Filename)) {
			$Subject = ASTools::getFile($Filename);
		} else {
			return FALSE;
		}

		$Filename = _TEXT_DIR . $Identifier . '_message.txt';
		if (file_exists($Filename)) {
			$Message = ASTools::getFile($Filename);
		} else {
			return FALSE;
		}

		$Filename = _TEXT_DIR . $Identifier . '_sendfrom.txt';
		if (file_exists($Filename)) {
			$SendFrom = ASTools::getFile($Filename);
		} else {
			return FALSE;
		}

		$myHtml->Msg = $Subject;
		$myHtml->convertTags();
		$Subject = $myHtml->Msg;

		$myHtml->Msg = $Message;
		$myHtml->convertTags();
		$Message = $myHtml->Msg;

		$Headers = "From: " . mb_encode_mimeheader($SendFrom, "ISO-2022-JP", "Q") . " <" . $SendFrom . ">\n";
		if ($wBcc != NULL)
			$Headers .= "Bcc: " . $wBcc . "\n";

		if(!mb_send_mail ($EMail, $Subject, $Message, $Headers, "-f" . $SendFrom))
			trigger_error("ending Mail Failed. Please Look Up maillog.", E_USER_ERROR);

		return TRUE;
	}

	function encodePluralValue($Value, $Separator = '|'){
		if (is_array($Value)) {
			for ($i = 0; $i < count($Value); $i++) {
				if ($i > 0)
					$Encoded .= $Separator;
				$Encoded .= $Value[$i];
			}
		}
		else
			$Encoded = $Value;

		$Encoded = '|' . $Encoded . '|';

		return $Encoded;
	}

	function decodePluralValue($Value, $Separator = '|'){
		if (substr($Value, 0, 1) == '|')
			$Value = substr($Value, 1, -1);

		if ($Value == NULL)
			return array();

		$Decoded = explode($Separator, $Value);

		return $Decoded;
	}

	#
	# 配列の値がNullのものを削除(キーは数値)
	#
	function deleteNullArray($Arr) {
		if (!is_array($Arr)) {
			return array();
		}

		$rtn = array();
		for ($i = 0; $i < count($Arr); $i++) {
			if ($Arr[$i]) {
				$rtn[] = $Arr[$i];
			}
		}

		return $rtn;
	}
}
?>
