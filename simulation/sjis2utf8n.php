<?php
	/* �ǂݍ��񂾃t�@�C����SJIS -> UTF-8N�ɕϊ� */
	//echo $_GET['file'];
	header("Content-Type: text/html; charset=UTF-8");
	
	$_ = file_get_contents($_GET['file']);
	mb_convert_variables('UTF-8', 'SJIS', $_);
	//$_ = 'A';
	echo $_;
?>