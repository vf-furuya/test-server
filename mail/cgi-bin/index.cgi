#!/usr/bin/perl

#---------------------------------------------------------------------
# 楽メールpro
#
# バージョン
$Version = '2.4.0.3';
#---------------------------------------------------------------------
# v2.4以前のためconfig.plを読み込んで各種設定を保持
&peculiar();

require '../lib/Pub.pl';
require '../lib/System.pl';
require "${'myroot'}lib/cgi_lib.pl";
require "${'myroot'}lib/jcode.pl";


&method_ck();
# 画像表示
if( $mode eq 'img' ){
	&Pub'image();
}

# セットアップ確認
require "${'myroot'}lib/setup.pl";

require "${'myroot'}lib/_html/session.pl";
require "../lib/composition.pl";

&Pub'Server(1);

&Simul'slch() if( $mode eq 'slch' );
&pass_check() if ($mode eq 'ck');
#&get_cookie();
#----------------------------------------------------------------------
# 認証
#----------------------------------------------------------------------
unless( &Session'check( \&error ) ){
	if( $mode eq 'imgupload' || $mode eq 'fdetail' || $mode eq 'manual' || $mode eq 'ctm_regprev' ){
		&error('ログインしてください。','アクセスの有効期限が過ぎました。<br>お手数ですが一度ログアウトし、再度ログインしてください。');
		exit;
	}
	&html_pass();
}
&make_mailtag_tmp();
# 転送データの集計
&Click'pickup();

if ( $mode eq 'new' )      { &make_page( 'new' ); }
elsif ( $mode eq 'list' )  { &make_page( 'list' ); }
elsif ( $mode eq 'admin' ) { &make_page( 'admin' ); }
elsif ( $mode eq 'method' ){ &make_page( 'method' ); }
elsif ( $mode eq 'help' )  { &make_page( 'help' ); }
elsif ( $mode eq 'all' )   { &make_plan_page('plan', 'all'); }
elsif ( $mode eq 'log' )   { &make_plan_page('plan', 'log'); }
elsif ( $mode eq 'pname' ) { &make_plan_page('plan', 'pname'); }
elsif ( $mode eq 'bs' )    { &make_plan_page('plan', 'bs'); }
elsif ( $mode eq 'header' ){ &make_plan_page('plan', 'header'); }
elsif ( $mode eq 'footer' ){ &make_plan_page('plan', 'footer'); }
elsif ( $mode eq 'cl' )    { &make_plan_page('plan', 'cl'); }
elsif ( $mode eq 'form1' ) { &make_plan_page('plan', 'form1'); }
elsif ( $mode eq 'form2' ) { &make_plan_page('plan', 'form2'); }
elsif ( $mode eq 'l' )     { &make_plan_page('plan', 'schedule'); }
elsif ( $mode eq 'p' )     { &make_plan_page('plan', 'preview'); }
elsif ( $mode eq 'ml' )    { &make_plan_page('plan', 'body'); }
# HTML編集画面
elsif ( $mode eq 'mb_html'){ &make_plan_page('plan', 'html'); }
elsif ( $mode eq 'mf1' )   { &make_plan_page('plan', 'mf1'); }
elsif ( $mode eq 'mf2' )   { &make_plan_page('plan', 'mf2'); }
elsif ( $mode eq 'mf3' )   { &make_plan_page('plan', 'mf3'); }
elsif ( $mode eq 'fdetail'){ &MF'action(); }
# フォームプレビュー
elsif ( $mode eq 'sprev' ){ &make_plan_page('plan', 'sprev'); }
# 画面カスタマイズ
elsif ( $mode eq 'ctm_regdisp' ) { &make_plan_page('plan', 'ctm_regdisp'); }
elsif ( $mode eq 'ctm_regprev' ){ &make_plan_page('plan', 'ctm_regprev'); }

elsif ( $mode eq 'g' )     {
	if( $param{'pnum'} eq '' ){
		print "Set-Cookie: raku_search=", "\n"; # Cookie初期化
		$all_cookies{'raku_search'} = '';  # 検索要素初期化
		$param{'def_search'} = 1;
	}
	&make_plan_page('plan', 'guest'); }
elsif ( $mode eq 'add' )   { &make_plan_page('plan', 'add'); }
elsif ( $mode eq 'up' )    { &make_plan_page('plan', 'up'); }
elsif ( $mode eq 'upsend' ){ &csvupload_each(); }
elsif ( $mode eq 'ref' )   { &make_plan_page('plan', 'ref'); }
elsif ( $mode eq 'mail' )  { &make_plan_page('plan', 'mail'); }
elsif ( $mode eq 'mailnext'){&make_plan_page('plan', 'mailnext');}
# 一斉メール(バックグラウンド)
elsif ( $mode eq 'simul')  {&Simul'send_background();}
elsif ( $mode eq 'redirect'){ &make_plan_page('plan', 'redirect');}
# 一斉メール(条件指定)
elsif ( $mode eq 'simul_cdn_conf' ){ &make_plan_page( 'plan', 'simul_cdn_conf' ); }
elsif ( $mode eq 'simul_cdn_set' ){ &Simul'cdn_set(); }
# 削除確認画面
elsif ( $mode eq 'confdel'){ &make_plan_page('plan', 'delete');}

elsif ( $mode eq 'resche' ){ &reschedule(); } 
elsif ( $mode eq 'body' )  { &body(); }
# HTMLの編集
elsif ( $mode eq 'html' )  { &body_html(); }
elsif ( $mode eq 'htmlprev'){ &htmlprev(); }
elsif ( $mode eq 'text' )  { &renew(); }
elsif ( $mode eq 'next' )  { &regist(); }
elsif ( $mode eq 'st' )    { &sendtest(); }
#elsif ( $mode eq 'guest' ) { &reguest(); }
elsif ( $mode eq 'addguest'){ &guest(); }
#elsif ( $mode eq 'renew' ) { &renewguest(); }
#elsif ( $mode eq 'cancel' ){ &renewguest(); }
elsif ( $mode eq 'get' )   { &csv(); }
elsif ( $mode eq 'upload' ){ &upload(); }
elsif ( $mode eq 'mailsend'){ &mailsend(); }
elsif ( $mode eq 'ipchange'){ &ipchange(); }
elsif ( $mode eq 'remethod'){ &method(); }
elsif ( $mode eq 'run')     { &renew(); }
elsif ( $mode eq 'logout' ){ &logout(); }
# 画像アップロード
elsif ( $mode eq 'imgupload' ){ &imgupload(); }

# まぐまぐ登録機能
elsif ( $mode eq 'f_magu' ){ &make_plan_page('plan', 'magu'); }
elsif ( $mode eq 'k_magu' ){ &Magu::Keep(); }

# 設定ファイル公開
elsif ( $mode eq 'config' ){ &disp_config(); }
elsif ( $mode eq 'manual' ){ &manual(); }
# プランコピー
elsif ( $mode eq 'copy' ){ &make_plan_page('plan', 'copy'); }
elsif ( $mode eq 'make_copy' ){ &Copy'copy(); }
# 配信再開
elsif ( $mode eq 'restart' ){ &restart(); }
# 本文CSV
elsif ( $mode eq 'down_step' ){ &down_step(); }
elsif ( $mode eq 'upload_step' ){ &upload_step(); }
# クリック分析
elsif ( $mode eq 'click_analy' ){ &make_plan_page( 'plan', 'click_analy' ); }
# エラーファイル公開
elsif ( $mode eq 'error' ){ &disp_error(); }
elsif ( $mode eq 'pms' ){ &disp_pms(); }
elsif ( $mode eq 'file' ){ &getControl(); }
&make_page( 'help' );

exit;
# --------------------------------------------------------------------------------
# ユーザー定義関数
# --------------------------------------------------------------------------------

#--------------------------------------------------#
# 認証                                             #
#--------------------------------------------------#
sub pass_check {
	my $input_id = &delspace($param{'input_id'});
	my $input_pass = &delspace($param{'input_pass'});
	my $path = $myroot . $data_dir . $log_dir . $admin_txt;
	
	unless ( open(PASS, "$path" ) ) {
		&html_main("システムエラー<br><br>$pathが開けません");
	}
	my $id = <PASS>;
	my $pass = <PASS>;
	chomp( $id );
	chomp( $pass );
	if ( $id eq '' || $pass eq '' ) {
		unless ($defid eq $input_id && $defpass eq $input_pass) {
			&error('認証エラー', "認証に失敗しました");
		}
	}else{
		unless ( $id eq $input_id && $pass eq crypt($input_pass,$pass) ) {
			&error('認証エラー', "認証に失敗しました");
		}
	}
	# フォーム自動生成ログファイルの有無確認
	&MF'logfile_find();
	
	# 一斉メール強制終了確認
	my $run_simul = 0;
	if( &Simul'running( 1 ) ){
		$run_simul = 1;
	}
	# ログイン認証時(Session発行)
	&Session'set($pass);
	
	# 一斉条件指定メールテンポラリーファイルを削除
	&Simul'cdn_clean( 1 );
	&make_page( 'help', '', '', '', $run_simul );
}

#--------------------------------------------------#
# ログアウト                                       #
#--------------------------------------------------#
sub logout {
    &Session'reset();
    &html_pass();
    exit;
}

#--------------------------------------------------#
# 送信方式の設定                                   #
#--------------------------------------------------#
sub method {
    
	my $method = $param{'method'}-0;
	my $each  = $param{'each'}-0;
	$each = 200 if ( $each > 200 );
	my $sleep  = $param{'sleep'}-0;
	$sleep = 60 if ( $sleep > 60 );
	my $partition  = $param{'partition'}-0;
	$partition = 100 if ( $partition > 100 );
	
	my $chk_sleep = $param{'chk_sleep'} -0;
	my $r_sleep   = $param{'r_sleep'} -0;
	my $chk_f     = $param{'chk_f'} -0;
	my $f_mail    = $param{'f_mail'};
	
	$r_sleep = 10 if( $r_sleep > 10 );
	if( $chk_sleep && !$r_sleep ){
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>待ち時間を入力してください。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
        &html_main( $table );
	}
	if( $chk_f && &chk_email($f_mail) ){
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>メールアドレスの形式に誤りがあります。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
        &html_main( $table );
		exit;
	}
	
	my $dummy = $myroot . $data_dir . $$ . time . '.dummy';
	my $lockfull = &lock();
	unless ( open(DUMMY, ">$dummy") ) {
		&rename_unlock( $lockfull );
		&error('システムエラー', 'ダミーファイルが作成できません');
	}
	print DUMMY "method\t$method\n";
	print DUMMY "each\t$each\n";
	print DUMMY "sleep\t$sleep\n";
	print DUMMY "partition\t$partition\n";
	print DUMMY "chk_sleep\t$chk_sleep\n";
	print DUMMY "r_sleep\t$r_sleep\n";
	print DUMMY "chk_f\t$chk_f\n";
	print DUMMY "f_mail\t$f_mail\n";
	close(DUMMY);
	rename $dummy,"$myroot$data_dir$methodtxt";
	&rename_unlock( $lockfull );
	&make_page( 'method' );
    exit;
}

#--------------------------------------------------#
# ID、パスワードの変更                             #
#--------------------------------------------------#
sub ipchange {
    
    my $nid = $param{'nid'};
    my $npass = $param{'npass'};
    my $rpass = $param{'rpass'};
    my $input_id = $param{'input_id'};
    my $input_pass = $param{'input_pass'};
    if ( $npass eq '' ) {
	
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>パスワードを入力してください。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
        &html_main( $table );
    }
    if ( $npass ne $rpass ) {
	
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>確認パスワードが一致しません。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
        &html_main( $table );
    }
    my $new_pass = crypt( $npass, &make_salt() );
    my $fullpath = &lock();
    my $path = $myroot . $data_dir . $log_dir . $admin_txt;
    unless ( open(PASS, "$path" ) ) {
        &rename_unlock( $fullpath );
		
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>システムエラー<br><br>$pathが開けません。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
        &html_main( $table );
    }
    my $id = <PASS>;
    my $pass = <PASS>;
    close(PASS);
    chomp( $id, $pass );
    $nid = $id if !$nid;
    if ( $id eq '' || $pass eq '' ) {
	    unless ($defid eq $input_id && $defpass eq $input_pass) {
            &rename_unlock( $fullpath );
			
			my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>パスワードが違います。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
        	&html_main( $table );
        }
    }else{
        unless ( $id eq $input_id && $pass eq crypt($input_pass,$pass) ) {
            &rename_unlock( $fullpath );
			
			my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>パスワードが違います。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
			&html_main( $table );
		}
	}
	
	my $tmp = $myroot . $data_dir . $log_dir . $$ . time . '.tmp';
	unless ( open(TMP, ">$tmp" ) ) {
		&rename_unlock( $fullpath );
		
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>システムエラー<br><br>テンポラリーファイルが作成できません$data_dirのパーミッションを確認してください。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
		&html_main( $table );
	}
	$nid = $defid if !$nid;
	print TMP "$nid\n";
	print TMP "$new_pass\n";
	close(TMP);
	rename $tmp, $path;
	&rename_unlock( $fullpath );
	&make_page( 'list' );
    exit;
}
#--------------------------------------------------#
# 暗号化のキー作成                                 #
#--------------------------------------------------#
sub make_salt {
    srand (time + $$);
    return pack ('CC', int (rand(26) + 65), int (rand(10) +48));
}
#--------------------------------------------------#
# 配信プランの更新                                 #
#--------------------------------------------------#
sub renew {
	#----------------------------#
	# 更新する項目のセット       #
	#----------------------------#
	my $id = &delspace( $param{'id'} );
	my $data;
	my $index;
	my $action = &delspace( $param{'action'} );
	if($action eq ''){&make_plan_page( 'plan', '', 'エラー' );exit;}
	if    ( $action eq 'pname' )  { $data = &the_text( $param{'text'} ); $index=2; }
	elsif ( $action eq 'header' ) { $data = &the_text( $param{'text'} ); $index=9; }
	elsif ( $action eq 'cl' )     { $data = &the_text( $param{'text'} ); $index=10; }
	elsif ( $action eq 'footer' ) { $data = &the_text( $param{'text'} ); $index=11; }
	
	# 配信元情報
	my ( $pname, $sname, $address, $address2 );
	if ( $action eq 'bs' ) { 
		$pname    = &deltag( $param{'pname'} );
		$sname    = &deltag( $param{'sname'} );
		$address  = &the_text( $param{'address'} );
		if (&chk_email($address) ) {
			&make_plan_page( 'plan', 'g', 'メールアドレスの形式が正しくありません');
			exit;
        }
		$address2 = &the_text( $param{'address2'} );
		foreach my $_email ( split(/,/, $address2) ){
			if( &chk_email($_email) ) {
				&make_plan_page( 'plan', 'g', 'メールアドレスの形式が正しくありません');
				exit;
			}
		}
	}
	
	# 登録用フォーム
	my %form1;
	my @findex;
	my $st   = 15; # 格納データの開始インデックス
	my $end  = 32; # 格納データの終了インデックス
	foreach my $i ( 15 .. 32 ){
		push @findex, $i;
	}
	my $st2  = 43; # 格納データの開始インデックス（04/6/17追加修正）
	my $end2 = 57; # 格納データの終了インデックス（04/6/17追加修正）
	foreach my $i ( 43 .. 57 ){
		push @findex, $i;
	}
	my $st3  = 61; # 格納データの開始インデックス（06/12/21追加修正 v2.2）
	my $end3 = 65; # 格納データの終了インデックス（06/12/21追加修正 v2.2）
	foreach my $i ( 61 .. 65 ){
		push @findex, $i;
	}
	# 58,59は姓名別の格納データ
	my $st3  = 66; # 格納データの開始インデックス（07/06/14追加修正 v2.3）
	my $end3 = 75; # 格納データの終了インデックス（07/06/14追加修正 v2.3）
	foreach my $i ( 66 .. 75 ){
		push @findex, $i;
	}
	my $setDesign = 0;
	if ( $action eq 'form1' ) {
		
		# デザイン選択
		if( defined $param{'setDesign'} ){
			$design = $param{'design'};
			$setDesign = 1;
			goto INPUT;
		}
		
		my %Sort;
		foreach my $i ( @findex ) {
			my $ck = ($param{"fm$i"})? 1: 0;
			my $req = ($param{"req$i"})? 1: 0;
			$ck = 1 if($i == 19); # メールアドレス
			$req = 1 if($i == 19);
			$req = 1 if($i == 65 && $ck == 1 ); # メールアドレス確認
			$form1{$i} = $ck . '<>' . &deltag($param{"text$i"}) . '<>' . $req. '<>'. $param{"sort$i"};
			
			if( defined $Sort{$param{"sort$i"}} ){
				&make_plan_page( "plan", "", "表\示順の指定に誤りがあります。" );
				exit;
			}
			$Sort{$param{"sort$i"}} = 1 if( $param{"sort$i"} > 0 );
			
			#姓名別
			#if( $i eq 17 ){
			#	my $sep = ($param{'_fm17'})? 1: 0;
			#	my $sep1 = &deltag( $param{'_text17_1'} );
			#	my $sep2 = &deltag( $param{'_text17_2'} );
			#	$form1{'58'} = $sep . '<>' . $sep1 . '<>' . $sep2;
			#}
			#if( $i eq 18 ){
			#	my $sep = ($param{'_fm18'})? 1: 0;
			#	my $sep1 = &deltag( $param{'_text18_1'} );
			#	my $sep2 = &deltag( $param{'_text18_2'} );
			#	$form1{'59'} = $sep . '<>' . $sep1 . '<>' . $sep2;
			#}
		}
	}
	
	
    # 変更、削除用フォーム
    my $re;
    my $de;
    if ( $action eq 'form2' ) {
		my $ck1 = ($param{'fr'})? 1: 0;
        my $ck2 = ($param{'fd'})? 1: 0;
        my $rmail = &deltag( $param{'rmail'} );
        my $rnmail = &deltag( $param{'rnmail'} );
        my $dmail = &deltag( $param{'dmail'} );
        my $rid = &deltag( $param{'ruserid'} );
        my $did = &deltag( $param{'duserid'} );
        $re = "$ck1<>$rid<>$rmail<>$rnmail";
        $de = "$ck2<>$did<>$dmail";
	}
	# リダイレクトURL
	my ( $rurl, $nrul, $crul, $out, $ck, $ck2, $ck3 );
	if ( $action eq 'redirect' ) {
		$rurl = &deltag( $param{'regist'} );
		$nurl = &deltag( $param{'renew'} );
		$curl = &deltag( $param{'cancel'} );
		$ck = ( $param{'ck'} )? 1: 0;
		$ck2 = ( $param{'notice'} )? 1: 0;
		$ck3 = ( $param{'confirm'} )? 1: 0;
		$dck = ( $param{'dck'} )? 1: 0;
		$out = &deltag( $param{'out'} );
		$utf = $param{'utf'} -0;
		$ssl = $param{'ssl'} -0;
		# HTTP情報
		$http_regist = &deltag( $param{'http_regist'});
		$http_renew = &deltag( $param{'http_renew'});
		$http_cancel = &deltag( $param{'http_cancel'});
		
		# Jcodeライブラリの確認
		if( $utf ){
			unless( &Ctm'jcode_check() ){
				&make_plan_page( "plan", "", "Jcodeライブラリが正しく設置されておりません。<br>文字コードに「UTF-8」を利用するには、<br>一式同梱の『UTF8をご利用の場合』を参照いただいきインストールください。" );
			}
		}
    }
    # 稼動、停止
    if ( $mode eq 'run' ) {
        $data = $param{'action'}-0;
        $index = 37;
    }
	if( $action eq 'body' ){
		$data = $param{'ra_conf'} -0;
		$index = 77;
	}
	
	
	INPUT:
	#---------------------#
	# 排他処理            #
	#---------------------#
	my $lockfull = &lock();
	#--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page('plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	#---------------------#
	# テンポラリファイル  #
	#---------------------#
	my $tmp = $myroot . $data_dir . $log_dir . $id . '.tmp';
	unless ( open(TMP, ">$tmp" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリファイルが作成できません<br>$data_dirディレクトリのパーミッションを確認してください");
		exit;
	}
	while( <PLAN> ) {
		chomp;
		my @line = split(/\t/);
		if( $action eq 'runtime' ){
			my $st = $param{"$line[0]\_s"} -0;
			my $ed = $param{"$line[0]\_e"} -0;
			$line[76] = "$st<>$ed";
		}
		if ( $line[0] eq $id ) {
			if ( $action eq 'bs' ) {
				# 配信元
				$line[2] = $pname;
				$line[3] = $sname;
				$line[4] = $address;
				$line[5] = $address2;
			}elsif ( $action eq 'form1' ) {
				# 登録用フォーム
				if( defined $param{'setDesign'} ){
					$line[81] = $design;
				}else{
					foreach my $i ( @findex ) {
						$line[$i] = $form1{$i};
					}
				}
				#$line[58] = $form1{'58'};
				#$line[59] = $form1{'59'};
				
			}elsif ( $action eq 'form2' ) {
				# 変更・解除用フォーム
				$line[33] = $re;
                $line[34] = $de;
			}elsif ( $action eq 'delete' ) {
				# 配信プラン削除
				unless ( open(QUEUE, "$myroot$data_dir$queue_dir$line[7]" ) ) {
					close(TMP);
					unlink $tmp;
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>データファイルが開けません。（本文設定）");
					exit;
				}
				while(<QUEUE>){
					chomp;
					my $filename = ( split(/\t/) )[7];
					my $filepath = $myroot . $data_dir . $queue_dir . $filename;
					if( -e $filepath ){
						unlink $filepath;
					}
				}
				close(QUEUE);
				
				# まぐまぐ登録設定の削除
				&Magu::delete( $id );
				# フォーム自動生成設定の削除
				&MF'set('delete');
				# カスタマイズ削除
				&Ctm'clean( $id );
				# アクセス集計削除
				my @ids;
				my( $sche, $da ) = split(/<>/,$line[36]);
				foreach( split(/,/,$sche ) ){
					my $code = (split(/\//) )[2];
					push @ids, $code;
				}
				push @ids, $id;
				&Click'clean( @ids );
				
				unlink "$myroot$data_dir$csv_dir$line[6]", "$myroot$data_dir$queue_dir$line[7]","$myroot$data_dir$log_dir$line[8]";
				next;
			}elsif ( $action eq 'redirect' ) {
				$line[12] = $rurl;
				$line[13] = $nurl;
				$line[14] = $curl;
				$line[38] = $out;
				$line[39] = $ck;
				$line[40] = $ck2;
				$line[41] = $ck3;
				$line[42] = $dck;
				$line[60] = $utf;
				$line[78] = $http_regist;
				$line[79] = $http_renew;
				$line[80] = $http_cancel;
				$line[83] = $ssl;
            }elsif( $action eq 'click_analy' ){
				$line[82] = $param{'addr'}; # Click.pl で生成
			}else {
				$line[$index] = $data if( $index ne '' );
			}
			
		}
		$_ = join("\t", @line);
		print TMP "$_\n";
	}
	close(TMP);
	close(PLAN);
	rename $tmp, $file;
	#---------------------#
	# 排他処理排除        #
	#---------------------#
	&rename_unlock( $lockfull );
	
	# 管理者通知設定の場合
	if( $mode eq 'body' ){
		return;
	}
	# クリック分析
	if( $mode eq 'click_analy' ){
		return;
	}
    &make_page( 'list' ) if ( $action eq 'delete' || $action eq 'runtime' );
	&make_plan_page( 'plan', 'form1' ) if( $setDesign );
	&make_plan_page( 'plan', 'all' );
	exit;
}

#--------------------------------------------------#
# 配信プランの新規追加                             #
#--------------------------------------------------#
sub regist {
	
	my $pname = &delspace( $param{'p_title'} );
	if ( $pname eq '' ) {
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>識別名を入力してください。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
        &html_main( $table );
    }
	my $count = $param{'count'} - 0;
	my $interval = $param{'interval'} - 0;
	my @intervals;
    my $int;
	for( my $i=0; $i<$count; $i++ ){
        $int += $interval;
		$intervals[$i] = $int;
	}
    my $intervals = join(",", @intervals);
	my $now = time;
	my $id = $now . $$;
	my $csv = 'C' . $id . '.cgi';
	my $queue = 'Q' . $id . '.cgi';
	my $sendlog = 'L' . $id . '.cgi';
	my $date = &make_date2( $now );
	
	if( $count > 0 && !$interval ){
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>配信間隔を指定してください。</td>
</tr>
<tr>
<td><font color="#0000FF">ブラウザの<strong>「戻る」</strong>ボタンをクリックし、再度入力してください。</font></td>
</tr>
</table>
END
		&html_main( $table );
		exit;
	}
	
	
	
	#---------------------#
	# 排他処理            #
	#---------------------#
	my $lockfull = &lock();
	#-------------------------------#
	# 登録者リストCSVファイルの作成 #
	#-------------------------------#
	my $csvpath = "$myroot$data_dir$csv_dir$csv";
	unless ( open(CSV, ">$csvpath" ) ) {
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">システムエラー</font><br><br>登録者リストファイルが作成できません<br>$csv_dirディレクトリのパーミッションを確認してください");
		exit;
	}
	close(CSV);
	#-------------------------------#
	# プランの本文ファイルの作成    #
	#-------------------------------#
	my $queuepath = "$myroot$data_dir$queue_dir$queue";
	unless ( open(QUE, ">$queuepath" ) ) {
		unlink $csvpath;
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">システムエラー</font><br><br>プラン本文ファイルが作成できません<br>$queue_dirディレクトリのパーミッションを確認してください");
		exit;
	}
	close(QUE);
	#-------------------------------#
	# 送信の詳細ログファイルの作成  #
	#-------------------------------#
	my $sendlogpath = "$myroot$data_dir$log_dir$sendlog";
	unless ( open(QUE, ">$sendlogpath" ) ) {
		unlink $csvpath, $queuepath;
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">システムエラー</font><br><br>プラン本文ファイルが作成できません<br>$queue_dirディレクトリのパーミッションを確認してください");
		exit;
	}
	close(QUE);
	#--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		unlink $csvpath, $queuepath, $sendlogpath;
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	#---------------------#
	# テンポラリファイル  #
	#---------------------#
	my $tmp = $myroot . $data_dir . $log_dir . $id . '.tmp';
	unless ( open(TMP, ">$tmp" ) ) {
		unlink $csvpath, $queuepath, $sendlogpath;
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリファイルが作成できません<br>$data_dirディレクトリのパーミッションを確認してください");
		exit;
	}
	chmod 0606, $tmp;
	#---------------------#
	# データを追加        #
	#---------------------#
	my $line = qq|$id\t$date\t$pname\t$sname\t$address\t$address2\t$csv\t$queue\t$sendlog\t$header\t$cancel\t$footer\t$thankurl\t$chageurl\t$stopurl\t$co\t$_co\t$name\t$_name\t1<><>1\t$tel\t$fax\t$url\t$code\t$ken\t$ken1\t$ken2\t$ken3\t$free1\t$free2\t$free3\t$free4\t$free5\t$renew\t$crossout\t$count\t$intervals\t0\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t1\t1\n|;
	print TMP $line;
	while( <PLAN> ) {
		print TMP;
	}
	close(TMP);
	close(PLAN);
	rename $tmp, $file;
	#---------------------#
	# 排他処理排除        #
	#---------------------#
	&rename_unlock( $lockfull );
	
	$param{'id'} = $id;
	&make_plan_page( 'plan', 'all' );
	exit;
}

#------------------------------------------------------#
# 日程の更新                                           #
#------------------------------------------------------#
sub reschedule {
    
    my $id = $param{'id'} - 0;
	my $type = $param{'type'};
	my $count;
	my $interval;
	my $dnum;
	my $addnum;
	my %change;
	my $sort_date;
	my $scheduleRenew = 0;
	my %def_intervals;
	my %stopConfig;
	my $dcode;
	
	
	my $plantxt = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$plantxt" ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	my %def_intervals;
	my $def_dates;
	while( <PLAN> ) {
		chomp;
		my @line = split(/\t/);
		if ( $line[0] eq $id ) {
			my ( $def_interval, $def_dates ) = split( /<>/, $line[36] );
			my $n = 2;
			foreach( split( /,/, $def_interval ) ){
				my( $int, $config, $code ) = split( /\//);
				$def_intervals{$n} = [$int, $config, $code];
				$n++;
			}
		}
	}
	close(PLAN);
    #--------------------------------------------------------------#
	# 配信プランデータ内を更新                                     #
	#--------------------------------------------------------------#
	if ( $type ne 'date' ) {
		$count = $param{'count'} - 0;
		my $_count = $count;
		my @intervals;
		my $er = 0;
		my $max = 0;
		my $add_flag = 0;
		my $stepNum = 2; # 配信番号
		# 第2回の追加チェック
		if(  defined $param{"add0"} ){
			$max++;
			my $uniq = crypt( $max, &main'make_salt() );
			$uniq =~ s/[\.|\/|\,]//gi;
			push @intervals, "$max//$uniq";
			$_count++;
			$add_flag = 1;
			$addnum = 1;
			$scheduleRenew = 1;
			$stepNum++;
		}
		
		for ( my $i=1; $i<=$count; $i++ ) {
			
			my $c_name = 'int' . $i;
			my $stop = 'stop'. $i;
			my $def_stop = 'def_stop'. $i;
			$param{$c_name} -= 0;
			$param{$stop} -= 0;
			$param{$def_stop} -= 0;
			my $def_stepNum = $i+1;
			my $def_uniq = $def_intervals{$def_stepNum}->[2];
			
			# 追加の場合は、起算日数を追加
			if ( $add_flag && $max >= $param{$c_name}) {
				$param{$c_name}++;
			}
			# 配信日程の削除
			if ( defined $param{"del$i"} ) {
				$dnum = $i;
				$dcode = $def_uniq;
				$_count--;
				$scheduleRenew = 1;
				next;
			}
			# 「一時停止」回を取得（最新）
			$stopConfig{$stepNum} = 1 if( $param{$stop} );
			
			# 「一時停止」が更新された場合
			$scheduleRenew = 1 if( $param{$stop} != $param{$def_stop} );
			
			# 一時停止の場合は、起算日数を初期化
			if( $param{$stop} ){
				$param{$c_name} = "";
				$max = 0;
				
			}else{
				if ( !$param{$c_name} ){
					&make_plan_page( 'plan', '', "配信間隔は、1日後以上に設定してください");
				}
				if ( $max >= $param{$c_name} ){
					&make_plan_page( 'plan', '', "日程が正しく設定されておりません。<br>配信間隔設定をご確認ください。");
				}
				$max = $param{$c_name};
			}
			
			push @intervals, "$param{$c_name}/$param{$stop}/$def_uniq";
			$stepNum++;
			
			# 配信日程の追加
			if ( defined $param{"add$i"} ) {
				$max++;
				my $uniq = crypt( $max, &main'make_salt() );
				$uniq =~ s/[\.|\/|\,]//gi;
				push @intervals, "$max//$uniq";
				$_count++;
				$add_flag = 1;
				$addnum = $i + 1;
				$stepNum++;
				$scheduleRenew = 1
			}
			
		}
		$interval = join(',', @intervals);
		
		# 登録時・変更時・解除時
		my $r = ($param{'r'})? 1: 0;
		my $r2 = ($param{'r2'})? 1: 0;
		my $r3 = ($param{'r3'})? 1: 0;
		$count = "$_count,$r,$r2,$r3";
		
	} else {
		my %dates;
		my %InDate;
		foreach ( keys %param ) {
			if ( /mon(\d+)/ ) {
				my $date = $1;
				if ( defined $param{"day$date"} ) {
					if ( defined $param{"del$date"} ) {
						$dnum = "d$date";
						next;
					}
					my $mon = sprintf( "%02d", $param{"mon$date"}-0 );
					my $day = sprintf( "%02d", $param{"day$date"}-0 );
					
					# 年データは特殊（無い場合毎年）
					my $year;
					$year = sprintf( "%04d", $param{"year$date"} -0) if( $param{"year$date"} > 0 );
					if ( $InDate{"$mon$day"} ) {
						&make_plan_page( 'plan', '', "すでに同じ日付が登録させています");
					}
					$change{"d$date"} = "d$mon$day$year" if ( $date ne "$mon$day$year" );
					$dates{"$mon$day$year"} = qq|$param{"mon$date"}/$param{"day$date"}|;
					$dates{"$mon$day$year"} .= qq|/$param{"year$date"}| if($param{"year$date"} > 0) ;
					$InDate{"$mon$day"} = 1;
				}
			}
		}
		my $year = sprintf( "%04d", $param{"addyear"} );
		my $mon = sprintf( "%02d", $param{"addmon"} );
		my $day = sprintf( "%02d", $param{"addday"} );
		my $add = $mon. $day;
		$add .= $year if( $year > 0 );
		if ( $add > 0 ) {
			if ( $mon <= 0 || $day <= 0 || $param{"addyear"} eq '' ) {
				&make_plan_page( 'plan', '', "追加用の日付が正しく設定されていません");
			}
			if ( $InDate{"$mon$day"} ) {
				&make_plan_page( 'plan', '', "追加した日付は、すでに登録させています");
			}
			$dates{$add} = "$mon/$day";
			$dates{$add} .= "/$year" if( $year > 0);
		}
		my @after;
		foreach ( sort{ sprintf( "%04d", substr($a,4,4) ).substr($a,0,4) <=> sprintf( "%04d", substr($b,4,4) ).substr($b,0,4) } keys %dates ) {
			push @after, $dates{$_};
		}
		$sort_date = join(",", @after );
	}
	
    #-------------#
	# 排他処理    #
	#-------------#
    my $lockfull = &lock();
    #--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	#---------------------#
	# テンポラリファイル  #
	#---------------------#
	my $tmp_plan = $myroot . $data_dir . $log_dir . $id . '.tmp';
	unless ( open(TMP, ">$tmp_plan" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリファイルが作成できません<br>$log_dirディレクトリのパーミッションを確認してください");
		exit;
	}
	chmod 0606, $tmp_plan;
	#---------------------#
	# データを更新        #
	#---------------------#
	my ( $csv, $queue, $sendlog );
	while( <PLAN> ) {
		chomp;
		my @line = split(/\t/);
		if ( $line[0] eq $id ) {
			my ( $int, $dat ) = split( /<>/, $line[36] );
			if ( $type ne 'date' ) {
				$line[35] = $count;
				$line[36] = "$interval<>$dat";
			} else {
				$line[36] = "$int<>$sort_date";
			}
			$_ = join("\t", @line);
			$csv     = $line[6];
			$queue   = $line[7];
			$sendlog = $line[8];
		}
		print TMP "$_\n";
	}
	close(TMP);
	close(PLAN);
	
	
	#----------------#
	# 本文を更新     #
	#----------------#
	my $tmp_queue = '';
	my $queuepath = $myroot . $data_dir . $queue_dir . $queue;
	if ( $dnum ne '' || $addnum || keys %change ) {
		unless ( open(BODY, $queuepath ) ) {
		    unless (-e $queuepath ) {
			    unless (open(BODY, ">>$queuepath") ) {
					unlink $tmp_plan;
				    &rename_unlock( $lockfull );
				    &make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$data_dirのパーミッションを確認してください");
				    exit;
			    }
			} else {
				unlink $tmp_plan;
				&rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$queuepathのパーミッションを確認してください");
				exit;
			}
		}
		$tmp_queue = $myroot . $data_dir . $queue_dir . time . $$ . '.tmp';
		unless ( open(TMP, ">>$tmp_queue" ) ) {
			unlink $tmp_plan;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$queue_dirのパーミッションを確認してください");
			exit;
		}
		chmod 0606, $tmp_queue;
		while( <BODY> ) {
			chomp;
			my @lines  = split(/\t/);
			if ( $lines[0] eq $dnum ) {
				if( $lines[7] ne '' ){
					my $path = $myroot . $data_dir . $queue_dir . $lines[7];
					if( -e $path ){
						unlink $path;
					}
				}
				next;
			}
			if ( $type ne 'date' ) {
				if ( $dnum ne '' && $dnum !~ /^d(\d+)/ && $lines[0] > $dnum ) {
					$lines[0] = $lines[0] - 1;
					$_ = join( "\t", @lines );
				}
				if ( $addnum ne '' && $addnum !~ /^d(\d+)/ && $lines[0] >= $addnum ) {
					$lines[0] = $lines[0] + 1;
					$_ = join( "\t", @lines );
				}
			}
			if ( defined $change{$lines[0]} ) {
				$lines[0] = $change{$lines[0]};
				$_ = join( "\t", @lines );
			}
			print TMP "$_\n";
		}
		close(TMP);
		close(BODY);
	}
	
	#-------------------------------#
	# CSVの送信済みメール番号を修正 #
	#-------------------------------#
	my $tmp_csv = '';
	my $csvpath = $myroot . $data_dir . $csv_dir . $csv;
	if ( $type ne 'date' && $scheduleRenew ) {
		unless ( open(CSV, $csvpath ) ) {
			unless (-e $csvpath ) {
				unless (open(CSV, ">>$csvpath") ) {
					unlink $tmp_plan;
					unlink $tmp_queue;
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$data_dirのパーミッションを確認してください");
					exit;
			    }
		    } else {
				unlink $tmp_plan;
				unlink $tmp_queue;
			    &rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$csvpathのパーミッションを確認してください");
				exit;
			}
		}
		$tmp_csv = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
		unless( open(TMP, ">$tmp_csv") ){
			unlink $tmp_plan;
			unlink $tmp_queue;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$csv_dirのパーミッションを確認してください");
			exit;
		}
		chmod 0606, $tmp_csv;
		my $loop = 0;
		while( <CSV> ) {
			chomp;
			my @csvdata = split(/\t/);
			my $sendNum = ( $csvdata[20] >= 2 )? $csvdata[20]: 0; # 旧配信済み回
			
			$csvdata[20] -= 1 if ( $dnum >0 && $dnum < $csvdata[20] );
			$csvdata[20] += 1 if ( $addnum > 0 && $addnum < $csvdata[20] );
			$csvdata[51] -= 1 if ( $csvdata[51] > 0 && $dnum >0 && $dnum < $csvdata[51] );
			$csvdata[51] += 1 if ( $csvdata[51] > 0 && $addnum > 0 && $addnum < $csvdata[51] );
			$csvdata[51] = '' if( $csvdata[51] < 2 );
			
			my $nextStep = ($csvdata[20] > 1)? $csvdata[20]+1: 2; # 次回配信回
			
			$csvdata[52] = 1 if( $stopConfig{$nextStep} );
			$csvdata[52] = 0 unless( defined $stopConfig{$nextStep} );
			
			# 指定回が有る場合は、待機状態ではない
			$csvdata[52] = 0 if( $csvdata[51] ne '' );
			
			# 日程がない場合は指定日数を初期化
			$csvdata[54] = '' if( $interval eq '' );
			
			# 保存前の送信履歴を確認&保存
			# ここで各ステップの送信日を保持する（送信済みのみ）
			# 通常は配信時に保存 v2.4以前では履歴を保存しないため、ここで強制的に保存
			my @sended = split( /<>/, $csvdata[53] );
			my @result;
			foreach( @sended){
				my( $n, $data ) = split(/\//);
				if( $dnum > 0 ){
					my $deleteStepNum = $dnum+1; # ステップ番号に変換
					# 削除
					next if( $n == $deleteStepNum );
					$n -= 1 if ( $deleteStepNum <= $n );
				}elsif ( $addnum > 0 ){
					my $addStepNum = $addnum+1; # ステップ番号に変換
					$n += 1 if( $addStepNum <= $n );
				}
				push @result, qq|$n/$data|;
			}
			$csvdata[53] = join("<>", @result );
			$_ = join("\t", @csvdata);
			print TMP "$_\n";
			
			if( $loop > 2000 ){
				select(undef, undef, undef, 0.10);
				$loop = 0;
			}
			$loop++;
		}
		close(CSV);
		close(TMP);
		
	}
	
	#----------------#
	# 配信ログを修正 #
	#----------------#
	my $tmp_log = '';
	my $logpath = $myroot . $data_dir . $log_dir . $sendlog;
	if ( $dnum ne '' || $addnum || keys %change ) {
		unless ( open(LOG, $logpath ) ) {
			unless (-e $logpath ) {
				unless (open(LOG, ">>$logpath") ) {
					unlink $tmp_plan;
					unlink $tmp_queue;
					unlink $tmp_csv;
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$data_dirのパーミッションを確認してください");
					exit;
			    }
		    } else {
				unlink $tmp_plan;
				unlink $tmp_queue;
				unlink $tmp_csv;
			    &rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$logpathのパーミッションを確認してください");
				exit;
			}
		}
		$tmp_log = "$myroot$data_dir$log_dir" . $$ . time . '.tmp';
		unless( open(TMP, ">$tmp_log") ){
			unlink $tmp_plan;
			unlink $tmp_queue;
			unlink $tmp_csv;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$log_dirのパーミッションを確認してください");
			exit;
		}
		chmod 0606, $tmp_log;
		$loop = 0;
		while( <LOG> ) {
			chomp;
			my @logs = split(/\t/);
			if( $type ne 'date' ) {
				if ( $logs[4] eq $dnum ) {
					$logs[4]  = '';
				}else{
					$logs[4] -= 1  if ( $dnum > 0 && $dnum < $logs[4] );
					$logs[4] += 1  if ( $addnum > 0 && $addnum <= $logs[4] );
				}
			}else{
				if ( defined $change{$logs[4]} ){
					$logs[4] = $change{$logs[4]};
				}
				$logs[4] = '' if ( $dnum eq $logs[4] );
			}
			$_ = join("\t", @logs);
			print TMP "$_\n";
			
			if( $loop > 2000 ){
				select(undef, undef, undef, 0.10);
				$loop = 0;
			}
			$loop++;
		}
		close(LOG);
		close(TMP);
		
	}
	
	#--------------#
	# データ保存反映
	#--------------#
	
	# プランデータ
	rename $tmp_plan, $file;
	# 本文データ
	rename $tmp_queue, $queuepath if( $tmp_queue ne '' );
	# 登録者データ
	rename $tmp_csv, $csvpath if( $tmp_csv ne '' );
	# 配信ログデータ
	rename $tmp_log, $logpath if( $tmp_log ne '' );
	# アクセス分析
	&Click'default( $dcode, 1 ) if( $type ne 'date' );
	
	#--------------#
	# 排他処理解除 #
	#--------------#
    &rename_unlock( $lockfull );
    &make_plan_page( 'plan', 'schedule' );
    exit;
}

# 各プランのステップにユニークコードを設定する(v2.4から必要)
sub schedule_disorder
{
	my $plantxt = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$plantxt" ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	my %def_intervals;
	my $def_dates;
	while( <PLAN> ) {
		chomp;
		my @line = split(/\t/);
		if ( $line[0] eq $id ) {
			my ( $def_interval, $def_dates ) = split( /<>/, $line[36] );
			my $n = 2;
			foreach( split( /,/, $def_interval ) ){
				my( $int, $config, $code ) = split( /\//);
				$def_intervals{$n} = [$int, $config, $code];
				$n++;
			}
		}
	}
	close(PLAN);
	
	unless ( open(CSV, $csvpath ) ) {
		$tmp_csv = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
		unless( open(TMP, ">$tmp_csv") ){
			unlink $tmp_plan;
			unlink $tmp_queue;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$csv_dirのパーミッションを確認してください");
			exit;
		}
		chmod 0606, $tmp_csv;
		my $loop = 0;
		while( <CSV> ) {
			chomp;
			my @csvdata = split(/\t/);
			my $sendNum = ( $csvdata[20] >= 2 )? $csvdata[20]: 0; # 旧配信済み回
			
			
			# 保存前の送信履歴を確認&保存
			# ここで各ステップの送信日を保持する（送信済みのみ）
			# 通常は配信時に保存 v2.4以前では履歴を保存しないため、ここで強制的に保存
			my %sendLog;
			foreach( sort{ $a <=> $b } keys %def_intervals ){
				my $int = $def_intervals{$_}->[0];
				next if( $sendLog{$_} > 0 ); # すでに保持している場合
				next if( $sendNum < $_ );    # 配信済み回より後の場合はスキップ
				$sendLog{$_} = $csvdata[19] + ($int*60*60*24);
			}
			my @result;
			foreach( sort{ $a <=> $b } keys %sendLog ){
				push @result, qq|$_/$sendLog{$_}|;
			}
			$csvdata[53] = join("<>", @result );
			$_ = join("\t", @csvdata);
			print TMP "$_\n";
			
			if( $loop > 2000 ){
				select(undef, undef, undef, 0.10);
				$loop = 0;
			}
			$loop++;
		}
		close(CSV);
		close(TMP);
		
		rename $tmp_csv, $cav_path;
	}
}

#------------------------------------------------------#
# 本文の更新                                           #
#------------------------------------------------------#
sub body {
	my $id = &delspace( $param{'id'} -0 );
	my $n = &delspace( $param{'n'} );
    $n -= 0 if ( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );
	my $t_title = &delspace( $param{'btitle'} );
	$param{'body'} =~ s/(\s\s)$//;
	my $body = &the_text( $param{'body'} );
	
	my $h = ( $param{'header'} )? 1: 0;
	my $c = ( $param{'cancel'} )? 1: 0;
	my $f = ( $param{'footer'} )? 1: 0;
	
	# HTML形式
	my $ctype = ( $param{'content-type'}-0 )? 1: 0;
	my $line = qq|$n\t$t_title\t$h\t$c\t$body\t$f\t$ctype|;
	my $lockfull = &lock();
	#--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	my $queue;
	while( <PLAN> ) {
		my ( $index, $file ) = ( split(/\t/) )[0, 7];
		if ( $index eq $id ) {
			$queue = $myroot . $data_dir . $queue_dir . $file;
			last;
		}
	}
	close(PLAN);
	&make_plan_page( 'plan', '', 'エラー<br>該当するプランがありません') if (!$queue);
	unless ( open(BODY, $queue ) ) {
		unless (-e $queue ) {
			unless (open(BODY, ">>$queue") ) {
				&rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$queue_dirのパーミッションを確認してください");
				exit;
			}
		} else {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$queueのパーミッションを確認してください");
			exit;
		}
	}
	my $tmp = $myroot . $data_dir . $queue_dir . time . $$ . '.tmp';
	unless ( open(TMP, ">>$tmp" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$queue_dirのパーミッションを確認してください");
		exit;
	}
	chmod 0606, $tmp;
	my $flag = 0;
	while( <BODY> ) {
		chomp;
		my ( $index, $filename ) = ( split(/\t/) )[0, 7];
		if ( $index eq $n ) {
			$flag = 1;
			$_ = "$line\t$filename";
		}
		print TMP "$_\n";
	}
	print TMP "$line\n" if ( !$flag );
	close(TMP);
	close(BODY);
	rename $tmp, $queue;
	&rename_unlock( $lockfull );
	
	if( $n eq 'ra' ){
		$main'param{'action'} = $mode;
		&renew();
	}
	
	&make_plan_page('plan', 'preview');
	exit;
}

sub body_html {
	
	my $id = &delspace( $param{'id'} -0 );
	my $n = &delspace( $param{'n'} );
    $n -= 0 if ( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );
	
	my $filename = &the_filedata( 'html' );
	
	if( $filename !~ /.htm(l)*$/ && !defined $param{'del'} ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">入力エラー</font><br><br>HTMLファイルを指定してください。");
		exit;
	}
	
	my $lockfull = &lock();
	
	#--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	my( $queuedir, $queue, $filepath );
	while( <PLAN> ) {
		my ( $index, $file ) = ( split(/\t/) )[0, 7];
		if ( $index eq $id ) {
			$queuedir = $myroot . $data_dir . $queue_dir;
			$queue    = $queuedir . $file;
			$filepath = $queuedir . $filename;
			last;
		}
	}
	close(PLAN);
	
	if (!$queue){
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', 'エラー<br>該当するプランがありません');
		exit;
	}
	
	unless ( open(BODY, $queue ) ) {
		unless (-e $queue ) {
			unless (open(BODY, ">>$queue") ) {
				&rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$queue_dirのパーミッションを確認してください");
				exit;
			}
		} else {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$queueのパーミッションを確認してください");
			exit;
		}
	}
	my $tmp = $myroot . $data_dir . $queue_dir . time . $$ . '.tmp';
	unless ( open(TMP, ">>$tmp" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが作成できません<br>$queue_dirのパーミッションを確認してください");
		exit;
	}
	chmod 0606, $tmp;
	my $flag = 0;
	my $def_filename;
	while( <BODY> ) {
		chomp;
		my @_lines = split(/\t/);
		if ( $_lines[0] eq $n ) {
			$flag = 1;
			$def_filename = $_lines[7];
			my $path = $queuedir . $_lines[7];
			unlink $path;
			if( defined $param{'del'} ){
				$_lines[7] = '';
			}else{
				if( $filename ne $def_filename && -e $filepath ){
					close(TMP);
					unlink $tmp;
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>同名ファイルがアップロードされています。", '', 'html' );
					exit;
				}
				$_lines[7] = $filename;
			}
			$_ = join( "\t", @_lines );
		}
		print TMP "$_\n";
	}
	if( !$flag ){
		print TMP qq|$n\t$t_title\t$h\t$c\t$body\t$f\t$ctype\t$filename\n|;
	}
	
	close(TMP);
	close(BODY);
	rename $tmp, $queue;
	
	#--------------------------#
	# HTMLファイルを保存       #
	#--------------------------#
	unless( defined $param{'del'} ){
		unless( open(HTML, ">$filepath") ){
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">入力エラー</font><br><br>HTMLファイルが作成できません。<br>$image_dir のパーミッションが[ 707 ]であるか確認してください。");
			exit;
		}
		local $_HTML = $param{'html'};
		&jcode::convert( \$_HTML, 'jis' );
		print HTML $_HTML;
		close(HTML);
		chmod 0606, $filepath;
	}
	
	
	&rename_unlock( $lockfull );
	&make_plan_page('plan', 'html');
	exit;
}


#------------------------------------------------------#
# 本文の送信テスト用パラメータの取得                   #
#------------------------------------------------------#
sub sendtest {
    my $id = $param{'id'} - 0;
    my $n = $param{'n'};
    $n -= 0 if( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );
    
	# 送信済み短縮URLを取得
	my $forward = &Click'getForward_url();
	
	#--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	local ( $queuedir, $queue, $name, $from, $to, $header, $cancel, $footer, $tag_data, $step, $ssl );
	while( <PLAN> ) {
        chomp;
		my ( $index, $_name, $_from, $_to, $file, $_header, $_cancel, $_footer, $_step, $_tag_data, $ssl ) = ( split(/\t/) )[0, 3, 4, 5, 7, 9, 10, 11, 36, 82, 83];
		if ( $index eq $id ) {
			$queuedir = $myroot . $data_dir . $queue_dir;
			$queue  = $queuedir . $file;
			$name   = $_name;
			$from   = $_from;
			$to     = ( split(/,/, $_to) )[0];
			$header = $_header;
			$cancel = $_cancel;
			$footer = $_footer;
			$tag_data = $_tag_data;
			$step = $_step;
			&Pub'ssl($ssl);
			last;
		}
	}
	close(PLAN);
    if (!$queue){
	    &make_plan_page( 'plan', '', 'エラー<br>該当するプランがありません');
        exit;
    }
	#---------------------------#
	# 転送用タグ取得            #
	#---------------------------#
	my( $urlTag, $other ) = &Click'roadTag( $tag_data );
	
	my( $schedule, $dates ) = split( /<>/, $step );
	my $c=1;
	my %SIDS;
	$UIDS{'0'} = $id. '-0';
	foreach( split(/,/, $schedule ) ){
		my( $int, $config, $sid ) = split(/\//);
		$UIDS{$c} = $sid;
		$c++;
	}
	my $unic = $UIDS{$n};
	
    #--------------------------#
	# 既存の本文データを取得   #
	#--------------------------#
	unless ( open(BODY, $queue ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$queueのパーミッションを確認してください");
		exit;
	}
    my $body;
	while( <BODY> ) {
		chomp;
		my ( $index ) = ( split(/\t/) )[0];
		if ( $index eq $n ) {
			$body = $_;
            last;
		}
	}
    close(BODY);
    if (!$body) {
	    &make_plan_page( 'plan', '', 'エラー<br>該当する本文がありません');
        exit;
    }
    #--------------------------#
	# 送信テストメールの作成   #
	#--------------------------#
	$header =~ s/<br>/\n/gi;
	$cancel =~ s/<br>/\n/gi;
	$footer =~ s/<br>/\n/gi;
	my @bodys = split(/\t/, $body);
	
	local $subject = $bodys[1];
	$subject = &include( \@temdata_base, $subject, '', 1 );
	local $message;
	local $CONTENT_TYPE;
	
	my $forward_urls;
	# テキスト形式
	if( $bodys[6] <= 0 ){
		local $mes = $bodys[4];
		$mes =~ s/<br>/\n/gi;
		$message .= "$header\n" if ( $bodys[2] );
		$message .= "$mes\n";
		$message .= "$cancel\n" if ( $bodys[3] );
		$message .= "$footer" if ( $bodys[5] );
		
		# 転送タグ変換
		($message, $forward_urls) = &Click'analyTag('', $message, $urlTag, $unic, $forward) if( $n =~ /^\d+$/ );
		$message = &include( \@temdata_base, $message, '', 1 );
	}
	# HTML形式
	else{
		$CONTENT_TYPE = 'text/html';
		my $htmlpath = $queuedir . $bodys[7];
		unless( open( HTML, $htmlpath ) ){
			&make_plan_page( 'plan', '', 'エラー<br>該当するHTMLファイルがありません。');
        exit;
		}
		while(<HTML>){
			$message .= $_;
		}
		close(HTML);
		# 転送タグ変換
		($message, $forward_urls) = &Click'analyTag('', $message, $urlTag, $unic, $forward) if( $n =~ /^\d+$/ );
		$message = &include( \@temdata_base, $message, 1, 1 );
	}
	
	
	if ( &send( $from, $name, $to, $subject, $message ) ){
		&make_plan_page( 'plan', '', 'メールが送信できません' );
	}
	# アクセス集計用データ生成
	&Click'setForward_t( $forward_urls, $unic, '', 1 );
	&make_plan_page('plan', 'all');
	exit;
}

#------------------------------------------------------#
# 管理者によるユーザー登録                             #
#------------------------------------------------------#
sub ____reguest {
    my $id = $param{'id'} - 0;
    my $date = time;
    my $lockfull = &lock();
    #--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
    my @line;
    my $csvpath;
    my $queuepath;
    my $logpath;
    while( <PLAN> ) {
		chomp;
		@line = split(/\t/);
		if ( $line[0] eq $id ) {
			$csvpath = "$myroot$data_dir$csv_dir$line[6]";
			$queuepath = "$myroot$data_dir$queue_dir$line[7]";
			$logpath = "$myroot$data_dir$log_dir$line[8]";
			last;
		}
	}
	close(PLAN);
	#--------------------------------#
	# 既存の登録者データからIDを取得 #
	#--------------------------------#
	my $index;
	unless ( $csvpath ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">システムエラー</font><br><br>該当するデータがありません");
		exit;
	}
	unless ( open(CSV, "$csvpath" ) ) {
		if ( -e $csvpath ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$csvpathのパーミッションを確認してください");
			exit;
		}
		unless ( open(CSV, ">>$csvpath") ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">システムエラー</font><br><br>ユーザー登録ができません<br>$data_dirのパーミッションを確認してください");
			exit;
		}
		$index = 0;
	}else {
        while( <CSV> ) {
            chomp;
            my ( $id, $mail ) = ( split(/\t/) )[0, 5];
            if ( $param{'mail'} eq $mail ) {
                &rename_unlock( $lockfull );
                &make_plan_page( 'plan', 'g', '同一のメールアドレスが登録されています');
                exit;
            }
            $index = $id;
        }
    }
    close(CSV);
    $index++;
    my @names = (
			{'name' => 'co', 'value' => '会社名'},
			{'name' => '_co', 'value' => '会社名フリガナ'},
			{'name' => 'name', 'value' => 'お名前'},
			{'name' => '_name', 'value' => 'お名前フリガナ'},
			{'name' => 'mail', 'value' => 'メールアドレス'},
			{'name' => 'tel', 'value' => '電話番号'},
			{'name' => 'fax', 'value' => 'FAX番号'},
			{'name' => 'url', 'value' => 'URL'},
			{'name' => 'code', 'value' => '郵便番号'},
			{'name' => 'address', 'value' => '都道府県'},
			{'name' => 'address1', 'value' => '住所１'},
			{'name' => 'address2', 'value' => '住所２'},
			{'name' => 'address3', 'value' => '住所３'},
			{'name' => 'free1', 'value' => 'フリー項目１'},
			{'name' => 'free2', 'value' => 'フリー項目２'},
			{'name' => 'free3', 'value' => 'フリー項目３'},
			{'name' => 'free4', 'value' => 'フリー項目４'},
			{'name' => 'free5', 'value' => 'フリー項目５'},
			{'name' => 'free6', 'value' => 'フリー項目６'},
			{'name' => 'free7', 'value' => 'フリー項目７'},
			{'name' => 'free8', 'value' => 'フリー項目８'},
			{'name' => 'free9', 'value' => 'フリー項目９'},
			{'name' => 'free10', 'value' => 'フリー項目１０'},
			{'name' => 'free11', 'value' => 'フリー項目１１'},
			{'name' => 'free12', 'value' => 'フリー項目１２'},
			{'name' => 'free13', 'value' => 'フリー項目１３'},
			{'name' => 'free14', 'value' => 'フリー項目１４'},
			{'name' => 'free15', 'value' => 'フリー項目１５'},
			{'name' => 'free16', 'value' => 'フリー項目１６'},
			{'name' => 'free17', 'value' => 'フリー項目１７'},
			{'name' => 'free18', 'value' => 'フリー項目１８'},
			{'name' => 'free19', 'value' => 'フリー項目１９'},
			{'name' => 'free20', 'value' => 'フリー項目２０'},
		);
    #--------------------#
    # 入力値の取得と検査 #
    #--------------------#
    my @par;
    my $n = 15;
    for ( my $i=0; $i<@names; $i++ ) {
        my $indata;
        if ( (split(/<>/,$line[$n]))[0] ) {
			my $r_name = $names[$i]->{'name'};
			my $r_val = $names[$i]->{'value'};
            $indata = $param{$r_name};
            if ( (split(/<>/,$line[$n]))[2] || $names[$i]->{'name'} eq 'mail') {
            	if ( $names[$i]->{'name'} eq 'mail' ) {
                	if( &chk_email($indata) ) {
                    	&rename_unlock( $lockfull );
                    	&make_plan_page( 'plan', '', '入力エラー<br>メールアドレスの形式が正しくありません');
                    	exit;
					}
            	} else {
                	if ( $indata eq '' ) {
						my $mes = ( (split(/<>/,$line[$n]))[1] )? &deltag( (split(/<>/,$line[$n]))[1] ): $r_val;
                    	&rename_unlock( $lockfull );
                    	&make_plan_page( 'plan', '', "入力エラー<br>[ $mes ] に入力してください");
                    	exit;
                	}
            	}
			}
        }
        push @par, $indata;
		if( $n == 32 ){
			$n = 43;
		}else{
			$n++;
		}
        $indata='';
    }
    # 受付拒否
    if ( $line[38] ) {
        foreach ( (split(/,/, $line[38])) ) {
            if ( index($par[4], $_) >= 0 ) {
                &rename_unlock( $fullpath );
                &make_plan_page( 'plan', 'g', '登録できません');
                exit;
            }
        }
    }
    $index = sprintf( "%05d", $index );
    my $sk = ( split(/,/, $line[35]) )[1];
    my $res = $param{'res'};
    my $check = ( $sk || $res )? '': 0;
    unshift @par, $index;
    splice( @par, 19, 0, $date );  # 登録日（秒）
    splice( @par, 20, 0, $check ); # 最終配信回数
    splice( @par, 21, 0, $date );  # 最終配信日（秒）
    my $line =  join("\t", @par) . "\n";
    my $senderror;
    if ( !$sk && !$res ) {
        # 登録メールの送信
        my $rh_body = &get_body( $queuepath );
        $line[9] =~ s/<br>/\n/gi;
        $line[10] =~ s/<br>/\n/gi;
        $line[11] =~ s/<br>/\n/gi;
        local ( $subject, $message ) = &make_send_body( 0, $rh_body, $line[9], $line[10], $line[11] );
        $subject = &include( \@par, $subject );
		$message = &include( \@par, $message );
        if ( !$sk && !$res ) {
			$senderror = &send( $line[4], $line[3], $par[5], $subject, $message );
			# 配信ログに追加
        	unless ( $senderror ) {
            	open(LOG, ">>$logpath");
            	print LOG "$par[0]\t$par[5]\t$par[3]\t$date\t0\t$subject\n";
            	close(LOG);
        	}else{
				&make_plan_page( 'plan', '', '登録できません');
        	}
		}
        # 管理者宛へ送信
		#if ( $line[40] ) {
		#	$senderror = &send( $line[4], $line[3], $line[5], $subject, $message );
		#}
    }
    #-------#
    # 追加  #
    #-------#
    open(CSV, ">>$csvpath");
    print CSV $line;
    close(CSV);
    &rename_unlock( $lockfull );
    # リダイレクト
    &make_plan_page( 'plan', 'guest' );
    exit;
}
#------------------------------------------------------#
# 管理者によるユーザーの変更、解除                     #
#------------------------------------------------------#
sub ____renewguest {
    my $id = $param{'id'} - 0;
    my $mail = $param{'mail'};
    my $nmail = $param{'nmail'};
    if ( &chk_email($mail) || ($mode eq 'renew' && &chk_email($nmail)) ) {
        &rename_unlock( $lockfull );
        &make_plan_page( 'plan', 'g', 'メールアドレスの形式が正しくありません');
        exit;
    }
    my $number;
    my $fnum;
    my $mes;
    my $target;
    my $turl;
    if ($mode eq 'renew') {
        $number = 33;
        $fnum = 2;
        $target = 'r';
        $turl = 13;
        $mes = 'メールアドレスを変更しました';
    }elsif ($mode eq 'cancel') {
        $number = 34;
        $fnum = 3;
        $target = 'c';
        $turl = 14;
        $mes = '登録を解除しました';
    }
    my $lockfull = &lock();
    #--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
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
            last;
        }
    }
    close(PLAN);
    #--------------------------------#
	# 既存の登録者データからIDを取得 #
	#--------------------------------#
    my $index;
    unless ( $csvpath ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">システムエラー</font><br><br>該当するデータがありません");
		exit;
	}
    unless ( open(CSV, "$csvpath") ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">システムエラー</font><br><br>$csvpathが開けません");
		exit;
	}
    my $tmp = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
    unless ( open(TMP, ">$tmp") ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが開けません<br>$data_dirのパーミッションを確認してください");
		exit;
	}
	chmod 0606, $tmp;
    my $flag = 0;
    my @csvs;
    while( <CSV> ) {
        chomp;
        my @csv = split(/\t/);
        if ( $mail eq $csv[5] ) {
            $flag = 1;
            if ( $formck & $csv[0] ne $userid ) {
                unlink $tmp;
                &rename_unlock( $lockfull );
                &make_plan_page( 'plan', 'g', "IDが一致しません");
                last;
            }
            if ( $mode eq 'renew' ) {
                $csv[5] = $nmail;
                $_ = join("\t", @csv);
                @csvs = @csv;
            } else {
                @csvs = @csv;
                next;
            }
        }
        print TMP "$_\n";
    }
    if ( !$flag ) {
        unlink $tmp;
        &rename_unlock( $lockfull );
        &make_plan_page( 'plan', 'g', "メールアドレスが一致しません");
    }
    close(TMP);
    close(CSV);
    my $res = $param{'res'};
    my $senderror;
    if ( !$sendck && !$res ) {
        # 変更、解除メールの送信
        my $rh_body = &get_body( $queuepath );
        $line[9] =~ s/<br>/\n/gi;
        $line[10] =~ s/<br>/\n/gi;
        $line[11] =~ s/<br>/\n/gi;
        local ( $subject, $message ) = &make_send_body( $target, $rh_body, $line[9], $line[10], $line[11] );
        $subject = &include( \@csvs, $subject );
		$message = &include( \@csvs, $message );
        $senderror = &send( $line[4], $line[3], $csvs[5], $subject, $message );
        # 配信ログに追加
        my $now = time;
        unless ( $senderror ) {
            open(LOG, ">>$logpath");
            print LOG "$csvs[0]\t$csvs[5]\t$cavs[3]\t$now\t$target\t$subject\n";
            close(LOG);
        }else{
            &rename_unlock( $lockfull );
            unlink $tmp;
            &make_plan_page( 'plan', 'g', "$mes");
        }
    }
    rename $tmp, $csvpath;
    &rename_unlock( $lockfull );
    # リダイレクト
    &make_plan_page( 'plan', 'guest' );
    exit;
}

#--------------------------#
# 登録者データを取得       #
#--------------------------#
sub get_csvdata {
    my ( $id, $userid ) = @_;
    #--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
    my $csvpath;
    while( <PLAN> ) {
        chomp;
        my ( $index, $csv ) = ( split(/\t/) )[0, 6];
        if ( $index eq $id ) {
            $csvpath = "$myroot$data_dir$csv_dir$csv";
            last;
        }
    }
    close(PLAN);
    #--------------------------------#
	# 既存の登録者データからIDを取得 #
	#--------------------------------#
    my $index;
    unless ( open(CSV, "$csvpath") ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>$csvpathが開けません");
		exit;
	}
    if ( $userid eq '' ) {
        return <CSV>;
    }
    while( <CSV> ) {
        chomp;
        my @csvs = split(/\t/);
        if ( $csvs[0] eq $userid ) {
            return @csvs;
            last;
        }
    }
    close(CSV);
	&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>該当するデータがありません");
	exit;
}

#----------------------------#
# 登録者情報ページからの更新 #
#----------------------------#
sub guest {
	
    my $id = $param{'id'} - 0;
	
	#---------------------#
	# 排他処理            #
	#---------------------#
	my $lockfull = &lock();
	
    #--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	my @line;
	my $csvpath;
	my $queuepath;
	my $logpath;
	my $count;
	my %ra_conf;
	while( <PLAN> ) {
		chomp;
		@line = split(/\t/);
		if ( $line[0] eq $id ) {
			$csvpath   = "$myroot$data_dir$csv_dir$line[6]";
			$queuepath = "$myroot$data_dir$queue_dir$line[7]";
			$logpath   = "$myroot$data_dir$log_dir$line[8]";
			$count = (split( /,/, $line[35]) )[0];
			$dck       = $line[42];
			&Pub'ssl($line[83]);
			last;
		}
	}
	close(PLAN);
	
    my $userid = &deltag( $param{'n'} );
	my $def_mail = &deltag( $param{'def_mail'} );
    my $co     = &deltag( $param{'co'} );
    my $_co    = &deltag( $param{'_co'} );
    my $name   = &deltag( $param{'name'} );
    my $_name  = &deltag( $param{'_name'} );
    my $mail   = $param{'mail'};
	
	# 配信情報更新
	my $reStep = 0;
	my $step = $param{'step'};
	my $stop = $param{'stop'};
	my $interval = $param{'interval'};
	my $restart;
	my $sendStepNum;
	my $baseStepNum;
	
	if( defined $param{"stepInfo"} ){
		$reStep = 1;
	}else{
		if ( !defined $param{'de'} && &chk_email($mail) ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "メールアドレスの形式が正しくありません");
			exit;
		}
		if ( !defined $param{'de'} && $mail eq '' ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "メールアドレスを入力してください");
			exit;
		}
	}
	
	# 追加と配信情報更新の場合
	my $stopFlag = 0;
	if( !defined $param{'re'} && !defined $param{'de'} ){
		if( $step ne 'end' ){
			my( $inter, $config ) = split( /\//, ( split( /,/, (split(/<>/,$line[36]))[0] ) )[$step-2] );
			if( $config ){
				$stopFlag = 1;
				if( !$reStep && $interval <= 0 ){
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "配信開始日を指定してください。");
					exit;
				}
			}else{
				$interval = '';
			}
		}
	}
	
    my $tel      = &deltag( $param{'tel'} );
    my $fax      = &deltag( $param{'fax'} );
    my $url      = &deltag( $param{'url'} );
    my $code     = &deltag( $param{'code'} );
    my $address  = &deltag( $param{'address'} );
    my $address1 = &deltag( $param{'address1'} );
    my $address2 = &deltag( $param{'address2'} );
    my $address3 = &deltag( $param{'address3'} );
    my $free1    = &deltag( $param{'free1'} );
    my $free2    = &deltag( $param{'free2'} );
    my $free3    = &deltag( $param{'free3'} );
    my $free4    = &deltag( $param{'free4'} );
    my $free5    = &deltag( $param{'free5'} );
	my $free6    = &deltag( $param{'free6'} );
    my $free7    = &deltag( $param{'free7'} );
    my $free8    = &deltag( $param{'free8'} );
    my $free9    = &deltag( $param{'free9'} );
    my $free10   = &deltag( $param{'free10'} );
	my $free11   = &deltag( $param{'free11'} );
    my $free12   = &deltag( $param{'free12'} );
    my $free13   = &deltag( $param{'free13'} );
    my $free14   = &deltag( $param{'free14'} );
    my $free15   = &deltag( $param{'free15'} );
	my $free16   = &deltag( $param{'free16'} );
    my $free17   = &deltag( $param{'free17'} );
    my $free18   = &deltag( $param{'free18'} );
    my $free19   = &deltag( $param{'free19'} );
    my $free20   = &deltag( $param{'free20'} );
	my $free21   = &deltag( $param{'free21'} );
    my $free22   = &deltag( $param{'free22'} );
    my $free23   = &deltag( $param{'free23'} );
    my $free24   = &deltag( $param{'free24'} );
    my $free25   = &deltag( $param{'free25'} );
	my $free26   = &deltag( $param{'free26'} );
    my $free27   = &deltag( $param{'free27'} );
    my $free28   = &deltag( $param{'free28'} );
    my $free29   = &deltag( $param{'free29'} );
    my $free30   = &deltag( $param{'free30'} );
	
	my $sei      = &deltag( $param{'sei'} );
	my $_sei     = &deltag( $param{'_sei'} );
	my $mei      = &deltag( $param{'mei'} );
	my $_mei     = &deltag( $param{'_mei'} );
	
	# 姓名項目とお名前項目の連動
	if( $sei ne '' || $mei ne '' ){
		$name = $sei . $mei;
	}
	if( $_sei ne '' || $_mei ne '' ){
		$_name = $_sei . $_mei;
	}
	
    my $date = time;
	
	#--------------------------------#
	# 既存の登録者データからIDを取得 #
	#--------------------------------#
	my $index;
	unless ( open(CSV, "$csvpath") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>$csvpathが開けません");
		exit;
	}
	my $tmp = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
	unless ( open(TMP, ">$tmp") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが開けません<br>$csv_dirのパーミッションを確認してください");
		exit;
	}
	chmod 0606, $tmp;
	my @csvs;
	my %Email;
	my $M_index = 0;
	while( <CSV> ) {
		chomp;
		$M_index++;
		@csv = split(/\t/);
		my $tar_mail;
		if ( $csv[0] eq $userid && $def_mail eq $csv[5] ) {
			# 配信情報更新
			if( $reStep ){
				my $nextStep = ( $csv[20] > 1 )? $csv[20]+1: 2;
				
				if( $csv[51] ne '' ){
					# 指定回の場合
					if( $csv[51] ne $step ){
						if( $stopFlag && $interval <= 0 ){
							close(TMP);
							unlink $tmp;
							&rename_unlock( $lockfull );
							&make_plan_page( 'plan', '', "配信開始日を指定してください。");
							exit;
						}
						$csv[52] = '';
						my $now = time;
						$csv[54] = ( $step eq 'end' || !$stopFlag )? '': qq|$interval/$now|;
						
						my $bsseStepNum = &getBaseNum( $line[36],$step );
						my $cur_bsseStepNum = &getBaseNum( $line[36],$csv[20] );
						if( $bsseStepNum != $cur_bsseStepNum ){
							my %sendLog;
							foreach( split( /<>/, $csv[53]) ){
								my( $n, $date ) = split(/\//);
								$sendLog{$n} = $date;
							}
							$sendLog{$bsseStepNum} = time;
							my @result;
							foreach( sort{ $a <=> $b } keys %sendLog ){
								push @result, qq|$_/$sendLog{$_}|;
							}
							$csv[53] = join( "<>", @result );
						}
					}
				}else{
					# 通常のステップの場合
					if( $nextStep ne $step ){
						if( $stopFlag && $interval <= 0 ){
							close(TMP);
							unlink $tmp;
							&rename_unlock( $lockfull );
							&make_plan_page( 'plan', '', "配信開始日を指定してください。");
							exit;
						}
						$csv[52] = '';
						my $now = time;
						$csv[54] = ( $step eq 'end' || !$stopFlag )? '': qq|$interval/$now|;
						
						my $bsseStepNum = &getBaseNum( $line[36],$step );
						my $cur_bsseStepNum = &getBaseNum( $line[36],$csv[20] );
						if( $bsseStepNum != $cur_bsseStepNum ){
							my %sendLog;
							foreach( split( /<>/, $csv[53]) ){
								my( $n, $date ) = split(/\//);
								$sendLog{$n} = $date;
							}
							$sendLog{$bsseStepNum} = time;
							my @result;
							foreach( sort{ $a <=> $b } keys %sendLog ){
								push @result, qq|$_/$sendLog{$_}|;
							}
							$csv[53] = join( "<>", @result );
						}
						
						
					}else{
						# 配信再開の場合
						if( $csv[52] && !$stop ){
							$restart = 1;
							$sendStepNum = ( $csv[20] > 1 )? $csv[20]+1: 2;
							$csv[54] = '';
						}
					}
				}
				$csv[51] = $step if( $step eq 'end' || $nextStep < $step );
				# 配信済みの次回を指定されてた場合、通常に戻る
				$csv[51] = ''if( $nextStep == $step );
				@csvs = @csv;
				$_ = join( "\t", @csv );
			}
			# 登録者情報更新
			elsif ( defined $param{'re'} ) {
				my $_address = ( $address eq '' )? $csv[10]: $address;
				$_  = "$csv[0]\t$co\t$_co\t$name\t$_name\t$mail\t$tel\t$fax\t$url\t$code\t$_address\t$address1\t$address2\t$address3\t";
				$_ .= "$free1\t$free2\t$free3\t$free4\t$free5\t$csv[19]\t$csv[20]\t$csv[21]\t$free6\t$free7\t$free8\t$free9\t$free10\t";
				$_ .= "$free11\t$free12\t$free13\t$free14\t$free15\t$free16\t$free17\t$free18\t$free19\t$free20\t";
				$_ .= "$sei\t$_sei\t$mei\t$_mei\t";
				$_ .= "$free21\t$free22\t$free23\t$free24\t$free25\t$free26\t$free27\t$free28\t$free29\t$free30\t";
				$_ .= "$csv[51]\t$csv[52]\t$csv[53]\t$csv[54]";
				@csvs = split(/\t/,$_);
				$tar_mail = $mail;
			}
			# 登録削除
			elsif ( defined $param{'de'} ) {
				@csvs = split(/\t/,$_);
				next;
			}
		}else{
			$tar_mail = $csv[5];
		}
		$index = $csv[0] if( $index < $csv[0] );
		print TMP "$_\n";
		
		if( !$dck && $Email{$tar_mail}>0 && !defined $param{'de'}  && !$reStep ) {
			close(TMP);
			unlink $tmp;
			&rename_unlock( $fullpath );
			&make_plan_page( 'plan', '', qq|<font color="#CC0000">入力エラー</font><br><br>メールアドレスが重複しています。<br>重複したメールアドレス <strong><font color="#0000EE">$tar_mail</font> [ Line: $Email{$tar_mail} $M_index ]</strong><br><br>【登録設定】登録メールアドレスの重複を許可に設定するか、<br>重複するデータを削除してください。|);
			exit;
		}
		$Email{$tar_mail} = $M_index;
	}
	$index++;
	my $target;
	my $res = $param{'res'};
	my @sends = split(/,/, $line[35]);
	my $sendck;
	if ( defined $param{'re'} ) {
		$target = 'r';
		$sendck = $sends[2];
	}elsif ( defined $param{'de'} ) {
		$target = 'c';
		$sendck = $sends[3];
	}elsif( !$reStep ) {
		
		if( !$dck && $Email{$mail}>0 ) {
			close(TMP);
			unlink $tmp;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', qq|<font color="#CC0000">入力エラー</font><br><br>メールアドレスが重複しています。[ <strong>Line: $Email{$mail}</strong> ]<br><br>【登録設定】登録メールアドレスの重複を許可に設定してください。|);
			exit;
		}
		$sendck = $sends[1];
		$target = 0;
		$snumber = ( !$res && !$sendck )? 0: '';
		$index = sprintf( "%05d", $index );
		# 配信情報
		$step = '' if( $step == 2 || $count <= 0 );
		my $sendlog;
		if( $step ne '' ){
			my $baseNum = &getBaseNum( $line[36], $step );
			if( $baseNum > 1 ){
				my $now = time;
				$sendlog = qq|$baseNum/$now|;
			}
		}
		
		my $newline = qq|$index\t$co\t$_co\t$name\t$_name\t$mail\t$tel\t$fax\t$url\t$code\t$address\t$address1\t$address2\t$address3\t|;
		$newline .= qq|$free1\t$free2\t$free3\t$free4\t$free5\t|;
		$newline .= qq|$date\t$snumber\t$date\t|;
		$newline .= qq|$free6\t$free7\t$free8\t$free9\t$free10\t|;
		$newline .= qq|$free11\t$free12\t$free13\t$free14\t$free15\t$free16\t$free17\t$free18\t$free19\t$free20\t|;
		$newline .= qq|$sei\t$_sei\t$mei\t$_mei\t|;
		$newline .= qq|$free21\t$free22\t$free23\t$free24\t$free25\t$free26\t$free27\t$free28\t$free29\t$free30\t|;
		$newline .= qq|$step\t\t$sendlog\t$interval|;
		print TMP "$newline\n";
		@csvs = split(/\t/, $newline);
		
	}
	close(CSV);
	close(TMP);
	# 簡易タグ挿入用に修正
	#splice( @csvs, 19, 3 );
	if ( !$res && !$sendck) {
		# 変更、解除メールの送信
		my $rh_body = &get_body( $queuepath );
		$line[9] =~ s/<br>/\n/gi;
		$line[10] =~ s/<br>/\n/gi;
		$line[11] =~ s/<br>/\n/gi;
		local ( $subject, $message ) = &make_send_body( $target, $rh_body, $line[9], $line[10], $line[11] );
		
		my $forward_urls;
		my $uniq = $id. '-0';
		if( $target eq '0' ){
			# 送信済み短縮URLを取得
			my $forward = &Click'getForward_url();
			#---------------------------#
			# 転送用タグ取得            #
			#---------------------------#
			my( $urlTag, $other ) = &Click'roadTag( $line[82] );
			# 転送タグ変換
			($message, $forward_urls) = &Click'analyTag($csvs[0], $message, $urlTag, $uniq, $forward);
		}
		
		my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
		$subject = &include( \@csvs, $subject );
		$message = &include( \@csvs, $message, $jis );
		$senderror = &send( $line[4], $line[3], $csvs[5], $subject, $message, '' );
		# 配信ログに追加
		my $now = time;
		unless ( $senderror ) {
			open(LOG, ">>$logpath");
			print LOG "$csvs[0]\t$csvs[5]\t$csvs[3]\t$now\t$target\t$subject\n";
			close(LOG);
			# アクセス集計用データ生成
			&Click'setForward_t( $forward_urls, $uniq ) if( $target eq '0' );
		}else{
			unlink $tmp;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', 'g', 'メール送信に失敗しました');
			exit;
		}
	}
	rename $tmp, $csvpath;
	&rename_unlock( $lockfull );
	
	if( $restart ){
		&restart_action( $id, $userid, $sendStepNum );
	}
	
	&make_plan_page( 'plan', 'guest' );
	exit;
}

#-------------------------#
# 登録者CSVのダウンロード #
#-------------------------#
sub csv {
	
	my $id = $param{'id'} - 0;
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, $file) ) {
		&make_plan_page( 'plan', '', "システムエラー<br>$fileが開けません");
		exit;
	}
	my $path;
	while( <PLAN> ) {
		chomp;
		my ( $index, $csv ) = ( split(/\t/) )[0, 6];
		if ( $index eq $id ) {
			$path = "$myroot$data_dir$csv_dir$csv";
			last;
		}
	}
	close(PLAN);
	unless ( $path ) {
		&make_plan_page( 'plan', '', "システムエラー<br>該当するデータがありません");
		exit;
	}
	unless ( open(CSV, "$path") ) {
		&make_plan_page( 'plan', '', "システムエラー<br>$pathが開けません");
		exit;
	}
	my @csvdata;
	while( <CSV> ) {
		chomp;
		my @csvs;
		my @lines = split(/\t/);
		#my @seimei = splice( @lines, 37, 4 );
		#my @senddata = splice( @lines, 19, 3 );
		my $date = &make_date( $lines[19] );
		#my $email = splice( @lines, 5, 1 );
		
		$csvs[0] = $lines[5];
		$csvs[1] = $lines[1];
		$csvs[2] = $lines[2];
		$csvs[3] = $lines[37];
		$csvs[4] = $lines[38];
		$csvs[5] = $lines[39];
		$csvs[6] = $lines[40];
		$csvs[7] = $lines[3];
		$csvs[8] = $lines[4];
		$csvs[9] = $lines[6];
		$csvs[10] = $lines[7];
		$csvs[11] = $lines[8];
		$csvs[12] = $lines[9];
		$csvs[13] = $lines[10];
		$csvs[14] = $lines[11];
		$csvs[15] = $lines[12];
		$csvs[16] = $lines[13];
		$csvs[17] = $lines[14];
		$csvs[18] = $lines[15];
		$csvs[19] = $lines[16];
		$csvs[20] = $lines[17];
		$csvs[21] = $lines[18];
		$csvs[22] = $lines[22];
		$csvs[23] = $lines[23];
		$csvs[24] = $lines[24];
		$csvs[25] = $lines[25];
		$csvs[26] = $lines[26];
		$csvs[27] = $lines[27];
		$csvs[28] = $lines[28];
		$csvs[29] = $lines[29];
		$csvs[30] = $lines[30];
		$csvs[31] = $lines[31];
		$csvs[32] = $lines[32];
		$csvs[33] = $lines[33];
		$csvs[34] = $lines[34];
		$csvs[35] = $lines[35];
		$csvs[36] = $lines[36];
		$csvs[37] = '';
		$csvs[38] = '';
		$csvs[39] = $date;
		$csvs[40] = $lines[41];
		$csvs[41] = $lines[42];
		$csvs[42] = $lines[43];
		$csvs[43] = $lines[44];
		$csvs[44] = $lines[45];
		$csvs[45] = $lines[46];
		$csvs[46] = $lines[47];
		$csvs[47] = $lines[48];
		$csvs[48] = $lines[49];
		$csvs[49] = $lines[50];
		my $line = '';
		foreach( @csvs ){
			s/<br>/\n/ig;
			s/"/""/g;
			$line .= ',' if( $line ne '');
			$line .= qq|"$_"|;
		}
		push @csvdata, "$line\n";
	}
	close(CSV);
	my $filename = $id . '.csv';
	print qq|Content-Disposition: attachment; filename="$filename"| , "\n";
	print "Content-type: application/x-csv", "\n";
	# print "Content-length: ", "\n";
	print "\n";
	print @csvdata;
	exit;
	
}

#-------------------------#
# 登録者CSVのアップロード #
#-------------------------#
sub upload {
	
	my $id       = $param{'id'} - 0;
	my $file     = "$myroot$data_dir$log_dir$plan_txt";
	my $filedata = $param{'csvfile'};
	my $stepNum = &delspace($param{'step'});
	my $interval = &delspace($param{'interval'});
	
	# 登録済み重複リスト
	my %mail_overlap;
	# 空リスト
	my %mail_undef;
	# 不正アドレスリスト
	my %mail_format;
	# 重複アドレス
	my %mail_repeat;
	# 登録済みリスト（追加の場合）
	my %mail_alr;
	# エラーフラグ
	my $errflag = 0;
	
	if( $param{'addcheck'} eq '' ){
		&main'make_plan_page( 'plan', '', "アップロード方式を選択してください。", '1' );
	}
	
	my $addcheck = $param{'addcheck'} - 0; # 追加アップロードフラグ
	my $sendflag = $param{'sendflag'} - 0;     # 登録時送信フラグ
	my $dup      = $param{'dup'} - 0; # 重複削除
	
	my $csvfilename = &the_filedata( 'csvfile' );
	if ( $csvfilename !~ /\.csv$/ ) {
		&make_plan_page( 'plan', '', "更新エラー<br>CSVファイルを指定してください");
	}
	
	unless ( open(PLAN, $file) ) {
		&make_plan_page( 'plan', '', "システムエラー<br>$fileが開けません");
		exit;
	}
	my $path;
	my $dck;
	my $step;
	my $schedule;
	while( <PLAN> ) {
		chomp;
		my ( $index, $csv, $_step, $_schedule, $check ) = ( split(/\t/) )[0, 6, 35, 36, 42 ];
		if ( $index eq $id ) {
			$path = "$myroot$data_dir$csv_dir$csv";
			$dck  = $check;
			$step = $_step;
			$schedule = $_schedule;
			last;
		}
	}
	close(PLAN);
	unless ( $path ) {
		&make_plan_page( 'plan', '', "システムエラー<br>該当するデータがありません");
		exit;
	}
	my $In = 0;
	my $count = (split( /,/, $step ))[0];
	my @step = split( /,/, (split(/<>/,$schedule))[0] );
	for( my $i=0; $i<$count; $i++ ){
		my $n = $i+2;
		my( $inter, $config ) = split(/\//,$step[$i]);
		if( $n eq $stepNum ){
			$In = 1;
			if( $config ){
				if( $interval <= 0 ){
					&make_plan_page( 'plan', '', "配信開始日を指定してください。");
					exit;
				}
				my $now = time;
				$interval = qq|$interval/$now|;
			}else{
				$interval = '';
			}
		}
	}
	my $sendlog;
	if( $step ne '' ){
		my $baseNum = &getBaseNum( $schedule, $stepNum );
		if( $baseNum > 1 ){
			my $now = time;
			$sendlog = qq|$baseNum/$now|;
		}
	}
	
	if( $stepNum > 1 && !$In ){
		&make_plan_page( 'plan', '', "システムエラー<br>指定した配信回は、削除された可能\性があります。<br>最新の日程をご確認ください。");
		exit;
	}
	
	my $lockfull = &lock();
	unless ( open(CSV, "$path") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "システムエラー<br>$pathが開けません");
		exit;
	}
	my $tmp = "$myroot$data_dir$csv_dir" . time . $$ . '.tmp';
	unless ( open(TMP, ">$tmp") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "システムエラー<br>$pathが開けません");
		exit;
	}
	chmod 0606, $tmp;
	
	#--------------------------------------
	# 登録時送信の場合
	#--------------------------------------
	my $regist_path;
	if( $sendflag ){
		$regist_path = "$myroot$data_dir$csv_dir" . 'REG-'. time. $$ . "-$id" . '.cgi';
		unless ( open(REG, ">>$regist_path") ) {
			close(TMP);
			unlink $tmp;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "システムエラー<br>ファイルが作成できません。$csv_dirのパーミッションをご確認ください。");
			exit;
		}
		chmod 0606, $regist_path;
	}
	
	my $now = time;
	my $max = 0;
	my %CSV;
    while( <CSV> ) {
		chomp;
		my ( $id, $email ) = ( split(/\t/) )[0,5];
		$max = $id if ( $max < $id );
		if( defined $CSV{$email} ) {
			next if( $dup ); # 重複削除
			push @{ $CSV_RAP{$email} }, $_;
			next;
		}
		$CSV{$email} = $_;
	}
	close(CSV);
	my @senddata = ( $now, '', $now );
	my $n        = 0;
	my $newaddr  = 0;
	
	my $csvindex = 0;
	my @csvdata = split( /\r?\n|\r/, $filedata );
	for( my $csvindex=0; $csvindex <= $#csvdata; $csvindex++) {
		
		$line = $csvdata[$csvindex];
		# 行数を進める
		$n++;
		
		while( $line =~ tr/"// % 2 && $csvindex < $#csvdata ){
			$csvindex++;
			$_line = $csvdata[$csvindex];
			$line .= "\n$_line";
		}
		$line =~ s/(?:\x0D\x0A|[\x0D\x0A])?$/,/;
		my @lines = map {/^"(.*)"$/s ? scalar($_ = $1, s/""/"/g, $_) : $_}
                ($line =~ /("[^"]*(?:""[^"]*)*"|[^,]*),/g);
		my $newline = join("\t",@lines);
		$newline =~ s/"//g;
		$newline = &deltag( $newline );
		$newline = &the_text( $newline );
		my @line = split( /\t/, $newline );
		
		# 予備・登録日時項目を削除
		splice( @line, 37, 3 );
		my $email = shift @line;
		my @seimei = splice( @line, 2, 4 );
		if( $seimei[0] ne '' || $seimei[2] ne '' ){
			$line[2] = $seimei[0] . $seimei[2];
		}
		if( $seimei[1] ne '' || $seimei[3] ne '' ){
			$line[3] = $seimei[1] . $seimei[3];
		}
		$email = &delspace( $email );
		
		#------------------------------
		# 空チェック
		#------------------------------
		if( $email eq '' ){
			$mail_undef{$n} = 1;
			next;
		}
		#------------------------------
		# メールアドレス形式チェック
		#------------------------------
		if( &chk_email($email) ){
			$mail_format{$n} = $email;
			next;
		}
		#------------------------------
		# 重複チェック
		#------------------------------
		if( $Email{$email} ) {
			if( $dup ){
				next;
			}
			$mail_repeat{$n} = $email;
			next;
		}
		
		#------------------------------
		# 登録済みチェック(追加の場合)
		#------------------------------
		if( $addcheck && $CSV{$email} ne '' ) {
			if( $dup ){
				next;
			}
			$mail_alr{$n} = $email;
			next;
		}
		
		if( $CSV{$email} eq '' ) {
			$max++; # IDを進める
			$newaddr++;
			my $id = sprintf( "%05d", $max );
			unshift @line, $id;
			
			if( $#line < 5 ){
				$line[5] = $email;
				
			}else{
				splice( @line, 5, 0, $email );
			}
			if( $#line < 19 ){
				$line[19] = $now;
				$line[20] = '';
				$line[21] = $now;
			}else{
				splice( @line, 19,0, @senddata );
			}
			
			if( $#line < 37 ){
				$line[37] = $seimei[0];
				$line[38] = $seimei[1];
				$line[39] = $seimei[2];
				$line[40] = $seimei[3];
			}else{
				splice( @line, 37, 0, @seimei );
			}
			
			if( $#line < 51 ){
				$line[51] = $stepNum if( $stepNum > 2 || $stepNum eq 'end' );
			}else{
				splice( @line, 51, 0, $stepNum ) if( $stepNum > 2 || $stepNum eq 'end' );
			}
			if( $#line < 53 ){
				$line[53] = $sendlog;
			}else{
				splice( @line, 53, 0, $sendlog );
			}
			if( $#line < 54 ){
				$line[54] = $interval;
			}else{
				splice( @line, 54, 0, $interval );
			}
			
			my $sendlist = join( "\t", @line );
			print REG "$sendlist\n";
			
		}else{
			
			if( @{ $CSV_RAP{$email} } > 0 ){
				print TMP "$CSV{$email}\n";
				foreach my $line ( @{ $CSV_RAP{$email} } ){
					print TMP "$line\n";
				}
				$mail_overlap{$n} = $email if( !$addcheck );
				$Email{$email} = $n;
				next;
			}
			
			my ( $id, @senddata ) = ( split(/\t/, $CSV{$email}) )[0,19,20,21, 51,52,53,54];
			unshift @line, $id;
			if( $#line < 5 ){
				$line[5] = $email;
				
			}else{
				splice( @line, 5, 0, $email );
			}
			if( $#line < 19 ){
				$line[19] = $senddata[0];
				$line[20] = $senddata[1];
				$line[21] = $senddata[2];
			}else{
				my @stepInfo = ($senddata[0],$senddata[1],$senddata[2]);
				splice( @line, 19,0, @stepInfo );
			}
			
			if( $#line < 37 ){
				$line[37] = $seimei[0];
				$line[38] = $seimei[1];
				$line[39] = $seimei[2];
				$line[40] = $seimei[3];
			}else{
				splice( @line, 37, 0, @seimei );
			}
			
			if( $#line < 51 ){
				$line[51] = $senddata[3];
				$line[52] = $senddata[4];
				$line[53] = $senddata[5];
				$line[54] = $senddata[6];
			}else{
				my @stepInfo = ($senddata[3],$senddata[4],$senddata[5], $senddata[6]);
				splice( @line, 51, 0, @stepInfo );
			}
		}
		
		my $new = join( "\t", @line );
		print TMP "$new\n";
		$Email{$email} = $n;
	}
	close(TMP);
	close(REG);
	#------------------------------------------------
	# エラー行の確認
	#------------------------------------------------
	my $errflag = 0;
	if( keys %mail_overlap ){
		$param{'mail_overlap'} = {%mail_overlap};
		$errflag = 1;
	}
	if( keys %mail_undef ){
		$param{'mail_undef'} = {%mail_undef};
	}
	if( keys %mail_format ){
		$param{'mail_format'} = {%mail_format};
		$errflag = 1;
	}
	if( keys %mail_repeat ){
		$param{'mail_repeat'} = {%mail_repeat};
		$errflag = 1;
	}
	if( keys %mail_alr ){
		$param{'mail_alr'} = {%mail_alr};
		$errflag = 1;
	}
	
	if( $addcheck ){
		my $tmp2 = $myroot. $data_dir. $csv_dir. 'UP-'. $$. time. '.cgi';
		open( TMP, "<$tmp ");
		open( CSV, "<$path" );
		open( TEMPLATE, ">$tmp2");
		while(<CSV>){
			print TEMPLATE $_;
		}
		while(<TMP>){
			print TEMPLATE $_;
		}
		close(CSV);
		close(TMP);
		close(TEMPLATE);
		chmod 0606, $tmp2;
		rename $tmp2, $path;
		unlink $tmp;
	}else{
		chmod 0606, $tmp;
		rename $tmp, $path;
	}
	chmod 0606, $path;
	&rename_unlock( $lockfull );
	#--------------------------
	# 通常終了
	#--------------------------
	
	# 登録時メールの対象がない場合
	if( $sendflag ){
		if( $newaddr <= 0 ){
			unlink $regist_path;
			$sendflag = 0;
		}
	}
	
	#--------------------------------------------------------------
	# 登録時送信の場合は、Javascrptを利用して配信タグを表示する
	#--------------------------------------------------------------
	if( $sendflag ){
		# 送信準備
		my $session = &regsender($id, $regist_path);
		local( $method, $each, $sleep, $partition ) = &send_method( \@errors );
		# 分割配信
		if( $method ){
			&make_plan_page('plan', 'up_error', '', '');
		}else{
		# アクセス毎配信
			$param{'ss'} = $session;
			$param{'start'} = 1;
			&csvupload_each();
			exit;
		}
	}
	
	&make_plan_page( 'plan', 'up_error' );
	exit;
}

sub regsender
{
	my( $id,$regist_path ) = @_;
	( $session, $session_path ) = &get_csvup_session( $id );
	if( $session eq '' ){
		$session      = crypt( $cookie_id, &make_salt() );
		$session      =~ s/[\.\\\/]//g;
		$session_path = "$myroot$data_dir$csv_dir" . 'CUR-' . $session . "_$id" . '.cgi';
	}
	
	rename $regist_path, $session_path;
	return $session;
}


#-------------------------#
# 登録者へのメール送信    #
#-------------------------#
sub mailsend {
	
	# 条件指定ページへ
	if( defined $param{'simul_cdn'} ){
		&make_plan_page( 'plan', 'simul_cdn', '', '', '' );
	}
	
	if( $param{'next'} > 0 ){
		&Simul'send_manual();
	}
	&Simul'make_config();
	exit;
}

# ----------------------------------------------------------------------------------------
# 以下HTML出力関係
# ----------------------------------------------------------------------------------------

#------------------------------------------------------#
# 各表示ページ毎の出力テーブルを作成しページを出力する #
#------------------------------------------------------#
sub make_plan_page {
	my ( $type, $page, $error, $send, $etc ) = @_;
	my $table;
	my $pname;
	my $main_title;
	my $main_table;
	my $id = $param{'id'} - 0;
	my @line; # データの配列
	my $help;
	
	#-------------------------#
	# ページのタイトル        #
	#-------------------------#
	if (    $page eq 'all' )    { $main_title = '詳細'; $help = qq|"#" onClick="wopen('$self?md=manual&p=detail', 'detail');" |; }
	elsif ( $page eq 'bs' )     { $main_title = '配信元情報'; $help = qq|"#" onClick="wopen('$self?md=manual&p=sender', 'sender');" |; }
    elsif ( $page eq 'redirect'){ $main_title = '登録設定'; $help = qq|"#" onClick="wopen('$self?md=manual&p=redirect', 'redirect');" |;}
	elsif ( $page eq 'header' ) { $main_title = 'ヘッダ'; $help = qq|"#" onClick="wopen('$$self?md=manual&p=header', 'header');" |; }
	elsif ( $page eq 'footer' ) { $main_title = 'フッタ'; $help = qq|"#" onClick="wopen('$self?md=manual&p=footer', 'footer');" |; }
	elsif ( $page eq 'cl' )     { $main_title = '解除案内'; $help = qq|"#" onClick="wopen('$self?md=manual&p=cancel', 'cnacel');" |; }
	elsif ( $page eq 'form1' )  { $main_title = '登録フォーム'; $help = qq|"#" onClick="wopen('$self?md=manual&p=form1', 'form1');" |;}
	elsif ( $page eq 'form2' )  { $main_title = '変更・解除フォーム'; $help = qq|"#" onClick="wopen('$self?md=manual&p=form2', 'form2');" |;}
	elsif ( $page eq 'preview' ){ $main_title = '本文のプレビュー'; $help = qq|"#" onClick="wopen('$self?md=manual&p=preview', 'preview');"|;}
	elsif ( $page eq 'body' )   { $main_title = '本文の編集トップ'; $help = qq|"#" onClick="wopen('$self?md=manual&p=body', 'body');"|;}
	# HTML編集画面
	elsif ( $page eq 'html' )   { $main_title = '本文(HTML)の編集'; $help = qq|"#" onClick="javascript: return false;" |;}
	elsif ( $page eq 'schedule'){ $main_title = '配信日程'; $help = qq|"#" onClick="wopen('$self?md=manual&p=schedule', 'schedule');" |;}
	elsif ( $page eq 'mf1' )    { $main_title = '登録用フォームのHTMLソース'; $help = qq|"#" onClick="wopen('$self?md=manual&p=fsample1', 'fsample1');" |; }
	elsif ( $page eq 'mf2' )    { $main_title = '変更用フォームのHTMLソース'; $help = qq|"#" onClick="wopen('$self?md=manual&p=fsample2', 'fsample2');" |; }
	elsif ( $page eq 'mf3' )    { $main_title = '解除用フォームのHTMLソース'; $help = qq|"#" onClick="wopen('$self?md=manual&p=fsample3', 'fsample3');" |; }
	
	# 画面カスタマイズ
	elsif ( $page eq 'ctm_regdisp' ){ my $sub_title = '（携帯用）' if($param{'m'}>0); $main_title = '画面カスタマイズ'.$sub_title; $help = qq|"#" onClick="javascript: return false;" |; }
	
	elsif ( $page eq 'guest' )  { $main_title = '登録者情報'; $help = qq|"#" onClick="wopen('$self?md=manual&p=guest', 'guest');" |; }
	elsif ( $page eq 'add' )    { $main_title = '登録者の追加'; $help = qq|"#" onClick="wopen('$self?md=manual&p=grenew', 'grenew');" |; }
	elsif ( $page eq 'ref' )    { $main_title = '登録者の編集'; $help = qq|"#" onClick="wopen('$self?md=manual&p=grenew', 'grenew');" |; }
	elsif ( $page eq 'mail' )   { $main_title = '登録者にメールを送信 [ 本文 ]'; $help = qq|"#" onClick="wopen('$self?md=manual&p=body', 'body');"|;}
	elsif ( $page eq 'mailnext'){ $main_title = '登録者にメールを送信 [ 選択 ]'; $help = qq|"#" onClick="wopen('$self?md=manual&p=select', 'select');"|;}
	elsif ( $page eq 'log' )    { $main_title = '配信ログ'; $help = qq|"#" onClick="wopen('$self?md=manual&p=log', 'log');" |; }
	elsif ( $page eq 'up' )     { $main_title = '一覧をアップロード'; $help = qq|"#" onClick="wopen('$self?md=manual&p=guest', 'guest');" |; }
	elsif ( $page eq 'up_error'){ $main_title = '一覧をアップロード'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# 条件指定
	elsif ( $page eq 'simul_cdn' ){ $main_title = '登録者にメール送信 [ 条件指定 ]'; $help = qq|"#" onClick="javascript: return false;" |; }
	elsif ( $page eq 'simul_cdn_conf' ){ $main_title = '登録者にメール送信 [ 条件指定確認 ]'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# プラン削除画面
	elsif ( $page eq 'delete' ) { $main_title = '配信プラン削除'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# まぐまぐ登録機能画面
	elsif ( $page eq 'magu' ){ $main_title = 'まぐまぐ登録'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# プランコピー
	elsif ( $page eq 'copy' ){ $main_title = 'コピープラン作成'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# クリック分析
	elsif ( $page eq 'click_analy' ){ $main_title = 'クリック分析・計測'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	if ( $error ) {
        $main_title = 'エラー';
        $page = 'error';
        $page = 'send' if ( $send ne '' );
        $main_title = '登録者にメール送信' if ( $send ne '' );
    }
    
	#-------------------------#
	# 該当するデータを取得    #
	#-------------------------#
	if ( $type eq 'plan' ) {
		my $file = $myroot . $data_dir . $log_dir . $plan_txt;
		unless ( open (FILE, $file) ) {
			&error( 'plan', '', "システムエラー<br><br>$fileが開けません<br>パーミッションを確認してください" );
		}
		while( <FILE> ) {
			chomp;
			@line = split(/\t/);
			if( $line[0] eq $id ) {
				last;
			}else  {
				undef @line;
			}
		}
		close(FILE);
		$pname = $line[2];
		
		# 配信ログのみ書き込み制限を確認
		my $log_path = $myroot. $data_dir. $log_dir. $line[8];
		if( !( -w $log_path ) ){
			my $tmp = $myroot. $data_dir. $log_dir. 'TMP-'. $$. time. '.cgi';
			open( LOG, "<$log_path" );
			open( TMP, ">$tmp" );
			while(<LOG>){
				print TMP $_;
			}
			close(LOG);
			close(TMP);
			chmod 0606, $tmp;
			rename $tmp, $log_path
		}
		
	}
	&Pub'ssl($line[83]);
    my $auterun = ($line[37])? '稼動中': '停止中';
    my $run = ($line[37])? "停止する": "稼動する";
    my $alert = ($line[37])? "停止します。よろしいですか？": "稼動します。よろしいですか？";
    my $link = ($line[37])? '0': '1';
    my $runlink = qq|<a href="$indexcgi\?md=run&id=$id&action=$link" onClick="return confir('$alert');"><font color="#0000FF">$run</font></a>|;
	#my $sendmsg = ($line[37])? '配信を実行する': '';
	#my $distance = ($line[37])? ' / ': '';
	#my $sendtag = qq|$distance<a href="#" onClick="alert('配信を実行します');wopen('$sendpl', 'raku_mail');"><font color="#0000FF"><strong>$sendmsg</strong></font></a>|;
	
	#----------------------------#
	# メイン部分のテーブルを作成 #
	#----------------------------#
	if ( $page eq 'all' ) {
		# 詳細
		foreach ( @line ) {
			$_ = '&nbsp;' unless ( $_ );
		}
		$line[5] =~ s/\,/<br>/g;
		my $header = $line[9] if($line[9]  ne '&nbsp;');
		my $cancel = $line[10] if($line[10] ne '&nbsp;');
		my $footer = $line[11] if($line[11] ne '&nbsp;');
		
		$header = &make_text( $header );
		$header = &reInclude( $header );
		$header = &include( \@temdata, $header, '', 1 );
		
		$cancel = &make_text( $cancel );
		$cancel = &reInclude( $cancel );
		$cancel = &include( \@temdata, $cancel, '', 1 );
		
		$footer = &make_text( $footer );
		$footer = &reInclude( $footer );
		$footer = &include( \@temdata, $footer, '', 1 );
		
		
		# 登録用フォームの作成
		my $st = 15;
		my $end = 32;
		my( $form1, $form1_m ) = &make_form( '1', $id, 'form1', $line[12], $line[39], $line[58], $line[59], $line[81], @line[15 .. 32], @line[43 .. 57], @line[61 .. 65], @line[66 .. 75] );
        my( $form2, $form2_m ) = &make_form( '1', $id, 'form2', $line[13], $line[39], $line[58], $line[59], $line[81], $line[33] );
        my( $form3, $form3_m ) = &make_form( '1', $id, 'form3', $line[14], $line[39], $line[58], $line[59], $line[81], $line[34] );
		my $schedule = &make_schedule( $id, 0, $line[35], $line[36], $line[7] );
        my $redirect = &make_redirect_table( $line[12], $line[13], $line[14], $line[38], $line[40], $line[78], $line[79], $line[80] );
		$main_table = <<"END";
<table width="470" border="0" align="center" cellpadding="1" cellspacing="0">
          <tr>
            <td bgcolor="#000000"><table width="470" border="0" cellspacing="0" cellpadding="10">
              <tr>
                <td bgcolor="#FFFFFF"><font color="#FF0000">【ご注意】<br>
                </font>サーバが一杯になると、不具合が生じる可能\性があるので、サーバの容量にはご注意ください。
                  万一に備えて、定期的に顧客リスト及び本文のバックアップをお取りになることをお勧めいたします。</td>
              </tr>
            </table></td>
          </tr>
        </table><br>
                                      <table width="100%" border="1" cellpadding="3" cellspacing="1" bordercolor="#99CCFF">
                                        <tr> 
                                          <td width="100" align="left" bgcolor="#99CCFF">配信プラン名</td>
                                          <td>$line[2]</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#99CCFF">配信元名</td>
                                          <td>$line[3]</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">配信元アドレス</td>
                                          <td>$line[4]</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">管理者アドレス</td>
                                          <td>$line[5]</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">配信日程</td>
                                          <td>$schedule</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">ヘッダー</td>
                                          <td>$header&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">解除案内</td>
                                          <td>$cancel&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">フッター</td>
                                          <td>$footer&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">登録設定</td>
                                          <td>$redirect
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">登録用フォーム</td>
                                          <td>$form1<a href="$index?md=mf1&id=$id"><font color="#0000FF">HTMLソ\ースのサンプルを表\示</font></a><br><a href="javascript: void(0);" onClick="wopen('$main'indexcgi?md=manual&p=html_edit', 'html_edit', 840, 360);"><font color="#0000FF">姓・名を一列に編集する方法について</font></a></td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">変更フォーム</td>
                                          <td>$form2<a href="$index?md=mf2&id=$id"><font color="#0000FF">HTMLソ\ースのサンプルを表\示</font></a></td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">解除フォーム</td>
                                          <td>$form3<a href="$index?md=mf3&id=$id"><font color="#0000FF">HTMLソ\ースのサンプルを表\示</font></a></td>
                                        </tr>
                                      </table>
END
	} elsif ( $page eq 'bs' ) {
		# 配信元情報
		$main_table = <<"END";
                                <form name="form1" method="post" action="$indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="502"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="3">
                                          <tr> 
                                            <td>配信元の情報を更新します</td>
                                          </tr>
                                          <tr> 
                                            <td>入力後、「更新を反映」ボタンをクリックしてください</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                          <td>
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                            <td bgcolor="#ABDCE5">
                                            <table width="100%" border="0" cellpadding="3" cellspacing="1">
                                              <tr> 
                                                <td width="142" bgcolor="#E5FDFF" rowspan="2">配信プラン名</td>
                                                <td width="348" bgcolor="#FFFFFF">
                                                  <input name="pname" type="text" id="sname" value="$line[2]" size="50"></td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#FFFFFF">配信プラン名は識別名なので、任意に変更可能\です。</td>
                                              </tr>
                                              <tr> 
                                                <td width="142" bgcolor="#E5FDFF">配信元名</td>
                                                <td width="348" bgcolor="#FFFFFF">
                                                  <input name="sname" type="text" id="sname" value="$line[3]" size="50"></td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#E5FDFF">配信元メールアドレス</td>
                                                <td bgcolor="#FFFFFF">
                                                  <input name="address" type="text" id="address" value="$line[4]" size="50"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2" bgcolor="#FFFFFF" nowrap>配信元名・配信元メールアドレスが、登録者宛に届くメールの差出人として扱われます。</td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#E5FDFF">管理者メールアドレス</td>
                                                <td bgcolor="#FFFFFF">
                                                  <input name="address2" type="text" id="address2" value="$line[5]" size="50">
                                                  <table width="300" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                      <td><font color="#0000FF" size="-1">※</font><font color="#0000FF" size="-1">複数指定する場合は半角「,」で区切ってください</font></td>
                                                    </tr>
                                                  </table>                                                  
                                                </td>
                                              <tr> 
                                                <td colspan="2" bgcolor="#FFFFFF" nowrap>登録時の確認メールや送信テストはこちらの管理人メールアドレスに届きます。</td>
                                              </tr>
                                              </tr>
                                            </table>
                                            </td>
                                            </tr>
                                            </table>
                                          </td>
                                          </tr>
                                          <tr> 
                                            <td><br><table width="450" border="0">
                                              <tr>
                                                <td>※<strong>管理者メールアドレスを複数指定した場合</strong></td>
                                              </tr>
                                              <tr>
                                                <td>「,」カンマで区切った先頭のメールアドレスを以下に使用し、その他のメールアドレスは登録時の管理者への通知メールに使用されます。<br>                                                  <br>
                                                  ・本文の送信テスト<br>
                                                  ・登録者へのメール送信（配信日程にないメールを送信）</td>
                                              </tr>
                                            </table></td>
                                          </tr>
                                          <tr align="center"> 
                                            <td><input name="id" type="hidden" id="id" value="$id">
                                              <input name="action" type="hidden" id="action" value="bs">
                                              <input name="md" type="hidden" id="md" value="text">
                                              <input type="submit" name="Submit" value="　更新を反映　"></td>
                                          </tr>
                                        </table></td>
                                      <td width="21">&nbsp;</td>
                                    </tr>
                                  </table>
                                </form>
END
	} elsif ( $page eq 'redirect' ) {
		# 登録完了動作
        my $checked = 'checked' if ( $line[39] );
		my $checked2 = 'checked' if ( $line[40] );
		my $checked3 = 'checked' if ( $line[41] );
		my $checked4 = 'checked' if ( $line[42] );
		my $checked_utf = 'checked' if( $line[60] );
		my $checked_ssl = 'checked' if( $line[83] );
		
		my $href_regist = &Pub'setHttp($line[12]);
		my $href_renew = &Pub'setHttp($line[13]);
		my $href_cancel = &Pub'setHttp($line[14]);
		
		my $selected_regist_0 = ( $line[78] ne 'https://' )? ' selected="selected"': '';
		my $selected_regist_1 = ( $line[78] eq 'https://' )? ' selected="selected"': '';
		my $selected_renew_0 = ( $line[79] ne 'https://' )? ' selected="selected"': '';
		my $selected_renew_1 = ( $line[79] eq 'https://' )? ' selected="selected"': '';
		my $selected_cancel_0 = ( $line[80] ne 'https://' )? ' selected="selected"': '';
		my $selected_cancel_1 = ( $line[80] eq 'https://' )? ' selected="selected"': '';
		
		$main_table = <<"END";
                                <form name="form1" method="post" action="$indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="502"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="3">
                                          <tr> 
                                            <td><strong>登録設定</strong>を更新します</td>
                                          </tr>
                                          <tr> 
                                            <td>入力後、「更新を反映」ボタンをクリックしてください
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                          <td><font color="#FF0033">※指定がない場合は簡易ページが出力されます。<br>　 詳しくはメニューのヘルプをクリックしてください。</font>
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr>
                                              <td>
                                                
                                              </td>
                                            </tr>
                                            <tr>
                                            <td bgcolor="#ABDCE5">
                                              <table width="100%" border="0" cellpadding="5" cellspacing="1">
                                              <tr>
                                                <td bgcolor="#E5FDFF" rowspan="2">登録を通知する </td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="notice" value="checkbox" $checked2>管理者に通知</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">ここにチェックを入れると、「登録時」のメールが管理者のメールアドレスにも送信されます。</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#E5FDFF" rowspan="2" nowrap>登録時の入力確認 </td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="confirm" value="checkbox" $checked3>入力確認ページを表\示する</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">ここにチェックを入れると、フォームへの入力内容確認画面を表\示します。</td>
                                              </tr>
                                              
                                              <tr>
                                                <td rowspan="2" nowrap bgcolor="#E5FDFF">文字コード設定</td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="utf" value="1" $checked_utf />
                                                  UTF-8を利用する</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">登録時に楽メールが表\示するページ（入力確認・エラー・完了画面）の文字コードにUTF-8が使われます。</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#E5FDFF" rowspan="2">登録メールアドレスの重複 </td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="dck" value="checkbox" $checked4>許可する</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">登録時に楽メールが表\示するページ（入力確認・エラー・完了画面）の文字コードにUTF-8が使われます。</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#E5FDFF" rowspan="2">SSL設定 </td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="ssl" value="1" $checked_ssl>SSLで使用する</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">SSLを使用可能\なサーバーにおいて、SSL領域に楽メールPROを設置した場合に設定してください。<br>
                                                   登録用CGI(apply.cgi)のURLがSSL(https://)となり、<br>
                                                   ・「登録/変更/解除用」フォームのサンプルソ\ース<br>
                                                   ・ワンクリック解除リンク<br>・アクセス分析用リンク<br>
                                                   のアクセス先URLとして使われ、SSLが使用可能\になります。<br><br>
                                                   <font color="#FF0000">【SSL使用時のURLが異なるサーバーの場合】</font><br>「SSL設定」を有効にして、以後「SSL用のURL」で管理画面にログインしてください。<br>
                                                   それにより、登録CGI(apply.cgi)が「SSL用のURL」として設定されます。<br><br>
                                                   <font color="#FF0000">※設定を変更した場合は、登録用フォームのHTMLを最新のものに貼\り付けなおしてください。</font>
                                               </td>
                                              </tr>
                                               <tr> 
                                                <td bgcolor="#E5FDFF">登録完了時のURL</td>
                                                <td bgcolor="#FFFFFF"><select name="http_regist">
                                                    <option$selected_regist_0>http://</option>
                                                    <option$selected_regist_1>https://</option>
                                                  </select>
                                                  <input name="regist" type="text" value="$href_regist" size="45"></td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#E5FDFF">変更完了時のURL</td>
                                                <td bgcolor="#FFFFFF"><select name="http_renew">
                                                    <option$selected_renew_0>http://</option>
                                                    <option$selected_renew_1>https://</option>
                                                  </select>
                                                  <input name="renew" type="text" value="$href_renew" size="45"></td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#E5FDFF">解除完了時のURL</td>
                                                <td bgcolor="#FFFFFF"><select name="http_cancel">
                                                    <option$selected_cancel_0>http://</option>
                                                    <option$selected_cancel_1>https://</option>
                                                  </select>
                                                  <input name="cancel" type="text"  value="$href_cancel" size="45"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2" bgcolor="#FFFFFF">上記フォームにURLアドレスを入れることで、登録時・変更時・解除時に任意のページを表\示することができます。<br><font color="#FF0000">※完了URLは、PCからのアクセス専用です。</font>
                                                <br><br>
                                                <table width="100%" border="0" cellpadding="3" cellspacing="1">
                                                  <tr>
                                                  <td><input name="ck" type="checkbox" $checked></td>
                                                  <td><font color="#FF0000">サーバーによっては上記URLを指定することで正常に動作しない場合があります。
                                                      その場合はここをチェックしてください。</font></td>
                                                  </tr>
                                                </table></td>
                                              </tr>
                                              </table>
                                            </td>
                                            </tr>
                                            </table>
                                          </td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                          <td>
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                            <td bgcolor="#ABDCE5">
                                            <table width="100%" border="0" cellpadding="3" cellspacing="1">
                                              <tr>
                                                <td bgcolor="#E5FDFF">
                                                特定ドメイン・メールアドレスの受付拒否
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#FFFFFF">
                                                （複数指定する場合は半角「,」で区切ってください）<br>
                                                <input name="out" type="text" value="$line[38]" size="80"></td>
                                              </tr>
                                            </table>
                                            </td>
                                            </tr>
                                            </table>
                                          </td>
                                          </tr>
                                          <tr align="center"> 
                                            <td><input name="id" type="hidden" id="id" value="$id">
                                              <input name="action" type="hidden" id="action" value="redirect">
                                              <input name="md" type="hidden" id="md" value="text">
                                              <input type="submit" name="Submit" value="　更新を反映　"></td>
                                          </tr>
                                        </table></td>
                                      <td width="21">&nbsp;</td>
                                    </tr>
                                  </table>
                                </form>
END
	}elsif ( $page eq 'header' || $page eq 'footer' || $page eq 'cl' ) {
	    # 本文のヘッダ、フッタ、解除案内
		my $subtitle;
		my $text;
		my $submit = $page;
		$subtitle = '冒頭部分' if ( $page eq 'header' );
		$subtitle = '署名部分' if ( $page eq 'footer' );
		$subtitle = '解除案内分' if ( $page eq 'cl' );
		$text = $line[9] if ( $page eq 'header' );
		$text = $line[10] if ( $page eq 'cl' );
		$text = $line[11] if ( $page eq 'footer' );
		
		$text =~ s/<br>/\n/ig;
		$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>配信するメールの<strong>$subtitle（本文中）</strong>を更新します</td>
                                          </tr>
                                          <tr> 
                                            <td>入力後、「更新を反映」ボタンをクリックしてください</td>
                                          </tr>
                                          <tr> 
                                            <td><textarea name="text" cols="55" rows="10" id="text">$text</textarea></td>
                                          </tr>
                                          <tr> 
                                            <td align="center"><input name="md" type="hidden" id="md" value="text">
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="action" type="hidden" id="action" value="$submit">
                                              <input type="submit" name="Submit" value="　更新を反映　"></td>
                                          </tr>
                                          <tr> 
                                            <td><font color="#FF0000">※ステップメール本文や登録者へのメール送信等で、入力した上記データを挿入する場合、更新内容はすべてのメールに反映されます。</font></td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
	} elsif ( $page eq 'form1' ) {
		# 登録用フォームの指定フォーム
		$main_table = &MF'form_top( $id, @line );
	} elsif ( $page eq 'form2' ) {
        # 変更、解除
        my ( $ck1, $uid1, $mail1, $rmail ) = split(/<>/, $line[33]);
        my $checked1 = 'checked' if $ck1;
        my ( $ck2, $uid2, $mail2 ) = split(/<>/, $line[34]);
        my $checked2 = 'checked' if $ck2;
		$main_table = <<"END";
                                <form name="form1" method="post" action="$indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="503"><table width="100%" border="0" cellspacing="0" cellpadding="2">
                                          <tr> 
                                            <td>登録されたメールアドレス変更用、登録解除の入力フォームを指定してください</td>
                                          </tr>
                                          <tr> 
                                            <td>入力項目に指定したい場合は<strong>「入力チェック」</strong>にチェックしてください</td>
                                          </tr>
                                          <tr> 
                                            <td>また、表\示する項目の名称を変更したい場合は<strong>「表\示名称」</strong>に入力してください</td>
                                          </tr>
                                          <tr> 
                                            <td>決定後、<strong>「更新を反映」</strong>ボタンをクリックしてください</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td><strong>登録変更用</strong></td>
                                          </tr>
                                          <tr> 
                                            <td><table width="100%" border="1" cellspacing="0" cellpadding="1">
                                                <tr> 
                                                  <td width="146" align="center" bgcolor="#CCCCCC">項目</td>
                                                  <td width="92" align="center" bgcolor="#CCCCCC">入力チェック</td>
                                                  <td width="261" align="center" bgcolor="#CCCCCC">表\示名称</td>
                                                </tr>
                                                <tr> 
                                                  <td>登録者ID</td>
                                                  <td align="center"><input name="fr" type="checkbox" id="fm19" value="checkbox" $checked1></td>
                                                  <td align="center"><input name="ruserid" type="text" value="$uid1" size="40"></td>
                                                </tr>
                                                <tr> 
                                                  <td>変更前メールアドレス</td>
                                                  <td align="center">必須</td>
                                                  <td align="center"><input name="rmail" type="text" value="$mail1" size="40"></td>
                                                </tr>
                                                <tr> 
                                                  <td>変更後メールアドレス</td>
                                                  <td align="center">必須</td>
                                                  <td align="center"><input name="rnmail" type="text" value="$rmail1" size="40"></td>
                                                </tr>
                                              </table></td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td><strong>登録解除用</strong></td>
                                          </tr>
                                          <tr> 
                                            <td><table width="100%" border="1" cellspacing="0" cellpadding="1">
                                                <tr> 
                                                  <td width="146" align="center" bgcolor="#CCCCCC">項目</td>
                                                  <td width="92" align="center" bgcolor="#CCCCCC">入力チェック</td>
                                                  <td width="261" align="center" bgcolor="#CCCCCC">表\示名称</td>
                                                </tr>
                                                <tr> 
                                                  <td>登録者ID</td>
                                                  <td align="center"><input name="fd" type="checkbox" id="fm19" value="checkbox" $checked2></td>
                                                  <td align="center"><input name="duserid" type="text" value="$uid2" size="40"></td>
                                                </tr>
                                                <tr> 
                                                  <td>メールアドレス</td>
                                                  <td align="center">必須</td>
                                                  <td align="center"><input name="dmail" type="text" value="$mail2" size="40"></td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td align="center">
                                            <input type="hidden" name="id" value="$id">
                                            <input type="hidden" name="md" value="text">
                                            <input type="hidden" name="action" value="form2">
                                            <input type="submit" name="Submit" value="　更新を反映　"></td>
                                          </tr>
                                          <tr><td><font color="#FF0000">
                                            <strong>※「登録者ID」とは</strong><br>
                                            各登録者に対して、登録順に自動生成される半角数字の通し番号です。<br>「登録時メール」などを使って登録者に通知することで、変更・解除の際に登録者の固有情報として利用できます。</font></td></tr>
                                        </table></td>
                                    </tr>
                                  </table>
                                </form>
END
	}elsif ( $page eq 'add' || $page eq 'ref' ) {
        my $n = $param{'n'};
        my @csvs = &get_csvdata( $id, $n ) if( $page ne 'add' && $n > 0);
		if ( @csvs ) {
			foreach( 1 .. 50 ){
				$csvs[$_] =~ s/<br>/\n/gi;
			}
		}
		my $message;
		my $message2;
		my $submit;
		my $info;
		my $userid;
		my $sended;
		my $step;
		# 日程情報
		my @step = split( /,/, (split(/<>/,$line[36]))[0] );
		
		if ( $page eq 'add' ) {
			$submit   = qq|<input type="submit" value="　追加する　" onClick="return confir('追加しますか？');">|;
			$message  = '追加';
			$message2 = qq|入力後、「<strong>追加する</strong>」ボタンをクリックしてください|;
			$userid   = ' 半角数字で通し番号を作成します。<br>※このプラン内限定で有効なIDです。';
			# ステップメール日程を取得
			( $option, $script_array ) = &scheduleOption( $line[35], $line[36] );
		}else {
			$submit = qq|<input type="submit" name="re" value="　更新を反映する　"><input type="submit" name="de" value="　削除する　" onClick="return confir('本当に削除しますか?');">|;
			$message = '更新、削除';
			$message2 = qq|入力を反映して編集する場合は「<strong>更新を反映する</strong>」ボタンを<br>この登録者を削除する場合は「<strong>削除する</strong>」ボタンをクリックしてください<br>都道府県は変更する場合選択してください|;
			$info     = <<"END";
                                <tr>
                                  <td bgcolor="#FFFFFF" colspan="2"><strong>自動返信</strong></td>
								</tr>
								<tr>
                                <td bgcolor="#FFFFFF" colspan="2">
                                <input type="radio" name="res" value="0">「変更もしくは解除時」のメールを送信する<br>　　（更新後すぐにメールが送信されます）<br>
                                <input type="radio" name="res" value="1" checked>送信しない
                                </td>
                                </tr>
END
			my $id_number = sprintf( "%05d",$csvs[0] );
			$userid   = "<strong>$id_number</strong><br>※このプラン内限定で有効なIDです。";
			$stop_message = qq|※次回配信回を変更すると「一時停止」状態は解除されます。<br>| if( $csvs[52] > 0 );
			
			# ステップメール日程を取得
			( $option, $script_array ) = &scheduleOption( $line[35], $line[36], 1, $csvs[20], $csvs[51], $csvs[19], $csvs[53] );
			
			# ステップメール回を取得
			$sended = '未配信' if($csvs[20] eq '' );
			$sended = '登録時' if($csvs[20] eq '0' );
			$sended = '第'.$csvs[20]. '回' if($csvs[20] > 0 );
			
		}
		$main_table = <<"END";
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

function reStart(){
	
	if( document.form1.step.selectedIndex == 0 && document.form1.restart_flag.value == 1 ){
		return confir('配信を再開します。\\n更新後すぐに、該当のステップメールが送信されます。\\n\\nよろしいですか?');
	}
}

// -->
</script>
                              <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                              <td width="50">&nbsp;
                              </td>
                              <td width="400">
                              
                                <form action="$indexcgi" method="POST" name="form1">
                                <table  width="100%" border="0" cellspacing="0" cellpadding="4">
                                <tr>
                                <td width="450" colspan="2"><strong>登録者</strong>を$messageします
                                </td>
                                </tr>
                                <tr>
                                <td colspan="2">$message2
                                </td>
                                </tr>
                                <tr>
                                <td colspan="2">&nbsp;
                                </td>
                                </tr>
                                                <tr>
                                                  <td colspan="2" bgcolor="#FFCC66">▼配信情報</td>
                                                </tr>
END
		# 登録者追加
		if( $page eq 'add' ){
			$main_table .= <<"END";
                                                <tr>
                                                  <td width="25%">配信開始回</td>
                                                  <td widht=""><select name="step" onchange="Interval();">
                                                      $option
                                                    </select></td>
                                                </tr>
                                                 <tr><td colspan="2"><font color="#FF0000">※表\示されている配信日は、配信回を指定した際の開始日付です。</font><br>
                                                    </td></tr>
                                                <tr>
                                                <tr>
                                                  <td width="25%">配信開始日</td>
                                                  <td widht=""><input id="interval" type="text" name="interval" size="5" disabled style="background-color:#CCCCCC;">日後から開始</td>
                                                </tr>
                                                 <tr><td colspan="2"><font color="#FF0000">※再開時配信回を指定した場合は、入力してください。</font>
                                                    </td></tr>
                                                <tr>
                                                <tr>
                                                  <td>登録時メール</td>
                                                  <td widht=""><input name="res" type="radio" value="0">
                                                    送信する<br>
                                                    <input name="res" type="radio" value="1" checked="checked">
                                                    送信しない</td>
                                                </tr>
END
		}
		# 登録者編集
		if( $page eq 'ref' ){
			$main_table .= <<"END";
                                               <tr>
                                                  <td>メールアドレス</td>
                                                  <td widht="">$csvs[5]</td>
                                                </tr>
                                                <tr>
                                                  <td>配信済み回</td>
                                                  <td widht="">$sended</td>
                                                </tr>
                                                <tr>
                                                  <td width="25%">次回配信回</td>
                                                  <td widht=""><select name="step" onchange="Interval();">
                                                      $option
                                                    </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                  <td width="25%">配信開始日</td>
                                                  <td widht=""><input id="interval" type="text" name="interval" size="5" disabled style="background-color:#CCCCCC;">日後から開始</td>
                                                </tr>
                                                 <tr><td colspan="2"><font color="#FF0000">※再開時配信回を指定した場合は、入力してください。</font>
                                                    </td></tr>
                                                <tr>
END
		}
		# 登録者編集(一時待機)
		if( $page eq 'ref' && $csvs[52] > 0 ){
			$main_table .= <<"END";
                                                <tr>
                                                  <td>配信状態</td>
                                                  <td widht=""><input name="stop" type="radio" value="1" onclick="document.form1.restart_flag.value = 0" checked>
                                                    配信を再開しない
                                                    <br>
                                                    <input name="stop" type="radio" value="0" onclick="document.form1.restart_flag.value = 1">
                                                    配信を再開する</td>
                                                </tr>
END
		}
		# 登録者編集
		if( $page eq 'ref' ){
			$main_table .= <<"END";
												<tr><td colspan="2"><font color="#FF0000">$stop_message
												※表\示されている配信日は、配信回を変更した際の開始日付です。<br>
												※指定回によっては、配信時に複数のステップが送信されます。</font><br>
                                                </td></tr>
                                                <tr>
                                                  <td colspan="2"><input type="submit" name="stepInfo" value="　配信情報を更新する　" onclick="return reStart();">
                                                  <input type="reset" name="Submit2" value="元に戻す"><input type="hidden" name="restart_flag"></td>
                                                </tr>
END
		}
		$main_table .= <<"END";
                                                <tr>
                                                  <td>&nbsp;</td>
                                                  <td widht="">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2" bgcolor="#FFCC66">▼登録者情報</td>
                                                </tr>
                                <tr>
                                <td width="">登録者ID
                                </td>
                                <td widht="">$userid<input type="hidden" name="def_mail" value="$csvs[5]">
                                </td>
                                </tr>
                                <tr>
                                <td width="">会社名
                                </td>
                                <td widht=""><input type="text" name="co" value="$csvs[1]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>会社名フリガナ
                                </td>
                                <td><input type="text" name="_co" value="$csvs[2]" size="40">
                                </td>
                                </tr>

                                <tr>
                                <td>姓
                                </td>
                                <td><input type="text" name="sei" value="$csvs[37]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>姓フリガナ
                                </td>
                                <td><input type="text" name="_sei" value="$csvs[38]" size="40">
                                </td>
                                </tr>

                                <tr>
                                <td>名
                                </td>
                                <td><input type="text" name="mei" value="$csvs[39]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>名フリガナ
                                </td>
                                <td><input type="text" name="_mei" value="$csvs[40]" size="40">
                                </td>
                                </tr>

                                <tr>
                                <td>お名前<br><a href="#1"><font color="#FF0000">(※1)</font></a>
                                </td>
                                <td><input type="text" name="name" value="$csvs[3]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>お名前フリガナ<br><a href="#2"><font color="#FF0000">(※2)</font></a>
                                </td>
                                <td><input type="text" name="_name" value="$csvs[4]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>メールアドレス
                                </td>
                                <td><input type="text" name="mail" value="$csvs[5]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>電話番号
                                </td>
                                <td><input type="text" name="tel" value="$csvs[6]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>FAX番号
                                </td>
                                <td><input type="text" name="fax" value="$csvs[7]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>URL
                                </td>
                                <td><input type="text" name="url" value="$csvs[8]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>郵便番号
                                </td>
                                <td><input type="text" name="code" value="$csvs[9]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>都道府県
                                </td>
                                <td>$csvs[10]
                                    <select name="address" size="1"><option value=''>選択してください</option><option>北海道</option><option>青森県</option><option>岩手県</option><option>宮城県</option><option>秋田県</option><option>山形県</option><option>福島県</option><option>茨城県</option><option>栃木県</option><option>群馬県</option><option>埼玉県</option><option>千葉県</option><option>東京都</option><option>神奈川県</option><option>新潟県</option><option>富山県</option><option>石川県</option><option>福井県</option><option>山梨県</option><option>長野県</option><option>岐阜県</option><option>静岡県</option><option>愛知県</option><option>三重県</option><option>滋賀県</option><option>京都府</option><option>大阪府</option><option>兵庫県</option><option>奈良県</option><option>和歌山県</option><option>鳥取県</option><option>島根県</option><option>岡山県</option><option>広島県</option><option>山口県</option><option>徳島県</option><option>香川県</option><option>愛媛県</option><option>高知県</option><option>福岡県</option>
                                    <option>佐賀県</option><option>長崎県</option><option>熊本県</option><option>大分県</option><option>宮崎県</option><option>鹿児島県</option><option>沖縄県</option><option>全国</option><option>海外</option></select>
                                </td>
                                </tr>
                                <tr>
                                <td>住所１
                                </td>
                                <td><input type="text" name="address1" value="$csvs[11]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>住所２
                                </td>
                                <td><input type="text" name="address2" value="$csvs[12]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>住所３
                                </td>
                                <td><input type="text" name="address3" value="$csvs[13]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１
                                </td>
                                <td><input type="text" name="free1" value="$csvs[14]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２
                                </td>
                                <td><input type="text" name="free2" value="$csvs[15]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目３
                                </td>
                                <td><input type="text" name="free3" value="$csvs[16]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目４
                                </td>
                                <td><input type="text" name="free4" value="$csvs[17]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目５
                                </td>
                                <td><input type="text" name="free5" value="$csvs[18]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目６
                                </td>
                                <td><input type="text" name="free6" value="$csvs[22]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目７
                                </td>
                                <td><input type="text" name="free7" value="$csvs[23]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目８
                                </td>
                                <td><input type="text" name="free8" value="$csvs[24]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目９
                                </td>
                                <td><input type="text" name="free9" value="$csvs[25]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１０
                                </td>
                                <td><input type="text" name="free10" value="$csvs[26]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１１
                                </td>
                                <td><input type="text" name="free11" value="$csvs[27]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１２
                                </td>
                                <td><input type="text" name="free12" value="$csvs[28]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１３
                                </td>
                                <td><input type="text" name="free13" value="$csvs[29]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１４
                                </td>
                                <td><input type="text" name="free14" value="$csvs[30]" size="40">
                                </td>
                                </tr>
                                 <tr>
                                <td>フリー項目１５
                                </td>
                                <td><input type="text" name="free15" value="$csvs[31]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１６
                                </td>
                                <td><input type="text" name="free16" value="$csvs[32]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１７
                                </td>
                                <td><input type="text" name="free17" value="$csvs[33]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１８
                                </td>
                                <td><input type="text" name="free18" value="$csvs[34]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目１９
                                </td>
                                <td><input type="text" name="free19" value="$csvs[35]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２０
                                </td>
                                <td><input type="text" name="free20" value="$csvs[36]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２１
                                </td>
                                <td><input type="text" name="free21" value="$csvs[41]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２２
                                </td>
                                <td><input type="text" name="free22" value="$csvs[42]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２３
                                </td>
                                <td><input type="text" name="free23" value="$csvs[43]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２４
                                </td>
                                <td><input type="text" name="free24" value="$csvs[44]" size="40">
                                </td>
                                </tr>
                                 <tr>
                                <td>フリー項目２５
                                </td>
                                <td><input type="text" name="free25" value="$csvs[45]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２６
                                </td>
                                <td><input type="text" name="free26" value="$csvs[46]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２７
                                </td>
                                <td><input type="text" name="free27" value="$csvs[47]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２８
                                </td>
                                <td><input type="text" name="free28" value="$csvs[48]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目２９
                                </td>
                                <td><input type="text" name="free29" value="$csvs[49]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>フリー項目３０
                                </td>
                                <td><input type="text" name="free30" value="$csvs[50]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td colspan="2">&nbsp;
                                </td>
                                </tr>
$info
                                <tr>
                                <td colspan="2">$submit
                                </td>
                                </tr>
                                </table>
                                <input type="hidden" name="md" value="addguest">
                                <input type="hidden" name="n" value="$n" size="40">
                                <input type="hidden" name="id" value="$id">
                                </form>
                                         <br> 
                                        <table width="100%" border="0"> 
                                           <tr> 
                                             <td width="20" valign="top"><a name="1"></a><font color="#FF0000">※1</font></td><td>「姓」「名」項目をご利用の場合、データ管理上この項目データには「姓」「名」の入力データが自動的に登録されますが、システム利用上問題はございません。</td> 
                                           </tr> 
                                           <tr> 
                                             <td width="20" valign="top"><a name="2"></a><font color="#FF0000">※2</font></td><td>「姓フリガナ」「名フリガナ」項目をご利用の場合、データ管理上この項目データには「姓」「名」の入力データが自動的に登録されますが、システム利用上問題はございません。</td> 
                                           </tr>
                                        </table>                             
                              
                              </td>
                              </tr>
                              </table>
END
	}elsif ( $page eq 'up' ) {
		# ステップメール日程を取得
		my( $step, $script_array ) = &scheduleOption( $line[35], $line[36] );
		
		# 登録時自動配信実行確認
		my( $session, $target ) = &get_csvup_session( $id );
		my $sendtable;
		if( $session ne '' ){
			local( $method, $each, $sleep, $partition ) = &send_method( \@errors );
			if( $method ){
				my $sendtag;
				my $message;
				my $sendact;
				my $flag    = "$myroot$data_dir$csv_dir" . $session;
				unless( -e $flag ){
					# 配信フラグファイルを作成
					open(FLAG, ">$flag");
					close(FLAG);
					# 配信用IMGタグ作成
					$sendtag = &csvup_sendtag( $session );
					$sendact = qq|配信を開始しました。|;
					$message = qq|<br><br>この処理直後は「管理画面」のリンクをクリックした際の動作が重たくなる場合があります。その際は、もう一度該当のリンクをクリックしてください。|;
				}else{
					$sendact = qq|配信中です。|;
				}
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
       <tr>
        <td bgcolor="#FFFFFF"><font color="#FF0000"><strong>一覧アップロードより新規追加した登録者へ「登録時メール」をバックグラウンドで$sendact</strong>$message</font>$sendtag</td>
       </tr>
      </table>
    </td>
  </tr>
</table><br>　
END
			}else{
				open(LIST,$target);
				my $n = 0;
				while(<LIST>){
					$n++;
				}
				close(LIST);
				my $next = ( $each > $n )? $n: $each;
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
        <tr>
          <td bgcolor="#FFFFFF"><strong><font color="#FF0000">一覧アップロードより新規追加した登録者への登録時メール未配信分を送信してください。</font>(残り：$n件)</strong>
           <br><br><a href="$indexcgi?md=upsend&ss=$session"><font color="#0000FF">&gt;&gt;次の$next件を送信する</font></a><br><br>
           連続で配信を行いますと、ご利用のサーバの能\力によりましては大量配信により負荷が増加することにより配信エラーが生じる可能\性がございます。
           大量のリストを一括登録したり、ユーザーが多くなった状態での一括送信及び日付指定配信を行う場合はご利用者様の責任において慎重にお願いいたします。</td>
        </tr>
      </table>
    </td>
  </tr>
</table><br>　
END
			}
		}
		
		$main_table = <<"END";
$sendtable
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
                                          <td width="441"><form name="form1" method="post" action="$main'indexcgi" enctype="multipart/form-data">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                  <td><strong>CSVファイル</strong>よりデータを登録します。</td>
                                                </tr>
                                                <tr>
                                                  <td>アップロード方式を選択しCSVファイルをご指定後、「登録」ボタンをクリックしてください。</td>
                                                </tr>
                                                <tr align="center">
                                                  <td><br>
                                                    <table width="480" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td bgcolor="#666666"><table width="480" border="0" cellpadding="15" cellspacing="1">
                                                            <tr>
                                                              <td bgcolor="#FFFFFF">【CSVファイルを確実にアップロードするには以下の手順をお試しください】<br>
                                                                <br />
                                                                １） プランを作成<br />
                                                                ２） 登録用フォームのページで項目を設定<br />
                                                                ３） 「登録者情報」のページから「追加」をクリックし、全ての情報を入れて1件登録<br />
                                                                ４） 一覧をダウンロードでCSVファイルデータを取得<br />
                                                                ５） ４を参照に、データを追加して、CSVファイルデータを作成<br />
                                                                ６） ５を再アップロード<br />
                                                              </td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                    </table>
                                                    <br>
                                                    &nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td bgcolor="#FFFFE6"><table width="500" border="0" cellspacing="1" cellpadding="5">
                                                      <tr>
                                                        <td colspan="2" bgcolor="#FFE4CA">(１)アップロード方式</td>
                                                      </tr>
                                                      <tr>
                                                        <td width="20%" valign="top"><input name="addcheck" type="radio" value="1" />
                                                          追加アップロード<br />
                                                          <br /></td>
                                                        <td width="80%">CSVファイルのデータを新規登録します。<br>
                                                          <font color="#FF0000"><br>
                                                          <strong>※「登録者情報」に登録されているメールアドレスは削除されません。 </strong></font></td>
                                                      </tr>
                                                      <tr>
                                                        <td valign="top" nowrap><input name="addcheck" type="radio" value="0" />
                                                          上書きアップロード</td>
                                                        <td valign="top">CSVファイルのデータで「登録者情報」を上書きします。<br>
                                                          「登録者情報」に登録済みのデータは上書きされ、<br>
                                                          未登録のデータは新規登録されます。 <br>
                                                          <br>
                                                          <strong><font color="#FF0000">※CSVファイルデータに無いメールアドレスは「登録者情報」から削除されます。</font></strong></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><table width="450" align="center" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td bgcolor="#999999"><table width="450" border="0" cellpadding="10" cellspacing="1">
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF">【ご注意】<br>
                                                                      <br>
                                                                      「アップロード方式」の選択に関係なく、CSVファイルに重複して登録されているメールアドレスは、上位のメールアドレスを残し削除されます。<br>
                                                                      また、メールアドレス項目が空白のデータ行は無視されます。</td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" bgcolor="#FFE4CA">(２)重複して登録されているメールアドレスの削除</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><input name="dup" type="checkbox" id="dup" value="1" />
                                                          重複して登録されているメールアドレスを削除する</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" align="center"><table width="450" border="0" cellspacing="0" cellpadding="2">
                                                            <tr>
                                                              <td width="450">「上書きアップロード」でCSVファイルをアップロードする場合、「登録者情報」に重複して登録されているメールアドレスは上書き更新されません。<br>
                                                                重複して登録されているメールアドレスを上書き更新するためには、「登録者情報」から重複して登録されているメールアドレスを削除する必要があります。</td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><table width="450" align="center" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td bgcolor="#999999"><table width="450" border="0" cellpadding="10" cellspacing="1">
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF">【ご注意】<br>
                                                                      <br>
                                                                      「登録者情報」に重複して登録されているメールアドレスは、一番古い情報を残し削除されます。</td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" bgcolor="#FFE4CA">(３)配信回指定 (新規登録するユーザー)</td>
                                                      </tr>
                                                      <tr>
                                                        <td align="right">配信開始回</td>
                                                        <td><select name="step" onchange="Interval();">
                                                            $step
                                                          </select><br><font color="#FF0000">※配信日は配信回を指定した際の開始日付です。</font></td>
                                                      </tr>
                                                      <tr>
                                                        <td align="right">配信開始日</td>
                                                        <td><input id="interval" type="text" name="interval" size="5" disabled style="background-color:#CCCCCC;">日後から開始<br><font color="#FF0000">※再開時配信回を指定した場合は、入力してください。</font></td>
                                                      </tr>
                                                      <tr>
                                                        <td align="right" valign="top">登録時メール</td>
                                                        <td><input name="sendflag" type="radio" value="0" checked="checked">
                                                          送信しない<br>
                                                          <input name="sendflag" type="radio" value="1">
                                                          送信する</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><table width="450" border="0" align="center" cellpadding="2" cellspacing="0">
                                                            <tr>
                                                              <td><p>CSVファイルより新規登録した登録者へ登録時メールを配信することができます。<br>
                                                                <br>
                                                              </p>
                                                              </td>
                                                            </tr>
                                                          </table><table width="450" align="center" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td bgcolor="#999999"><table width="450" border="0" cellpadding="10" cellspacing="1">
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF"><p>【送信方法について】</p>
                                                                      <p>送信方法は「送信方式設定」の設定により決定されます。<br>
                                                                          <br>
                                                                        ○バックグラウンドでCGIが起動できるサーバーをご利用の場合<br>
                                                                        <br>
                                                                        「分割で送信する」に設定することで、一度の配信動作ですべての新規ユーザーへメールを送信することができます。 <br>
                                                                        また、その場合CGIが常時起動していても、サーバー側で強制的に切断されない必要があります。<br>
                                                                        <br>
                                                                        ○バックグラウンドでCGIが起動でないサーバーをご利用の場合<br>
                                                                        <br>
                                                                        「アクセス毎に送信する」に設定してください。<br>
                                                                        一度の送信動作で送信が完了しなかった場合、「一覧をアップロード」画面（この画面）より手動で送信を実行してください。</p></td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><table width="450" align="center" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td bgcolor="#999999"><table width="450" border="0" cellpadding="10" cellspacing="1">
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF"><strong><font color="#FF0000">【重要事項】</font></strong><br>
                                                                      <br>
                                                                      「楽メールPRO」はCGIプログラムであるため、動作は設置したサーバーの能\力に依存します。<br>
                                                                      サーバー側の制限や負荷などの影響で配信が中断される場合や配信エラーが生じる可能\性がございます。<br />
                                                                      大量のCSVファイルデータを一括登録したり、ユーザーが多くなった状態での一括送信を行う場合は、ご利用者様の責任において慎重にお願いいたします。</td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" bgcolor="#FFE4CA">(４)アップロードするCSVファイル指定</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><input type="file" name="csvfile" size="60" /></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" align="center"><table width="450" border="0" cellspacing="0" cellpadding="2">
                                                            <tr>
                                                              <td width="450">アップロードするCSVファイルを「参照」よりご指定ください。</td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" align="center"><input type="submit" name="Submit" value="　　　　登録　　　　" />
                                                          <input name="md" type="hidden" id="md" value="upload" />
                                                          <input name="id" type="hidden" id="id" value="$id" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" align="center">&nbsp;</td>
                                                      </tr>
                                                    </table></td>
                                                </tr>
                                              </table>
                                              <br>
                                              <br>
                                              <table  width="500" border="0" align="center" cellpadding="1" cellspacing="0">
                                                <tr>
                                                  <td bgcolor="#999999"><table width="500" border="0" cellpadding="5" cellspacing="0">
                                                      <tr>
                                                        <td bgcolor="#FFFFEC">【バックグラウンドでの送信が強制的に終了されてしまった場合】<strong><br>  
                                                          <br>
                                                        </strong>万一、負荷やその他サーバー制限等でバックグラウンド配信が強制的に終了されてしまった場合、以下の方法で
                                                          配信を再開することが出来ます。<br>
                                                          <br>
                                                          ○「送信方式」をアクセス毎送信に設定し、このページより手動で配信を行う。<br>
                                                          ○配信が中断された次回の「配信を実行する」ボタンより配信を行う。<br>
                                                          ○配信が中断された次回の自動配信タグのアクセスにより配信を行う。<br>
                                                          （配信設定マニュアル.html「配信専用ページの設定方法」を参照ください） <br>
                                                          <br>
                                                          <font color="#FF0000"> ※強制終了されないように、サーバースペックに合わせ「送信方式」を決定ください。<br>
                                                          ※配信再開までの間、他プランのステップメール等の配信に影響することはございません。<br>
                                                          ※配信が再開された場合、「登録時」メールが優先的に配信されます。<br>
                                                          ※強制終了の影響により、正常な配信が保障できない場合がございます。</font><br></td>
                                                      </tr>
                                                    </table></td>
                                                </tr>
                                              </table>
                                            </form></td>
                                          <td width="20">&nbsp;</td>
                                        </tr>
                                      </table>
END
	}elsif ( $page eq 'up_error' ){
		
		my( $session, $target ) = &get_csvup_session( $id );
		my $sendtable;
		if( $session ne '' ){
			local( $method, $each, $sleep, $partition ) = &send_method( \@errors );
			if( $method ){
				my $sendtag;
				my $message;
				my $sendact;
				my $flag    = "$myroot$data_dir$csv_dir" . $session;
				unless( -e $flag ){
					# 配信フラグファイルを作成
					open(FLAG, ">$flag");
					close(FLAG);
					# 配信用IMGタグ作成
					$sendtag = &csvup_sendtag( $session );
					$sendact = qq|配信を開始しました。|;
					$message = qq|<br><br>この処理直後は「管理画面」のリンクをクリックした際の動作が重たくなる場合があります。その際は、もう一度該当のリンクをクリックしてください。|;
				}else{
					$sendact = qq|配信中です。|;
				}
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
       <tr>
        <td bgcolor="#FFFFFF"><font color="#FF0000"><strong>一覧アップロードより新規追加した登録者へ「登録時メール」をバックグラウンドで$sendact</strong>$message</font>$sendtag</td>
       </tr>
      </table>
    </td>
  </tr>
</table><br><br>　
END
			}else{
				open(LIST,$target);
				my $n = 0;
				while(<LIST>){
					$n++;
				}
				close(LIST);
				my $next = ( $each > $n )? $n: $each;
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
        <tr>
          <td bgcolor="#FFFFFF"><strong><font color="#FF0000">一覧アップロードより新規追加した登録者への登録時メール未配信分を送信してください。</font>(残り：$n件)</strong>
           <br><br><a href="$indexcgi?md=upsend&ss=$session"><font color="#0000FF">&gt;&gt;次の$next件を送信する</font></a><br><br>
           連続で配信を行いますと、ご利用のサーバの能\力によりましては大量配信により負荷が増加することにより配信エラーが生じる可能\性がございます。
           大量のリストを一括登録したり、ユーザーが多くなった状態での一括送信及び日付指定配信を行う場合はご利用者様の責任において慎重にお願いいたします。</td>
        </tr>
      </table>
    </td>
  </tr>
</table><br><br>　
END
			}
		}
		
		my $message;
		my $rep = 0;
		# 重複登録済み
		if( $param{'mail_overlap'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_overlap'}} ){
				$sel .= qq|$_行目 $param{'mail_overlap'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|■「登録者情報」に重複して登録済みのメールアドレス<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# 形式不備
		if( $param{'mail_format'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_format'}} ){
				$sel .= qq|$_行目 $param{'mail_format'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|■メールアドレスの形式が正しくないと思われる行<br>　　(メールアドレスの前後にスペースや全角文字含まれているなど)<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# 重複
		if( $param{'mail_repeat'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_repeat'}} ){
				$sel .= qq|$_行目 $param{'mail_repeat'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|■CSVファイルに重複して登録されているメールアドレス行<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# 登録済み（追加の場合）
		if( $param{'mail_alr'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_alr'}} ){
				$sel .= qq|$_行目 $param{'mail_alr'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|■すでに登録済みのメールアドレス行<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# 登録不備があった場合
		if( $message ne '' ){
			$message = qq|以下のデータはエラーがあり、登録できませんでした。<br><br>$message|;
		}
		
		$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td align="center"><br><strong><font color="#FF0000">CSVファイルのアップロードが完了しました。</font></strong></td>
                                          </tr>
                                          <tr> 
                                            <td>$sendtable &nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$message</td>
                                          </tr>
                                           <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$rep_message</td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
		
    }elsif ( $page eq 'up_error' ){
		
		my( $session, $target ) = &get_csvup_session( $id );
		my $sendtable;
		if( $session ne '' ){
			local( $method, $each, $sleep, $partition ) = &send_method( \@errors );
			if( $method ){
				my $sendtag;
				my $message;
				my $sendact;
				my $flag    = "$myroot$data_dir$csv_dir" . $session;
				unless( -e $flag ){
					# 配信フラグファイルを作成
					open(FLAG, ">$flag");
					close(FLAG);
					# 配信用IMGタグ作成
					$sendtag = &csvup_sendtag( $session );
					$sendact = qq|配信を開始しました。|;
					$message = qq|<br><br>この処理直後は「管理画面」のリンクをクリックした際の動作が重たくなる場合があります。その際は、もう一度該当のリンクをクリックしてください。|;
				}else{
					$sendact = qq|配信中です。|;
				}
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
       <tr>
        <td bgcolor="#FFFFFF"><font color="#FF0000"><strong>一覧アップロードより新規追加した登録者へ「登録時メール」をバックグラウンドで$sendact</strong>$message</font>$sendtag</td>
       </tr>
      </table>
    </td>
  </tr>
</table><br><br>　
END
			}else{
				open(LIST,$target);
				my $n = 0;
				while(<LIST>){
					$n++;
				}
				close(LIST);
				my $next = ( $each > $n )? $n: $each;
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
        <tr>
          <td bgcolor="#FFFFFF"><strong><font color="#FF0000">一覧アップロードより新規追加した登録者への登録時メール未配信分を送信してください。</font>(残り：$n件)</strong>
           <br><br><a href="$indexcgi?md=upsend&ss=$session"><font color="#0000FF">&gt;&gt;次の$next件を送信する</font></a><br><br>
           連続で配信を行いますと、ご利用のサーバの能\力によりましては大量配信により負荷が増加することにより配信エラーが生じる可能\性がございます。
           大量のリストを一括登録したり、ユーザーが多くなった状態での一括送信及び日付指定配信を行う場合はご利用者様の責任において慎重にお願いいたします。</td>
        </tr>
      </table>
    </td>
  </tr>
</table><br><br>　
END
			}
		}
		
		my $message;
		my $rep = 0;
		# 重複登録済み
		if( $param{'mail_overlap'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_overlap'}} ){
				$sel .= qq|$_行目 $param{'mail_overlap'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|■「登録者情報」に重複して登録済みのメールアドレス<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# 形式不備
		if( $param{'mail_format'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_format'}} ){
				$sel .= qq|$_行目 $param{'mail_format'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|■メールアドレスの形式が正しくないと思われる行<br>　　(メールアドレスの前後にスペースや全角文字含まれているなど)<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# 重複
		if( $param{'mail_repeat'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_repeat'}} ){
				$sel .= qq|$_行目 $param{'mail_repeat'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|■CSVファイルに重複して登録されているメールアドレス行<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# 登録済み（追加の場合）
		if( $param{'mail_alr'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_alr'}} ){
				$sel .= qq|$_行目 $param{'mail_alr'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|■すでに登録済みのメールアドレス行<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# 登録不備があった場合
		if( $message ne '' ){
			$message = qq|以下のデータはエラーがあり、登録できませんでした。<br><br>$message|;
		}
		
		$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td align="center"><br><strong><font color="#FF0000">CSVファイルのアップロードが完了しました。</font></strong></td>
                                          </tr>
                                          <tr> 
                                            <td>$sendtable &nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$message</td>
                                          </tr>
                                           <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$rep_message</td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
		
	}elsif ( $page eq 'mf1' || $page eq 'mf2' || $page eq 'mf3' || $page eq 'sprev' ) {
		# 登録用フォームのソースを表示
		my @data;
		my $type;
		my $url;
		if ( $page eq 'mf1'|| $page eq 'sprev' ) { @data = @line[15 .. 32, 43 .. 57, 61 .. 65, 66 .. 75]; $type = 'form1'; $url = $line[12]; }
		elsif ( $page eq 'mf2' ) { @data = $line[33]; $type = 'form2';  $url = $line[13]; }
		elsif ( $page eq 'mf3' ) { @data = $line[34]; $type = 'form3';  $url = $line[14]; }
		my( $source, $source_m ) = &make_form( 0, $id, $type, $url, $line[39], $line[58], $line[59], $line[81], @data );
		
		if( $page eq 'sprev' ){
			my $display = ( $param{'m'} )? $source_m: $source;
			$display =~ s/type\=[\"|\']?submit[\"|\']?/type=\"button\" /gi;
			$display =~ s/onclick\=[\"|\']?.+[\"|\'\\s]?(.*)>/$1>/ig;
			print <<"END";
Content-type: text/html

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis" />
</head>
<body>
$display
</body>
</html>
END
			exit;
		}
		
		$source = &deltag( $source );
		$source_m = &deltag( $source_m );
        $main_table = <<"END";
                                <table width="100%" cellpadding="3" cellspacing="0" border="0">
                                <tr>
                                <td>以下のソ\ースを<strong>任意のHTMLファイル内</strong>にコピーして使用してください
                                </td>
                                </tr>
                                <tr>
                                  <td>&nbsp;</td>
                                </tr>
                                <tr>
                                  <td bgcolor="#FFCC66">▼PC専用サンプルHTMLソ\ース</td>
                                </tr>
                                <tr>
                                <td>
                                <textarea cols="60" rows="20" onFocus="this.select();">
$source</textarea>
                                </td>
                                </tr>
                                <tr>
                                  <td>&nbsp;</td>
                                </tr>
                                <tr>
                                  <td bgcolor="#FFCC66">▼携帯専用サンプルHTMLソ\ース</td>
                                </tr>
                                 <tr>
                                  <td><font color="#FF0000">※全ての携帯で動作を保証するものではありません。</font></td>
                                </tr>
                                <tr>
                                <td>
                                <textarea cols="60" rows="20" onFocus="this.select();">
$source_m</textarea></td>
                                </tr>
                                <tr>
                                </table>
<br><br>
<TABLE cellSpacing="0" cellPadding="5" width="500" border="0">
  <TBODY>
    <TR>
      <TD bgcolor="#FFCC66">○登録・変更・解除完了画面を同一ウィンドウで表\示するには</TD>
    </TR>
    <TR>
      <TD bgcolor="#FFFFEE">
	<font color="#FF0000">■「登録設定」で完了時URLを入れている場合</font><br>
	　同一ウィンドウで確認画面・完了画面を表\示します。<br>
	<br>
	<font color="#FF0000">■「登録設定」で完了時URLを入れていない場合</font><br>
	　ポップアップウインドウにて確認画面・完了画面を表\示します。<br>
	　その場合、同一ウインドウでの表\示切り替え方法は以下の通りです。<br>
	１）<br>
        <strong>&lt;form name=&quot;form1&quot; method=&quot;post&quot; action=&quot;URL&quot; target=&quot;new&quot;&gt;</strong><br>
        上記の行の、<br>
        <font color="#FF0000">target=&quot;new&quot;</font><br>
        この部分を削除してください。<br>
        <br>
        ２）<br>
        <strong>&lt;input type=&quot;submit&quot;   value=&quot;　登録　&quot;<br>
        onClick=&quot;window.open('','new','height=300,width=500,scrollbars=yes');&quot;&gt;</strong><br>
        上記の行の、<br>
        <font color="#FF0000">onClick=&quot;window.open('','new','height=300,width=500,scrollbars=yes');&quot;</font><br>
        この部分を削除してください。<br></TD>
    </TR>
    <TR>
      <TD bgcolor="#FFCC66">○その他フォームに関する注意事項</TD>
    </TR>
    <TR>
      <TD bgcolor="#FFFFEE">１．&lt;%***%&gt;と記述されている箇所は編集・削除しないでください。<br>
        ２．&lt;form&gt;   ～ &lt;/form&gt;内に&lt;form&gt;は入れないでください。<br>
        ３．&lt;input   name=&quot;***&quot;　～&gt;の「name=&quot;***&quot;」部分は編集・削除しないでください。<br>
        ４．サンプルのHTMLソ\ースで生成される項目以外のデータはご利用いただけません。<br>
        ５．ホームページビルダーの自動修正機能\を停止してください。</TD>
    </TR>
  </TBODY>
</TABLE>

END
	}elsif ( $page eq 'preview' || $page eq 'body' || $page eq 'html' ) {
		#-------------------------------------
		# 本文のプレビュー、更新
		#-------------------------------------
		my $n = &delspace( $param{'n'} );
		$n -= 0 if ( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );# ra 個別設定
		my $num = $n+1;
		$num = ($n>0)? "第$num回": '登録時';
		$num = '変更時' if( $n eq 'r' );
		$num = '解除時' if( $n eq 'c' );
		$num = '登録時(管理者通知専用)' if( $n eq 'ra' );
		if ( $n =~ /^d(\d+)/ ) {
			my $mon = substr($n, 1, 2 ) - 0;
			my $day = substr($n, 3, 2 ) - 0;
			$num = $mon . '月' . $day . '日';
		}
		
		if( $n =~ /^\d+$/ ){
			# 簡易タグ修正（転送アドレス）
			&remakeTag( $id );
		}
		
		
		# 個別設定の利用
		my $ra_conf = $line[77] - 0;
		
		my $file = $myroot . $data_dir . $queue_dir . $line[7];
		unless ( open(BODY, $file) ) {
			&make_plan_page( 'plan', '', "システムエラー<br><br>$fileが開けません<br>パーミッションを確認してください");
		}
		my ( $index, $h, $c, $body, $f, $ctype, $filename );
		local $btitle;
		while( <BODY> ) {
			chomp;
			( $index, $btitle, $h, $c, $body, $f, $ctype, $filename ) = split(/\t/);
			last if ( $index eq $n );
			( $index, $btitle, $h, $c, $body, $f, $ctype, $filename ) = undef;
		}
		if ( $page eq 'preview' ) {
			
			# 転送
			$body = &Click'prev1( $id, $body ) if( $n =~ /^\d+$/ );
			
			$btitle = &make_text( $btitle );
			$btitle = &reInclude( $btitle );
			$btitle = &include( \@temdata, $btitle, '', 1 );
			
			my $header = &include(\@temdata, &reInclude(&make_text($line[9])), '', 1)  if ( $h );
			my $cancel = &include(\@temdata, &reInclude(&make_text($line[10])), '', 1)  if ( $c );
			my $footer = &include(\@temdata, &reInclude(&make_text($line[11])), '', 1)  if ( $f );
			
			$body = &make_text( $body );
			$body = &reInclude( $body );
			$body = &include( \@temdata, $body, '', 1 );
			
			# 転送変換(プレビュー用)
			$body = &Click'prev2( $body ) if( $n =~ /^\d+$/ );
			
			my $estab    = ( $ctype )? 'HTML形式':  'テキスト形式';
			my $prevhtml = ( $filename eq '' )? '設定されていません。': qq|<a href="$indexcgi?md=htmlprev&id=$id&n=$n" target="_blank"><font color="#0000FF">HTMLファイルのプレビュー</font></a>|;
			
			# 登録時別設定
			if( $n eq '0' ){
				$sub_link_r = qq|<a href="$main'indexcgi?md=p&n=ra&id=$id"><font color="#0000FF">&gt;&gt;【管理者通知専用】本文を見る</font></a><br>&nbsp;|;
			}
			if( $n eq 'ra' ){
				$sub_link_r = qq|<a href="$main'indexcgi?md=p&n=0&id=$id"><font color="#0000FF">&gt;&gt;通常の【登録時】本文を見る</font></a><br>&nbsp;|;
				my $conf = ( $ra_conf )? 'する': 'しない';
				$sub_radio = qq|<tr><td bgcolor="#EEEEEE">利用</td><td>$conf</td></tr><tr><td colspan="2">&nbsp;</td></tr>|;
			}
			
			
			$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="499"><table width="100%" border="0" cellspacing="0" cellpadding="2">
                                        <tr> 
                                          <td colspan="2"><strong>本文のプレビュー[ $num ] </strong>を表\示しています</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2">編集する場合は「<strong>編集する</strong>」ボタンをクリックしてください</td>
                                        </tr>
                                        <tr>
                                          <td colspan="2">$sub_link_r&nbsp;</td>
                                        </tr>
       $sub_radio
	                                    <tr> 
                                          <td width="64" bgcolor="#EEEEEE">題名</td>
                                          <td width="435">$btitle</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#EEEEEE">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td valign="top" bgcolor="#EEEEEE">ヘッダー</td>
                                          <td>$header</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#EEEEEE">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td valign="top" bgcolor="#EEEEEE">本文</td>
                                          <td>$body</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#EEEEEE">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td valign="top" bgcolor="#EEEEEE">解除案内</td>
                                          <td>$cancel</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#EEEEEE">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td valign="top" bgcolor="#EEEEEE">フッター</td>
                                          <td>$footer</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#EEEEEE">HTML形式</td>
                                          <td>$prevhtml</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#EEEEEE">既定形式</td>
                                          <td><font color="#FF0000">$estab</font> に設定されています。</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr align="center"> 
                                          <td colspan="2"><form action="$indexcgi" method="post" name="" id="">
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="n" type="hidden" id="n" value="$n">
                                              <input name="md" type="hidden" id="md" value="ml">
                                              <input type="submit" name="Submit" value="　編集する　">
                                            </form></td>
                                        </tr>
                                        <tr>
                                          <td colspan="2" bgcolor="#FFFFFF"><em><font color="#336600">&lt;項目名&gt;</font></em> ・・各登録者情報の入力値および専用のデータに変換されます。<br>
                                            <font color="#FF0000">※「送信テスト」の本文でも&lt;項目名&gt;と変換され送信されます。</font></td>
                                        </tr>
                                      </table></td>
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
END
		}elsif( $page eq 'body' ){
            # 本文編集
			$h = 'checked' if ( $h );
			$c = 'checked' if ( $c );
			$f = 'checked' if ( $f );
			
			# テキスト形式 or HTML形式
			my $_text = ( !$ctype )? 'checked': '';
			my $_html = ( $ctype )? 'checked': '';
			$btitle = &make_text( $btitle );
			$body =~ s/<br>/\n/gi;
			$body = &make_text( $body );
			$main_table = &form_mailbody_top( $h, $c, $f, $_text, $_html, $num, $btitle, $body, $n, $id, $ra_conf );
		}elsif( $page eq 'html' ){
			$main_table = &form_mailbody_html( $h, $c, $f, $_text, $_html, $num, $btitle, $body, $n, $id, $filename );
		}
	} elsif ( $page eq 'schedule' ) {
        # プランの日程
		$main_table = &make_schedule( $id, 1, $line[35], $line[36] );
	} elsif ( $page eq 'guest' ) {
        # 登録者情報
        $main_table = &make_guest_table( $id, $line[6] );
    } elsif ( $page eq 'mail' ) {
		
		&Simul'running();
		
		# 簡易タグ修正（転送アドレス）
		&remakeTag( $id );
		
        # 登録者へのメール作成
		my $btitle = &main'deltag( $main'param{'title'} );
		my $body = &main'the_text( $main'param{'body'} );
		$body  = &main'make_text( $body );
		$body =~ s/<br>/\n/gi;
		my $h = ' checked="checked"' if( $main'param{'header'} );
		my $c = ' checked="checked"' if( $main'param{'cancel'} );
		my $f = ' checked="checked"' if( $main'param{'footer'} );
		
		my $cdn;
		my $method_bg;
		my $method_ma;
		my $search;
		my $cdn_table;
		my $hidden;
		my $cdn_sid;
		my $cdn_filepath;
		my $rebody = 0;
		my $method = 1;
		my $set_mode = 'mailnext';
		if( $param{'md'} eq 'simul_cdn_set' ){
			$method = $main'param{'method'} -0;
			( $cdn_sid, $cdn_filepath ) = &Simul'cdn_session();
			( $search, $cdn_table, $hidden ) = &Simul'cdn_prop( $id, [@line] );
			$set_mode = 'simul_cdn_conf';
			$rebody = 1;
		}
		$method_bg = ' checked="checked"' if( $method );
		$method_ma = ' checked="checked"' if( !$method );
		
		$simul_src = 'http://' . $ENV{'SERVER_NAME'} .  $ENV{'SCRIPT_NAME'} . '?md=slch';
        $main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="500"><table width="500" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="500"> <form name="form1" method="post" action="$indexcgi">
                                              <table width="490" border="0" cellspacing="0" cellpadding="2">
                                                <tr> 
                                                  <td colspan="2" width="450"><strong>本文</strong>を作成します。<br><br>
配信プランとは別に、臨時にメールを配信する場合に、「登録者へメール送信」を使用してください。<br><br>
<font color="FF0000">
※「登録者へメール送信」では、<strong>ＨＴＭＬ形式メール</strong>は非対応となっております。<br>
　 ＨＴＭＬメールを一斉送信したい場合は、<strong>「日付指定配信」</strong>をご利用ください。
</font>
                                                  </td>
                                                </tr>
 
                                                <tr> 
                                                  <td colspan="2"><br>入力後、「<strong>次へ</strong>」ボタンをクリックしてください</td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td width="70">題名</td>
                                                  <td width="420"><input name="title" type="text" id="title" value="$btitle" size="50"></td>
                                                </tr>
                                                <tr> 
                                                  <td>ヘッダー</td>
                                                  <td><input name="header" type="checkbox" id="header" value="1" $h>
                                                    挿入する</td>
                                                </tr>
                                                <tr>
                                                  <td>&nbsp;</td>
                                                  <td bgcolor="#FFFFE1"><font color="#FF0033">※簡易タグ</font>
                                                  <select onchange="this.form.convtag.value = this.value;">$mail_reflect_tag</select>&nbsp;<input type="text" style="background-color:#EEEEEE" name="convtag" size="15" onfocus="this.select();">
                                                  </td>
                                                </tr>
                                                <tr> 
                                                  <td>本文</td>
                                                  <td width="400"><textarea name="body" cols="50" rows="20" id="body">$body</textarea></td>
                                                </tr>
                                                <tr> 
                                                  <td>解除案内</td>
                                                  <td><input name="cancel" type="checkbox" id="cancel" value="1" $c>
                                                    挿入する</td>
                                                </tr>
                                                <tr> 
                                                  <td>フッター</td>
                                                  <td><input name="footer" type="checkbox" id="footer" value="1" $f>
                                                    挿入する</td>
                                                </tr>
   <tr>
    <td colspan="2"><br><br>
    ▼ 配信方法を選択してください
<table width="450" border="0" cellspacing="1" cellpadding="5">
  <tr>
    <td colspan="2" valign="top" nowrap="nowrap" bgcolor="#FFFFFF"><input name="method" type="radio" value="1"$method_bg />
バックグラウンドで配信する(※)</td>
  </tr>
  <tr>
    <td width="70" valign="top" nowrap="nowrap" bgcolor="#FFFFFF">&nbsp;</td>
    <td width="350" valign="top" nowrap="nowrap" bgcolor="#FFFFFF">「送信方式設定」の「分割で送信する」で設定された方法での自動送信方式</td>
  </tr>
  <tr>
    <td colspan="2" valign="top" nowrap="nowrap" bgcolor="#FFFFFF"><input name="method" type="radio" value="0"$method_ma />
手動で配信する</td>
  </tr>
  <tr>
    <td width="70" valign="top" nowrap="nowrap" bgcolor="#FFFFFF">&nbsp;</td>
    <td width="350" bgcolor="#FFFFFF">「送信方式設定」の「アクセス毎に送信する」で設定された件数毎にクリックする必要のある手動送信方式</td>
  </tr>
  <tr>
    <td colspan="2">
	 <table width="400"align="center"><tr><td>※必須条件<br>
      ▼バックグラウンドでCGIの起動ができるサーバーであること。<br>
      ▼CGIが常時起動していても、サーバー側で強制的に切断されないこと。</td></tr></table></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" bgcolor="#FFFFE1"><br>
<p>■配信制限および仕様について</p>
<font color="#FF0000">一斉送信実行中は、その他すべてのプランを含めて、一斉メール送信の実行は<br>行えません。<br>
<br>「楽メールPRO」はCGIプログラムであるため、動作は設置したサーバーの能\力に依存します。<br>
サーバー側の制限や負荷などの影響で配信が中断される場合や配信エラーが生じる可能\性がございます。<br>
ご使用のサーバースペックに合わせ、ご利用者様の責任において慎重にお願いいたします。</font><br><br>

<p>■バックグラウンド配信が強制的に終了されてしまった場合</p>

万一負荷やその他サーバー制限等でバックグラウンド配信が強制的に終了されてしまった場合、以下の方法で
配信を再開することが出来ます。<br><br>

○次回のログイン時に自動的に再開されます。<br>
○ログイン中の場合、このページにアクセスすることで再開されます。<br>
○配信再開用のimgタグを貼\り付けたページにアクセスすることで再開されます。<br><br>

＜imgタグについて＞
<br>以下タグを任意ページの&lt;body&gt;内に貼\り付けてください。<br>
<strong>&lt;img src="$simul_src" border="0" width="1" height="1"&gt;</strong><br>
(※実際は、改行を含めない)
<br><br>
<font color="#FF0000">
※強制終了されないように、サーバースペックに合わせ「送信方式」を<br>　 決定してください。<br>
※配信再開までの間、ステップメール等の配信に影響することはございません。<br>
※強制終了の影響により、正常な配信が保障できない場合がございます。</font><br><br>
　    </td>
  </tr>
</table>
    </td>
  </tr>
                                                <tr> 
                                                  <td colspan="2" align="left"> <br><br>
                                                    <input name="id" type="hidden" id="id" value="$id">
                                                    <input name="md" type="hidden" id="md" value="$set_mode">
                                                    <input type="submit" value="　　　次へ　　　"></td>
$hidden
                                                    <input name="cdn_sid" type="hidden" id="cdn_sid" value="$cdn_sid">
                                                    <input name="rebody" type="hidden" id="rebody" value="$rebody">
                                                </tr>
                                              </table>
                                            </form></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table>
END
    }elsif ( $page eq 'mailnext' ) {
		
		# 一意のユニークIDを生成
		my $uniq = crypt( $$, &make_salt() );
		
		# 配信方法
		my $method = $param{'method'} -0;
		my $method_mes = ( $method )? 'バックグラウンド配信': '手動配信';
		
	 	&Simul'background_check() if( $method );
		&Simul'running();
        # 登録者へのメール送信選択
		my @csvs = &get_csvdata( $id );
		
		#my $btitle = &deltag( &include( \@temdata, $param{'title'} ) );
		my $btitle = &make_text( $param{'title'} );
		$btitle = &reInclude( $btitle );
		$btitle = &include( \@temdata, $btitle, '', 1 );
		
		
		my $_btitle = &deltag( $param{'title'} );
		my $body = &the_text( $param{'body'} );
		$body  = &make_text( $body );
		
		# 転送変換
		$pbody = &Click'prev1( $id, $main'param{'body'} );
		
		$pbody = &make_text( $pbody );
		$pbody = &reInclude( $pbody );
		$pbody = &include( \@temdata, $pbody, '', 1 );
		$pbody =~ s/\n/<br \/>/ig;
		
		# 転送変換(プレビュー用)
		$pbody = &Click'prev2( $pbody );
		
		#$pbody = &include( \@temdata, $param{'body'} );
		#$pbody = &the_text( $pbody );
		#$pbody = &make_text( $pbody );
		my $header  = $line[9] if ($param{'header'});
		my $cancel  = $line[10] if ($param{'cancel'});
		my $footer  = $line[11] if ($param{'footer'});
		
		$header = &make_text( $header );
		$header = &reInclude( $header );
		$header = &include( \@temdata, $header, '', 1 );
		
		$cancel = &make_text( $cancel );
		$cancel = &reInclude( $cancel );
		$cancel = &include( \@temdata, $cancel, '', 1 );
		
		$footer = &make_text( $footer );
		$footer = &reInclude( $footer );
		$footer = &include( \@temdata, $footer, '', 1 );
		
		my $table;
		my $ed;
		my $count;
        foreach ( @csvs ) {
			if( $count >= 1000 ){
				$count = 0;
				select(undef, undef, undef, 0.20);
			}
			$count++;
            chomp;
            my ( $index, $name, $mail ) = ( split(/\t/) )[0, 3, 5];
			next if( index($ed, $mail) >= 0 );
			$ed .= "#$mail";
            $name = &make_text( $name );
            $name = '&nbsp;' if ( $name eq '' );
            $mail = &make_text( $mail );
            $table .= <<"END";
                                   <tr>
                                    <td align="center"><input type="checkbox" name="sm$index" value="1">
                                    </td>
                                    <td>$mail
                                    </td>
                                    <td>$name
                                    </td>
                                    </tr>
END
        }
        $main_table = <<"END";
                               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                <td width="20">&nbsp;</td>
                                <td width="450"">
                                  <form action="$indexcgi" method="POST">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                  <tr> 
                                  <td>$btitle</td>
                                  </tr>
                                  <tr>
                                  <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                  <td>$header</td>
                                  </tr>
                                  <tr> 
                                  <td>$pbody</td>
                                  </tr>
                                  <tr> 
                                  <td>$cancel</td>
                                  </tr>
                                  <tr> 
                                  <td>$footer</td>
                                  </tr>
                                  <tr> 
                                  <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                  <td>配信方法： $method_mes  <input type="hidden" name="method" value="$method"></td>
                                  </tr>
                                         <tr>
                                          <td bgcolor="#FFFFFF" align="right"><br><em><font color="#336600">&lt;項目名&gt;</font></em> ・・各登録者情報の入力値および専用のデータに変換されます。<br>
                                            <font color="#FF0000">※管理者宛へ送信する本文でも&lt;項目名&gt;と変換され送信されます。</font><hr></td>
                                        </tr>
                                  <tr>
                                  <td><strong>▼送信する登録者を選択してください。</strong><br><font color="#FF0000">（※重複して登録されているメールアドレスへは１通のみ送信します）</font>
                                  </td>
                                  </tr>
                                  <tr>
                                  <td><input type="submit" name="simul_cdn" value="　条件を指定して配信する　"><br>
 <input type="radio" name="all" value="0" checked>すべての登録者に送信する<br>
 <input type="radio" name="all" value="1">チェックした登録者に送信する<br>
 <input type="radio" name="all" value="2">チェックした登録者以外に送信する
                                  </td>
                                  </tr>
                                  <tr>
                                  <td width="450">
                                    
                                    <table width="100%" border="1" cellspacing="0" cellpadding="2">
                                    <tr>
                                    <td width="26" align="center">選択
                                    </td>
                                    <td width="140">メールアドレス
                                    </td>
                                    <td width="90">お名前
                                    </td>
                                    </tr>
                                    $table
                                    </table>
                                  </td>
                                  </tr>
                                  <tr>
                                  <td><input type="submit" value="　送信する　" onClick="return confir('送信しますか？');">
                                  </td>
                                  </tr>
                                  </table>
                                  <input type="hidden" name="md" value="mailsend">
                                  <input type="hidden" name="id" value="$id">
                                  <input type="hidden" name="title" value="$_btitle">
                                  <input type="hidden" name="header" value="$param{'header'}">
                                  <input type="hidden" name="cancel" value="$param{'cancel'}">
                                  <input type="hidden" name="body" value="$body">
                                  <input type="hidden" name="footer" value="$param{'footer'}">
                                  <input type="hidden" name="uniq" value="$uniq">
                                  </form>
                                
                                </td>
                                </tr>
                                </table>
END
	}elsif ( $page eq 'simul_cdn' ){
		$main_table = &Simul'cdn_form( @line );
	}elsif ( $page eq 'simul_cdn_conf' ){
		$main_table = &Simul'cdn_conf( @line);
    }elsif ( $page eq 'log' ) {
        $main_table = &make_log_table( $id, $line[6], $line[8] );
    }elsif ( $page eq 'error' || $page eq 'send' ) {
        $main_table = <<"END";
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr><td>&nbsp;</td></tr>
                                <tr><td>&nbsp;</td></tr>
                                <tr>
                                <td align="center">$error
                                </td>
                                </tr>
                                </table>
END
    }
	
	elsif( $page eq 'delete' ){
		
		$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="499"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="523"> <form action="index.cgi" method="post" enctype="multipart/form-data" name="form1">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                                <tr> 
                                                  <td width="515">この配信プランを削除します。</td>
                                                </tr>
                                                <tr>
                                                  <td>この配信プランに関連してすべてのデータが削除されます。<br>
                                                    また、データの復元もできません。</td>
                                                </tr>
                                                <tr>
                                                  <td>&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td align="center"> 
                                                    <input name="action" type="hidden" id="action" value="delete">
                                                    <input name="id" type="hidden" id="id" value="$id"> 
                                                    <input name="md" type="hidden" id="md" value="text"> 
                                                    <input type="submit" value="　削除する　" onClick="return confirmation();"></td>
                                                </tr>
                                              </table>
                                            </form></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table>
END
		
	}
	
	# まぐまぐ登録画面
	elsif( $page eq 'magu' ){
		$main_table = &Magu::Form();
	}
	
	# 画面カスタマイズ
	elsif( $page eq 'ctm_regdisp' ){
		$main_table = &Ctm::Form( $line[60], [@line] );
	}
	# 画面プレビュー
	elsif( $page eq 'ctm_regprev' ){
		&Ctm::Prev(  $line[60], [@line] );
	}
	# プランコピー
	elsif( $page eq 'copy' ){
		$main_table = &Copy::form( '', $line[35], $line[36] );
	}
	# クリック分析
	elsif( $page eq 'click_analy' ){
		$main_table = &Click::page( $line[82] );
	}
	
	#--------------------------------------#
	# メニューとメイン部分のテーブルを結合 #
	#--------------------------------------#
	if ( $type eq 'plan' ) {
		my $csvcheck = &make_guest_table( $id, $line[6], 1 ); # 登録者の有無を確認
		if ( $csvcheck > 0 ){
			$maillink = <<"END";
<tr> 
  <td align="center" bgcolor="#eeffe6">&nbsp;</td>
  <td width="117" bgcolor="#eeffe6"><a href="$indexcgi\?md=mail&id=$id"><font color="#FF9900">登録者へメール送信</font></a></td>
</tr>
END
		}
		$table = <<"END";
              <table width="100%" border="0" cellspacing="5" cellpadding="0">
                <tr> 
                  <td width="700"><br>
                    プランの編集 &gt; <strong>$pname</strong>　 $auterun 　　　[ $runlink ]　　 $sendtag</a><hr noshade> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="141" height="100%" valign="top"> 
                          <table width="132" border="0" cellpadding="3" cellspacing="0">
                            <tr> 
                              <td colspan="2" align="center" bgcolor="#b1cca3">メニュー</td>
                            </tr>
                            <tr> 
                              <td width="3" align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi\?md=all&id=$id"><font color="#FF9900">詳細</font></a></td>
                            </tr>
                            <tr>
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td bgcolor="#eeffe6"><a href="$indexcgi\?md=log&id=$id"><font color="#FF9900">配信ログ</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi\?md=bs&id=$id"><font color="#FF9900">配信元情報</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=l&id=$id"><font color="#FF9900">配信日程・本文</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=header&id=$id"><font color="#FF9900">ヘッダー</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td bgcolor="#eeffe6"><a href="$indexcgi?md=cl&id=$id"><font color="#FF9900">解除案内</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=footer&id=$id"><font color="#FF9900">フッター</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=redirect&id=$id"><font color="#FF9900">登録設定</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=form1&id=$id"><font color="#FF9900">登録用フォーム</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=form2&id=$id"><font color="#FF9900">変更・解除フォーム</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=ctm_regdisp&id=$id&act=top"><font color="#FF9900">画面カスタマイズ</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi\?md=g&id=$id"><font color="#FF9900">登録者情報</font></a></td>
                            </tr>
                            $maillink
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=copy&id=$id"><font color="#FF9900">コピープラン作成</font></a></td>
                            </tr>
                            <tr>
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=f_magu&id=$id"><font color="#FF9900">まぐまぐ登録機能\</font></a></td>
                            </tr>
                            <tr>
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=click_analy&id=$id"><font color="#FF9900">クリック分析・計測</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=confdel&id=$id"><font color="#FF9900">このプランを削除</font></a></td>
                            </tr>
                          </table>
                        </td>
                        <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="3">
                            <tr> 
                              <td width="199" align="center"><a href="#" onClick="history.back();"><font color="#0000FF">戻る</font></a></td>
                              <td width="348" align="center" bgcolor="#FF9900"><strong>$main_title</strong></td>
                            </tr>
                            <tr> 
                              <td colspan="2">$main_table</td>
                            </tr>
                          </table> </td>
                      </tr>
                    </table></td>
                </tr>
              </table>
END
	}
	&html_main($table, $help);
	exit;
}

#------------------------------------------------------------#
# タイトルのメニュ－リンクからのページを作成                 #
#------------------------------------------------------------#
sub make_page {
	my ( $type, $err, $run, $load, $simul ) = @_;
	my $table;
	if ( $type eq 'new' ) {
		$table = <<"END";
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><form name="form1" method="post" action="$indexcgi">
                            <br>
                            <strong>プランを新規作成します</strong> 
                            <hr noshade>
                            <table width="663" border="0" cellpadding="5" cellspacing="0">
                              <tr bgcolor="#FF9900"> 
                                <td colspan="2"><strong><font color="#FFFFFF">配信プラン名と配信日程</font></strong></td>
                              </tr>
                              <tr bgcolor="#e5f6ff"> 
                                <td width="107" align="center" bgcolor="#FFFFCC">プラン名 
                                </td>
                                <td bgcolor="#FFFFCC"> 
                                  <input name="p_title" type="text" id="p_title2" size="50">
                                  <font color="#CC0000">※識別名です</font> </td>
                              </tr>
                              <tr bgcolor="#e5f6ff"> 
                                <td width="107" align="center" bgcolor="#FFFFCC">配信回数</td>
                                <td width="536" bgcolor="#FFFFCC"> 
                                  <select name="count" id="count">
                                    <option value="0">-- 選択してください --</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                    <option value="13">13</option>
                                    <option value="14">14</option>
                                    <option value="15">15</option>
                                  </select>
                                </td>
                              </tr>
                              <tr bgcolor="#e5f6ff"> 
                                <td width="107" align="center" bgcolor="#FFFFCC">配信間隔</td> 
                                <td bgcolor="#FFFFCC">
                                  <select name="interval" id="interval">
                                    <option value="0">-- 選択してください --</option>
                                    <option value="1">1日後</option>
                                    <option value="2">2日後</option>
                                    <option value="3">3日後</option>
                                    <option value="4">4日後</option>
                                    <option value="5">5日後</option>
                                    <option value="6">6日後</option>
                                    <option value="7">7日後</option>
                                    <option value="8">8日後</option>
                                    <option value="9">9日後</option>
                                    <option value="10">10日後</option>
                                  </select>
                                </td>
                              </tr>
                              <tr bgcolor="#e5f6ff"> 
                                <td align="center" bgcolor="#FFFFCC">&nbsp;</td>
                                <td bgcolor="#FFFFCC"><font color="#CC0000">
                                  ※入力情報はすべて変更が可能\です<br>
                                  タブ内の数値以上を設定したい場合、ここでは仮に決めておいてください。</font></td>
                              </tr>
                              <tr align="center" bgcolor="#FFFFCC"> 
                                <td colspan="2"> 
                                  <input name="md" type="hidden" id="md" value="next"> 
                                  <input type="submit" value="　次へ　"> </td>
                              </tr>
                            </table>
                          </form></td>
                      </tr>
                    </table>
END
	}elsif ( $type eq 'list' ) {
		#-----------------------------#
		# 実際のプラン一覧            #
		#-----------------------------#
		my $file = $myroot . $data_dir. $log_dir . $plan_txt;
		unless ( open(FILE, $file) ) {
			&make_plan_page( 'plan', '', "システムエラー<br><br>$fileが開けません<br>パーミッションを確認してください");
		}
		my $list_table = <<"END";

                               <table width="100%" border="0" cellspacing="0" cellpadding="1">
<form name="form1" method="post" action="$main'indexcgi">
                                  <tr> 
                                    <td width="360"></td>
                                    <td width="60" align="center">&nbsp;</td>
                                    <td width="60">&nbsp;</td>
                                    <td width="160" align="center">▽ステップメール配信時間帯</td>
                                    <td width="60"></td>
                                  </tr>
END
        my $flag = 0;
		while( <FILE> ) {
            $flag = 1;
			chomp;
			my ( $id ,$name, $_run, $runtime ) = ( split(/\t/) )[0, 2, 37, 76];
            my $run = ($_run)? '稼動中': '<font color="#BBBBBB">停止中</font>';
            my $runlink = ($_run)? '停止する': '稼動する';
            my $alert = ($_run)? '停止します。よろしいですか？': '稼動します。よろしいですか？';
            my $link = ($_run)? '0': '1';
			my ( $st, $ed ) = split(/<>/,$runtime);
			$st = 0 if( $st < 0 || $st > 23 );
			$ed = 0 if( $ed < 0 || $ed > 23 );
			my $sel_st;
			my $sel_ed;
			foreach my $s ( 0 .. 23 ){
				my $sed = ' selected' if( $st == $s );
				my $eed = ' selected' if( $ed == $s );
				$sel_st .= qq|<option value="$s"$sed>$s</option>\n|;
				$sel_ed .= qq|<option value="$s"$eed>$s</option>\n|;
			}
			$list_table .= <<"END";
                                  <tr> 
                                    <td width="360"><a href="$indexcgi?md=all&id=$id"><font color="#0000FF">$name</font></a></td>
                                    <td width="60" align="center"><font color="#000000">$run</font></td>
                                    <td width="60"><a href="$indexcgi?md=run&id=$id&action=$link"><font color="#0000FF" onClick="return confir('$alert');";>$runlink</font></a></td>
                                    <td width="160" align="center"><select name="$id\_s">$sel_st</select>時<span class="fontsize10px">から</span><select name="$id\_e">$sel_ed</select>時<span class="fontsize10px">まで</span></td>
                                    <td width="60" align="center"><a href="$indexcgi?md=log&id=$id"><font color="#0000FF">配信ログ</font></a></td>
                                  </tr>
END
		}
		$list_table .= <<"END";
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td align="center">&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td align="center"><input type="submit" name="" value="配信時間帯を更新">
                                    <input type="hidden" name="md" value="text">
                                    <input type="hidden" name="action" value="runtime"></td>
                                    <td align="center">&nbsp;</a></td>
                                  </tr>
</form>
                                </table>
END
        $list_table = 'プランが作成されていません' if !$flag;
		#------------------------------#
		# プランの一覧の表示用テーブル #
		#------------------------------#
		$table = <<"END";
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><strong><br>
                          既存の配信プランを表\示しています</strong> <hr noshade> <font color="#669900">「 
                          編集したい<strong>配信プラン名</strong> 」または「 <strong>配信ログ</strong> 
                          」をクリックしてください</font> <br> <br> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="5">
                            <tr> 
                              <td bgcolor="#FF9900"><font color="#FFFFFF">配信プラン一覧</font></td>
                            </tr>
                            <tr> 
                              <td width="640" bgcolor="#FFFFCC"> 
                                $list_table
                              </td>
                            </tr>
                          </table><br>
                          <table width="100%" border="0" cellspacing="0" cellpadding="5"> 
                            <tr> 
                              <td bgcolor="#FFFFEE">
                                <table  width="640" border="0" cellspacing="0" cellpadding="2"> 
                                    <tr> 
                                      <td><font color="#FF0000"><strong>■ステップメール配信時間帯について</strong></font><br>
                                        <br>
                                       メール配信を行う時間帯を絞り込むことができます。<br>
                                       ご指定のステップメール配信時間帯は、稼動中のプランに対して有効となります。<br>
                                       「停止時間」に「開始時間」より前の時刻を指定すると、翌日の時刻が設定可能\です。<br>
                                       同時刻を指定することで、常時稼動となります。<br>
                                       <br>
                                       ▽対象となるメール配信
                                       <br>
                                       ・管理画面「配信を実行する」リンクによる配信<br>
                                       ・自動配信タグによる配信<br>
                                       ・cronによる配信<br>
                                       <font color="#FF0000">
                                       ※その他すべての機能\および配信には適用されません。<br>
                                      ※「登録時」などの各通知メールは時間帯の設定に関わらず登録及び配信を行います。<br>
                                       <br>
                                       </font><table width="500" border="0" cellspacing="0" cellpadding="0">
                                         <tr>
                                           <td bgcolor="#999999"><table width="500" border="0" cellspacing="1" cellpadding="8">
                                             <tr>
                                               <td bgcolor="#FFFFFF">【設定例】
                                                 <br>
                                                 0時<span class="fontsize10px">から</span>12時<span class="fontsize10px">まで</span><br>
                                                 → 0:00～11:59までメール配信を行います。
                                                 <br>
                                                 20時<span class="fontsize10px">から</span>2時<span class="fontsize10px">まで</span><br>
                                                 → 20:00～翌日の01:59までメール配信を行います。</td>
                                             </tr>
                                           </table></td>
                                         </tr>
                                       </table>
                                       <br>
                                       <table width="500" border="0" cellspacing="0" cellpadding="0">
                                         <tr>
                                           <td bgcolor="#999999"><table width="500" border="0" cellspacing="1" cellpadding="8">
                                             <tr>
                                               <td bgcolor="#FFFFFF">【ご注意】
                                                 <br>
                                                 指定の時間帯にアクセスがなく、その日に予\定していた配信が行われなかった場合、<br>
                                                 その未配信分は、次回のステップメール配信時に累積されて配信されます。 </td>
                                             </tr>
                                           </table></td>
                                         </tr>
                                       </table></td>
                                    </tr>
                                </table>
                              </td>
                             </tr>
                           </table></td>
                      </tr>
                    </table>
END
	}elsif ( $type eq 'admin' ) {
		$table = <<"END";
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><strong><br>
                          管理者の情報を編集します</strong> <hr noshade> <font color="#669900">入力後、「<strong>更新を反映</strong> 」
                          ボタンををクリックしてください</font> <br> <br> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="5">
                            <tr>
                            <td width="10">&nbsp;</td>
                            <td>
                              <font color="#FFOOOO">$err</font>
                              <form action="$indexcgi" method="POST">
                              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                <tr><td bgcolor="#FF9900" colspan="2">■ ID、パスワードの変更</td></tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                <tr>
                                <td width="100">変更後のID
                                </td>
                                <td width="470"><input type="text" name="nid" size="30">
                                </td>
                                </tr>
                                <tr>
                                <td>変更後のパスワード
                                </td>
                                <td><input type="password" name="npass" size="10" maxlength="8"> （ 半角英数字 8文字以内 ）
                                </td
                                </tr>
                                <tr>
                                <td>変更後の確認パスワード
                                </td>
                                <td><input type="password" name="rpass" size="10" maxlength="8">
                                </td
                                </tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                <tr>
                                <td width="100">現在のID
                                </td>
                                <td width="450"><input type="text" name="input_id" size="30">
                                </td>
                                </tr>
                                <tr>
                                <td>現在のパスワード
                                </td>
                                <td><input type="password" name="input_pass" size="10" maxlength="8">
                                </td
                                </tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                <tr><td align="right"><input type="submit" value="　更新を反映　" onClick="return confir('本当に変更しますか？');"></td><td>&nbsp;</td></tr>
                              </table>
                              <input type="hidden" name="md" value="ipchange">
                              </form>
                              
                            </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
END
	}elsif ( $type eq 'method' ) {
		#--------------------#
		# 送信方式           #
		#--------------------#
		local $defeach = 100;
		local $defsleep = 30;
		local $defpartition = 50;
		my %method;
		unless( open(MET, "$myroot$data_dir$methodtxt") ) {
			&error('システムエラー', "送信方式用データファイルが開けません[ $myroot$data_dir$methodtxt ]");exit;
		}
		while( <MET> ) {
			chomp;
			my ( $nam, $val ) = split(/\t/);
			$nam = &deltag( $nam );
			$val -= 0 if( $nam ne 'f_mail' );
			$method{$nam} = $val;
		}
		close(MET);
		if ( !defined $method{'method'} || $method{'method'} ) {
			$checked2 = 'checked';
			
		}else{
			$checked = 'checked';
		}
		if ( defined $method{'each'} ) {
			${"each$method{'each'}"} = 'selected';
		}else{
			${"each$defeach"} = 'selected';
		}
		if ( defined $method{'sleep'} ) {
			${"sleep$method{'sleep'}"} = 'selected';
		}else{
			${"sleep$defsleep"} = 'selected';
		}
		if ( defined $method{'partition'} ) {
			${"partition$method{'partition'}"} = 'selected';
		}else{
			${"partition$defpartition"} = 'selected';
		}
		# サーバー制限
		my $chk_sleep = ( $method{'chk_sleep'} )? ' checked': '';
		my $r_sleep   = ( $method{'r_sleep'} )? $method{'r_sleep'}:'';
		my $chk_f     = ( $method{'chk_f'} )? ' checked': '';
		my $f_mail    = $method{'f_mail'};
		
		$table = <<"END";
                    <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                      <tr> 
                        <td><strong><br> 
                          配信するメールの送信方式を設定します</strong> 
                          <hr noshade> 
                          <font color="#669900">送信方式を選択し、送信方式に応じた設定を選択後、「<strong>更新を反映</strong> 」 ボタンををクリックしてください</font> <br> 
                          <br> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="5"> 
                            <tr> 
                              <td width="10">&nbsp;</td> 
                              <td> <form action="index.cgi" method="POST"> 
                                  <table width="100%" border="0" cellspacing="0" cellpadding="2"> 
                                    <tr> 
                                      <td bgcolor="#FF9900" colspan="2"><input name="method" type="radio" value="0" $checked> 
                                        アクセス毎に送信する</td> 
                                    </tr> 
                                    <tr> 
                                      <td colspan="2">&nbsp;</td> 
                                    </tr> 
                                    <tr> 
                                      <td width="120"> １回のアクセスにつき </td> 
                                      <td width="380"><select name="each" id="each"> 
                                          <option $each10>10</option> 
                                          <option $each20>20</option> 
                                          <option $each30>30</option> 
                                          <option $each40>40</option> 
                                          <option $each50>50</option> 
                                          <option $each60>60</option> 
                                          <option $each70>70</option> 
                                          <option $each80>80</option> 
                                          <option $each90>90</option> 
                                          <option $each100>100 (推奨) </option> 
                                          <option $each110>110</option> 
                                          <option $each120>120</option> 
                                          <option $each130>130</option> 
                                          <option $each140>140</option> 
                                          <option $each150>150</option> 
                                          <option $each160>160</option> 
                                          <option $each170>170</option> 
                                          <option $each180>180</option> 
                                          <option $each190>190</option> 
                                          <option $each200>200</option> 
                                        </select> 
                                        通づつ送信する 。 </td> 
                                    </tr> 
                                    <tr> 
                                      <td colspan="2"><font color="#FF0000">※配信日程以外のメール送信時の送信数としても使用されます。（一括送信）</font></td> 
                                    </tr>
                                    <tr> 
                                      <td colspan="2"><font color="#FF0000">※１回の送信数が多い場合、または連続で送信するとサーバーに負荷を掛けます。</font></td> 
                                    </tr> 
                                    <tr> 
                                      <td colspan="2">アクセス毎送信の場合、一度のアクセスによるメール配信件数は最大で200件に制限しています。<br>
                                                      システム全体の登録人数が多い場合は<font color="#0000FF">配信設定マニュアル.html「ご利用サーバーでの制限」</font>をご覧ください。</td> 
                                    </tr> 
                                    <tr> 
                                      <td colspan="2">&nbsp;</td> 
                                    </tr> 
                                  </table> 
                                  <table width="100%" border="0" cellspacing="0" cellpadding="2"> 
                                    <tr> 
                                      <td bgcolor="#FF9900"><input name="method" type="radio" value="1" $checked2> 
                                        分割で送信する</td> 
                                    </tr> 
                                    <tr> 
                                      <td>&nbsp;</td> 
                                    </tr> 
                                    <tr> 
                                      <td width="380"><select name="sleep" id="sleep"> 
                                          <option $sleep5>5</option> 
                                          <option $sleep10>10</option> 
                                          <option $sleep15>15</option> 
                                          <option $sleep20>20</option> 
                                          <option $sleep25>25</option> 
                                          <option $sleep30>30 (推奨)</option> 
                                          <option $sleep35>35</option> 
                                          <option $sleep40>40</option> 
                                          <option $sleep45>45</option> 
                                          <option $sleep50>50</option> 
                                          <option $sleep55>55</option> 
                                          <option $sleep60>60</option> 
                                        </select> 
                                        秒毎に
                                        <select name="partition" id="select"> 
                                          <option $partition10>10</option> 
                                          <option $partition20>20</option> 
                                          <option $partition30>30</option> 
                                          <option $partition40>40</option> 
                                          <option $partition50>50 (推奨)</option> 
                                          <option $partition60>60</option> 
                                          <option $partition70>70</option> 
                                          <option $partition80>80</option> 
                                          <option $partition90>90</option> 
                                          <option $partition100>100</option> 
                                        </select> 
                                        通づつ送信する。</td> 
                                    </tr> 
                                    <tr> 
                                      <td><font color="#FF0000">※１回の送信数が多い場合サーバーに負荷を掛けます。</font></td> 
                                    </tr> 
                                    <tr> 
                                      <td>&nbsp;</td> 
                                    </tr> 
                                    <tr> 
                                      <td><strong>必須条件</strong></td> 
                                    </tr> 
                                    <tr> 
                                      <td>▼バックグラウンドでCGIの起動ができるサーバーであること。 </td> 
                                    </tr> 
                                    <tr> 
                                      <td> ▼CGIが常時起動していても、サーバー側で強制的に切断されないこと。 </td> 
                                    </tr> 
                                    <tr>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td bgcolor="#FF9900">■ サーバー制限設定</td>
                                    </tr>
                                    <tr>
                                      <td><table width="600" border="0" cellpadding="5" cellspacing="0">
                                          <tr>
                                            <td colspan="2">ご利用のサーバーでsendmailを使用してメールを送信する際、特別な制限がある場合以下の設定を<br>
                                              行ってください。<br>
                                              制限に関する詳細は「楽メール」を設置したサーバーの管理者に問い合わせるか、もしくはサポートページをご参照ください。<br>
                                              <br></td>
                                          </tr>
                                          <tr>
                                            <td colspan="2" bgcolor="#FFFFEE">該当する制限の <strong>チェックボックス</strong>にチェックを入れ、<strong>必要な情報</strong>をご入力ください。<br>
                                              制限がある場合、以下の設定を行いませんと<strong><font color="#FF0000">「楽メール」は正常に動作致しません</font></strong>。</td>
                                          </tr>
                                          <tr>
                                            <td colspan="2" bgcolor="#FFFFEE"><input name="chk_sleep" type="checkbox" id="chk_sleep" value="1"$chk_sleep>
                                              sendmailでメールを連続送信する際に待ち時間が必要。　</td>
                                          </tr>
                                          <tr>
                                            <td width="50" bgcolor="#FFFFEE">&nbsp;</td>
                                            <td width="550" bgcolor="#FFFFEE">１通送信の度に
                                              <input name="r_sleep" type="text" id="r_sleep" value="$r_sleep" size="5">
                                              秒待つ。</td>
                                          </tr>
                                          <tr>
                                            <td colspan="2" bgcolor="#FFFFEE">&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td colspan="2" bgcolor="#FFFFEE"><input name="chk_f" type="checkbox" id="chk_f" value="1"$chk_f>
                                              sendmailでメールを送信する場合、-fオプション(sender)を指定する必要がある。</td>
                                          </tr>
                                          <tr>
                                            <td bgcolor="#FFFFEE">&nbsp;</td>
                                            <td bgcolor="#FFFFEE">メールアドレス
                                              <input name="f_mail" type="text" id="f_mail" value="$f_mail" size="50">
                                              <br>
                                              ※ ご利用のサーバーで取得しましたメールアドレスを入力してください。</td>
                                          </tr>
                                        </table></td>
                                    </tr>
                                    <tr>
                                      <td>&nbsp;</td>
                                    </tr> 
                                  </table> 
                                  <input name="submit" type="submit" onClick="return confir('本当に変更しますか？');" value="　更新を反映　"> 
                                  <input name="md" type="hidden" id="md" value="remethod"> 
                                </form></td>
                            </tr> 
                          </table>
                          <table width="600" border="0" cellspacing="0" cellpadding="5"> 
                            <tr> 
                              <td width="10">&nbsp;</td> 
                              <td bgcolor="#FFFFCC">
                                <table width="590" border="0" cellspacing="0" cellpadding="2"> 
                                    <tr> 
                                      <td><font color="#FF0000"><strong>■各送信方式の特徴</strong></font><br>
                                       「分割送信」の場合は、１日１回のアクセスでその日にスケジューリングされたメールを全て送信します。<br>
                                       「アクセス毎に送信する」では、１回の配信数以上に配信予\定のメールがある場合、複数のアクセスが必要となります。<br><br>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td><font color="#FF0000"><strong>■送信の優先順位について</strong></font><br>
                                       プランが複数ある場合、「プラン一覧」の表\の上のプランが優先的に送信されます。
                                      </td> 
                                    </tr>
                                </table>
                              </td>
                             </tr>
                           </table>
                         </td> 
                      </tr> 
                    </table>
END
	
	}elsif ( $type eq 'help' ) {
		my $link_simul;
		if( $simul ){
			$link_simul = qq|<img src="$indexcgi\?md=simul" border="0" width="1" height="1">|;
		}
		$table = <<"END";
                     <TABLE cellspacing=0 cellpadding=3 width=660 border=0>
                      <TBODY>
                        <TR>
                          <TD>$link_simul&nbsp; </TD>
                        </TR>
                        <TR>
                          <TD>■　概要
                            <HR noShade>
                          </TD>
                        </TR>
                        <TR>
                          <TD width=640><TABLE cellSpacing=0 cellPadding=1 width=640 border=0>
                              <TBODY>
                                <TR>
                                  <TD width=20>&nbsp;</TD>
                                  <TD width=620>メールマガジン、メールセミナー、フォローメールの配信を自動的に行います<BR>
                                    あらかじめメールの配信回数・メールの内容・配信間隔等（メール配信プラン）を 
                                    設定しておくことで、フォーム（登録）を設置したホームページにお客様がメール配信を希望すると、設定に応じて自動的にメールが配信されます。</TD>
                                </TR>
                              </TBODY>
                            </TABLE></TD>
                        </TR>
                        <TR>
                          <TD>&nbsp;</TD>
                        </TR>
                        <TR>
                          <TD>■　自動配信の設定について</TD>
                        </TR>
                        <TR>
                          <TD><HR noShade></TD>
                        </TR>
                        <TR>
                          <TD><TABLE cellSpacing=0 cellPadding=1 width=640 border=0>
                              <TBODY>
                                <TR>
                                  <TD width=20>&nbsp;</TD>
                                  <TD width=620>「楽メール」では管理者様のご利用に応じて、いくつかの配信方式を選択できます。<BR>
                                    <br>
                                    <strong>（１）配信タグを利用した自動配信（推奨）</strong><br>
                                    <br>
                                    ホームページの任意の場所（多くはトップページのどこか）に配信用のタグを埋め込んでおき、そのページアクセスがある度にＣＧＩが起動・チェック・配信を行います。<br>
                                    これにより、任意のページに１日１アクセスでもあれば、毎日のメール配信が完全自動で可能\となります。
                                    <form>
                                      <table WIDTH="148" BORDER="0" align="center" CELLPADDING="0" CELLSPACING="0">
                                        <tr>
                                          <td BGCOLOR="#666666" ALIGN="center"><table WIDTH="600" BORDER="0" align="center" CELLPADDING="10" CELLSPACING="1" class="table1">
                                              <tr>
                                                <td ALIGN="center" BGCOLOR="#FFFFCC"><font color="#000000">▼任意のページでJAVASCRPTのプリロードを利用しアクセスするたびにメールを配信したい場合 </font>
                                                  <p><font color="#000000">任意のページの&lt;HEAD&gt;&lt;/HEAD&gt;内に</font></p>
                                                  <textarea name="textarea" cols="70" rows="5" onFocus="this.select();">
&lt;script language="JavaScript"&gt;&lt;!--
myIMG = new Image();
myIMG.src = '$Pub'scriptName$sendcgi?run';
// --&gt;&lt;/script&gt;</textarea>
                                                  <font color="#FF0000"><br>
                                                  ※全ての文字列を選択して貼\り付けてください。<br>※楽メールPROをSSL領域に設置した場合には、”http”を”https”へと変更してください。</font> </td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
                                    </form>
                                    <strong><br>
                                    （２）配信専用ページからＣＧＩをワンクリックで起動</strong><br>
                                    <br>
                                    配信用のＵＲＬアドレスをクリックすることで、ＣＧＩの起動・チェック・配信を行います。<br>
                                    <form>
                                      <table WIDTH="148" BORDER="0" align="center" CELLPADDING="0" CELLSPACING="0">
                                        <tr>
                                          <td BGCOLOR="#666666" ALIGN="center"><table WIDTH="600" BORDER="0" align="center" CELLPADDING="10" CELLSPACING="1" class="table1">
                                              <tr>
                                                <td ALIGN="center" BGCOLOR="#FFFFCC"><p><font color="#000000">▼任意のページに「配信専用リンク」を作成しアクセスするたびにメールを配信したい場合のリンク </font></p>
                                                  <p>任意のページ内に</p>
                                                  <p>
                                                    <input name="text" type="test" id="text" value="&lt;a href=&quot;$Pub'scriptName$sendcgi&quot;&gt;任意&lt;/a&gt;" size="90" onFocus="this.select();">
                                                    <font color="#FF0000"><br>
                                                    ※全ての文字列を選択して貼\り付けてください。<br>※楽メールPROをSSL領域に設置した場合には、”http”を”https”へと変更してください。</font></td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
                                    </form>
                                    <strong> （３）ＣＧＩに手動でアクセスし、配信を実行する</strong><br>
                                    <br>
                                    ＣＧＩの管理画面上からＣＧＩの起動・チェック・配信を行います。<br>
                                    このページ上部メニューの「<strong>配信を実行する</strong>」をクリックすることで、 チェック・配信が行われます。<br>
                                    <br>
                                    <font color="#FF0000">【注意】 </font><BR>
                                    配信には<BR>
                                    ●アクセス毎に配信<BR>
                                    ●分割で配信<BR>
                                    の二通りがあり、どちらかを「<u><font color="#0000FF">送信方式設定</font></u>」で決定します。（デフォルトは分割方式） <BR>
                                    分割送信の場合は、１日１回のアクセスでその日にスケジューリングされたメールを全て送信しますが、アクセス毎の送信では、１回の配信数以上に配信予\定のメールがある場合、複数のアクセスが必要となります。<BR>
                                    <BR>
                                    ▼<font color="#0000FF">配信設定マニュアル.html「ご利用サーバーでの制限」</font>をご覧ください。<BR>
                                    <BR>
                                    <strong>（４）クーロンを利用した自動送信（わかる方向け）</strong><BR>
                                    <BR>
                                    UNIX系のOSの機能\であるクーロンを使用することによって自動化（スケジュール管理） 
                                    を行います<BR>
                                    クーロンが使用できない環境の場合は上記のいづれかの方法でメールを配信してください。<br>
                                    <font color="#FF0000">※クーロンの利点は、タグやアクセスを使わずに自動配信ができる点と時間指定が可能\な点です。</font><br>
                                    <br>
                                    ▼<font color="#0000FF">配信設定マニュアル.html「クーロンの設定方法」</font>をご覧ください。</TD>
                                </TR>
                              </TBODY>
                            </TABLE></TD>
                        </TR>
                        <TR>
                          <TD>&nbsp;</TD>
                        </TR>
                        <TR>
                          <TD>■　ご注意</TD>
                        </TR>
                        <TR>
                          <TD><hr noshade></TD>
                        </TR>
                        <TR>
                          <TD><table width="600" border="0" align="center" cellpadding="1" cellspacing="0">
                              <tr>
                                <td bgcolor="#666666"><TABLE cellSpacing=0 cellPadding=5 width=600 border=0>
                                    <TBODY>
                                      <TR>
                                        <TD bgcolor="#FFCC66">★大量配信について</TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFFFEE">「楽メール」はＣＧＩプログラムであるため、ご利用のサーバの能\力によりましては大量配信により負荷が増加することで、配信エラーが生じる可能\性がございます。<br>
                                          大量のリストを一括登録したり、ユーザーが多くなった状態での一括送信及び日付指定配信を行う場合はご利用者様の責任において慎重にお願いいたします。<br>
                                        </TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFCC66">★自動配信について</TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFFFEE">「楽メール」はＣＧＩプログラムですので、配信予定\のチェック・配信を行うためシステムの起動・配信チェックを定期的に行う必要がございます。
                                          この作業を自動化するには、通常は「自動配信タグ」をサイト内に埋め込んでおき、サイトへの不特定多数のアクセスがある度に配信チェック・自動配信を行う形式が基本となります。<br>
                                          【設置マニュアル】<br>
                                          <a href="http://www.raku-mail.com/manual/autosendtag.pdf" target="_blank"><font color="#0000FF">http://www.raku-mail.com/manual/autosendtag.pdf</font></a><br>
　                                           </TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFCC66">★unicode(UTF-8)ご使用時のサーバー負荷について</TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFFFEE">楽メールをUTF-8で使用する場合において、ご利用のサーバーにJcode.pmがインストールされていないと、<br>
                                          サーバーへの負荷が通常より高くなる場合がございます。<br>
                                          Jcode.pmの有無については、ご利用サーバーのサポート等でご確認下さい。</TD>
                                      </TR>
                                    </TBODY>
                                  </TABLE></td>
                              </tr>
                            </table></TD>
                        </TR>
                      <TD>&nbsp;</TD>
                      </TR>
                      <TD>■　登録内容の確認通知について
                          <HR noShade>
                        </TD>
                      </TR>
                      <TR>
                        <TD width=640><TABLE cellSpacing=0 cellPadding=1 width=640 border=0>
                            <TBODY>
                              <TR>
                                <TD width=20>&nbsp;</TD>
                                <TD width=620>管理者に、登録情報を知らせるには登録時の控えを登録者に送信し、<br>
                                  このメールを管理者にも送信する設定にする方法が考えられます。<br>
                                  <br>
                                  具体的な方法といたしましては、<br>
                                  <br>
                                  １）登録時のメール内に以下のような形式で登録内容を差し込みます。<br>
                                  【例】<br>
                                  <table WIDTH="148" BORDER="0" align="center" CELLPADDING="0" CELLSPACING="0">
                                    <tr>
                                      <td BGCOLOR="#666666" ALIGN="center"><table WIDTH="600" BORDER="0" align="center" CELLPADDING="5" CELLSPACING="1" class="table1">
                                          <tr>
                                            <td BGCOLOR="#FFFFCC">以下の内容で登録を受付けました。ご登録ありがとうございます。<br>
                                              お名前：&lt;%name%&gt;<br>
                                              メールアドレス：&lt;%mail%&gt;<br>
                                            </td>
                                          </tr>
                                        </table></td>
                                    </tr>
                                  </table>
                                  <br>
                                  ２）「登録設定」のページにて、「管理者に通知」にチェックを入れます。<br>
                                  <br>
                                  これにより、登録者に登録内容の控えが配信され、同時に管理者宛に<br>
                                  同じものが届くため、登録内容が確認できる仕組みです。</TD>
                              </TR>
                            </TBODY>
                          </TABLE></TD>
                      </TR>
                      <TR>
                        <TD>&nbsp;</TD>
                      </TR>
                      <TR>
                        <TD>■　メニューについて
                          <HR noShade>
                        </TD>
                      </TR>
                      <TR>
                        <TD width=640><TABLE cellSpacing=0 cellPadding=1 width=630 border=0>
                            <TBODY>
                              <TR>
                                <TD width=20>&nbsp;</TD>
                                <TD width=610><TABLE cellSpacing=5 cellPadding=5 width=620 border=0>
                                    <TBODY>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>新規作成</STRONG> </TD>
                                        <TD width=500>メール配信プランを新規作成します。<BR>
                                          入力した情報はすべて変更できます。 </TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>プラン一覧</STRONG> </TD>
                                        <TD width=500>現在作成済みのメール配信プランの一覧を表\示します。<BR>
                                          表\示されている配信プランをクリックすることでそのプランの情報を閲覧し、更新を行えます。 </TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>管理者情報</STRONG> </TD>
                                        <TD width=500>管理者ID、パスワードを変更できます。<BR>
                                          変更したID、パスワードは次回から適用されます。 </TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top><STRONG>送信方式設定</STRONG></TD>
                                        <TD>配信する方式を設定できます。<BR></TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top><STRONG>配信を実行する</STRONG></TD>
                                        <TD>実際に稼働中の配信プランのメールを配信します。<BR></TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>ログアウト</STRONG> </TD>
                                        <TD width=500>認証に使用している期限なし「Cookie」をリセットします。<BR>
                                          ブラウザを閉じても同じ効果が得られます。 </TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>ヘルプ</STRONG> </TD>
                                        <TD width=500>「新規作成」、「プラン一覧」、「管理者情報」ページが表\示されている場合はこのページが表\示されます。 
                                          各プランの更新画面が表\示されている場合はその更新のマニュアルが表\示されます。 
                                          使用マニュアルとしてご利用ください。 </TD>
                                      </TR>
                                    </TBODY>
                                  </TABLE></TD>
                              </TR>
                            </TBODY>
                          </TABLE></TD>
                      </TR>
                        <TR>
                          <TD>&nbsp;</TD>
                        </TR>
                        <TR>
                          <TD>■　セットアップ（環境設定）</TD>
                        </TR>
                        <TR>
                          <TD><hr noshade></TD>
                        </TR>
                        <TR>
                          <TD><TABLE cellSpacing=0 cellPadding=1 width=640 border=0>
                              <TBODY>
                                <TR>
                                  <TD width=20>&nbsp;</TD>
                                  <form method="post" action="$indexcgi">
                                    <TD width=620>以下のボタンより初回時のセットアップを再度起動できます。<br>
                                      設定をやり直したい場合や動作が正常に行われない場合などに、再度セットアップを実行してください。<br>
                                      <input type="submit" name="setup" value="　セットアップを実行　">
                                    <input name="md" type="hidden" id="md" value="setup"></TD>
                                  </form>
                                </TR>
                              </TBODY>
                            </TABLE></TD>
                        </TR>
                         <TR>
                          <TD>&nbsp;</TD>
                        </TR>
                      </TBODY>
                    </TABLE>
END
	}
    my $help = qq|"$indexcgi\?md=help"|;
	&html_main( $table, $help, $run, $load );
	exit;
}


#------------------------------------------------------------#
# メイン画面のテンプレート                                   #
#------------------------------------------------------------#
sub html_main {
	my ( $table, $help, $run, $load ) = @_;
	my $logo = &get_relpath( "$image_dir", $IMG_URL );
	$logo = $logo . 'rakumaillogo.jpg';
	print <<"END";
Content-type: text/html

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<title>$title</title>
<link href="$image_dir$css" rel="stylesheet" type="text/css">
<script type="text/javascript"><!--
function confirmation(){
    var what=confirm('この配信プランに関連する、すべてのデータが削除されます\\n\\n本当に削除しますか？');
    if(what == false){
        return false;
    }
}
function confir(str){
    var what=confirm(str);
    if(what == false){
        return false;
    }
}
function wopen( url, name, wd, ht ){
	var w = ( wd > 0 )? wd: 550;
	var h = ( ht > 0 )? ht: 500;
    window.open(url, name, "width="+w+",height="+h+",menubar=no,scrollbars=yes");
}
--></script>
</head>
<body>
<center>
  <table width="700" border="0" cellspacing="10">
    <tr> 
      <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr bgcolor="#0033CC"> 
            <td colspan="3" bgcolor="#FCD52F"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td rowspan="2"><table cellpadding="5">
                    <tr><td><img src="$logo"></td></tr></table></td>
                  <td align="right" valign="top">
				  <table border="0" cellpadding="0" cellspacing="0">
				    <tr>
					  <td bgcolor="#003580">
					    <table width="100%" border="0" cellspacing="1" cellpadding="3">
						  <tr>
						    <td width="80" align="center" bgcolor="#6699CC"><a href="$indexcgi"><font style="font-size:10px"color="#FFFFFF">トップページへ</font></a></td>
						  </tr>
						</table>
					  </td>
					</tr>
				  </table>
				</td>
                </tr>
                <tr> 
                  <td align="right" valign="bottom"><font color="#666666">ver$Version</font></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3" bgcolor="#003580"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="3">
                <tr bgcolor="#6699CC"> 
                  <td width="80" align="center"><a href="$indexcgi\?md=new">新規作成</a></td>
                  <td width="80" align="center"><a href="$indexcgi\?md=list">プラン一覧</a></td>
                  <td width="90" align="center"><a href="$indexcgi\?md=admin">管理者情報</a></td>
                  <td width="90" align="center"><a href="$indexcgi\?md=method">送信方式設定</a></td>
                  <td width="100" align="center"><a href="#" onClick="alert('配信を実行します');wopen('$sendcgi', 'raku_mail')">配信を実行する</a></td>
                  <td width="80" align="center"><a href="$indexcgi\?md=logout">ログアウト</a></td>
                  <td width="60" align="center"><a href=$help>ヘルプ</a></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3" bgcolor="#FFFFFF"> <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td>$table </td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
  </table>
</center>
</body>
</html>
END
	exit;
}

# 日程テーブルの作成
# $type 0 => 詳細ページ時の表示用
# $type 1 => 配信日程ページ用
sub make_schedule {
	my ( $id, $type, $counts, $intervals, $qfilename ) = @_;
	my $now = time;
	my ( $count, $r1, $r2, $r3 ) = split(/,/, $counts);
	my ( $interval, $dates ) = split(/<>/, $intervals);
	my @interval = split( /,/, $interval );
	my @dates = split( /,/, $dates );
	my $table;
	
	# 配信日程・本文用
	if ( $type ) {
		my $ck1 = ' checked="checked"' if($r1);
		$baseNum = '登録時';
		$table = <<"END";
<script type="text/javascript"><!--

function getElem( nam ){
	var obj = '';
	if ( document.getElementById ){
		obj = document.getElementById ( nam );
	}else{
		obj = document.all [name];
	}
	return obj;
}

// 日程オブジェクト操作
function openObj( nam ){
	var obj = getElem(nam);
	obj.style.display = "";
}
function closeObj( nam ){
	var obj = getElem(nam);
	obj.style.display = "none";
}
function ScheduleDisplay(){
	var count = $count;
	var message = '登録時';
	
	for( var i = 0; i < count; i++ ){
		var num = i + 2;
		var nam = 's' + num;
		var s1 = nam + '_1';
		var s2 = nam + '_2';
		var s3 = nam + '_3';
		
		var obj = getElem(nam);
		var next = getElem( nam + '_from' );
		next.innerText = message;
		next.textContent = message;
		if( obj.checked == false ){
			closeObj(s1);
			openObj(s2);
			openObj(s3);
		}else{
			// テキストの変更
			message = '第'+num+'回';
			openObj(s1);
			closeObj(s2);
			closeObj(s3);
			
		}
	}
	var SD = setTimeout("ScheduleDisplay();",200);
}
function winLoad(){
	if (window.addEventListener) { //for W3C DOM
		window.addEventListener("load", ScheduleDisplay, false);
	}else if (window.attachEvent) { //for IE
		window.attachEvent("onload", ScheduleDisplay);
	}else  {
		window.onload = ScheduleDisplay;
	}
}
winLoad();

// アラートメッセージ
function altSdl(obj){
	if( obj.checked ){
		alert("以降のステップは、配信を再開した時点からの「起算日数」で配信が実行されます。\\n必要な場合、指定日数の調整を行ってください。");
	}
}

// -->
</script>
                                <table width="100%" border="0" cellspacing="0" cellpadding="5">
                                        <tr>
                                          <td bgcolor="#FFFFFF">登録時からの<strong>起算日数</strong>で、オートステップメールを配信します。<br>
                                          配信間隔と本文を設定してください。</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#FFFFFF">配信間隔指定と日付で指定は平行して設定が可能\です。</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#FFFFFF"><table width="100%" border="0" cellspacing="0" cellpadding="1">
                                            <tr>
                                              <td bgcolor="#666666"><table width="100%" border="0" cellspacing="0" cellpadding="10">
                                                <tr>
                                                  <td bgcolor="#FFFFFF"><strong><font color="#FF0000">【ご注意】</font><br>
                                                    </strong>稼働中に配信間隔の変更があると、場合によっては一度に複数のメールが配信されてしまう場合があります。<br>
                                                    稼働中の配信日程の変更は十\分注意してください。<br>また、登録者数によっては、更新が完了するまでに時間がかかる場合があります。</td>
                                                </tr>
                                              </table></td>
                                            </tr>
                                          </table></td>
                                        </tr>
                                        <tr>
                                          <td align="center" bgcolor="#FFFFCC"><form name="form1" method="post" action="$indexcgi">
                                              <table width="500" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td bgcolor="#FFFFFF"><table width="500" border="0" cellpadding="2" cellspacing="0">
                                                      <tr>
                                                        <td height="20" colspan="6" bgcolor="#FFFFCC">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td width="8%" align="center" bgcolor="#FFCC33">不可</td>
                                                        <td width="13%" align="center" bgcolor="#FFCC33">一時停止</td>
                                                        <td width="14%" align="center" bgcolor="#FFCC33">配信回数</td>
                                                        <td width="20%" align="center" bgcolor="#FFCC33">配信間隔</td>
                                                        <td align="center" bgcolor="#FFCC33">変更ボタン</td>
                                                        <td width="15%" align="center" bgcolor="#FFCC33">本文編集</td>
                                                      </tr>
                                                      <tr>
                                                        <td align="center" bgcolor="#FEF2CD" height="30"><input name="r" type="checkbox" value="1"$ck1></td>
                                                        <td align="center" valign="middle" bgcolor="#FEF2CD">--</td>
                                                        <td align="center" valign="middle" bgcolor="#FEF2CD">登録時</td>
                                                        <td align="center" bgcolor="#FEF2CD">登録時配信</td>
                                                        <td valign="middle" nowrap="nowrap" bgcolor="#FEF2CD"><input type="submit" name="add0" value="下に追加" onClick="return confir('追加しますか？');"></td>
                                                        <td align="center" bgcolor="#FEF2CD"><a href="$indexcgi?md=ml&id=$id&n=0"><font color="#0000FF">本文の編集</font></a></td>
                                                      </tr>
END
		for ( my $i=1; $i<=$count; $i++ ) {
			my $num = $i +1;
			my $intnum = $i-1;
			my( $inter, $config ) = split( /\//,$interval[$i-1] );
			$inter = ( $config )? '': $inter -0;
			$config -= 0;
			
			my $def_stop = ( $config )? 1: 0;
			my $stop = ( $config )? ' checked="checked"': '';
			my $bgcolor = ( !$config )? '#FFFFCC': '#FEF2CD' ;
			$table .= <<"END";
                                                     <tr>
                                                        <td align="center" bgcolor="$bgcolor" height="30">&nbsp;</td>
                                                        <td align="center" valign="middle" bgcolor="$bgcolor"><input id="s$num" type="checkbox" name="stop$i" value="1"$stop onclick="altSdl(this);"><input type="hidden" name="def_stop$i" value="$def_stop"></td>
                                                        <td align="center" valign="middle" bgcolor="$bgcolor">第$num回</td>
                                                        <td align="center" bgcolor="$bgcolor">
                                                          <span id="s$num\_1" style="display:none;">再開時配信</span>
                                                          <span id="s$num\_2"><font style="font-size:12px;"><span id="s$num\_from">$baseNum</span></font><font style="font-size:11px" color="#666666">より</font><br></span>
                                                          <span id="s$num\_3"><input type="text" name="int$i" size="3" value="$inter">日後</span></td>
                                                        <td valign="middle" nowrap="nowrap" bgcolor="$bgcolor"><input name="add$i" type="submit" id="add$i" onClick="return confir('追加しますか？');" value="下に追加" />
                                                        <input name="del$i" type="submit" id="del$1" onClick="return confir('削除しますか？');" value="削除" /></td>
                                                        <td align="center" bgcolor="$bgcolor"><a href="$indexcgi?md=ml&id=$id&n=$i"><font color="#0000FF">本文の編集</font></a></td>
                                                      </tr>
END
			$baseNum = '第'. $num. '回' if( $config );
		}
        $ck2 = ' checked="checked"' if($r2);
        $ck3 = ' checked="checked"' if($r3);
		$table .= <<"END";
                                                      <tr>
                                                        <td align="center" bgcolor="#FFFFCC" height="30"><input name="r2" type="checkbox" id="r" value="checkbox"$ck2></td>
                                                        <td nowrap="nowrap" bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td align="center" valign="middle" bgcolor="#FFFFCC">変更時</td>
                                                        <td bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td align="center" bgcolor="#FFFFCC"><a href="$indexcgi?md=ml&id=$id&n=r"><font color="#0000FF">本文の編集</font></a></td>
                                                      </tr>
                                                      <tr>
                                                        <td align="center" bgcolor="#FFFFCC" height="30"><input name="r3" type="checkbox" id="r" value="checkbox"$ck3></td>
                                                        <td nowrap="nowrap" bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td align="center" valign="middle" bgcolor="#FFFFCC">解除時</td>
                                                        <td bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td align="center" bgcolor="#FFFFCC"><a href="$indexcgi?md=ml&id=$id&n=c"><font color="#0000FF">本文の編集</font></a></td>
                                                      </tr>
                                                      
                                                  </table></td>
                                                </tr>
                                              </table>
                                              <br>
                                              <input name="md" type="hidden" id="md" value="resche">
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="count" type="hidden" id="count" value="$count">
                                              <input name="display" type="hidden" id="display" value="$now">
                                              <input type="submit" name="Submit2" value="　更新を反映　" onClick="return confir('更新しますか？');"><input type="reset" name="Submit4" value="　元に戻す　">
                                              <br>
                                              <table width="450" cellpadding="2">
                                                <tr>
                                                  <td width="5%" align="right" valign="top">※</td>
                                                  <td width="95%" align="left">左の「不可」をチェックすると、登録・変更・解除時のメールを配信しません。</td>
                                                </tr>
                                                <tr>
                                                  <td align="right" valign="top">※</td>
                                                  <td align="left">「一時停止」をチェックすると、前回ステップの送信後に停止状態となり以降のステップメールの配信が中止されます。<br />
                                                    資料発送後に次回ステップへ進めるなどに利用すると便利です。</td>
                                                </tr>
                                                <tr>
                                                  <td align="right" valign="top">※</td>
                                                  <td align="left">停止状態となった登録者へ次回ステップを送信するには、「登録者情報」画面の「再開」ボタンをクリックするか「配信情報」を更新してください。</td>
                                                </tr>
                                                <tr>
                                                  <td align="left">&nbsp;</td>
                                                  <td align="left"><font color="FF0000"><strong>「不可」をチェックせず「本文の編集」も行わないと、登録者に空のメールが送られてしまいますので、ご注意ください。</strong></font></td>
                                                </tr>
                                              </table>
                                            </form></td>
                                        </tr>
                                      </table>
END
		#-----------#
		# 日付指定  #
		#-----------#
		$table .= <<"END";
                               <table width="100%" border="0" cellspacing="0" cellpadding="5">
                                  <tr> 
                                    <td bgcolor="#FFFFCC"><form name="form1" method="post" action="$indexcgi?md=schedule&id=$id">
                                        <table width="100%" border="0" cellpadding="2" cellspacing="0">
                                          
                                          <tr bgcolor="#F3C261"> 
                                            <td height="20" colspan="3">■日付で指定</td>
                                          </tr>
                                          <tr> 
                                            <td width="50%">&nbsp;</td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                          </tr>
END
		foreach my $date ( @dates ) {
			# 日付用コード生成
			my ( $mon, $day, $year ) = split( /\//, $date );
			my $target = sprintf("%02d", $mon) . sprintf("%02d", $day);
			$target .= sprintf("%04d", $year) if( $year > 0 );
			
			# 日付指定（月）
			my $smon = qq|<select name="mon$target" id="interval">\n|;
            for(my $t=1; $t<=12; $t++ ){
				my $selected = ($mon == $t)? 'selected': '';
				$smon .= qq|<option value="$t" $selected>$t</option>\n|;
			}
            $smon .= '</select>';
			
			# 日付指定（日）
            my  $sday = qq|<select name="day$target" id="interval">\n|;
            for(my $t=1; $t<=31; $t++ ){
				my $selected = ($day == $t)? 'selected': '';
				$sday .= qq|<option value="$t" $selected>$t</option>\n|;
			}
            $sday .= '</select>';
			my $syear = &ToYearOption( $year -0 );
			$table .= <<"END";
                                          <tr>
                                            <td align="right"><select name="year$target">$syear</select>年$smon月$sday日</td>
                                            <td><input type="submit" name="del$target" value="削除" onClick="return confir('削除しますか？');"></td>
                                            <td><a href="$indexcgi?md=ml&id=$id&n=d$target"><font color="#0000FF">本文の編集</font></a></td>
                                          </tr>
END
		}
		my $addmon = qq|<select name="addmon">\n|;
		my $addday = qq|<select name="addday">\n|;
        for(my $t=0; $t<=31; $t++ ){
			my $str = ( $t )? $t: '--';
			$addmon .= qq|<option value="$t">$str</option>\n| if ( $t <= 12 );
			$addday .= qq|<option value="$t">$str</option>\n|;
		}
		$addmon .= '</select>';
		$addday .= '</select>';
		$addyear = &ToYearOption();
		$table .= <<"END";
                                          <tr> 
                                            <td align="center" colspan="3">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td align="center" colspan="3">&nbsp;
                                            配信日付の追加
                                            <select name="addyear">$addyear</select>年$addmon月$addday日</td>
                                          </tr>
                                          <tr align="center"> 
                                            <td colspan="3"><input name="md" type="hidden" id="md" value="resche">
                                              <input name="type" type="hidden" id="id" value="date">
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="count" type="hidden" id="count" value="$count">
                                              <input type="submit" name="Submit" value="　更新を反映　" onClick="return confir('更新しますか？');"></td>
                                          </tr>
                                          <tr>
                                            <td colspan="3" align="center">
                                              <table width="450" cellpadding="2">
                                                      <tr>
                                                        <td width="5%" align="right" valign="top">※</td>
                                                        <td width="95%" align="left">年度が経過した分は順次非表\示となります</td>
                                                      </tr>
                                                      <tr>
                                                        <td width="5%" align="right" valign="top">※</td>
                                                        <td width="95%" align="left">登録者へ指定の日付に一括でメールが配信される為、送信数によってはサーバーへの負荷が高くなる場合があります。</td>
                                                      </tr>
                                                      <tr>
                                                        <td>&nbsp;</td>
                                                        <td><font color="#FF0000"><strong>配信プランとは別に臨時にメールを配信する場合は、
                                                        「登録者へメール送信」を使用してください。</strong></font></td>
                                                      </tr>
                                                  </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </form></td>
                                  </tr>
                                         <tr>
                                          <td align="center" bgcolor="#FFFFFF">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#FFFFFF"><form enctype="multipart/form-data" method="post" action="$indexcgi">
                                              <table width="500" border="0" cellspacing="0" cellpadding="5">
                                                <tr>
                                                  <td bgcolor="#FFCC66">▼本文のダウンロード/アップロード</td>
                                                </tr>
                                                <tr>
                                                  <td align="center" bgcolor="#FFFFCC"><input name="stepfile" type="file" size="50">
                                                    <input type="submit" name="Submit3" value="　更新　" onclick="return confir('本文データを更新します。\\n本当によろしいですか？');"></td>
                                                </tr>
                                                <tr>
                                                  <td align="center" bgcolor="#FFFFCC">[ <a href="$indexcgi?md=down_step&id=$id"><font color="#0000FF">本文をダウンロード</font></a> ]</td>
                                                </tr>
                                                <tr>
                                                 <td align="center" bgcolor="#FFFFCC"><table width="450" cellpadding="2">
                                                      <tr>
                                                        <td align="right" valign="top">※</td>
                                                        <td align="left">本文更新用のCSVファイルを「参照」より選択ください。<br>
                                                          アップロードにより本文を更新する場合は、必ず「本文をダウンロード」より最新のデータを取得ください。</td>
                                                      </tr>
                                                      <tr>
                                                        <td width="5%" align="right" valign="top">※</td>
                                                        <td width="95%" align="left">配信日程に登録していないデータは、登録・更新されません。</td>
                                                      </tr>
                                                  </table></td>
                                                </tr>
                                              </table><input name="md" type="hidden" id="md" value="upload_step">
                                              <input name="id" type="hidden" id="id" value="$id">
                                            </form></td>
                                        </tr>
                                  <tr>
                                   <td><br>○ <strong>ステップメールの配信開始について</strong><br><br>
                                      登録者の登録日に配信する事はできません。<br>
                                      配信間隔は登録日からの起算となります。<br>
                                      配信間隔を1日後に設定されている場合、登録日の翌日でないと配信されません。<br>
                                      登録日の翌日に配信を実行されれば、配信されます。
                                   </td>
                                  </tr>
                                  <tr>
                                   <td><br>○ <strong>稼働中のスケジュール変更について</strong><br><br>
プラン稼働中にスケジュールが追加・削除された際は、"各登録者の「配信済み回」"を<br>
自動的に調整し更新内容を適切に処理し次回の配信本文が決定されます。<br>
<br>
・「配信済み回」より前のデータが追加された場合は「配信済み回」を１つ進めます。<br>
・「配信済み回」より前のデータが削除された場合は「配信済み回」を１つ戻します。<br>
・「配信済み回」より後のデータが追加・削除された場合、処理の必要がない為調整はされません。<br>

                                    </td>
                                  </tr>
                                </table>
END
	} else {
	# 詳細ページ用
		# 本文題名を取得
		my $qfilepath = $myroot. $data_dir. $queue_dir. $qfilename;
		my $body = &get_body( $qfilepath );
		my $def_subject = '(題名未設定)';
		$table = <<"END";
                                      <table width="400" border="0" cellpadding="2" cellspacing="0">
                                        <tr> 
                                          <td width="40" align="center">使用</td>
                                          <td width="60">配信回数</td>
                                          <td width="60">配信間隔</td>
                                          <td width="175">&nbsp;</td>
                                          <td width="65">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
END
		my $baseNum = '登録時';
		for ( my $i=0; $i<=$count; $i++ ) {
			my $num = $i+1;
			$num = ($i)? "第$num回":'登録時';
			my( $int, $config ) =  split(/\//,$interval[$i-1]) if ($i>0);
			$int .= '日後' if( !$config );
			$int = '登録時' if( !$i );
			$int = '再開時' if( $config );
			my $ck = '&nbsp;';
			$ck = ($r1)? '×': '○' if !$i;
			my $from = ( !$i || $config )? '': $baseNum.'より<br>';
			# 本文題名
			my $mail_subject = ($body->{$i}->{'subject'} eq '' )? $def_subject: &deltag($body->{$i}->{'subject'});
			$table .= <<"END";
                                        <tr> 
                                          <td align="center">$ck</td>
                                          <td>$num</td>
                                          <td><font style="font-size:10px" color="#AAAAAA">$from</font>$int</td>
                                          <td><a href="$indexcgi?md=p&id=$id&n=$i"><font color="#0000FF">$mail_subject</font></a></td>
                                          <td><a href="$indexcgi?md=st&id=$id&n=$i"><font color="#0000FF" onClick="return confir('送信してもよろしいですか?');">送信テスト</font></a></td>
                                        </tr>
END
			$baseNum = $num if( $config );
		}
		foreach ( @dates ) {
			my ( $mon, $day, $year ) = split(/\//, $_ );
			$mon = sprintf("%02d", $mon);
			$day = sprintf("%02d", $day);
			$year = sprintf("%04d", $year);
			my $target = $mon . $day;
			$target .= $year if( $year > 0 );
			$year = '毎' if( $year <= 0 );
			
			# 本文題名
			my $mail_subject = ($body->{"d$target"}->{'subject'} eq '' )? $def_subject: &deltag($body->{"d$target"}->{'subject'});
			$table .= <<"END";
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td colspan="2" align="right">$year年 $mon月 $day日&nbsp;</td>
                                          <td><a href="$indexcgi?md=p&id=$id&n=d$target"><font color="#0000FF">$mail_subject</font></a></td>
                                          <td><a href="$indexcgi?md=st&id=$id&n=d$target"><font color="#0000FF" onClick="return confir('送信してもよろしいですか?');">送信テスト</font></a></td>
                                        </tr>
END
		}
        $ck2 = ($r2)? '×': '○';
        $ck3 = ($r3)? '×': '○';
		# 本文題名
		my $renew_subject = ($body->{'r'}->{'subject'} eq '' )? $def_subject: &deltag($body->{'r'}->{'subject'});
		my $cancel_subject = ($body->{'c'}->{'subject'} eq '' )? $def_subject: &deltag($body->{'c'}->{'subject'});
			
		$table .= <<"END";
                                        <tr> 
                                          <td align="center">$ck2</td>
                                          <td>変更時</td>
                                          <td>&nbsp;</td>
                                          <td><a href="$indexcgi?md=p&id=$id&n=r"><font color="#0000FF">$renew_subject</font></a></td>
                                          <td><a href="$indexcgi?md=st&id=$id&n=r"><font color="#0000FF" onClick="return confir('送信してもよろしいですか?');">送信テスト</font></a></td>
                                        </tr>
                                        <tr> 
                                          <td align="center">$ck3</td>
                                          <td>解除時</td>
                                          <td>&nbsp;</td>
                                          <td><a href="$indexcgi?md=p&id=$id&n=c"><font color="#0000FF">$cancel_subject</font></a></td>
                                          <td><a href="$indexcgi?md=st&id=$id&n=c"><font color="#0000FF" onClick="return confir('送信してもよろしいですか?');">送信テスト</font></a></td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table>
END
	}
	return $table;
}

#-------------------------#
# 配信ログテーブルの作成  #
#-------------------------#
sub make_log_table {
	
	my ( $id, $csvfile, $file ) = @_;
	my $csvpath = "$myroot$data_dir$csv_dir$csvfile";
	my $path    = "$myroot$data_dir$log_dir$file";
	my $table;
	my $tmp = $myroot . $data_dir . $log_dir . $$ . time . 'log.tmp';
	
	my $lockfull = &lock();
	
	unless ( open(CSV, $csvpath) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "システムエラー<br><br>$csvpathが開けません<br>パーミッションを確認してください");
		exit;
	}
	my %CSV;
	while(<CSV>){
		chomp;
		my ( $id, $email ) = ( split(/\t/) )[0, 5];
		$CSV{$id} = $email;
	}
	
	unless ( open(LOG, $path) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "システムエラー<br><br>$pathが開けません<br>パーミッションを確認してください");
		exit;
	}
	my @log = <LOG>;
	@log = reverse @log;
	if ( @log > $logmax ) {
		splice( @log, $logmax );
		unless ( open(TMP, ">$tmp") ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "システムエラー<br><br>テンプレートファイルが作成できません<br>[ $log_dir ]パーミッションを確認してください");
			exit;
		}
		chmod 0606, $tmp;
		my @relog = reverse @log;
		print TMP @relog;
		close(TMP);
		close(LOG);
		rename $tmp, $path;
	}else{
		close(LOG);
	}
	&rename_unlock( $lockfull );
	
	my $position = $param{'pn'};
	
	# スタートコード
	$position = 0 if ( $position < 0 );
	# 始まりのインデックス
	my $pstart = $position * $pagemax if ( $position > 0 );
	if ( $pstart > $#log ) {
		$position = 0;
		$pstart = 0;
	}
	# 終わりのインデックス
	my $pend = $pstart + ( $pagemax - 1 );
	$pend = $#log if ( $pend > $#log );
	
	# コードの設定
	my $old = $position + 1 if ( ($position + $papemax) < $logmax );
	my $new = $position -1 if ( $position > 0 );
	
	# 表示用
	my $total = @log;
	my $sp = $pstart + 1;
	my $ep = $pend + 1;
	my $newlink = qq|<a href="$indexcgi?md=log&id=$id&pn=$new"><font color="0000FF">▲戻る</font></a>| if( $pstart > 0 );
	my $oldlink = qq|<a href="$indexcgi?md=log&id=$id&pn=$old"><font color="0000FF">進む▼</font></a>| if( $pend < $#log );
	my $toplink = qq|<a href="$indexcgi?md=log&id=$id&pn=0"><font color="0000FF">▲トップへ</font></a>| if( $pstart > 0 );
	#@log = splice( @log, $pstart, $pagemax );
	
    close(LOG);
    if ( @log ) {
        $table = <<"END";

  <table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr><td><strong>配信ログ</strong>の一覧を表\示しています。<br>(最大保持数 最新2000件まで)</td>
  </tr>
  <tr><td>&nbsp;</td>
  </tr>
  <tr><td>「題名」をクリックすると送信したメールのプレビューを表\示します。<br>
          「メールアドレス」をクリックすると登録者の一覧ページを表\示します。<br>
		  <font color="#FF0000">※配信後に削除されたステップメールのログ及び「登録者へメール送信」で送信されたメールログはリンク表\示されません。</font>
</td>
  </tr>
  <tr><td>&nbsp;</td>
  </tr>
  <tr><td>
    <table>
    <tr>
      <td width="140">[ <strong>$total</strong> <small>件中</small> $sp - $ep ]</td><td width="60">$toplink</td><td width="40" align="right">$newlink</td><td width="40">$oldlink</td>
    <tr>
    </table>
  </td>
  </tr>
  <tr>
  <td bgcolor="#FFCCF2">
    <table width="100%" border="0" cellpadding="2" cellspacing="1">
    <tr>
    <td width="200" bgcolor="#FFCCF2">配信題名
    </td>
    <td width="150" bgcolor="#FFCCF2">宛先
    </td>
    <td width="70" bgcolor="#FFCCF2">配信日付
    </td>
    </tr>
END
		foreach( @log[$pstart .. $pend] ) {
			chomp;
			my ( $gnum, $mail, $name, $date, $bnum, $subject ) = split(/\t/);
			$date = &make_date3( $date );
			$name = &deltag( $name );
			$name = '&nbsp;' if(!$name);
			$mail = &deltag( $mail );
			$subject = '題名未設定' if( $subject eq '' );
			
			if( $bnum eq 'S' ){
				# 何もしない
			}elsif( $bnum eq '' ){
				# 何もしない
			}else{
				$subject = qq|<a href="$indexcgi?md=p&n=$bnum&id=$id"><font color="#0000FF">$subject</font></a>|;
			}
			$mail    = ( $CSV{$gnum} eq $mail )? qq|<a href="$indexcgi?md=g&id=$id#$gnum"><font color="#0000FF">$mail</font></a>|: $mail;
			
			$table .= <<"END";
    <tr>
    <td width="200" bgcolor="#FFFFFF">$subject
    </td>
    <td width="150" bgcolor="#FFFFFF">$mail
    </td>
    <td width="70" bgcolor="#FFFFFF">$date
    </td>
    </tr>
END
        }
        $table .= <<"END";
  </table>
END
    }else{
       $table = <<"END";
<table width="100%" border="0" cellpadding="" cellspacing="">
<tr>
<td>&nbsp;
</td>
</tr>
<tr>
<td align="center">配信されていません
</td>
</tr>
</table>
END
    }
    return $table;
}

#-------------------------#
# フォームサンプルの作成  #
#-------------------------#
# $mode 0 => ユーザー用
# $mode 1 => 管理者用
sub make_form {
	my ( $mode, $id, $type, $url, $rch, $sep1, $sep2, $design, @form ) = @_;
	local $md;
	local $submit = ($mode)? $indexcgi: $applycgi;
    local $subval;
    local $conf = qq|onClick="window.open('','new','height=300,width=500,scrollbars=yes');"| if( $rch || ($url eq '') );
	local $_target = qq| target="new"| if ( !$mode && ( $rch || ($url eq '') ) );
	local $button = ($mode)? 'button': 'submit';
	
	# まぐまぐ登録機能をチェック
	my $rp = &Magu::Check();
	if( $rp->{'ON'} ){
		$_target = qq| target="_blank"|;
		$conf    = '';
	}
	
	#-----------------------------------------
	#-----------------------------------------
	
	# 以下、動作用に振り分け
	if ( $type eq 'form1' ) {
		
		# 表示順を整形
		my @array;
		my @array2;
		@array = splice( @form, 33, 5 );
		@array2 = splice( @array, 4, 1 );
		splice( @form, 2, 0, @array );
		splice( @form, 9, 0, @array2 );
		
		$md = qq|<input name="md" type="hidden" id="md" value="guest">|;
		$subval = '　登録　';
		local $address=qq|<select name="address" size="1"><option>北海道</option><option>青森県</option><option>岩手県</option><option>宮城県</option><option>秋田県</option><option>山形県</option><option>福島県</option><option>茨城県</option><option>栃木県</option><option>群馬県</option><option>埼玉県</option><option>千葉県</option><option>東京都</option><option>神奈川県</option><option>新潟県</option><option>富山県</option><option>石川県</option><option>福井県</option><option>山梨県</option><option>長野県</option><option>岐阜県</option><option>静岡県</option><option>愛知県</option><option>三重県</option><option>滋賀県</option><option>京都府</option><option>大阪府</option><option>兵庫県</option><option>奈良県</option><option>和歌山県</option><option>鳥取県</option><option>島根県</option><option>岡山県</option><option>広島県</option><option>山口県</option><option>徳島県</option><option>香川県</option><option>愛媛県</option><option>高知県</option><option>福岡県</option>
		<option>佐賀県</option><option>長崎県</option><option>熊本県</option><option>大分県</option><option>宮崎県</option><option>鹿児島県</option><option>沖縄県</option><option>全国</option><option>海外</option></select>\n|;
		if ( $mode ) {
			#$conf = qq|onClick="return confir('登録しますか?');"|;
			$conf = qq|onClick="alert('登録用フォームの確認用です。');"|;
			$message = qq|※このフォームは確認用です。(PC用)|;
        }
		
		my $seimei;
		my $seimei_kana;
		
		# 詳細設定を読み込む
		my %MF_detail = &MF'_get_detail( $param{'id'}-0 );
		my $i = 1;
		my $d = 1;
		
		# 表示順指定一覧
		my @SortOn;
		my @SortOn_m;
		# 表示指定無し
		my @SortNon;
		my @SortNon_m;
		
		my( $base, $line ) = &MF'_analyTemplate( $design );
		# 携帯用
		my( $mbase, $mline ) = &MF'_analyTemplate( $FormTemplate_mobile, 1 );
		
		foreach ( @form ) {
			my ( $ck, $name, $req, $sort ) = split(/<>/);
			$name = $Ctm'names[$i]->{'value'} if($name eq '');
			my $value = qq|<input name="$Ctm'names[$i]->{'name'}" type="text" size="25">|;
			my $value_m = qq|<input name="$Ctm'names[$i]->{'name'}" type="text" size="14">|;
			# 詳細フォームを表示
			if( $i > 18 ){
				$value = &MF'makeform( $Ctm'names[$i]->{'name'}, $MF_detail{$d} );
				$value_m = &MF'makeform( $Ctm'names[$i]->{'name'}, $MF_detail{$d}, 1 );
				$d++;
			}
			#my $width = 150;
			# ☆☆☆旧仕様フォームでの、登録動作は残したままなので、仕様確認のため以下コードは削除不可☆☆☆
			# 姓名別
			#if( $i == 2 ){
			#	my( $sep_ch, $name1, $name2 ) = split(/<>/, $sep1);
			#	if( $sep_ch ){
			#		my $sep_name1 = ($name1 eq '')? '姓': $name1;
			#		my $sep_name2 = ($name2 eq '')? '名': $name2;
			#		$value = qq|<font size="-1">$sep_name1</font><input name="_name1" type="text" size="10"> <font size="-1">$sep_name2</font><input name="_name2" type="text" size="10">|;
			#		$width = 200;
			#	}
			#}
			#if( $i == 3 ){
			#	my( $sep_ch, $name1, $name2 ) = split(/<>/, $sep2);
			#	if( $sep_ch ){
			#		my $sep_name1 = ($name1 eq '')? '姓': $name1;
			#		my $sep_name2 = ($name2 eq '')? '名': $name2;
			#		$value = qq|<font size="-1">$sep_name1</font><input name="_kana1" type="text" size="10"> <font size="-1">$sep_name2</font><input name="_kana2" type="text" size="10">|;
			#		$width = 200;
			#	}
			#}
			$value = $address if ( $i == 15 ); # 都道府県
			$value_m = $address if ( $i == 15 ); # 都道府県
			if ( $ck ne '&nbsp;' && $ck) {
				
				my %FORM;
				$FORM{'name'} = $name;
				$FORM{'form'} = $value;
				$_form = &MF'include( $line, {%FORM} );
				# 携帯用
				$FORM{'form'} = $value_m;
				$_form_m = &MF'include( $mline, {%FORM} );
				
				if( $sort > 0 ){
					$SortOn[$sort] = $_form;
					$SortOn_m[$sort] = $_form_m;
				}else{
					push @SortNon, $_form;
					push @SortNon_m, $_form_m;
				}
			}
			$i++;
		}
		
		foreach( @SortOn ){
			$exchang .= $_;
		}
		foreach( @SortNon ){
			$exchang .= $_;
		}
		# 携帯用
		foreach( @SortOn_m ){
			$exchang_m .= $_;
		}
		foreach( @SortNon_m ){
			$exchang_m .= $_;
		}
		my %FORM;
		$FORM{'__ROW-exchang__'} = $exchang;
		$FORM{'cgi'} = $submit;
		$FORM{'submit'} = $button;
		$FORM{'target'} = $_target;
		$FORM{'javascript'} = $conf;
		$FORM{'hidden'} .= $md. "\n";
		$FORM{'hidden'} .= qq|<input name="id" type="hidden" id="id" value="$id">\n|;
		$FORM{'hidden'} .= qq|<input name="cd" type="hidden" id="cd" value="文字">\n|;
		my $source = $message. &MF'include( $base, {%FORM} );
		# 携帯用
		$FORM{'__ROW-exchang__'} = $exchang_m;
		$FORM{'hidden'} = qq|<input type="hidden" name="m_prop" value="id:$id,md:guest,cd:文字,mbl:1">|;
		my $source_m = $message. &MF'include( $mbase, {%FORM} );
		
		return $source, $source_m;
		
	} else {
		
		#-----------------------------------------
		# 変更・解除用
		#-----------------------------------------
		# 上部
		my $form_source = <<"END";
<table width="270" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" action="$submit"$_target>
END
		my $form_source_m = <<"END";
<form  method="post" action="$submit">
END
		my @names = (
			{'name' => 'userid', 'value' => '登録者ID'},
			{'name' => 'mail', 'value' => '変更前メールアドレス'},
			{'name' => 'nmail', 'value' => '変更後メールアドレス'},
		);
        my ( $ck, $uid, $mail, $rmail ) = split(/<>/, $form[0]);
        $uid  = $names[0]->{'value'} if ( $uid eq '' );
        $mail = $names[1]->{'value'} if ( $mail eq '' && $type eq 'form2' );
        $mail = 'メールアドレス' if ( $mail eq '' && $type eq 'form3' );
        $rmail = $names[2]->{'value'} if ( $rmail eq '' );
        
        if ( $type eq 'form2' ) {
			
			#----------------------------------------------------------
			# 変更用
			#----------------------------------------------------------
			$md = qq|<input name="md" type="hidden" id="md" value="renew">|;
			$subval = '　変更　';
			
			# コメント
			if ( $mode ) {
				$conf = qq|onClick="alert('変更用フォームの確認用です。');"|;
				$form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" colspan="2">※このフォームは確認用です。(PC用)<br><br></td>
</tr>
END
			}
			
			# 登録者ID
			if ( $ck eq '1' ) {
				$form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$uid</font></td>
<td bgcolor="#FFFFFF"><input type="text" name="$names[0]->{'name'}" size="25"></td>
</tr>
END
				$form_source_m .= <<"END";
■$uid：<input type="text" name="$names[0]->{'name'}" size="14"><br>
END
			}
			# 入力フォーム
			$form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$mail</font></td>
<td bgcolor="#FFFFFF" width="150"><input type="text" name="$names[1]->{'name'}" size="25"></td>
</tr>
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$rmail</font></td>
<td bgcolor="#FFFFFF"><input type="text" name="$names[2]->{'name'}" size="25"></td>
</tr>
END
			$form_source_m .= <<"END";
■$mail：<br>
<input type="text" name="$names[1]->{'name'}" size="14"><br>
■$rmail：<br>
<input type="text" name="$names[2]->{'name'}" size="14"><br>
END
			
	    }elsif ( $type eq 'form3' ) {
			
			#----------------------------------------------------------
			# 削除用
			#----------------------------------------------------------
			$md = qq|<input name="md" type="hidden" id="md" value="cancel">|;
			$subval = '　解除　';
			
			if ( $mode ) {
				$conf = qq|onClick="alert('解除用フォームの確認用です。');"|;
				$form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" colspan="2">※このフォームは確認用です。(PC用)<br><br></td>
</tr>
END
            }
            if ( $ck eq '1' ) {
                $form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$uid</font></td>
<td bgcolor="#FFFFFF"><input type="text" name="$names[0]->{'name'}" size="25"></td>
</tr>
END
				$form_source_m .= <<"END";
■$uid：<br>
<input type="text" name="$names[0]->{'name'}" size="14"><br>
</tr>
END
            }
            $form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$mail</font></td>
<td bgcolor="#FFFFFF" width="150"><input type="text" name="$names[1]->{'name'}" size="25"></td>
</tr>
END
			$form_source_m .= <<"END";
■$mail：<br>
<input type="text" name="$names[1]->{'name'}" size="14"><br>
END
    	}
		$form_source .= <<"END";
<tr>
<td colspan="2" align="center">
$md
<input name="id" type="hidden" id="id" value="$id">
<input type="$button" value="$subval" $conf>
<input name="cd" type="hidden" id="cd" value="文字">
</td>
</tr>
</form>
</table>
END
		$form_source_m .= <<"END";

$md
<input name="id" type="hidden" value="$id">
<input type="$button" value="$subval">
<input name="cd" type="hidden" value="文字">
<input name="mbl" type="hidden"  value="1">
</form>
END
		return $form_source, $form_source_m;
	}
}

#------------------------------#
# 登録設定ページの作成（詳細） #
#------------------------------#
sub make_redirect_table {
    my ( $r, $n, $c, $o, $m, $http_regist, $http_renew, $http_cancel ) = @_;
	
	my $regist = &Pub'setHttp( $r, $http_regist, 'all' );
	my $renew = &Pub'setHttp( $n, $http_renew, 'all' );
	my $cancel = &Pub'setHttp( $c, $http_cancel, 'all' );
	
    $r = ( $r && $r ne '&nbsp;')? qq|<a href="$regist" target="_new"><font color="#0000FF">$regist</font></a>|: '（未設定）';
    $n = ( $n && $n ne '&nbsp;' )? qq|<a href="$renew" target="_new"><font color="#0000FF">$renew</font></a>|: '（未設定）';
    $c = ( $c && $c ne '&nbsp;' )? qq|<a href="$cancel" target="_new"><font color="#0000FF">$cancel</font></a>|: '（未設定）';
	$mes = ( $m && $m ne '&nbsp;' )? '（管理者に通知）': '';
    my $table = <<"END";
                                               <table width="100%" border="0" cellpadding="1" cellspacing="0">
                                               <tr>
                                               <td>■登録完了$mes
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>$r
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>■変更完了
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>$n
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>■解除完了
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>$c
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>■受付拒否
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>$o
                                               </td>
                                               </tr>
                                               </table>
END
    return $table;
}

#-------------------------#
# 登録者情報ページ作成    #
#-------------------------#
sub make_guest_table {
    my ( $id, $file, $chk ) = @_;
    my $table;
	
	# 検索
	my $search;
	if( !$chk ){
		$search = $param{'search_str'};
		if( $search eq '' && !$param{'search'} ){
			$search = &unescape($all_cookies{'raku_search'});
		}
		my $search_cookie = &escape($search);
		print "Set-Cookie: raku_search=$search_cookie", "\n";
	}
#======================== 修正箇所 ========================
$pnum = $param{'pnum'};
unless($pnum){
	$pnum = 1;
}
#==========================================================
    my $path = "$myroot$data_dir$csv_dir$file";
    unless ( open(CSV, "$path") ) {
		return if( $readflag );
		$readflag = 1;
        &make_plan_page( 'plan', '', "システムエラー<br>$pathが開けません<br>パーミッションを確認してください");
        exit;
    }
	my $total = 0;
    unless( -z $path ) {
		while( <CSV> ) {
			my @str;
			if( $chk ){
				close(CSV);
				return 1;
			}
			if( $search ne '' ){
				@str = split(/\t/);
				$search_flag = 1;
				$search_result = qq|<td align="right" nowrap><font color="#FF0000"><strong>絞込中 [  </strong><a href="$indexcgi?md=g&id=$id"><font color="#0000FF">解除する</font></a><strong> ]</strong></font></td>|;
				next if( index($str[5], $search) < 0 );
			}
			$total++;
            chomp;
#======================== 修正箇所 ========================
	if($total>($pnum-1)*100 && $total<=$pnum*100){
#==========================================================
			@str = split(/\t/) if( $search eq '' );
            my $uid = $str[0];
            my $email = &deltag( $str[5] );
            my $name = &deltag( $str[3] );
            my $date = &make_date3( $str[19] );
            my $result = "未配信" if($str[20] eq '');
			my $status = '通常';
			$status = qq|第$str[51]回～| if( $str[51] > 0 );
			$status = qq|<input type="submit" name="restart-$uid-$str[20]" value="再開" onclick="return confir('配信を再開します。\\n更新後すぐに、該当のステップメールが送信されます。\\n\\nよろしいですか?');">| if( $str[52] );
			$status = qq|終了| if( $str[51] eq 'end' );
            $result = "登録時" if($str[20] eq 0);
            $result = "第$str[20]回" if($str[20] > 0);
            $_table .= <<"END";
                                  <tr align="center">
                                  <td bgcolor="#FFFFFF" align="left"><a name="$uid">$email</a></td>
                                  <td bgcolor="#FFFFFF" align="left">$name</td>
                                  <td bgcolor="#FFFFFF">$date</td>
                                  <td bgcolor="#FFFFFF">$result</td>
                                  <td bgcolor="#FFFFFF" align="center">
                                    <a href="$indexcgi\?md=ref&id=$id&n=$uid"><font color="#0000FF">編集</font>
                                  </td>
                                  <td bgcolor="#FFFFFF">$status</td>
                                  </tr>
END
        }
	}
	
	# 検索の結果該当ユーザが存在しない場合
	if( $search_flag && $_table eq '' ){
		$_table .= <<"END";
                                  <tr>
                                  <td colspan="5" bgcolor="#FFFFFF" align="center">該当する登録者が存在しません。
                                  </td>
                                  </tr>
END
	}
#======================== 修正箇所 ========================

$pnuma = $pnum-1;
$pnumb = $pnum+1;
$mpnum = ($total/100 == int($total/100) ? $total/100 : int($total/100+1)); 


if($pnum <= 1){
$prepage = <<"END";
	<td align="left"><font color="#999999">前の100件</font></td>
END
}else{
$prepage = <<"END";
	<td align="left"><a href="$indexcgi\?md=g&id=$id&pnum=$pnuma"><font color="#0000FF">前の100件</font></a></td>
END
}
if($pnum*100 >= $total){
$nextpage = <<"END";
	<td align="right"><font color="#999999">次の100件</font></td>
END
}else{
$nextpage = <<"END";
	<td align="right"><a href="$indexcgi\?md=g&id=$id&pnum=$pnumb"><font color="#0000FF">次の100件</font></a></td>
END
}
#==========================================================
		$pnum = 0 if( $total <= 0 );
        $table = <<"END";
                              <table width="100%" cellpadding="0" cellspacing="0" border="0">
                              
                              <tr>
                              <td>[ <a href="$indexcgi\?md=add&id=$id"><font color="#0000FF">追加</font></a> ]
                              　
                              [ <a href="$indexcgi\?md=get&id=$id"><font color="#0000FF">一覧をダウンロード</font></a> ]
                              　
                              [ <a href="$indexcgi\?md=up&id=$id"><font color="#0000FF">一覧をアップロード</font></a> ]
                              　
                              [ <a href="$indexcgi\?md=mail&id=$id"><font color="#0000FF">メールを送信する</font></a> ]
                              </td>
                              </tr>
                              <tr>
                              <td>&nbsp;
                              </td>
                              </tr>
                              <tr>
                              <td align="center" valign="middle">
                                 <br>
                                 <table border="1" cellpadding="2" cellspacing="0" bordercolor="#ACA899">
                                   <tr><form action="" method="post">
                                     <td bgcolor="#EFEDDE">　登録者のメールアドレスを
                                       <input type="text" name="search_str" size="30" value="$search">
                                       で
                                       <input type="submit" value="絞り込む">　
                                       <input type="hidden" name="md" value="g">
                                       <input type="hidden" name="id" value="$id">
                                       <input type="hidden" name="pnum" value="0">
                                       <input type="hidden" name="search" value="1"></td>
                                     </form></tr>
                                 </table></td>   
                              </tr>
                               <tr>
                              <td>&nbsp;
                              </td>
                              </tr>
                              <tr>
                              <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td align="left" nowrap><strong>登録者</strong>の一覧<font color="#FF0000">　</font> [ <strong>TOTAL</strong> $total 件 ]　　[ $pnum / $mpnum ページ ] </td>
                                  $search_result
                                </tr>
                              </table></td>
                              </tr>
	<tr>
	<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
$prepage
$nextpage
	</tr>
	</table></td>
	</tr>

                              <tr>
                              <td>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                
                                <tr>
                                <td bgcolor="#99CCFF">
                              
                                                  <table width="100%" cellpadding="2" cellspacing="1" border="0">
                                                    <tr>
                                                      <td align="center"><font color="#000000">メールアドレス</font> </td>
                                                      <td width="18%" align="center" nowrap><font color="#000000">お名前</font> </td>
                                                      <td width="16%" align="center" nowrap><font color="#000000">登録日</font> </td>
                                                      <td width="11%" align="center" nowrap><font color="#000000">配信済</font> </td>
                                                      <td width="8%" align="center"><font color="#000000">&nbsp;</font> 編集</td>
                                                      <td width="10%" align="center" nowrap>状態</td>
                                                    </tr>
                                                    <form ation="$indexcgi" method="post">$_table
													<input type="hidden" name="md" value="restart"><input type="hidden" name="id" value="$id"><input type="hidden" name="pnum" value="$pnum"></form>
                                                  </table>
                                </td></tr></table>
                              
                              </td>
                              </tr>
                              </table>
END
    }
	if( $total <= 0 && $search_flag <= 0 ){
        $table = <<"END";
                              <table width="100%" cellpadding="0" cellspacing="0" border="0">
                              <tr>
                              <td>&nbsp;
                              </td>
                              </tr>
                              <tr>
                              <td align="center">登録されていません　　 [ <a href="$indexcgi\?md=add&id=$id"><font color="#0000FF">追加</font></a> ]
                                                                        　　[ <a href="$indexcgi\?md=up&id=$id"><font color="#0000FF">一覧をアップロード</font></a> ]
                              </td>
                              </tr>
                              <tr>
                              <td>&nbsp;
                              </td>
                              </tr>
                              </table>
END
    }
	close(CSV);
    return $table;
}

#--------------------------#
# パスワード認証HTMLの出力 #
#--------------------------#
sub html_pass {

	print &html_header();
	print<<"END";
<body>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr> 
    <td><form action="$indexcgi" method="post">
        <br>
        <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr> 
            <td bgcolor="#000000"> 
              <table width="500" border="0" cellpadding="2" cellspacing="1">
                <tr bgcolor="#005E80"> 
                  <td colspan="2" align="center"><strong><font color="#FFFFFF">
                    自動メール配信システム「楽メール」<BR>パスワード認証</font></strong>
                  </td>
                </tr>
                <tr> 
                  <td width="30%" align="center" bgcolor="#ABDCE5"><font color="#333333">ユーザーID</font></td>
                  <td bgcolor="#E5FBFF"> <input name="input_id" type="text" size="40"> 
                  </td>
                </tr>
                <tr> 
                  <td width="30%" align="center" bgcolor="#ABDCE5"><font color="#333333">パスワード</font></td>
                  <td bgcolor="#E5FBFF"> <input name="input_pass" type="password" size="20"> 
                  </td>
                </tr>
                <tr bgcolor="#FFFFFF"> 
                  <td colspan="2" align="center"> <input type="submit" name="Submit" value="　ログイン認証　"> 
                    <br> <font size=2 color="7398E5">管理ツールを使用するにはCookieがONになっている必要があります</font>
					</td>
                </tr>
              </table></td>
          </tr>
        </table>

        <br>
        <br>
        <table border="1" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><iframe scrolling="Yes" frameborder="0" width="500" height="210" src="http://www.raku-mail.com/iframe_cgi_pr.htm"><a href="http://www.raku-mail.com/" target="_blank">楽メール新着情報</a>は iframe 対応のブラウザで見てください。 </iframe></td>
          </tr>
        </table><br>
        <table border="1" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><iframe scrolling="Yes" frameborder="0" width="500" height="210" src="http://www.raku-mail.com/iframe_cgi_info.htm"><a href="http://www.raku-mail.com/" target="_blank">楽メール新着情報</a>は iframe 対応のブラウザで見てください。 </iframe></td>
          </tr>
        </table>
        <input name="md" type="hidden" value="ck">
      </form></td>
  </tr>
</table>
</body>
</html>
END
	exit;
}


sub page {
	
	my( $position, $logmax ) = @_;
	# スタートコード
	$position = 0 if ( $position < 0 );
	# 始まりのインデックス
	my $pstart = $position * $pagemax if ( $position > 0 );
	
	# 終わりのインデックス
	my $pend = $pstart + ( $pagemax - 1 );
	
	# コードの設定
	my $old;
	if( $logmax ){
		$old = $position + 1 if( ($position + $papemax) < $logmax );
	}else{
		$old = $position + 1;
	}
	my $new = $position -1 if ( $position > 0 );
	return $pstart, $pend, $old, $new;
}

#-----------------------------------------------#
# 管理ツールのフレームの出力（管理のメイン画面）#
#-----------------------------------------------#
sub edit_frame {
    my($menu)=@_;
    print &html_header();
    print "<frameset cols=\"180px,*\">\n";
    print "<frame src=\"$target_menu\" name=\"$frame_menu\">\n";
    print "<frame src=\"$target_main\" name=\"$frame_main\">\n";
    print "</frameset>\n";
    print "</html>\n";
    exit;
}

sub disp_config{
	open( CONF, "./config.pl" );
	binmode(CONF);
	print qq|Content-Disposition: attachment; filename="config.txt"| , "\n";
	print "Content-type: application/x-txt", "\n\n";
	while(<CONF>){
		print $_;
	}
	close(CONF);
	exit;
}
sub disp_error{
	my $errfile = "$myroot$data_dir" . 'errorlog.cgi';
	open( ERR, $errfile );
	binmode(ERR);
	print qq|Content-Disposition: attachment; filename="errorlog.txt"| , "\n";
	print "Content-type: application/x-txt", "\n\n";
	while(<ERR>){
		print $_;
	}
	close(ERR);
	exit;
}
sub disp_pms
{
	my $index = &dist_pms_check( $indexcgi );
	my $apply = &dist_pms_check( $applycgi_name );
	my $send = &dist_pms_check( $sendcgi );
	
	open( CGI, "<$sendcgi" );
	while(<CGI>){
		if( /^\$myroot/ ){
			$scriptcode = $_;
			last;
		}
	}
	close(CGI);
	$scriptcode = $sendcgi.'<font color="#FF0000"> に指定コードが見つかりません。<br>誤った編集を行った可能性があります。</font>' if( $scriptcode eq '' );
	
	$ENV{'SCRIPT_FILENAME'} =~ /(.*)$indexcgi/;
	my $rootpath = $1;
	
	$index->{'perl'} = &getPerlpath( $indexcgi );
	$apply->{'perl'} = &getPerlpath( $applycgi_name );
	$send->{'perl'} = &getPerlpath( $sendcgi );
	
	
	print <<"END";
Content-type: text/html

<html>
<head></head>
<body>
<h4>パーミッション確認</h4>
<strong>【 CGI 】</strong>
<table>
<tr>
 <td align="right">$indexcgi ：</td>
 <td>[ $index->{'pms'} ]</td>
 <td>$index->{'error'}</td>
 <td>$index->{'message'}</td>
</tr>
<tr>
 <td align="right">$applycgi_name ：</td>
 <td>[ $apply->{'pms'} ]</td>
 <td>$apply->{'error'}</td>
 <td>$apply->{'message'}</td>
</tr>
<tr>
 <td align="right">$sendcgi ：</td>
 <td>[ $send->{'pms'} ]</td>
 <td>$send->{'error'}</td>
 <td>$send->{'message'}</td>
</tr>
</table>
<br><br>
<h4>Perlパス確認</h4>
<table>
<tr>
 <td align="right">$indexcgi ：</td>
 <td>[$index->{'perl'}]</td>
</tr>
<tr>
 <td align="right">$applycgi_name ：</td>
 <td>[$apply->{'perl'}]</td>
 <td></td>
</tr>
<tr>
 <td align="right">$sendcgi ：</td>
 <td>[$send->{'perl'}]</td>
</tr>
</table>
<br><br>
<h4>Cron確認</h4>
<table>
<tr>
 <td align="left">$sendcgi の絶対パス設定(※distributeディレクトリ指定)</td>
</tr>
<tr>
 <td><strong>$scriptcode</strong></td>
</tr>
<tr>
 <td>[$rootpath]<br>($indexcgiが設置された絶対パス)</td>
</tr>
</table>
</body>
</html>

END
	exit;
}
sub dist_pms_check
{
	my( $path ) = @_;
	my %hash;
	$hash{'pms'} = &_getPms( $path );
	$hash{'message'} = &checkPms('cgi', $path);
	$hash{'error'} = ( $hash{'message'} eq '' )? $ErrorMessage{'001'}: $ErrorMessage{'002'};
	return {%hash};
}

sub getPerlpath
{
	my $path = shift;
	open( CGI, "<$sendcgi" );
	my $line = <CGI>;
	close(CGI);
	chomp( $line );
	return $line;
}

sub getControl
{
	my $file = $param{'p'};
	$file =~ s/\.\.\///g;
	
	my $path = $myroot. $data_dir. $file;
	my $filename;
	if( $path =~ /([^\/]+)$/ ){
		$filename = $1;
	}
	
	open( ERR, $path );
	binmode(ERR);
	print qq|Content-Disposition: attachment; filename="$filename"| , "\n";
	print "Content-type: application/x-txt", "\n\n";
	while(<ERR>){
		print $_;
	}
	close(ERR);
	unless( -e $path ){
		print $filename. ' は見つかりませんでした';
	}
	exit;
}


sub manual
{
	my $html = $param{'p'};
	$html =~ s/\.//g;
	$html =~ s/\///g;
	
	my $path = $manual . '/'. $html . '.html';
	
	if( $html eq 'distribute' ){
		my $filename = $html . '.csv';
		my $path = $manual . '/'. $filename;
		&manual_csv( $filename, $path );
		exit;
	}
	
	open( HTML, $path );
	my $source;
	while(<HTML>){
		while( ( $parameter ) = ( /<%__([^<>\%]+)__%>/oi ) ) {
			s//$$parameter/;
		}
		$source .= $_;
	}
	close(HTML);
	print <<"END";
Content-type: text/html

$source
END
	exit;
}
sub manual_csv
{
	my($filename, $path)  = @_;
	
	open( CSV, $path );
	my @csvdata = <CSV>;
	close(CSV);
	
	print qq|Content-Disposition: attachment; filename="$filename"| , "\n";
	print "Content-type: application/x-csv", "\n";
	print "\n";
	print @csvdata;
	exit;
}

sub restart
{
	my $id = $param{'id'};
	my $userid;
	foreach( keys %param ){
		if( /^restart-(\d+)-(\d*)$/ ){
			$userid = $1;
			$sended = $2;
			last;
		}
	}
	my $target = ( $sended > 1 )? $sended+1: 2;
	if( $userid eq '' ){
		&make_plan_page( 'plan', '', '登録者を指定してください。' );
	}
	
	# 実行
	&restart_action( $id, $userid, $target );
	&make_plan_page( 'plan', 'guest');
	exit;
}

sub restart_action
{
	my( $id, $userid, $target ) = @_;
	
	#---------------------#
	# 排他処理            #
	#---------------------#
	my $lockfull = &lock();
	
	# 送信済み短縮URLを取得
	my $forward = &Click'getForward_url();
	
    #--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	my @line;
	my $csvpath;
	my $queuepath;
	my $logpath;
	my %ra_conf;
	while( <PLAN> ) {
		chomp;
		@line = split(/\t/);
		if ( $line[0] eq $id ) {
			$csvpath   = "$myroot$data_dir$csv_dir$line[6]";
			$queuepath = "$myroot$data_dir$queue_dir$line[7]";
			$logpath   = "$myroot$data_dir$log_dir$line[8]";
			&Pub'ssl($line[83]);
			last;
		}
	}
	close(PLAN);
	
	#---------------------------#
	# 転送用タグ取得            #
	#---------------------------#
	my( $urlTag, $other ) = &Click'roadTag( $line[82] );
	my $uniq;
	my( $step, $dates ) = split(/<>/, $line[36] );
	my $n = 2;
	foreach( split(/,/, $step ) ){
		my( $inter, $config, $code ) = split(/\//);
		$stepConf{$n} = $config -0;
		$uniq = $code if( $n == $target );
		$n++;
	}
	
	#--------------------------------#
	# 既存の登録者データからIDを取得 #
	#--------------------------------#
	unless ( open(CSV, "$csvpath") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>$csvpathが開けません");
		exit;
	}
	my $tmp = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
	unless ( open(TMP, ">$tmp") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリーファイルが開けません<br>$csv_dirのパーミッションを確認してください");
		exit;
	}
	chmod 0606, $tmp;
	my @csvs;
	while( <CSV> ) {
		chomp;
		@csv = split(/\t/);
		my $tar_mail;
		if ( $csv[0] == $userid && $csv[52] ) {
			my $nextStep = ( $csv[20] > 1 )? $csv[20]+1: 2;
			if( $nextStep == $target ){
				if( defined $stepConf{$target} ){
					$csv[20] = $nextStep;
					my %baseTime; # 再開日付
					foreach( split(/<>/,$csv[53] ) ){
						my( $n, $date ) = split(/\//);
						$baseTime{$n} = $date;
					}
					$baseTime{$target} = time;
					my @base;
					foreach( keys %baseTime ){
						push @base, qq|$_/$baseTime{$_}|;
					}
					$csv[53] = join( "<>", @base );
					$csv[52] = ( $stepConf{$target+1} )? 1: '';
				}else{
					$csv[52] = '';
				}
			}
			
			@csvs = @csv; # メール送信用
			$_ = join( "\t", @csv );
		}
		
		print TMP "$_\n";
	}
	close(CSV);
	close(TMP);
	rename $tmp, $csvpath;
	
	if( @csvs && $target ){
		my $rh_body = &get_body( $queuepath );
		$line[9] =~ s/<br>/\n/gi;
		$line[10] =~ s/<br>/\n/gi;
		$line[11] =~ s/<br>/\n/gi;
		my $logNum = $target - 1;
		local ( $subject, $message ) = &make_send_body( $logNum, $rh_body, $line[9], $line[10], $line[11] );
		# 転送タグ変換
		my $forward_urls;
		($message, $forward_urls) = &Click'analyTag($csv[0], $message, $urlTag, $uniq, $forward);
		
		my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
		$subject = &include( \@csvs, $subject );
		$message = &include( \@csvs, $message, $jis );
		$senderror = &send( $line[4], $line[3], $csvs[5], $subject, $message, '' );
		# 配信ログに追加
		my $now = time;
		unless ( $senderror ) {
			open(LOG, ">>$logpath");
			print LOG "$csvs[0]\t$csvs[5]\t$csvs[3]\t$now\t$logNum\t$subject\n";
			close(LOG);
		}else{
			unlink $tmp;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', 'g', 'メール送信に失敗しました');
			exit;
		}
		# アクセス集計用データ生成
		&Click'setForward_t( $forward_urls, $uniq );
	}
	&rename_unlock( $lockfull );
}

sub down_step
{
	my $id = $param{'id'} - 0;
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, $file) ) {
		&make_plan_page( 'plan', '', "システムエラー<br>$fileが開けません");
		exit;
	}
	my $path;
	while( <PLAN> ) {
		chomp;
		my ( $index, $queue, $_step, $_detail ) = ( split(/\t/) )[0, 7, 35, 36];
		if ( $index eq $id ) {
			$step = $_step;
			$detail = $_detail;
			$path = "$myroot$data_dir$queue_dir$queue";
			last;
		}
	}
	close(PLAN);
	unless ( $path ) {
		&make_plan_page( 'plan', '', "システムエラー<br>該当するデータがありません");
		exit;
	}
	unless ( open(QUEUE, "$path") ) {
		&make_plan_page( 'plan', '', "システムエラー<br>$pathが開けません");
		exit;
	}
	my $rh_body = &get_body( $path );
	
	my $filename = 'StepMail-'. $id . '.csv';
	print qq|Content-Disposition: attachment; filename="$filename"| , "\n";
	print "Content-type: application/x-csv", "\n";
	# print "Content-length: ", "\n";
	print "\n";
	
	# 説明
	print qq|ステップ名（※編集不可）,題名,本文,ヘッダ(挿入する場合は「1」),解除案内(挿入する場合は「1」),フッタ(挿入する場合は「1」),ステップ識別（※編集不可）,日付年（※編集不可）,日付月（※編集不可）,日付日（※編集不可）\n|;
	
	# ステップメール
	my $count = (split( /,/, $step ))[0];
	for( my $i=0; $i<$count; $i++ ){
		my $n = $i+2;
		my $code = $i+1;
		print &down_step_makecsv( $n, $rh_body->{$code} );
	}
	
	# 日付
	my( $schedule, $dates ) = split(/<>/, $detail );
	foreach( split( /,/, $dates ) ){
		my( $mon, $day, $year  ) = split( /\// );
		my $code = sprintf( "%02d%02d", $mon, $day );
		$code .= sprintf( "%04d", $year ) if( $year > 0 );
		print &down_step_makecsv( "d$_", $rh_body->{"d$code"} );
	}
	# 登録時メール(管理者専用)
	print &down_step_makecsv( 'ra', $rh_body->{'ra'} );
	# 登録時メール
	print &down_step_makecsv( '0', $rh_body->{'0'} );
	# 変更時メール
	print &down_step_makecsv( 'r', $rh_body->{'r'} );
	# 解除時メール
	print &down_step_makecsv( 'c', $rh_body->{'c'} );
	exit;
}
sub down_step_makecsv
{
	my( $step, $stepmail ) = @_;
	
	my @csv;
	my $year;
	my $mon;
	my $day;
	
	my $step_name;
	$step_name = qq|第$step回| if( $step > 1 );
	$step_name = '登録時' if( $step == 0 );
	$step_name = '登録時(管理者専用)' if( $step eq 'ra' );
	$step_name = '変更時' if( $step eq 'r' );
	$step_name = '解除時' if( $step eq 'c' );
	if( $step =~ /^d(.+)/ ){
		($mon, $day, $year ) = split(/\//, $1 );
		my $pyear =( $year eq '' )? '毎': $year;
		$step_name = qq|(日付)$pyear年$mon月$day日|;
	}
	
	my $step_code;
	$step_code = $step;
	$step_code = 'r1' if( $step == 0 );
	$step_code = 'r0' if( $step eq 'ra' );
	$step_code = 'r2' if( $step eq 'r' );
	$step_code = 'r3' if( $step eq 'c' );
	$step_code = '' if( $step =~ /^d(.+)/ );
	
	my $subject = $stepmail->{'subject'};
	my $body = $stepmail->{'body'};
	
	$subject =~ s/<br>//ig;
	$body =~ s/<br\s*\/?>/\n/ig;
	
	$csv[0] = $step_name;
	$csv[1] = $subject;
	$csv[2] = $body;
	$csv[3] = ($stepmail->{'header'})? 1: '';
	$csv[4] = ($stepmail->{'cancel'})? 1: '';
	$csv[5] = ($stepmail->{'footer'})? 1: '';
	$csv[6] = $step_code;
	$csv[7] = $year;
	$csv[8] = $mon;
	$csv[9] = $day;
	
	for( $i=0; $i<=$#csv; $i++ ){
		$csv[$i] =~ s/\"/\"\"/g;
		$csv[$i] = qq|"$csv[$i]"|;
	}
	my $line = join( ",", @csv );
	return "$line\n";
}

sub upload_step
{

	my $id = $param{'id'} - 0;
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	my $filedata = $param{'stepfile'};
	
	my $filename = &the_filedata( 'stepfile' );
	if ( $filename !~ /\.csv$/ ) {
		&make_plan_page( 'plan', '', "更新エラー<br>CSVファイルを指定してください");
	}
	
	unless ( open(PLAN, $file) ) {
		&make_plan_page( 'plan', '', "システムエラー<br>$fileが開けません");
		exit;
	}
	my $path;
	while( <PLAN> ) {
		chomp;
		my ( $index, $queue, $_step, $_detail ) = ( split(/\t/) )[0, 7, 35, 36];
		if ( $index eq $id ) {
			$step = $_step;
			$detail = $_detail;
			$path = "$myroot$data_dir$queue_dir$queue";
			last;
		}
	}
	close(PLAN);
	unless ( $path ) {
		&make_plan_page( 'plan', '', "システムエラー<br>該当するデータがありません");
		exit;
	}
	my $rh_body = &get_body( $path );
	
	my %StepDetail;
	# ステップメール
	my $count = (split( /,/, $step ))[0];
	for( my $i=0; $i<$count; $i++ ){
		my $n = $i+2;
		my $code = $i+1;
		$StepDetail{$n} = $code;
	}
	
	# 日付
	my( $schedule, $dates ) = split(/<>/, $detail );
	foreach( split( /,/, $dates ) ){
		my( $mon, $day, $year  ) = split( /\// );
		my $code = sprintf( "%02d%02d", $mon, $day );
		$code .= sprintf( "%04d", $year ) if( $year > 0 );
		$StepDetail{$code} = "d$code";
	}
	# 登録時メール(管理者専用)
	$StepDetail{'r0'} = 'ra';
	# 登録時メール
	$StepDetail{'r1'} = '0';
	# 変更時メール
	$StepDetail{'r2'} = 'r';
	# 解除時メール
	$StepDetail{'r3'} = 'c';
	
	my @queue;
	my @stepdata = split( /\r?\n|\r/, $filedata );
	my $index;
	for( $index=0; $index <= $#stepdata; $index++) {
		
		$line = $stepdata[$index];
		# 行数を進める
		$n++;
		
		while( $line =~ tr/"// % 2 && $index < $#stepdata ){
			$index++;
			$_line = $stepdata[$index];
			$line .= "\n$_line";
		}
		$line =~ s/(?:\x0D\x0A|[\x0D\x0A])?$/,/;
		my @lines = map {/^"(.*)"$/s ? scalar($_ = $1, s/""/"/g, $_) : $_}
                ($line =~ /("[^"]*(?:""[^"]*)*"|[^,]*),/g);
		
		my $target;
		if( $lines[8] > 0 && $lines[9] > 0 ){
			$target = sprintf( "%02d%02d", $lines[8], $lines[9] );
			$target.= sprintf( "%04d", $lines[7] ) if( $lines[7] > 0 );
		}
		$target = $lines[6] if( $lines[6] > 1 );
		$target = 'r0' if( $lines[6] eq 'r0' );
		$target = 'r1' if( $lines[6] eq 'r1' );
		$target = 'r2' if( $lines[6] eq 'r2' );
		$target = 'r3' if( $lines[6] eq 'r3' );
		
		if( defined $StepDetail{$target} ){
			my $code = $StepDetail{$target};
			$rh_body->{$code}->{'subject'} = $lines[1];
			$rh_body->{$code}->{'body'} = $lines[2];
			$rh_body->{$code}->{'header'} = $lines[3];
			$rh_body->{$code}->{'cancel'} = $lines[4];
			$rh_body->{$code}->{'footer'} = $lines[5];
		}
	}
	
	my $tmp = "$myroot$data_dir$queue_dir". 'UP-'. time. '.cgi';
	unless ( open(TMP, ">$tmp") ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>テンポラリファイルが作成できません<br>$myroot$data_dir$queue_dir ディレクトリのパーミッションを確認してください");
		exit;
	}
	chmod 0606, $tmp;
	
	foreach( sort keys %StepDetail ){
		my $code = $StepDetail{$_};
		my @csv;
		$csv[0] = $code;
		$csv[1] = &the_text( $rh_body->{$code}->{'subject'});
		$csv[2] = ($rh_body->{$code}->{'header'})? 1 : 0;
		$csv[3] = ($rh_body->{$code}->{'cancel'})? 1 : 0;
		$csv[4] = &the_text( $rh_body->{$code}->{'body'});
		$csv[5] = ($rh_body->{$code}->{'footer'})? 1 : 0;;
		$csv[6] = $rh_body->{$code}->{'ctype'};
		$csv[7] = $rh_body->{$code}->{'filename'};
		my $newline = join( "\t", @csv );
		print TMP "$newline\n";
	}
	close(TMP);
	rename $tmp, $path;
	&make_plan_page( 'plan', 'schedule' );
	exit;
}

sub peculiar
{
	return;
	eval{ require './config.pl'; };
	
	$DEF_sendmail = $sendmail;
	$DEF_image_dir = $image_dir;
}
