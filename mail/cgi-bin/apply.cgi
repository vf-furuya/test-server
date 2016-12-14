#!/usr/bin/perl

#---------------------------------------
# 楽メールpro
#
# ユーザ登録専用CGIファイル apply.cgi
# v 2.4
#---------------------------------------
require '../lib/Pub.pl';
require '../lib/System.pl';
require "${'myroot'}lib/cgi_lib.pl";
require "${'myroot'}lib/jcode.pl";
require "${'myroot'}lib/composition.pl";

local @codes;
local $code;
&my_method_ck();

if( $param{'U'} ne '' ){
	&Click'pickup( 1 );
	&Click'forwarding();
	exit;
}

&Pub'Server();

# 文字コード変換用
$CODE;
$VCODE;
$utf;
$jcodeconvert;
$jcodegetcode;

if ( $mode eq 'guest' ) { &reguest(); }
elsif ( $mode eq 'renew' ) { &renewguest(); }
elsif ( $mode eq 'cancel' ) { &renewguest(); }
&print_error('エラーが発生しました', '直接のアクセス<br>もしくは<br>フォームが正常に貼り付けられていない為、エラーが発生しました。<br><br>貼り付けたフォームからアクセスしてこの画面が表示される場合は、再度貼り付けたフォームに間違いがないか確認してください。', 0, 'err');

#------------------------------------------------------#
# ユーザー登録                                         #
#------------------------------------------------------#
sub reguest {
	
	local $id = $param{'id'} - 0;
	
	# 送信済み短縮URLを取得
	my $forward = &Click'getForward_url();
	
	my $date = time;
	my $lockfull = &lock();
	#--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">システムエラー</font>', "ファイルが開けません<br>$fileのパーミッションが[606]に設定されているか<br>ご確認してください", 0, 'err');
		exit;
	}
	local @line;
	my $csvpath;
	my $queuepath;
	my $logpath;
	my $ra_conf;
	my $tag_data;
	while( <PLAN> ) {
		chomp;
		@line = split(/\t/);
		if ( $line[0] eq $id ) {
			$csvpath = "$myroot$data_dir$csv_dir$line[6]";
			$queuepath = "$myroot$data_dir$queue_dir$line[7]";
			$logpath = "$myroot$data_dir$log_dir$line[8]";
			$utf = $line[60]-0;
			$ra_conf = $line[77] -0; # 管理者通知専用本文利用フラグ
			$tag_data = $line[82];
			&Pub'ssl($line[83]);
			last;
		}
	}
	close(PLAN);
	
	my $mobile = &Jcode( $utf );
	
	if ( !$line[37] ) {
		&rename_unlock( $lockfull );
		&print_error('登録できません', '大変申し訳ありません<br>現在、申し込みを停止しています。', 0, 'err' );
	}
	
	#---------------------------#
	# 転送用タグ取得            #
	#---------------------------#
	my( $urlTag, $other ) = &Click'roadTag( $tag_data );
	
	my( $step, $dates ) = split(/<>/, $line[36] );
	my $n = 2;
	my %stepConf;
	foreach( split(/,/, $step ) ){
		my( $inter, $config, $code ) = split(/\//);
		$stepConf{$n} = $config -0;
		$uniq = $code if( $n == $target );
		$n++;
	}
	
	#--------------------------------#
	# 既存の登録者データからIDを取得 #
	#--------------------------------#
	my $index;
	unless ( $csvpath ) {
		&rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">システムエラー</font>', "該当するデータがありません。", 0, 'err' );
		exit;
	}
	unless ( open(CSV, "$csvpath" ) ) {
		if ( -e $csvpath ) {
			&rename_unlock( $lockfull );
			&print_error('<font color="#CC0000">システムエラー</font>', "ファイルが開けません<br>$csvpathのパーミッションを確認してください。", 0, 'err' );
			exit;
		}
		unless ( open(CSV, ">>$csvpath") ) {
			&rename_unlock( $lockfull );
			&print_error('<font color="#CC0000">システムエラー</font>', "ユーザー登録ができません<br>$csvpathのパーミッションが[606]に正しく設定されているか確認してください。", 0, 'err' );
			exit;
		}
		$index = 0;
	}else {
		while( <CSV> ) {
			chomp;
			my ( $id, $mail ) = ( split(/\t/) )[0, 5];
			if ( !$line[42] && $param{'mail'} eq $mail ) {
				&rename_unlock( $lockfull );
				&print_error("入力エラー", '同一のメールアドレスが登録されています。', 0, 'err' );
				exit;
			}
			$index = $id if( $index < $id );
		}
	}
	close(CSV);
	$index++;
	
	#--------------------#
	# 入力値の取得と検査 #
	#--------------------#
	my @par;    # 入力値（CSV形式順）
	local $registform; # 入力確認用inputタグ
	
	# 項目番号 フォーム設定
	%rFORM = &Ctm'regulation_dataline();
	
	# 項目番号 登録者情報CSV番号
	%rCSV = &Ctm'regulation_csvline();
	
	# 項目表示順
	my @names = @Ctm'names;
	
	# 表示順On
	my @SortOn;
	# 表示順Off
	my @SortOff;
	
	my @sort;
	for ( my $i=1; $i<@names; $i++ ) {
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		
		my $sort = ( split(/<>/, $line[$r_num]) )[3];
		if( $sort > 0 ){
			$SortOn[$sort] = $names[$i];
		}else{
			push @SortOff, $names[$i];
		}
	}
	push @sort, @SortOn;
	push @sort, @SortOff;
	
	for ( my $i=0; $i<@sort; $i++ ) {
		next if( $sort[$i] eq '' );
		my $r_name = $sort[$i]->{'name'};
		my $r_val  = $sort[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		my $indata = '';
		if ( ( split(/<>/, $line[$r_num]) )[0] ) {
			
			
			# 姓名別（※姓名別フラグ削除 v2.2より登録時のみ設定を参照）
			if( $r_name eq 'name'  && !defined $param{'reged'}){
				my $_name1 = &deltag( $param{'_name1'} );
				my $_name2 = &deltag( $param{'_name2'} );
				$indata = ($_name1 ne '' && $_name2 ne '')? $_name1 . $_name2: '';
			}
			if( $r_name eq '_name'  && !defined $param{'reged'}){
				my $_name1 = &deltag( $param{'_kana1'} );
				my $_name2 = &deltag( $param{'_kana2'} );
				$indata = ($_name1 ne '' && $_name2 ne '')? $_name1 . $_name2: '';
			}
			$indata   = &deltag( $param{$r_name} ) if( $indata eq '' );
			$jcodeconvert->(\$indata, 'sjis', $CODE );
			&jcode'h2z_sjis(\$indata);
			
			local $confdata = &the_text($indata);
			$jcodeconvert->(\$confdata, $VCODE, 'sjis' );
			
			$$r_name = $confdata;
			
			if ( (split(/<>/,$line[$r_num]))[2]  || $r_name eq 'mail' || $r_name eq '_mail' ) {
				if ( $r_name eq 'mail' ) {
					if (&chk_email($indata) ) {
						&rename_unlock( $lockfull );
						&print_error( "入力エラー", 'メールアドレスの形式が正しくありません。', 0, 'err');
						exit;
					}
				}elsif( $r_name eq '_mail' ) {
					
					# メールアドレス確認
					if( $param{'mail'} ne $param{'_mail'} ){
						&rename_unlock( $lockfull );
						&print_error( "入力エラー", 'メールアドレスの入力が一致しません。', 0, 'err');
						exit;
					}
					
				}else {
					if ( $indata eq '' ) {
						my $mes = ( (split(/<>/,$line[$r_num]))[1] )? &deltag( (split(/<>/,$line[$r_num]))[1] ): $r_val;
						&rename_unlock( $lockfull );
						&print_error('入力エラー', "[ $mes ] に入力してください。", 0, 'err');
						exit;
					}
			 	}
				
			}
			
			# 確認画面用データ
			if ( $line[41] ) {
				$registform .= qq|<input type="hidden" name="$r_name" value="$indata">\n|;
				
			}
		}
		$par[$rCSV{$r_name}] = &the_text($indata);
		$indata='';
	}
	
	# 受付拒否
	if ( $line[38] ) {
		foreach ( (split(/,/, $line[38])) ) {
			if ( index($par[5], $_) >= 0 ) {
				&rename_unlock( $lockfull );
				&print_error( '入力エラー','登録できません。<br>ご入力のメールアドレスは登録を受け付けておりません。', 0, 'err');
				exit;
			}
		}
	}
	
	#-------------------------------#
	# 入力確認ページ                #
	#-------------------------------#
	if ( $line[41] && !defined $param{'reged'} ) {
		&rename_unlock( $lockfull );
		if( &cMobile() ){
			$registform .= qq|<input type="hidden" name="m_prop" value="id:$id,md:guest,cd:文字,mbl:1,reged:1">\n|;
		}else{
			$registform .= qq|<input type="hidden" name="reged" value="1">\n|;
			$registform .= qq|<input type="hidden" name="cd" value="文字">\n|;
		}
		if( $VCODE eq 'utf8' ){
			$jcodeconvert->(\$registtable, 'utf8', 'sjis');
			$jcodeconvert->(\$registform, 'utf8', 'sjis');
		}
		local $submit = 'reged';
		
		&print_error('入力確認', '', '', 'conf');
		exit;
	}
	
	$index = sprintf("%05d", $index);
	$userID = $index;
	my $sk = ( split(/,/, $line[35]) )[1];
	my $check = ($sk)? '': 0;
	#unshift @par, $index;
	#splice( @par, 19, 0, $date );  # 登録日（秒）
	#splice( @par, 20, 0, $check ); # 最終配信回数
	#splice( @par, 21, 0, $date );  # 最終配信日（秒）
	$par[19] = &the_text($date);
	$par[20] = &the_text($check);
	$par[21] = &the_text($date);
	$par[0]  = $index;
	
	$par[3] = $par[37] . $par[39] if( $par[37] ne '' || $par[39] ne '' ); # お名前データの連動
	$par[4] = $par[38] . $par[40] if( $par[38] ne '' || $par[40] ne '' ); # お名前データの連動
	
	if( $stepConf{'2'} ){
		$par[52] = 1;
	}
	
	my $line =  join("\t", @par) . "\n";
	# 簡易タグ挿入用に修正
	#splice( @par, 19, 3 );
	my $senderror;
	if ( !$sk || $line[40] ) {
		# 登録メールの送信
		my $rh_body = &get_body( $queuepath );
		$line[9] =~ s/<br>/\n/gi;
		$line[10] =~ s/<br>/\n/gi;
		$line[11] =~ s/<br>/\n/gi;
		
		local ( $subject, $message ) = &make_send_body( 0, $rh_body, $line[9], $line[10], $line[11] );
		# 転送タグ変換
		my $unic = $id. '-0';
		my $forward_urls;
		($message, $forward_urls) = &Click'analyTag($par[0], $message, $urlTag, $unic, $forward);
		
		my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
        $subject = &include( \@par, $subject );
		$message = &include( \@par, $message, $jis );
		if ( !$sk ) {
			$senderror = &send( $line[4], $line[3], $par[5], $subject, $message );
			# 配信ログに追加
			unless ( $senderror ) {
				open(LOG, ">>$logpath");
				print LOG "$par[0]\t$par[5]\t$par[3]\t$date\t0\t$subject\n";
				close(LOG);
			}else{
				&rename_unlock( $lockfull );
				&print_error('<font color="#CC0000">システムエラー</font>','登録できません。<br>メール送信プログラムが停止しているか、指定に誤りがあるため<br>メールが送信できませんでした。<br>管理者にお問合せください。', 0, 'err');
			}
			# アクセス集計用データ生成
			&Click'setForward_t( $forward_urls, $unic );
		}
		# 管理者宛へ送信
		if ( $line[40] ) {
			local %ra;
			$ra{'flag'} = 0;
			if( $ra_conf ){
				local ( $ra_subject, $ra_message ) = &make_send_body( 'ra', $rh_body, $line[9], $line[10], $line[11] );
				my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
        		$subject = &include( \@par, $ra_subject );
				$message = &include( \@par, $ra_message, $jis );
				$ra{'flag'} = 1;
				$ra{'addr'} = $par[5];
			}
			&send( $line[4], $line[3], $line[5], $subject, $message, '', {%ra} );
		}
	}
	
	#-------#
	# 追加  #
	#-------#
	my $tmp = $myroot. $data_dir. $csv_dir. 'TMP-'. $$. time. '.cgi';
	open(CSV, "<$csvpath");
	open(TMP, ">$tmp");
	while(<CSV>){
		print TMP $_;
	}
	print TMP $line;
	close(CSV);
	close(TMP);
	chmod 0606, $tmp;
	rename $tmp, $csvpath;
	&rename_unlock( $lockfull );
	
	#----------------------------------#
	# まぐまぐ登録                     #
	#----------------------------------#
	&Magu::Magumagu( $par[5] );
	
	# リダイレクト
	if ( !$mobile && $line[12] && !$line[39] ) {
		my $href = &Pub'setHttp( $line[12], $line[78], 'all' );
		print "Location: $href", "\n\n";
		exit;
	}
	my $url = qq|<a href="http://$line[12]"><font color="#0000FF">戻る</font></a>| if( $line[12] );
	&print_error('登録が完了しました', '', $url, 'end');
	exit;
	
}
#------------------------------------------------------#
# ユーザーの変更、解除                                 #
#------------------------------------------------------#
sub renewguest {
	local $utf_error;
    local $id = $param{'id'} - 0;
    my $mail = $param{'mail'};
    my $nmail = $param{'nmail'};
    
	my $number;
	my $fnum;
	my $mes;
	my $target;
	my $turl;
	my $http_index;
	my $conf;
	if ($mode eq 'renew') {
		$number = 33;
		$fnum = 2;
		$target = 'r';
		$turl = 13;
		$http_index = 79;
		$conf = 'renew';
		# $mes = 'メールアドレスを変更しました';
	}elsif ($mode eq 'cancel') {
		$number = 34;
		$fnum = 3;
		$target = 'c';
		$turl = 14;
		$http_index = 80;
		$conf = 'delete';
		# $mes = '登録を解除しました';
	}
	my $lockfull = &lock();
	#--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
        &rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">システムエラー</font>', "ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
    my @line;
    my $csvpath;
    my $queuepath;
    my $logpath;
    my $sendck; # 自動送信確認
    my $formck; # IDの入力必須確認
    my $userid;
    while( <PLAN> ) {
        chomp;
        @line = split(/\t/);
        if ( $line[0] eq $id ) {
            $csvpath = "$myroot$data_dir$csv_dir$line[6]";
            $queuepath = "$myroot$data_dir$queue_dir$line[7]";
            $logpath = "$myroot$data_dir$log_dir$line[8]";
            $sendck = (split(/,/,$line[35]))[$fnum];
            $formck = (split(/<>/,$line[$number]))[0];
            $userid = $param{'userid'} if ( $formck );
			&Pub'ssl($line[83]);
            last;
        }
    }
    close(PLAN);
	$utf = $line[60];
	my $mobile = &Jcode( $utf );
	
	if ( &chk_email($mail) || ($mode eq 'renew' && &chk_email($nmail)) ) {
        &rename_unlock( $lockfull );
		&print_error('入力エラー', "メールアドレスの形式が正しくありません。");
        exit;
    }
	
    #--------------------------------#
	# 既存の登録者データからIDを取得 #
	#--------------------------------#
    my $index;
    unless ( $csvpath ) {
        &rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">システムエラー</font>','該当するデータがありません。');
		exit;
	}
    unless ( open(CSV, "$csvpath") ) {
        &rename_unlock( $lockfull );
        &print_error('<font color="#CC0000">システムエラー</font>', "$csvpathが開けません。");
		exit;
	}
    my $tmp = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
    unless ( open(TMP, ">$tmp") ) {
        &rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">システムエラー</font>',"テンポラリーファイルが開けません<br>$csv_dirのパーミッションを確認してください。");
		exit;
	}
	my $flag  = 0;
	my $agree = 0;
	my @csvs;
	my %Email;
	while( <CSV> ) {
		chomp;
		my @csv = split(/\t/);
		$csv[0] = sprintf( "%05d", $csv[0] );
		if ( $mail eq $csv[5] ) {
			$flag = 1;
			if ( !$formck || $csv[0] eq $userid ) {
				$agree = 1;
				if ( $mode eq 'renew' ) {
					$csv[5] = $nmail;
					$_ = join("\t", @csv);
					@csvs = @csv;
				} else {
					@csvs = @csv;
					next;
				}
			}
		}else{
			$Email{$csv[5]} = 1;
		}
		print TMP "$_\n";
	}
	close(TMP);
	close(CSV);
	if ( !$flag ) {
		unlink $tmp;
		&rename_unlock( $lockfull );
		&print_error('入力エラー', "メールアドレスが一致しません。");
	}
	if ( $formck && !$agree ) {
		unlink $tmp;
		&rename_unlock( $lockfull );
		&print_error('入力エラー', "IDが一致しません。");
	}
	if( !$line[42] && $Email{$nmail} ){
		unlink $tmp;
		&rename_unlock( $lockfull );
		&print_error('入力エラー', "すでに同一のメールアドレスが登録されています。");
	}
	# 簡易タグ挿入用に修正
	#splice( @csvs, 19, 3 );
    my $senderror;
    unless ( $sendck ) {
        # 変更、解除メールの送信
        my $rh_body = &get_body( $queuepath );
        $line[9] =~ s/<br>/\n/gi;
        $line[10] =~ s/<br>/\n/gi;
        $line[11] =~ s/<br>/\n/gi;
        local ( $subject, $message ) = &make_send_body( $target, $rh_body, $line[9], $line[10], $line[11] );
		my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
        $subject = &include( \@csvs, $subject );
		$message = &include( \@csvs, $message, $jis );
        $senderror = &send( $line[4], $line[3], $csvs[5], $subject, $message );
        # 配信ログに追加
        my $now = time;
        unless ( $senderror ) {
            open(LOG, ">>$logpath");
            print LOG "$csvs[0]\t$csvs[5]\t$csvs[3]\t$now\t$target\t$subject\n";
            close(LOG);
        }else{
            &rename_unlock( $lockfull );
            &print_error('<font color="#CC0000">システムエラー</font>', '登録できません');
        }
    }
	chmod 0606, $tmp;
    rename $tmp, $csvpath;
    &rename_unlock( $lockfull );
    # リダイレクト
	my $redirect_url = &Pub'setHttp( $line[$turl], $line[$http_index], 'all' );
	
    if ( !$mobile && $line[$turl] && !$line[39] ) {
        print "Location: $redirect_url", "\n\n";
        exit;
    }
    my $url = qq|<a href="$redirect_url"><font color="#0000FF">戻る</font></a>| if( $line[$turl] );
    &print_error('', '', $url, $conf);
    exit;
}

# 画面表示
sub print_error {
    local ( $subject, $message, $_url, $type ) = @_;
	
	$type = 'err' if( $type eq '' );
	
	if( $jcodeconvert eq '' ){
		($jcodeconvert, $jcodegetcode ) = &jcode_rap();
	}
	
	my $mobile = &cMobile();
	
	# ソースを取得
	local $array_source = &Ctm'find( $id, $type, $utf, $mobile );
	# <%registtable%>部分を取得
	local $source_table = &Ctm'_table( [@line], '',$mobile ) if( $type eq 'conf' );
	local $url = $_url if( $type ne 'conf' );
	
	if( $VCODE eq 'utf8' ){
		$jcodeconvert->(\$subject, 'utf8', 'sjis' );
		$jcodeconvert->(\$message, 'utf8', 'sjis');
		$jcodeconvert->(\$url, 'utf8', 'sjis');
		$jcodeconvert->(\$source_table, 'utf8', 'sjis');
	}
    
	local $meta;
	my @source;
	foreach( @$array_source ){
		local $line = $_;
		if( $VCODE eq 'utf8' ){
			$meta = qq|<meta http-equiv="Content-Type" content="text/html; charset=utf-8">|;
			$jcodeconvert->(\$line, 'utf8');
			
		}else{
			$meta = qq|<meta http-equiv="Content-Type" content="text/html; charset=shift_jis">|;
			$jcodeconvert->(\$line, 'sjis');
		}
		
		# <%registtable%>を変換
		$line =~ s/<%registtable%>/$source_table/;
		
		push @source, $line;
	}
	
	if( $type eq 'end' ){
		$id = $userID;
	}
	
    my $body;
	foreach( @source ) {
		local $line = $_;
		$line =~ s/(<\s*meta.*http-equiv.*charset.*>)/$meta/i;
		$_ = $line;
		while( ( $parameter ) = ( /<%([^<>\%]+)%>/oi ) ) {
			s//$$parameter/;
		}
        $body .= $_;
    }
	my $length = length $body;
	print "Content-type: text/html", "\n";
	print "Content-length: $length", "\n" if( $mobile );
	print "\n";
	print $body;
    exit;
}

#-----------------------#
# 日本語変換関数の指定  #
#-----------------------#
sub jcode_rap {
	my( $utf ) = @_;
	
	if( $utf ){
		eval 'use Jcode;';
		unless( $@ ){
			return \&Jcode'convert, sub{ $str = shift; my($code, $len )= &Jcode'getcode($str); return $code;};
		}
	}
	return \&jcode'convert, sub{ $str = shift; my $code = &jcode'getcode(\$str); return $code;};
}

BEGIN {
	push( @INC, "../lib/Jcode" );
}

sub my_method_ck{

	my($all);
	unless($ENV{'REQUEST_METHOD'} eq 'POST'){
		$all= $ENV{'QUERY_STRING'};
		&get_param($all);
	}else{
		if ( $ENV{'CONTENT_TYPE'} =~ m|multipart/form-data; boundary=([^\r\n]*)$|io ){
			&get_multipart_params();
		}else{
			read(STDIN, $all, $ENV{'CONTENT_LENGTH'});
			&my_get_param($all);
		}
	}
	# 携帯用にパラメータを区分け
	if( defined $param{'m_prop'} ){
		my @value = split(/,/, $param{'m_prop'} );
		foreach( @value ){
			my( $key, $val ) = split(/:/);
			$param{$key} = $val;
		}
	}
	$mode= &delspace($param{'md'});
}

sub my_get_param{
    local($alldata) = @_;
    local($data, $key, $val);
    foreach $data (split(/&/, $alldata)){
        ($key, $val) = split(/=/, $data);
		$key =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack('C',hex($1))/eg;
        $val =~ tr/+/ /;
        $val =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack('C',hex($1))/eg;
        $val =~ s/\t//g;
        $param{$key} = $val;
    }
	
}

# マルチフォームからのパラメータの取得
sub my_get_multipart_params{
    my($delim,$id,$value,$filename,$mimetype,$size);
    $delim=<STDIN>;
    $delim=~ s/\s+$//;
    $line='';
    until ($line =~ /^$delim--/){
        $id='';
        $value='';
        $filename='';
        $mimetype='';
        $line=<STDIN>;
        until ($line =~ /^\s*$/){
            return if eof(STDIN);
            if($line =~ /\sname="([^"]*)"/i){
                $id=$1;
            }
            if($line =~ /\sfilename="([^"]*)"/i){
                $filename=&delspace($1);
            }
            if($line =~ /^Content-Type:\s+(\S+)/i){
                $mimetype=$1;
            }
            $line=<STDIN>;
        }
        $size=0;
        $line=<STDIN>;
        until ($line =~ /^$delim/){
            return if eof(STDIN);
            $size+=length($line);
            # $value.=$line if ($size < $maxbyte);
            $value.=$line;
            $line = <STDIN>;
        }
        # if($size < $maxbyte){
        if (1) {
			$value =~ s/\t//g if($filename eq '');
            $param{$id} = $value;
            $paramtype{$id}=$mimetype if($mimetype ne '');
        }
        else{
            $param{$id}='';
            $paramtype{$id}='big';
        }
        
        $paramfile{$id}=$filename if($filename ne '');
        
    }
}

sub my_replace
{
	my $code = $jcodegetcode->($param{'cd'}) if( $param{'cd'} ne '' );
	my @keys = keys %param;
	foreach my $key ( @keys ){
		local $val = $param{$key};
		if( $code ne '' ){
			$jcodeconvert->(\$val, 'sjis', $code);
			
		}else{
			$jcodeconvert->(\$val, 'sjis');
		}
		$param{$key} = $val;
	}
}
sub Jcode
{
	my( $utf ) = @_;
	#my $mobile = &cAgent();
	my $mobile = &cMobile();
	# 文字コード変換用
	my $convUTF = ( $utf )? 1: 0;
	($jcodeconvert, $jcodegetcode ) = &jcode_rap( $convUTF );
	
	$CODE = $jcodegetcode->($param{'cd'}) if( $param{'cd'} ne '' );
	if( $mobile && $utf ){
		$VCODE = ( $CODE ne 'utf8' )? 'sjis': $CODE;
	}elsif( $mobile && !$utf ){
		$VCODE = 'sjis';
	}elsif( $utf ){
		$VCODE = 'utf8';
	}else{
		$VCODE = 'sjis';
	}
	
	return $mobile;
}


# 利用しない
sub cAgent
{
	my $mobile = 0;
	#ユーザーエージェントのみで判別する場合
	if($ENV{'HTTP_USER_AGENT'} =~ /^DoCoMo/){
		$mobile = 1;
	}elsif($ENV{'HTTP_USER_AGENT'} =~ /^J-PHONE|^Vodafone|^SoftBank|^Semulator/){
		$softbank = 1;
		$mobile = 1;
	}elsif($ENV{'HTTP_USER_AGENT'} =~ /^UP.Browser|^KDDI/){
		$mobile = 1;
	}
	return $mobile;
}
sub cMobile
{
	if( defined $param{'mbl'} ){
		return 1;
	}
	return 0;
}
