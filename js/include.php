<?php
	########################################################
	# 各種INCLUDE処理
	########################################################

	// 基本読み込み
	include_once dirname(__file__).'/../links/VF/inc/_header_site_nodb.inc';
//	include_once '_header_site_nodb.inc';
	
	$js		= ASParameter::getStringValue('js');
	$html	= ASParameter::getStringValue('html');
	$wGCD	= ASParameter::getStringValue('gcd');
	$add	= ASParameter::getStringValue('add');
	$myunit = ASParameter::getStringValue('myunit');
	$punit	= ASParameter::getStringValue('punit');
	$ugf	= ASParameter::getStringValue('ugf');
	
	if ($html == ""){//エラー回避のために。
		$html = "index";
	}
	$jsArr = ($js != "") ? explode(",", $js) : array();
	$htmlArr = ($html != "") ? explode(",", $html) : array();
	
	if ($wGCD > 0){
		$wGCD = _COMMON_GENRUCD;
	}
	
	if (count($jsArr) == 0 && count($htmlArr) == 0){
		exit;
	}

	$MyFilePath = dirname(__file__)."/";
	if ($ugf != "1"){ // ユニット取得出来てないとき
		if($add == ""){
			$nowURL = $_SERVER["QUERY_STRING_UNESCAPED"];
			$addArr = explode('\\&',$nowURL);
			foreach($addArr as $idx=>$data){
				$nowArr = explode("=", $data);
				if($nowArr[0] == "add"){
					$add = $nowArr[1];
					break;
				}
			}
		}
	
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
	
		if($flg != "1" && $myparamname != ""){
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
	}

	$getContents = "";
	
	//JSの時。
	if(count($jsArr) > 0){
		$jsTag = '<script type="text/javascript" src="%s"></script>';
		
		$jsPath = "/".str_replace(_DOCUMENT_ROOT, "", $MyFilePath);
		for($jc=0; $jc<count($jsArr); $jc++){
			$bFile = $jsArr[$jc].".js";
			$uFile = ($myunit != "") ? $jsArr[$jc]."_".$myunit.".js" : "";
			$pFile = ($punit != "") ? $jsArr[$jc]."_".$punit.".js" : "";
			if($uFile != "" && file_exists($MyFilePath.$uFile)){
				$getContents .= sprintf($jsTag, $jsPath.$uFile);
			}elseif($pFile != "" && file_exists($MyFilePath.$pFile)){
				$getContents .= sprintf($jsTag, $jsPath.$pFile);
			}elseif(file_exists($MyFilePath.$bFile)){
				$getContents .= sprintf($jsTag, $jsPath.$bFile);
			}
		}
	}
	//htmlの時。
	elseif(count($htmlArr) > 0){
		for($hc=0; $hc<count($htmlArr); $hc++){
			$nowGetContents = "";
			$bFile = $htmlArr[$hc].".html";
			$uFile = ($myunit != "") ? $htmlArr[$hc]."_".$myunit.".html" : "";
			$pFile = ($punit != "") ? $htmlArr[$hc]."_".$punit.".html" : "";
			
			if($uFile != "" && file_exists($MyFilePath.$uFile)){
				$nowGetContents = file_get_contents($MyFilePath.$uFile);
//				echo '<input type="hidden" value="'.$uFile.'">';
			}elseif($pFile != "" && file_exists($MyFilePath.$pFile)){
				$nowGetContents = file_get_contents($MyFilePath.$pFile);
//				echo '<input type="hidden" value="'.$pFile.'">';
			}elseif(file_exists($MyFilePath.$bFile)){
				$nowGetContents = file_get_contents($MyFilePath.$bFile);
//				echo '<input type="hidden" value="'.$bFile.'">';
			}
			
			if ($nowGetContents != ""){
				$utf = mb_convert_encoding($nowGetContents, "UTF-8", "SJIS");
				
				$getContents .= ReplaceInclude($utf);
			}
		}
	}

	echo mb_convert_encoding($getContents, "SJIS", "UTF-8");

exit;
	

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