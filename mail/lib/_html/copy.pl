package Copy;

sub form
{
	my( $err, $step, $interval ) = @_;
	my %param = %main'param;
	my $def = 1 if( !$err );
	my $bs = ( $def || $param{'bs'} )? ' checked=checked': '';
	my $header = ( $def || $param{'header'} )? ' checked=checked': '';
	my $cancel = ( $def || $param{'cancel'} )? ' checked=checked': '';
	my $footer = ( $def || $param{'footer'} )? ' checked=checked': '';
	my $redirect = ( $def || $param{'redirect'} )? ' checked=checked': '';
	my $form1 = ( $def || $param{'form1'} )? ' checked=checked': '';
	my $form2 = ( $def || $param{'form2'} )? ' checked=checked': '';
	my $ctm = ( $def || $param{'ctm'} )? ' checked=checked': '';
	my $schedule = ( $def || $param{'schedule'} )? ' checked=checked': '';
	my $mailbody = ( $def || $param{'mailbody'} )? ' checked=checked': '';
	my $guest = ( $def || $param{'guest'} )? ' checked=checked': '';
	my $forward = ( $def || $param{'forward'} )? ' checked=checked': '';
	my $id = $param{'id'} -0;
	my $nid = time . $$;
	
	
	# ステップメール日程を取得
	my( $step, $script_array ) = &main'scheduleOption( $step, $interval );
	
	my $table = <<"END";
<script type="text/javascript"><!--

chk = new Array();
chk['end'] = 0;
$script_array

function Interval(){
	var index = document.form1.step.selectedIndex;
	var val = document.form1.step.options[index].value;
	if( val == ''){
		return;
	}
	if( chk[val] > 0 ){
		document.form1.interval.disabled = false;
		document.form1.interval.style.backgroundColor = '#FFFFFF';
		
	}else{
		document.form1.interval.disabled = true;
		document.form1.interval.value = '';
		document.form1.interval.style.backgroundColor = '#CCCCCC';
	}
}
function winLoad(){
	if (window.addEventListener) { //for W3C DOM
		window.addEventListener("load", Interval, false);
	}else if (window.attachEvent) { //for IE
		window.attachEvent("onload", Interval);
	}else  {
		window.onload = Interval;
	}
}
winLoad();

// -->
</script>
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td width="20">&nbsp;</td>
                                          <td width="500"><table width="500" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td width="500"><form name="form1" method="post" action="$main'indexcgi">
                                                    <table width="490" border="0" cellspacing="0" cellpadding="2">
                                                      <tr>
                                                        <td width="840">このプランの情報を元に<strong>新規プラン</strong>を作成することができます。<br>
                                                          新規プランの<strong>「プラン名」</strong>を入力し、必要な情報を選択後、<strong>「作成」</strong>ボタンを<br>
                                                          クリックしてください。<br>&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td align="left"><table width="490" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td bgcolor="#ABDCE5"><table width="490" border="0" cellpadding="4" cellspacing="1">
                                                                  <tr>
                                                                    <td width="100" bgcolor="#E5FDFF">プラン名</td>
                                                                    <td width="350" bgcolor="#FFFFFF"><input name="plan_name" type="text" id="plan_name" size="40"></td>
                                                                  </tr>
                                                                  <tr>
                                                                    <td rowspan="6" bgcolor="#E7FFFF">各種設定</td>
                                                                    <td bgcolor="#FFFFFF"><input name="bs" type="checkbox" id="bs" value="1"$bs>
                                                                      配信元情報</td>
                                                                  </tr>
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF"><input name="header" type="checkbox" id="header" value="1"$header>
                                                                      ヘッダー　
                                                                      <input name="cancel" type="checkbox" id="cancel" value="1"$cancel>
                                                                      解除案内
                                                                      <input name="footer" type="checkbox" id="footer" value="1"$footer>
                                                                      フッター</td>
                                                                  </tr>
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF"><input name="redirect" type="checkbox" id="redirect" value="1"$redirect>
                                                                      登録設定</td>
                                                                  </tr>
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF"><input name="form1" type="checkbox" id="form1" value="1"$form1>
                                                                      登録用フォーム
                                                                      <input name="form2" type="checkbox" id="form2" value="1"$form2>
                                                                      変更・解除フォーム</td>
                                                                  </tr>
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF"><input name="ctm" type="checkbox" id="ctm" value="1"$ctm>
                                                                      画面カスタマイズ<br>※「登録用フォーム」をコピーしない場合、「入力確認画面」の設定は<br>　 コピーされません。</td>
                                                                  </tr>
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF"><input name="forward" type="checkbox" id="forward" value="1"$forward>
                                                                      転送先アドレス</td>
                                                                  </tr>
                                                                  <tr>
                                                                    <td bgcolor="#E7FFFF">配信日程・本文</td>
                                                                    <td bgcolor="#FFFFFF"><input name="schedule" type="checkbox" id="schedule" value="1"$schedule>
                                                                      日程・本文<br>
                                                                      ※ヘッダ・解除案内・フッターは挿入チェックが対象となります。<br>
                                                                      ※HTMLファイル名は、[ファイル名_日付]として作成されます。</td>
                                                                  </tr>
                                                                  <tr>
                                                                    <td bgcolor="#E7FFFF">登録者情報</td>
                                                                    <td bgcolor="#FFFFFF"><input name="guest" type="checkbox" id="guest" value="1"$guest>
                                                                      登録者情報<br>
                                                                      ※配信履歴は初期化されます。<br>
                                                                      ※登録日付はコピーを実行した日付となります。<br>
                                                                      ※重複登録されているメールアドレスは最新のデータが<br>　 対象となります。<br>
                                                                      <br>
                                                                      ▼配信開始回： 
																	  <select name="step" onchange="Interval();">
																	  $step
																	  </select><br>
																	  ▼配信開始日： <input id="interval" type="text" name="interval" size="5" disabled style="background-color:#CCCCCC;">日後から開始<br><font color="#FF0000">※再開時配信回を指定した場合は、開始日を入力してください。</font>
																	  <br><font color="#FF0000">※「登録時」のメールは送信されません。</font><br>
                                                                      <font color="#FF0000">※「配信日程」データをコピーする必要があります。</font></td>
                                                                  </tr>
                                                                  
                                                              </table></td>
                                                            </tr>
                                                          </table>
                                                          <br>
                                                          <input name="id" type="hidden" id="id" value="$id">
                                                          <input name="md" type="hidden" id="md" value="make_copy">
                                                          <input name="ボタン" type="submit" value="　　　作成　　　" onClick="return confir('プランを作成します。\\nよろしいですか？');">
                                                          <input name="nid" type="hidden" id="nid" value="$nid"></td>
                                                      </tr>
                                                    </table>
                                                  </form></td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
END
	return $table;
}

sub copy
{
	my %param = %main'param;
	my $plan_name = &main'delspace( &main'deltag($param{'plan_name'}) );
	my $bs = $param{'bs'}-0;
	my $header = $param{'header'}-0;
	my $cancel = $param{'cancel'}-0;
	my $footer = $param{'footer'}-0;
	my $redirect = $param{'redirect'}-0;
	my $form1 = $param{'form1'}-0;
	my $form2 = $param{'form2'}-0;
	my $ctm = $param{'ctm'}-0;
	my $schedule = $param{'schedule'}-0;
	my $mailbody = $param{'mailbody'}-0;
	my $guest = $param{'guest'}-0;
	my $id = $param{'id'} -0;
	my $nid = $param{'nid'} -0;
	
	my $step = $param{'step'};
	my $interval = $param{'interval'};
	
	my $forward = $param{'forward'}-0;
	
	my $file = $main'myroot . $main'data_dir . $main'log_dir . $main'plan_txt;
	unless ( open (FILE, $file) ) {
		&main'make_plan_page( 'plan', '', "システムエラー<br><br>$fileが開けません<br>パーミッションを確認してください" );
	}
	while( <FILE> ) {
		chomp;
		@line = split(/\t/);
		if( $line[0] eq $id ) {
			last;
		}else{
			undef @line;
			# リロード用の処理
			if( $nid eq $line[0] ){
				$main'param{'id'} = $nid;
				&main'make_plan_page( 'plan', 'all' );
			}
		}
	}
	close(FILE);
	
	if( $schedule ){
		my( $steps, $date ) = split( /<>/, $line[36] );
		my $n = 2;
		foreach( split(/,/, $steps ) ) {
			my( $int, $config, $uniq ) = split( /\//);
			if( $step == $n ){
				if( $config && $interval <= 0 ){
					&main'make_plan_page( 'plan', '', "配信開始日を指定してください。" );
				}
			}
			$n++;
		}
	}
	
	
	my $guest_log = $main'myroot. $main'data_dir. $main'csv_dir. $line[6];
	my $queue_log = $main'myroot. $main'data_dir. $main'queue_dir. $line[7];
	
	#---------------------#
	# テンポラリファイル  #
	#---------------------#
	my $tmp = $main'myroot . $main'data_dir . $main'log_dir . $id . '.tmp';
	unless ( open(TMP, ">$tmp" ) ) {
		&main'make_plan_page('plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリファイルが作成できません<br>$data_dirディレクトリのパーミッションを確認してください");
		exit;
	}
	chmod 0606, $tmp;
	
	# ここからコピー情報を埋め込む
	
	if( $plan_name eq '' ){
		$plan_name = $line[2] . 'のコピー';
	}
	$line[0] = $nid;
	$line[1] = time;
	$line[2] = $plan_name;
	$line[37] = 0; # 停止中として作成
	$line[76] = ''; # 稼働時間は初期値
	my %path; # 参照ファイルと作成ファイルパス
	# 配信元情報
	if( !$bs ){
		$line[3] = '';
		$line[4] = '';
		$line[5] = '';
	}
	# ヘッダ
	if( !$header ){
		$line[9] = '';
	}
	# 解除案内
	if( !$cancel ){
		$line[10] = '';
	}
	# フッタ
	if( !$footer ){
		$line[11] = '';
	}
	# 登録設定
	if( !$redirect ){
		$line[12] = '';
		$line[13] = '';
		$line[14] = '';
		$line[38] = '';
		$line[39] = '';
		$line[40] = '';
		$line[41] = '';
		$line[42] = '';
		$line[60] = '';
	}
	# 登録用フォーム
	if( !$form1 ){
		my %regformdata = &Ctm'regulation_dataline();
		foreach( keys %regformdata ){
			my $index = $regformdata{$_};
			$line[$index] = '';
		}
	}
	# 変更・解除フォーム
	if( !$form2 ){
		$line[33] = '';
		$line[34] = '';
	}
	# 画面カスタマイズ
	
	if( $ctm ){
		my @type = ( 'err', 'end', 'renew', 'delete' );
		if( $form1 ){
			push @type, 'conf';
		}
		foreach my $md( @type ){
			my( $default_file, $ctm_file, $target_file ) = &Ctm'get_path( $id, $md );
			my( $_default_file, $_ctm_file, $_target_file ) = &Ctm'get_path( $line[0], $md );
			if( -f $ctm_file ){
				$path{$ctm_file} = $_ctm_file;
			}
			
			# 携帯用
			my( $default_file_m, $ctm_file_m, $target_file_m ) = &Ctm'get_path( $id, $md, 1 );
			my( $_default_file_m, $_ctm_file_m, $_target_file_m ) = &Ctm'get_path( $line[0], $md, 1 );
			if( -f $ctm_file_m ){
				$path{$ctm_file_m} = $_ctm_file_m;
			}
		}
	}
	
	# 転送アドレス
	if( !$forward ){
		$line[82] = '';
	}else{
		my( $num, $addr ) = split(/\|/, $line[82] );
		my $count = 0;
		my @new;
		foreach( split(/<>/,$addr) ){
			$count++;
			my( $_id, $name, $url ) = split(/,/);
			push @new, qq|$count,$name,$url|;
		}
		my $new_addr = join("<>", @new );
		$line[82] = "$count|$new_addr";
	}
	
	# 日程
	if( !$schedule ){
		$line[35] = '';
		$line[36] = '';
		$line[77] = '';
	}else{
		my( $steps, $date ) = split( /<>/, $line[36] );
		my $count = 1;
		my @new;
		foreach( split(/,/, $steps ) ) {
			my( $int, $config, $uniq ) = split( /\//);
			my $new_uniq = &makeUid( $count );
			push @new, qq|$int/$config/$new_uniq|;
		}
		my $new_step = join( ",", @new );
		$line[36] = qq|$new_step<>$date|;
	}
	
	# 各ファイル名
	$line[6] = 'C'. $line[0]. '.cgi';
	$line[7] = 'Q'. $line[0]. '.cgi';
	$line[8] = 'L'. $line[0]. '.cgi';
	my $_guest_log = $main'myroot. $main'data_dir. $main'csv_dir. $line[6];
	my $_queue_log = $main'myroot. $main'data_dir. $main'queue_dir. $line[7];
	my $_log_log = $main'myroot. $main'data_dir. $main'log_dir. $line[8];
	# 本文
	my %queue;
	if( $schedule ){
		$path{$queue_log} = $_queue_log;
		$queue{$queue_log} = 1;
	}
	
	my $new_line = join( "\t", @line ) . "\n";
	
	# 情報ファイルを生成
	open( FILE, ">$_guest_log" );
	close(FILE);
	chmod 0606, $_guest_log;
	
	open( FILE, ">$_queue_log" );
	close(FILE);
	chmod 0606, $_queue_log;
	
	open( FILE, ">$_log_log" );
	close(FILE);
	chmod 0606, $_log_log;
	
	
	if( keys %path ){
		my $now = time;
		foreach my $filepath ( keys %path ){
			my $make_file_path = $path{$filepath};
			
			# 本文データの場合
			my $queue = ( $queue{$filepath} )? 1: 0;
			
			open( PATH, $filepath );
			open( MAKE, ">$make_file_path" );
			while(<PATH>){
				if( $queue ){
					chomp;
					my @mail = split(/\t/);
					if( $mail[7] ne '' ){
						my $newfilename = '';
						my $dir = "$main'myroot$main'data_dir$main'queue_dir";
						my $htmlpath = $dir. $mail[7];
						if( -f $htmlpath ){
							$newfilename = &check_copy_htmlfile( $dir, $mail[7] );
							my $_htmlpath = $dir. $newfilename;
							open( HTML, $htmlpath );
							open( NHTML, ">$_htmlpath" );
							while(my $line = <HTML> ){
								print NHTML $line;
							}
							close(NHTML);
							close(HTML);
							chmod 0606, $_htmlpath;
						}
						$mail[7] = $newfilename;
						$_ = join( "\t", @mail );
					}
					$_ .= "\n";
				}
				print MAKE $_;
			}
			close(PATH);
			close(MAKE);
			chmod 0606, $make_file_path;
		}
	}
	if( $guest ){
		my $sendlog;
		if( $step ne '' && $schedule ){
			my $baseNum = &main'getBaseNum( $line[36], $step );
			if( $baseNum > 1 ){
				my $now = time;
				$sendlog = qq|$baseNum/$now|;
			}
		}
		my %ed;
		my $now = time;
		open( GUEST, $guest_log );
		open( MAKE, ">$_guest_log" );
		while(<GUEST>){
			chomp;
			my @data = split(/\t/);
			next if( $ed{$data[5]} );
			$ed{$data[5]} = 1;
			$data[19] = $now;
			$data[20] = '';
			$data[21] = $now;
			$data[51] = $step if( $schedule && $step ne '' );
			$data[52] = '';
			$data[53] = $sendlog;
			$data[54] = qq|$interval/$now| if( $schedule && $interval > 0 );
			my $newline = join( "\t", @data ) . "\n";
			print MAKE $newline;
		}
		close(GUEST);
		close(MAKE);
		chmod 0606, $_guest_log;
	}
	
	# フォームタイプ
	my $detailfile = &MF'_getlogfile();
	my @detail_line;
	open( DETAIL, $detailfile );
	while( <DETAIL> ){
		my $_id = $_ -0;
		if( $_id eq $id ){
			chomp;
			my @data = split(/\t/);
			$data[0] = $line[0];
			my $line = join( "\t", @data );
			push @detail_line, "$line\n";
		}
	}
	close(DETAIL);
	open( DETAIL, ">>$detailfile");
	print DETAIL @detail_line;
	close(DETAIL);
	
	# データファイルを作成
	print TMP $new_line;
	open( PLAN, "<$file" );
	while(<PLAN>){
		print TMP $_;
	}
	close(PLAN);
	close(TMP);
	rename $tmp, $file;
	
	$main'param{'id'} = $line[0];
	&main'make_plan_page( 'plan', 'all' );
	exit;
}
sub check_copy_htmlfile
{
	my( $dir, $filename ) = @_;
	my $now = time;
	my $code = &main'make_datecode( $now );
	$filename =~ /^(.+)\.(.+)$/;
	my $_file = $1;
	my $_ext = $2;
	if( $_file =~ /^(.+)\_(\d\d\d\d\d\d\d\d)(\_)?/ ){
		$_file = $1;
	}
	my $_filename = $_file . "_$code". ".$_ext";
	my $filepath = $dir. $_filename;
	my $n = 1;
	while(1){
		if( -f $filepath ){
			$n++;
			$_filename = $_file . "_$code". '_'. $n. ".$_ext";
			$filepath = $dir. $_filename;
		}else{
			return $_filename;
		}
	}
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

1;
