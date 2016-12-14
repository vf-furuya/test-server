/* cokkie - save
--------------------------------------------------*/
var myURL = location.href;
var arr = myURL.split("add=");

var c_value = "";
if (arr.length > 1){
	c_value = arr[(arr.length-1)];
}

var c_str="";
if (c_value != ""){
	// pathの指定
	var path = location.pathname;
	var paths = new Array();
	paths = path.split("/");
	if(paths[paths.length-1] != ""){
		paths[paths.length-1] = "";
		path = paths.join("/");
	}
	path = "/";

	c_str += "landing_add_value=" + escape(c_value);
	c_str += "; path=" + path;
	
	u_str = "landing_unit_name=";
	u_str += "; path="+ path;

	p_str = "landing_punit_name=";
	p_str += "; path="+ path;

	f_str = "landing_ugf=9";
	f_str += "; path="+ path;

	document.cookie=c_str;
	document.cookie=u_str;
	document.cookie=p_str;
	document.cookie=f_str;
}
