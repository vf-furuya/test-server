
/* ========== スムーススクロール ========== */


$(function(){
   // #で始まるアンカーをクリックした場合に処理
   $('a[href^=#]').click(function() {
      // スクロールの速度
      var speed = 400;// ミリ秒
      // アンカーの値取得
      var href= $(this).attr("href");
      // 移動先を取得
      var target = $(href == "#" || href == "" ? 'html' : href);
      // 移動先を数値で取得
      var position = target.offset().top;
      // スムーススクロール
      $($.browser.safari ? 'body' : 'html').animate({scrollTop:position}, speed, 'swing');
      return false;
   });
});





/* ========== ロールオーバー ========== */

function smartRollover() {
	if(document.getElementsByTagName) {
		var images = document.getElementsByTagName("img");

		for(var i=0; i < images.length; i++) {
			if(images[i].getAttribute("src").match("_off."))
			{
				images[i].onmouseover = function() {
					this.setAttribute("src", this.getAttribute("src").replace("_off.", "_on."));
				}
				images[i].onmouseout = function() {
					this.setAttribute("src", this.getAttribute("src").replace("_on.", "_off."));
				}
			}
		}
	}
}

if(window.addEventListener) {
	window.addEventListener("load", smartRollover, false);
}
else if(window.attachEvent) {
	window.attachEvent("onload", smartRollover);
}





/* ========== form画像化 ========== */

//チェックボックス
$(function(){
	//checkedだったら最初からチェックする
	$('div.check-group input').each(
		function(){
		if ($(this).attr('checked') == 'checked') {
			$(this).next().addClass('checked');
		}
	});
	//クリックした要素にクラス割り当てる
	$('div.check-group label').toggle(
		function () {
		$(this)
		.addClass('checked')
		.prev('input').attr('checked','checked');
		},
		function () {
		$(this)
		.removeClass('checked')
		.prev('input').removeAttr('checked');
		}
	);
});

//ラジオボタン
$(function(){
	var radio = $('div.radio-group');
	$('input', radio).css({'opacity': '0'})
	//checkedだったら最初からチェックする
	.each(function(){
		if ($(this).attr('checked') == 'checked') {
		$(this).next().addClass('checked');
		}
	});
		//クリックした要素にクラス割り当てる
	$('label', radio).click(function() {
		$(this).parent().parent().each(function() {
		$('label',this).removeClass('checked');	
	});
	$(this).addClass('checked');
	});
});





/* ========== 開閉パネル ========== */

$(function() {
	$('#openArea').toggle(
		function() {
		$('#moreInfo').slideDown("fast")
		$(this).text('> 条件を閉じる')
		},
		function() {
		$('#moreInfo').slideUp();
		$(this).text('> 条件を更に追加')
		}
	);
});




