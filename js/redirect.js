function goRedirect(url, paraname){
	
	var st="";
	var ed="";
	var value = "";
	if(document.cookie.length>0){
		// クッキーの値を取り出す
		st=document.cookie.indexOf("landing_add_value=");
		if(st!=-1){
			st=st+"landing_add_value".length+1;
			ed=document.cookie.indexOf(";",st);
			if(ed==-1) ed=document.cookie.length;
			// 値をデコードして返す
			value = unescape(document.cookie.substring(st,ed));
		}     
	}
	
	var setParam = "";
	
	if (value != ""){ //パラメータあるとき
		var posi = url.indexOf("?");
		if (posi > 0){ 
			setParam = setParam + "&";
		}else{
			setParam = setParam + "?";
		}
		
		if (paraname != undefined){
			var aaa = url.match(/links\/cp/);
			var bbb = url.match(/links2\/cp/);
			if (aaa || bbb){ // リダイレクタに飛ぶとき
				setParam = setParam + "pn=" + encodeURIComponent(paraname) + "&pv=";
			}else{ // 直にリダイレクトするとき
				setParam = setParam + paraname;
			}
		}
		setParam = setParam + value;
	}
	document.write('<meta http-equiv="Refresh" content="0;URL=' + url + setParam + '">');

}