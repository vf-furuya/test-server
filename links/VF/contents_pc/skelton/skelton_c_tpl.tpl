<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>%%_SITE_TITLE%%</title>
<meta name="Author" content="IT Trend" />
<meta name="Copyright" content="&amp;IT Trend" />
%%i::admin/_head.tpl%%
<script language=javascript>
<!-- Hide script from old browser
// コードを伴ったプログラム移動
function goPageWithCD(pgAct, CD) {
	document.fList.edit__PrimaryKey__.value = CD;
	document.fList.action = pgAct;
	document.fList.submit(true);
}
// コードを伴ったプログラム移動
function goPageWithCDandWork(pgAct, CD, tmp) {
	document.fList.edit__PrimaryKey__.value = CD;
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
	%%i::admin/_header.tpl%%

	<div id="contents" class="clearfix">
		<h2 class="mngmt"><img src="/img/admin/h2_mng_tool.gif" alt="管理ツール" /></h2>

		<div id="main_contents" class="mypage">
			<h3>__TableTitle__情報</h3>

			<div class="box_form">
				<table class="admin_form">
__LinesLoop__					<tr>
						<th>__ColumnTitle__<span>*</span>:</th>
						<td>%%s::r::p__ColumnName__%%</td>
					</tr>
__LinesLoop__				</table>
			</div>
%%IfDelete%%
			<div class="mt30 mb30 b center">こちらのデータを削除してもよろしいですか？</div>
%%IfDelete%%
			<div class="mt10 center">
%%IfComplete%%
				<a href="javascript:void(0);" onclick="javascript:goPageWithCD('__FilePrefix___e.php', %%edit__PrimaryKey__%%); return false;"><img src="/img/admin/btn_save.png" alt="登録" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPageWithWork('__FilePrefix___s.php', %%_WORK_BACK%%); return false;"><img src="/img/admin/btn_back.png" alt="戻る" /></a>　
%%IfComplete%%
%%IfDelete%%
				<a href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('__FilePrefix___e.php', %%edit__PrimaryKey__%%, %%_WORK_DELETE%%); return false;"><img src="/img/admin/btn_delet.png" alt="削除" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPage('__FilePrefix___l.php'); return false;"><img src="/img/admin/btn_back.png" alt="戻る" /></a>　
%%IfDelete%%
			</div>
		</div><!--main_contents -->

		<div id="sub_contents"><!--box_data-demand -->
			%%IfAdminRoot%%%%i::admin/_sidemenu_admin_root.tpl%%%%IfAdminRoot%%
			%%IfAdmin%%%%i::admin/_sidemenu_admin.tpl%%%%IfAdmin%%
			%%IfClient%%%%i::admin/_sidemenu_client.tpl%%%%IfClient%%
			%%IfCreator%%%%i::admin/_sidemenu_creator.tpl%%%%IfCreator%%
			%%IfDummy%%%%i::admin/_sidemenu_dummy.tpl%%%%IfDummy%%
		</div><!--sub_contents --> 

	</div><!--contents -->
	%%i::admin/_footer.tpl%%

</div><!--wrapper -->
%%HiddenValues%%
</form>
</body>
</html>