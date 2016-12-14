var cookiefobj;
var CookieName = "shoroji";
//----------------------------------------------------------------------------
// クッキーの保存。
function setCookieAll(form, field) {
  var bufCookie = CookieName +'=';
  delCookie(bufCookie);
  for (var i = 0; i < field.length; i++) {
//    alert(form.name);
    bufStr      = '';
    cookiefobj  = form.elements[field[i]];
    if (cookiefobj != null) {
      bufStr = cookiefobj.value;
//      alert(cookiefobj.name + ":" + bufStr);
    }
    bufCookie +=  field[i] +"=" + escape(bufStr) + "%00";
  }
  document.cookie = bufCookie 
                  + ";expires=Fri, 31-Dec-2030 23:59:59"
                  + ";path=/"
                  + ";";
//  alert(document.cookie);
//  alert( "Cookieに保存しました。");
}

//----------------------------------------------------------------------------
// クッキーの読込。
function getCookieAll(form, field) {
//  alert('cookie: ' + document.cookie);
  for (var i = 0; i < field.length; i++) {
    cookiefobj = form.elements[field[i]];
    if (cookiefobj != null) {
      cookiefobj.value = getCookie(field[i]);
//    if (cookiefobj.value.length > 0) 
//    { alert(field[i] + ": " + cookiefobj.value); }
    }
  }
}

//----------------------------------------------------------------------------
function getCookie(key){
  tmp = document.cookie+";";
  tmp1 = tmp.indexOf(key, tmp.indexOf(CookieName, 0));
  if(tmp1 != -1){
    tmp = tmp.substring(tmp1,tmp.length);
    start = tmp.indexOf("=",0);
    end = tmp.indexOf("%00",start);
    return(unescape(tmp.substring(start+1,end)));
  }
  return("");
}

function delCookie(key){
  expiredate = new Date();
  expiredate.setYear(expiredate.getYear()-1);
  tmp = key+"=;";
  tmp += "expires="+expiredate.toGMTString();
  document.cookie = tmp;
}
