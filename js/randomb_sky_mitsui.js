var txt = new Array();
txt[0]="<a href='/link/mizuho.html' target='_blank'><img src='/images/sky_mizuho.jpg' border='0'></a>";
txt[1]="<a href='/link/acom.html' target='_blank'><img src='/images/sky_acom.gif' border='0'></a>";
txt[2]="<a href='/link/promice.html' target='_blank'><img src='/images/sky_promise.gif' border='0'></a>";
txt[3]="<a href='/link/mizuho.html' target='_blank'><img src='/images/sky_mizuho.jpg' border='0'></a>";
txt[4]="<a href='/link/mizuho.html' target='_blank'><img src='/images/sky_mizuho.jpg' border='0'></a>";
txt[5]="<a href='/link/smbc.html' target='_blank'><img src='/images/sky_mitsui.gif' border='0'></a>";
txt[6]="<a href='/link/smbc.html' target='_blank'><img src='/images/sky_mitsui.gif' border='0'></a>";
txt[7]="<a href='/link/smbc.html' target='_blank'><img src='/images/sky_mitsui.gif' border='0'></a>";
txt[8]="<a href='/link/smbc.html' target='_blank'><img src='/images/sky_mitsui.gif' border='0'></a>";

mmax = 9; //txt��3�܂ł����4�ƋL��
txtno = Math.floor(Math.random() * mmax);
document.write(txt[txtno]);


