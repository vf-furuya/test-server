var	JSleepDummyFile = './JSleep.js' ;
var	JSleepDummyIeFile = './JSleep_IE.html' ;

function	JSleep( sec ) {
	var	startTime = (new Date()).getTime() ;
	var stopTime = startTime + Math.floor(1000 * sec) ;
	for (;;) {
		var	xmlHttpObj = null ;
		if ( typeof ActiveXObject != "undefined" ) {
			var	msXml = [ 'Msxml2.XMLHTTP', 'Microsoft.XMLHTTP' ] ;
			for ( var ci=0; ci < msXml.length; ci++ ) {
				xmlHttpObj = new ActiveXObject( msXml[ci] ) ;
				if ( xmlHttpObj ) break ;
			}
		}
		else if ( typeof XMLHttpRequest != "undefined" ) {
			xmlHttpObj = new XMLHttpRequest() ;
		}
		if ( !xmlHttpObj ) break ;
		for (;;) {
			var curTime = (new Date()).getTime() ;
			if ( stopTime <= curTime ) break ;
			xmlHttpObj.open( 'GET', JSleepDummyFile + '?time=' + curTime, false ) ;
			xmlHttpObj.send( null ) ;
		}
		break ;
	}
}	//	end of JSleep()


function	JSleep_NowaitLoop( sec ) {
	var	startTime = (new Date()).getTime() ;
	var stopTime = startTime + Math.floor(1000*sec) ;
	for (;;) {
		var curTime = (new Date()).getTime() ;
		if ( stopTime <= curTime ) break ;
	}
}	//	end of JSleep_NowaitLoop()


function	JSleep_IE( sec ) {
	if ( typeof showModalDialog != 'undefined' ) {
		showModalDialog( JSleepDummyIeFile, sec, "dialogHeight:1px;dialogWidth:128px;scroll:no;resizable:no;status:no;unadorned:no;help:no;" ) ;
	}
}	//	end of JSleep_IE()