<?php
	########################################################
	# 各種INCLUDE処理
	########################################################
	// 基本読み込み
//	include_once '_header_site_nodb.inc';
	include_once dirname(__file__).'/links/VF/inc/_header_site_nodb.inc';

	$html	= ASParameter::getStringValue('html');
	$wGCD	= ASParameter::getStringValue('gcd');
	$add	= ASParameter::getStringValue('add');

	if ($html == ""){//エラー回避のために。
		$html = "index";
	}

	if ($wGCD > 0){
		$wGCD = _COMMON_GENRUCD;
	}
	
	$MyFilePath = dirname(__file__)."/";
	if ($add != ""){
		$myparamname = $add;
		$res = setcookie("landing_add_value", $add, 0, "/");
		$myunit = "";
		$res = setcookie("landing_unit_name", "", 0, "/");
		$punit = "";
		$res = setcookie("landing_punit_name", "", 0, "/");
		$flg = "9";
		$res = setcookie("landing_ugf", $flg, 0, "/");
	}else{
		$myparamname = $_COOKIE["landing_add_value"];
		$myunit = $_COOKIE["landing_unit_name"];
		$punit = $_COOKIE["landing_punit_name"];
		$flg = $_COOKIE["landing_ugf"];
	}
	
	$DefaultFileBaseName = $html;
	$DefaultFile = $DefaultFileBaseName.".html";
	
	$UnitFile = "";
	$P_UnitFile = "";
	if($myunit == "" &&  $flg != "1" && $myparamname != ""){
		$url = sprintf(_GETUNIT_APIURL, $myparamname, $wGCD);
		$result = file_get_contents($url);
		$getUnit = json_decode($result);
		$myunit = $getUnit->us;
		$punit = $getUnit->pus;
	}
	
	if ($myunit != ""){
		$ugf = "1";
		$res = setcookie("landing_ugf", "1", 0, "/");
		$res = setcookie("landing_unit_name", $myunit, 0, "/");
		$UnitFile = $DefaultFileBaseName."_".$myunit.".html";
	}
	if($punit != ""){
		$ugf = "1";
		$res = setcookie("landing_ugf", "1", 0, "/");
		$res = setcookie("landing_punit_name", $punit, 0, "/");
		$P_UnitFile = $DefaultFileBaseName."_".$punit.".html";
	}
	
	if($UnitFile != "" && file_exists($MyFilePath.$UnitFile)){
		//ユニットファイル
		$getContents = file_get_contents($MyFilePath.$UnitFile);
	}elseif($P_UnitFile != "" && file_exists($MyFilePath.$P_UnitFile)){
		//親のユニットファイル
		$getContents = file_get_contents($MyFilePath.$P_UnitFile);
	}elseif(file_exists($MyFilePath.$DefaultFile)){
		//共通ファイル
		$getContents = file_get_contents($MyFilePath.$DefaultFile);
	}else{
		//どうしようもないので、トップに戻ります。
		$IfError = TRUE;;
	}
	
	if(!$IfError && $getContents != ""){
		$getContents = ReplaceInclude($getContents);
	}
	
	
	$myHtml = new ASHtml('_index.tpl', $MY_CARRIER, TRUE);
	unset($myHtml);
//	echo __line__;


function ReplaceInclude($contents){
	global $MyFilePath ,$myunit, $punit, $ugf;
	$retContents = $contents;
	preg_match_all('/<!--#include virtual="([^"]+)"([\s]?)-->/i', $retContents, $matches);
	
	for($idx=0; $idx<count($matches[0]); $idx++){
		$getpath = "";
		$geturl = "";
		$partsContents = "";

		$replaceStr = $matches[0][$idx];
		$setIncludeFile = $matches[1][$idx];
		
		//ファイルパスの調整
		if (preg_match("/^\//", $setIncludeFile)){
			$getpath = _DOCUMENT_ROOT.$setIncludeFile;
			$geturl = _MAIN_URL.$setIncludeFile;
		}else{
			$getpath = $MyFilePath.$setIncludeFile;
			$geturl = _MAIN_URL.str_replace(_DOCUMENT_ROOT,"",$MyFilePath).$setIncludeFile;
		}
		
		//phpファイルと、そうでないときで取得方法が変わる
		if ($setIncludeFile == str_replace(".php","", $setIncludeFile)){
			if(file_exists($getpath)){
				$partsContents = file_get_contents($getpath);
				$partsContents = ReplaceInclude($partsContents);
			}
		}else{
			$url = $geturl;
			
			$url .= ($myunit != "") ? ((strpos($url, "?") > 0) ? "&" : "?") . "myunit=".$myunit : "";
			$url .= ($punit != "") ? ((strpos($url, "?") > 0) ? "&" : "?") . "punit=".$punit : "";
			$url .= ($ugf != "") ? ((strpos($url, "?") > 0) ? "&" : "?") . "ugf=".$ugf : "";
			$partsContents = file_get_contents($url);
		}
		
		$retContents = str_replace($replaceStr,$partsContents, $retContents);
	}
	return $retContents;
}

?>