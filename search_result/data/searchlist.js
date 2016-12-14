var sort99 = new Array() ;
function fnc_onload(){
	var shinsa_flg=false;
	var gendo_flg=false;
	var kinri_flg=false;
	var meyasu_flg=false;
	var kikan_flg=false;
	var loc=location.href;
	loc=fnc_okikae(loc,'http://','');
	loc=fnc_okikae(loc,'https://','');
	fnc_jouken(loc);
	fnc_list(loc);
	//パラメータ引き継ぐ
	for(var i=1;i<=5;i++){
		//refine-top
		if (loc.indexOf('refine-top=refine-top-'+i)>0){
			document.getElementById("refine-top-"+i).checked=true;
		}
		//mokuteki
		if (loc.indexOf('mokuteki=m'+i)>0){
			document.getElementById("mokuteki-"+i).checked=true;
		}
		//shinsa radio
		if (loc.indexOf('shinsa=s'+i)>0){
			document.getElementById("shinsa-"+i).checked=true;
			shinsa_flg=true;
		}
		//gendo radio
		if (loc.indexOf('gendo=g'+i)>0){
			document.getElementById("gendo-"+i).checked=true;
			gendo_flg=true;
		}
		//kinri radio
		if (loc.indexOf('kinri=k'+i)>0){
			document.getElementById("kinri-"+i).checked=true;
			kinri_flg=true;
		}
		//meyasu radio
		if (loc.indexOf('meyasu=m'+i)>0 && i<=4){
			document.getElementById("meyasu-"+i).checked=true;
			meyasu_flg=true;
		}
		//kodawari
		if (loc.indexOf('kodawari=kd'+i)>0){
			document.getElementById("kodawari-"+i).checked=true;
		}
		//conveni
		if (loc.indexOf('conveni=cv'+i)>0 && i<=4){
			document.getElementById("conveni-"+i).checked=true;
		}
		//kikan radio
		if (loc.indexOf('kikan=kk'+i)>0 && i<=2){
			document.getElementById("kikan-"+i).checked=true;
			kikan_flg=true;
		}
		if (!shinsa_flg)document.getElementById("shinsa-6").checked=true;
		if (!gendo_flg)document.getElementById("gendo-6").checked=true;
		if (!kinri_flg)document.getElementById("kinri-6").checked=true;
		if (!meyasu_flg)document.getElementById("meyasu-5").checked=true;
		if (!kikan_flg)document.getElementById("kikan-3").checked=true;
	}
}
function fnc_jouken(loc){
	//条件設定
	obj=new XMLHttpRequest();
	obj.open("GET","./data/jouken.php?loc="+fnc_okikae(loc,'&','_')+'&dt='+new Date(), false);
	obj.send(null);
	var retstr=obj.responseText;
	$("#tbl_jouken").html(retstr);
}
function fnc_list(loc){
	//条件設定
	obj=new XMLHttpRequest();
	var q="./data/list.php?loc="+fnc_okikae(loc,'&','_')+'_&sort='+document.fml.sort.value+'&tab='+document.fml.tab.value+'&dt='+new Date();
	obj.open("GET",q, false);
	obj.send(null);
	var retstr=obj.responseText;
	var html='';
	var tmp='';
	retstr+="\t";
	var a=retstr.split("\t");
	var gyou=0;
	var max=0;
	var aSort = new Array() ;
	for(var i=0;i<a.length;i++){
		var vl=a[i]+'~';
		var a2=vl.split('~');
		if (a2[1]==''){
			html+=a2[0];
		}else{
			var ngstr=',,'+document.fml.ng.value+',';
			if (document.fml.sort.value=='99'){
				var sind=ngstr.indexOf(','+a2[0]+',');
				if (sind>0){
					//削除済み
				}else{
					max++;
					gyou=sort99['key'+a2[0]];
					tmp=fnc_okikae(a2[1],'##cind##',gyou);
					aSort[parseInt(gyou+0)]=tmp;
				}
			}else{
				var sind=ngstr.indexOf(','+a2[0]+',');
				if (sind>0){
					//削除済み
				}else{
					gyou++;
					tmp=fnc_okikae(a2[1],'##cind##',gyou);
					html+=tmp;
				}
			}
		}
	}
	if (document.fml.sort.value=='99'){
		for(var i=1;i<=max;i++){
			html+=aSort[parseInt(i)];
		}
	}
	$("#tbl_result").html(html);
}
function fnc_okikae(str,mae,ato){	//置き換え関数
	for(i=0;i<100;i++){
		if (str!=null ){
			str=str.replace(mae, ato);
			if (str.indexOf(mae)<0){
				i=1001;
			}
		}
	}
	return str;
}
function fnc_sort(snum){
	document.fml.sort.value=snum;
	var loc=location.href;
	loc=fnc_okikae(loc,'http://','');
	loc=fnc_okikae(loc,'https://','');
	fnc_list(loc);
}

function fnc_tab(tabno){
	var names=',基本情報,借入れ,借入条件,返済,会社案内';
	var aname=names.split(',');
	for(var i=1;i<=5;i++){
		var sousa=document.getElementById("tab"+i);
		if (i==tabno){
			sousa.innerHTML =aname[i];
			sousa.className='current';
		}else{
			sousa.innerHTML ='<a href="javascript:void(0);" onclick="javascript:fnc_tab('+i+');">'+aname[i]+'</a>';
			sousa.className='';
		}
	}
	document.fml.sort.value=99;
	var gyou=0;
	for(var i=1;i<1000;i++){
		if (document.getElementById("ind"+i)){
			if (document.getElementById("ind"+i).style.display!="none"){
				gyou++;
				sort99[document.getElementById("ind"+i).title]=gyou;
			}
		}else{
			i=10000;
		}
	}
	document.fml.tab.value=tabno;
	var loc=location.href;
	loc=fnc_okikae(loc,'http://','');
	loc=fnc_okikae(loc,'https://','');
	fnc_list(loc);
}

function fnc_narabi(nmode,ind){
	var add=0;
	var col2=null;
	var col=document.getElementById("ind"+ind);
	if (nmode=='d'){
		if (document.getElementById("ind"+(parseInt(ind)+1))){
			col2=document.getElementById("ind"+(parseInt(ind)+1));
			add=1;
		}else{
			return;
		}
	}else if(nmode=='u'){
		if (document.getElementById("ind"+(parseInt(ind)-1))){
			add=-1;
			col2=document.getElementById("ind"+(parseInt(ind)-1));
		}else{
			return;
		}
	}
	//html変換
	var bk_html_col=col2.innerHTML;
	bk_html_col=fnc_okikae(bk_html_col,"fnc_narabi('u','"+(parseInt(ind)+add)+"');","fnc_narabi('u','"+ind+"');");
	bk_html_col=fnc_okikae(bk_html_col,"fnc_del('"+(parseInt(ind)+add)+"');","fnc_del('"+ind+"');");
	var tmp=col.innerHTML;
	tmp=fnc_okikae(tmp,"fnc_narabi('u','"+ind+"');","fnc_narabi('u','"+(parseInt(ind)+add)+"');");
	tmp=fnc_okikae(tmp,"fnc_del('"+ind+"');","fnc_del('"+(parseInt(ind)+add)+"');");
	col2.innerHTML=tmp;
	col.innerHTML=bk_html_col;
	//title変換
	var bk_title=col2.title;
	col2.title=col.title;
	col.title=bk_title;
	//class変換
	var bk_cls=col2.className;
	col2.className=col.className;
	col.className=bk_cls;
}

function fnc_del(ind){
	var col=null;
	var mcol=null;
	var lastind=ind;
	var ngs=document.fml.ng.value;
	var tit=document.getElementById("ind"+ind).title;
	tit=fnc_okikae(tit,"key","");
	for(var i=1;i<1000;i++){
		if (document.getElementById("ind"+i)){
			if (i>parseInt(ind) && document.getElementById("ind"+(i-1))){
				col=document.getElementById("ind"+i);
				mcol=document.getElementById("ind"+(i-1));
				//html変換
				var tmp=col.innerHTML;
				tmp=fnc_okikae(tmp,"fnc_narabi('u','"+i+"');","fnc_narabi('u','"+(i-1)+"');");
				tmp=fnc_okikae(tmp,"fnc_del('"+i+"');","fnc_del('"+(i-1)+"');");
				mcol.innerHTML=tmp;
				//title変換
				mcol.title=col.title;
				//class変換
				mcol.className=col.className;
			}
			if (document.getElementById("ind"+i).style.display!="none")lastind=i;
		}else{
			i=10000;
		}
	}
	document.getElementById("ind"+lastind).style.display="none";
	document.getElementById("ind"+lastind+"_d").style.display="none";
	if (lastind==ind && ind=='1'){
		var retstr='<tr><td>データが削除されました。</td></tr>';
		$("#tbl_result").html(retstr);
	}
	if (ngs!='')ngs+=',';
	ngs+=tit;
	document.fml.ng.value=ngs;
}

function fnc_getxmldata(nm,xml){
	var startstr='<'+nm+'>';
	var endstr='</'+nm+'>';
	var ret='';
	var eind=0;
	var sind=xml.indexOf(startstr);
	if (sind>0){
		var xml2=xml.substring(sind+startstr.length);
		var eind=xml2.indexOf(endstr);
	}
	if (sind>0 && eind>0){
		ret=xml2.substring(0,eind);
	}
	return ret;
}

function fnc_tagcut(startstr,endstr,xml){
	var ret='';
	var eind=0;
	var sind=xml.indexOf(startstr);
	if (sind>0){
		var xml2=xml.substring(sind+startstr.length);
		var eind=xml2.indexOf(endstr);
	}
	if (sind>0 && eind>0){
		ret=xml2.substring(0,eind);
	}
	return ret;
}
function fnc_relist(){
	
}