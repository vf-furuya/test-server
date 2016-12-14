#!/usr/bin/perl

#---------------------------------------
# 楽メールpro
#
# ステップメール送信専用CGIファイル send.cgi
# v 2.4
#---------------------------------------

# distributeディレクトリの相対パス（cronを使用する場合は「絶対パス」）
$myroot = '../';

# 絶対パス設定例
# $myroot = '/home/rakumail/public_html/distribute/';

# ライブラリインポート
require "${'myroot'}lib/send/send.pl";
require "${'myroot'}lib/Pub.pl";
require "${'myroot'}lib/System.pl";
require "${'myroot'}lib/cgi_lib.pl";
require "${'myroot'}lib/jcode.pl";
require "${'myroot'}lib/_html/Click.pl";

&Pub'Server();

$title         = '「楽メール」配信管理';
&method_ck();

my @errors;
local( $method, $each, $sleep, $partition ) = &send_method( \@errors );

# 再配信送信済み数
$csvsum = 0;
#----------------------------------------------------------------------------#
# CSVアップロード配信
#----------------------------------------------------------------------------#
if( $param{'ss'} ne '' ){
	&csvupload_fork();
	exit;
}else{
	
	# 配信再開チェック
	$csvsum = &sender_chk($method, $each, $sleep, $partition);
}

local $process = &permission();
#----------------------------------------------------------------------------#
# ステップメール配信
#----------------------------------------------------------------------------#
if ( $method ) {

FORK: {
	if( $pid = fork ) {
		if ( !$set ) {
			my $message = "「楽メール」配信を開始しました。!!\n";
			my $body = qq|<html><head><meta HTTP-EQUIV='Content-type' CONTENT='text/html; charset=shift_jis'><title>$title</title></head><body>$message</body></html>|;
			my $length = length $body;
			$| = 1;
			if ( $ENV{'REQUEST_METHOD'} ) {
				# ブラウザからの起動
				print "Content-type: text/html", "\n";
				print "Content-Length: $length\n\n";
				print "$body";
			}else{
				print "$message";
			}
			close(STDOUT);
    		wait;
		}else{
			wait;
			1;
		}
	
	} elsif (defined $pid) {
    	$| = 1;
    	close(STDOUT);
		$method = 1;
		&main_loop();
    	exit;
	
	} elsif ( $! =~ /No more process/) {
    	# プロセスが多すぎる時は、時間を置いて再チャレンジ。
    	sleep 5;
    	redo FORK;
	} else {
    	# fork使用不可サーバー。
		&format_pro( $process );
    	&error('システムエラー',"バックグラウンドでCGIが実行できないため、分割配信が出来ません。<br>送信方式を「アクセス毎に送信する」に設定してください。");
		exit;
	}
}

}else{
	&main_loop( $csvsum );
}

# -----------------------------------------------------------------------------------
# 定義関数
# -----------------------------------------------------------------------------------

sub main_loop {

my $csvsum = shift;
my $sum = 0;
my $start_time = (times)[0];

$sum += $csvsum if( $csvsum > 0 );

MAINLOOP:

# アクセス集計
&Click'pickup( 1 );

# 送信済み短縮URLを取得
my $forward = &Click'getForward_url();

my %new_csvdata = ();
my $fullpath = &lock();

#--------------------------#
# 既存のプランデータを取得 #
#--------------------------#
my $file = "$myroot$data_dir$log_dir$plan_txt";

unless ( open(PLAN, "$file" ) ) {
    push @errors, '配信プランファイルが開けません';
}
while( <PLAN> ) {
	last if ( !$method && ($sum >= $each) );
	
	if( $method && ($sum >= $partition) ) {
		$sum = 0; # 初期化
		close(PLAN);
		close(CSV);
		close(LOG);
		&rename_unlock( $fullpath );
		&format_pro( $process );
		$process = &pro();
		sleep( $sleep );
		goto MAINLOOP;
	}
	
    last if @errors;
    chomp;
    my @plan = split(/\t/);
    next if ( !$plan[37] );# 稼動停止中
	
	&Pub'ssl($plan[83]);
	
	#---------------------------#
	# 簡易稼動指定              #
	#---------------------------#
	my( $stt, $edt ) = split(/<>/,$plan[76]);
	my $now = time;
	my $hour = ( gmtime($now+(60*60*9)) )[2];
	if( $stt < $edt ){
		next if( $hour < $stt );
		next if( $hour >= $edt );
	}else{
		next if( $hour < $stt && $hour >= $edt );
	}
	
	$param{'id'}  = $plan[0] - 0;
    my $csvpath   = "$myroot$data_dir$csv_dir$plan[6]";
    my $queuepath = "$myroot$data_dir$queue_dir$plan[7]";
    my $rh_body   = &get_body( $queuepath );
    my $logpath   = "$myroot$data_dir$log_dir$plan[8]";
    $plan[9]      =~ s/<br>/\n/gi; my $header = $plan[9];
    $plan[10]     =~ s/<br>/\n/gi; my $cancel = $plan[10];
    $plan[11]     =~ s/<br>/\n/gi; my $footer = $plan[11];
    my ( $count, @input_check ) = split(/,/, $plan[35]); # 配信数、挿入チェック
	my ( $intervals, $dates ) = split( /<>/, $plan[36] );
    my @interval = split(/,/, $intervals);                # 配信日程
	my @dates = split( /,/, $dates );
    my $rh_body = &get_body( $queuepath );
    unless ( open(LOG, ">>$logpath") ) {
        push @errors, 'ログファイルが開けません';
    }
    
    unless ( open(CSV, "$csvpath") ) {
        push @errors, '登録者データが取得できません';
    }
	
	#---------------------------#
	# 転送用タグ取得            #
	#---------------------------#
	my( $urlTag, $other ) = &Click'roadTag( $plan[82] );
	
	my $SENDED_INFO;
    while( <CSV> ) {
		last if ( !$method && ($sum >= $each) );
		
		if( $method && ($sum >= $partition) ) {
			$sum = 0; # 初期化
			close(PLAN);
			close(CSV);
			close(LOG);
			if ( (keys %new_csvdata) ) {
				# 登録者の更新
				&renew_csv_data( $csvpath, \%new_csvdata );
			}
			&rename_unlock( $fullpath );
			&format_pro( $process );
			$process = &pro();
			sleep( $sleep );
			goto MAINLOOP;
		}
		
        last if @errors;
        chomp;
        my @csv = split(/\t/);
		my @incsv = @csv;
		
		#--------------------------------------------------------
		# 日付指定制御用
		#--------------------------------------------------------
		my $inputed_codedate = &make_datecode($csv[21]); # 最終送信日（秒）日付指定送信に使用
		my $inputed_codedate_day = substr( &make_datecode($csv[21]), 4 ); # 最終送信日（秒）日付指定送信に使用
		my $now = time;
		$nowcode = &make_datecode($now);
		$nowcode_day = substr( &make_datecode($now), 4);
		my $flag = 0;
        my $n = 0;
		
        # 日付指定の場合
		foreach my $_date ( @dates ) {
			last if ( !$method && ($sum >= $each) );
			if( $method && ($sum >= $partition) ) {
				$sum = 0; # 初期化
				close(PLAN);
				close(CSV);
				close(LOG);
				if ( (keys %new_csvdata) ) {
					# 登録者の更新
					&renew_csv_data( $csvpath, \%new_csvdata );
				}
				&rename_unlock( $fullpath );
				&format_pro( $process );
				$process = &pro();
				sleep( $sleep );
				goto MAINLOOP;
			}
        	my ( $mon, $day, $year ) = split(/\//, $_date);
			my $code_year = sprintf("%04d", $year);
        	my $code_day = sprintf("%02d", $mon) . sprintf("%02d", $day);
			my $SENDED_CODE .= $csv[5] . "[$inputed_codedate]";
			# 最終送信日が本日で無い場合
        	if ( $inputed_codedate ne $nowcode ) {
				
        		next if ( $code_year > 0 && $code_year.$code_day ne $nowcode );
				next if ( $code_year <= 0 && $code_day ne $nowcode_day );
					
					#my $edcode = $csv[5] . "[$nowcode]";
					# 同一メールアドレスには、送信しない
					if( index( $SENDED_INFO, $SENDED_CODE ) >= 0 ){
						$csv[21] = $now; # 最終送信日（秒）日付指定
                		my $line = join("\t", @csv);
						my $sid = $csv[0] -0;
                		$new_csvdata{$sid} = $line;
						goto STEP;
					}
					$SENDED_INFO .= "#$SENDED_CODE";
					my $code = $code_day;
					$code .= $code_year if( $code_year > 0 );
					
					# 送信メール作成
        			local ( $subject, $message ) = &make_send_body( "d$code", $rh_body, $header, $cancel, $footer );
					
        			my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
        			$subject = &include( \@incsv, $subject );
					$message = &include( \@incsv, $message, $jis );
					$senderror = &send( $plan[4], $plan[3], $csv[5], $subject, $message );
					if ( !$senderror ) {
                		print LOG "$csv[0]\t$csv[5]\t$csv[3]\t$now\td$code\t$subject\n";
                		$csv[21] = $now; # 最終送信日（秒）日付指定
                		my $line = join("\t", @csv);
						my $sid = $csv[0] -0;
                		$new_csvdata{$sid} = $line;
						
            		} else {
					
                		push @errors, 'メールが送信できません';
                		last;
						
            		}
					$sum++;
				
				
			}
		}
		
		STEP:
		#----------------------------------------------------------
		# 日数間隔の場合
		#----------------------------------------------------------
        my $registDate = $csv[19]-0; # 登録日（秒）
		my $targetStep = $csv[51]; # 配信回指定
		my $stop = $csv[52] -0;
		my %baseTime; # 再開日付
		foreach( split(/<>/,$csv[53] ) ){
			my( $n, $date ) = split(/\//);
			$baseTime{$n} = $date;
		}
		my( $targetInterval, $targetBase ) = split(/\//, $csv[54]); # 指定回の起算日数と起算日付
		
		
		# 配信完了の場合
		next if( $targetStep eq 'end' );
		
		my $sendStepNum = ( $csv[51] > 0 )? $csv[51]: $csv[20];
		my $stepBase = &getBaseTime( $registDate, $intervals, $csv[53], $sendStepNum );
		
		my $n = 1;
		#my $date = $registDate; # 登録日
        foreach my $_int ( @interval ) {
			my( $int, $config, $unic ) = split( /\//,$_int );
			$n++; # 配信回数を進める
			
			# 起算日数の基本日付を取得
			#if( $config ){
			#	$date = $baseTime{$n} if( $baseTime{$n} > 0 );
			#}
			#if( $targetInterval > 0 ){
			#	$date = $targetBase if( $targetBase > 0 );
			#	$int = $targetInterval;
			#}
			
			last if ( !$method && ($sum >= $each) );
			if( $method && ($sum >= $partition) ) {
				$sum = 0; # 初期化
				close(PLAN);
				close(CSV);
				close(LOG);
				if ( (keys %new_csvdata) ) {
					# 登録者の更新
					&renew_csv_data( $csvpath, \%new_csvdata );
				}
				&rename_unlock( $fullpath );
				&format_pro( $process );
				$process = &pro();
				sleep( $sleep );
				goto MAINLOOP;
			}
			# 一時停止の場合
			last if( $stop );
			# 配信済みの場合
			next if( $n <= $csv[20] );
			# 指定回がある場合
			next if( $targetStep > 0 && $n < $targetStep );
			# 起算日付
			my $date = $stepBase->{$n};
			# 再開指定が有る場合
			if( $targetInterval > 0 ){
				$date = $targetBase;
				$int = $targetInterval;
			}
			$datecode = &make_datecode( $date+(60*60*24*$int) ); # 配信日
			
			# 登録日に達していない場合
			last if ( $nowcode < $datecode );
			
			
			# 未配信に一時停止が有る場合は、そこまで
			if( $config && !$targetInterval ){
				$stop = 1;
				$csv[52] = 1;
				my $line = join("\t", @csv);
				my $sid = $csv[0] -0;
				$new_csvdata{$sid} = $line;
				last;
			}
			
			#$flag = 2 if ( $nowcode >= $datecode );
			# 送信メール作成
			local ( $subject, $message ) = &make_send_body( $n-1, $rh_body, $header, $cancel, $footer );
			# 転送タグ変換
			my $forward_urls;
			($message, $forward_urls) = &Click'analyTag($csv[0], $message, $urlTag, $unic, $forward);
			
			my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
			$subject = &include( \@incsv, $subject );
			$message = &include( \@incsv, $message, $jis );
			$senderror = &send( $plan[4], $plan[3], $csv[5], $subject, $message );
			if ( !$senderror ) {
				my $sendNum = $n -1;
				print LOG "$csv[0]\t$csv[5]\t$csv[3]\t$now\t$sendNum\t$subject\n";
				$csv[20] = $n; # 最終配信番号の更新
				my $def = 0;
				if( $targetStep == $n || $targetInterval ){
					$targetStep = '';
					$targetInterval = '';
					$targetBase = '';
					$csv[51] = ''; # 指定回
					$csv[54] = ''; # 指定配信開始日
					$def = 1;
				}
				$baseTime{$n} = time;
				my @base;
				foreach( keys %baseTime ){
					push @base, qq|$_/$baseTime{$_}|;
				}
				$csv[53] = join( "<>", @base );
				$csv[52] = 0; # 一時停止を解除
				$stop = 0;
				my $line = join("\t", @csv);
				my $sid = $csv[0] -0;
				$new_csvdata{$sid} = $line;
				
				# アクセス集計用データ生成
				&Click'setForward_t( $forward_urls, $unic );
				
				if( $def ){
					$sum++;
					goto STEP;
				}
				
			} else {
			
				push @errors, 'メールが送信できません';
				last;
				
			}
			$sum++;
		}
	}
	close(CSV);
	
	if ( (keys %new_csvdata) ) {
		# 登録者の更新
		&renew_csv_data( $csvpath, \%new_csvdata );
	}
	
}
close(PLAN);
&rename_unlock( $fullpath );
&format_pro( $process );
# 配信終了

return if defined $pid; # 子プロセスなら終了

my $end_time = (times)[0];
my $search_time = sprintf ("%.3f",$end_time - $start_time);
if ( !$set ) {
	my $more = '<br><br>メール送信の制限数に達した為、送信を中断しました<br>もう一度、アクセスしてください' if ( !$method && ($sum >= $each) );
    #--------------#
    # 出力         #
    #--------------#
    if ( !$ENV{'REQUEST_METHOD'} ) {
        if ( @errors ) {
            foreach ( @errors ) {
                print $_, '<br>';
            }
        } else {
            print <<"END";
[ メール自動配信 ]
正常に配信を終了しました

$more
END
        }
    }else{
        if ( $ENV{'QUERY_STRING'} eq 'run' ) {
            my $imagepath = "$myroot$image_dir$imagefile";
            open(IMG, $imagepath);
            print "Content-type: image/gif", "\n\n";
	        binmode(STDOUT);
            print <IMG>;
            exit;
        
        }
        if ( @errors ) {
            print "Content-type: text/html", "\n\n";
            print "<html>";
            foreach ( @errors ) {
                print $_, '<br>';
            }
            print "</html>";
        } else {
            &error('完了しました',"$sum 件のメールを配信しました<br>送信にかかった時間 $search_time$more");
        }
    }
    exit;
}


}


sub csvupload_fork
{
	unless( $method ){
		&format_pro( $process );
		&error('システムエラー', '許可されていない動作です。');
	}
	local( $id, $filename, $session ) = &upload_prop( \@errors );
	
	UPFORK: {
		if( $pid = fork ) {
			my $message = "「楽メール」登録時一斉メール配信を開始しました。!!\n";
			my $length = length $message;
			$| = 1;
			print "Content-type: text/plain", "\n";
			print "Content-Length: $length\n\n";
			print $message;
			close(STDOUT);
			wait;
		} elsif (defined $pid) {
			$| = 1;
			close(STDOUT);
			
			my $rest;
			CSVUP:
			($rest, $sended ) = &csvupload_sender( $id, $filename, $session, $partition );
			if( $rest > 0 ){
				#$process = &pro();
				sleep($sleep);
				goto CSVUP;
			}
			exit;
		} elsif ( $! =~ /No more process/) {
			# プロセスが多すぎる時は、時間を置いて再チャレンジ。
			sleep 5;
			redo UPFORK;
		} else {
			# fork使用不可サーバー。
			&format_pro( $process );
			exit;
		}
	}
}

sub degug
{
	my $file = '../data/bug.txt';
	open( BUG, ">>$file" );
	print BUG $_[0]."\n";
	close(BUG);
}
