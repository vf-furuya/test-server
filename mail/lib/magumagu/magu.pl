package Magu;
#---------------------------------------
# 楽メールpro
#
# まぐまぐ登録機能関連関数群 magu.pl
# v 2.01
#---------------------------------------
my $Dir     = $main::myroot . $main::data_dir;
my $logfile = $Dir . 'magu.cgi';
my $def_url = 'http://regist.mag2.com/reader/Magrdadd';

sub Magumagu
{
	my $email   = shift;
	my $p_magid = 'magid';
	my $p_email = 'rdemail';
	my $rp      = &Check();
	
	# 登録機能が有効でない場合、登録処理を終了
	return 0 unless( $rp->{'ON'} );
	
	my $url   = $rp->{'URL'};
	my $magid = $rp->{'MAGID'};
	
	my $href = qq|$url?$p_email=$email&$p_magid=$magid|;
	print "Location: $href", "\n\n";
	exit;
}

sub Keep
{
	
	my $id      = $main::param{'id'} - 0;
	my $now     = time;
	my $tmpfile = $Dir . $$ . $now . '.tmp';
	
	my $on      = $main::param{'on'} -0;
	my $url     = $main::param{'url'};
	my $magid   = $main::param{'magid'};
	my $newline = qq|$id\t$on\t$url\t$magid\n|;
	
	if( $on > 0 && $magid <= 0 ){
		&main::make_plan_page( 'plan', 'g', '【まぐまぐ】のマガジンIDを入力してください。');
	}
	
	my $fullpath = &main::lock();
	unless( open( TMP, ">$tmpfile" ) ){
		&main::make_plan_page( 'plan', 'g', "データファイルが作成できません。<br>[ $Dir ]のパーミッションをご確認ください。 " );
		&main::rename_unlock( $fullpath );
		exit;
	}
	open( MAGU, $logfile );

	my $flag = 0;
	while(<MAGU>){
		chomp;
		my @str = split(/\t/);
		if( $str[0] eq $id ){
			print TMP $newline;
			$flag = 1;
			next;
		}
		print TMP "$_\n";
	}
	if( !$flag ){
		print TMP $newline;
	}
	close(MAGU);
	close(TMP);
	chmod 0666, $logfile;
	
	unless( rename $tmpfile, $logfile ){
		unlink $tmpfile;
		&main::make_plan_page( 'plan', 'g', "データファイルが作成できません。<br>[ $Dir ]のパーミッションをご確認ください。 ");
		&main::rename_unlock( $fullpath );
		exit;
	}
	&main::rename_unlock( $fullpath );
	
	&main::make_plan_page('plan', 'magu');
	exit;
}

sub delete{
	
	my $id = shift;
	$id         = $id - 0;
	my $now     = time;
	my $tmpfile = $Dir . $$ . $now . '.tmp';
	
	unless( open( TMP, ">$tmpfile" ) ){
		&main::make_plan_page( 'plan', 'g', "データファイルが作成できません。<br>[ $Dir ]のパーミッションをご確認ください。 " );
		&main::rename_unlock( $fullpath );
		exit;
	}
	open( MAGU, $logfile );

	my $flag = 0;
	while(<MAGU>){
		chomp;
		my @str = split(/\t/);
		if( $str[0] eq $id ){
			next;
		}
		print TMP "$_\n";
	}
	close(MAGU);
	close(TMP);
	
	rename $tmpfile, $logfile;
	return;
}

sub Check
{
	my $id = $main::param{'id'} - 0;
	my %Param;
	open( MAGU, $logfile );
	while(<MAGU>){
		chomp;
		my @str = split(/\t/);
		if( $str[0] eq $id ){
			$Param{'id'}    = $id;
			$Param{'ON'}    = $str[1];
			$Param{'URL'}   = $str[2];
			$Param{'MAGID'} = $str[3];
		}
	}
	close(MAGU);
	$Param{'URL'} = $def_url if( $Param{'URL'} eq '' );
	return \%Param;
}

sub Form
{
	my $id = $main::param{'id'};
	my $rp = &Check( $id );
	my $on = ( $rp->{'ON'} )? ' checked': '';
	my $form  = <<"END";
                                        <form name="form1" method="post" action="$main::indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td width="20">&nbsp;</td>
                                            <td width="502"><table width="100%" border="0" cellspacing="1" cellpadding="3">
                                                <tr>
                                                  <td><strong>「まぐまぐ登録機能\」</strong>を設定できます。<br>
                                                    <br>
                                                  「まぐまぐ登録機能\」とは楽メールの登録フォームを使ってメールマガジン「まぐまぐ」<br>
                                                  へ自動登録する機能\です。<br></td>
                                                </tr>
                                                <tr>
                                                  <td>入力後、「更新を反映」ボタンをクリックしてください </td>
                                                </tr>
                                                <tr>
                                                  <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                      <tr>
                                                        <td></td>
                                                      </tr>
                                                      <tr>
                                                        <td bgcolor="#ABDCE5"><table width="100%" border="0" cellpadding="5" cellspacing="1">
                                                            <tr>
                                                              <td width="100" bgcolor="#E5FDFF">基本設定</td>
                                                              <td bgcolor="#FFFFFF"><input name="on" type="checkbox" id="on" value="1"$on>
                                                              このプランでの「まぐまぐ登録機能\」を有効にする<br>
                                                              <font color="#666666">※管理画面からの登録には適応されません。</font></td>
                                                            </tr>
                                                            <tr>
                                                              <td nowrap bgcolor="#E5FDFF">まぐまぐ登録用URL </td>
                                                              <td nowrap bgcolor="#FFFFFF"><input name="url" type="text" size="55" value="$rp->{'URL'}">
                                                              <br>
                                                              登録用プログラムURLを<strong> http </strong>から入力ください。</td>
                                                            </tr>
                                                            <tr>
                                                              <td bgcolor="#E5FDFF">まぐまぐマガジンID </td>
                                                              <td bgcolor="#FFFFFF"><input name="magid" type="text" size="20" value="$rp->{'MAGID'}">
                                                              <br>
                                                              登録する【まぐまぐ】のマガジンIDを入力ください。</td>
                                                            </tr>
                                                            <tr>
                                                              <td colspan="2" bgcolor="#FFFFFF">
                                                                <table width="100%" border="0" cellpadding="3" cellspacing="1">
                                                                  <tr>
                                                                    <td><font color="#FF0000">
                                                                      ★登録フォームについて
                                                                      <br><br>
                                                                      この機能\を有効し「詳細」→「HTMLサンプルソ\ースを表\示」より登録フォームを生成するとポップアップは通常サイズのウィンドウでご利用いただけます。<br><br>
                                                                      ★登録完了画面について<br>
                                                                      <br>
                                                                      この機能\を有効にすると、「登録設定」での完了ページ設定に関わらず登録完了画面は【まぐまぐ】のものになります。<br>
                                                                      <br>
                                                                      ★ご注意<br>
                                                                      <br>
                                                                      【まぐまぐ】登録に必要な情報に変更があった場合、この登録機能\は正常に動作しない可能\性があります。</font></td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                        </table></td>
                                                      </tr>
                                                    </table></td>
                                                </tr>
                                                <tr align="center">
                                                  <td><input name="id" type="hidden" id="id" value="$id">
                                                    <input name="md" type="hidden" id="md" value="k_magu">
                                                    <input type="submit" name="Submit" value="　更新を反映　"></td>
                                                </tr>
                                              </table></td>
                                            <td width="21">&nbsp;</td>
                                          </tr>
                                        </table>
                                      </form>
END
	return $form;
}

1;
