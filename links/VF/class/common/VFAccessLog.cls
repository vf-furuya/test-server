<?php
/**
 * AccessLogクラス
 *
 * tAccessLogFテーブルを扱うクラスです。
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2008/01/23
 * @version 1.6
 **/

// 依存
include_once _BASE_CLS_DIR . 'VFBaseAccessLog.cls';

class AccessLog extends BaseAccessLog {
	static function writeLog($myDB, $AccessDate, $RemoteIP, $RequestUri, $wConversionFlg=0) {
		$sql = sprintf("INSERT INTO tAccessLogF (AccessDate, RemoteIP, RequestUri, ConversionFlag) values ('%s', '%s', '%s', %d);"
					 , $AccessDate
					 , $RemoteIP
					 , $RequestUri
					 , $wConversionFlg);

		if (($rtn=$myDB->executeQuery($sql))) {
			return $myDB->getLastInsertId();
		}
		else {
			return -1;
		}
	}
}

