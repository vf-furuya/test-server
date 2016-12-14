
package Simul;

#--------------------------------------------
# 楽メールpro
# 一斉メール送信関連関数群
# ver2.4
#--------------------------------------------

# 互換性チェック
&compatibility();

sub running
{
	my $chk = shift;
	my $hash_path = &get_path();
	my $hash_rule = &get_send_rule();
	
	# 配信中の場合
	if( -e $hash_path->{'control'} ){
		
		my $method = $hash_rule->{'method'} - 0;
		if( $method > 0 ){
			my $now = time;
			my $date = ( stat($hash_path->{'control'}) )[9];
			# 最後の更新から5分以内であれば配信中
			if( $date + (60*5) > $now ){
				return 0 if( $chk );
				&disp_background(0, 0, $hash_rule );
			}
			# 送信フラグ
			&make_flag( $hash_path->{'flag'}, 0 );
			# エラーログへ追加
			&print_errlog( $date );
			return 1 if( $chk );
			&disp_background( 1, 1, $hash_rule );
		}else{
			return 0 if( $chk );
			&disp_manual( 2, $hash_rule );
		}
	}
}


sub get_method
{
	my $path = $main'myroot . $main'data_dir . $main'methodtxt;
	unless ( open(MET, $path) ) {
		&error('システムエラー', '送信形式データファイルが開けません');
	}
	my %METHOD;
	while( <MET> ) {
		chomp;
		my ( $name, $val ) = split(/\t/);
		$METHOD{$name} = $val;
	}
	close(MET);
	
	$METHOD{'each'}      = 100 if($METHOD{'each'} <= 0);
	$METHOD{'sleep'}     = 30 if($METHOD{'sleep'} <= 0);
	$METHOD{'partition'} = 50 if($METHOD{'partition'} <= 0);
	
	return \%METHOD;
}


sub make_config
{
	my $action = shift;
	my $hash_path = &get_path();
	my $hash_plan = &get_plan();
	my $method = $main'param{'method'} - 0;
	
	# ユニークIDをチェック
	open( UNIQ, "<$hash_path->{'uniq'}" );
	my $uniq = <UNIQ>;
	close(UNIQ);
	
	if( $uniq eq $main'param{'uniq'} ){
		&main'make_plan_page( 'plan', 'mail' );
		exit;
	}
	my $dir = &compatibility();
	my $tmp = $dir. 'U-'. $$. time. '.cgi';
	open( UNIQ, ">$tmp" );
	print UNIQ $main'param{'uniq'};
	close(UNIQ);
	chmod 0606, $tmp;
	rename $tmp, $hash_path->{'uniq'};
	
	
	# 配信ルールを設定
	&make_rule( $hash_path->{'rule'}, $hash_plan );
	
	# 本文を設定
	&make_mail( $hash_path->{'mail'}, $hash_plan );
	
	# 配信リストを設定
	&make_list( $hash_path->{'list'}, $action );
	
	# 配信制御ファイルの有効性をONに設定
	&make_control( $hash_path->{'control'}, 'default' );
	
	# 送信フラグ
	&make_flag( $hash_path->{'flag'}, 0 );
	
	# 画面遷移
	if( $method > 0 ){
		# バックグラウンド配信
		&disp_background( 1 );
	}else{
		# 手動配信(一度だけ配信を実行)
		&make_flag( $hash_path->{'flag'}, 1 );
		&send_manual();
	}
}

sub make_rule
{
	my( $path, $hash_plan ) = @_;
	my $method = $main'param{'method'} - 0;
	my $id = $main'param{'id'} - 0;
	my $start = time;
	my $subject = &main'_deltag( $main'param{'title'} );
	
	my $dir = &compatibility();
	my $tmp = $dir. 'R-'. $$. time. '.cgi';
	open( RULE, ">$tmp" );
	print RULE "$method\n";
	print RULE "$id\n";
	print RULE "$hash_plan->{'plan_name'}\n";
	print RULE "$start\n";
	print RULE "$subject\n";
	print RULE "$hash_plan->{'admin'}\n";
	print RULE "$main'param{'uniq'}\n";
	close(RULE);
	chmod 0606, $tmp;
	rename $tmp, $path;
}

sub make_mail
{
	my( $path, $hash_plan ) = @_;
	
	local $subject = &main'_deltag( $main'param{'title'} );
	local $message;
	$message .= $hash_plan->{'header'} . "\n" if ($main'param{'header'} ne '');
	$message .= &main'_deltag( $main'param{'body'} ) . "\n";
	$message .= $hash_plan->{'cancel'} . "\n" if ($main'param{'cancel'} ne '');
	$message .= "\n" . $hash_plan->{'footer'} if ($main'param{'footer'} ne '');
	
	$message =~ s/<br>/\n/ig;
	
	my $name = $hash_plan->{'name'};
	my $from = $hash_plan->{'from'};
	
	# ------------------   メッセージフォーマット   ---------------
	my $return  = $from;
	$from       = qq| <$from>|;
	if( $name ne '' ){
		$name =~ s/&lt;/</gi;
		$name =~ s/&gt;/>/gi;
		$name =~ s/&quot;/"/gi;
		$name = &main'mail64encode( $name );
	}

	# ユーザのリモートIPアドレス
	$remote_host_name   = $ENV{'REMOTE_HOST'};
	$remote_addr = $ENV{'REMOTE_ADDR'};
	$host_addr   = $ENV{'HTTP_X_FORWARDED_FOR'};

	local $data = <<"END";
Return-Path: <$return>
From: $name$from
Reply-to: $return
To: <%mail%>
<%subject%>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Mailer: $remote_host_name($remote_addr:$host_addr)

$message
END
#-------------------------------------------------------------
	&jcode'sjis2jis( \$data, 'z' );
	
	my $dir = &compatibility();
	my $tmp = $dir. 'M-'. $$. time. '.cgi';
	open( BODY, ">$tmp" );
	print BODY $data;
	close(BODY);
	chmod 0606, $tmp;
	rename $tmp, $path;
}

sub make_list
{
	my( $path, $action ) = @_;
	
	# 条件指定
	if( $action eq 'cdn' ){
		my( $cdn_sid, $cdn_filepath ) = &cdn_session();
		rename $cdn_filepath, $path;
		return;
	}
	
	my $all = $main'param{'all'} - 0;
	my $id = $main'param{'id'} - 0;
	my @csvs = &main'get_csvdata( $id );
	
	my $sendid = 1;
	
	my %Email;
	my $dir = &compatibility();
	my $tmp = $dir. 'L-'. $$. time. '.cgi';
	open( LIST, ">$tmp" );
	foreach( @csvs ){
		chomp;
		my @csv = split(/\t/);
		my $check = $main'param{"sm$csv[0]"};
		
		# リストに登録済み
		next if( $Email{$csv[5]} );
		$Email{$csv[5]} = 1;
		
		if( $all == 1 ){
			next if( $check <= 0);
		}elsif( $all == 2 ){
			next if( $check > 0 );
		}
		unshift @csv, $id;
		unshift @csv, $sendid;
		
		my $line = join( "\t", @csv );
		print LIST "$line\n";
		$sendid++;
	}
	close(LIST);
	chmod 0606, $tmp;
	rename $tmp, $path;
}

sub make_control
{
	my( $path, $flag ) = @_;
	open( CTL, $path );
	my @control = <CTL>;
	close(CTL);
	
	if( $flag eq 'default' ){
		$control[0] = "start\n";
		$control[1] = "0\n";
	}else{
		$control[0] = "running\n";
		$control[1] = "$flag\n";
	}
	
	my $dir = &compatibility();
	my $tmp = $dir. 'C-'. $$. time. '.cgi';
	open(CTL, ">$tmp");
	print CTL @control;
	close(CTL);
	chmod 0606, $tmp;
	rename $tmp, $path;
}

sub make_flag
{
	my( $path, $act ) = @_;
	if( $act ){
		unlink $path;
	}else{
		open( FLAG, ">$path" );
		close(FLAG);
	}
}

sub send_manual
{
	my $hash_rule = &get_send_rule();
	my $hash_method = &get_method();
	
	my $each = $hash_method->{'each'} - 0;
	my $subject = $hash_rule->{'subject'};
	my $admin = $hash_rule->{'admin'};
	my $uniq = $hash_rule->{'uniq'};
	my $id = $hash_rule->{'id'};
	my $flag = &send( $each, $subject, $admin, $id, $uniq );
	
	&disp_manual( $flag, $hash_rule );
}

sub send_background
{
	my $hash_path = &get_path();
	unless( -e $hash_path->{'flag'} ){
		&running();
		exit;
	}
	# 配信フラグを削除
	&make_flag( $hash_path->{'flag'}, 1 );
	
	my $hash_rule = &get_send_rule();
	
	# fork
	FORK: {
		if( $pid = fork ) {
			my $message = "一斉メール配信を開始しました。\n";
			my $body = qq|<html><head><meta HTTP-EQUIV='Content-type' CONTENT='text/html; charset=shift_jis'><meta name="robots" content="none"><title>$title</title></head><body>$message</body></html>|;
			my $length = length $body;
			$| = 1;
			print "Content-type: text/html", "\n";
			print "Content-Length: $length\n\n";
			print "$body";
			close(STDOUT);
			wait;
		
		} elsif (defined $pid) {
			$| = 1;
			close(STDOUT);
			&background_roop( $hash_rule );
			exit;
		
		} elsif ( $! =~ /No more process/) {
    		# プロセスが多すぎる時は、時間を置いて再チャレンジ。
    		sleep 5;
    		redo FORK;
		} else {
    		# fork使用不可サーバー。
			exit;
		}
	}
	
}

sub background_roop
{
	my $hash_rule = shift;
	
	my $subject = $hash_rule->{'subject'};
	my $admin = $hash_rule->{'admin'};
	my $uniq = $hash_rule->{'uniq'};
	my $id = $hash_rule->{'id'};
	
	while(1){
		# アクセス集計
		&Click'pickup( 1 );
		
		my $hash_method = &get_method();
		my $each = $hash_method->{'partition'} - 0;
		my $sleep = $hash_method->{'sleep'} - 0;
		my $flag = &send( $each, $subject, $admin, $id, $uniq );
		last unless( $flag );
		sleep($sleep);
	}
	&cdn_clean();
}

sub background_check
{
	# fork
	FORK: {
		if( $pid = fork ) {
			wait;
		} elsif (defined $pid) {
			exit;
		} else {
    		# fork使用不可サーバー。
			&main'make_plan_page( 'plan', '', "ご利用のサーバーではバックグラウンド配信が利用できない可能\性がございます。<br>サーバー会社様へお問合せください。", '1' );
			exit;
		}
	}
}

sub send
{
	my( $each, $subject, $admin, $id, $uniq ) = @_;
	my $hash_path = &get_path();
	
	#排他処理
	my $fullpath = &main'lock();
	
	# SSL設定取得
	my $file = "$main'myroot$main'data_dir$main'log_dir$main'plan_txt";
	unless ( open(PLAN, "$file" ) ) {
    	push @errors, '配信プランファイルが開けません';
	}
	while( <PLAN> ) {
		chomp;
		my @plan = split(/\t/);
		if( $plan[0] == $id ){
			&Pub'ssl($plan[83]);
		}
	}
	close(PLAN);
	
	#---------------------------#
	# 送信済み短縮URLを取得     #
	#---------------------------#
	my $forward = &Click'getForward_url();
	my $forward_subject = $subject;
	
	#---------------------------#
	# 転送用タグ取得            #
	#---------------------------#
	$main'param{'id'} = $id;
	my( $urlTag, $other ) = &Click'getTag( $id, 1 );
	
	# 転送アドレス
	my $uniq_code = $id. '-S-'. $uniq;
	
	# 配信済み送信IDを取得
	open( CTL, $hash_path->{'control'} );
	my @ctl = <CTL>;
	close(CTL);
	
	my $sended = $ctl[1] - 0;
	my $number = 0;
	
	if( $sended <= 0 && index( $ctl[0], 'start' ) < 0 ){
		# 制御エラー
		&main'rename_unlock( $fullpath );
		&main'make_plan_page( 'plan', '', "エラーが発生しました。<br><br>パーミッション設定をご確認ください。", '1' );
		exit;
	}
	if( $sended > 0 && index( $ctl[0], 'running' ) < 0 ){
		# 制御エラー
		&main'rename_unlock( $fullpath );
		&main'make_plan_page( 'plan', '', "エラーが発生しました。<br><br>パーミッション設定をご確認ください。", '1' );
		exit;
	}
	
	# 本文を取得
	#my @mailbody;
	open( BODY, $hash_path->{'mail'} );
	my $mailbody;
	while(<BODY>){
		$mailbody .= $_;
	}
	close(BODY);
	
	# 送信制限を取得
	my $op_f;
	my $hash_method = &get_method();
	if( $hash_method->{'chk_f'} ){
		$op_f = qq| -f $hash_method->{'f_mail'}|;
	}
	# 待ち時間
	my $r_sleep;
	if( $hash_method->{'chk_sleep'} ){
		$r_sleep = $hash_method->{'r_sleep'};
	}
	my $n = 0;
	open(LIST, $hash_path->{'list'} );
	while(<LIST>){
		my $target_id = $_ -0;
		next if( $sended >= $target_id );
		
		$n++;
		if( $n > 1000 ){
			$n = 0;
			select(undef, undef, undef, 0.20);
		}
		
		chomp($_);
		my @csv = split(/\t/);
		my $target = shift @csv;
		my $id = shift @csv;
		
		# 転送タグ変換
		my( $sendbody, $forward_urls) = &Click'analyTag($csv[0], $mailbody, $urlTag, $uniq_code, $forward);
		
		$main'param{'id'} = $id;
		&sender( $subject, $sendbody, [@csv], $op_f, $r_sleep );
		&log( $id, [@csv], $subject );
		
		# アクセス集計用データ生成
		&Click'setForward_t( $forward_urls, $uniq_code, $forward_subject );
		
		$number++;
		&make_control( $hash_path->{'control'}, $target_id );
		if( $number >= $each ){
			last;
		}
	}
	my $line = <LIST>;
	close(LIST);
	
	# 排他処理解除
	&main'rename_unlock( $fullpath );
	
	if( $line eq '' ){
		# 配信終了
		$main'temdata_base[5] = $admin;
		my( $sendbody, $forward_urls) = &Click'analyTag('', $mailbody, $urlTag, $uniq_code, $forward);
		&sender( $subject, $sendbody, [@main'temdata_base], $op_f, $r_sleep, 1 );
		&finish();
		return 0;
	}
	
	return 1;
}

sub sender
{
	my( $_subject, $mailbody, $csv, $op_f, $r_sleep, $preview ) = @_;
	
	# Subject を調整
	local $subject = $_subject;
	$subject = &main'include( $csv, $subject, '', $preview );
	&jcode'sjis2jis( \$subject, 'z' );
	$subject = &main'mail64encode( $subject );
	
	my $body;
	#foreach( @$mailbody ){
		#chomp;
		#local $line = $_;
		$mailbody =~ s/<%subject%>/Subject: $subject/i;
		$mailbody = &main'include( $csv, $mailbody, 1, $preview );
		#$body .= "\n";
	#}
	
	# 送信
	my $senderror=0;
	unless ( open (MAIL, "| $main'sendmail$op_f -t") ) {
		$senderror = 1;
	}
	print MAIL $mailbody;
	close(MAIL);
	
	sleep($r_sleep) if( $r_sleep );
}


sub log
{
	local( $id, $csv, $subject ) = @_;
	my $logfile = $main'myroot . $main'data_dir . $main'log_dir . 'L' . $id . '.cgi';
	my $now = time;
	
	my $userid = $csv->[0];
	my $email = $csv->[5];
	my $name  = $csv->[3];
	
	$subject = &main'include( $csv, $subject );
	
	open(LOG, ">>$logfile");
	print LOG "$userid\t$email\t$name\t$now\tS\t$subject\n";
	close(LOG);
}

sub compatibility
{
	my $dir = $main'myroot . $main'data_dir;
	my $path_dir = $dir . 'simul/';
	
	unless( -d $path_dir ){
		my $flag = mkdir $path_dir, 0707;
		if( !$flag ){
			&main'error("<strong>ディレクトリが作成できません。","</strong><br><br><br>$dir<br><br>のパーミッションがただしく設定されているかご確認ください。");
		}
		chmod 0707, $dir;
	}
	if( !( -x $dir) || !( -w $dir) ){
		&main'error("パーミッションエラー","<br><br><br>$dir<br><br>のパーミッションが[707]に正しく設定されているかご確認ください。");
	}
	
	return $path_dir;
}

sub get_path
{
	my $dir = &compatibility();
	my $rule = $dir . 'rule.cgi';
	my $list = $dir . 'list.cgi';
	my $mail = $dir . 'mail.cgi';
	my $uniq = $dir . 'uniq.cgi'; # 最後の送信IDを保存
	
	# 送信時制御ファイル
	my $control = $dir . 'control.cgi';
	my $flag = $dir . 'flag';
	
	my %PATH;
	$PATH{'rule'} = $rule;
	$PATH{'list'} = $list;
	$PATH{'mail'} = $mail;
	$PATH{'control'} = $control;
	$PATH{'flag'} = $flag;
	$PATH{'uniq'} = $uniq;
	return \%PATH;
}

sub get_plan
{
	my $id = $main'param{'id'} - 0;
	#--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = $main'myroot . $main'data_dir . $main'log_dir . $main'plan_txt;
	
	unless ( open(PLAN, "$file" ) ) {
		&main'make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	local ( $index, $plan_name, $name, $from, $admin, $header, $cancel, $footer );
	while( <PLAN> ) {
		chomp;
		my ( $index, $_plan_name, $_name, $_from, $_admin, $_header, $_cancel, $_footer ) = ( split(/\t/) )[0, 2, 3, 4, 5, 9, 10, 11];
		if ( $index eq $id ) {
			$plan_name = $_plan_name;
			$name = $_name;
			$from = $_from;
			$admin = $_admin;
			$admin = ( split(/,/,$_admin) )[0];
			$header = $_header;
			$cancel = $_cancel;
			$footer = $_footer;
            last;
        }
    }
    if ( $admin eq '' ) {
        &main'make_plan_page( 'plan', '', "管理者のメールアドレスを取得できません。<br><br>管理者メールアドレスを入力してください");
    }
    close(PLAN);
	
	my %PLAN;
	$PLAN{'plan_name'} = $plan_name;
	$PLAN{'name'} = $name;
	$PLAN{'from'} = $from;
	$PLAN{'admin'} = $admin;
	$PLAN{'header'} = $header;
	$PLAN{'cancel'} = $cancel;
	$PLAN{'footer'} = $footer;
	return \%PLAN;
}

sub get_send_rule
{
	my %SEND_CONF;
	my $hash_path = &get_path();
	open( MET, $hash_path->{'rule'} );
	chomp( my @rule = <MET> );
	close(MET);
	
	$SEND_CONF{'method'} = $rule[0];
	$SEND_CONF{'id'} = $rule[1];
	$SEND_CONF{'plan_name'} = $rule[2];
	$SEND_CONF{'start'} = $rule[3];
	$SEND_CONF{'subject'} = $rule[4];
	$SEND_CONF{'admin'} = $rule[5];
	$SEND_CONF{'uniq'} = $rule[6];
	
	return \%SEND_CONF;
}

sub disp_manual
{
	my( $sended, $hash_rule ) = @_;
	my $hash_path = &get_path();
	my $hash_method = &get_method();
	my $id = $main'param{'id'} - 0;
	
	if( $sended >= 1 ){
		my $screen;
		if( $id eq $hash_rule->{'id'} ){
			if( $sended == 1 ){
			
				$screen = <<"END";
<form action="$main'indexcgi" method="POST">
送信が $hash_method->{'each'}件を超えたため送信が中断し完了できませんでした。<br>
残り件数を送信してください。
<input type="submit" value="送信する" onClick="return confir('送信しますか？');">
<input type="hidden" name="md" value="mailsend">
<input type="hidden" name="next" value="1">
<input type="hidden" name="id" value="$id">
</form>
END

			}elsif($sended == 2 ){
				
				$screen = <<"END";
<form action="$main'indexcgi" method="POST">
前回このプランでの一斉メール時において、正常に完了しなかった為、<br>配信が中断されています。<br>
下のボタンにより、配信を再開してください<br>
<input type="submit" value="送信する" onClick="return confir('送信しますか？');">
<input type="hidden" name="md" value="mailsend">
<input type="hidden" name="next" value="1">
<input type="hidden" name="id" value="$id">
</form>
END
				
			}
		}else{
			$screen = <<"END";
<font color="#FF0000">既に一斉メールが配信中です</font><br><br>
<table>
<tr><td colspan="2"><strong>▼ 配信情報</strong></td></tr>
<tr><td width="50">プラン：</td><td width="350" align="left">$hash_rule->{'plan_name'}</td></tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr><td colspan="2">実行済みの配信を完了させてください。<br>
こちら残りの配信を実行するには　<a href="$main'indexcgi\?md=mail&id=$hash_rule->{'id'}"><font color="#0000FF">こちら</font></a></td></tr>
</table>
END
		}
		&main'make_plan_page( 'plan', '', "$screen", '1' );
		exit;
	
	}else{
		# 条件テンポラリーファイルを削除
		&cdn_clean();
		# 送信完了
		&main'make_plan_page( 'plan', '', "送信が完了しました", '1' );
		exit;
	}
}

sub disp_background
{
	my( $sended, $re, $hash_rule ) = @_;
	my $smid = $hash_rule->{'id'};
	$main'param{'id'} = $smid if( $main'param{'id'} <= 0 );
	
	my $screen;
	if( $sended ){
		if( $re ){
			$re_message = qq|サーバー負荷及び送信が中断していた為、<br>再度|;
		}
		$screen = <<"END";
<font color="#FF0000">$re_messageバックグラウンドで配信を開始しました。</font><br><br>
この処理直後は「管理画面」のリンクをクリックした際の動作が<br>
重くなる場合があります。<br> 
その際は、もう一度該当のリンクをクリックしてください。<br><br>
尚、メールの送信はバックグラウンドで行われますので<br>ログアウト及び電源をお切りになっても
問題ございません。
<img src="$main'indexcgi\?md=simul" border="0" width="1" height="1">
END
		&main'make_plan_page( 'plan', '', "$screen", '1' );
		exit;
	}
	$screen = <<"END";
<font color="#FF0000">バックグラウンドで配信中です。</font><br><br>
一斉メールの配信は、前回の配信が終了した後実行可能\となりますので、<br>しばらくお待ちください。
END
	&main'make_plan_page( 'plan', '', "$screen", '1' );
}

sub finish
{
	my $hash_path = &get_path();
	foreach( keys %$hash_path ){
		next if( $_ eq 'uniq' );
		my $filepath = $hash_path->{$_};
		unlink $filepath;
	}
}

sub debug
{
	print "Content-type: text/html\n\n";
	print "<html><head><title>CGI</title></head>\n";
	print "<body>\n";
	print "<br>$_[0]<br>";
	print "</body></html>\n";
	exit;
}

sub _debug
{
	my $str = shift;
	open( DG, '>>../data/simul/mailbody.txt' );
	print DG $str;
	close(DG);
	
	#&debug('OK!');
}

sub slch
{
	my $imgfile = $main'myroot . $main'image_dir . $main'imagefile;
	if( &running( 1 ) ){
		&send_background();
	}else{
		open( IMG, $imgfile );
		print "Content-type: image/gig", "\n\n";
		binmode IMG;
		while(<IMG>){
			print $_;
		}
		close(IMG);
		exit;
	}
}

sub print_errlog
{
	my $_date = shift;
	my $logfile = $main'myroot . $main'data_dir . 'errorlog.cgi';
	my $tmp = $main'myroot . $main'data_dir. 'ERR-TMP-'. $$. time. '.cgi';
	
	open( ERRTMP, ">$tmp" );
	open( ERR, "<$logfile" );
	while( <ERR> ){
		print ERRTMP $_;
	}
	
	my($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($_date+(60*60*9));
	my $date = sprintf ( "%04d/%02d/%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec );
	
	print ERR qq|$date | . '頃に一斉メール配信が強制終了された可能性があります。' . qq|\n|;
	close(ERR);
	close(ERRTMP);
	eval{ chmod 0606, $tmp; };
	rename $tmp, $logfile;
}

sub cdn_form
{
	my( @line ) = @_;
	
	my $id = $main'param{'id'} -0;
	my $method = $main'param{'method'} -0;
	my( $cdn_sid, $cdn_filename ) = &cdn_session();
	
	# フォーム設定情報
	my @names = @Ctm'names;
	# 項目番号 フォーム設定
	my %rFORM = &Ctm'regulation_dataline();
	# 詳細設定
	my %detail = &MF'_get_detail_list( $id, 1 );
	
	# 表示順On
	my @SortOn;
	# 表示順Off
	my @SortOff;
	
	my $cdn_table;
	my $fn = 0;
	for ( my $i=1; $i<@names; $i++ ) {
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		my $prop = 'text';
		if( $i > 18 ){
			$fn++;
		}
		my $bgcolor = '#FFFFFF';
		my $form;
		if ( ( split(/<>/, $line[$r_num]) )[0] ) {
			my $inname = ( split(/<>/, $line[$r_num]) )[2];
			$inname = &main'deltag( $inname );
			my $fname = ( $inmame eq '' )? $r_val: $inname;
			my $input;
			my $select;
			my $checkbox;
			my $raido;
			if( $fn > 0 ){
				# フリー項目
				$prop = $detail{$fn}->[0];
				$select = $detail{$fn}->[1];
				$checkbox = $detail{$fn}->[2];
				$raido = $detail{$fn}->[3];
				$bgcolor = '#F4FAFF';
			}
			if( $r_name eq 'address' ){
				$input = &_cdn_ken( $r_name );
			}elsif( $r_name eq '_mail' ){
				next;
			}else{
				$input = &_cdn_detail( $prop, $r_name, $select, $checkbox, $raido );
			}
			$form = <<"END";
<tr bgcolor="$bgcolor"><td>$fname</td><td>$input</td></tr>\n
END
			my $sort = ( split(/<>/, $line[$r_num]) )[3];
			if( $sort > 0 ){
				$SortOn[$sort] = $form;
			}else{
				push @SortOff, $form;
			}
		}
	}
	
	foreach( @SortOn ){
		$cdn_table .= $_;
	}
	foreach( @SortOff ){
		$cdn_table .= $_;
	}
	
	my $_btitle = &main'deltag( $main'param{'title'} );
	my $body = &main'the_text( $main'param{'body'} );
	$body  = &main'make_text( $body );
	my $header = ($main'param{'header'})? 1: 0;
	my $cancel = ($main'param{'cancel'})? 1: 0;
	my $footer = ($main'param{'footer'})? 1: 0;
	
	
	my $main_table = <<"END";
                               <form name="f1" method="post" action="$main'indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="503"><table width="100%" border="0" cellspacing="0" cellpadding="2">
                                          <tr> 
                                            <td>メールを送信する<strong>「登録者情報」</strong>の条件を指定してください。</td>
                                          </tr>
                                          <tr> 
                                            <td>条件として設定できるのは、「登録用フォーム」で選択されている全項目となります。</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          
                                          <tr> 
                                            <td>指定後、<strong>「実行する」</strong>ボタンをクリックしてください</td>
                                          </tr>
                                          <tr> 
                                            <td><table width="100%" border="1" cellspacing="0" cellpadding="1">
                                                <tr> 
                                                  <td width="146" align="center" bgcolor="#CCCCCC">項目</td>
                                                  <td width="261" align="center" bgcolor="#CCCCCC">条件</td>
                                                </tr>
$cdn_table
                                              </table></td>
                                          </tr>
                                             <tr> 
                                             <td>&nbsp;</td> 
                                           </tr> 
                                          <tr> 
                                            <td align="center"><input name="md" type="hidden" id="md" value="simul_cdn_conf"> 
                                              <input name="id" type="hidden" id="id" value="$id"> 
                                              <input name="method" type="hidden" id="method" value="$method">
                                              <input name="title" type="hidden" value="$_btitle">
                                              <input name="body" type="hidden" value="$body">
                                              <input name="header" type="hidden"  value="$header">
                                              <input name="cancel" type="hidden"  value="$cancel">
                                              <input name="footer" type="hidden" value="$footer">
                                              <input name="cdn_sid" type="hidden" value="$cdn_sid">
                                              <input type="submit" value="　実行する　" name="SUMIL" onClick="return fncOnClick();"></td>
                                          </tr>
                                        </table>
                                         <br></td>
                                    </tr>
                                  </table>
                                </form>
<SCRIPT LANGUAGE="JavaScript">
<!--
i = 0;
function fncOnClick()
{
	var ret = confir('登録者数 および 指定条件 が多い場合、処理に負荷または時間がかかる場合があります。');
	if( ret == false ){
        return false;
	}
	
	if(i==0){
		document.f1.handleEvent = "submit";
		document.f1.submit();
		document.f1.SUMIL.disabled=true;
		i++;
	}
	else {
	}
}
//-->
</SCRIPT>
END
	return $main_table;
}

sub cdn_conf
{
	my( @line ) = @_;
	
	# ユニークID
	my $uniq =  crypt( $$, &main'make_salt() );
	
	
	my $id = $main'param{'id'} -0;
	my $method = $main'param{'method'} -0;
	my( $cdn_sid, $cdn_filename ) = &cdn_session();
	my( $search, $cdn_table, $hidden ) = &cdn_prop( $id, [@line] );
	
	# 検索
	my $total = &cdn_search( $line[6], $search );
	
	my $submit = qq|<input type="submit" value="送信を開始する" onClick="return confir('送信しますか？');">| if($total > 0);
	
	my $ptitle = &main'make_text( $main'param{'title'} );
	$ptitle = &main'reInclude( $ptitle );
	$ptitle = &main'include( \@main'temdata, $ptitle, '', 1 );
	
	
	my $_btitle = &main'deltag( $main'param{'title'} );
	my $body = &main'the_text( $main'param{'body'} );
	$body  = &main'make_text( $body );
	
	# 転送変換
	$pbody = &Click'prev1( $id, $main'param{'body'} );
		
	$pbody = &main'make_text( $pbody );
	$pbody = &main'reInclude( $pbody );
	$pbody = &main'include( \@main'temdata, $pbody, '', 1 );
	$pbody =~ s/\n/<br \/>/ig;
	
	# 転送変換(プレビュー用)
	$pbody = &Click'prev2( $pbody );
	
	
	my $header  = $main'param{'header'} -0;
	my $cancel  = $main'param{'cancel'} -0;
	my $footer  = $main'param{'footer'} -0;
	
	my $pheader  = $line[9] if ($header);
	my $pcancel  = $line[10] if ($cancel);
	my $pfooter  = $line[11] if ($footer);
	
	$pheader = &main'make_text( $pheader );
	$pheader = &main'reInclude( $pheader );
	$pheader = &main'include( \@main'temdata, $pheader, '', 1 );
	
	$pcancel = &main'make_text( $pcancel );
	$pcancel = &main'reInclude( $pcancel );
	$pcancel = &main'include( \@main'temdata, $pcancel, '', 1 );
	
	$pfooter = &main'make_text( $pfooter );
	$pfooter = &main'reInclude( $pfooter );
	$pfooter = &main'include( \@main'temdata, $pfooter, '', 1 );
	
	my $main_table = <<"END";
                               <form name="f1" method="post" action="$main'indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="503"><table width="100%" border="0" cellspacing="0" cellpadding="2">
                                          <tr> 
                                            <td>本文および条件をご確認ください。</td>
                                          </tr>
                                          <tr> 
                                            <td>本文を修正する場合は<strong>「本文を修正する」</strong>を、</td>
                                          </tr>
                                          <tr> 
                                            <td>メールを送信する場合<strong>「送信を開始する」</strong>ボタンを、</td>
                                          </tr>
                                          <tr> 
                                            <td>条件を変更する場合は<strong>「条件を設定し直す」</strong>ボタンを、</td>
                                          </tr>
                                          <tr> 
                                            <td>クリックしてください。</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>$ptitle</td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$pheader</td>
                                          </tr>
                                          <tr> 
                                            <td>$pbody</td>
                                          </tr>
                                          <tr> 
                                            <td>$pcancel</td>
                                          </tr>
                                          <tr> 
                                            <td>$pfooter</td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td><table width="100%" border="1" cellspacing="0" cellpadding="1">
                                                <tr> 
                                                  <td width="146" align="center" bgcolor="#CCCCCC">項目</td>
                                                  <td width="261" align="center" bgcolor="#CCCCCC">条件</td>
                                                </tr>
$cdn_table
                                              </table></td>
                                          </tr>
                                             <tr> 
                                             <td>&nbsp;</td> 
                                           </tr>
                                             <tr>
                                               <td>条件に一致した登録者数：　<strong><font size="4">$total</font></strong> 件 </td>
                                             </tr>
                                             <tr>
                                               <td>&nbsp;</td>
                                             </tr> 
                                          <tr> 
                                            <td align="center"><input name="md" type="hidden" id="md" value="simul_cdn_set"> 
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="method" type="hidden" id="method" value="$method">
                                              <input name="title" type="hidden" id="title" value="$_btitle">
                                              <input name="body" type="hidden" id="body" value="$body">
                                              <input name="header" type="hidden" id="header" value="$header">
                                              <input name="cancel" type="hidden" id="cancel" value="$cancel">
                                              <input name="footer" type="hidden" id="footer" value="$footer">
                                              <input name="cdn_sid" type="hidden" value="$cdn_sid">
                                              <input name="uniq" type="hidden" value="$uniq">
                                              <input name="make_body" type="submit" id="make_body" value="本文を修正する"> 
$submit
                                              <input name="back" type="submit" id="back" value="条件を設定し直す"> 
$hidden
                                              </td>
                                          </tr>
                                        </table>
                                         <br></td>
                                    </tr>
                                  </table>
                                </form>
END
	return $main_table;
}

sub cdn_prop
{
	my( $id, $rline ) = @_;
	my @line = @$rline;
	
	# フォーム設定情報
	my @names = @Ctm'names;
	# 項目番号 フォーム設定
	my %rFORM = &Ctm'regulation_dataline();
	# 詳細設定
	my %detail = &MF'_get_detail_list( $id, 1 );
	
	# 登録者情報データ番号を取得
	my %csv = &Ctm'regulation_csvline();
	
	# 表示順On
	my @SortOn;
	# 表示順Off
	my @SortOff;
	
	my $cdn_table;
	my $hidden;
	my $fn = 0;
	my %search;
	for ( my $i=1; $i<@names; $i++ ) {
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		my $prop = 'text';
		# メールアドレス確認
		if( $r_name eq '_mail' ){
			next;
		}
		# フリー項目
		if( $i > 18 ){
			$fn++;
		}
		my $bgcolor = '#FFFFFF';
		my $form;
		if ( ( split(/<>/, $line[$r_num]) )[0] ) {
			my $inname = ( split(/<>/, $line[$r_num]) )[2];
			$inname = &main'deltag( $inname );
			my $fname = ( $inmame eq '' )? $r_val: $inname;
			my $input;
			my $value = &main'deltag( $main'param{$r_name} );
			my $pvalue = ($value ne '')? $value: '---';
			if( $fn > 0 ){
				# フリー項目
				$bgcolor = '#F4FAFF';
			}
			$form .= <<"END";
<tr bgcolor="$bgcolor"><td>$fname</td><td>$pvalue&nbsp;</td></tr>\n
END
			$hidden .= qq|<input type="hidden" name="$r_name" value="$value">\n|;
			
			# 検索データ正規化
			if( $value ne '' ){
				my $index = $csv{$r_name};
				$search{$index} = $value ;
			}
			my $sort = ( split(/<>/, $line[$r_num]) )[3];
			if( $sort > 0 ){
				$SortOn[$sort] = $form;
			}else{
				push @SortOff, $form;
			}
		}
	}
	
	foreach( @SortOn ){
		$cdn_table .= $_;
	}
	foreach( @SortOff ){
		$cdn_table .= $_;
	}
	
	return {%search}, $cdn_table, $hidden;
}

sub cdn_set
{
	my( $cdn_sid, $cdn_filepath ) = &cdn_session();
	if( defined $main'param{'make_body'} ){
		&main'make_plan_page( 'plan', 'mail' );
		exit;
	}
	if( defined $main'param{'back'} ){
		if( -f $cdn_filepath ){
			unlink $cdn_filepath;
		}
		&main'make_plan_page( 'plan', 'simul_cdn' );
		exit;
	}
	unless( -f $cdn_filepath ){
		&main'make_plan_page( 'plan', 'simul_cdn' );
	}
	&make_config( 'cdn' );
}

sub cdn_session
{
	my $sid;
	$sid = ( $main'param{'cdn_sid'} )? $main'param{'cdn_sid'}-0: time . $$;
	my $dir = &compatibility();
	my $filename = $dir. 'CDN-'. $sid . '.cgi';
	return $sid, $filename;
}

sub cdn_clean
{
	my $limit = shift;
	my $now = time;
	my $dir = &compatibility();
	opendir DIR, $dir;
	my @file = readdir DIR;
	close(DIR);
	foreach( @file ){
		if( /^CDN-(\d+)/ ){
			my $path = $dir. $_;
			if( $limit ){
				my $date = ( stat($path) )[9];
				if( $date + (60*60*10) < $now  ){
					unlink $path;
				}
			}else{
				unlink $path;
			}
		}
	}
}

sub _cdn_detail
{
	my( $prop, $name, $select, $checkbox, $radio ) = @_;
	my $input;
	my $value = &main'deltag( $main'param{$name} );
	
	if( $prop eq 'textarea' ){
		$input = &_cdn_text( $name, $value );
	}elsif( $prop eq 'select' ){
		$input = &_cdn_select( $name, $value, $select );
	}elsif( $prop eq 'checkbox' ){
		$input = &_cdn_checkbox( $name, $value, $checkbox );
	}elsif( $prop eq 'radio' ){
		$input = &_cdn_radio( $name, $value, $radio );
	}else{
		$input = &_cdn_text( $name, $value );
	}
	return $input;
}
sub _cdn_text
{
	my( $name, $value ) = @_;
	return qq|<input type="text" name="$name" value="$value" size="40">を含む|;
}
sub _cdn_textarea
{
	
}
sub _cdn_select
{
	my( $name, $value, $element ) = @_;
	my $select = qq|<select name="$name"><option value="">選択してください</option>|;
	foreach( @$element ){
		my $selected = ' selected' if( $value eq $_ );
		$select .= qq|<option value="$_"$selected>$_</option>|;
	}
	$select .= qq|</select>|;
	return $select;
}
sub _cdn_checkbox
{
	my( $name, $value, $element ) = @_;
	my $checked = ' checked="checked"' if( $value eq $element->[0] );
	return  qq|<input type="checkbox" name="$name" value="$element->[0]"$checked>$element->[0]|;
}
sub _cdn_radio
{
	my( $name, $value, $element ) = @_;
	my $radio = qq|<input type="radio" name="$name" value="">指定しない<br>|;
	foreach( @$element ){
		my $checked = ' checked="checked"' if( $value eq $_ );
		$radio .= qq|<input type="radio" name="$name" value="$_"$checked>$_<br>|;
	}
	return $radio;
}
sub _cdn_ken
{
	my $name = shift;
	%Ken = (
	'1' => '北海道',
	'2' => '青森県',
	'3' => '岩手県',
	'4' => '宮城県',
	'5' => '秋田県',
	'6' => '山形県',
	'7' => '福島県',
	'8' => '茨城県',
	'9' => '栃木県',
	'10' => '群馬県',
	'11' => '埼玉県',
	'12' => '千葉県',
	'13' => '東京都',
	'14' => '神奈川県',
	'15' => '新潟県',
	'16' => '富山県',
	'17' => '石川県',
	'18' => '福井県',
	'19' => '山梨県',
	'20' => '長野県',
	'21' => '岐阜県',
	'22' => '静岡県',
	'23' => '愛知県',
	'24' => '三重県',
	'25' => '滋賀県',
	'26' => '京都府',
	'27' => '大阪府',
	'28' => '兵庫県',
	'29' => '奈良県',
	'30' => '和歌山県',
	'31' => '鳥取県',
	'32' => '島根県',
	'33' => '岡山県',
	'34' => '広島県',
	'35' => '山口県',
	'36' => '徳島県',
	'37' => '香川県',
	'38' => '愛媛県',
	'39' => '高知県',
	'40' => '福岡県',
	'41' => '佐賀県',
	'42' => '長崎県',
	'43' => '熊本県',
	'44' => '大分県',
	'45' => '宮崎県',
	'46' => '鹿児島県',
	'47' => '沖縄県'
	);
	my $value = &main'deltag($main'param{$name});
	my $input .= qq|<select name="$name"><option value="">選択してください</option>|;
	foreach( sort keys %Ken ){
		my $ken_name = $Ken{$_};
		my $selected = ' selected' if( $value eq $ken_name );
		$input .= qq|<option value="$ken_name"$selected>$ken_name</option>|;
	}
	$input .= qq|</select>|;
	return $input;
}

sub cdn_search
{
	my( $csvfile, $search ) = @_;
	
	my $id = $main'param{'id'} -0;
	my( $cdn_sid, $cdn_filepath ) = &cdn_session();
	my $sendid = 0;
	
	if( $main'param{'rebody'} && -f $cdn_filepath ){
		open( CDN, $cdn_filepath );
		while(<CDN>){
			$sendid++;
		}
		close(CDN);
		return $sendid;
	}
	
	my $csvfilepath = $main'myroot . $main'data_dir . $main'csv_dir . $csvfile;
	open( CDN, ">$cdn_filepath" );
	open( CSV, "<$csvfilepath" );
	my %mail;
	my $count = 0;
	while(<CSV>){
		chomp;
		my @csvs = split(/\t/);
		next if( $mail{$csvs[5]} );
		my $flag = 1;
		foreach $ind ( keys %$search ){
			if( $count >= 1000 ){
				$count = 0;
				select(undef, undef, undef, 0.20);
			}
			$count++;
			my $val = $search->{$ind};
			if( index( $csvs[$ind], $val ) < 0 ){
				$flag = 0;
				last;
			}
		}
		next if( !$flag );
		$sendid++;
		$mail{$csvs[5]} = 1;
		print CDN qq|$sendid\t$id\t$_\n|;
	}
	close(CDN);
	close(CSV);
	chmod 0606, $cdn_filepath;
	
	if( $sendid <= 0 ){
		unlink $cdn_filepath;
	}
	return $sendid;
}
1;
