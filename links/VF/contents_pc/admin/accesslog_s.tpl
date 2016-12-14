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
		<h2 class="mngmt"><img src="/img/admin/h2_mng_tool.gif" alt="管理ツール" /></h2>

		<div id="main_contents" class="mypage">
			<h3>アクセスログ情報</h3>

			<div class="box_form">
				<table class="admin_form">
					<tr>
						<th>連番<span>*</span>:</th>
						<td>
							__s::r::pLogCD__
							__IfLogCDEmpty__<div class="err">連番のご記入は必須です。</div>__IfLogCDEmpty__
							__IfLogCDError__<div class="err">連番のご記入に誤りがあります。</div>__IfLogCDError__
						</td>
					</tr>
					<tr>
						<th>リモートアドレス<span>*</span>:</th>
						<td>
							__s::r::pRemoteIP__
							__IfRemoteIPEmpty__<div class="err">リモートアドレスのご記入は必須です。</div>__IfRemoteIPEmpty__
							__IfRemoteIPError__<div class="err">リモートアドレスのご記入に誤りがあります。</div>__IfRemoteIPError__
						</td>
					</tr>
					<tr>
						<th>アクセスページURI<span>*</span>:</th>
						<td>
							__s::r::pRequestUri__
							__IfRequestUriEmpty__<div class="err">アクセスページURIのご記入は必須です。</div>__IfRequestUriEmpty__
							__IfRequestUriError__<div class="err">アクセスページURIのご記入に誤りがあります。</div>__IfRequestUriError__
						</td>
					</tr>
					<tr>
						<th>アクセス日時<span>*</span>:</th>
						<td>
							__s::r::pAccessDate__
							__IfAccessDateEmpty__<div class="err">アクセス日時のご記入は必須です。</div>__IfAccessDateEmpty__
							__IfAccessDateError__<div class="err">アクセス日時のご記入に誤りがあります。</div>__IfAccessDateError__
						</td>
					</tr>
				</table>
			</div>
			<div class="mt10 center">
				<a href="javascript:void(0);" onclick="javascript:goPageWithCD('accesslog_c.php', __editLogCD__); return false;"><img src="/img/admin/btn_check.png" alt="確認" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPage('accesslog_l.php'); return false;"><img src="/img/admin/btn_back.png" alt="戻る" /></a>　
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