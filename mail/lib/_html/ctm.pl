package Ctm;
#--------------------------------------------
# 楽メールpro
# 画面カスタマイズ関連関数群
# ver2.2
#--------------------------------------------

# 互換性チェック
&compatibility();

# 項目表示順設定
@names = (
			{'name' => 'id', 'value' => '登録者ID'},
			{'name' => 'co', 'value' => '会社名'},
			{'name' => '_co', 'value' => '会社名フリガナ'},
			{'name' => 'sei', 'value' => '姓'},
			{'name' => '_sei', 'value' => '姓フリガナ'},
			{'name' => 'mei', 'value' => '名'},
			{'name' => '_mei', 'value' => '名フリガナ'},
			{'name' => 'name', 'value' => 'お名前'},
			{'name' => '_name', 'value' => 'お名前フリガナ'},
			{'name' => 'mail', 'value' => 'メールアドレス'},
			{'name' => '_mail', 'value' => 'メールアドレス確認'},
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
			{'name' => 'free21', 'value' => 'フリー項目２１'},
			{'name' => 'free22', 'value' => 'フリー項目２２'},
			{'name' => 'free23', 'value' => 'フリー項目２３'},
			{'name' => 'free24', 'value' => 'フリー項目２４'},
			{'name' => 'free25', 'value' => 'フリー項目２５'},
			{'name' => 'free26', 'value' => 'フリー項目２６'},
			{'name' => 'free27', 'value' => 'フリー項目２７'},
			{'name' => 'free28', 'value' => 'フリー項目２８'},
			{'name' => 'free29', 'value' => 'フリー項目２９'},
			{'name' => 'free30', 'value' => 'フリー項目３０'},
);


sub regulation_dataline
{
	my %hash;
	$hash{'co'} = 15;
	$hash{'_co'} = 16;
	$hash{'sei'} = 61;
	$hash{'_sei'} = 62;
	$hash{'mei'} = 63;
	$hash{'_mei'} = 64;
	$hash{'name'} = 17;
	$hash{'_name'} = 18;
	$hash{'mail'} = 19;
	$hash{'_mail'} = 65;
	$hash{'tel'} = 20;
	$hash{'fax'} = 21;
	$hash{'url'} = 22;
	$hash{'code'} = 23;
	$hash{'address'} = 24;
	$hash{'address1'} = 25;
	$hash{'address2'} = 26;
	$hash{'address3'} = 27;
	$hash{'free1'} = 28;
	$hash{'free2'} = 29;
	$hash{'free3'} = 30;
	$hash{'free4'} = 31;
	$hash{'free5'} = 32;
	$hash{'free6'} = 43;
	$hash{'free7'} = 44;
	$hash{'free8'} = 45;
	$hash{'free9'} = 46;
	$hash{'free10'} = 47;
	$hash{'free11'} = 48;
	$hash{'free12'} = 49;
	$hash{'free13'} = 50;
	$hash{'free14'} = 51;
	$hash{'free15'} = 52;
	$hash{'free16'} = 53;
	$hash{'free17'} = 54;
	$hash{'free18'} = 55;
	$hash{'free19'} = 56;
	$hash{'free20'} = 57;
	$hash{'free21'} = 66;
	$hash{'free22'} = 67;
	$hash{'free23'} = 68;
	$hash{'free24'} = 69;
	$hash{'free25'} = 70;
	$hash{'free26'} = 71;
	$hash{'free27'} = 72;
	$hash{'free28'} = 73;
	$hash{'free29'} = 74;
	$hash{'free30'} = 75;
	
	return %hash;
}

sub regulation_csvline
{
	my %hash;
	$hash{'co'} = 1;
	$hash{'_co'} = 2;
	$hash{'sei'} = 37;
	$hash{'_sei'} = 38;
	$hash{'mei'} = 39;
	$hash{'_mei'} = 40;
	$hash{'name'} = 3;
	$hash{'_name'} = 4;
	$hash{'mail'} = 5;
	$hash{'tel'} = 6;
	$hash{'fax'} = 7;
	$hash{'url'} = 8;
	$hash{'code'} = 9;
	$hash{'address'} = 10;
	$hash{'address1'} = 11;
	$hash{'address2'} = 12;
	$hash{'address3'} = 13;
	$hash{'free1'} = 14;
	$hash{'free2'} = 15;
	$hash{'free3'} = 16;
	$hash{'free4'} = 17;
	$hash{'free5'} = 18;
	$hash{'free6'} = 22;
	$hash{'free7'} = 23;
	$hash{'free8'} = 24;
	$hash{'free9'} = 25;
	$hash{'free10'} = 26;
	$hash{'free11'} = 27;
	$hash{'free12'} = 28;
	$hash{'free13'} = 29;
	$hash{'free14'} = 30;
	$hash{'free15'} = 31;
	$hash{'free16'} = 32;
	$hash{'free17'} = 33;
	$hash{'free18'} = 34;
	$hash{'free19'} = 35;
	$hash{'free20'} = 36;
	$hash{'free21'} = 41;
	$hash{'free22'} = 42;
	$hash{'free23'} = 43;
	$hash{'free24'} = 44;
	$hash{'free25'} = 45;
	$hash{'free26'} = 46;
	$hash{'free27'} = 47;
	$hash{'free28'} = 48;
	$hash{'free29'} = 49;
	$hash{'free30'} = 50;
	
	return %hash;
}

sub regulation_detail
{
	my %hash;
	$hash{'text'} = 'テキストフォーム';
	$hash{'textarea'} = 'テキストエリア';
	$hash{'select'} = 'セレクトメニュー';
	$hash{'checkbox'} = 'チェックボックス';
	$hash{'radio'} = 'ラジオボタン';
	return %hash;
}

sub Form
{
	my ($utf, $r_prop ) = @_;
	my $action = $main'param{'act'};
	
	my $table;
	if( $action eq 'top' ){
		$table = &F_top();
	}elsif( $action eq 'form' ){
		$table = &F_customize( $utf, $r_prop );
	}elsif( $action eq 'renew' ){
		&renew();
		$table = &F_customize( $utf, $r_prop );
	}
	return $table;
}

sub F_top
{
	my $self = $main'indexcgi;
	my $id = $main'param{'id'};
	my $table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$self">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>本プランの登録時の画面カスタマイズを行います。</td>
                                          </tr>
                                          <tr> 
                                            <td>カスタマイズする画面メニューリンクをクリックしてください。</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>▼PC専用画面</td>
                                          </tr>
                                          <tr>
                                            <td><table width="450" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td colspan="2" bgcolor="#ABDCE5"><table width="450" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td width="150" bgcolor="#E5FDFF">エラー画面</td>
                                                    <td width="300" bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=err"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=err" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">入力確認画面</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=conf"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=conf" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">登録完了画面</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=end"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=end" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">変更完了画面</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=renew"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=renew" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">解除完了画面</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=delete"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=delete" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                </table></td>
                                                </tr>
                                              
                                            </table></td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>▼携帯用画面</td>
                                          </tr>
                                           <tr>
                                            <td><table width="450" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td colspan="2" bgcolor="#ABDCE5"><table width="450" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td width="150" bgcolor="#E5FDFF">エラー画面</td>
                                                    <td width="300" bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=err&m=1"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=err&m=1" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">入力確認画面</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=conf&m=1"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=conf&m=1" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">登録完了画面</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=end&m=1"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=end&m=1" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">変更完了画面</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=renew&m=1"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=renew&m=1" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">解除完了画面</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=delete&m=1"><font color="#0000FF">編集する</font></a>　<a href="$self?id=$id&md=ctm_regprev&type=delete&m=1" target="_blank"><font color="#0000FF">プレビュー</font></a></td>
                                                  </tr>
                                                </table></td>
                                                </tr>
                                              
                                            </table></td>
                                          </tr>
                                          <tr> 
                                            <td align="center"><input name="id" type="hidden" id="id" value="$id">
                                              <input name="action" type="hidden" id="action"></td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
	return $table;
}


sub F_customize
{
	my( $utf, $r_prop ) = @_;
	my $self = $main'indexcgi;
	my $type = $main'param{'type'};
	my $id = $main'param{'id'};
	my $mobile = $main'param{'m'} -0;
	
	my $m = '&m=1' if( $mobile );
	my $m_message2 = <<"END";
	                            <tr>
                                  <td><font color="#FF0000">※全ての携帯で動作を保証するものではありません。</font></td>
                                </tr>
END
	$m_message2 = '' if( !$mobile );
	
	# 表示文
	my $link_err  = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=err$m"><font color="#0000FF">エラー画面へ</font></a>|;
	my $link_conf = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=conf$m"><font color="#0000FF">入力確認画面へ</font></a>|;
	my $link_end  = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=end$m"><font color="#0000FF">登録完了画面へ</font></a>|;
	my $link_renew  = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=renew$m"><font color="#0000FF">変更完了画面へ</font></a>|;
	my $link_delete = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=delete$m"><font color="#0000FF">解除完了画面へ</font></a>|;
	
	my $disp;
	my $default_message;
	if( $type eq 'err' ){
		$disp = 'エラー';
		$link_err = '<strong>エラー画面</strong>';
	}elsif( $type eq 'conf' ){
		$disp = '入力確認';
		$link_conf = '<strong>入力確認画面</strong>';
		$default_message = '<font color="#FF0000">利用する「登録用フォーム」項目の変更を行った場合、変更した項目情報を反映するには、一度デザインを初期化していただき、再度デザインのカスタマイズをして頂く必要があります。</font>';
		$tag = <<"END";
<tr><td>
<table>
                                          <tr>
                                            <td align="center" valign="middle" nowrap bgcolor="#FFFFEE"><font color="#FF0000">※変換タグ
                                            </font></td>
                                            <td><select onchange="this.form.convtag.value = this.value;">$main'confirm_reflect_tag</select>&nbsp;<input type="text" style="background-color:#EEEEEE" name="convtag" size="15" onfocus="this.select();">
                                              <br>
                                                簡易タグが利用できます。<br>
                                                上のタグ集を参考に、ソ\ース内にタグを記述ください。</td>
                                          </tr>
</table>
</td></tr>
END
	}elsif( $type eq 'end' ){
		$disp = '登録完了';
		$link_end = '<strong>登録完了画面</strong>';
		$tag = <<"END";
<tr><td>
<table>
                                          <tr>
                                            <td align="center" valign="middle" nowrap bgcolor="#FFFFEE"><font color="#FF0000">※変換タグ
                                              </font></td>
                                            <td><select onchange="this.form.convtag.value = this.value;">$main'thanks_reflect_tag</select>&nbsp;<input type="text" style="background-color:#EEEEEE" name="convtag" size="15" onfocus="this.select();"><br>
                                            簡易タグが利用できます。<br>
                                            上のタグ集を参考に、ソ\ース内にタグを記述ください。<br>
                                            <br><font color="#FF0000">
                                            <strong>※「登録者ID」とは</strong><br>
                                            各登録者に対して、登録順に自動生成される半角数字の通し番号です。</font></td>
                                          </tr>
</table>
</td></tr>
END
	}elsif( $type eq 'renew' ){
		$disp = '変更完了';
		$link_renew = '<strong>変更完了画面</strong>';
	}elsif( $type eq 'delete' ){
		$disp = '解除完了';
		$link_delete = '<strong>解除完了画面</strong>';
	}
	
	# ソースを取得
	local $array_source = &find( $id, $type, $utf, $mobile );
	local $source = join( "", @$array_source );
	
	# Jcode.pmを読み込んで文字コード変換(sjisへ)
	&lib_inc();
	my $code = $jcodegetcode->($source);
	$jcodeconvert->(\$source, 'sjis', $code );
	
	# <%registtable%>を変換
	my $source_table = &_table( $r_prop, 0, $mobile ) if( $type eq 'conf' );
	$source =~ s/<%registtable%>/$source_table/;
	
	# タグを変換
	$source  = &main'deltag( $source );
	my $table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$self">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>本プランの登録時の<strong>$disp画面</strong>のカスタマイズを行います。</td>
                                          </tr>
                                          <tr> 
                                            <td>HTMLソ\ースを入力し「<strong>更新を反映する</strong>」をクリックしてください。</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>[ $link_err ]　[ $link_conf ]　[ $link_end ]　[ $link_renew ]　<br>[ $link_delete ] </td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>以下に<strong>HTMLソ\ース</strong>を入力してください。　　<a href="$self?id=$id&md=ctm_regprev&type=$type$m" target="_blank"><font color="#0000FF">&gt;&gt;保存済みの画面プレビュー</font></a></td>
                                          </tr>
                                          <tr>
                                            <td><textarea name="source" cols="60" rows="30" wrap="off">$source</textarea></td>
                                          </tr>
$m_message2
                                          $tag
                                          <tr>
                                            <td><input name="renew" type="submit" id="renew" value="　更新を反映する　">
                                              <input name="default" type="submit" id="default" value="　初期化する　"></td>
                                          </tr>
                                          <tr> 
                                            <td align="center"><input name="id" type="hidden" id="id" value="$id">
                                              <input name="md" type="hidden" id="md" value="ctm_regdisp">
                                              <input name="m" type="hidden" id="type" value="$mobile">
                                              <input name="act" type="hidden" id="act" value="renew">
                                              <input name="type" type="hidden" id="type" value="$type"></td>
                                          </tr>
                                          <tr>
                                            <td bgcolor="#FFFFEE">１．&lt;%***%&gt;と記述されている箇所は編集・削除しないでください。<br>
                                              ２．&lt;form&gt;   ～ &lt;/form&gt;内に&lt;form&gt;は入れないでください。<br>
                                              ３．HTMLソ\ースで生成される項目以外のデータはご利用いただけません。<br>
                                              ４．ホームページビルダー上に上記ソ\ースをコピーして編集する場合、ホームページビルダーの自動修正機能\を停止してください。</td>
                                          </tr>
                                           <tr>
                                            <td><strong>$default_message</strong> &nbsp;</td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
	return $table;
}

sub _table
{
	my( $prop, $prev, $mobile ) = @_;
	
	my $table;
	# 項目番号 フォーム設定
	%rFORM = &regulation_dataline();
	
	# 項目番号 登録者情報CSV番号
	%rCSV = &regulation_csvline();
	
	# 表示順On
	my @SortOn;
	# 表示順Off
	my @SortOff;
	
	for ( my $i=1; $i<@names; $i++ ) {
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		
		my $confdata = ( $prev )? $main'temdata[$rCSV{$r_name}]: qq|<%$r_name%>&nbsp;|;
		
		if ( ( split(/<>/, $prop->[$r_num]) )[0] ) {
			
			my $fname = ( (split(/<>/,$prop->[$r_num]))[1] )? (split(/<>/,$prop->[$r_num]))[1]: $r_val;
			my $tr = qq|<tr><td width="120">$fname</td><td width="280">$confdata</td></tr>\n| if( $r_name ne '_mail');
			my $tr_m = qq|$fname：<br>\n$confdata<br><br>\n| if( $r_name ne '_mail');
			my $line = ($mobile )? $tr_m: $tr;
			my $sort = ( split(/<>/, $prop->[$r_num]) )[3];
			if( $sort > 0 ){
				$SortOn[$sort] = $line;
			}else{
				push @SortOff, $line;
			}
		}
	}
	
	foreach( @SortOn ){
		$table .= $_;
	}
	foreach( @SortOff ){
		$table .= $_;
	}
	
	return $table;
}

sub Prev
{
	my( $utf, $prop ) = @_;
	
	my $type  = $main'param{'type'};
	local $id = $main'param{'id'};
	my $mobile = $main'param{'m'} -0;
	$utf = 0 if( $mobile );
	# ソースを取得
	local $array_source = &find( $id, $type, $utf, $mobile );
	
	# <%registtable%>部分を取得
	local $source_table = &_table( $prop, 1, $mobile ) if( $type eq 'conf' );
	
	# Jcode.pmを読込
	&lib_inc();
	
	# 仮データを挿入
	if( $type eq 'err' ){
		$subject = '入力エラー';
		$message = '<em><font color="#336600">&lt;ここにエラー内容が記載されます。&gt;</font></em>';
	}
	
	# 項目番号 登録者情報CSV番号
	%rCSV = &regulation_csvline();
	
	for ( my $i=0; $i<@names; $i++ ) {
		next if( $type ne 'end' && $i == 0 );
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		
		local $confdata = $main'temdata[$rCSV{$r_name}];
		if( $utf ){
			$jcodeconvert->(\$confdata, 'utf8');
		}
		$$r_name = $confdata;
	}
	
	my $_url = '';
	if( $prop->[39] ){
		if( $type eq 'end' ){
			$_url = qq|<a href="http://$prop->[12]"><font color="#0000FF">戻る</font></a>|;
		}elsif( $type eq 'renew' ){
			$_url = qq|<a href="http://$prop->[13]"><font color="#0000FF">戻る</font></a>|;
		}elsif( $type eq 'delete' ){
			$_url = qq|<a href="http://$prop->[14]"><font color="#0000FF">戻る</font></a>|;
		}
	}
	$url = $_url if( $type ne 'conf' );
	
	# 文字コードを統一
	if( $utf ){
		$jcodeconvert->(\$source_table, 'utf8');
		$jcodeconvert->(\$subject, 'utf8');
		$jcodeconvert->(\$message, 'utf8');
		$jcodeconvert->(\$url, 'utf8');
	}
	
	my @source;
	foreach( @$array_source ){
		local $line = $_;
		if( $utf ){
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
	
	print "Content-type: text/html", "\n\n";
	foreach( @source ) {
		local $line = $_;
		$line =~ s/(<\s*meta.*http-equiv.*charset.*>)/$meta/i;
		$_ = $line;
		while( ( $parameter ) = ( /<%([^<>\%]+)%>/oi ) ) {
			s//$$parameter/;
		}
        print $_;
    }
	exit;
}

sub renew
{
	my $self = $main'self;
	my $type = $main'param{'type'};
	my $id   = $main'param{'id'};
	my $mobile = $main'param{'m'}  -0;
	
	my( $default_file, $ctm_file, $target_file ) = &get_path( $id, $type, $mobile );
	
	if( defined $main'param{'default'} ){
		unlink $ctm_file;
	}
	if( defined $main'param{'renew'} ){
		$main'param{'source'} =~ s/(\s\s)$//;
		my $source = &main'delspace( $main'param{'source'} );
		$source = &main'deltag( $source );
		$source = &main'the_text( $source );
		$source =~ s/<br>/\n/gi;
		$source =~ s/&lt;/</gi;
		$source =~ s/&gt;/>/gi;
		$source =~ s/&quot;/\"/gi;
		$source =~ s/&amp;/\&/gi;
		
		my $ctm_dir = &compatibility();
		my $tmp = $ctm_dir. 'CTM-'. $$. time. '.cgi';
		open( CTM, ">$tmp");
		print CTM $source;
		close(CTM);
		chmod 0606, $tmp;
		rename $tmp, $ctm_file;
	}
	
}
sub clean
{
	my( $id ) = @_;
	my @type = ( 'err','conf','end','renew','delete' );
	foreach my $type ( @type ){
		my( $default_file, $ctm_file, $target_file ) = &get_path( $id, $type );
		my( $default_file_m, $ctm_file_m, $target_file_m ) = &get_path( $id, $type, 1 );
		if( -f $ctm_file ){
			unlink $ctm_file;
		}
		if( -f $ctm_file_m ){
			unlink $ctm_file_m;
		}
	}
}

sub find
{
	my( $id, $type, $utf, $mobile ) = @_;
	
	my( $default_file, $ctm_file, $target_file ) = &get_path( $id, $type, $mobile );
	my @source;
	open( CTM, $target_file );
	while(<CTM>){
		push @source, $_;
	}
	close(CTM);
	
	#my $source = join("",@source);
	return [@source];

}

sub get_path
{
	my( $id, $type, $mobile ) = @_;
	my $ctm_dir = &compatibility();
	
	my $default_dir = $main'myroot . $main'template;
	my $default_file;
	my $ctm_file;
	if( $mobile ){
		$default_file = $default_dir . $main'err_m     if( $type eq 'err' );
		$default_file = $default_dir . 'confirm_m.pl'  if( $type eq 'conf' );
		$default_file = $default_dir . 'confirm1_m.pl' if( $type eq 'end' );
		$default_file = $default_dir . 'confirm2_m.pl' if( $type eq 'renew' );
		$default_file = $default_dir . 'confirm3_m.pl' if( $type eq 'delete' );
		$ctm_file = $ctm_dir . $id . '_' . $main'err_m     if( $type eq 'err' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm_m.pl'  if( $type eq 'conf' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm1_m.pl' if( $type eq 'end' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm2_m.pl' if( $type eq 'renew' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm3_m.pl' if( $type eq 'delete' );
	}else{
		$default_file = $default_dir . $main'err     if( $type eq 'err' );
		$default_file = $default_dir . 'confirm.pl'  if( $type eq 'conf' );
		$default_file = $default_dir . 'confirm1.pl' if( $type eq 'end' );
		$default_file = $default_dir . 'confirm2.pl' if( $type eq 'renew' );
		$default_file = $default_dir . 'confirm3.pl' if( $type eq 'delete' );
		$ctm_file = $ctm_dir . $id . '_' . $main'err     if( $type eq 'err' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm.pl'  if( $type eq 'conf' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm1.pl' if( $type eq 'end' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm2.pl' if( $type eq 'renew' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm3.pl' if( $type eq 'delete' );
	}
	my $target_file;
	$target_file = ( -f $ctm_file )? $ctm_file: $default_file;
	
	return $default_file, $ctm_file, $target_file;
}


sub compatibility
{
	my $dir = $main'myroot . $main'data_dir;
	my $path_dir = $dir . 'mkform/';
	
	unless( -d $path_dir ){
		my $flag = mkdir $path_dir, 0707;
		if( !$flag ){
			&main'error("<strong>ディレクトリが作成できません。","</strong><br><br><br>$dir<br><br>のパーミッションがただしく設定されているかご確認ください。");
		}
		chmod 0707, $path_dir;
	}
	
	if( !( -x $path_dir) || !( -w $path_dir) ){
		&main'error("パーミッションエラー","<br><br><br>$path_dir<br><br>のパーミッションが[707]に正しく設定されているかご確認ください。");
	}
	
	return $path_dir;
}

# デバッグ用
sub debug {

	print "Content-type: text/html\n\n";
	print "<html><head><title>CGI Error</title></head>\n";
	print "<body>\n";
	print "<br>$_[0]<br>";
	print "</body></html>\n";
	exit;
}

#-----------------------#
# 日本語変換関数の指定  #
#-----------------------#
sub jcode_rap {
	eval 'use Jcode;';
	if( $@ ){
		return \&jcode'convert, sub{ $str = shift; my $code = &jcode'getcode($str); return $code;};
	}else{
		return \&Jcode'convert, sub{ $str = shift; my($code, $len )= &Jcode'getcode($str); return $code;};
	}
}

sub lib_inc {
	unshift( @main'INC, "../lib/Jcode" );
	($jcodeconvert, $jcodegetcode ) = &jcode_rap();
}

sub jcode_check
{
	unshift( @main'INC, "../lib/Jcode" );
	eval 'use Jcode;';
	if( $@ ){
		return 0;
	}else{
		return 1;
	}
}

1;
