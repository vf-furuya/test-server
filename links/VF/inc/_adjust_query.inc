<?php
/**-------------------------------------------------
 ** リダイレクトチェッカ用にURLエンコードをしたり外したり
 **-------------------------------------------------*/

$_qs = $_SERVER['QUERY_STRING'];
do {
	$_qs = str_replace("&amp;", "&", $_qs);
} while (strpos($_qs, "&amp;")!==FALSE);

$get = explode("&", $_qs);
unset($_GET);

if (count($get)>0) {
	foreach ($get as $g) {
		list($k, $v) = explode("=", $g);
		$_GET[$k] = $v;
	}
}
?>