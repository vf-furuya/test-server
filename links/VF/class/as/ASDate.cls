<?php
/**
 * ASDateクラス
 *
 * 日付関係のツール群です。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2003/12/03
 * @version 0.1
 **/

define('_SUNDAY', 0);
define('_MONDAY', 1);
define('_TUESDAY', 2);
define('_WEDNESDAY', 3);
define('_THURSDAY', 4);
define('_FRIDAY', 5);
define('_SATURDAY', 6.);

class ASDate {

	/**
	 * 日時を分解します。
	 * getStrippedTimestampメソッドなどで記号等が完全に取り除かれた状態が前提となります。
	 * $timestampを要素分解して、Year、Month、Day、Hour、Minute、Secondというindexを持った連想配列を返します。
	 * 
	 * @access		public
	 * @param		String		$timestamp		処理対象日付
	 * @return		Array		加工結果の配列
	 */
	function getPiecesOfTimestamp($timestamp){
		$timestamp = ASDate::getStrippedTimestamp($timestamp);
		
		$TempTimestampArray = explode(',', $timestamp);
		
		

		// 整形して各値をセット
		$Year = $TempTimestampArray[0];
		$Month = $TempTimestampArray[1];
		$Day = $TempTimestampArray[2];
		$Hour = $TempTimestampArray[3];
		$Minute = $TempTimestampArray[4];
		$Second = $TempTimestampArray[5];
		/*
		$Year = substr($timestamp,0,4);
		$Month = substr($timestamp,4,2);
		$Day = substr($timestamp,6,2);
		$Hour = substr($timestamp,9,2);
		$Minute = substr($timestamp,11,2);
		$Second = substr($timestamp,13,2);
		*/

		// 配列に格納して返す
		$myTimestamp['Year'] = $Year;
		$myTimestamp['Month'] = $Month;
		$myTimestamp['Day'] = $Day;
		$myTimestamp['Hour'] = $Hour;
		$myTimestamp['Minute'] = $Minute;
		$myTimestamp['Second'] = $Second;

		return $myTimestamp;
	}

	/**
	 * ハイフンやスラッシュが入った日時からそれら記号を取り除きます
	 * $timestampから「-」「/」「:」「.」「年」「月」「日」「時」「分」を取り除きます。
	 *
	 * @access		public
	 * @param		String		$timestamp	加工対象日時
	 * @return		String		加工結果
	 */
	function getStrippedTimestamp($timestamp){
		$timestamp = str_replace("-", ",", $timestamp);
		$timestamp = str_replace("/", ",", $timestamp);
		$timestamp = str_replace(":", ",", $timestamp);
		$timestamp = str_replace(".", ",", $timestamp);
		$timestamp = str_replace("年", ",", $timestamp);
		$timestamp = str_replace("月", ",", $timestamp);
		$timestamp = str_replace("日", ",", $timestamp);
		$timestamp = str_replace("時", ",", $timestamp);
		$timestamp = str_replace("分", ",", $timestamp);
		$timestamp = str_replace(" ", ",", $timestamp);
		$timestamp = str_replace("　", ",", $timestamp);

		return $timestamp;
	}

	/**
	 * 指定日数日付を足して結果を返します。
	 * 日付$dateに$days日加算した日付を返します。$dateは標準的(「-」「/」「:」「.」「年」「月」「日」「時」「分」のいずれか複数を使った日付表記)な表記であれば対応可能です。
	 * 時刻まで入った形式の$dateも扱えますが、返り値は年月日のみになります。
	 * 
	 * @access		public
	 * @param		String		$date		基準となる日付
	 * @param		Integer		$days		ログ出力メッセージ
	 * @return		String		日付加算結果
	 */
	function getDatePlus($date, $days){
		$date = ASDate::getStrippedTimestamp($date);
		$myTimestamp = ASDate::getPiecesOfTimestamp($date);

		$returnDate = date("Ymd", mktime(0, 0, 0, $myTimestamp['Month'], $myTimestamp['Day'] + $days, $myTimestamp['Year']));

		return $returnDate;
	}

	/**
	 * 指定月数月を足して結果を返します。
	 * 日付$dateに$monthsヶ月加算した日付を返します。$dateは標準的(「-」「/」「:」「.」「年」「月」「日」「時」「分」のいずれか複数を使った日付表記)な表記であれば対応可能です。
	 * 時刻まで入った形式の$dateも扱えますが、返り値は年月日のみになります。
	 *
	 * @access		public
	 * @param		String		$date		基準となる日付
	 * @param		Integer		$months		ログ出力メッセージ
	 * @return		String		日付加算結果
	 */
	function getMonthPlus($date, $months){
		$date = ASDate::getStrippedTimestamp($date);

		$date = ASDate::getFirstOfThisMonth($date);

		$myTimestamp = ASDate::getPiecesOfTimestamp($date);

		$returnDate = date("Ymd", mktime(0, 0, 0, $myTimestamp['Month'] + $months, $myTimestamp['Day'], $myTimestamp['Year']));

		return $returnDate;
	}

	/**
	 * 8桁数値形式の日付を、表示用の数値形式に直して返します。
	 * 通常日付チェックそのものは行われているはずとして、ここでは一切エラーチェックしません。
	 *
	 * @access		public
	 * @param		String		$timestamp	加工対象数値
	 * @param		String		$type		表示方法(1(-):YYYY-MM-DD hh:mm:ss  2(/):YYYY/MM/DD hh:mm:ss 3(/):YYYY-MM-DDThh:mm:ss+09:00 それ以外:YYYY年MM月DD日 hh時mm分ss秒)
	 * @param		Boolean		$needTime	時間の部分が必要かどうか
	 * @param		String		$custom		完全なフォーマット指定(例: M-D-Y h:m.s)
	 * @return		String		加工結果
	 */
	function getFormattedTimestamp($date, $type = "", $needTime = false, $custom = ""){
		$date = ASDate::getStrippedTimestamp($date);
		$myTimestamp = ASDate::getPiecesOfTimestamp($date);

		if ($custom == ""){
			// まず日付を整形
			if ($type == 1 || $type == "-")
				$formatted = $myTimestamp['Year'] . "-" . $myTimestamp['Month'] . "-" . $myTimestamp['Day'];
			else if ($type == 2 || $type == "/")
				$formatted = $myTimestamp['Year'] . "/" . $myTimestamp['Month'] . "/" . $myTimestamp['Day'];
			else if ($type == 3 || $type == "rdf")
				$formatted = $myTimestamp['Year'] . "-" . $myTimestamp['Month'] . "-" . $myTimestamp['Day'];
			else
				$formatted = $myTimestamp['Year'] . "年" . $myTimestamp['Month'] . "月" . $myTimestamp['Day'] . "日";

			// needTimeがTRUEで、かつ時刻要素があれば時刻も処理する
			if ($needTime && $myTimestamp['Hour'] != "" && $myTimestamp['Minute'] != "" && $myTimestamp['Second'] != ""){
				if ($type == 1 || $type == "-")
					$formatted .= " " . $myTimestamp['Hour'] . ":" . $myTimestamp['Minute'] . ":" . $myTimestamp['Second'];
				else if ($type == 2 || $type == "/")
					$formatted .= " " . $myTimestamp['Hour'] . ":" . $myTimestamp['Minute'] . ":" . $myTimestamp['Second'];
				else if ($type == 3 || $type == "rdf")
					$formatted .= "T" . $myTimestamp['Hour'] . ":" . $myTimestamp['Minute'] . ":" . $myTimestamp['Second'] . "+09:00";
				else
					$formatted .= " " . $myTimestamp['Hour'] . "時" . $myTimestamp['Minute'] . "分" . $myTimestamp['Second'] . "秒";
			}
		}
		else{
			$formatted = $custom;

			$formatted = str_replace("Y", $myTimestamp['Year'], $formatted);
			$formatted = str_replace("M", $myTimestamp['Month'], $formatted);
			$formatted = str_replace("D", $myTimestamp['Day'], $formatted);
			$formatted = str_replace("h", $myTimestamp['Hour'], $formatted);
			$formatted = str_replace("m", $myTimestamp['Minute'], $formatted);
			$formatted = str_replace("s", $myTimestamp['Second'], $formatted);
		}

		return $formatted;
	}

	/**
	 * 要素に分かれた日付を整形します。
	 * 通常日付チェックそのものは行われているはずとして、ここでは一切エラーチェックしません。
	 *
	 * @access		public
	 * @param		Interger	$Year		年
	 * @param		Interger	$Month		月
	 * @param		Interger	$Day		日
	 * @param		Interger	$Hour		時
	 * @param		Interger	$Minute		分
	 * @param		Interger	$Second		秒
	 * @param		String		$Separator	区切り
	 * @return		String		加工結果
	 */
	function formatDatetime($Year, $Month, $Day, $Hour = NULL, $Minute = NULL, $Second = NULL, $Separator = '-') {
		$Value = sprintf("%04d" . $Separator . "%02d" . $Separator . "%02d", $Year, $Month, $Day);
		if ($Hour !== NULL && $Minute !== NULL)
			$Value .= sprintf(" %02d:%02d", $Hour, $Minute);
		if ($Second !== NULL)
			$Value .= sprintf(":%02d", $Second);

		return $Value;
	}

	/**
	 * 与えられた日付から、曜日を求めて指定の形式で返します。
	 * 表示方法は適当に足してください。
	 *
	 * @access		public
	 * @param		String		$timestamp	加工対象日時
	 * @param		String		$type		表示方法(1:月曜日  2:月  3:Monday)
	 * @return		String		加工結果
	 */
	function getDayOfWeek($date, $type = 1){
		$date = ASDate::getStrippedTimestamp($date);
		$myTimestamp = ASDate::getPiecesOfTimestamp($date);

		$DAY_OF_WEEK[0] = array('0', '日曜日', '日', 'Sunday');
		$DAY_OF_WEEK[1] = array('1', '月曜日', '月', 'Monday');
		$DAY_OF_WEEK[2] = array('2', '火曜日', '火', 'Tuesday');
		$DAY_OF_WEEK[3] = array('3', '水曜日', '水', 'Wednesday');
		$DAY_OF_WEEK[4] = array('4', '木曜日', '木', 'Thursday');
		$DAY_OF_WEEK[5] = array('5', '金曜日', '金', 'Friday');
		$DAY_OF_WEEK[6] = array('6', '土曜日', '土', 'Saturday');

		$number = date("w", mktime(0, 0, 0, $myTimestamp['Month'], $myTimestamp['Day'], $myTimestamp['Year']));

		return $DAY_OF_WEEK[$number][$type];
	}

	/**
	 * 与えられたふたつの日付から、その日数を求めます。
	 * $timestamp2から$timestamp1を引いて、日数を数値を返します。
	 * $timestamp1及び$timestamp2は標準的(「-」「/」「:」「.」「年」「月」「日」「時」「分」のいずれか複数を使った日付表記)な表記であれば対応可能です。
	 *
	 * @access		public
	 * @param		String		$timestamp1	計算対象開始日時
	 * @param		String		$timestamp2	計算対象終了日時
	 * @return		integer		計算結果
	 */
	function getDayCountOfTerm($timestamp1, $timestamp2){
		// 形式を整えて配列へ
		$timestamp1 = ASDate::getStrippedTimestamp($timestamp1);
		$timestamp2 = ASDate::getStrippedTimestamp($timestamp2);
		$myTimestamp1 = ASDate::getPiecesOfTimestamp($timestamp1);
		$myTimestamp2 = ASDate::getPiecesOfTimestamp($timestamp2);

		// 両日付のタイムスタンプを得る
		$unixTimestamp1 = mktime(0, 0, 0, $myTimestamp1['Month'], $myTimestamp1['Day'] + $days, $myTimestamp1['Year']);
		$unixTimestamp2 = mktime(0, 0, 0, $myTimestamp2['Month'], $myTimestamp2['Day'] + $days, $myTimestamp2['Year']);

		// 差を求めて1日の秒数で割る
		$days = ($unixTimestamp2 - $unixTimestamp1) / (24 * 60 * 60);

		return $days;
	}

	/**
	 * 与えられた日付の月の最初の日を求めます
	 * $timestamp1は標準的(「-」「/」「:」「.」「年」「月」「日」「時」「分」のいずれか複数を使った日付表記)な表記であれば対応可能です。
	 *
	 * @access		public
	 * @param		String		$timestamp1	計算対象開始日時
	 * @return		String		加工結果
	 */
	function getFirstOfThisMonth($timestamp1){
		// 形式を整えて配列へ
		$timestamp1 = ASDate::getStrippedTimestamp($timestamp1);
		$myTimestamp1 = ASDate::getPiecesOfTimestamp($timestamp1);

		// 初日を得る
		$returnDate = date("Ymd", mktime(0, 0, 0, $myTimestamp1['Month'], 1, $myTimestamp1['Year']));

		return $returnDate;
	}

	/**
	 * 与えられた日付の月の最後の日を求めます
	 * $timestamp1は標準的(「-」「/」「:」「.」「年」「月」「日」「時」「分」のいずれか複数を使った日付表記)な表記であれば対応可能です。
	 *
	 * @access		public
	 * @param		String		$timestamp1	計算対象開始日時
	 * @return		String		加工結果
	 */
	function getEndOfThisMonth($timestamp1){
		// 形式を整えて配列へ
		$timestamp1 = ASDate::getStrippedTimestamp($timestamp1);
		$myTimestamp1 = ASDate::getPiecesOfTimestamp($timestamp1);

		// 初日を得る
		$returnDate = date("Ymd", mktime(0, 0, 0, $myTimestamp1['Month'] + 1, 0, $myTimestamp1['Year']));

		return $returnDate;
	}

	/**
	 * 与えられた日付から、指定された曜日の日付を求めます。
	 *
	 * @access		public
	 * @param		String		$timestamp	加工対象日時
	 * @param		String		$dayofweek	表示方法(0～7)
	 * @return		String		加工結果
	 */
	function getDateOfDay($date, $dayofweek = 0, $lastweekFlg = FALSE){
		$date = ASDate::getStrippedTimestamp($date);
		$myTimestamp = ASDate::getPiecesOfTimestamp($date);

		$dayofdate = ASDate::getDayOfWeek($date, 0);

		if ($dayofdate == _SATURDAY)
			$result = $date;
		else {
			$distance = $dayofweek - $dayofdate;

			if ($lastweekFlg && $dayofdate < $dayofweek)
				$dayofdate = $distance - 7;
			else
				$dayofdate = $distance;

			$result = date("Ymd", mktime(0, 0, 0, $myTimestamp['Month'], $myTimestamp['Day'] + $dayofdate, $myTimestamp['Year']));
		}

		return $result;
	}

	/**
	 * 与えられた日付から、指定された曜日で始まる1週間の情報をオブジェクトとして返す。
	 *
	 * @access		public
	 * @param		String		$timestamp		加工対象日時
	 * @param		String		$dayofweek		開始曜日(0～7)
	 * @param		String		$lastweekFlg	始まり曜日が先週なのか次週なのか(先週ならTRUE)
	 * @param		String		$days			オブジェクトに投入する日数(デフォルト7＝1週間)
	 * @return		String		加工結果
	 */
	function getWeekObject($date, $dayofweek = 0, $lastweekFlg = FALSE, $days = 7){
		$start = ASDate::getDateOfDay($date, $dayofweek, $lastweekFlg);

		$myTimestamp = ASDate::getPiecesOfTimestamp($start);

		$DAY_OF_WEEK[0] = array('0', '日曜日', '日', 'Sunday');
		$DAY_OF_WEEK[1] = array('1', '月曜日', '月', 'Monday');
		$DAY_OF_WEEK[2] = array('2', '火曜日', '火', 'Tuesday');
		$DAY_OF_WEEK[3] = array('3', '水曜日', '水', 'Wednesday');
		$DAY_OF_WEEK[4] = array('4', '木曜日', '木', 'Thursday');
		$DAY_OF_WEEK[5] = array('5', '金曜日', '金', 'Friday');
		$DAY_OF_WEEK[6] = array('6', '土曜日', '土', 'Saturday');
		$COLOR_OF_DAY[0] = 'ff0000';
		$COLOR_OF_DAY[1] = '000000';
		$COLOR_OF_DAY[2] = '000000';
		$COLOR_OF_DAY[3] = '000000';
		$COLOR_OF_DAY[4] = '000000';
		$COLOR_OF_DAY[5] = '000000';
		$COLOR_OF_DAY[6] = '0000ff';

		for ($i = 0; $i < $days; $i++){
			$obj['Year'][$i] = $number = date("Y", mktime(0, 0, 0, $myTimestamp['Month'], $myTimestamp['Day'] + $i, $myTimestamp['Year']));
			$obj['Month'][$i] = $number = date("m", mktime(0, 0, 0, $myTimestamp['Month'], $myTimestamp['Day'] + $i, $myTimestamp['Year']));
			$obj['Day'][$i] = $number = date("d", mktime(0, 0, 0, $myTimestamp['Month'], $myTimestamp['Day'] + $i, $myTimestamp['Year']));
			$obj['DayNumber'][$i] = date("w", mktime(0, 0, 0, $myTimestamp['Month'], $myTimestamp['Day'] + $i, $myTimestamp['Year']));
			$obj['DayName'][$i] = $DAY_OF_WEEK[$obj['DayNumber'][$i]][2];
			$obj['DayColor'][$i] = $COLOR_OF_DAY[$obj['DayNumber'][$i]];
		}

		return $obj;
	}

	/**
	 * 与えられた日付から、Xヵ月後のTIMESTMAPオブジェクト(初日)を返します。
	 *
	 * @access		public
	 * @param		String		$date		加工対象日時
	 * @param		String		$distance	加算月数
	 * @return		String		加工結果
	 */
	function getForwardMonth($date, $distance = 1){
		$myTimestamp = ASDate::getPiecesOfTimestamp($date);

		$obj['Year'] = $number = date("Y", mktime(0, 0, 0, $myTimestamp['Month'] + $distance, 1, $myTimestamp['Year']));
		$obj['Month'] = $number = date("m", mktime(0, 0, 0, $myTimestamp['Month'] + $distance, 1, $myTimestamp['Year']));
		$obj['Day'] = $number = date("d", mktime(0, 0, 0, $myTimestamp['Month'] + $distance, 1, $myTimestamp['Year']));

		return $obj;
	}

	/**
	 * 与えられた要素から日付文字列を作成して返します。
	 *
	 * @access		public
	 * @param		String		$Year	年
	 * @param		String		$Month	月
	 * @param		String		$Day	日
	 * @return		String		加工結果
	 */
	function getDateFromElements($Year, $Month, $Day){
		if ($Year != NULL && $Month != NULL && $Day != NULL)
			$Value = $Year . '/' . sprintf('%02d', $Month) . '/' . sprintf('%02d', $Day);

		return $Value;
	}

	/**
	 * 与えられた日付から現在の年齢を算出します。
	 * $timestamp1は標準的(「-」「/」「:」「.」「年」「月」「日」「時」「分」のいずれか複数を使った日付表記)な表記であれば対応可能です。
	 *
	 * @access		public
	 * @param		String		$timestamp1	計算対象開始日時
	 * @return		String		加工結果
	 */
	function getAge($timestamp1){
		// 形式を整えて配列へ
		$timestamp1 = ASDate::getStrippedTimestamp($timestamp1);
		$myTimestamp1 = ASDate::getPiecesOfTimestamp($timestamp1);

		$Age = date('Y') - $myTimestamp1['Year'];

		if ($myTimestamp1['Month'] * 100 + $myTimestamp1['Day'] > date('m') * 100 + date('d'))
			$Age--;

		return $Age;
	}
}
?>
