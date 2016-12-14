<?php
	/**
	 * IPアドレス10進数変換(文字 ⇒ 10進数)
	 * @param string IPAddres
	 * @return int IPaddres
	 */
	function decimalIpaddres($ip) {
		$intIP = 0;

		//四分割化
		$splitIP = explode(".",$ip,4);

		//nnnn * 256^x + mmmm * 256^x-1 ....
		for($i = 0 ; $i < 4;$i++){
			$intIP += (int)$splitIP[$i] *  pow(256, (3 - $i));
		}

		return $intIP;

	}

	/**
	 * IPアドレス10進数変換(10進数 ⇒ 文字)
	 * @param int IPAddres
	 * @return string IPaddres
	 */
	function stringIpaddres($ip) {
		$strIP = "";
		if ($ip == ""){
			return $ip;
		}

		$total = 0;

		for($i = 0 ; $i <= 4;$i++){
			$splitIP[$i] = (int)(($ip - $total) / pow(256, 3 - $i));
			$total += $splitIP[$i] * pow(256, 3 - $i);
		}
		$strIP = $splitIP[0] . "." . $splitIP[1] . "." . $splitIP[2] . "." . $splitIP[3];

		return $strIP;
	}

	#
	# Return a random value
	#
	function _randGen($min = null, $max = null) {
		static $seeded;

		if (!isset($seeded)) {
			mt_srand((double)microtime()*1000000);
			$seeded = true;
		}

		if (isset($min) && isset($max)) {
			if ($min >= $max) {
				return $min;
			} else {
				return mt_rand($min, $max);
			}
		} else {
			return mt_rand();
		}
	}

	#
	# パスワード判定
	#
	function _validate_password($plain, $encrypted) {
		if ($plain && $encrypted) {
			// split apart the hash / salt
			$stack = explode(':', $encrypted);
			if (sizeof($stack) != 2) return false;
			if (md5($stack[1] . $plain) == $stack[0]) {
				return true;
			}
		}
		return false;
	}

	/**
	* adminsテーブル,creatorsテーブル Name検索
	*
	* @access		public
	* @param		object		$DB				DBConnectionオブジェクト
	* @param		string		$NameStr		検索Name
	* @param		integer		$AdminID		adminsテーブルで確認するID
	* @param		integer		$CreatorID		creatorsテーブルで確認するID
	* @return		boolean						FALSE:存在なし又は本人 TRUE:存在
	*/
	function existsName($DB = NULL, $NameStr = '', $AdminID = NULL, $CreatorID = NULL){
		if ($DB === NULL || strlen($NameStr) === 0) {
			trigger_error("データを抽出出来ませんでした。 existsName Failed. Name:" . $NameStr, E_USER_ERROR);
			exit;
		}

		$existsAdmin = existsStringColumn($DB, 'admins', 'Name', $NameStr, (int)$AdminID);
		$existsCreator = existsStringColumn($DB, 'creators', 'Name', $NameStr, (int)$CreatorID);

		return ($existsAdmin || $existsCreator);
	}

	/**
	 * 特定カラム検索
	 *
	 * @access		public
	 * @param		object		$DB				DBConnectionオブジェクト
	 * @param		string		$TableName		対象テーブル
	 * @param		string		$ColumnName		対象カラム
	 * @param		string		$editString		検索文字列
	 * @param		integer		$editID			検索ID
	 * @return		boolean						FALSE:存在なし又は$editID自身 TRUE:存在
	 */
	function existsStringColumn($DB = NULL, $TableName = '', $ColumnName = '', $editString = '', $editID = NULL){
		$result = 0;

		if ($DB === NULL || strlen($TableName) === 0 || strlen($ColumnName) === 0 || strlen($editString) === 0) {
			$result = FALSE;
		}
		else{
			$CheckString = '';
			// IDの指示あり(更新)自身のカラム値取得
			if((int)$editID > 0){
				$sql = "SELECT `" . $ColumnName . "` FROM `" . $TableName . "` WHERE ID = " . (int)$editID . " AND Delete_flag = 0";
				if($rtn = $DB->executeQuery($sql)){
					list($CheckString) = mysql_fetch_row($rtn);
				}
				else{
					$result = FALSE;
				}
			}
			// 自身と違う$editStringを指定されていたら存在確認
			if($CheckString != $editString){
				$sql = "SELECT count(*) FROM `" . $TableName . "` WHERE `" . $ColumnName . "` = '" . DBConnection::escapeString($editString) . "' AND Delete_flag = 0";
				if($rtn = $DB->executeQuery($sql)){
					list($count) = mysql_fetch_row($rtn);
					if ($count == 1){
						$result = 1;
					}
					elseif($count > 1){
						$result = FALSE;
					}
				}
				else{
					$result = FALSE;
				}
			}
		}

		if(FALSE === $result){
			trigger_error("データを抽出出来ませんでした。 Searching " . $TableName . " Failed. " . $ColumnName . ":" . $editString, E_USER_ERROR);
			exit;
		}

		return ($result > 0);
	}

	/**
	 * CSVエスケープ処理
	 *
	 * @param	array	$csvRow		一行分のデータ
	 * @param	string	$from		$csvRow内の文字エンコード
	 * @return	string				エスケープされたSJIS文字列CRLF改行付き
	 */
	function csvEscapeRow($csvRow, $from = 'UTF-8'){
		// ダブルクォートは二重ダブルクォートでエスケープしてやる
		foreach((array)$csvRow as $key => $value){
			$csvRow[$key] = '"' . str_replace('"', '""', $value) . '"';
		}
		$result = mb_convert_encoding(implode(',', $csvRow) . "\r\n", 'sjis-win', $from);
		return $result;
	}

	#
	# ハッシュ関数
	#
	function _encrypt_password($plain) {
		$password = '';
		for ($i=0; $i<10; $i++) {
			$password .= _randGen();
		}
		$salt = substr(md5($password), 0, 2);
		$password = md5($salt . $plain) . ':' . $salt;

		return $password;
	}

	#
	# パスワード生成
	#
	function _getRandomString($nLengthRequired = 8){
		$sCharList = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
		mt_srand();
		$sRes = "";
		for($i = 0; $i < $nLengthRequired; $i++)
			$sRes .= $sCharList{mt_rand(0, strlen($sCharList) - 1)};
		return $sRes;
	}

	#
	# パスワード生成(同時会員登録時に使用)
	#
	function _generatePwd($nLengthRequired = 8){
		$sCharList = "abcdefghkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ2345679";
		mt_srand();
		$sRes = "";
		for($i = 0; $i < $nLengthRequired; $i++)
			$sRes .= $sCharList{mt_rand(0, strlen($sCharList) - 1)};
		return $sRes;
	}

	#
	# アップロード画像名生成
	#
	function _getUploadImgName($filename) {
		$hash = time() . '-' . substr(sha1(_randGen()), 0, 8);
		$ext = pathinfo($filename, PATHINFO_EXTENSION);
		$rtn = $hash . '.' . $ext;
		return $rtn;
	}

	#
	# アップロード画像名生成(モジュール用)
	#
	function _getUploadImgNameForModule($filename,$FileExtention) {
		$hash = time() . '-' . substr(sha1(_randGen()), 0, 8);
		$ext = $FileExtention;
		$rtn = $hash . '' . $ext;
		return $rtn;
	}

	#
	# ファイルパスを返す関数
	# baseDir/
	# baseDir/temp/
	# baseDir/old/primarykey/
	# 上記のいずれかで画像が存在する場合に有効なパスを返す関数
	#
	function _getUploadImgPath($baseDir, $basePath, $filename, $primarykey = NULL) {
		if (!$baseDir || !$basePath || !$filename) {
			return '';
		}
		if (file_exists($baseDir . $filename)) {
			$rtn = $basePath . $filename;
		} else if (file_exists($baseDir . 'temp/' . $filename)) {
			$rtn = $basePath . 'temp/' . $filename;
		} else {
			$rtn = '';
		}
		return $rtn;
	}

	#
	# ファイルディレクトリを返す関数
	# baseDir/
	# baseDir/temp/
	# baseDir/old/primarykey/
	# 上記のいずれかで画像が存在する場合に有効なディレクトリを返す関数
	#
	function _getUploadImgDir($baseDir, $filename, $primarykey = NULL) {
		if (!$baseDir || !$filename) {
			return '';
		}
		if (file_exists($baseDir . $filename)) {
			$rtn = $baseDir . $filename;
		} else if (file_exists($baseDir . 'temp/' . $filename)) {
			$rtn = $baseDir . 'temp/' . $filename;
		} else {
			$rtn = '';
		}
		return $rtn;
	}

	#
	# 履歴DIRへ移動させる関数
	# 移動先DIRがなければ作成してから・・・
	# 失敗してもエラーは返さない
	#
	function _moveBaseToOldDIR($baseDir, $filename, $primarykey) {
		if (!$baseDir || !$filename || !$primarykey) {
			return TRUE;
		}
		if (!file_exists($baseDir . $filename)) {
			return TRUE;
		}
		$toDir = $baseDir . 'old/' . $primarykey . '/';
		if (!is_dir($toDir)) {
			mkdir($toDir, 0777, TRUE);
		}
		exec('mv ' . $baseDir . $filename . ' ' . $toDir . $filename);

		return TRUE;
	}

	#
	# TEMPDIRからベースへ移動させる関数
	# 移動先DIRがなければ作成してから・・・
	# 失敗してもエラーは返さない
	#
	function _moveTempToBaseDIR($baseDir, $filename) {
		if (!$baseDir || !$filename) {
			return TRUE;
		}
		if (!file_exists($baseDir . 'temp/' . $filename)) {
			return TRUE;
		}
		exec('mv ' . $baseDir . 'temp/' . $filename . ' ' . $baseDir . $filename);

		return TRUE;
	}

	#
	# 履歴DIRからTEMPDIRへ移動させる関数
	# 失敗してもエラーは返さない
	#
	function _moveOldToTempDIR($baseDir, $filename, $primarykey) {
		if (!$baseDir || !$filename || !$primarykey) {
			return TRUE;
		}
		if (!file_exists($baseDir . 'old/' . $primarykey . '/' . $filename)) {
			return TRUE;
		}
		exec('mv ' . $baseDir . 'old/' . $primarykey . '/' . $filename . ' ' . $baseDir . 'temp/' . $filename);

		return TRUE;
	}

	#
	# 履歴DIRからTEMPDIRへコピーする関数
	# 失敗してもエラーは返さない
	#
	function _copyOldToTempDIR($baseDir, $filename, $primarykey) {
		if (!$baseDir || !$filename || !$primarykey) {
			return TRUE;
		}
		if (!file_exists($baseDir . 'old/' . $primarykey . '/' . $filename)) {
			return TRUE;
		}
		exec('cp ' . $baseDir . 'old/' . $primarykey . '/' . $filename . ' ' . $baseDir . 'temp/' . $filename);

		return TRUE;
	}

	#
	# バナーログを更新する際にアクセスログを記録する為の関数
	#
	function _BannerLogAccessLog($Type) {
		if (!$Type) {
			$GLOBALS['ExecuteError'][] = "形式が指定されていません。";
			return FALSE;
		}

		$LogDIRName = _BANNER_LOG_DIR . date('Ymd') . '/';
		if (!is_dir($LogDIRName)) {
			mkdir($LogDIRName, 0777, TRUE);
		}

		$LogFilePath = $LogDIRName . $Type . '_Access.log';
		if (!file_exists($LogFilePath)) {
			exec("touch " . $LogFilePath);
			chmod($LogFilePath, 0777);
		}

		# Accessログに記録する文字列を生成
		$LogStr .= $_SERVER['REMOTE_ADDR'] . " [" . date('Y-m-d H:i:s') . "] \"" . $_SERVER['REQUEST_METHOD'] . " " . $_SERVER['SCRIPT_NAME'];
		if ($_SERVER['QUERY_STRING']) {
			$LogStr .= "?" . $_SERVER['QUERY_STRING'];
		}
		$LogStr .= " " . $_SERVER['SERVER_PROTOCOL'] . "\" " . $_SERVER['REDIRECT_STATUS'];
		$LogStr .= " - \"" . $_SERVER['HTTP_REFERER'] . "\" \"" . $_SERVER['HTTP_USER_AGENT'] . "\"\r\n";

		# 追記だけなのでロックなどは不要
		if (!ASTools::appendFile($LogFilePath, $LogStr)) {
			$GLOBALS['ExecuteError'][] = "ファイルの書込みに失敗しました";
			return FALSE;
		}

		return TRUE;
	}


	#
	# バナーログを更新する関数
	#
	function _coutUpBannerLog($Type, $BannerID) {
		if (!$Type) {
			$GLOBALS['ExecuteError'][] = "形式が指定されていません。";
			return FALSE;
		}
		if (!$BannerID) {
			$GLOBALS['ExecuteError'][] = "バナーIDが指定されていません。";
			return FALSE;
		}

		$LogDIRName = _BANNER_LOG_DIR . date('Ymd') . '/';
		if (!is_dir($LogDIRName)) {
			mkdir($LogDIRName, 0777, TRUE);
		}

		$LogFilePath = $LogDIRName . $Type . '_' . $BannerID . '.log';
		if (!file_exists($LogFilePath)) {
			exec("touch " . $LogFilePath);
			chmod($LogFilePath, 0777);
		}

		# ロック用ファイル
		if ($Type == 'Impression') {
			$LockFile = _BANNER_IMP_LOCKFILE;
		} else {
			$LockFile = _BANNER_CLICK_LOCKFILE;
		}

		$lock_fp = fopen($LockFile, 'w');
		if (!flock($lock_fp, LOCK_EX)) {
			$GLOBALS['ExecuteError'][] = "ファイルのロックに失敗しました";
			return FALSE;
		}

		$count = file_get_contents($LogFilePath);
		$count++;

		$fp = fopen($LogFilePath, 'w');
		if (fputs($fp,  $count) === FALSE){
			$GLOBALS['ExecuteError'][] = "ファイルの書込みに失敗しました";
			return FALSE;
		}
		fclose($fp);

		flock($lock_fp, LOCK_UN);
		fclose($lock_fp);

		return TRUE;
	}

	#
	# ｒパラメータorコラボアクセス数を更新する関数
	#
	function _coutUpAccessLog($Type, $editID) {
		if (!$Type) {
			$GLOBALS['ExecuteError'][] = "形式が指定されていません。";
			return FALSE;
		}
		if (!$editID) {
			$GLOBALS['ExecuteError'][] = "対象IDが指定されていません。";
			return FALSE;
		}

		if ($Type == 'r_param') {
			$LogDIRName = _RPARAM_LOG_DIR . date('Ymd') . '/';
		} else {
			$LogDIRName = _COLLABO_LOG_DIR . date('Ymd') . '/';
		}

		if (!is_dir($LogDIRName)) {
			mkdir($LogDIRName, 0777, TRUE);
		}

		$LogFilePath = $LogDIRName . $Type . '_' . $editID . '.log';
		if (!file_exists($LogFilePath)) {
			exec("touch " . $LogFilePath);
			chmod($LogFilePath, 0777);
		}

		# ロック用ファイル
		if ($Type == 'r_param') {
			$LockFile = _RPARAM_LOCKFILE;
		} else {
			$LockFile = _COLLABO_LOCKFILE;
		}

		$lock_fp = fopen($LockFile, 'w');
		if (!flock($lock_fp, LOCK_EX)) {
			$GLOBALS['ExecuteError'][] = "ファイルのロックに失敗しました";
			return FALSE;
		}

		$count = file_get_contents($LogFilePath);
		$count++;

		$fp = fopen($LogFilePath, 'w');
		if (fputs($fp,  $count) === FALSE){
			$GLOBALS['ExecuteError'][] = "ファイルの書込みに失敗しました";
			return FALSE;
		}
		fclose($fp);

		flock($lock_fp, LOCK_UN);
		fclose($lock_fp);

		return TRUE;
	}

	#
	# 該当日付のバナーインプレッション数を返す関数
	#
	function _getImpressionCnt($BannerID, $TargetDate) {
		$ImpLogFile = _BANNER_LOG_DIR . $TargetDate . '/Impression_' . $BannerID . '.log';

		if (!file_exists($ImpLogFile)) {
			return 0;
		}
		$rtn = file_get_contents($ImpLogFile);

		return $rtn;
	}

	#
	# 該当日付のバナークリック数を返す関数
	#
	function _getClickCnt($BannerID, $TargetDate) {
		$ClickLogFile = _BANNER_LOG_DIR . $TargetDate . '/Click_' . $BannerID . '.log';

		if (!file_exists($ClickLogFile)) {
			return 0;
		}
		$rtn = file_get_contents($ClickLogFile);

		return $rtn;
	}

	#
	# 該当日付のｒパラメータorコラボアクセス数を返す関数
	#
	function _getAccessCnt($Type, $TargetID, $TargetDate) {
		if ($Type == 'r_param') {
			$AccessLogFile = _RPARAM_LOG_DIR . $TargetDate . '/r_param_' . $TargetID . '.log';
		} else {
			$AccessLogFile = _COLLABO_LOG_DIR . $TargetDate . '/collabo_' . $TargetID . '.log';
		}

		if (!file_exists($AccessLogFile)) {
			return 0;
		}
		$rtn = file_get_contents($AccessLogFile);

		return $rtn;
	}

	#
	# ページング処理関数
	#
	function _getPageData($MaxPage, $AllPage, $myPage) {
		# 最大ページ数以下の場合
		if ($AllPage <= $MaxPage) {
			$PageListLoop = $AllPage;
			for ($i = 0; $i < $PageListLoop; $i++) {
				$PageNum[$i] = $i + 1;
				$IfMyPage[$i] = ($PageNum[$i] == $myPage) ? TRUE : FALSE;
			}
		}
		# 最大ページ数以上
		 else {
			$PageListLoop = $MaxPage;
			# 1ページ目を含む場合
			if ($myPage <= floor($MaxPage / 2)) {
				$BasePage = 1;
			}
			# 最終ページを含む場合
			else if ($myPage >= ($AllPage - floor($MaxPage / 2))) {
				$BasePage = $AllPage - $MaxPage + 1;
			}
			# 中間の場合
			else {
				$BasePage = $myPage - floor($MaxPage / 2);
			}
			for ($i = 0; $i < $PageListLoop; $i++) {
				$PageNum[$i] = $BasePage + $i;
				$IfMyPage[$i] = ($PageNum[$i] == $myPage) ? TRUE : FALSE;
			}
		}

		$rtn['PageListLoop'] = $PageListLoop;
		$rtn['PageNum'] = $PageNum;
		$rtn['IfMyPage'] = $IfMyPage;

		return $rtn;
	}

	#
	# 対象企業規模を表示用に整形して返す関数
	# カンマ区切りのEmployees_idを渡す
	#
	function _get_scale_width($Employees_id) {

		$bit = bindec('000000000') ;
		$min = $max = 0 ;

		if ($Employees_id) {
			$EmployeesIDArr = explode(',', $Employees_id);

			if (in_array(1, $EmployeesIDArr)) {
				$bit = $bit | bindec('000000001') ;
			}
			if (in_array(2, $EmployeesIDArr)) {
				$bit = $bit | bindec('000000010') ;
				$min = 11;
				$max = 50;
			}
			if (in_array(3, $EmployeesIDArr)) {
				$bit = $bit | bindec('000000100') ;
				if(empty($min)){ $min = 51; }
				$max = 100;
			}
			if (in_array(4, $EmployeesIDArr)) {
				$bit = $bit | bindec('000001000') ;
				if(empty($min)){ $min = 101; }
				$max = 250;
			}
			if (in_array(5, $EmployeesIDArr)) {
				$bit = $bit | bindec('000010000') ;
				if(empty($min)){ $min = 251; }
				$max = 500;
			}
			if (in_array(6, $EmployeesIDArr)) {
				$bit = $bit | bindec('000100000') ;
				if(empty($min)){ $min = 501; }
				$max = 750;
			}
			if (in_array(7, $EmployeesIDArr)) {
				$bit = $bit | bindec('001000000') ;
				if(empty($min)){ $min = 751; }
				$max = 1000;
			}
			if (in_array(8, $EmployeesIDArr)) {
				$bit = $bit | bindec('010000000') ;
				if(empty($min)){ $min = 1001; }
				$max = 5000;
			}
			if (in_array(9, $EmployeesIDArr)) {
				$bit = $bit | bindec('100000000') ;
			}
		}

		if($bit == 1){
			return "10名以下" ;
		}
		if($bit == 256){
			return "5000名以上" ;
		}
		if($bit == 511){
			return "全ての規模に対応" ;
		}

		if(($bit & bindec('111111111')) == 0){
			return "--" ;
		}

		//両端がない場合
		if(($bit & bindec('000000001')) == 0 && ($bit & bindec('100000000')) == 0){
			return $min . "?". $max . "名" ;
		}
		if(($bit & bindec('000000001')) != 0){
			return $max . "名以下" ;
		}
		if(($bit & bindec('100000000')) != 0){
			return $min . "名以上" ;
		}
	}

	#
	# 対象エリアを表示用に整形して返す関数
	# カンマ区切りのPrefecture_idを渡す
	#
	function _get_area_width($Prefecture_id) {

		if ($Prefecture_id) {
			$PrefectureIDArr = explode(',', $Prefecture_id);
			if (is_array($PrefectureIDArr)) {
				foreach ($PrefectureIDArr as $PID) {
					if (in_array($PID, array(1))) {
						$tmpAreaArr[] = "北海道";
						$IfHokkaido = TRUE;
					} else if (in_array($PID, array(2, 3, 4, 5, 6, 7))) {
						$tmpAreaArr[] = "東北";
						$IfTohoku = TRUE;
					} else if (in_array($PID, array(8, 9, 10))) {
						$tmpAreaArr[] = "北関東";
						$IfKitakanto = TRUE;
					} else if (in_array($PID, array(11, 12, 13, 14))) {
						$tmpAreaArr[] = "首都圏";
						$IfSyuto = TRUE;
					} else if (in_array($PID, array(15, 16, 17, 18, 19, 20))) {
						$tmpAreaArr[] = "北陸・甲信越";
						$IfHokuriku = TRUE;
					} else if (in_array($PID, array(21, 22, 23, 24))) {
						$tmpAreaArr[] = "東海";
						$IfTokai = TRUE;
					} else if (in_array($PID, array(25, 26, 27, 28, 29, 30))) {
						$tmpAreaArr[] = "近畿";
						$IfKinki = TRUE;
					} else if (in_array($PID, array(31, 32, 33, 34, 35))) {
						$tmpAreaArr[] = "中国";
						$IfChina = TRUE;
					} else if (in_array($PID, array(36, 37, 38, 39))) {
						$tmpAreaArr[] = "四国";
						$IfShikoku = TRUE;
					} else if (in_array($PID, array(40, 41, 42, 43, 44, 45, 46, 47))) {
						$tmpAreaArr[] = "九州・沖縄";
						$IfKyusyu = TRUE;
					}
				}
			}
		}

		# 全国の場合
		if ($IfHokkaido && $IfTohoku && $IfKitakanto && $IfSyuto && $IfHokuriku && $IfTokai && $IfKinki && $IfChina && $IfShikoku && $IfKyusyu) {
			return "全国";
		}

		if (is_array($tmpAreaArr) && count($tmpAreaArr) > 0) {
			$uniqueAreaArr = array_unique($tmpAreaArr);
			return implode(',', $uniqueAreaArr);
		}

		return "--";
	}

	/**
	* ファイルポインタから行を取得し、CSVフィールドを処理する
	* @param resource handle
	* @param int length
	* @param string delimiter
	* @param string enclosure
	* @return ファイルの終端に達した場合を含み、エラー時にFALSEを返します。
	*/
	function fgetcsv_reg (&$handle, $length = null, $d = ',', $e = '"') {
		$d = preg_quote($d);
		$e = preg_quote($e);
		$_line = "";
		while ($eof != true) {
			$_line .= (empty($length) ? fgets($handle) : fgets($handle, $length));
			$itemcnt = preg_match_all('/'.$e.'/', $_line, $dummy);
			if ($itemcnt % 2 == 0) $eof = true;
		}
		$_csv_line = preg_replace('/(?:\r\n|[\r\n])?$/', $d, trim($_line));
		$_csv_pattern = '/('.$e.'[^'.$e.']*(?:'.$e.$e.'[^'.$e.']*)*'.$e.'|[^'.$d.']*)'.$d.'/';
		preg_match_all($_csv_pattern, $_csv_line, $_csv_matches);
		$_csv_data = $_csv_matches[1];
		for($_csv_i=0;$_csv_i<count($_csv_data);$_csv_i++){
			$_csv_data[$_csv_i]=preg_replace('/^'.$e.'(.*)'.$e.'$/s','$1',$_csv_data[$_csv_i]);
			$_csv_data[$_csv_i]=str_replace($e.$e, $e, $_csv_data[$_csv_i]);
		}
		return empty($_line) ? false : $_csv_data;
	}

	#
	# 資料請求で使用する日付(2ヶ月前)を返す関数
	# （本日より2ヶ月前、存在しない日付なら対象月の最終日を返す)
	#
	function getOrderLimitDate($TargetDate = NULL) {
		# 候補日付を求める
		if ($TargetDate) {
			$TargetDateYear = date('Y', strtotime($TargetDate));
			$TargetDateMonth = date('n', strtotime($TargetDate));
			$TargetDateDay = date('j', strtotime($TargetDate));
		} else {
			$TargetDateYear = date('Y');
			$TargetDateMonth = date('n');
			$TargetDateDay = date('j');
		}

		$tmpYear = ($TargetDateMonth > 2) ? $TargetDateYear : $TargetDateYear - 1;
		$tmpMonth = ($TargetDateMonth > 2) ? $TargetDateMonth - 2 : $TargetDateMonth + 10;
		$tmpDay = $TargetDateDay;

		# 日付の正当性チェック
		if (checkdate($tmpMonth, $tmpDay, $tmpYear)) {
			$rtn = date('Y-m-d H:i:s', mktime(0, 0, 0, $tmpMonth, $tmpDay, $tmpYear));
		}
		# NGなら候補年月の最終日を返す
		else {
			$lastDay = date('t', mktime(0, 0, 0, $tmpMonth, 1, $tmpYear));
			$rtn = date('Y-m-d H:i:s', mktime(0, 0, 0, $tmpMonth, $lastDay, $tmpYear));
		}

		return $rtn;
	}

	#
	# 管理画面->受注管理で使用する日付(2ヶ月後)を返す関数
	# （本日より2ヶ月後、存在しない日付なら対象月の最終日を返す)
	#
	function getOrderMaxLimitDate($TargetDate = NULL) {
		# 候補日付を求める
		if ($TargetDate) {
			$TargetDateYear = date('Y', strtotime($TargetDate));
			$TargetDateMonth = date('n', strtotime($TargetDate));
			$TargetDateDay = date('j', strtotime($TargetDate));
		} else {
			$TargetDateYear = date('Y');
			$TargetDateMonth = date('n');
			$TargetDateDay = date('j');
		}

		$tmpYear = ($TargetDateMonth > 10) ? $TargetDateYear : $TargetDateYear + 1;
		$tmpMonth = ($TargetDateMonth > 10) ? $TargetDateMonth - 10 : $TargetDateMonth + 2;
		$tmpDay = $TargetDateDay;

		# 日付の正当性チェック
		if (checkdate($tmpMonth, $tmpDay, $tmpYear)) {
			$rtn = date('Y-m-d H:i:s', mktime(0, 0, 0, $tmpMonth, $tmpDay, $tmpYear));
		}
		# NGなら候補年月の最終日を返す
		else {
			$lastDay = date('t', mktime(0, 0, 0, $tmpMonth, 1, $tmpYear));
			$rtn = date('Y-m-d H:i:s', mktime(0, 0, 0, $tmpMonth, $lastDay, $tmpYear));
		}

		return $rtn;
	}

	#
	# 製品一覧ページでの静的パラメータをパースする処理
	# 取得したいパラメータを追加・変更する場合にはこちら
	#
	function getParamUrl($Param) {

		if (!$Param) {
			return array();
		}

		$ParamArr = explode('/', $Param);
		if (!(is_array($ParamArr) && count($ParamArr) > 0)) {
			return array();
		}

		# 取得したURLから必要な情報を取得
		foreach ($ParamArr as $v) {
			$tmpParam = array();
			$tmpParam = explode(':', $v);

			# 現在のページ番号の指定があれば処理しておく
			if ($tmpParam[0] == 'page' && $tmpParam[1] > 0) {
				$rtn['myPage'] = intval($tmpParam[1]);
				continue;
			}
			# 絞り込み条件の企業規模情報があれば処理しておく
			else if ($tmpParam[0] == 'employee' && $tmpParam[1] > 0) {
				$rtn['wEmployee'] = $tmpParam[1];
			}
			# 絞り込み条件の都道府県情報があれば処理しておく
			else if ($tmpParam[0] == 'prefecture' && $tmpParam[1] > 0) {
				$rtn['wPrefecture'] = $tmpParam[1];
			}
			else if ($tmpParam[0] == '' && $tmpParam[1] == '') {
			
			}
			# 必要な情報に当てはまらなければエラーとする
			else {
				$rtn['error'] = TRUE;
			}
		}

		return $rtn;
	}

	#
	# ユーザーエージェントからクローラーかどうか判別する関数
	#
	function isBot($user_agent) {
		if (!$user_agent) return false;

		if ( strpos ( $user_agent,'Googlebot' ) !== false ) {
			if ( strpos ( $user_agent,'Mobile' ) !== false ) {
				return true; //http://www.google.com/bot.html
			} else if ( strpos ( $user_agent,'Googlebot-Image' ) !== false ) {
				return true; //URL無し
			} else if ( strpos ( $user_agent,'YPBot' ) !== false ) {
				return true; //http://www.yellowpages.com/about/legal/crawl
			}
			return true; //http://www.google.com/bot.html
		} else if ( strpos ( $user_agent,'Yahoo! Slurp' ) !== false ) {
			return true; //http://help.yahoo.com/help/us/ysearch/slurp
		} else if ( strpos ( $user_agent,'bingbot' ) !== false ) {
			return true; //http://www.bing.com/bingbot.htm
		} else if ( strpos ( $user_agent,'Yeti' ) !== false ) {
			return true; //http://help.naver.com/robots/
		} else if ( strpos ( $user_agent,'Baiduspider+' ) !== false ) {
			return true; //http://www.baidu.com/search/spider.htm
		} else if ( strpos ( $user_agent,'Baiduspider' ) !== false ) {
			return true; //http://www.baidu.com/search/spider.html
		} else if ( strpos ( $user_agent,'Steeler' ) !== false ) {
			return true; //http://www.tkl.iis.u-tokyo.ac.jp/~crawler/
		} else if ( strpos ( $user_agent,'ichiro/mobile goo' ) !== false ) {
			return true; //http://help.goo.ne.jp/help/article/1142/
		} else if ( strpos ( $user_agent,'ichiro' ) !== false ) {
			return true; //http://help.goo.ne.jp/door/crawler.html
		} else if ( strpos ( $user_agent,'hotpage.fr' ) !== false ) {
			return true; //http://www.hotpage.fr
		} else if ( strpos ( $user_agent,'Feedfetcher-Google' ) !== false ) {
			return true; //http://www.google.com/feedfetcher.html
		} else if ( strpos ( $user_agent,'livedoor FeedFetcher' ) !== false ) {
			return true; //http://reader.livedoor.com/
		} else if ( strpos ( $user_agent,'ia_archiver' ) !== false ) {
			return true; //http://www.alexa.com/site/help/webmasters
		} else if ( strpos ( $user_agent,'YandexBot' ) !== false ) {
			return true; //http://yandex.com/bots
		} else if ( strpos ( $user_agent,'SISTRIX Crawler' ) !== false ) {
			return true; //http://crawler.sistrix.net/
		} else if ( strpos ( $user_agent,'msnbot-media' ) !== false ) {
			return true; //http://search.msn.com/msnbot.htm
		} else if ( strpos ( $user_agent,'zenback bot' ) !== false ) {
			return true; //http://www.logly.co.jp/
		} else if ( strpos ( $user_agent,'Y!J-BRI' ) !== false ) {
			return true; //http://help.yahoo.co.jp/help/jp/search/indexing/indexing-15.html
		} else if ( strpos ( $user_agent,'TurnitinBot' ) !== false ) {
			return true; //http://www.turnitin.com/robot/crawlerinfo.html
		} else if ( strpos ( $user_agent,'Google Desktop' ) !== false ) {
			return true; //http://desktop.google.com/
		} else if ( strpos ( $user_agent,'newzia crawler' ) !== false ) {
			return true; //http://www.logly.co.jp/
		} else if ( strpos ( $user_agent,'BaiduMobaider' ) !== false ) {
			return true; //http://www.baidu.jp/spider/
		} else if ( strpos ( $user_agent,'Y!J-BRJ/YATS crawler' ) !== false ) {
			return true; //http://listing.yahoo.co.jp/support/faq/int/other/other_001.html
		} else if ( strpos ( $user_agent,'Seznam screenshot-generator' ) !== false ) {
			return true; //http://fulltext.sblog.cz/screenshot/
		} else if ( strpos ( $user_agent,'SiteBot' ) !== false ) {
			return true; //http://www.sitebot.org/robot/
		} else if ( strpos ( $user_agent,'Purebot' ) !== false ) {
			return true; //http://www.puritysearch.net/
		} else if ( strpos ( $user_agent,'emBot-GalaBuzz/Nutch' ) !== false ) {
			return true; //http://emining.jp/
		} else if ( strpos ( $user_agent,'Search17Bot' ) !== false ) {
			return true; //http://www.search17.com/bot.php
		} else if ( strpos ( $user_agent,'Toread-Crawler' ) !== false ) {
			return true; //http://news.toread.cc/crawler.php
		} else if ( strpos ( $user_agent,'Tumblr' ) !== false ) {
			return true; //http://www.tumblr.com/
		} else if ( strpos ( $user_agent,'DotBot' ) !== false ) {
			return true; //http://www.dotnetdotcom.org/
		} else if ( strpos ( $user_agent,'Chilkat' ) !== false ) {
			return true; //http://www.chilkatsoft.com/ChilkatHttpUA.asp
		} else if ( strpos ( $user_agent, 'ezooms.bot') !== false) {
			return true; //http://reverse.wowrack.com
		} else if ( strpos ( $user_agent, 'MJ12bot') !== false) {
			return true; //http://www.majestic12.co.uk
		} else if ( strpos ( $user_agent, 'AhrefsBot') !== false) {
			return true; //http://ahrefs.com
		} else if ( strpos ( $user_agent, 'Exabot') !== false) {
			return true; //http://www.exabot.com
		} else if ( strpos ( $user_agent, 'AdsBot') !== false) {
			return true; //http://www.google.com/adsbot.html
		} else if ( strpos ( $user_agent, 'BuiBui-CheckBot') !== false) {
			return true; //buibui[at]dadapro[dot]com
		} else if ( strpos ( $user_agent, 'alexa.com') !== false) {
			return true; //http://www.alexa.com/
		} else if ( strpos ( $user_agent, 'ask.com') !== false) {
			return true; //http://www.ask.com/
		} else if ( strpos ( $user_agent, 'commoncrawl') !== false) {
			return true; //http://www.commoncrawl.org/
		} else if ( strpos ( $user_agent, 'covario') !== false) {
			return true; //http://www.covario.com/ids
		} else if ( strpos ( $user_agent, 'discobot') !== false) {
			return true; //http://discoveryengine.com/
		} else if ( strpos ( $user_agent, 'facebookexternalhit') !== false) {
			return true; //http://www.facebook.com/externalhit_uatext.php
		} else if ( strpos ( $user_agent, 'FairShare') !== false) {
			return true; //http://www.fairshare.cc/
		} else if ( strpos ( $user_agent, 'FlightDeckReports') !== false) {
			return true; //http://www.flightdeckreports.com/
		} else if ( strpos ( $user_agent, 'Gigabot') !== false) {
			return true; //http://www.gigablast.com/
		} else if ( strpos ( $user_agent, 'HuaweiSymantecSpider') !== false) {
			return true; //http://www.huaweisymantec.com/en/IRL/spider/
		} else if ( strpos ( $user_agent, 'inagist.com') !== false) {
			return true; //http://inagist.com/
		} else if ( strpos ( $user_agent, 'Jaxified') !== false) {
			return true; //http://www.jaxified.com/
		} else if ( strpos ( $user_agent, 'LinkedInBot') !== false) {
			return true; //http://www.linkedin.com/
		} else if ( strpos ( $user_agent, 'MLBot') !== false) {
			return true; //http://www.metadatalabs.com/
		} else if ( strpos ( $user_agent, 'Moreoverbot') !== false) {
			return true; //http://w.moreover.com/
		} else if ( strpos ( $user_agent, 'OneRiot') !== false) {
			return true; //http://www.oneriot.com/
		} else if ( strpos ( $user_agent, 'puritysearch.net') !== false) {
			return true; //http://www.puritysearch.net/
		} else if ( strpos ( $user_agent, 'robotgenius') !== false) {
			return true; //http://www.robotgenius.net/
		} else if ( strpos ( $user_agent, 'scoutjet.com') !== false) {
			return true; //http://www.scoutjet.com/
		} else if ( strpos ( $user_agent, 'SBIder') !== false) {
			return true; //http://www.sitesell.com/
		} else if ( strpos ( $user_agent, 'ellerdale.com') !== false) {
			return true; //http://www.ellerdale.com/
		} else if ( strpos ( $user_agent, 'tineye.com') !== false) {
			return true; //http://www.tineye.com/
		} else if ( strpos ( $user_agent, 'topsy.com') !== false) {
			return true; //http://www.topsy.com/
		} else if ( strpos ( $user_agent, 'TurnitinBot') !== false) {
			return true; //http://turnitin.com/
		} else if ( strpos ( $user_agent, 'videosurf.com') !== false) {
			return true; //http://www.videosurf.com/
		} else if ( strpos ( $user_agent, 'woriobot') !== false) {
			return true; //http://worio.com/
		}
		# 数が多すぎるので以下条件も追加
		 else if ( strpos ( $user_agent, 'bot') !== false) {
			return true;
		} else if ( strpos ( $user_agent, 'Bot') !== false) {
			return true;
		} else if ( strpos ( $user_agent, 'robo') !== false) {
			return true;
		} else if ( strpos ( $user_agent, 'Robo') !== false) {
			return true;
		}

		return false;
	}

	#
	# フリーワード検索時にキーワードを幾つか変換して配列で返す関数
	#
	function getSearchKeywords($Keyword) {
		$resArr[] = $Keyword;// そのまま
		$resArr[] = strtolower(mb_convert_kana($Keyword, 'a'));// 半角小文字
		$resArr[] = strtoupper(mb_convert_kana($Keyword, 'a'));// 半角大文字
		$resArr[] = strtolower(mb_convert_kana($Keyword, 'A'));// 全角小文字
		$resArr[] = strtoupper(mb_convert_kana($Keyword, 'A'));// 全角大文字
		$resArr[] = strtoupper(mb_convert_kana($Keyword, 'k'));// 半角カナ
		$resArr[] = strtoupper(mb_convert_kana($Keyword, 'K'));// 全角カナ
		return array_unique($resArr);
	}

	#
	# サジェストワード登録時に検索ワードを大文字→小文字、全角→半角変換処理を行うための関数
	#
	function getSearchwordForSuggest($Keyword) {
		$Keyword = strtolower(mb_convert_kana($Keyword, 'ak'));// 半角英数小文字,半角カナ,
		return $Keyword;
	}


	#
	# json_encode()関数が存在しないなら
	#
	if (!function_exists('json_encode')) {
		// JSON.phpを読み込んで
		require_once 'JSON.php';
		// json_encode()関数を定義する
		function json_encode($value) {
			$s = new Services_JSON();
			return $s->encodeUnsafe($value);
		}
		// json_decode()関数を定義する
		function json_decode($json, $assoc = false) {
			$s = new Services_JSON($assoc ? SERVICES_JSON_LOOSE_TYPE : 0);
			return $s->decode($json);
		}
	}
	
