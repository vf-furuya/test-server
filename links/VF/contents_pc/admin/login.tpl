<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>___SITE_TITLE__</title>
<meta name="Author" content="IT Trend" />
<meta name="Copyright" content="&amp;IT Trend" />
__i::admin/_head.tpl__
</head>

<body id="no_gnavi">
<form name="fList" action="" method="post">

<div id="wrapper">

	__i::admin/_header.tpl__

	<div id="contents" class="clearfix">

		<h2 class="mngmt"><img src="img/admin/h2_mng_tool.gif" alt="管理ツール" /></h2>

		<div id="main_contents" class="mypage">

			<h3>管理ツールログイン</h3>

			<p>IDとパスワードを入力して、ログインボタンを押してください。</p>
			<div class="box_form grey">
				<table class="form">
					<tr>
						<th>ID</th>
						<td><input name="wID" type="text" maxlength="255" class="user_id_2 imeoff" id="OperatorEmail" /></td>
					</tr>
					<tr>
						<th>パスワード</th>
						<td>
							<input type="password" name="wPassword" maxlength="255" class="user_id_2 imeoff" id="OperatorPassword" />
							__IfError__<div style="color: #FF0000;">ログイン情報に誤りがございます。</div>__IfError__
						</td>
					</tr>
				</table>
				<p class="center">
					<a href="#" onclick="goPageWithWork('login.php', ___WORK_LOGIN__); return false;"><img alt="ログイン" src="img/admin/btn_login_operator.png" /></a>
				</p>
			</div>
		</div>
		<!--main_contents -->

		<div id="sub_contents"><!--box_data-demand --> 

		</div><!--sub_contents --> 


	</div><!--contents -->

	__i::admin/_footer.tpl__

</div><!--wrapper -->

__HiddenValues__
</form>
</body>
</html>
