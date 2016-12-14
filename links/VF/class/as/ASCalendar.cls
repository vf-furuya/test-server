<?php
/**
 * ASCalendarクラス
 *
 * カレンダ関係のツール群です。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2003/12/03
 * @version 0.1
 **/

include_once _AS_CLS_DIR . "ASDate.cls";

class ASCalendar extends ASDate {
	/**
	 * ASDateによって生成される日時オブジェクト(配列)
	 */
	var $Timestamp;
	/**
	 * カレンダーの行数
	 */
	var $Rows;
	/**
	 * 各行の列数(7で固定)の配列
	 */
	var $Cols;
	/**
	 * 強調表示すべき日ならTRUEな値の配列
	 */
	var $IfToday;
	/**
	 * 日の値を収めた2重配列
	 */
	var $Days;
	/**
	 * 月の値
	 */
	var $Month;

	/**
	 * 最近数ヶ月の配列(YYYYMM)
	 */
	var $TheseMonths;
	/**
	 * 最近数ヶ月の表示用配列(YYYY-MM)
	 */
	var $TheseMonthsName;

	function ASCalendar ($fixedDate = NULL) {
		$fixedDate = ($fixedDate == NULL) ? date("Ymd") : $fixedDate;

		$this->Timestamp = $this->getPiecesOfTimestamp($fixedDate);
		$FirstDayNo = date("w", mktime(0, 0, 0, $this->Timestamp['Month'], 1, $this->Timestamp['Year']));
		$EndDay = date("d", mktime(0, 0, 0, $this->Timestamp['Month'] + 1, 0, $this->Timestamp['Year']));
		$counter = -1 * ($FirstDayNo - 1);

		// 表示用パーツ
		$CurrentYear = $this->Timestamp['Year'];
		$CurrentMonth = $this->Timestamp['Month'];

		// カレンダー生成
		$EndFlg = FALSE;
		$WeekLine = 0;
		while(!$EndFlg){
			for ($i = 0; $i < 7; $i++){
				$CalendarDay[$WeekLine][$i] = date("d", mktime(0, 0, 0, $this->Timestamp['Month'], $counter, $this->Timestamp['Year']));
				$SetDate[$WeekLine][$i] = date("Ymd", mktime(0, 0, 0, $this->Timestamp['Month'], $counter, $this->Timestamp['Year']));
				$CalendarMonth = date("m", mktime(0, 0, 0, $this->Timestamp['Month'], $counter, $this->Timestamp['Year']));

				if (date("Ymd") == $SetDate[$WeekLine][$i])
					$IfToday[$WeekLine][$i] = TRUE;

				$counter++;
			}
			$EndFlg = ($WeekLine > 1 && ($CalendarDay[$WeekLine][6] == $EndDay || $CalendarMonth != $this->Timestamp['Month'])) ? TRUE : FALSE;
			$CalendarLoop[$WeekLine] = 7;
			$WeekLine++;
		}
		$CalendarDoubleLoop = $WeekLine;

		$this->Rows = $CalendarDoubleLoop;
		$this->Cols = $CalendarLoop;
		$this->Days = $CalendarDay;
		$this->IfToday = $IfToday;
		$this->Month = $CurrentMonth;
		$this->Year = $CurrentYear;
		$this->NextMonth = date("Ymd", mktime(0, 0, 0, $this->Timestamp['Month'] + 1, 1, $this->Timestamp['Year']));
		$this->PreviousMonth = date("Ymd", mktime(0, 0, 0, $this->Timestamp['Month'] - 1, 1, $this->Timestamp['Year']));
	}

	function getTheseMonths ($fixedDate = NULL, $months = 5) {
		$fixedDate = ($fixedDate == NULL) ? date("Ymd") : $fixedDate;

		$this->Timestamp = $this->getPiecesOfTimestamp($fixedDate);

		for ($i = 0; $i < $months; $i++){
			$TheseMonths[$i] = date("Ym", mktime(0, 0, 0, $this->Timestamp['Month'] - $i, 1, $this->Timestamp['Year']));
			$TheseMonthsName[$i] = date("Y-m", mktime(0, 0, 0, $this->Timestamp['Month'] - $i, 1, $this->Timestamp['Year']));
		}

		$this->TheseMonths = $TheseMonths;
		$this->TheseMonthsName = $TheseMonthsName;
	}
}
?>
