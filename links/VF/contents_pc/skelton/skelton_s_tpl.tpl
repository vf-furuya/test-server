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
						<td>
							__IfShow__%%s::r::p__ColumnName__%%
							__IfShow____IfTextBox__<input type="text" name="w__ColumnName__" value="%%s::w__ColumnName__%%" class="__IMEMode__">
							__IfTextBox____IfTextArea__<textarea name="w__ColumnName__" cols="__TBSize__" rows="3" class="__IMEMode__">%%s::w__ColumnName__%%</textarea>
							__IfTextArea____IfRadio__%%__ColumnName__Loop%%<input type="radio" name="w__ColumnName__" value="%%__ColumnName__Value%%" %%__ColumnName__Checked%%>%%__ColumnName__%%　
							%%__ColumnName__Loop%%__IfRadio____IfCheckbox__%%__ColumnName__Loop%%<input type="checkbox" name="w__ColumnName__[]" value="%%__ColumnName__Value%%" %%__ColumnName__Checked%%>%%__ColumnName__%%　
							%%__ColumnName__Loop%%__IfCheckbox____IfSelect__<select name="w__ColumnName__">
							%%__ColumnName__Loop%%<option value="%%__ColumnName__Value%%"%%__ColumnName__Selected%%>%%__ColumnName__%%
							%%__ColumnName__Loop%%</select>
							__IfSelect____IfTimestamp__<input type="text" name="w__ColumnName__Year" value="%%s::w__ColumnName__Year%%" size="6" maxlength="4" class="imeoff"> 年 
							<input type="text" name="w__ColumnName__Month" value="%%s::w__ColumnName__Month%%" size="6" maxlength="2" class="imeoff"> 月 
							<input type="text" name="w__ColumnName__Day" value="%%s::w__ColumnName__Day%%" size="6" maxlength="2" class="imeoff"> 日　
							<input type="text" name="w__ColumnName__Hour" value="%%s::w__ColumnName__Hour%%" size="6" maxlength="2" class="imeoff"> 時
							<input type="text" name="w__ColumnName__Minute" value="%%s::w__ColumnName__Minute%%" size="6" maxlength="2" class="imeoff">分
							__IfTimestamp____IfTimestamp2__<input type="text" name="w__ColumnName__Year" value="%%s::w__ColumnName__Year%%" size="6" maxlength="4" class="imeoff"> 年 
							<input type="text" name="w__ColumnName__Month" value="%%s::w__ColumnName__Month%%" size="6" maxlength="2" class="imeoff"> 月 
							<input type="text" name="w__ColumnName__Day" value="%%s::w__ColumnName__Day%%" size="6" maxlength="2" class="imeoff"> 日　
							<input type="text" name="w__ColumnName__Hour" value="%%s::w__ColumnName__Hour%%" size="6" maxlength="2" class="imeoff"> 時
							<input type="text" name="w__ColumnName__Minute" value="%%s::w__ColumnName__Minute%%" size="6" maxlength="2" class="imeoff">分
							<input type="text" name="w__ColumnName__Second" value="%%s::w__ColumnName__Second%%" size="6" maxlength="2" class="imeoff">秒
							__IfTimestamp2____IfDate__<input type="text" name="w__ColumnName__Year" value="%%s::w__ColumnName__Year%%" size="6" maxlength="4" class="imeoff"> 年 
							<input type="text" name="w__ColumnName__Month" value="%%s::w__ColumnName__Month%%" size="6" maxlength="2" class="imeoff"> 月 
							<input type="text" name="w__ColumnName__Day" value="%%s::w__ColumnName__Day%%" size="6" maxlength="2" class="imeoff"> 日
							__IfDate__%%If__ColumnName__Empty%%<div class="err">__ColumnTitle__のご記入は必須です。</div>%%If__ColumnName__Empty%%
							%%If__ColumnName__Error%%<div class="err">__ColumnTitle__のご記入に誤りがあります。</div>%%If__ColumnName__Error%%
						</td>
					</tr>
__LinesLoop__				</table>
			</div>
			<div class="mt10 center">
				<a href="javascript:void(0);" onclick="javascript:goPageWithCD('__FilePrefix___c.php', %%edit__PrimaryKey__%%); return false;"><img src="/img/admin/btn_check.png" alt="確認" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPage('__FilePrefix___l.php'); return false;"><img src="/img/admin/btn_back.png" alt="戻る" /></a>　
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