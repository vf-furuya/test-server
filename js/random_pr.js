var txt = new Array();
txt[0]="<a href='/link/acom.html' target='_blank'>【アコム】借入可能か3秒診断チェック</a>";
txt[1]="<a href='/link/smbc.html' target='_blank'>【三井住友銀行ｶｰﾄﾞﾛｰﾝ】ネットですぐ審査回答！当日振込可能</a>";
txt[2]="<a href='/link/smbc.html' target='_blank'>【三井住友銀行ｶｰﾄﾞﾛｰﾝ】上限限度額は800万円！</a>";
txt[3]="<a href='/link/mitubishi.html' target='_blank'>【UFJｶｰﾄﾞﾛｰﾝ】ネット申込なら最短30分で審査完了！</a>";
txt[4]="<a href='/link/mizho.html' target='_blank'>通勤中に申込んで、夕方にはキャッシング！【みずほ銀行】</a>";
txt[5]="<a href='/link/lake.html' target='_blank'>【新生銀行レイク】最短即日融資対応！</a>";






mmax = 6; //txtが3まであれば4と記入
txtno = Math.floor(Math.random() * mmax);
document.write(txt[txtno]);


