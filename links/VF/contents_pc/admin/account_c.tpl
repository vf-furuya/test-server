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
	document.fList.editAccountCD.value = CD;
	document.fList.action = pgAct;
	document.fList.submit(true);
}
// コードを伴ったプログラム移動
function goPageWithCDandWork(pgAct, CD, tmp) {
	document.fList.editAccountCD.value = CD;
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
		<h2 class="mngmt"><img src="img/admin/h2_mng_tool.gif" alt="管理ツール" /></h2>

		<div id="main_contents" class="mypage">
			<h3>管理アカウントマスタ情報</h3>

			<div class="box_form">
				<table class="admin_form">
					<tr>
						<th>アカウントCD<span>*</span>:</th>
						<td>__s::r::pAccountCD__</td>
					</tr>
					<tr>
						<th>名前<span>*</span>:</th>
						<td>__s::r::pAccountName__</td>
					</tr>
					<tr>
						<th>メールアドレス<span>*</span>:</th>
						<td>__s::r::pEMail__</td>
					</tr>
					<tr>
						<th>アカウントID<span>*</span>:</th>
						<td>__s::r::pAccountID__</td>
					</tr>
					<tr>
						<th>パスワード<span>*</span>:</th>
						<td>__s::r::pAccountPW__</td>
					</tr>
					<tr>
						<th>認証キー<span>*</span>:</th>
						<td>__s::r::pAccountKey__</td>
					</tr>
<!--
					<tr>
						<th>権限<span>*</span>:</th>
						<td>__s::r::pAuthority__</td>
					</tr>
					<tr>
						<th>ログイン禁止<span>*</span>:</th>
						<td>__s::r::pDisabled__</td>
					</tr>
					<tr>
						<th>削除フラグ<span>*</span>:</th>
						<td>__s::r::pDelFlag__</td>
					</tr>
					<tr>
						<th>削除日時<span>*</span>:</th>
						<td>__s::r::pDelDate__</td>
					</tr>
					<tr>
						<th>作成日時<span>*</span>:</th>
						<td>__s::r::pCreateDate__</td>
					</tr>
					<tr>
						<th>更新日時<span>*</span>:</th>
						<td>__s::r::pUpdateDate__</td>
					</tr>
-->
				</table>
			</div>
__IfDelete__
			<div class="mt30 mb30 b center">こちらのデータを削除してもよろしいですか？</div>
__IfDelete__
			<div class="mt10 center">
__IfComplete__
				<a href="javascript:void(0);" onclick="javascript:goPageWithCD('account_e.php', __editAccountCD__); return false;"><img src="img/admin/btn_save.png" alt="登録" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPageWithWork('account_s.php', ___WORK_BACK__); return false;"><img src="img/admin/btn_back.png" alt="戻る" /></a>　
__IfComplete__
__IfDelete__
				<a href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('account_e.php', __editAccountCD__, ___WORK_DELETE__); return false;"><img src="img/admin/btn_delet.png" alt="削除" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPage('account_l.php'); return false;"><img src="img/admin/btn_back.png" alt="戻る" /></a>　
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