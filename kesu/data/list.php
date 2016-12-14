<?php
include_once dirname(__file__).'/../../links/VF/inc/_header_site_nodb.inc'; //assiette_ADD_20140630

$acard=array();
$onoff=array('','off','off','off','off','off','off','off','off');
$sort='';
$loc='';
$cnt=0;
$tab='';
$list='';
$html='';
$aList=array();
if (isset($_GET['loc']))$loc=$_GET['loc'];
if (isset($_GET['sort']))$sort=$_GET['sort'];
if (isset($_GET['tab']))$tab=$_GET['tab'];
$test=str_replace('_','@',$loc);
$list=fnc_tagcat($test,'list=','@');
$colspan='8';
if ($tab=='2'){
	$colspan='9';
}elseif($tab=='5'){
	$colspan='10';
}
if ($list!=''){
	$ary=explode(',',$list.',');
	foreach($ary as $vl){
		if (is_numeric($vl)){
			$aList+=array('l'.$vl=>'on');
		}
	}
}

#csvファイル全文で""内の改行部分を<br>化
function fnc_enrcut($str){
	$qflg=false;
	$ret='';
	$len=strlen($str);
	for($i=0;$i<$len;$i++){
		$v=substr($str,$i,1);
		if ($qflg){
			if ($v=='"'){
				$qflg=false;
				$ret.=$v;
			}elseif($v=="\r"){
				#suru-
			}elseif($v=="\n"){
				$ret.='<br>';
			}else{
				$ret.=$v;
			}
		}else{
			if ($v=='"'){
				$qflg=true;
				$ret.=$v;
			}else{
				$ret.=$v;
			}
		}
	}
	return $ret;
}

//assiette_ADD_20140707 START

/*if (!file_exists('loan_ex.csv')){
	echo '<tr><td colspan="'.$colspan.'">システムエラーが発生しました。（設定ファイル読み込みエラー）</td></tr>';
	exit;
}*/

$_bfname = 'loan_ex';
$_bfext = '.csv';

$basecsv = $_bfname.$_bfext;
$unitcsv = '';
$punitcsv = '';
$myparamname = $_COOKIE["landing_add_value"];
$myunit = $_COOKIE["landing_unit_name"];
$punit = $_COOKIE["landing_punit_name"];
$ugf = $_COOKIE["landing_ugf"];

if($ugf != "1" && $myparamname != ""){
	$url = sprintf(_GETUNIT_APIURL, $myparamname, _COMMON_GENRUCD);
	$result = file_get_contents($url);
	$getUnit = json_decode($result);
	$myunit = $getUnit->us;
	$punit = $getUnit->pus;
}
if ($myunit != ""){
	$ugf = "1";
	$res = setcookie("landing_ugf", "1", 0, "/");
	$res = setcookie("landing_unit_name", $myunit, 0, "/");
	$unitcsv = $_bfname."_".$myunit.$_bfext;
}
if ($punit != ""){
	$ugf = "1";
	$res = setcookie("landing_ugf", "1", 0, "/");
	$res = setcookie("landing_punit_name", $punit, 0, "/");
	$punitcsv = $_bfname."_".$punit.$_bfext;
}

$csvfilename = "";
if ($unitcsv != "" && file_exists($unitcsv)){
	$csvfilename = $unitcsv;
}elseif($punitcsv != "" && file_exists($punitcsv)){
	$csvfilename = $punitcsv;
}
elseif (!file_exists($basecsv)){
	echo '<tr><td colspan="8">システムエラーが発生しました。（設定ファイル読み込みエラー）</td></tr>';
	exit;
}else{
	$csvfilename = $basecsv;
}

#check
//$filest=filemtime('loan_ex.csv').':'.filesize('loan_ex.csv');
$filest=filemtime($csvfilename).':'.filesize($csvfilename);
//assiette_ADD_20140707 END

$ck='';
if (file_exists("log/filest.log")){
	if (!($if=fopen("log/filest.log","r"))){die("log/filest.log file open error!");};
	while($v=fgets($if)){
	 $ck.=$v;
	}
	fclose($if);
}
if ($filest!=$ck || !file_exists("log/read.log")){
	if (!($if = fopen ("log/filest.log", "w"))) {
	die ("log/filest.log not write");
	}
	flock ($if, LOCK_EX);
	fputs ($if, $filest);
	flock ($if, LOCK_UN);
	fclose ($if);
	
	$csv='';
//	if (!($if=fopen('loan_ex.csv',"r"))){die("data/card.csv file open error!");};
	if (!($if=fopen($csvfilename,"r"))){die("data/".$csvfilename." file open error!");};
	while($v=fgets($if)){
	 $csv.=$v;
	}
	fclose($if);
	$csv=fnc_enrcut($csv);
	$w='';
	$csv=str_replace(mb_convert_encoding("～","SJIS","UTF-8"),'(%-kara-%)',$csv);
	$csv=mb_convert_encoding($csv,"UTF-8","SJIS");
	$csv=str_replace('(%-kara-%)','～',$csv);
	$csv=str_replace("\t","  ",$csv);
	$csv=str_replace("?","-",$csv);
	$aline=explode("\r\n",$csv."\r\n");
	$i=0;
	$cnt=0;
	foreach($aline as $l){
		$l=trim($l);
		$l=str_replace("'","’",$l);
		$l=str_replace("\n","<br>",$l);
		$l=str_replace("\r","",$l);
		if ($l!='' && strlen($l)>40 && $i>0){
			$l=fnc_kanmataisaku($l);
			$w.=$l."\n";
		}
		$i++;
	}
	if (!($if = fopen ("log/read.log", "w"))) {
	die ("log/read.log not write");
	}
	flock ($if, LOCK_EX);
	fputs ($if, $w);
	flock ($if, LOCK_UN);
	fclose ($if);
}

$colcnt=0;
if (!($if=fopen("log/read.log","r"))){echo '<tr><td colspan="'.$colspan.'">システムエラーが発生しました。（設定ファイル読み込みエラー）</td></tr>';exit;};
while($l=fgets($if)){
	$colcnt++;
	$atmp=explode("\t",$l);
	if (is_numeric($atmp[0]) && $atmp[2]!='' && $atmp[1]=='1'){
		$flg=true;
		//refine-top
		for($i=1;$i<=4;$i++){
			if (strpos($loc,'refine-top=refine-top-'.$i)>0 && $flg){
				if ($atmp[9+$i]!='1')$flg=false;
			}
		}
		//mokuteki
		for($i=1;$i<=5;$i++){
			if (strpos($loc,'mokuteki=m'.$i)>0 && $flg){
				if ($atmp[13+$i]!='1')$flg=false;
			}
		}
		//shinsa
		for($i=1;$i<=5;$i++){
			if (strpos($loc,'shinsa=s'.$i)>0 && $flg){
				if ($atmp[18+$i]!='1')$flg=false;
			}
		}
		//gendo
		for($i=1;$i<=5;$i++){
			if (strpos($loc,'gendo=g'.$i)>0 && $flg){
				if ($atmp[23+$i]!='1')$flg=false;
			}
		}
		//kinri
		for($i=1;$i<=5;$i++){
			if (strpos($loc,'kinri=k'.$i)>0 && $flg){
				if ($atmp[28+$i]!='1')$flg=false;
			}
		}
		//meyasu
		for($i=1;$i<=4;$i++){
			if (strpos($loc,'meyasu=m'.$i)>0 && $flg){
				if ($atmp[33+$i]!='1')$flg=false;
			}
		}
		//kodawari
		for($i=1;$i<=5;$i++){
			if (strpos($loc,'kodawari=kd'.$i)>0 && $flg){
				if ($atmp[37+$i]!='1')$flg=false;
			}
		}
		//conveni
		for($i=1;$i<=4;$i++){
			if (strpos($loc,'conveni=cv'.$i)>0 && $flg){
				if ($atmp[42+$i]!='1')$flg=false;
			}
		}
		//kikan
		for($i=1;$i<=4;$i++){
			if (strpos($loc,'kikan=kk'.$i)>0 && $flg){
				if ($atmp[46+$i]!='1')$flg=false;
			}
		}
		if ($list!='' && !isset($aList['l'.$atmp[0]])){
			$flg=false;
		}
		if ($flg){
			$cnt++;
			$key=fnc_0add($colcnt,10).'_'.$atmp[0];
			if ($sort=='1' || $sort=='2'){
				$key=fnc_0add($atmp[49],10).'_'.$atmp[0];
				$onoff[($sort+0)]='on';
			}elseif ($sort=='3' || $sort=='4'){
				$key=fnc_0add($atmp[50],10).'_'.$atmp[0];
				$onoff[($sort+0)]='on';
			}elseif ($sort=='5' || $sort=='6'){
				$key=fnc_0add($atmp[51],10).'_'.$atmp[0];
				$onoff[($sort+0)]='on';
			}elseif ($sort=='7' || $sort=='8'){
				$key=fnc_0add($atmp[52],10).'_'.$atmp[0];
				$onoff[($sort+0)]='on';
			}
			$acard+=array($key=>$atmp);
		}
	}
}
fclose($if);

if (count($acard)==0){
	echo '<tr><td colspan="'.$colspan.'">検索条件に対応するローンがありませんでした。検索条件を再設定して検索して下さい。</td></tr>';
	exit;
}


if ($sort=='1' || $sort=='3' || $sort=='5' || $sort=='7' || $sort==""){
	ksort($acard);
}else{
	krsort($acard);
}

$html.='<tbody>'."\n";
$html.='<tr>'."\n";
$html.='<th width="24">&nbsp;</th>'."\n";
$html.='<th width="125">&nbsp;</th>'."\n";
if ($tab=='2'){
	$html.='<th width="96">必要書類</th>'."\n";
	$html.='<th width="96">保証人</th>'."\n";
	$html.='<th width="96">担保</th>'."\n";
	$html.='<th width="96">来店</th>'."\n";
	$html.='<th width="96">入会金・手数料<br>'."\n";
}elseif ($tab=='3'){
	$html.='<th width="120">借入時最低年齢</th>'."\n";
	$html.='<th width="120">学生</th>'."\n";
	$html.='<th width="120">専業主婦</th>'."\n";
	$html.='<th width="120">アルバイト</th>'."\n";
}elseif ($tab=='4'){
	$html.='<th width="160">返済方式</th>'."\n";
	$html.='<th width="160">返済方法</th>'."\n";
	$html.='<th width="160">返済期間・回数</th>'."\n";
}elseif ($tab=='5'){
	$html.='<th width="80">資本金</th>'."\n";
	$html.='<th width="80">会社設立年度</th>'."\n";
	$html.='<th width="80">店舗営業時間</th>'."\n";
	$html.='<th width="80">ATM営業時間</th>'."\n";
	$html.='<th width="80">本社所在地</th>'."\n";
	$html.='<th width="80">貸金業登録番号</th>'."\n";
}else{
	$html.='<th width="120">金利<br>'."\n";
	$html.='<a href="javascript:void(0);" onclick="javascript:fnc_sort('."'1'".');"><img src="../images/btn_sort_up_'.$onoff[1].'.png" alt="降順" width="14" height="12" border="0"></a><a href="javascript:void(0);" onclick="javascript:fnc_sort('."'2'".');"><img src="../images/btn_sort_down_'.$onoff[2].'.png" alt="昇順" width="14" height="12" border="0"></a></th>'."\n";
	$html.='<th width="120">審査時間<br>'."\n";
	$html.='<a href="javascript:void(0);" onclick="javascript:fnc_sort('."'3'".');"><img src="../images/btn_sort_up_'.$onoff[3].'.png" alt="降順" width="14" height="12" border="0"></a><a href="javascript:void(0);" onclick="javascript:fnc_sort('."'4'".');"><img src="../images/btn_sort_down_'.$onoff[4].'.png" alt="昇順" width="14" height="12" border="0"></a></th>'."\n";
	$html.='<th width="120">融資スピード<br>'."\n";
	$html.='<a href="javascript:void(0);" onclick="javascript:fnc_sort('."'5'".');"><img src="../images/btn_sort_up_'.$onoff[5].'.png" alt="降順" width="14" height="12" border="0"></a><a href="javascript:void(0);" onclick="javascript:fnc_sort('."'6'".');"><img src="../images/btn_sort_down_'.$onoff[6].'.png" alt="昇順" width="14" height="12" border="0"></a></th>'."\n";
	$html.='<th width="130">限度額<br>'."\n";
	$html.='<a href="javascript:void(0);" onclick="javascript:fnc_sort('."'7'".');"><img src="../images/btn_sort_up_'.$onoff[7].'.png" alt="降順" width="14" height="12" border="0"></a><a href="javascript:void(0);" onclick="javascript:fnc_sort('."'8'".');"><img src="../images/btn_sort_down_'.$onoff[8].'.png" alt="昇順" width="14" height="12" border="0"></a></th>'."\n";
}
$html.='<th>ポイント</th>'."\n";
$html.='<th width="100">&nbsp;</th>'."\n";
$html.='</tr>'."\n";

foreach($acard as $key =>$vl){
	$cind='##cind##';
	$html.='( -tab- )'.$vl[0].'( -kugiri- )'."\n";
	if (trim($vl[53])=='1'){
		$html.='<tr class="sp_card" id="ind'.$cind.'" title="key'.$vl[0].'">'."\n";
	}else{
		$html.='<tr class="nomal_card" id="ind'.$cind.'" title="key'.$vl[0].'">'."\n";
	}
	$html.='<td class="card_list_sort sortup" style="background-color:#f5f5f5;"><a href="javascript:void(0);" onclick="javascript:fnc_narabi('."'u'".','."'{$cind}'".');"><img src="../images/card_list_sortup_off.gif" alt="up" width="14" height="17" border="0"></a></td>'."\n";
	$html.='<td rowspan="2" class="card_list_face"><a href="'.$vl[4].'" target="_blank" class="u_space_5">'.$vl[2].'</a><br>'."\n";
	$html.='<a href="'.$vl[4].'" target="_blank"><img src="../images/'.$vl[3].'" alt="'.$vl[2].'" border="0"></a></td>'."\n";
	if ($tab=='2'){
		$html.='<td rowspan="2">'.$vl[54].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[55].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[56].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[57].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[58].'</td>'."\n";
	}elseif ($tab=='3'){
		$html.='<td rowspan="2">'.$vl[59].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[60].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[61].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[62].'</td>'."\n";
	}elseif ($tab=='4'){
		$html.='<td rowspan="2">'.$vl[63].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[64].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[65].'</td>'."\n";
	}elseif ($tab=='5'){
		$html.='<td rowspan="2">'.$vl[66].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[67].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[68].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[69].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[70].'</td>'."\n";
		$html.='<td rowspan="2">'.$vl[71].'</td>'."\n";
	}else{
		$bgc='';
		if ($sort=='1' || $sort=='2')$bgc=' style="background-color:#fffabc;background-image:none;"';
		$html.='<td '.$bgc.' rowspan="2">'.$vl[5].'</td>'."\n";
		$bgc='';
		if ($sort=='3' || $sort=='4')$bgc=' style="background-color:#fffabc;background-image:none;"';
		$html.='<td '.$bgc.' rowspan="2">'.$vl[7].'</td>'."\n";
		$bgc='';
		if ($sort=='5' || $sort=='6')$bgc=' style="background-color:#fffabc;background-image:none;"';
		$html.='<td '.$bgc.' rowspan="2">'.$vl[8].'</td>'."\n";
		$bgc='';
		if ($sort=='7' || $sort=='8')$bgc=' style="background-color:#fffabc;background-image:none;"';
		$html.='<td '.$bgc.' rowspan="2">'.$vl[6].'</td>'."\n";
	}
	$html.='<td class="card_list_txt" rowspan="2">'.$vl[9].'</td>'."\n";
	$html.='<td rowspan="2"><a href="'.$vl[4].'" target="_blank"><img src="../images/button_moushikomi_off.png" alt="申込み" width="100" height="50" border="0" onMouseOver="javascript:this.src='."'../images/button_moushikomi_on.png'".';" onMouseOut="javascript:this.src='."'../images/button_moushikomi_off.png'".';"></a><br><a href="javascript:void(0);" onclick="javascript:fnc_del('."'{$cind}'".');"><img src="../images/btn_delete_off.png" alt="削除する" width="64" height="23" border="0" class="btn_delete" onMouseOver="javascript:this.src='."'../images/btn_delete_on.png'".';" onMouseOut="javascript:this.src='."'../images/btn_delete_off.png'".';"></a></td>'."\n";
	$html.='</tr>'."\n";
	$html.='<tr class="sp_card" id="ind'.$cind.'_d">'."\n";
	$html.='<td class="card_list_sort sortdown"><a href="javascript:void(0);" onclick="javascript:fnc_narabi('."'d'".','."'{$cind}'".');"><img src="../images/card_list_sortdown_off.gif" alt="up" width="14" height="17" border="0"></a></td>'."\n";
	$html.='</tr>'."\n";
	
}
$html.='</tbody>'."\n";
$html=str_replace("\t",'',$html);
$html=str_replace("~",'～',$html);
$html=str_replace("( -tab- )","\t",$html);
$html=str_replace("( -kugiri- )","~",$html);
echo $html;
exit;

#CSVの列で区切りカンマを\tに変換（CSVUP時）
function fnc_kanmataisaku($str){
	$str=str_replace("\r\n","",$str);
	$str=str_replace("\t"," ",$str);
	$ret='';
	$flgh=true;
	$len=strlen($str);
	for($i=0;$i<$len;$i++){
		$v=substr($str,$i,1);
		if ($flgh && $v==","){
			$ret.="\t";
		}elseif($v=='"'){
			$ret.=$v;
			if ($flgh){
				$flgh=false;
			}else{
				$flgh=true;
			}
		}else{
			$ret.=$v;
		}
	}
	$r='';
	$i=0;
	$a=explode("\t",$ret."\t");
	foreach($a as $v){
		if ($i>0)$r.="\t";
		if ($i==49 || $i==50 || $i==51 || $i==52){
			$r.=fnc_0add(fnc_csvstr($v),10);
		}else{
			$r.=fnc_csvstr($v);
		}
		$i++;
	}
	return $r;
}
#CSVの個々の列で"で囲まれていた場合、"をカット、その後,""を"にする（CSVUP時）
function fnc_csvstr($str){
	$ret=trim($str);
	if (strlen($ret)>1){
		$s=substr($ret,0,1);
		$e=substr($ret,(strlen($ret)-1),1);
		if ($s=='"' && $e=='"'){
			$ret=substr($ret,1,(strlen($ret)-2));
		}
		$ret=str_replace('""','"',$ret);
	}
	$ret=str_replace('&quot;','"',$ret);
	return $ret;
}
function fnc_0add($str,$nm){
	$ret=$str;
	$l=strlen($str);
	$made=$nm - $l;
	if ($made>0){
		for ($i=1;$i<=$made;$i++){
			$ret='0'.$ret;
		}
	}
	return $ret;
}
function fnc_tagcat($moto,$startstr,$endstr){
	$ret='';
	$eind=0;
	$sind=strpos('_'.$moto,$startstr);
	
	if ($sind>0){
		$moto2=substr($moto,$sind+strlen($startstr));
		$eind=strpos('_'.$moto2,$endstr);
	}
	
	if ($sind>0 && $eind>0){
		$ret=substr($moto,($sind-1),($eind+strlen($startstr)));
		$ret=substr($ret,strlen($startstr));
	}else{
		$ret='';
	}
	return trim($ret);
}
?>