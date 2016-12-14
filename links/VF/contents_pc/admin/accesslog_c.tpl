<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>___SITE_TITLE__</title>
<meta name="Author" content="IT Trend" />
<meta name="Copyright" content="&amp;IT Trend" />
__i::admin/_head.tpl__
<script language=javascript>
<!-- Hide script from old browser
// コードを伴ったプログラム移動
function goPageWithCD(pgAct, CD) {
	document.fList.editLogCD.value = CD;
	document.fList.action = pgAct;
	document.fList.submit(true);
}
// コードを伴ったプログラム移動
function goPageWithCDandWork(pgAct, CD, tmp) {
	document.fList.editLogCD.value = CD;
	document.fList.work.value = tmp;
	document.fList.action = pgAct;
	document.fList.submit(true);
}
// end hiding -->
</script>
</head>

<body id="no_gnavi">
<form name="fList" action="" method="post">

<div id="wrapper">
	__i::admin/_header.tpl__

	<div id="contents" class="clearfix">
		<h2 class="mngmt"><img src="../img/admin/h2_mng_tool.gif" alt="管理ツール" /></h2>

		<div id="main_contents" class="mypage">
			<h3>アクセスログ情報</h3>

			<div class="box_form">
				<table class="admin_form">
					<tr>
						<th>連番<span>*</span>:</th>
						<td>__s::r::pLogCD__</td>
					</tr>
					<tr>
						<th>リモートアドレス<span>*</span>:</th>
						<td>__s::r::pRemoteIP__</td>
					</tr>
					<tr>
						<th>アクセスページURI<span>*</span>:</th>
						<td>__s::r::pRequestUri__</td>
					</tr>
					<tr>
						<th>アクセス日時<span>*</span>:</th>
						<td>__s::r::pAccessDate__</td>
					</tr>
				</table>
			</div>
__IfDelete__
			<div class="mt30 mb30 b center">こちらのデータを削除してもよろしいですか？</div>
__IfDelete__
			<div class="mt10 center">
__IfComplete__
				<a href="javascript:void(0);" onclick="javascript:goPageWithCD('accesslog_e.php', __editLogCD__); return false;"><img src="../img/admin/btn_save.png" alt="登録" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPageWithWork('accesslog_s.php', ___WORK_BACK__); return false;"><img src="../img/admin/btn_back.png" alt="戻る" /></a>　
__IfComplete__
__IfDelete__
				<a href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('accesslog_e.php', __editLogCD__, ___WORK_DELETE__); return false;"><img src="../img/admin/btn_delet.png" alt="削除" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPage('accesslog_l.php'); return false;"><img src="../img/admin/btn_back.png" alt="戻る" /></a>　
__IfDelete__
			</div>
		</div><!--main_contents -->

		<div id="sub_contents"><!--box_data-demand -->
			__IfAdminRoot____i::admin/_sidemenu_admin_root.tpl____IfAdminRoot__
			__IfAdmin____i::admin/_sidemenu_admin.tpl____IfAdmin__
			__IfClient____i::admin/_sidemenu_client.tpl____IfClient__
			__IfCreator____i::admin/_sidemenu_creator.tpl____IfCreator__
			__IfDummy____i::admin/_sidemenu_dummy.tpl____IfDummy__
		</div><!--sub_contents --> 

	</div><!--contents -->
	__i::admin/_footer.tpl__

</div><!--wrapper -->
__HiddenValues__
</form>
</body>
</html>