
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
		$(this).parent().parent().each(function() {
		$('label',this).removeClass('checked');	
	});
	$(this).addClass('checked');
	});
});





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




