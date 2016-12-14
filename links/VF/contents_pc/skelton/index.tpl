<html>
<head>
<title>スケルトンメーカ</title>

<META http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
table {
	border: 1px solid #999999;
	border-collapse: collapse;
	border-spacing: 0;
}
td {
	padding: 3px;
	font-size: 12px;
}

textarea {
	font-size: 11px;
}
-->
</style>
</head>

<body>

<form method="POST" action="index.php">

<table width="100%" border="1px">
	<tr>
		<td nowrap width="150">プロジェクト名</td>
		<td nowrap>
			<input type="text" name="wSuffix" value="__wSuffix__" size="60" __IME_OFF__ class="form">
		</td>
	</tr>
	<tr id="blockName">
		<td>DB定義</td>
		<td>
			<textarea name="wDefinition" rows="40" class="form" style="width: 100%; ime-mode: disabled;">__wDefinition__</textarea>
		</td>
	</tr>
	<tr id="blockName">
		<td>クラス上書き指定</td>
		<td>
			既にクラスが作成されている場合　
			<input type="checkbox" name="wUpdate1" value="t"__Update1Checked__>基底クラス(XXBase*)だけを上書きする<br>
		</td>
	</tr>
	<!--tr id="blockName">
		<td>サイト側PHP上書き指定</td>
		<td>
			既にサイト側PHPがある場合　
			<input type="checkbox" name="wUpdate4" value="t"__Update4Checked__>サイト側PHPを上書きしない<br>
		</td>
	</tr>
	<tr id="blockName">
		<td>管理側PHP上書き指定</td>
		<td>
			既に管理側PHPがある場合　
			<input type="checkbox" name="wUpdate5" value="t"__Update5Checked__>管理側PHPを上書きしない<br>
		</td>
	</tr>
	<tr id="blockName">
		<td>サイト側TPL上書き指定</td>
		<td>
			既にサイト側TPLがある場合　
			<input type="checkbox" name="wUpdate2" value="t"__Update2Checked__>サイト側TPLを上書きしない<br>
		</td>
	</tr>
	<tr id="blockName">
		<td>管理側TPL上書き指定</td>
		<td>
			既に管理側TPLがある場合　
			<input type="checkbox" name="wUpdate3" value="t"__Update3Checked__>管理側TPLを上書きしない<br>
		</td>
	</tr-->
	<tr>
		<td colspan="2">
			<input type="submit" value="データ更新" class="button">　
			<input type="reset" value="フォームを元に戻す" class="button">　
		</td>
	</tr>
</table>
</form>

</body>
</html>