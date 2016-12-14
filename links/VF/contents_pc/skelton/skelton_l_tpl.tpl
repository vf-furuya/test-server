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
// ページ移動
function changePage(myPage) {
	document.fList.myPage.value = myPage;
	document.fList.work.value = %%_WORK_SEARCH%%;
	document.fList.action = "__FilePrefix___l.php";
	document.fList.submit(true);
	return false;
}
// ソート指定
function changeSort(sortBy) {
	var NowSortBy = document.fList.SortBy.value;
	if (NowSortBy == sortBy) sortBy++;
	document.fList.SortBy.value = sortBy;
	document.fList.work.value = %%_WORK_SEARCH%%;
	document.fList.action = "__FilePrefix___l.php";
	document.fList.submit(true);
	return false;
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
			<h3>__TableTitle__</h3>

			%%IfPaging%%
			<ul id="pagination-digg">
				%%IfNoToPre%%<li><span class="previous"><<前へ</span></li>%%IfNoToPre%%
				%%IfToPre%%<li><span><a href="javascript:void(0);"  onclick="javascript:changePage(%%PreviousPage%%); return false;" class="previous"><<前へ</a></span></li>%%IfToPre%%
				%%PageListLoop%%
				%%IfMyPage%%<li class="current">%%PageNum%%</li>%%IfMyPage%%
				%%IfNoMyPage%%<li><a href="javascript:void(0);" onclick="javascript:changePage(%%PageNum%%); return false;">%%PageNum%%</a></li>%%IfNoMyPage%%
				%%PageListLoop%%
				%%IfToNext%%<li><span><a href="javascript:void(0);"  onclick="javascript:changePage(%%NextPage%%); return false;" class="next">次へ>></a></span></li>%%IfToNext%%
				%%IfNoToNext%%<li><span class="next">次へ>></span></li>%%IfNoToNext%%
			</ul>
			%%IfPaging%%
			<div>%%n::CountOfAll%%件中　%%n::CountFrom%%〜%%n::CountTo%%件を表示</div>
			<div class="mt-18 right"><a href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('__FilePrefix___s.php', -1, %%_WORK_NEW%%); return false;"><img src="/img/admin/btn_newcreation_small.png"></a></div>

			<div class="box-container">
				<table class="table-long">
					<thead>
						<tr>
__ListLoop__							<td class="left" nowrap><a href="javascript:void(0);" onclick="javascript:changeSort(__SortNo1__); return false;">__ListColumnTitle__</a></td>
__ListLoop__							<td class="w60 center" nowrap>アクション</td>
						</tr>
					</thead>
					<tbody>
%%IfResults%%%%__ClassName__ListLoop%%
						<tr>
__ListLoop__							<td class="left">%%s::r::__ListColumnName__%%</td>
__ListLoop__							<td class="center">
								<a class="pr5 tipsy_s" original-title="編集" href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('__FilePrefix___s.php', %%__PrimaryKey__%%, %%_WORK_EDIT%%); return false;"><img src="/img/admin/icon-edit.gif" alt="編集" /></a>
								<a class="pr5 tipsy_s" original-title="削除" href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('__FilePrefix___c.php', %%__PrimaryKey__%%, %%_WORK_DELETE%%); return false;"><img src="/img/admin/icon-delete.gif" alt="削除" /></a>
							</td>
						</tr>
%%__ClassName__ListLoop%%
%%IfResults%%
%%IfNoResults%%
						<tr>
							<td colspan="__Colspan__"><div class="list_err">該当するデータは見付かりませんでした。</div></td>
						</tr>
%%IfNoResults%%
					</tbody>
				</table>

				<div class="mt5 right"><a href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('__FilePrefix___s.php', -1, %%_WORK_NEW%%); return false;"><img src="/img/admin/btn_newcreation_small.png"></a></div>
				%%IfPaging%%
				<ul id="pagination-digg" class="mt-5">
					%%IfNoToPre%%<li><span class="previous"><<前へ</span></li>%%IfNoToPre%%
					%%IfToPre%%<li><span><a href="javascript:void(0);"  onclick="javascript:changePage(%%PreviousPage%%); return false;" class="previous"><<前へ</a></span></li>%%IfToPre%%
					%%PageListLoop%%
					%%IfMyPage%%<li class="current">%%PageNum%%</li>%%IfMyPage%%
					%%IfNoMyPage%%<li><a href="javascript:void(0);" onclick="javascript:changePage(%%PageNum%%); return false;">%%PageNum%%</a></li>%%IfNoMyPage%%
					%%PageListLoop%%
					%%IfToNext%%<li><span><a href="javascript:void(0);"  onclick="javascript:changePage(%%NextPage%%); return false;" class="next">次へ>></a></span></li>%%IfToNext%%
					%%IfNoToNext%%<li><span class="next">次へ>></span></li>%%IfNoToNext%%
				</ul>
				%%IfPaging%%
			</div><!-- end of div.box-container -->
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