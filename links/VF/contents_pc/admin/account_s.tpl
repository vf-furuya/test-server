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
						<td>
							__s::r::pAccountCD__
						</td>
					</tr>
					<tr>
						<th>名前<span>*</span>:</th>
						<td>
							<input type="text" name="wAccountName" value="__s::r::pAccountName__" />
							__IfAccountNameEmpty__<div class="err">名前のご記入は必須です。</div>__IfAccountNameEmpty__
							__IfAccountNameError__<div class="err">名前のご記入に誤りがあります。</div>__IfAccountNameError__
						</td>
					</tr>
					<tr>
						<th>メールアドレス<span>*</span>:</th>
						<td>
							<input type="text" name="wEMail" value="__s::r::pEMail__" />
							__IfEMailEmpty__<div class="err">メールアドレスのご記入は必須です。</div>__IfEMailEmpty__
							__IfEMailError__<div class="err">メールアドレスのご記入に誤りがあります。</div>__IfEMailError__
						</td>
					</tr>
					<tr>
						<th>アカウントID<span>*</span>:</th>
						<td>
							<input type="text" name="wAccountID" value="__s::r::pAccountID__" />
							__IfAccountIDEmpty__<div class="err">アカウントIDのご記入は必須です。</div>__IfAccountIDEmpty__
							__IfAccountIDError__<div class="err">アカウントIDのご記入に誤りがあります。</div>__IfAccountIDError__
						</td>
					</tr>
					<tr>
						<th>パスワード<span>*</span>:</th>
						<td>
							<input type="text" name="wAccountPW" value="__s::r::pAccountPW__" />
							__IfAccountPWEmpty__<div class="err">パスワードのご記入は必須です。</div>__IfAccountPWEmpty__
							__IfAccountPWError__<div class="err">パスワードのご記入に誤りがあります。</div>__IfAccountPWError__
						</td>
					</tr>
					<tr>
						<th>認証キー<span>*</span>:</th>
						<td>
							<input type="text" name="wAccountKey" value="__s::r::pAccountKey__" />
							__IfAccountKeyEmpty__<div class="err">認証キーのご記入は必須です。</div>__IfAccountKeyEmpty__
							__IfAccountKeyError__<div class="err">認証キーのご記入に誤りがあります。</div>__IfAccountKeyError__
						</td>
					</tr>
<!--
					<tr>
						<th>権限<span>*</span>:</th>
						<td>
							<select name="wAuthority">__AuthListLoop__<option value="__s::r::AuthValue__" __AuthRootChecked__>__s::r::AuthName__</option>　__AuthListLoop__
							__IfAuthorityEmpty__<div class="err">権限のご記入は必須です。</div>__IfAuthorityEmpty__
							__IfAuthorityError__<div class="err">権限のご記入に誤りがあります。</div>__IfAuthorityError__
						</td>
					</tr>
					<tr>
						<th>ログイン禁止<span>*</span>:</th>
						<td>
							<input type="checkbox" name="wDisabled" value="1" __DisabledChecked__/>
							__IfDisabledEmpty__<div class="err">ログイン禁止のご記入は必須です。</div>__IfDisabledEmpty__
							__IfDisabledError__<div class="err">ログイン禁止のご記入に誤りがあります。</div>__IfDisabledError__
						</td>
					</tr>
-->
					<tr>
						<th>作成日時<span>*</span>:</th>
						<td>
							__s::r::pCreateDate__
						</td>
					</tr>
					<tr>
						<th>更新日時<span>*</span>:</th>
						<td>
							__s::r::pUpdateDate__
						</td>
					</tr>
				</table>
			</div>
			<div class="mt10 center">
				<a href="javascript:void(0);" onclick="javascript:goPageWithCD('account_c.php', __editAccountCD__); return false;"><img src="img/admin/btn_check.png" alt="確認" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPage('account_l.php'); return false;"><img src="img/admin/btn_back.png" alt="戻る" /></a>　
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