var txt = new Array();
txt[0]="<a href='/link/mitubishi.html' target='_blank'>最短30分で審査回答！当日融資ＯＫ【三菱東京UFJ銀行ｶｰﾄﾞﾛｰﾝ】</a>";
txt[1]="<a href='/link/acom.html' target='_blank'>最短1時間融資！お急ぎの方はコチラ⇒【アコム】</a>";
txt[2]="<a href='/link/orix_bank.html' target='_blank'>【オリックス友銀行ｶｰﾄﾞﾛｰﾝ】300万円以内の申込は収入証明不要</a>";
txt[3]="<a href='/link/orix_bank.html' target='_blank'>最短３０分で審査完了！即日融資ＯＫ【オリックス銀行ｶｰﾄﾞﾛｰﾝ】</a>";
txt[4]="<a href='/link/mitubishi.html' target='_blank'>審査に不安の方はお試し診断で即確認できます【三菱東京UFJ銀行ｶｰﾄﾞﾛｰﾝ】</a>";
txt[5]="<a href='/link/promice.html' target='_blank'>【プロミス】通勤中に申込んで、夕方にはご融資！</a>";






mmax = 6; //txtが3まであれば4と記入
txtno = Math.floor(Math.random() * mmax);
document.write(txt[txtno]);


