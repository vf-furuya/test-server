
/* ========== �X���[�X�X�N���[�� ========== */


$(function(){
   // #�Ŏn�܂�A���J�[���N���b�N�����ꍇ�ɏ���
   $('a[href^=#]').click(function() {
      // �X�N���[���̑��x
      var speed = 400;// �~���b
      // �A���J�[�̒l�擾
      var href= $(this).attr("href");
      // �ړ�����擾
      var target = $(href == "#" || href == "" ? 'html' : href);
      // �ړ���𐔒l�Ŏ擾
      var position = target.offset().top;
      // �X���[�X�X�N���[��
      $($.browser.safari ? 'body' : 'html').animate({scrollTop:position}, speed, 'swing');
      return false;
   });
});





/* ========== ���[���I�[�o�[ ========== */

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





/* ========== form�摜�� ========== */

//�`�F�b�N�{�b�N�X
$(function(){
	//checked��������ŏ�����`�F�b�N����
	$('div.check-group input').each(
		function(){
		if ($(this).attr('checked') == 'checked') {
			$(this).next().addClass('checked');
		}
	});
	//�N���b�N�����v�f�ɃN���X���蓖�Ă�
	$('div.check-group label').toggle(
		function () {
			//netacti add start
			var ckstr=$(this).html();
			if (ckstr.indexOf('linkurl1')>0){
				location.href='http://cashing-ex.net/search_result/?sort=&refine-top=refine-top-1';
			}else if (ckstr.indexOf('linkurl2')>0){
				location.href='http://cashing-ex.net/search_result/?sort=&refine-top=refine-top-2';
			}else if (ckstr.indexOf('linkurl3')>0){
				location.href='http://cashing-ex.net/search_result/?sort=&refine-top=refine-top-3';
			}else if (ckstr.indexOf('linkurl4')>0){
				location.href='http://cashing-ex.net/search_result/?sort=&refine-top=refine-top-4';
			}else{
			//netacti add end
				$(this)
				.addClass('checked')
				.prev('input').attr('checked','checked');
			//netacti add start
			}
			//netacti add end
		},
		function () {
		$(this)
		.removeClass('checked')
		.prev('input').removeAttr('checked');
		}
	);
});

//���W�I�{�^��
$(function(){
	var radio = $('div.radio-group');
	$('input', radio).css({'opacity': '0'})
	//checked��������ŏ�����`�F�b�N����
	.each(function(){
		if ($(this).attr('checked') == 'checked') {
		$(this).next().addClass('checked');
		}
	});
		//�N���b�N�����v�f�ɃN���X���蓖�Ă�
	$('label', radio).click(function() {
	//netacti add start
	var delflg=false;
	var ckstr=$(this).html();
	for(i=0;i<5;i++){
		if (document.fms.shinsa[i].checked){
			if (document.getElementById("lbl_"+document.fms.shinsa[i].value).innerHTML==ckstr){
				delflg=true;
				setTimeout("fnc_delradio(document.fms.shinsa["+i+"])", 200);
			}
		}
	}
	for(i=0;i<5;i++){
		if (document.fms.gendo[i].checked){
			if (document.getElementById("lbl_"+document.fms.gendo[i].value).innerHTML==ckstr){
				delflg=true;
				setTimeout("fnc_delradio(document.fms.gendo["+i+"])", 200);
			}
		}
	}
	for(i=0;i<5;i++){
		if (document.fms.shinsa[i].checked){
			if (document.getElementById("lbl_"+document.fms.shinsa[i].value).innerHTML==ckstr){
				delflg=true;
				setTimeout("fnc_delradio(document.fms.shinsa["+i+"])", 200);
			}
		}
	}
	for(i=0;i<5;i++){
		if (document.fms.kinri[i].checked){
			if (document.getElementById("lbl_"+document.fms.kinri[i].value).innerHTML==ckstr){
				delflg=true;
				setTimeout("fnc_delradio(document.fms.kinri["+i+"])", 200);
			}
		}
	}
	for(i=0;i<4;i++){
		if (document.fms.meyasu[i].checked){
			if (document.getElementById("lbl_"+document.fms.meyasu[i].value).innerHTML==ckstr){
				delflg=true;
				setTimeout("fnc_delradio(document.fms.meyasu["+i+"])", 200);
			}
		}
	}
	for(i=0;i<2;i++){
		if (document.fms.kikan[i].checked){
			if (document.getElementById("lbl_"+document.fms.kikan[i].value).innerHTML==ckstr){
				delflg=true;
				setTimeout("fnc_delradio(document.fms.kikan["+i+"])", 200);
			}
		}
	}
	//netacti add end
		$(this).parent().parent().each(function() {
		$('label',this).removeClass('checked');	
	});
	//$(this).addClass('checked'); netacti comment
	//netacti add start
	if (delflg==false)$(this).addClass('checked');
	//netacti add end
	});
});

//netacti add start
function fnc_delradio(nm){
	nm.checked=false;
}
//netacti add end


/* ========== �J�p�l�� ========== */

$(function() {
	$('#openArea').toggle(
		function() {
		$('#moreInfo').slideDown("fast")
		$(this).text('> ���������')
		},
		function() {
		$('#moreInfo').slideUp();
		$(this).text('> �������X�ɒǉ�')
		}
	);
});

