var txt = new Array();
txt[0]="<a href='/link/mizuho.html' target='_blank'>利用限度額1,000万円で安心！【みずほ銀行カードローン】</a>";
txt[1]="<a href='/link/mizuho.html' target='_blank'>利用限度額1,000万円で安心！【みずほ銀行カードローン】</a>";
txt[2]="<a href='/link/acom.html' target='_blank'>【アコム】審査・利用まで即日対応！</a>";
txt[3]="<a href='/link/mizuho.html' target='_blank'>利用限度額1,000万円で安心！【みずほ銀行カードローン】</a>";






mmax = 4; //txtが3まであれば4と記入
txtno = Math.floor(Math.random() * mmax);
document.write(txt[txtno]);


