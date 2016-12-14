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
// ページ移動
function changePage(myPage) {
	document.fList.myPage.value = myPage;
	document.fList.work.value = ___WORK_SEARCH__;
	document.fList.action = "accesslog_l.php";
	document.fList.submit(true);
	return false;
}
// ソート指定
function changeSort(sortBy) {
	var NowSortBy = document.fList.SortBy.value;
	if (NowSortBy == sortBy) sortBy++;
	document.fList.SortBy.value = sortBy;
	document.fList.work.value = ___WORK_SEARCH__;
	document.fList.action = "accesslog_l.php";
	document.fList.submit(true);
	return false;
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
			<h3>アクセスログ</h3>

			__IfPaging__
			<ul id="pagination-digg">
				__IfNoToPre__<li><span class="previous"><<前へ</span></li>__IfNoToPre__
				__IfToPre__<li><span><a href="javascript:void(0);"  onclick="javascript:changePage(__PreviousPage__); return false;" class="previous"><<前へ</a></span></li>__IfToPre__
				__PageListLoop__
				__IfMyPage__<li class="current">__PageNum__</li>__IfMyPage__
				__IfNoMyPage__<li><a href="javascript:void(0);" onclick="javascript:changePage(__PageNum__); return false;">__PageNum__</a></li>__IfNoMyPage__
				__PageListLoop__
				__IfToNext__<li><span><a href="javascript:void(0);"  onclick="javascript:changePage(__NextPage__); return false;" class="next">次へ>></a></span></li>__IfToNext__
				__IfNoToNext__<li><span class="next">次へ>></span></li>__IfNoToNext__
			</ul>
			__IfPaging__
			<div>__n::CountOfAll__件中　__n::CountFrom__〜__n::CountTo__件を表示</div>
			<div class="mt-18 right"><a href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('accesslog_s.php', -1, ___WORK_NEW__); return false;"><img src="/img/admin/btn_newcreation_small.png"></a></div>

			<div class="box-container">
				<table class="table-long">
					<thead>
						<tr>
							<td class="w60 center" nowrap>アクション</td>
						</tr>
					</thead>
					<tbody>
__IfResults____AccessLogListLoop__
						<tr>
							<td class="center">
								<a class="pr5 tipsy_s" original-title="編集" href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('accesslog_s.php', __LogCD__, ___WORK_EDIT__); return false;"><img src="/img/admin/icon-edit.gif" alt="編集" /></a>
								<a class="pr5 tipsy_s" original-title="削除" href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('accesslog_c.php', __LogCD__, ___WORK_DELETE__); return false;"><img src="/img/admin/icon-delete.gif" alt="削除" /></a>
							</td>
						</tr>
__AccessLogListLoop__
__IfResults__
__IfNoResults__
						<tr>
							<td colspan="2"><div class="list_err">該当するデータは見付かりませんでした。</div></td>
						</tr>
__IfNoResults__
					</tbody>
				</table>

				<div class="mt5 right"><a href="javascript:void(0);" onclick="javascript:goPageWithCDandWork('accesslog_s.php', -1, ___WORK_NEW__); return false;"><img src="/img/admin/btn_newcreation_small.png"></a></div>
				__IfPaging__
				<ul id="pagination-digg" class="mt-5">
					__IfNoToPre__<li><span class="previous"><<前へ</span></li>__IfNoToPre__
					__IfToPre__<li><span><a href="javascript:void(0);"  onclick="javascript:changePage(__PreviousPage__); return false;" class="previous"><<前へ</a></span></li>__IfToPre__
					__PageListLoop__
					__IfMyPage__<li class="current">__PageNum__</li>__IfMyPage__
					__IfNoMyPage__<li><a href="javascript:void(0);" onclick="javascript:changePage(__PageNum__); return false;">__PageNum__</a></li>__IfNoMyPage__
					__PageListLoop__
					__IfToNext__<li><span><a href="javascript:void(0);"  onclick="javascript:changePage(__NextPage__); return false;" class="next">次へ>></a></span></li>__IfToNext__
					__IfNoToNext__<li><span class="next">次へ>></span></li>__IfNoToNext__
				</ul>
				__IfPaging__
			</div><!-- end of div.box-container -->
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