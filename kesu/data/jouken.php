<?php
$loc='';
$tbl='';
if (isset($_GET['loc']))$loc=$_GET['loc'];

if (strpos($loc,'list=')>0){
	$tmp='まとめて比較機能';
}
if ($tmp!=''){
	$tbl.='<tr><th>検索モード</th><td>まとめて比較機能</td></tr>'."\n";
}
$tmp='';
if (strpos($loc,'refine-top=refine-top-')>0){
	$a=array('','銀行系カードローン','即日融資ローン','おまとめローン','スマホ対応ローン','');
	for($i=1;$i<=4;$i++){
		if (strpos($loc,'refine-top=refine-top-'.$i)>0){
			if ($tmp!='')$tmp.='&nbsp;&nbsp;|&nbsp;&nbsp;';
			$tmp.=$a[$i];
		}
	}
}
if (strpos($loc,'mokuteki=m')>0){
	$a=array('','消費者金融','お試し審査','一定期間無利息','総量規制外','限度額大きい');
	for($i=1;$i<=5;$i++){
		if (strpos($loc,'mokuteki=m'.$i)>0){
			if ($tmp!='')$tmp.='&nbsp;&nbsp;|&nbsp;&nbsp;';
			$tmp.=$a[$i];
		}
	}
}
if ($tmp!=''){
	$tbl.='<tr><th>目的別</th><td>'.$tmp.'</td></tr>'."\n";
}
if (strpos($loc,'shinsa=s')>0){
	$tmp='';
	$a=array('','自動審査（3秒）','30分以内','1時間以内','3時間以内','当日中');
	for($i=1;$i<=5;$i++){
		if (strpos($loc,'shinsa=s'.$i)>0){
			if ($tmp!='')$tmp.='&nbsp;&nbsp;|&nbsp;&nbsp;';
			$tmp.=$a[$i];
		}
	}
	if ($tmp!=''){
		$tbl.='<tr><th>審査時間</th><td>'.$tmp.'</td></tr>'."\n";
	}
}
if (strpos($loc,'gendo=g')>0){
	$tmp='';
	$a=array('','30万以上','100万以上','300万以上','500万以上','800万以上');
	for($i=1;$i<=5;$i++){
		if (strpos($loc,'gendo=g'.$i)>0){
			if ($tmp!='')$tmp.='&nbsp;&nbsp;|&nbsp;&nbsp;';
			$tmp.=$a[$i];
		}
	}
	if ($tmp!=''){
		$tbl.='<tr><th>限度額</th><td>'.$tmp.'</td></tr>'."\n";
	}
}
if (strpos($loc,'kinri=k')>0){
	$tmp='';
	$a=array('','4％以下','5％以下','6％以下','7％以下','8％以下');
	for($i=1;$i<=5;$i++){
		if (strpos($loc,'kinri=k'.$i)>0){
			if ($tmp!='')$tmp.='&nbsp;&nbsp;|&nbsp;&nbsp;';
			$tmp.=$a[$i];
		}
	}
	if ($tmp!=''){
		$tbl.='<tr><th>金利</th><td>'.$tmp.'</td></tr>'."\n";
	}
}
if (strpos($loc,'meyasu=m')>0){
	$tmp='';
	$a=array('','1時間以内','3時間以内','当日中','1週間以内','');
	for($i=1;$i<=4;$i++){
		if (strpos($loc,'meyasu=m'.$i)>0){
			if ($tmp!='')$tmp.='&nbsp;&nbsp;|&nbsp;&nbsp;';
			$tmp.=$a[$i];
		}
	}
	if ($tmp!=''){
		$tbl.='<tr><th>融資までの目安</th><td>'.$tmp.'</td></tr>'."\n";
	}
}
if (strpos($loc,'kodawari=kd')>0){
	$tmp='';
	$a=array('','学生・主婦OK','来店不要','自動審査','保証人不要','土日祝日可');
	for($i=1;$i<=5;$i++){
		if (strpos($loc,'kodawari=kd'.$i)>0){
			if ($tmp!='')$tmp.='&nbsp;&nbsp;|&nbsp;&nbsp;';
			$tmp.=$a[$i];
		}
	}
	if ($tmp!=''){
		$tbl.='<tr><th>こだわり</th><td>'.$tmp.'</td></tr>'."\n";
	}
}
if (strpos($loc,'conveni=cv')>0){
	$tmp='';
	$a=array('','セブンイレブン','ファミリーマート','ローソン','サンクス','');
	for($i=1;$i<=4;$i++){
		if (strpos($loc,'conveni=cv'.$i)>0){
			if ($tmp!='')$tmp.='&nbsp;&nbsp;|&nbsp;&nbsp;';
			$tmp.=$a[$i];
		}
	}
	if ($tmp!=''){
		$tbl.='<tr><th>利用可能コンビニ</th><td>'.$tmp.'</td></tr>'."\n";
	}
}
if (strpos($loc,'kikan=kk')>0){
	$tmp='';
	$a=array('','銀行系','非銀行系','','','');
	for($i=1;$i<=2;$i++){
		if (strpos($loc,'kikan=kk'.$i)>0){
			if ($tmp!='')$tmp.='&nbsp;&nbsp;|&nbsp;&nbsp;';
			$tmp.=$a[$i];
		}
	}
	if ($tmp!=''){
		$tbl.='<tr><th>金融機関</th><td>'.$tmp.'</td></tr>'."\n";
	}
}

if ($tbl==''){
	$tbl.='<tr><th>検索条件</th><td>全て表示</td></tr>';
}
echo '<tbody>'."\n".$tbl."\n".'</tbody>';
exit;
?>