package Click;

$id; # page でグローバル化

$stepfile = 'step.cgi';
$uidfile = 'uid.cgi';
$clickfile = '-click.cgi';

$forwarddir = &compatibility();
$steplogfile = $forwarddir. $stepfile;
$uidlogfile = $forwarddir. $uidfile;

$uniq_counter = 1;

sub compatibility
{
	my $dir = $main'myroot . $main'data_dir;
	my $path_dir = $dir . 'forward/';
	
	unless( -d $path_dir ){
		my $flag = mkdir $path_dir, 0707;
		if( !$flag ){
			&main'error("<strong>ディレクトリが作成できません。","</strong><br><br><br>$dir<br><br>のパーミッションがただしく設定されているかご確認ください。");
		}
		chmod 0707, $path_dir;
	}
	
	if( !(-x $path_dir) || !(-w $path_dir) ){
		&main'error("<strong>パーミッションエラー</strong>","<br><br><br>$path_dir のパーミッションが[707]に設定されているかご確認ください。");
	}
	return $path_dir;
}

# 各プランのステップにユニークコードを設定する(v2.4から必要)
sub disorder
{
	my $dir = $main'myroot . $main'data_dir. $main'log_dir;
	my $logfile = $dir. $main'plan_txt;
	my $c = 0;
	
	my $tmp = $dir. 'TMP-'. time. $$. '.cgi';
	open( TMP, ">$tmp" ) or &main'error("<strong>パーミッションエラー</strong>","<br><br><br>$dir のパーミッションが[707]に設定されているかご確認ください。");
	open( PLAN, "<$logfile" );
	while(<PLAN>){
		chomp;
		my @data = split(/\t/);
		my( $schedule, $dates ) = split( /<>/, $data[36] );
		my @steps = split( /,/, $schedule );
		my $n = 0;
		my $flag = 0;
		my @new;
		foreach my $line ( @steps ){
			my( $int, $config, $uid ) = split( /\//, $line );
			if( $uid eq '' ){
				$flag = 1;
				my $unic = crypt( $c, &main'make_salt() );
				$unic =~ s/[\.|\/|\,]//gi;
				$line = qq|$int/$config/$unic|;
				$c++;
			}
			push @new, $line;
			$n++;
		}
		if( $flag ){
			my $newline = join(",", @new );
			$data[36] = qq|$newline<>$dates|;
			$_ = join( "\t", @data );
		}
		print TMP "$_\n";
	}
	close(PLAN);
	close(TMP);
	
	if( $c > 0 ){
		chmod 0606, $tmp;
		rename $tmp, $logfile;
	}else{
		unlink $tmp;
	}
}


sub page
{
	$id = $main'param{'id'} -0;
	my $action = $main'param{'act'};
	if( $action eq '' ){
		&report_mail();
	}elsif( $action eq 'url' ){
		&report_url();
	}elsif( $action eq 'addr' ){
		&report_addr();
	}elsif( $action eq 'action' ){
		# アドレス編集画面/初期化/削除
		&action();
	}elsif( $action eq 'set_addr' ){
		&renew();
	}
}

sub action
{
	if( defined $main'param{'page_addr'} ){
		return &page_addr();
	}
	foreach( keys %main'param ){
		my $lockfull = &main'lock();
		if( /^DEF-(.+)$/ ){
			&default( $1 );
		}
		if( /^DEL-(.+)$/ ){
			&default( $1 );
		}
		&main'rename_unlock( $lockfull );
	}
	&report_mail();
}

sub get
{
	my( $index ) = @_;
	#-------------------------#
	# 該当するデータを取得    #
	#-------------------------#
	my $id = $main'param{'id'} -0;
	my $file = $main'myroot . $main'data_dir . $main'log_dir . $main'plan_txt;
	unless ( open (FILE, $file) ) {
		&main'error( 'plan', '', "システムエラー<br><br>$fileが開けません<br>パーミッションを確認してください" );
	}
	my $data;
	while( <FILE> ) {
		chomp;
		my @line = split(/\t/);
		if( $line[0] eq $id ) {
			if( $index > 0 ){
				$data =  $line[$index];
			}else{
				$data = $line[82];
			}
			last;
		}
	}
	close(FILE);
	return $data;
}

sub renew
{
	my $MAIN_DATA = &get(); # 転送アドレスデータ群
	my( $count, $list ) = split( /\|/, $MAIN_DATA );
	my @urls;
	my %URL;
	foreach( split( /<>/, $list ) ){
		my( $pid, $name, $url ) = split( /,/);
		if( defined $main'param{"delete-$pid"} ){
			&clean_url($url);
			next;
		}
		push @urls, $_;
		$URL{$name} = 1;
		$URL{$url} = 1;
	}
	if( defined $main'param{'add'} ){
		$count++;
		my $name = &main'the_text( $main'param{'name'} );
		my $http = ($main'param{'http'})? 'https://': 'http://';
		my $url = &main'the_text( $main'param{'url'} );
		#my $uid = crypt( $count, &main'make_salt() );
		$name =~ s/,//g; # 区切り文字を削除
		$url =~ s/,//g; # 区切り文字を削除
		#$uid =~ s/[?|&]//gi; # パラメータに使われる文字列を削除
		
		if( $URL{$name} ){
			&main'make_plan_page( 'plan', '', "すでに同一の識別名を使われています。" );
			exit;
		}
		if( $URL{"$http$url"} ){
			&main'make_plan_page( 'plan', '', "すでに同一のアドレスが指定されています。" );
			exit;
		}
		my $line = qq|$count,$name,$http$url|;
		$line =~ s/\|//g; # 区切り文字を削除
		$line =~ s/[<|>]//g; # 区切り文字を削除
		push @urls, $line;
	}
	my $newlist = join( "<>", @urls );
	$main'param{'action'} = 'click_analy';
	$main'param{'addr'} = qq|$count\|$newlist|;
	&main'renew();
	$MAIN_DATA = $main'param{'addr'};
	&page_addr();
}

sub makeUid
{
	my( $salt ) = @_;
	my $uid = crypt( $salt, &make_salt() );
	$uid =~ s/[?|&|\.|\/]//gi; # パラメータに使われる文字列を削除
	return $uid;
}

sub make_salt {
    srand (time + $$);
    return pack ('CC', int (rand(26) + 65), int (rand(10) +48));
}

sub report_mail
{
	my $step = &get( 36 );
	my( $schedule, $dates ) = split(/<>/, $step );
	my $forward_mail = &getForward_mail();
	my $forward_url = &getForward_url();
	my $queue = &get( 7 );
	my $queuepath = $main'myroot. $main'data_dir. $main'queue_dir. $queue;
	my $rh_body = &main'get_body( $queuepath );
	
	my $regist_code = $id. '-0';
	my $regist_sended = $forward_mail->{$regist_code}->{'sended'} -0;
	my $regist_count = $forward_url->{$regist_code}->{'count'} -0;
	$regist_count = ( $regist_sended > 0 )? qq|<a href="$main'indexcgi?md=click_analy&act=url&id=$id&c=$regist_code"><font color="#0000FF"><strong>$regist_count</strong></font></a>|: 0;
	my $regist_disabled = ( $regist_sended > 0 )? '': ' disabled="disabled"';
	
	# 並び替え
	my @sids = sort{ $forward_mail->{$a}->{'date'} <=> $forward_mail->{$b}->{'date'} } keys %{$forward_mail};
	
	my $main_table =<<"END";
<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td> <form name="form1" method="post" action="$main'indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>送信したメールの「転送アドレス」の反応数やクリック数を分析・計測します。</td>
                                          </tr>
                                          <tr>
                                            <td>転送先アドレスを登録するには、「転送先アドレスを登録する」をクリックください。</td>
                                          </tr>
                                          <tr>
                                            <td>転送アドレスは、メール文作成画面の「簡易タグ」内に表\示されます。</td>
                                          </tr>
                                          <tr>
                                            <td>「反応数」をクリックすると、URL別のレポートが閲覧できます。</td>
                                          </tr>
                                          <tr> 
                                            <td align="center"><table width="480" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td bgcolor="#666666"><table width="480" border="0" cellpadding="15" cellspacing="1">
                                                            <tr>
                                                              <td bgcolor="#FFFFFF">【アクセス分析は以下の手順で行ってください。】<br>
                                                                <br />
                                                                １） 転送先アドレスを登録してください。<br />
                                                                ２） 登録した転送先アドレス「簡易タグ」を本文に記述ください。<br />
                                                                ３） クリック分析の集計結果をご確認ください。<br />
                                                                 ※分析・集計は、転送先アドレスを記述したメールに限られます。<br /></td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                  </table></td>
                                          </tr>
                                          
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td align="center"><input name="page_addr" type="submit" value="転送先アドレスを登録する"></td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>▼ステップメール</td>
                                          </tr>
                                          <tr>
                                            <td><table width="450" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td colspan="2" bgcolor="#FFCC66"><table width="500" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td width="10%" align="center" bgcolor="#FFCC33">配信回</td>
                                                    <td width="50%" align="center" bgcolor="#FFCC33">件名</td>
                                                    <td width="10%" align="center" bgcolor="#FFCC33">送信数</td>
                                                    <td width="10%" align="center" bgcolor="#FFCC33">反応数<br>
                                                      </td>
                                                    <td width="12%" align="center" bgcolor="#FFCC33">&nbsp;</td>
                                                  </tr>
                                                  <tr>
                                                    <td align="center" bgcolor="#FFFFFF">登録時</td>
                                                    <td bgcolor="#FFFFFF">$rh_body->{'0'}->{'subject'}</td>
                                                    <td align="right" bgcolor="#FFFFFF">$regist_sended</td>
                                                    <td align="right" bgcolor="#FFFFFF">$regist_count</td>
                                                    <td align="center" bgcolor="#FFFFFF"><input type="submit" name="DEF-$regist_code" value="初期化" onClick="return confir('集計データをすべて初期化します。\\nよろしいですか？');"$regist_disabled></td>
                                                  </tr>
END
	my $n = 0;
	foreach( split(/,/,$schedule ) ){
		my( $int, $config, $code ) = split(/\//);
		my $step_code = $n+1;
		my $stepNum = $n+2;
		my $subject = $rh_body->{$step_code}->{'subject'};
		my $sended = $forward_mail->{$code}->{'sended'} -0;
		my $count = $forward_url->{$code}->{'count'} -0;
		$count = ( $sended > 0 )? qq|<a href="$main'indexcgi?md=click_analy&act=url&id=$id&c=$code"><font color="#0000FF"><strong>$count</strong></font></a>|: 0;
		
		my $disabled = ( $sended > 0 )? '': ' disabled="disabled"';
		$n++;
		$main_table .= <<"END";
                                                  <tr>
                                                    <td align="center" bgcolor="#FFFFFF">第$stepNum回</td>
                                                    <td bgcolor="#FFFFFF">$subject</td>
                                                    <td align="right" bgcolor="#FFFFFF">$sended</td>
                                                    <td align="right" bgcolor="#FFFFFF">$count</td>
                                                    <td align="center" bgcolor="#FFFFFF"><input type="submit" name="DEF-$code" value="初期化" onClick="return confir('集計データをすべて初期化します。\\nよろしいですか？');"$disabled></td>
                                                  </tr>
END
	}
	$main_table .= <<"END";
                                                </table></td>
                                                </tr>
                                              
                                            </table></td>
                                          </tr>
                                          <tr>
                                            <td align="center">&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>▼一斉メール（登録者へメール送信）</td>
                                          </tr>
                                          <tr>
                                            <td align="center"><table width="450" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td colspan="2" bgcolor="#FFCC66"><table width="500" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td width="16%" align="center" bgcolor="#FFCC33">配信日付</td>
                                                    <td width="46%" align="center" bgcolor="#FFCC33">件名</td>
                                                    <td width="10%" align="center" bgcolor="#FFCC33">送信数</td>
                                                    <td width="10%" align="center" bgcolor="#FFCC33">反応数
                                                      </td>
                                                    <td width="12%" align="center" bgcolor="#FFCC33">&nbsp;</td>
                                                  </tr>
END

	my $sn = 0;
	foreach( keys %{ $forward_mail } ){
		next unless( /^$id-S-.+$/ );
		my $subject = &main'deltag( $forward_mail->{$_}->{'subject'} );
		my $date = &main'make_date3($forward_mail->{$_}->{'date'});
		my $sended = $forward_mail->{$_}->{'sended'} -0;
		my $count = $forward_url->{$_}->{'count'};
		$count = ( $sended > 0 )? qq|<a href="$main'indexcgi?md=click_analy&act=url&id=$id&c=$_"><font color="#0000FF"><strong>$count</strong></font></a>|: 0;
		$sn++;
		$main_table .= <<"END";
                                                  <tr>
                                                    <td bgcolor="#FFFFFF">$date</td>
                                                    <td bgcolor="#FFFFFF">$subject</td>
                                                    <td align="right" bgcolor="#FFFFFF">$sended</td>
                                                    <td align="right" bgcolor="#FFFFFF">$count</td>
                                                    <td align="center" bgcolor="#FFFFFF"><input type="submit" name="DEL-$_" value="削除" onClick="return confir('このメールの集計を停止し、データをすべて削除します。\\nよろしいですか？');"></td>
                                                  </tr>
END
	}
	if( !$sn ){
		$main_table .= <<"END";
                                                  <tr>
                                                    <td colspan="5" align="center" bgcolor="#FFFFFF">転送アドレスを含むメールは、送信されておりません。</td>
                                                  </tr>
END
	}
 	$main_table .= <<"END";
                                                </table></td>
                                                </tr>
                                              
                                            </table></td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td><strong><font color="#FF0000">各計測データは、多くのデータ容量を使用します。<br>
                                              サーバー容量を圧迫するようでしたら、「初期化」もしくは「削除」ボタンにて手動で集計結果を削除してください。</font></strong></td>
                                          </tr>
                                          <tr> 
                                            <td align="center"><input name="md" type="hidden" value="click_analy"><input name="id" type="hidden" value="$id">
                                              <input name="act" type="hidden" value="action"></td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
	return $main_table;
}

sub report_url
{
	my $sid = $main'param{'c'};
	my $forward_url = &getForward_url( $sid );
	my $forward = $forward_url->{$sid}->{'info'};
	my $total_count = $forward_url->{$sid}->{'count'};
	
	# 並び替え
	my @uids = sort{ $forward->{$b}->{'count'} <=> $forward->{$a}->{'count'} } keys %{$forward};
	
	my $main_table = <<"END";
<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td> <form name="form1" method="get" action="index.html">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>URL別の、反応数を表\示します。</td>
                                          </tr>
                                          <tr> 
                                            <td>「反応数」をクリックすると、該当URLをクリックした登録者一覧を表\示します。</td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          
                                          
                                          <tr>
                                            <td><table width="450" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td colspan="2" bgcolor="#FFCC66"><table width="500" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td width="65%" align="center" bgcolor="#FFCC33">URL</td>
                                                    <td width="8%" align="center" nowrap bgcolor="#FFCC33">送信<br>数
                                                      </td>
                                                    <td width="8%" align="center" nowrap bgcolor="#FFCC33">反応<br>数
                                                      </td>
                                                    <td width="9%" align="center" nowrap bgcolor="#FFCC33">反応<br>
                                                      内訳<br></td>
                                                    <td width="9%" align="center" nowrap bgcolor="#FFCC33">反応<br>
                                                      割合</td>
                                                  </tr>
END
	foreach( @uids ){
		my $url = $forward->{$_}->{'url'};
		my $sended = $forward->{$_}->{'sended'};
		my $count = $forward->{$_}->{'count'};
		my $pcount = ( $count > 0 )? qq|<a href="$main'indexcgi?md=click_analy&act=addr&id=$id&c=$sid&u=$_"><font color="#0000FF"><strong>$count</strong></font></a>|: 0;
		my $rate1 = ( $total_count> 0)? int( ($count/$total_count)*1000 ) / 10: 0;
		my $rate2 = ( $sended> 0)? int( ($count/$sended)*1000 ) / 10: 0;
		$main_table .= <<"END";
                                                  <tr>
                                                    <td bgcolor="#FFFFFF">$url</td>
                                                    <td align="right" bgcolor="#FFFFFF">$sended</td>
                                                    <td align="right" bgcolor="#FFFFFF">$pcount</td>
                                                    <td align="right" bgcolor="#FFFFFF">$rate1%</td>
                                                    <td align="right" bgcolor="#FFFFFF">$rate2%</td>
                                                  </tr>
END
	}
	$main_table .= <<"END";
                                                </table></td>
                                                </tr>
                                              
                                            </table></td>
                                          </tr>
                                          <tr>
                                            <td><font color="#FF0000">反応内訳</font><font color="#666666">・・・反応数のURL別内訳割合</font></td>
                                          </tr>
                                          <tr>
                                            <td><font color="#FF0000">反応割合</font><font color="#666666">・・・送信数における、該当URLをクリックした反応数割合</font></td>
                                          </tr>
                                          <tr>
                                            <td align="center">&nbsp;</td>
                                          </tr>
                                          
                                          <tr> 
                                            <td align="center"><input name="id" type="hidden" id="id" value="119613927817216">
                                              <input name="action" type="hidden" id="action"></td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
}
sub report_addr
{
	my $forward = &getForward_addr();
	my $file = &get( 6 );
	my $filepath = $main'myroot. $main'data_dir. $main'csv_dir. $file;
	
	my $main_table = <<"END";
<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td> <form name="form1" method="get" action="URL別レポート.html">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>URLをクリックした登録者を表\示します。</td>
                                          </tr>
                                          
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          
                                          
                                          <tr>
                                            <td><table width="450" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td colspan="2" bgcolor="#FFCC66"><table width="500" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td width="60%" align="center" bgcolor="#FFCC33">メールアドレス</td>
                                                    <td width="25%" align="center" nowrap bgcolor="#FFCC33">お名前</td>
                                                    <td width="15%" align="center" nowrap bgcolor="#FFCC33">クリック数(回)</td>
                                                    </tr>
END
	open( CSV, "<$filepath" );
	while(<CSV>){
		my( $userid, $name, $email ) = ( split(/\t/) )[0,3,5];
		$userid -= 0;
		next unless( defined $forward->{$userid} );
		my $click = $forward->{$userid}->{'click'};
		$main_table .= <<"END";
                                                  <tr>
                                                    <td bgcolor="#FFFFFF">$email</td>
                                                    <td align="center" bgcolor="#FFFFFF">$name</td>
                                                    <td align="right" bgcolor="#FFFFFF">$click</td>
                                                  </tr>
END
		delete $forward->{$userid};
	}
	if( keys %{$forward} ){
		my $count;
		my $click;
		foreach( keys %{$forward} ){
			$count++;
			$click += $forward->{$_}->{'click'};
		}
		$main_table .= <<"END";
                                                  <tr>
                                                    <td bgcolor="#FFFFFF" colspan="2">解除された登録者 (反応数 $count)</td>
                                                    <td align="right" bgcolor="#FFFFFF">$click</td>
                                                  </tr>
END
	}
	$main_table .= <<"END";
                                                </table></td>
                                                </tr>
                                              
                                            </table></td>
                                          </tr>
                                          <tr>
                                            <td><font color="#FF0000">クリック数</font><font color="#666666">・・延べクリック数を含む全クリック回数</font></td>
                                          </tr>
                                          <tr>
                                            <td align="center">&nbsp;</td>
                                          </tr>
                                          
                                          <tr> 
                                            <td align="center"><input name="id" type="hidden" id="id" value="119613927817216">
                                              <input name="action" type="hidden" id="action"></td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
	return $main_table;
}


sub page_addr
{
	my $queue = &get( 7 );
	my $logfile = $main'myroot. $main'data_dir. $main'queue_dir. $queue;
	open( QUE, "<$logfile" );
	my %setTag;
	while(<QUE>){
		chomp;
		my( $qid, $htmlfile ) = ( split(/\t/) )[0,7];
		next if( $qid !~ /^\d+$/ );
		my $htmlpath = $main'myroot. $main'data_dir. $main'queue_dir. $htmlfile;
		while( ( $p ) = ( /<%__([^<>\%]+)__%>/oi ) ) {
			$setTag{$p} = 1;
			s///;
		}
		if( $htmlfile ne '' && -e $htmlpath ){
			open( HTML, "<$htmlpath" );
			while(<HTML>){
				while( ( $p ) = ( /<%__([^<>\%]+)__%>/oi ) ) {
					$setTag{$p} = 1;
					s///;
				}
			}
		}
	}
	close(QUE);
	
	my $MAIN_DATA = &get(); # 転送アドレスデータ群
	my( $count, $list ) = split( /\|/, $MAIN_DATA );
	foreach( split(/<>/, $list) ){
		my( $aid, $name, $url ) = split( /,/ );
		my $tag = 'fw-'. $aid;
		my $disable = ( $setTag{$tag} )? ' disabled="disabled"': '';
		$tr .= <<"END";
                                                  <tr>
                                                    <td bgcolor="#FFFFFF">$name</td>
                                                    <td bgcolor="#FFFFFF">$url</td>
                                                    <td align="center" bgcolor="#FFFFFF"><input type="submit" name="delete-$aid" value="削除" onclick="return confir('本当に削除しますか？');"$disable></td>
                                                  </tr>
END
	}
	if( $tr eq '' ){
		$tr = <<"END";
                                                  <tr>
                                                    <td colspan="3" bgcolor="#FFFFFF">登録されていません</td>
                                                  </tr>
END
	}
	my $main_table =<<"END";
<table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td> <form name="form1" method="post" action="$main'indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>転送先アドレスを登録します。</td>
                                          </tr>
                                          <tr> 
                                            <td>転送アドレスは、メール文作成画面の「簡易タグ」として簡単にメール本文に挿入できます。</td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          
                                          
                                          <tr>
                                            <td><table width="450" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td colspan="2" bgcolor="#FFCC66"><table width="500" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td width="25%" align="center" bgcolor="#FFCC33">転送アドレス名<br>
                                                      (変換タグ名)</td>
                                                    <td align="center" nowrap bgcolor="#FFCC33">URL</td>
                                                    <td width="12%" align="center" nowrap bgcolor="#FFCC33">削除</td>
                                                  </tr>
                                                  $tr
                                                </table></td>
                                                </tr>
                                              
                                            </table></td>
                                          </tr>
                                          <tr>
                                            <td><font color="#FF0000">※本文編集で保存され、現在利用している「転送先アドレス」は削除できません。</font></td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td><table width="500" border="0" cellspacing="1" cellpadding="2">
                                              <tr>
                                                <td colspan="2" bgcolor="#FFCC33">▼新規登録</td>
                                                </tr>
                                              <tr>
                                                <td width="20%" align="right" bgcolor="#FFFFCC">転送アドレス名<br>
                                                  （変換タグ名）</td>
                                                <td bgcolor="#FFFFCC"><input type="text" name="name"></td>
                                              </tr>
                                              <tr>
                                                <td align="right" bgcolor="#FFFFCC">URL</td>
                                                <td bgcolor="#FFFFCC"><select name="http">
                                                  <option value="0">http://</option>
                                                  <option value="1">https://</option>
                                                </select>
                                                  <input name="url" type="text" size="40"></td>
                                              </tr>
                                              <tr>
                                                <td colspan="2" align="center" bgcolor="#FFFFCC"><input name="add" type="submit" value="　登録する　"></td>
                                                </tr>
                                            </table></td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          
                                          <tr> 
                                            <td align="center"><input name="md" type="hidden" value="click_analy"><input name="id" type="hidden" value="$id">
                                              <input name="act" type="hidden" value="set_addr"></td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
	return $main_table;
}

sub getTag
{
	my( $id, $action ) = @_;
	my $hash;
	my $MAIN_DATA = &get(); # 転送アドレスデータ群
	
	my( $hash,  $options ) = &roadTag( $MAIN_DATA );
	return $hash if( $action );
	my $option = qq|<option value=""></option><option value="">▼転送用タグ</option>|;
	$option .= $options;
	$option = '' if( $options eq '' );
	return $option;
}

sub roadTag
{
	my( $data ) = @_;
	my( $count, $list ) = split( /\|/, $data );
	my %url;
	my $options;
	foreach( split(/<>/, $list) ){
		my( $aid, $name, $url ) = split( /,/ );
		my $tagkey = 'fw-'. $aid;
		$url{$tagkey}->{'id'} = $aid;
		$url{$tagkey}->{'name'} = $name;
		$url{$tagkey}->{'url'} = $url;
		$options .= qq|<option value="&lt;%__$tagkey\__%&gt;">$name　&lt;%__$tagkey\__%&gt;</option>\n|;
	}
	return {%url}, $options;
}

# タグ解析
sub analyTag
{
	my( $pid, $body, $tag, $sid, $forward, $prev ) = @_;
	my $cgiscript = $main'applycgi;
	my %detail;
	my $c = 0;
	
	local $_ = $body;
	while( ( $p ) = ( /<%__([^<>\%]+)__%>/oi ) ) {
		my $url = $tag->{$p}->{'url'};
		my $name = $tag->{$p}->{'name'};
		my $fw;
		if( $prev ){
			$fw = qq|<\#\#$name\#\#>| if( $url ne '' );
		}else{
			$uniq_counter++;
			my $uid;
			if( $forward->{$sid}->{'url'}->{$url} ne '' ){
				$uid = $forward->{$sid}->{'url'}->{$url};
			}else{
				$uid = &makeUid($uniq_counter);
			}
			$detail{$uid} = $url;
			$fw = $cgiscript. '?U='. $uid. '&I='. $pid;
			$fw = '' if( $url eq '' );
			
			# 短縮URLデータを再保存(以後の送信時判定のため)
			$forward->{$sid}->{'url'}->{$url} = $uid if( $fw ne '' );
		}
		s//$fw/;
	}
	return $_, {%detail};
}

# 転送短縮URL仮データを生成
sub setForward_t
{
	my( $detail, $sid, $subject, $prev ) = @_;
	return unless( keys %{ $detail } ); # 短縮が無い場合
	
	my $stepfilepath = $forwarddir. 'FWD-STEP-'. $sid. '.cgi';
	my $def;
	
	# メール別送信データ
	unless( -e $stepfilepath ){
		$def = 1;
	}
	open( FWD, ">>$stepfilepath" );
	if( $def ){
		my $date = time;
		# 生成されていなかった場合は、識別情報を挿入
		print FWD qq|subject\t$subject\n|;
		print FWD qq|date\t$date\n|;
		print FWD qq|\n|; # ヘッダ終了
	}
	print FWD "1\n" if( !$prev );
	close(FWD);
	
	foreach my $uid ( keys %{ $detail } ){
		my $url = $detail->{$uid};
		next if( $url eq '' );
		# URL別送信データ
		my $logfile = $forwarddir. 'FWD-URL-'. $uid. '.cgi';
		my $def = 0;
		unless( -e $logfile ){
			$def = 1;
		}
		open( FWD, ">>$logfile" );
		if( $def ){
			# 生成されていなかった場合は、識別情報を挿入
			print FWD qq|sid\t$sid\n|;
			print FWD qq|url\t$url\n|;
			print FWD qq|\n|; # ヘッダ終了
		}
		print FWD "1\n" if( !$prev );
		close(FWD);
	}
}

sub pickup
{
	my( $flag ) = @_;
	my $lockfull = &main'lock();
	
	# 各プランのステップにユニークコードを設定する
	&disorder() if( !$flag );
	
	opendir DIR, $forwarddir;
	my @files = readdir DIR;
	close(DIR);
	foreach( @files ){
		if( /^FWD-STEP-(.+)\.cgi$/ ){
			&countStep('step', $_, $1);
		}
		if( /^FWD-URL-(.+)\.cgi$/ ){
			&countUrl('url', $_, $1);
		}
	}
	&main'rename_unlock( $lockfull );
}
sub countStep
{
	my( $act, $filename, $sid ) = @_;
	my $filepath = $forwarddir. $filename;
	my $count = 0;
	my $head = 1;
	my $subject;
	my $date;
	
	open( FWD, "<$filepath" );
	while(<FWD>){
		chomp;
		if( $_ eq ''){
			$head = 0;
			next;
		}
		if( $head ){
			my @data = split( /\t/ );
			$subject = $data[1] if( $data[0] eq 'subject' );
			$date = $data[1] if( $data[0] eq 'date' );
			next;
		}
		$count++;
	}
	close(FWD);
	
	my $flag = 0;
	my $tmp = $forwarddir. 'S-'. time. $$. '.cgi';
	open( LOG, "<$steplogfile" );
	open( TMP, ">$tmp" );
	chmod 0606, $tmp;
	while(<LOG>){
		chomp;
		my @data = split(/\t/);
		if( $data[0] eq $sid ){
			$flag = 1;
			$data[3] += $count;
			$_ = join("\t",@data);
		}
		print TMP "$_\n";
	}
	if( !$flag ){
		print TMP qq|$sid\t$subject\t$date\t$count\n|;
	}
	
	close(LOG);
	close(TMP);
	rename $tmp, $steplogfile;
	unlink $filepath;
}
sub countUrl
{
	my( $act, $filename, $uid ) = @_;
	my $filepath = $forwarddir. $filename;
	my $count = 0;
	
	my $head = 1;
	my $sid;
	my $url;
	open( FWD, "<$filepath" );
	while(<FWD>){
		chomp;
		if( $_ eq ''){
			$head = 0;
			next;
		}
		if( $head ){
			my @data = split( /\t/ );
			$sid = $data[1] if( $data[0] eq 'sid' );
			$url = $data[1] if( $data[0] eq 'url' );
			next;
		}
		$count++;
	}
	close(FWD);
	
	my $flag = 0;
	my $tmp = $forwarddir. 'U-'. time. $$. '.cgi';
	open( LOG, "<$uidlogfile" );
	open( TMP, ">$tmp" );
	chmod 0606, $tmp;
	while(<LOG>){
		chomp;
		my @data = split(/\t/);
		if( $data[0] eq $uid ){
			$flag = 1;
			$data[3] += $count;
			$_ = join("\t",@data);
		}
		print TMP "$_\n";
	}
	if( !$flag ){
		print TMP qq|$uid\t$sid\t$url\t$count\n|;
	}
	
	close(LOG);
	close(TMP);
	rename $tmp, $uidlogfile;
	unlink $filepath;
}


sub getForward_mail
{
	my %hash;
	open( LOG, "<$steplogfile" );
	while( <LOG> ){
		chomp;
		my( $sid, $subject, $date, $sended ) = split( /\t/ );
		$hash{$sid}->{'subject'} = $subject;
		$hash{$sid}->{'date'} = $date;
		$hash{$sid}->{'sended'} = $sended;
	}
	close(LOG);
	return {%hash};
}

sub getForward_url
{
	my( $target_id ) = @_;
	my %hash;
	open( LOG, "<$uidlogfile" );
	while( <LOG> ){
		chomp;
		my( $uid, $sid, $url, $sended, $count ) = split( /\t/ );
		next if( $target_id ne '' && $target_id ne $sid );
		$hash{$sid}->{'info'}->{$uid}->{'url'} = $url;
		$hash{$sid}->{'info'}->{$uid}->{'sended'} = $sended;
		$hash{$sid}->{'info'}->{$uid}->{'count'} = $count;
		$hash{$sid}->{'url'}->{$url} = $uid;
		#$hash{$sid}->{'sended'} = $sended;
		$hash{$sid}->{'count'} += $count;
	}
	close(LOG);
	return {%hash};
}

sub getForward_addr
{
	my $uid = $main'param{'u'};
	my $sid = $main'param{'c'};
	
	my $forward_mail = &getForward_mail();
	unless( defined $forward_mail->{$sid} ){
		&main'make_plan_page('plan', '', "指定したアクセス情報がありません。");
	}
	
	my %hash;
	my $logfile = $forwarddir. $sid. $clickfile;
	open( LOG, "<$logfile" );
	while(<LOG>){
		my( $myid, $userid, $click ) = split(/\t/);
		next if( $myid ne $uid );
		$userid -= 0;
		$hash{$userid}->{'click'} = $click;
	}
	close(LOG);
	return {%hash};
}

# 転送
sub forwarding
{
	my $target = $main'param{'U'};
	my $userid = $main'param{'I'};
	my $location;
	my $sid;
	
	open( LOG, "<$uidlogfile" );
	while( <LOG> ){
		chomp;
		my( $uid, $_sid, $_url, $_sended, $_count ) = split( /\t/ );
		if( $uid eq $target ){
			$location = $_url;
			$sid = $_sid;
			last;
		}
	}
	close(LOG);
	
	my $forward_mail = &getForward_mail();
	unless( defined $forward_mail->{$sid} ){
		print "Location: $location", "\n" if( $location ne '');
		print "Content-type: text/html","\n\n";
		print <<"END";
<html>
<head>
<body>
転送先アドレスが見つかりません。
</body>
</head>
</html>
END
		exit;
	}
	
	if( $userid <= 0 ){
		goto LOC;
	}
	
	my $tmp = $forwarddir. 'CK-'. time. $$. '.cgi';
	my $logfile = $forwarddir. $sid. $clickfile;
	my $count = 0;
	my $lockfull = &main'lock();
	
	my $flag = 0;
	open( TMP, ">$tmp" );
	chmod 0606, $tmp;
	open( FWD, "<$logfile" );
	while( <FWD> ){
		chomp;
		my @data = split(/\t/);
		if( $data[0] eq $target && $data[1] eq $userid ) {
			$flag = 1;
			$data[2]++;
			$_ = join( "\t", @data );
		}
		print TMP "$_\n";
	}
	if( !$flag ){
		print TMP "$target\t$userid\t1\n";
	}
	close(FWD);
	close(TMP);
	
	if( !$flag ){
		&countUp( $target );
	}
	rename $tmp, $logfile;
	
	LOC:
	&main'rename_unlock( $lockfull );
	
	print "Location: $location", "\n";
	print "Content-type: text/html","\n\n";
	
	print <<"END";
<html>
<head>
location.href = '$location';
</head>
</html>
END
	exit;
}

sub countUp
{
	my $uid = shift;
	my $tmp = $forwarddir. 'UP-'. time. $$. '.cgi';
	open( TMP, ">$tmp" );
	chmod 0606, $tmp;
	open( FWD, "<$uidlogfile" );
	while( <FWD> ){
		chomp;
		my @data = split(/\t/);
		if( $data[0] eq $uid ) {
			$data[4]++;
			$_ = join( "\t", @data );
		}
		print TMP "$_\n";
	}
	close(FWD);
	close(TMP);
	rename $tmp, $uidlogfile;
}


# プレビュー変換
sub prev1
{
	my( $id, $message ) = @_;
	my $tag = &getTag( $id, 1 );
	
	my $detail;
	( $message, $detail ) = &analyTag( '', $message, $tag, '', '', 1 );
	return $message;
}

sub prev2
{
	my( $str ) = @_;
	$str =~ s/<\#\#(.*?)\#\#>/<em><font color=#336600>&lt;$1&gt;<\/font><\/em>/g;
	$str =~ s/&lt;\#\#(.*?)\#\#&gt;/<em><font color="#336600">&lt;$1&gt;<\/font><\/em>/g;
	return $str;
}

sub default
{
	my( $sid, $delete ) = @_;
	
	my $filepath = $forwarddir. $sid. $clickfile;
	unlink $filepath if( -e $filepath );
	
	
	my $tmp_uid = $forwarddir. 'UID-'. time. $$. '.cgi';
	open( TMP, ">$tmp_uid" );
	chmod 0606, $tmp_uid;
	open( LOG, "<$uidlogfile" );
	while(<LOG>){
		chomp;
		my @data = split( /\t/ );
		if( $sid eq $data[1] ){
			$data[1] = '';
			$data[3] = 0;
			$data[4] = 0;
			$_ = join("\t", @data);
		}
		print TMP "$_\n";
	}
	
	close(LOG);
	close(TMP);
	rename $tmp_uid, $uidlogfile;
	
	my $tmp_step = $forwarddir. 'STP-'. time. $$. '.cgi';
	open( TMP, ">$tmp_step" );
	chmod 0606, $tmp;
	open( LOG, "<$steplogfile" );
	while(<LOG>){
		chomp;
		my @data = split( /\t/ );
		if( $sid eq $data[0] ){
			if( $data[0] =~ /^\d+-S/ || $delete ){
				next;
			}
			$data[3] = 0;
			$_ = join("\t", @data);
		}
		print TMP "$_\n";
	}
	
	close(LOG);
	close(TMP);
	rename $tmp_step, $steplogfile;
}

sub clean
{
	my( @ids ) = @_;
	
	foreach( @ids ){
		my $filepath = $forwarddir. $_. $clickfile;
		unlink $filepath if( -e $filepath );
	}
	
	my $idline = join( "\/", @ids );
	$idline = '/'. $idline. '/';
	
	my $tmp_uid = $forwarddir. 'UID-'. time. $$. '.cgi';
	open( TMP, ">$tmp_uid" );
	chmod 0606, $tmp_uid;
	open( LOG, "<$uidlogfile" );
	while(<LOG>){
		chomp;
		my @data = split( /\t/ );
		if( index( $idline, $data[1]) >= 0  ){
			next;
		}
		if( $data[1] =~ /^(\d+)-S/ ){
			if( index( $idline, "$1\/" ) >= 0 ){
				next;
			}
		}
		if( $data[1] =~ /^(\d+)-0/ ){
			if( index( $idline, "$1\/" ) >= 0 ){
				next;
			}
		}
		print TMP "$_\n";
	}
	
	close(LOG);
	close(TMP);
	rename $tmp_uid, $uidlogfile;
	
	my $tmp_step = $forwarddir. 'STP-'. time. $$. '.cgi';
	open( TMP, ">$tmp_step" );
	chmod 0606, $tmp;
	open( LOG, "<$steplogfile" );
	while(<LOG>){
		chomp;
		my @data = split( /\t/ );
		if( index( $idline, $data[0]) >= 0  ){
			next;
		}
		if( $data[0] =~ /^(\d+)-S/ ){
			if( index( $idline, "$1\/" ) >= 0 ){
				next;
			}
		}
		if( $data[0] =~ /^(\d+)-0/ ){
			if( index( $idline, "$1\/" ) >= 0 ){
				next;
			}
		}
		print TMP "$_\n";
	}
	
	close(LOG);
	close(TMP);
	rename $tmp_step, $steplogfile;
}
sub clean_url
{
	my( $url ) = @_;
	my $tmp_uid = $forwarddir. 'UID-'. time. $$. '.cgi';
	open( TMP, ">$tmp_uid" );
	chmod 0606, $tmp_uid;
	open( LOG, "<$uidlogfile" );
	while(<LOG>){
		chomp;
		my @data = split( /\t/ );
		if( $data[2] eq $url  ){
			next;
		}
		print TMP "$_\n";
	}
	
	close(LOG);
	close(TMP);
	rename $tmp_uid, $uidlogfile;
	
}
1;
