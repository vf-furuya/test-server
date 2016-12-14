<?php
#COOKIEパラメータを取得します。
function fnc_cookie($str){

	$retval="";

	if (isset($_COOKIE[$str]))$retval=$_COOKIE[$str];

	if (strlen($retval)>80000){
		echo 'too largedata';
		exit;
	}
	
	return ($retval);

}
#GETパラメータを取得します。
function fnc_get($str){

	$retval="";

	if (isset($_GET[$str]))$retval=$_GET[$str];
	
	return ($retval);

}
#COOKIEパラメータを取得します。
function set_cookie($str,$vl){

	setcookie($str,$vl,time()+(60*60*24*30));
#	setcookie($str,$vl,0,'/');
	
	return "";

}
if (fnc_get('mode')=='ck' && is_numeric(fnc_get('i'))){
	$tmp=fnc_cookie('llist').',';
	$a=explode(',',$tmp);
	foreach($a as $v){
		if (is_numeric($v) && $v==fnc_get('i')){
			echo '1';
			exit;
		}
	}
	echo $tmp.' : 0';
	exit;
}

if (fnc_get('mode')=='0' && is_numeric(fnc_get('i'))){
	$tmp=fnc_cookie('llist').',';
	$list='';
	$a=explode(',',$tmp);
	foreach($a as $v){
		if (is_numeric($v) && $v!=fnc_get('i')){
			if ($list!='')$list.=',';
			$list.=$v;
		}
	}
	set_cookie('llist',$list);
	echo "document.write(' ');";
	exit;
}
if (fnc_get('mode')=='alldel'){
	$tmp=fnc_cookie('llist').',';
	set_cookie('llist',',');
	echo $tmp;
	exit;
}
if (fnc_get('mode')=='1' && is_numeric(fnc_get('i'))){
	$tmp=fnc_cookie('llist').',';
	$list='';
	$flg=false;
	$a=explode(',',$tmp);
	foreach($a as $v){
		if (is_numeric($v)){
			if ($list!='')$list.=',';
			$list.=$v;
			if ($v==fnc_get('i')){
				$flg=true;
			}
		}
	}
	if (!$flg){
		if ($list!='')$list.=',';
		$list.=fnc_get('i');
	}
	set_cookie('llist',$list);
	echo "document.write(' ');";
	exit;
}

$aryCk=array();
$tmp=fnc_cookie('llist').',';
$list='';
$a=explode(',',$tmp);
foreach($a as $v){
	if (is_numeric($v)){
		$aryCk+=array('ck'.$v=>'on');
	}
}
$tbl='';
$lists='';
if (!file_exists('loan_ex.csv')){
	echo 'データの読み込みに失敗しました。<br>';
	exit;
}
if (!($if=fopen("log/read.log","r"))){echo 'データの読み込みに失敗しました。<br>';exit;};
while($l=fgets($if)){
	$atmp=explode("\t",$l);
	if (is_numeric($atmp[0]) && $atmp[2]!='' && $atmp[1]=='1' && isset($aryCk['ck'.$atmp[0]])){
		if ($lists!='')$lists.=',';
		$lists.=$atmp[0];
		$tbl.='<div class="cp_info">';
		$tbl.='<p class="cp_name"><a href="'.$atmp[4].'" target="_blank">'.$atmp[2].'</a></p>';
		$tbl.='<div class="cap_cp"><a href="'.$atmp[4].'" target="_blank"><img src="../images/'.$atmp[3].'" alt="" width="120" height="120" border="0"></a></div>';
		$tbl.='<div class="cp_btn"><a href="'.$atmp[4].'" target="_blank"><img src="../images/btn_sidecheck_off.png" alt="申込み" width="103" height="35" border="0" onMouseOver="javascript:this.src='."'../images/btn_sidecheck_on.png'".';" onMouseOut="javascript:this.src='."'../images/btn_sidecheck_off.png'".';"></a><br>';
		$tbl.='<a href="javascript:void(0);" onclick="javascript:fnc_del('."'".$atmp[0]."'".');"><img src="../images/btn_delete_off.png" alt="削除する" width="64" height="23" border="0"  onMouseOver="javascript:this.src='."'../images/btn_delete_on.png'".';" onMouseOut="javascript:this.src='."'../images/btn_delete_off.png'".';" ></a></div>';
		$tbl.='</div>';
	}
}
fclose($if);

if ($tbl==''){
	$tbl.= ' <div style="margin: 7px; font-size: 14px;"> チェックしたローンがありません。 </div> ';
}else{
	$tbl='<form action="../search_result/" method="get" name="fmcklist"><input type="hidden" name="list" value="'.$lists.'" />'.$tbl.'<div class="all_delete"><a href="javascript:void(0);" onclick="javascript:fnc_alldel();"><img src="../images/btn_delete_l_off.png" alt="全て削除する" width="88" height="23" border="0" onMouseOver="javascript:this.src='."'../images/btn_delete_l_on.png'".';" onMouseOut="javascript:this.src='."'../images/btn_delete_l_off.png'".';"></a></div>';
	$tbl.='<div class="cp_moushikomi"><a href="javascript:void(0);" onclick="javascript:document.fmcklist.submit();"><img src="../images/btn_cp_moushikomi_off.png" alt="まとめて比較" width="258" height="46" border="0" onMouseOver="javascript:this.src='."'../images/btn_cp_moushikomi_on.png'".';" onMouseOut="javascript:this.src='."'../images/btn_cp_moushikomi_off.png'".';"></a></div></form>';
}

if (fnc_get('mode')=='reload'){
	echo $tbl;
	exit;
}
?>
function fnc_list(){
	var ret='<?php echo str_replace("'","@?@",$tbl);?>';
	ret=fnc_okikae2(ret,'>','>'+"\n");
	ret=fnc_okikae2(ret,'@?@',"'");
	document.getElementById("div_loanlist").innerHTML =ret;
}
function fnc_okikae2(str,mae,ato){	//置き換え関数
	for(i=0;i<5000;i++){
		str=str.replace(mae, ato);
		if (str.indexOf(mae)<0){
			i=1000001;
		}
	}
	return str;
}

function fnc_checkbox(lid){
	obj=new XMLHttpRequest();
	obj.open("GET",'../search_result/data/check.php?mode=ck&i='+lid+'&dt='+new Date(), false);
	obj.send(null);
	var retstr=obj.responseText;
	var ckd='';
	if (retstr=='1')ckd=' checked ';
	var ret='<input type="checkbox" name="ck'+lid+'" id="ck'+lid+'" onclick="javascript:fnc_click('+"'"+lid+"'"+')" value="1" '+ckd+' />';
	document.write(ret);
}
function fnc_del(lid){
	var mode='0';
	if (document.getElementById("ck"+lid)){
		if (document.getElementById("ck"+lid).checked){
			document.getElementById("ck"+lid).checked=false;
		}
	}
	obj=new XMLHttpRequest();
	obj.open("GET",'../search_result/data/check.php?mode='+mode+'&i='+lid+'&dt='+new Date(), false);
	obj.send(null);
	var retstr=obj.responseText;
	fnc_relist();
}
function fnc_alldel(){
	obj=new XMLHttpRequest();
	obj.open("GET",'../search_result/data/check.php?mode=alldel&dt='+new Date(), false);
	obj.send(null);
	var retstr=obj.responseText+',';
	var a=retstr.split(',');
	for(var i=0;i < a.length;i++){
		var tmp=a[i];
		if (tmp!=''){
			if (document.getElementById("ck"+tmp)){
				if (document.getElementById("ck"+tmp).checked){
					document.getElementById("ck"+tmp).checked=false;
				}
			}
		}
	}
	fnc_relist();
}
function fnc_click(lid){
	var mode='0';
	if (document.getElementById("ck"+lid).checked){
		mode='1';
	}
	obj=new XMLHttpRequest();
	obj.open("GET",'../search_result/data/check.php?mode='+mode+'&i='+lid+'&dt='+new Date(), false);
	obj.send(null);
	var retstr=obj.responseText;
	fnc_relist();
}
function fnc_relist(){
	obj=new XMLHttpRequest();
	obj.open("GET",'../search_result/data/check.php?mode=reload&dt='+new Date(), false);
	obj.send(null);
	var retstr=obj.responseText;
	var ret=retstr;
	ret=fnc_okikae2(ret,'>','>'+"\n");
	document.getElementById("div_loanlist").innerHTML =ret;
}