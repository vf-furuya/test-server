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
	document.fList.editID.value = CD;
	document.fList.action = pgAct;
	document.fList.submit(true);
}
// コードを伴ったプログラム移動
function goPageWithCDandWork(pgAct, CD, tmp) {
	document.fList.editID.value = CD;
	document.fList.work.value = tmp;
	document.fList.action = pgAct;
	document.fList.submit(true);
}
// ページ移動
function changePage(myPage) {
	document.fList.myPage.value = myPage;
	document.fList.work.value = ___WORK_SEARCH__;
	document.fList.action = "user_l.php";
	document.fList.submit(true);
	return false;
}
// ソート指定
function changeSort(sortBy) {
	var NowSortBy = document.fList.SortBy.value;
	if (NowSortBy == sortBy) sortBy++;
	document.fList.SortBy.value = sortBy;
	document.fList.work.value = ___WORK_SEARCH__;
	document.fList.action = "user_l.php";
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
		<h2 class="mngmt"><img src="img/admin/h2_mng_tool.gif" alt="管理ツール" /></h2>

		<div id="main_contents" class="mypage h100">

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