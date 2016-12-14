
$action = $param{'action'};

if( defined $param{'setup'} ){ &setup(); }
elsif( $action eq 'step' ){ &step(); }
&check();


sub check
{
	# 初期セットアップ
	unless( -e $DATA{'setup'} ){
		&setup();
		return 1;
	}else{
		open( VER, "<$DATA{'setup'}" );
		my $version = <VER>;
		close(VER);
		if( &check_version($version) ){
			&setup();
		}
	}
	
	# CGIチェック
	#if( &_cgi() ){
	#	$error = 1;
	#}
	# セットアップ開始
	if( $error ){
		&setup();
		return 1;
	}
}

sub check_version
{
	my( $def_version ) = @_;
	
	my @def_ver = split( /\./, $def_version );
	my @cur_ver = split( /\./, $Version );
	
	if( $def_ver[0] != $cur_ver[0] || $def_ver[1] != $cur_ver[1] ){
		return 1;
	}
	return 0;
}

sub setup
{
	#eval{ require './config.pl'; };
	&step();
}
sub step
{
	my $stepAction;
	my $stepTitle;
	my $lastStep = $#SETUP_STEP;
	my $stepNum = $param{'next'} -0;
	
	if( defined $param{'back'} ){
		$stepNum -= 2;
	}
	if( defined $param{'current'} ){
		$stepNum -= 1;
	}
	if( defined $param{'setPathImg'} ){
		&setPathImg();
		$stepNum -= 1;
	}
	if( defined $param{'setPathLocal'} ){
		&setPathImg( 1 );
		$stepNum -= 1;
	}
	if( defined $param{'setSendmail'} ){
		&setSendmail();
		$stepNum -= 1;
	}
	if( defined $param{'auth'} ){
		my $tmp = $myroot. $data_dir. 'SETUP-'. $$. time. '.cgi';
		open( SETUP, ">$tmp" );
		print SETUP $Version;
		close(SETUP);
		chmod 0606, $tmp;
		rename $tmp, $DATA{'setup'};
		return;
	}
	
	my $check_image_local = 1;
	my $n = 0;
	foreach( @SETUP_STEP ){
		#my $numMessae = $n. '．' if( $n > 0 && $lastStep > $n );
		if( $n > $stepNum ){
			#$REF{$Tag'Setup{'SETUP-STEP'}} .= qq|<font color="$Error'Message{'013'}">$numMessae$_->[0]</font>|;
			#$REF{$Tag'Setup{'SETUP-STEP'}} .= qq|<font color="$Error'Message{'013'}"> &gt; </font>| if( $lastStep > $n );
		}elsif( $n == $stepNum ){
			#$REF{$Tag'Setup{'SETUP-STEP'}} .= qq|<font color="$Error'Message{'012'}"><strong>$numMessae$_->[0]</strong></font>|;
			#$REF{$Tag'Setup{'SETUP-STEP'}} .= qq|<font color="$Error'Message{'013'}"> &gt; </font>| if( $lastStep > $n );
			$stepAction = $_;
			#$stepTitle = $_->[2];
		}else{
			#$REF{$Tag'Setup{'SETUP-STEP'}} .= qq|<font color="$Error'Message{'011'}"><strong>$numMessae$_->[0]</strong></font>|;
			#$REF{$Tag'Setup{'SETUP-STEP'}} .= qq|<font color="$Error'Message{'011'}"><strong> &gt; </strong></font>| if( $lastStep > $n );
		}
		# 画像ローカルパス設定の有無を判定
		#if( $_->[1] eq 'pmsImg' ){
		#	$check_image_local = 1;
		#}
		$n++;
	}
	
	my $template;
	if( $stepAction eq 'start' ){
		$template = &setup_start($stepNum);
	}elsif( $stepAction eq 'pmsBase' ){
		$template = &pmsBase($stepNum);
	}elsif( $stepAction eq 'pathImg' ){
		$template = &pathImg($stepNum, $check_image_local);
	}elsif( $stepAction eq 'pmsImg' ){
		$template = &pmsImg($stepNum);
	}elsif( $stepAction eq 'pathSmail' ){
		$template = &pathSmail($stepNum);
	}elsif( $stepAction eq 'end' ){
		$template = &setup_end($stepNum);
	}
	
	#$REF{$Tag'Setup{'SETUP-TITLE'}} = $stepTitle;
	#$REF{$Tag'Setup{'SETUP-NEXT'}} = $stepNum +1;
	# 変換タグを反映
	#my $HTML = &reflect( \%REF, $template );
	# Content-type
	#&header( 1 );
	# ページ出力
	#print $HTML;
	&setup_htmlframe( $template );
	exit;
}
sub setup_start
{
	my( $step ) = @_;
	my $main = <<"END";
                    <form action="$indexcgi" method="post">
                      <TABLE cellspacing=0 cellpadding=3 width=660 border=0>
                        <TBODY>
                          <TR>
                            <TD><STRONG>セットアップ &gt; </STRONG><font color="#999999">1．データディレクトリチェック</font> <font color="#999999">&gt;   2．画像ディレクトリチェック &gt;   3．sendmailチェック &gt;   完了</font>
                              <hr></TD>
                          </TR>
                          <TR>
                            <TD>&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD><table width="500" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td bgcolor="#FFFFFF"><table width="550" border="0" cellspacing="1" cellpadding="10">
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3>セットアップを開始します </h3></td>
                                      </tr>
                                      <tr>
                                        <td valign="top" bgcolor="#FFFFFF">プログラムのセットアップを開始します。</td>
                                      </tr>
                                      <tr>
                                        <td valign="top" bgcolor="#FFFFFF"><table width="200" border="0" cellspacing="0" cellpadding="2">
                                            <tr>
                                              <td width="100" align="right">&nbsp;</td>
                                              <td width="100"><input type="submit" name="Submit" value="　次へ　"></td>
                                            </tr>
                                          </table>
                                          <input name="action" type="hidden" id="action" value="step">
                                          &nbsp;
                                          <input name="next" type="hidden" id="next" value="1"></td>
                                      </tr>
                                    </table></td>
                                </tr>
                              </table></TD>
                          </TR>
                        </TBODY>
                      </TABLE>
                    </form>
END
	return $main;
}
sub setup_pmsBase
{
	my( $step, $chk, $error ) = @_;
	$step++;
	
	foreach( @$chk ){
		my $path = $_->[0];
		my $mes = $_->[1];
		$TR .= <<"END";
                                                  <tr>
                                                    <td width="70%" bgcolor="#FFFFE8">$path</td>
                                                    <td width="30%" align="center" bgcolor="#FFFFE8">$mes</td>
                                                  </tr>
END
	}
	
	if( $error ){
		$none_ok = 'none';
		$none_err = '';
	}else{
		$none_ok = '';
		$none_err = 'none';
	}
	
	
	my $main = <<"END";
<form action="$main'indexcgi" method="post">
                      <TABLE cellspacing=0 cellpadding=3 width=660 border=0>
                        <TBODY>
                          <TR>
                            <TD><font color="#999999">セットアップ &gt;</font><STRONG> <font color="#CC6600">1．データディレクトリチェック</font></STRONG> <font color="#999999">&gt;   2．画像ディレクトリチェック &gt;   3．sendmailチェック &gt;   完了</font>
                            <hr></TD>
                          </TR>
                          <TR>
                            <TD>&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD><table width="500" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td bgcolor="#FFFFFF"><table width="550" border="0" cellspacing="1" cellpadding="10">
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3><strong>１． </strong>データディレクトリチェック</h3>
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#666666"><table width="100%" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td colspan="2" bgcolor="#FFCC33">▼データディレクトリ　パーミッションチェック</td>
                                                  </tr>
$TR
                                                </table></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3><strong>検査結果</strong> </h3>
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="500" border="0" cellspacing="1" cellpadding="10">
                                                  <tr style="display:$none_ok;">
                                                    <td bgcolor="#FAF9F3">エラーはありませんでした。<br>
                                                      「次へ」ボタンを押して先に進んでください。 </td>
                                                  </tr>
                                                  
                                                  <tr style="display:$none_err;">
                                                    <td bgcolor="#FFE6E6"><font color="#990000"><font color="#FF0000">エラーがありました。</font></font><font color="#FF0000"><br>
                                                      エラーが表\示された項目をFTPにて変更後、再確認ボタンを押してください。</font> </td>
                                                  </tr>
                                                  
                                              </table></td>
                                            </tr>
                                          </table>
                                          <br>
                                          <table width="200" border="0" align="center" cellpadding="1" cellspacing="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="200" border="0" cellspacing="0" cellpadding="10">
                                                <tr style="display:$none_ok;">
                                                  <td align="center" bgcolor="#ECE9D8"><input name="next" type="submit" id="next" value="　次へ　"></td>
                                                </tr>
                                                <tr style="display:$none_err;">
                                                  <td align="center" bgcolor="#ECE9D8"><input name="current" type="submit" id="current" value="　再確認　"></td>
                                                </tr>
                                              </table></td>
                                            </tr>
                                          </table>
                                          <hr>
                                          <input name="back" type="submit" id="back" value="　戻る　">
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#FFFFFF"></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                    </table></td>
                                </tr>
                              </table>
                              <input name="action" type="hidden" id="action" value="step">
                              <input name="next" type="hidden" id="step" value="$step"></TD>
                          </TR>
                          <TR>
                            <TD align="center">&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD></TD>
                          </TR>
                        </TBODY>
                      </TABLE>
                    </form>
END
}
sub setup_pathImg
{
	my( $step, $image_dir, $imglocal, $error ) = @_;
	
	$step++;
	my $now = time;
	if( $error ){
		$none_ok = 'none';
		$none_err = '';
	}else{
		$none_ok = '';
		$none_err = 'none';
	}
	
	my $main = <<"END";
<form action="$main'indexcgi" method="post">
                      <TABLE cellspacing=0 cellpadding=3 width=660 border=0>
                        <TBODY>
                          <TR>
                            <TD><font color="#999999">セットアップ &gt; 1．データディレクトリチェック</font> <font color="#999999">&gt;   <font color="#CC6600"><strong>2．画像ディレクトリチェック</strong></font> &gt;   3．sendmailチェック &gt;   完了</font>
                            <hr></TD>
                          </TR>
                          <TR>
                            <TD>&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD><table width="500" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td bgcolor="#FFFFFF"><table width="550" border="0" cellspacing="1" cellpadding="10">
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3><strong>２． </strong>画像ディレクトリチェック</h3>
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#666666"><table width="100%" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td colspan="2" bgcolor="#FFCC33">▼画像表\示チェック</td>
                                                  </tr>
                                                  <tr>
                                                    <td colspan="2" bgcolor="#FFFFE8"><img src="$image_dir\icon_alert.gif?$now" width="50" height="50"><br>
                                                      <font color="#FF0000">上記の「黄色い三角の画像」は表\示されていますか？ </font></td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3>&gt;&gt;表\示されている場合</h3>
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="550" border="0" cellspacing="1" cellpadding="10">
                                                  <tr style="display:$none_ok;">
                                                    <td bgcolor="#FAF9F3">「次へ」ボタンを押して先に進んでください。 </td>
                                                  </tr>
                                                  <tr style="display:$none_err;">
                                                    <td bgcolor="#FAF9F3"><font color="#FF0000">ご利用のサーバーでは、仮想パスを使用している可能\性があり、このままでは画像がアップロードできません。以下の手順に従って、設定をしてください。</font></td>
                                                  </tr>
                                                  <tr style="display:$none_err;">
                                                    <td bgcolor="#FAF9F3">１、画像ファイルのディレクトリパスを入力してください。<br>
                                                      <table width="500" border="0" align="center" cellpadding="10" cellspacing="0">
                                                        <tr>
                                                          <td><input name="imglocal" type="text" id="imglocal" value="$imglocal" size="40">
                                                            <br>
                                                            <font color="#996600">画像ファイルのディレクトリパスを、index.cgi 
                                                            からのFTPで見た場合の相対パスで<br>
                                                            入力してください。</font></td>
                                                        </tr>
                                                      </table>
                                                      <br>
                                                      ２、下のボタンを押して、再度確認してください。</td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table>
                                          <br>
                                          <table width="200" border="0" align="center" cellpadding="1" cellspacing="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="200" border="0" cellspacing="0" cellpadding="10">
                                                  <tr style="display:$none_ok;">
                                                    <td align="center" bgcolor="#ECE9D8"><input type="submit" value="　次へ　"></td>
                                                  </tr>
                                                  <tr style="display:$none_err;">
                                                    <td align="center" bgcolor="#ECE9D8"><input name="setPathLocal" type="submit" id="setPathLocal" value="　再確認　"></td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3>&gt;&gt;表\示されていない場合</h3>
                                          <table width="550" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="550" border="0" cellspacing="1" cellpadding="10">
                                                  <tr style="display:;">
                                                    <td bgcolor="#FFE6E6"><font color="#FF0000">ご利用のサーバーでは、現在の設置構\成では画像が読み込めない可能\性があります。<br>
                                                      以下の手順に従って、設定を行ってください。</font></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#FFE6E6">１．ご利用サーバーでの動作制限をご確認下さい。<br>
                                                      「cgi-bin/」ディレクトリ内では、画像が読み込めないサーバーの可能\性があります。<br>
                                                      <br>
                                                      ２．FTPにて、「./images/」ディレクトリを画像が読み込めるディレクトリ内に設置してください。 <br>
                                                      <br>
                                                      ３．以下を設置した場所にあわせて変更してください。 <br>
                                                      <table width="500" border="0" align="center" cellpadding="10" cellspacing="0">
                                                        <tr>
                                                          <td><input name="imgpath" type="text" id="imgpath" value="$image_dir" size="40">
                                                            <br>
                                                            <font color="#996600">画像ファイルのディレクトリパスをindex.cgi 
                                                            からの相対パスで入力してください。</font></td>
                                                        </tr>
                                                      </table>
                                                      <br>
                                                      ４．下のボタンを押して、再度確認してください</td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table>
                                          <br>
                                          <table width="200" border="0" align="center" cellpadding="1" cellspacing="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="200" border="0" cellspacing="0" cellpadding="10">
                                                  <tr>
                                                    <td align="center" bgcolor="#ECE9D8"><input name="setPathImg" type="submit" id="'setPathImg'" value="　再確認　"></td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table>
                                          <hr>
                                          <input name="back" type="submit" id="back" value="　戻る　">
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#FFFFFF"></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                    </table></td>
                                </tr>
                              </table>
                              <input name="action" type="hidden" id="action" value="step">
                              <input name="next" type="hidden" id="next" value="$step"></TD>
                          </TR>
                          <TR>
                            <TD align="center">&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD></TD>
                          </TR>
                        </TBODY>
                      </TABLE>
                    </form>
END
	return $main;
}
sub setup_pmsImg
{
	my( $step, $chk, $error ) = @_;
	$step++;
	
	foreach( @$chk ){
		my $path = $_->[0];
		my $mes = $_->[1];
		$TR .= <<"END";
                                                  <tr>
                                                    <td width="70%" bgcolor="#FFFFE8">$path</td>
                                                    <td width="30%" align="center" bgcolor="#FFFFE8">$mes</td>
                                                  </tr>
END
	}
	
	if( $error ){
		$none_ok = 'none';
		$none_err = '';
	}else{
		$none_ok = '';
		$none_err = 'none';
	}
	
	
	my $main = <<"END";
<form action="$main'indexcgi" method="post">
                      <TABLE cellspacing=0 cellpadding=3 width=660 border=0>
                        <TBODY>
                          <TR>
                            <TD><font color="#999999">セットアップ &gt; 1．データディレクトリチェック</font> <font color="#999999">&gt;<strong> <font color="#CC6600">2．画像ディレクトリチェック</font></strong> &gt;   3．sendmailチェック &gt;   完了</font><font color="#999999">&nbsp;</font>
                            <hr></TD>
                          </TR>
                          <TR>
                            <TD>&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD><table width="$none_ok" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td bgcolor="#FFFFFF"><table width="550" border="0" cellspacing="1" cellpadding="10">
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3><strong>２． </strong>画像ディレクトリチェック</h3>
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#666666"><table width="100%" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td colspan="2" bgcolor="#FFCC33">▼画像ディレクトリ　パーミッションチェック</td>
                                                  </tr>
$TR
                                                </table></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3><strong>検査結果</strong> </h3>
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="500" border="0" cellspacing="1" cellpadding="10">
                                                  <tr style="display:$none_ok;">
                                                    <td bgcolor="#FAF9F3">エラーはありませんでした。<br>
                                                      「次へ」ボタンを押して先に進んでください。 </td>
                                                  </tr>
                                                  
                                                  <tr style="display:$none_err;">
                                                    <td bgcolor="#FFE6E6"><font color="#990000"><font color="#FF0000">エラーがありました。</font></font><font color="#FF0000"><br>
                                                      エラーが表示された項目をFTPにて変更後、再確認ボタンを押してください。</font> </td>
                                                  </tr>
                                                  
                                              </table></td>
                                            </tr>
                                          </table>
                                          <br>
                                          <table width="200" border="0" align="center" cellpadding="1" cellspacing="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="200" border="0" cellspacing="0" cellpadding="10">
                                                <tr style="display:$none_ok;">
                                                  <td align="center" bgcolor="#ECE9D8"><input name="next" type="submit" id="next" value="　次へ　"></td>
                                                </tr>
                                                <tr style="display:$none_err;">
                                                  <td align="center" bgcolor="#ECE9D8"><input name="current" type="submit" id="current" value="　再確認　"></td>
                                                </tr>
                                              </table></td>
                                            </tr>
                                          </table>
                                          <hr>
                                          <input name="back" type="submit" id="back" value="　戻る　">
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#FFFFFF"></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                    </table></td>
                                </tr>
                              </table>
                              <input name="action" type="hidden" id="action" value="step">
                              <input name="next" type="hidden" id="next" value="$step"></TD>
                          </TR>
                          <TR>
                            <TD align="center">&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD></TD>
                          </TR>
                        </TBODY>
                      </TABLE>
                    </form>
END
}
sub setup_pathSmail
{
	my( $step, $sendmail, $error ) = @_;
	$step++;
	if( $error ){
		$none_ok = 'none';
		$none_err = '';
	}else{
		$none_ok = '';
		$none_err = 'none';
	}
	
	my $main = <<"END";
<form action="$main'indexcgi" method="post">
                      <TABLE cellspacing=0 cellpadding=3 width=660 border=0>
                        <TBODY>
                          <TR>
                            <TD><font color="#999999">セットアップ &gt; 1．データディレクトリチェック</font> <font color="#999999">&gt;   2．画像ディレクトリチェック &gt;   <strong><font color="#CC6600">3．sendmailチェック</font></strong> &gt;   完了</font>
                            <hr></TD>
                          </TR>
                          <TR>
                            <TD>&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD><table width="500" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td bgcolor="#FFFFFF"><table width="550" border="0" cellspacing="1" cellpadding="10">
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3><strong>３． </strong>sendmailチェック</h3>
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#666666"><table width="100%" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td colspan="2" bgcolor="#FFCC33">▼sendmailパスチェック</td>
                                                  </tr>
                                                  <tr style="display:$none_ok;">
                                                    <td width="20%" bgcolor="#FFFFE8">sendmailパス</td>
                                                    <td width="80%" bgcolor="#FFFFE8">$sendmail</td>
                                                  </tr>
                                                  <tr style="display:$none_err;">
                                                    <td bgcolor="#FFFFE8">sendmailパス</td>
                                                    <td bgcolor="#FFFFE8"><input name="sendmail" type="text" id="sendmail" value="$senamail" size="40">
                                                      <br>
                                                      ご利用サーバーのsendmailパスを入力してください。<br>
                                                      例1： /usr/lib/sendmail <br>
                                                      例2： /usr/sbin/sendmail </td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF">&nbsp;</td>
                                      </tr>
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3><strong>検査結果</strong> </h3>
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="500" border="0" cellspacing="1" cellpadding="10">
                                                  <tr style="display:$none_ok;">
                                                    <td bgcolor="#FAF9F3">sendmailパスは確認されました。<br>
                                                       「次へ」ボタンを押して先に進んでください。</td>
                                                  </tr>
                                                  <tr style="display:$none_err;">
                                                    <td bgcolor="#FFE6E6"><font color="#FF0000">sendmailパスは確認できませんでした。 <br>
                                                      ご利用サーバーの設定を確認の上入力し、再確認ボタンを押してください。 </font> </td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table>
                                          <br>
                                          <table width="200" border="0" align="center" cellpadding="1" cellspacing="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="200" border="0" cellspacing="0" cellpadding="10">
                                                  <tr style="display:$none_ok;">
                                                    <td align="center" bgcolor="#ECE9D8"><input name="next" type="submit" id="next" value="　次へ　"></td>
                                                  </tr>
                                                  <tr style="display:$none_err;">
                                                    <td align="center" bgcolor="#ECE9D8"><input name="setSendmail" type="submit" id="setSendmail" value="　再確認　"></td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table>
                                          <hr>
                                          <input name="back" type="submit" id="back" value="　戻る　">
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#FFFFFF"></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                    </table></td>
                                </tr>
                              </table>
                              <input name="action" type="hidden" id="action" value="step">
                              <input name="next" type="hidden" id="next" value="$step"></TD>
                          </TR>
                          <TR>
                            <TD align="center">&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD></TD>
                          </TR>
                        </TBODY>
                      </TABLE>
                    </form>
END
	return $main;
}
sub setup_end
{
	my $main = <<"END";
<form action="$main'indexcgi" method="post">
                      <TABLE cellspacing=0 cellpadding=3 width=660 border=0>
                        <TBODY>
                          <TR>
                            <TD><font color="#999999">セットアップ &gt; 1．データディレクトリチェック</font> <font color="#999999">&gt;   2．画像ディレクトリチェック &gt;   3．sendmailチェック &gt; <font color="#CC6600"><strong>完了</strong></font></font>
                              <hr></TD>
                          </TR>
                          <TR>
                            <TD>&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD><table width="500" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                  <td bgcolor="#FFFFFF"><table width="550" border="0" cellspacing="1" cellpadding="10">
                                      <tr>
                                        <td bgcolor="#FFFFFF"><h3>セットアップ完了</h3>
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="500" border="0" cellspacing="1" cellpadding="10">
                                                  <tr>
                                                    <td bgcolor="#FAF9F3">セットアップは、すべて完了しました。<br>
                                                      <br>
                                                      管理画面にログインするための初期データは、以下に設定されています。<br>
                                                      <br>
                                                      <table border="0" align="center" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                          <td bgcolor="#999999"><table border="0" cellpadding="5" cellspacing="1">
                                                              <tr>
                                                                <td bgcolor="#EAEAEA">ID<br>
                                                                  <input name="textfield" type="text" value="id"></td>
                                                              </tr>
                                                              <tr>
                                                                <td bgcolor="#EAEAEA">パスワード<br>
                                                                  <input name="textfield2" type="text" value="pass"></td>
                                                              </tr>
                                                            </table></td>
                                                        </tr>
                                                      </table>
                                                      <br>
                                                      
                                                      </td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table>
                                          <br>
                                          <table width="200" border="0" align="center" cellpadding="1" cellspacing="0">
                                            <tr>
                                              <td bgcolor="#999999"><table width="200" border="0" cellspacing="0" cellpadding="10">
                                                  <tr style="display:;">
                                                    <td align="center" bgcolor="#ECE9D8"><input name="auth" type="submit" id="auth" value="　完了　">
													</td>
                                                  </tr>
                                                </table></td>
                                            </tr>
                                          </table><br><font color="#FF0000">※ 各種設定を変更したい場合は、セットアップ完了後にトップ画面より変更してください。</font>
                                          <hr>
                                          <input type="button" value="　戻る　" onclick="history.back();">
                                          <table width="500" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                              <td bgcolor="#FFFFFF"></td>
                                            </tr>
                                          </table></td>
                                      </tr>
                                    </table></td>
                                </tr>
                              </table>
                              <input name="action" type="hidden" id="action" value="step"></TD>
                          </TR>
                          <TR>
                            <TD align="center">&nbsp;</TD>
                          </TR>
                          <TR>
                            <TD></TD>
                          </TR>
                        </TBODY>
                      </TABLE>
                    </form>
END
}

sub checkPms
{
	my( $chk, $path ) = @_;
	
	my $os = $^O;
	if($os !~ /MSWin32/i){
		my $execuid = $<;	#実UID
		my $owneruid = (stat($path))[4];
		if($execuid eq $owneruid) {
			if( $chk eq 'cgi' ){
				if( !( -x $path ) ){
					my $pms = &_getPms( $path );
					if( $pms !~ /^70/ ){
						return $ErrorMessage{'004'};
					}
				}
			}
			if( $chk eq 'dir' ){
				if( !(-w $path ) || !( -x $path ) ){
					my $pms = &_getPms( $path );
					if( $pms !~ /^70/ ){
						return $ErrorMessage{'004'};
					}
				}
			}
		}else{
			if( $chk eq 'cgi' ){
				if( !( -x $path ) ){
					my $pms = &_getPms( $path );
					if( $pms ne '705' ){
						return $ErrorMessage{'005'};
					}
				}
			}
			if( $chk eq 'dir' ){
				if( !(-w $path ) || !( -x $path ) ){
					my $pms = &_getPms( $path );
					if( $pms ne '707' ){
						return $ErrorMessage{'006'};
					}
				}
			}
		}
	}
}

sub pmsBase
{
	my( $step ) = @_;
	my $error = 0;
	
	my @DIRS;
	$DIRS[0] = $myroot. $data_dir. $log_dir;
	$DIRS[1] = $myroot. $data_dir. $csv_dir;
	$DIRS[2] = $myroot. $data_dir. $queue_dir;
	$DIRS[3] = $myroot. $data_dir. $simul_dir;
	$DIRS[4] = $myroot. $data_dir. $mkform_dir;
	$DIRS[5] = $myroot. $data_dir. $forward_dir;
	
	my @CHK_DIR;
	my $error;
	my $mes;
	
	# 基本ディレクトリチェック
	my $BaseDir = $myroot.$data_dir;
	unless( -e $BaseDir ){
		$error = 1;
		$mes = $ErrorMessage{'002'} . $ErrorMessage{'003'};
	}else{
		my $message = &checkPms( 'dir', $BaseDir );
		if( $message ne '' ){
			$error = 1;
			$mes = $ErrorMessage{'002'} . $message;
		}
		$mes = $ErrorMessage{'001'} if( $mes eq '' );
	}
	push @CHK_DIR, [$BaseDir,$mes];
	
	goto LOCK if( $error );
	
	foreach( @DIRS ){
		my $path = $_;
		&mkdir( $path );
		my $mes;
		my %check;
		unless( -e $path ){
			$error = 1;
			$mes = $ErrorMessage{'002'} . $ErrorMessage{'003'};
		}else{
		
			my $message = &checkPms( 'dir', $path );
			if( $message ne '' ){
				$error = 1;
				$mes = $ErrorMessage{'002'} . $message;
			}
		}
		$mes = $ErrorMessage{'001'} if( $mes eq '' );
		push @CHK_DIR, [$path,$mes];
	}
	
	LOCK:
	
	# ロックディレクトリ
	# 基本ディレクトリチェック
	my $Lock = $myroot.$lockdir;
	unless( -e $Lock ){
		$error = 1;
		$mes = $ErrorMessage{'002'} . $ErrorMessage{'003'};
	}else{
		my $message = &checkPms( 'dir', $Lock );
		if( $message ne '' ){
			$error = 1;
			$mes = $ErrorMessage{'002'} . $message;
		}
		$mes = $ErrorMessage{'001'} if( $mes eq '' );
	}
	push @CHK_DIR, [$Lock,$mes];
	
	#if( !$error ){
		# ユーザーディレクトリを生成（データ保存基本ディレクトリ）
	#	&mkdir( $DATA{'base'} );
	#}
	
	# MESSAGE
	#&message( \%REF );
	
	# 作成画面表示
	#my $template = ($error)? $TPL'path{'setup_pms1_err'}: $TPL'path{'setup_pms1_ok'};
	
	
	
	my $template = &setup_pmsBase( $step, [@CHK_DIR], $error );
	
	return $template;
}

sub _cgi
{
	my( $Check ) = @_;
	my $error = 0;
	foreach( @CGIS ){
		my $script = $_; # メインCGIスクリプトは同じディレクトリ
		
		unless( -e $script ){
			$error = 1;
			$Check->{$script}->{'err'} = $Error'Message{'002'} . $Error'Message{'003'};
			next;
		}
		
		my $message = &checkPms( 'cgi', $script );
		if( $message ne '' ){
			$error = 1;
			$Check->{$script}->{'err'} = $Error'Message{'002'} . $message;
			next;
		}
		
		$Check->{$script}->{'err'} = $Error'Message{'001'};
	}
	return $error;
}

sub pathImg
{
	my( $step, $img_local ) = @_;
	my %SEV;
	&Pub'getServerData( \%SEV );
	
	#$REF{$Tag'Setup{'SETUP-IMAGE-DIR'}} = $DEF_IMGDIR;
	#$REF{$Tag'Setup{'SETUP-IMAGE-PATH'}} = $SEV{'imgpath'};
	#$REF{$Tag'Setup{'SETUP-IMAGE-LOCAL'}} = $SEV{'imglocal'};
	#$REF{$Tag'Setup{'SETUP-IMAGE-AUTO-DEF'}} = $SEV{'auto'} -0;
	#$REF{$Tag'Setup{'SETUP-IMAGE-AUTO'}} = ( $SEV{'auto'} )? ' checked': '';
	#$REF{$Tag'Setup{'SETUP-GET-REQ'}} = '?'.time. $$ if( !$SEV{'auto'} );
	
	my $error = 0;
	if( $img_local ){
		#my $dir = ( $REF{'AUTO'} )? $DEF_IMGDIR: $SEV{'imglocal'};
		my $iconpath = $SEV{'imglocal'} . $ICON;
		unless( -e $iconpath ){
			$error = 1;
		}
	}
	
	my $path = $SEV{'imgpath'};
	my $local = $SEV{'imglocal'};
	
	# MESSAGE
	#&message( \%REF );
	
	# 作成画面表示
	my $template = &setup_pathImg( $step, $path, $local, $error );
	return $template;
}

sub pmsImg
{
	my( $step ) = @_;
	my %SEV;
	&Pub'getServerData( \%SEV );
	
	#$REF{'SETUP-IMAGE-PATH'} = $SEV{'imgpath'};
	#$REF{'SETUP-IMAGE-LOCAL'} = $SEV{'imglocal'};
	#$REF{'SETUP-IMAGE-AUTO'} = ( $SEV{'auto'} )? ' checked': '';
	#my $dir = ( $SEV{'auto'} )? $DEF_IMGDIR: $SEV{'imglocal'};
	
	push @IMGS, $SEV{'imglocal'};
	
	my %Check;
	my @CHK_DIR;
	my $error = 0;
	foreach( @IMGS ){
		my $path = $_; # CGIスクリプトは同じディレクトリ
		my $mes;
		my %check;
		unless( -e $path ){
			$error = 1;
			$mes = $ErrorMessage{'002'} . $ErrorMessage{'003'};
		}else{
			my $message = &checkPms( 'dir', $path );
			if( $message ne '' ){
				$error = 1;
				$mes = $ErrorMessage{'002'} . $message;
			}
		}
		$mes = $ErrorMessage{'001'} if( $mes eq '' );
		push @CHK_DIR, [$path,$mes];
		#local %prop;
		#$prop{$Tag'Setup{'SETUP-PMS-PATH'}} = $path;
		#$prop{$Tag'Setup{'SETUP-PMS-MESSAGE'}} = $mes;
		#push @{ $REF{'ROW'}->{$TPL'row{'setup'}} }, {%prop};
	}
	
	# MESSAGE
	#&message( \%REF );
	
	# 作成画面表示
	my $template = &setup_pmsImg($step, [@CHK_DIR], $error);
	return $template;
}

sub pathSmail
{
	my( $step ) = @_;
	my $sendmail;
	
	my %SEV;
	&Pub'getServerData( \%SEV );
	$sendmail = $SEV{'sendmail'};
	#$REF{$Tag'Setup{'SETUP-SENDMAIL'}} = $sendmail;
	
	my $error = 0;
	unless( -x $sendmail ){
		$error = 1;
	}
	if( $sendmail !~ /sendmail$/ ){
		$error = 1;
	}
	# 作成画面表示
	#my $template = ( &chk_sendmail($sendmail) )? $TPL'path{'setup_smail_ok'}: $TPL'path{'setup_smail_err'};
	my $template = &setup_pathSmail( $step, $sendmail, $error );
	return $template;
}

sub end
{
	# ディレクトリ・ファイル自動生成
	#&setComposition();
	
	# MESSAGE
	#&message( \%REF );
	
	# 作成画面表示
	my $template  = &setup_start();
	return $template;
}

sub setPathImg
{
	my $local = shift;
	#my $auto = $param{'auto'} -0;
	my $imgpath = &delspace( $param{'imgpath'} );
	my $imglocal = &delspace( $param{'imglocal'} );
	
	if( $imgpath ne '' && $imgpath !~ /\/$/ ){
		$imgpath .= '/';
	}
	if( $imglocal ne '' && $imglocal !~ /\/$/ ){
		$imglocal .= '/';
	}
	
	my %Server;
	&Pub'getServerData( \%Server );
	if( $local ){
		$Server{'imglocal'} = $imglocal;
	}else{
		$Server{'imglocal'} = '' if( $Server{'imglocal'} eq $image_dir );
		$Server{'imglocal'} = '' if( $Server{'imgpath'} ne $imgpath );
		$Server{'imgpath'} = $imgpath;
		#$Server{'auto'} = $auto;
	}
	my $tmpfile = $myroot. $data_dir. 'SEV-'. $$. time. '.cgi';
	unless( open(TMP, ">$tmpfile") ){
		$param{'next'} = 0;
		&step();
	}
	foreach( keys %Server ){
		print TMP "$_\t$Server{$_}\n";
	}
	close(TMP);
	eval{ chmod 0606, $tmpfile; };
	rename $tmpfile, $DATA{'server'};
}

sub setSendmail
{
	my $sendmail = &delspace( $param{'sendmail'} );
	unless( -x $sendmail ){
		return;
	}
	if( $sendmail !~ /sendmail$/ ){
		return;
	}
	my %Server;
	&Pub'getServerData( \%Server );
	$Server{'sendmail'} = $sendmail;
	
	my $tmpfile = $myroot. $data_dir. 'SEV-'. $$. time. '.cgi';
	unless( open(TMP, ">$tmpfile") ){
		$param{'next'} = 0;
		&step();
	}
	foreach( keys %Server ){
		print TMP "$_\t$Server{$_}\n";
	}
	close(TMP);
	eval{ chmod 0606, $tmpfile; };
	rename $tmpfile, $DATA{'server'};
}

sub setComposition
{
	return;
}

sub mkdir
{
	my( $dir, $file ) = @_;
	unless( -d $dir ){
		mkdir $dir, 0707;
		chmod 0707, $dir;
	}
	if( $file ne '' ){
		unless( -e $file ){
			open( MAKE, ">$file" );
			chmod 0606, $file;
			close(MAKE);
		}
	}
	if( $dir ne '' ){
		$dir .= '/' if( $dir !~ /\/$/ );
		my $indexhtml = $dir . 'index.html';
		unless( -e $indexhtml ){
			open( DEF, ">$indexhtml" );
			close(DEF);
			eval{ chmod 0646, $indexhtml; };
		}
	}
}

sub _getPms
{
	my $file = shift;
	my @stat = stat $file;
	my$pms   = substr((sprintf "%03o", $stat[2]), -3);
	return $pms;
}

sub setup_htmlframe
{
	my( $main ) = @_;
	print <<"END";
Content-type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv=<!-- saved from url=(0013)about:internet -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<title>[管理画面]</title>
<link href="$indexcgi?md=img&p=style.css" rel="stylesheet" type="text/css">
<script type="text/javascript"><!--

function confir(str){
    var what=confirm(str);
    if(what == false){
        return false;
    }
}

--></script>
</head>
<body>
<center>
  <table width="700" border="0" cellspacing="10">
    <tr>
      <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr bgcolor="#0033CC">
            <td colspan="3" bgcolor="#FCD52F"><table width="100%" border="0" cellspacing="5" cellpadding="5">
                <tr>
                  <td align="left"><img src="$indexcgi?md=img&p=rakumaillogo.jpg"></td>
                  <td align="right" valign="bottom"><font color="#666666">ver$main'Version</font></td>
                </tr>
              </table></td>
          </tr>
          <tr>
            <td colspan="3" bgcolor="#FFFFFF"><table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr>
                  <td align="left">$main
                  </td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
  </table>
</center>
<body>
</body>
</html>
END
	exit;
}

1;
