<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<title>- 登録 入力確認-</title>
<link href="style.css" rel="stylesheet" type="text/css">
<script type="text/javascript"><!--
--></script>
</head>
<body bgcolor="#FFF6E5">
<form action="<%applycgi%>" method="POST">
<center>
<table width="300" border="0" cellpadding="0" cellspacing="10">
<tr>
<td height="250">
  <table width="300" border="1" cellspacing="5" bordercolor="#FFBF00">
    <tr> 
      <td>
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr> 
            <td colspan="3" bgcolor="#FFDF80"> 
              <table width="100%" border="0" cellspacing="5" cellpadding="5">
                <tr> 
                  <td><font color="#000000" size="+1"><strong>入力内容をご確認ください</strong></font></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3" bgcolor="#FFFFFF">
              <table width="100%" border="0" cellspacing="0" cellpadding="10">
                <tr> 
                  <td><font color="#666666" size="-1">
                    <table width="400" border="0" cellpadding="0" cellspacing="0">
                     <%registtable%>
                    </table>
                </tr>
              </table></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr><td align="center"><input type="button" value="　閉じる　" onClick="window.close();">　　　
        <input type="submit" name="<%submit%>" value="　確　認　"></td>
    </tr>
  </table>
</td>
</tr>
</table>
</center>
<%registform%>
<input name="md" type="hidden" id="md" value="guest">
<input name="id" type="hidden" id="id" value="<%id%>">
</from>
</body>
</html>
