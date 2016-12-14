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
	document.fList.editSiteCD.value = CD;
	document.fList.action = pgAct;
	document.fList.submit(true);
}
// コードを伴ったプログラム移動
function goPageWithCDandWork(pgAct, CD, tmp) {
	document.fList.editSiteCD.value = CD;
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
			<h3>サイト管理マスタ情報</h3>
__IfLinkUrlExists__
				<table class="admin_form">
					<tr>
						<th>リンク先:</th>
						<td>
							<textarea name="">__pLinkUrl__</textarea>
						</td>
					</tr>
				</table>
__IfLinkUrlExists__

			<div class="box_form">
				<table class="admin_form">
					<tr>
						<th>管理番号<span>*</span>:</th>
						<td>
							__s::r::pSiteCD__
						</td>
					</tr>
__IfAdminRoot__
					<tr>
						<th>アカウントCD<span>*</span>:</th>
						<td>
							<select name="wAccouontCD">__AccouontListLoop__<option value="__AccouontListValue__"__AccouontListSelected__>__AccouontListName__</option>__AccouontListLoop__
							</select>
						</td>
					</tr>
__IfAdminRoot__
					<tr>
						<th>サイトインデックスNo<span>*</span>:</th>
						<td>
							<select name="wSiteIndex">__SiteIndexLoop__<option value="__SiteIndexValue__"__SiteIndexSelected__>__SiteIndexName__</option>__SiteIndexLoop__
							</select>
							__IfSiteIndexEmpty__<div class="err">サイトインデックスNoのご記入は必須です。</div>__IfSiteIndexEmpty__
							__IfSiteIndexError__<div class="err">サイトインデックスNoのご記入に誤りがあります。</div>__IfSiteIndexError__
						</td>
					</tr>
					<tr>
						<th>サイト名<span>*</span>:</th>
						<td>
							<input type="text" name="wSiteName" value="__s::r::pSiteName__" />
							__IfRedirectUrlEmpty__<div class="err">サイト名のご記入は必須です。</div>__IfRedirectUrlEmpty__
							__IfRedirectUrlError__<div class="err">サイト名のご記入に誤りがあります。</div>__IfRedirectUrlError__
						</td>
					</tr>
					<tr>
						<th>リダイレクト先<span>*</span>:</th>
						<td>
							<input type="text" name="wRedirectUrl" value="__s::r::pRedirectUrl__" />
							__IfRedirectUrlEmpty__<div class="err">リダイレクト先のご記入は必須です。</div>__IfRedirectUrlEmpty__
							__IfRedirectUrlError__<div class="err">リダイレクト先のご記入に誤りがあります。</div>__IfRedirectUrlError__
						</td>
					</tr>
<!--
					<tr>
						<th>リダイレクト深度<span>*</span>:</th>
						<td>
							<select name="wRedirectDepth">__RedirectDepthLoop__<option value="__RedirectDepthValue__"__RedirectDepthSelected__>__RedirectDepthName__</option>__RedirectDepthLoop__
							</select>
							__IfRedirectDepthEmpty__<div class="err">リダイレクト深度のご記入は必須です。</div>__IfRedirectDepthEmpty__
							__IfRedirectDepthError__<div class="err">リダイレクト深度のご記入に誤りがあります。</div>__IfRedirectDepthError__
						</td>
					</tr>
					<tr>
						<th>リダイレクト用UID<span>*</span>:</th>
						<td>
							<input type="text" name="wUID" value="__s::r::pUID__" />
							__IfUIDEmpty__<div class="err">リダイレクト用UIDのご記入は必須です。</div>__IfUIDEmpty__
							__IfUIDError__<div class="err">リダイレクト用UIDのご記入に誤りがあります。</div>__IfUIDError__
						</td>
					</tr>
					<tr>
						<th>利用禁止<span>*</span>:</th>
						<td>
							<input type="text" name="wDisabled" value="__s::r::pDisabled__" />
							__IfDisabledEmpty__<div class="err">利用禁止のご記入は必須です。</div>__IfDisabledEmpty__
							__IfDisabledError__<div class="err">利用禁止のご記入に誤りがあります。</div>__IfDisabledError__
						</td>
					</tr>
-->

					<tr>
						<th>タグ<span></span>:</th>
						<td>
							<div id="TagEdit">
								<table id="TagEditTable">
__TagListLoop__
									<tr>
										<td class="TagIndex">__TagIndex__</td>
									</tr>
									<tr>
										<td><textarea name="wTag[__TagIndex__]" id="wTag__TagIndex__">__s::Tag__</textarea>
												<p><input type="checkbox" name="wHeadFlag[__TagIndex__]" id="wHeadFlag__TagIndex__" value="1"__HeadFlagSelected__><label for="wHeadFlag__TagIndex__" >&lt;head&gt;内に配置する</label></p>
										</td>
									</tr>
__TagListLoop__
								</table>
							</div>
						</td>
					</tr>

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
				<a href="javascript:void(0);" onclick="javascript:goPageWithCD('site_c.php', __editSiteCD__); return false;"><img src="img/admin/btn_check.png" alt="確認" /></a>　
				<a href="javascript:void(0);" onclick="javascript:goPage('site_l.php'); return false;"><img src="img/admin/btn_back.png" alt="戻る" /></a>　
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