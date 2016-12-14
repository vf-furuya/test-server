#---------------------------------------
# 楽メールpro
#
# HTML形式メール用関連関数群1 page.pl
# v 2.4
#---------------------------------------
sub form_mailbody_top {
	my( $h, $c, $f, $_text, $_html, $num, $btitle, $body, $n, $id, $config ) = @_;
	
	# 登録時別設定
	if( $n eq '0' ){
		$sub_link_r = qq|<a href="$main'indexcgi?md=ml&n=ra&id=$id"><font color="#0000FF">&gt;&gt;【管理者通知専用】本文設定へ</font></a><br>&nbsp;|;
	}
	if( $n eq 'ra' ){
		$sub_link_r = qq|<a href="$main'indexcgi?md=ml&n=0&id=$id"><font color="#0000FF">&gt;&gt;通常の【登録時】本文設定へ</font></a><br>&nbsp;|;
		my $checked0 = ( $config )? '': ' checked="checked"';
		my $checked1 = ( $config )? ' checked="checked"': '';
		$sub_radio = qq|<tr><td bgcolor="#FFFFCC">利用</td><td><input type="radio" name="ra_conf" value="1"$checked1>する<input type="radio" name="ra_conf" value="0"$checked0>しない</td></tr><tr><td colspan="2">&nbsp;</td></tr>|;
		$sub_message = <<"END";
<br><table  width="450" border="0" cellspacing="0" cellpadding="10"> 
  <tr> 
    <td width="450" bgcolor="#FFFFEE">【管理者通知専用】本文を有効とした場合、上記本文が管理者へ送信されます。また、このメールの【送信者メールアドレス】は「登録者のメールアドレス」となり、一般的なメールソ\フト等では「返信メールアドレス」として利用することができます。
    </td>
  </tr>
</table>
END
	}
	
	my $main_table = <<"END";
                                 <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="499"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="523"> <form action="$indexcgi" method="post" enctype="multipart/form-data" name="form1">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                                <tr> 
                                                  <td colspan="2"><strong>本文[ $num ]</strong>を編集します</td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">入力後、「<strong>更新を反映</strong>」ボタンをクリックしてください。<br><br>
                                                    また、<font color="#FF0000">HTML形式でメールを配信したい</font>場合は、「<strong>HTML形式の設定</strong>」を<br>
                                                    行った後、「<strong>HTML形式を既定とする</strong>」にチェックしてください。</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">$sub_link_r&nbsp;</td>
                                                </tr>
  $sub_radio
                                                <tr> 
                                                  <td width="76" bgcolor="#FFFFCC">題名</td>
                                                  <td width="439"><input name="btitle" type="text" id="btitle" value="$btitle" size="50"></td>
                                                </tr>
                                                <tr> 
                                                  <td bgcolor="#FFFFCC">ヘッダー</td>
                                                  <td><input name="header" type="checkbox" id="header" value="checkbox" $h>
                                                    挿入する</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2" align="center">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td valign="top" bgcolor="#FFFFCC">本文</td>
                                                  <td bgcolor="#FFFFEC"><font color="#FF0033">※簡易タグ</font>
                                                    <select onchange="this.form.convtag.value = this.value;">$mail_reflect_tag</select>&nbsp;<input type="text" style="background-color:#EEEEEE" name="convtag" size="15" onfocus="this.select();">
                                                    <br>
                                                    上のタグ集を参考に、件名・本文中にタグを打ち込んでください。</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2"><input name="content-type" type="radio" value="0" $_text>
                                                    テキスト形式を既定とする</td>
                                                  </tr>
                                                <tr> 
                                                  <td colspan="2"><textarea name="body" cols="65" rows="20" id="body">$body</textarea></td>
                                                  </tr>
                                                <tr>
                                                  <td colspan="2">&nbsp;</td>
                                                  </tr>
                                                <tr>
                                                  <td colspan="2"><input name="content-type" type="radio" value="1" $_html>
                                                    HTML形式を既定とする</td>
                                                  </tr>
                                                <tr>
                                                  <td colspan="2"><br>　
                                                    → <a href="$indexcgi?md=mb_html&id=$id&n=$n"><font color="#0000FF">HTML形式の設定はこちら</font></a><br>
                                                    <br>　
                                                    <font color="#FF0000">HTML形式のを既定とした場合、「ヘッダ」「解除案内」「フッタ」の設定は<br>　
                                                    無視されます。<br>
                                                    　</font></td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td bgcolor="#FFFFCC">解除案内</td>
                                                  <td><input name="cancel" type="checkbox" id="cancel" value="checkbox" $c>
                                                    挿入する</td>
                                                </tr>
                                                <tr> 
                                                  <td bgcolor="#FFFFCC">フッター</td>
                                                  <td><input name="footer" type="checkbox" id="footer" value="checkbox" $f>
                                                    挿入する</td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2" align="center"> 
                                                    <input name="id" type="hidden" id="id" value="$id"> 
                                                    <input name="n" type="hidden" id="n" value="$n"> 
                                                    <input name="md" type="hidden" id="md" value="body"> 
                                                    <input type="submit" value="　更新を反映　"></td>
                                                </tr>
                                              </table>
$sub_message
                                            </form></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table>
END
	return $main_table;
}

sub form_mailbody_html {
	my( $h, $c, $f, $_text, $_html, $num, $btitle, $body, $n, $id, $filename ) = @_;
	my $prev = ( $filename ne '' )? qq|<a href="$indexcgi?md=htmlprev&id=$id&n=$n" target="_blank"><font color="#0000FF">設定済みHTMLファイルのプレビュー( $filename )</font></a>|: 'HTMLファイルは設定されていません。';
	
	my $main_table = <<"END";
                               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="499"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="523"> <form action="index.cgi" method="post" enctype="multipart/form-data" name="form1">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                                <tr> 
                                                  <td colspan="2"><strong>本文[ $num ] HTML形式の設定</strong> </td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">配信したいHTMLファイルを参照ボタンから選択し、<strong>決定</strong>ボタンをクリックしてください。</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">また、この本文を配信するためには、<a href="$indexcgi?md=ml&id=$id&n=$n"><font color="#0000FF">本文の編集トップ</font></a>画面で「<strong>HTML形式を既定とする</strong>」にチェックする必要があります。</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2"></td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td width="100" bgcolor="#FFFFCC">HTMLファイル</td>
                                                  <td width="400"><input name="html" type="file" id="html" size="50">
                                                    <br>
                                                    $prev</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2"><br><font color="#FF0000">・</font><font color="#FF0000">配信するHTML形式の本文は、専用のHTMLファイルをご用意ください。<br>
                                                    ・画像ファイルを貼\り付けている場合はローカルPC上で表\示確認を行ってください。<br>
                                                    ・テキスト形式と同様に【簡易タグ】が利用可能\です。<br>
                                                    ・他の本文で使用している同名のファイルはアップロードできません。<br>
                                                    ・日本語ファイル名は強制的に半角へ変換されます。<br>
                                                    ・HTMLファイルの文字コートを指定する際は、'iso-2022-jp'でご指定ください。<br>
                                                    　&lt;meta http-equiv="Content-Type" content="text/html; charset=iso-2022-jp"&gt;</font>
                                                    </td>
                                                  </tr>
                                                <tr>
                                                  <td colspan="2"></td>
                                                  </tr>
                                                <tr> 
                                                  <td colspan="2"> 
                                                    <input name="id" type="hidden" id="id" value="$id"> 
                                                    <input name="n" type="hidden" id="n" value="$n"> 
                                                    <input name="md" type="hidden" id="md" value="html"> 
                                                    　　<input type="submit" value="　決定　"><input name="del" type="submit" value="　設定を削除する　"></td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2" align="center">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">■ 画像ファイルのアップロード</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2"><br>
                                                    画像ファイルはご自身で用意し、FTPソ\フトを使って任意のサーバーにアップロード<br>
                                                    してください。<br>
                                                    また、画像ファイルはURL（http://～）でパス指定してください。<br>
                                                    ただし、レンタルサーバーの中には外部から画像ファイルの直リンクを制限している<br>
                                                    場合があります。<br>
                                                    その場合は画像ファイルを貼\り付けても表\示されませんので、該当のHTMLファイルが<br>
                                                    ローカルPC上で正常に表\示されるかご確認ください。<br>
                                                    <br>
                                                    この管理画面で画像ファイルを管理したい場合は以下のリンクより画像ファイルを<br>
                                                    アップロードしてください。<br>
                                                    <br>　
                                                    → <a href="javascript: void(0);" onClick="window.open('$indexcgi?md=imgupload', 'imgup', 'width=600,height=500,menubar=no,scrollbars=yes');"><font color="#0000FF">画像ファイル管理へ</font></a><br></td>
                                                </tr>
                                              </table>
                                            </form></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table>
END
	return $main_table;
}

sub htmlprev {
	
	my $id = &delspace( $param{'id'} -0 );
	my $n = &delspace( $param{'n'} );
    $n -= 0 if ( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );
	
	#--------------------------#
	# 既存のプランデータを取得 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$fileのパーミッションを確認してください");
		exit;
	}
	my($queuedir, $queue );
	while( <PLAN> ) {
		my ( $index, $file ) = ( split(/\t/) )[0, 7];
		if ( $index eq $id ) {
			$queuedir = $myroot . $data_dir . $queue_dir;
			$queue    = $queuedir . $file;
			last;
		}
	}
	close(PLAN);
	&make_plan_page( 'plan', '', 'エラー<br>該当するプランがありません') if (!$queue);
	my $flag = 0;
	my $filename;
	unless( open(BODY, $queue ) ){
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">システムエラー</font><br><br>ファイルが開けません<br>$queueのパーミッションを確認してください");
		exit;
	}
	while( <BODY> ) {
		chomp;
		my @_lines = split(/\t/);
		if ( $_lines[0] eq $n ) {
			$flag = 1;
			$filename = $_lines[7];
		}
	}
	close(BODY);
	my $path = $queuedir . $filename;
	my $message;
	if( $flag && -e $path ){
		open( HTML, $path );
		while(<HTML>){
			$message .= $_;
		}
		close(HTML);
	}else{
		&error('エラー', '該当するHTMLファイルがありません。');
	}
	$CONTENT_TYPE = 'text/html';
	# 転送
	$message = &Click'prev1( $id, $message ) if( $n =~ /^\d+$/ );
	$message = &include( \@temdata, $message, 1, 1 );
	# 転送変換(プレビュー用)
	$message = &Click'prev2( $message ) if( $n =~ /^\d+$/ );
	print "Content-type: text/html", "\n\n";
	print $message;
	exit;
	
}

sub scheduleOption
{
	my( $step, $schedule, $ref, $sended, $target, $registTime,$baseTime ) = @_;
	
	$registTime = ( $registTime > 0 )? $registTime: time;
	#my $time = $registTime;
	my $option;
	my $script_array;
	my $next_step = ($ref && $sended > 1)? $sended+1: 2;
	$next_step = $target if( $target ne '' );
	#foreach( split(/<>/, $baseTime) ){
	#	my( $n, $time ) = split(/\//);
	#	$base{$n} = $time;
	#}
	# ステップメール日程を取得
	my @step = split( /,/, (split(/<>/,$schedule))[0] );
	
	my $base = &getBaseTime($registTime,$schedule,$baseTime, $sended);
	
	my $count = (split(/,/, $step ))[0];
	for( $i=0; $i<$count; $i++ ){
		my $n = $i+2;
		my( $inter, $config ) = split( /\//,$step[$i] );
		next if( $sended > 0 && $sended >= $n );
		
		#my $time = ($sended < $n)? ( $inter * 60*60*24 ) + $base->{$n}:  ( $inter * 60*60*24 ) + time;
		my $time = ( $inter * 60*60*24 ) + $base->{$n};
		my $date = &make_date3( $time );
		my $next = ( $config )? qq|第$n回 （開始日を指定してください）|: qq|第$n回 （$date 配信）$stop|;
		$next = qq|第$n回 （次回配信回）| if( $ref &&  $next_step == $n && $target ne 'end' );
		my $selected = ' selected="selected"' if( $target == $n );
		
		if( $ref ){
			$script_array .= ( $config && $next_step ne $n && $target ne $n )? qq|chk[$n] = 1;|: qq|chk[$n] = 0;|;
		}else{
			$script_array .= ( $config )? qq|chk[$n] = 1;|: qq|chk[$n] = 0;|;
		}
		$option .= qq|<option value="$n"$selected>$next</option>\n|;
	}
	# 配信終了
	if( $count > 0 ){
		my $n = $count+1;
		my $selected = ' selected="selected"' if( $target eq 'end' );
		my $end = 'end' if( $sended < $n );
		$option .= qq|<option value="$end"$selected>配信終了</option>|;
	}else{
		$option .= qq|<option value="">指定なし</option>|;
	}
	return $option, $script_array;
}

sub ToYearOption
{
	my( $target ) = @_;
	
	my $t = time;
	local($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($t+(60*60*9));
	$year += 1900;
	my $option;
	$option = qq|<option value="">----</option>\n| if( $target eq '' );
	$option .= qq|<option value="0">毎年</option>\n|;
	for( my $i=0; $i<=1; $i++ ){
		$year += $i;
		my $selected = ' selected="selected"' if( $target == $year );
		$option .= qq|<option value="$year"$selected>$year</option>\n|;
	}
	return $option;
}
1;
