package MF;
#--------------------------------------------
# 楽メールpro
# フォーム生成関連関数群
# ver2.4
#--------------------------------------------

# フリー項目 詳細設定
my $Dir     = $main::myroot . $main::data_dir;
my $logfile = $Dir . 'mk.cgi';

sub _getlogfile
{
	return $logfile;
}

sub logfile_find
{
	unless( -e $logfile ){
		unless( open( LOGFILE, ">$logfile" ) ){
			&main'error("システムエラー","ログファイル構\成に誤りがあります。<br><br><strong>$Dir</strong>　のパーミッション設定をご確認ください。");
		}
		close(LOGFILE);
	}
}

sub action
{
	&logfile_find();
	my $act = $main'param{'act'};
	if( $act eq 'wd' )         { &form_detail(); }
	elsif( $act eq 'set_type' ){ &set_type(); }
	elsif( $act eq 'fs' )      { &form_detail_prop('select'); }
	elsif( $act eq 'fc' )      { &form_detail_prop('checkbox'); }
	elsif( $act eq 'fr' )      { &form_detail_prop('radio'); }
	elsif( $act eq 'set_prop' ){ &set_prop(); }
	exit;
}


sub form_top
{
	my( $id, @line ) = @_;
	
	# デザインテンプレート
	my $designFile = $line[81];
	my $design = &_getDesignTemplate();
	my $designOption;
	foreach( @$design ){
		my $name = $_->[0];
		my $html = $_->[1];
		my $selected = ($designFile eq $html)? ' selected="selected"': '';
		$designOption .= qq|<option value="$html"$selected>$name</option>\n|;
	}
	
	
	
	my $st = 15;  # 配列のインデックス
	my $end = 27;
	for ( my $i=$st; $i<=$end; $i++ ) {
		my ( $ck, $name, $req, $sort ) = split(/<>/, $line[$i]);
		${"checked$i"}    = 'checked' if($ck);
		${"reqchecked$i"} = 'checked' if($req);
		${"text$i"}       = &main'make_text($name);
		# 表示順取得
		${"sort$i"} = &_getSort( $i, $sort );
	}
	# お名前関連項目（姓名別フラグ） ※v2.2から廃止 apply.cgiの登録時のみ設定が有効
	my( $sep1, $sep1_1, $sep1_2 ) = split(/<>/, $line[58]);
	$checked_17 = 'checked' if($sep1);
	my( $sep2, $sep2_1, $sep2_2 ) = split(/<>/, $line[59]);
	$checked_18 = 'checked' if($sep2);
	
	# 姓名別フォーム + メールアドレス確認
	$st = 61;  # 配列のインデックス
	$end = 65;
	for ( my $i=$st; $i<=$end; $i++ ) {
		my ( $ck, $name, $req, $sort ) = split(/<>/, $line[$i]);
		${"checked$i"}    = 'checked' if($ck);
		${"reqchecked$i"} = 'checked' if($req);
		${"text$i"}       = &main'make_text($name);
		# 表示順取得
		${"sort$i"} = &_getSort( $i, $sort );
	}
	#------------------------------------------
	# ここからフリー項目
	#------------------------------------------
	# 配列のインデックス
	my @findex;
	foreach my $i ( 28 .. 32 ){
		push @findex, $i;
	}
	foreach my $i ( 43 .. 57 ){
		push @findex, $i;
	}
	foreach my $i ( 66 .. 75 ){
		push @findex, $i;
	}
	
	#$st = 28;  
	#$end = 32;
	my %form_name;
	my %fname = &Ctm'regulation_detail();
	# 詳細情報を取得
	my %detail = &_get_detail_list( $id );
	my $fn = 1; # フリー項目番号（1から順）
	foreach my $i ( @findex ){
		my ( $ck, $name, $req, $sort ) = split(/<>/, $line[$i]);
		${"checked$i"}    = 'checked' if($ck);
		${"reqchecked$i"} = 'checked' if($req);
		${"text$i"}       = &main'make_text($name);
		my $fname = ( defined $detail{$fn} )? $fname{$detail{$fn}}: $fname{'text'};
		${"detail$i"}     = qq|<font color="#666666">【現在の設定】</font>　<strong><font color="#333333"><span id="free$fn">$fname</span></font></strong><br><a href="javascript: void(0);" onClick="javascript: window.open('$main'indexcgi?md=fdetail&act=wd&fn=$fn&id=$id', '_blank', 'width=600,height=500,scrollbars=yes');"><font color="#0000FF">[ フォームタイプ詳細設定 ]</font></a>|;
		$fn++;
		
		# 表示順取得
		${"sort$i"} = &_getSort( $i, $sort );
	}
	#$st = 43;  # 配列のインデックス
	#$end = 57;
	#$st = 66;
	#$end = 75;
	
	my $main_form = <<"END";
 <!-- saved from url=(0013)about:innternet -->
<form name="form1" method="post" action="$main'indexcgi">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="20">&nbsp;</td>
      <td width="503"><table width="100%" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td>登録用の入力フォームを指定してください</td>
          </tr>
          <tr>
            <td>入力項目に指定したい場合は<strong>「選択」</strong>にチェックしてください</td>
          </tr>
          <tr>
            <td>また、<strong>「必須」</strong>をチェックすると登録時の必須項目になります</td>
          </tr>
          <tr>
            <td>表\示する項目の名称を変更したい場合は<strong>「表\示名称」</strong>に入力してください</td>
          </tr>
          <tr>
            <td>決定後、<strong>「更新を反映」</strong>ボタンをクリックしてください</td>
          </tr>
          <tr>
            <td><br>
              <a href="./$main'indexcgi?md=mf1&id=$id"><font color="#0000FF">&gt;&gt;サンプルHTMLソ\ースを表\示</font></a>　<font color="#FF0000">※携帯用のサンプルソ\ースも表\示されます。</font><br />
              <br />
               <table width="100%" border="1" cellspacing="0" cellpadding="3">
                <tr>
                  <td width="150" align="center" bgcolor="#CCCCCC">デザインテンプレート選択</td>
                  <td width="350"><select name="design">
                    <option value="">基本簡易デザイン</option>
                    $designOption
                  </select>
                  <input type="submit" name="setDesign" value="　決定　">　[ <a href="javascript: void(0);" onClick="wopen('$main'indexcgi?md=manual&p=sample_tmp', 'sample_tmp', 700, 500);"><font color="#0000FF">デザイン一覧</font></a> ]</td>
                </tr>
                <tr>
                  <td colspan="2"><font color="#FF0000">●テンプレート選択により、「PC用サンプルHTMLソ\ース」デザインが変更されます。</font> </td>
                  </tr>
              </table>
              <br><div align="right">&gt;&gt;保存済み画面プレビューを表\示 [ <a href="$indexcgi?md=sprev&id=$id" target="_blank"><font color="#0000FF">PC用</font></a> ] [ <a href="$indexcgi?md=sprev&id=$id&m=1" target="_blank"><font color="#0000FF">携帯用</font></a> ]</div><br />
              <br />
              [<a href="javascript:void(0);" onclick="setSt(0);"><font color="#0000FF">基本項目</font></a>]　[<a href="javascript:void(0);" onclick="setSt(1);"><font color="#0000FF">フリー項目</font></a>]
              <font color="#666666">　【←更新したい項目種別をクリックしてください</font>】<br />
              <table width="100%" border="1" cellspacing="0" cellpadding="1" id="btb">
                <tr>
                  <td width="146" align="center" bgcolor="#CCCCCC">項目</td>
                  <td width="46" align="center" bgcolor="#CCCCCC">選択</td>
                  <td width="46" align="center" bgcolor="#CCCCCC">必須</td>
                  <td width="70" align="center" bgcolor="#CCCCCC">表\示順</td>
                  <td width="220" align="center" bgcolor="#CCCCCC">表\示名称</td>
                </tr>
                <tr>
                  <td>会社名</td>
                  <td align="center"><input name="fm15" type="checkbox" id="fm15" value="checkbox" $checked15></td>
                  <td align="center"><input name="req15" type="checkbox" id="req15" value="checkbox" $reqchecked15></td>
                  <td align="center">$sort15</td>
                  <td align="center"><input name="text15" type="text" id="text15" value="$text15" size="35">
                  </td>
                </tr>
                <tr>
                  <td>会社名フリガナ</td>
                  <td align="center"><input name="fm16" type="checkbox" id="fm16" value="checkbox" $checked16></td>
                  <td align="center"><input name="req16" type="checkbox" id="req16" value="checkbox" $reqchecked16></td>
                  <td align="center">$sort16</td>
                  <td align="center"><input name="text16" type="text" id="text16" value="$text16" size="35"></td>
                </tr>
                <tr>
                  <td>姓</td>
                  <td align="center"><input name="fm61" type="checkbox" id="fm61" value="checkbox" $checked61></td>
                  <td align="center"><input name="req61" type="checkbox" id="req61" value="checkbox" $reqchecked61></td>
                  <td align="center">$sort61</td>
                  <td align="center"><input name="text61" type="text" id="text61" value="$text61" size="35">
                  </td>
                </tr>
                <tr>
                  <td>姓フリガナ</td>
                  <td align="center"><input name="fm62" type="checkbox" id="fm62" value="checkbox" $checked62></td>
                  <td align="center"><input name="req62" type="checkbox" id="req62" value="checkbox" $reqchecked62></td>
                  <td align="center">$sort62</td>
                  <td align="center"><input name="text62" type="text" id="text62" value="$text62" size="35">
                  </td>
                </tr>
                <tr>
                  <td>名</td>
                  <td align="center"><input name="fm63" type="checkbox" id="fm63" value="checkbox" $checked63></td>
                  <td align="center"><input name="req63" type="checkbox" id="req63" value="checkbox" $reqchecked63></td>
                  <td align="center">$sort63</td>
                  <td align="center"><input name="text63" type="text" id="text63" value="$text63" size="35">
                  </td>
                </tr>
                <tr>
                  <td>名フリガナ</td>
                  <td align="center"><input name="fm64" type="checkbox" id="fm64" value="checkbox" $checked64></td>
                  <td align="center"><input name="req64" type="checkbox" id="req64" value="checkbox" $reqchecked64></td>
                  <td align="center">$sort64</td>
                  <td align="center"><input name="text64" type="text" id="text64" value="$text64" size="35">
                  </td>
                </tr>
                <tr>
                  <td>お名前<a href="#1"><font color="#FF0000">(※1)</font></a></td>
                  <td align="center"><input name="fm17" type="checkbox" id="fm17" value="checkbox"$checked17></td>
                  <td align="center"><input name="req17" type="checkbox" id="req17" value="checkbox" $reqchecked17></td>
                  <td align="center">$sort17</td>
                  <td align="center"><input name="text17" type="text" id="text17" value="$text17" size="35"></td>
                </tr>
                <tr>
                  <td>お名前フリガナ<a href="#2"><font color="#FF0000">(※2)</font></a></td>
                  <td align="center"><input name="fm18" type="checkbox" id="fm18" value="checkbox" $checked18></td>
                  <td align="center"><input name="req18" type="checkbox" id="req18" value="checkbox" $reqchecked18></td>
                  <td align="center">$sort18</td>
                  <td align="center"><input name="text18" type="text" id="text18" value="$text18" size="35"></td>
                </tr>
                <tr>
                  <td>メールアドレス</td>
                  <td align="center"><input name="fm19" type="checkbox" id="fm19" value="checkbox" $checked19></td>
                  <td align="center"><input name="req19" type="checkbox" id="req19" value="checkbox" $reqchecked19></td>
                  <td align="center">$sort19</td>
                  <td align="center"><input name="text19" type="text" id="text19" value="$text19" size="35"></td>
                </tr>
                <tr>
                  <td>メールアドレス確認</td>
                  <td align="center"><input name="fm65" type="checkbox" id="fm65" value="checkbox" $checked65></td>
                  <td align="center"><input name="req65" type="checkbox" id="req65" value="checkbox" $reqchecked65></td>
                  <td align="center">$sort65</td>
                  <td align="center"><input name="text65" type="text" id="text65" value="$text65" size="35"></td>
                </tr>
                <tr>
                  <td>電話番号</td>
                  <td align="center"><input name="fm20" type="checkbox" id="fm20" value="checkbox" $checked20></td>
                  <td align="center"><input name="req20" type="checkbox" id="req20" value="checkbox" $reqchecked20></td>
                  <td align="center">$sort20</td>
                  <td align="center"><input name="text20" type="text" id="text20" value="$text20" size="35"></td>
                </tr>
                <tr>
                  <td>FAX番号</td>
                  <td align="center"><input name="fm21" type="checkbox" id="fm21" value="checkbox" $checked21></td>
                  <td align="center"><input name="req21" type="checkbox" id="req21" value="checkbox" $reqchecked21></td>
                  <td align="center">$sort21</td>
                  <td align="center"><input name="text21" type="text" id="text21" value="$text21" size="35"></td>
                </tr>
                <tr>
                  <td>URL</td>
                  <td align="center"><input name="fm22" type="checkbox" id="fm22" value="checkbox" $checked22></td>
                  <td align="center"><input name="req22" type="checkbox" id="req22" value="checkbox" $reqchecked22></td>
                  <td align="center">$sort22</td>
                  <td align="center"><input name="text22" type="text" id="text22" value="$text22" size="35"></td>
                </tr>
                <tr>
                  <td>郵便番号</td>
                  <td align="center"><input name="fm23" type="checkbox" id="fm23" value="checkbox" $checked23></td>
                  <td align="center"><input name="req23" type="checkbox" id="req23" value="checkbox" $reqchecked23></td>
                  <td align="center">$sort23</td>
                  <td align="center"><input name="text23" type="text" id="text23" value="$text23" size="35"></td>
                </tr>
                <tr>
                  <td>都道府県（選択）</td>
                  <td align="center"><input name="fm24" type="checkbox" id="fm24" value="checkbox" $checked24></td>
                  <td align="center"><input name="req24" type="checkbox" id="req24" value="checkbox" $reqchecked24></td>
                  <td align="center">$sort24</td>
                  <td align="center"><input name="text24" type="text" id="text24" value="$text24" size="35"></td>
                </tr>
                <tr>
                  <td>住所１</td>
                  <td align="center"><input name="fm25" type="checkbox" id="fm25" value="checkbox" $checked25></td>
                  <td align="center"><input name="req25" type="checkbox" id="req25" value="checkbox" $reqchecked25></td>
                  <td align="center">$sort25</td>
                  <td align="center"><input name="text25" type="text" id="text25" value="$text25" size="35"></td>
                </tr>
                <tr>
                  <td>住所２</td>
                  <td align="center"><input name="fm26" type="checkbox" id="fm26" value="checkbox" $checked26></td>
                  <td align="center"><input name="req26" type="checkbox" id="req26" value="checkbox" $reqchecked26></td>
                  <td align="center">$sort26</td>
                  <td align="center"><input name="text26" type="text" id="text26" value="$text26" size="35">
                  </td>
                </tr>
                <tr>
                  <td>住所３</td>
                  <td align="center"><input name="fm27" type="checkbox" id="fm27" value="checkbox" $checked27></td>
                  <td align="center"><input name="req27" type="checkbox" id="req27" value="checkbox" $reqchecked27></td>
                   <td align="center">$sort27</td>
                  <td align="center"><input name="text27" type="text" id="text27" value="$text27" size="35"></td>
                </tr>
              </table>
              <table width="100%" border="1" cellspacing="0" cellpadding="1" id="ftb">
                <tr>
                  <td width="146" align="center" bgcolor="#CCCCCC">項目</td>
                  <td width="46" align="center" bgcolor="#CCCCCC">選択</td>
                  <td width="46" align="center" bgcolor="#CCCCCC">必須</td>
                  <td width="70" align="center" bgcolor="#CCCCCC">表\示順</td>
                  <td width="261" align="center" bgcolor="#CCCCCC">表\示名称</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１</td>
                  <td align="center"><input name="fm28" type="checkbox" id="fm28" value="checkbox" $checked28></td>
                  <td align="center"><input name="req28" type="checkbox" id="req28" value="checkbox" $reqchecked28></td>
                   <td align="center">$sort28</td>
                  <td align="center"><input name="text28" type="text" id="text28" value="$text28" size="40">
                    <br>
                    $detail28</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２</td>
                  <td align="center"><input name="fm29" type="checkbox" id="fm29" value="checkbox" $checked29></td>
                  <td align="center"><input name="req29" type="checkbox" id="req29" value="checkbox" $reqchecked29></td>
                   <td align="center">$sort29</td>
                  <td align="center"><input name="text29" type="text" id="text29" value="$text29" size="40">
                    <br>
                    $detail29</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目３</td>
                  <td align="center"><input name="fm30" type="checkbox" id="fm30" value="checkbox" $checked30></td>
                  <td align="center"><input name="req30" type="checkbox" id="req30" value="checkbox" $reqchecked30></td>
                   <td align="center">$sort30</td>
                  <td align="center"><input name="text30" type="text" id="text30" value="$text30" size="40">
                    <br>
                    $detail30</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目４</td>
                  <td align="center"><input name="fm31" type="checkbox" id="fm31" value="checkbox" $checked31></td>
                  <td align="center"><input name="req31" type="checkbox" id="req31" value="checkbox" $reqchecked31></td>
                   <td align="center">$sort31</td>
                  <td align="center"><input name="text31" type="text" id="text31" value="$text31" size="40">
                    <br>
                    $detail31</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目５</td>
                  <td align="center"><input name="fm32" type="checkbox" id="fm32" value="checkbox" $checked32></td>
                  <td align="center"><input name="req32" type="checkbox" id="req32" value="checkbox" $reqchecked32></td>
                   <td align="center">$sort32</td>
                  <td align="center"><input name="text32" type="text" id="text32" value="$text32" size="40">
                    <br>
                    $detail32</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目６</td>
                  <td align="center"><input name="fm43" type="checkbox" id="fm43" value="checkbox" $checked43></td>
                  <td align="center"><input name="req43" type="checkbox" id="req43" value="checkbox" $reqchecked43></td>
                   <td align="center">$sort43</td>
                  <td align="center"><input name="text43" type="text" id="text43" value="$text43" size="40">
                    <br>
                    $detail43</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目７</td>
                  <td align="center"><input name="fm44" type="checkbox" id="fm44" value="checkbox" $checked44></td>
                  <td align="center"><input name="req44" type="checkbox" id="req44" value="checkbox" $reqchecked44></td>
                   <td align="center">$sort44</td>
                  <td align="center"><input name="text44" type="text" id="text44" value="$text44" size="40">
                    <br>
                    $detail44</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目８</td>
                  <td align="center"><input name="fm45" type="checkbox" id="fm45" value="checkbox" $checked45></td>
                  <td align="center"><input name="req45" type="checkbox" id="req45" value="checkbox" $reqchecked45></td>
                  <td align="center">$sort45</td>
                  <td align="center"><input name="text45" type="text" id="text45" value="$text45" size="40">
                    <br>
                    $detail45</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目９</td>
                  <td align="center"><input name="fm46" type="checkbox" id="fm46" value="checkbox" $checked46></td>
                  <td align="center"><input name="req46" type="checkbox" id="req46" value="checkbox" $reqchecked46></td>
                   <td align="center">$sort46</td>
                  <td align="center"><input name="text46" type="text" id="text46" value="$text46" size="40">
                    <br>
                    $detail46</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１０</td>
                  <td align="center"><input name="fm47" type="checkbox" id="fm47" value="checkbox" $checked47></td>
                  <td align="center"><input name="req47" type="checkbox" id="req47" value="checkbox" $reqchecked47></td>
                   <td align="center">$sort47</td>
                  <td align="center"><input name="text47" type="text" id="text47" value="$text47" size="40">
                    <br>
                    $detail47</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１１</td>
                  <td align="center"><input name="fm48" type="checkbox" id="fm48" value="checkbox" $checked48></td>
                  <td align="center"><input name="req48" type="checkbox" id="req48" value="checkbox" $reqchecked48></td>
                   <td align="center">$sort48</td>
                  <td align="center"><input name="text48" type="text" id="text48" value="$text48" size="40">
                    <br>
                    $detail48</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１２</td>
                  <td align="center"><input name="fm49" type="checkbox" id="fm49" value="checkbox" $checked49></td>
                  <td align="center"><input name="req49" type="checkbox" id="req49" value="checkbox" $reqchecked49></td>
                  <td align="center">$sort49</td>
                  <td align="center"><input name="text49" type="text" id="text49" value="$text49" size="40">
                    <br>
                    $detail49</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１３</td>
                  <td align="center"><input name="fm50" type="checkbox" id="fm50" value="checkbox" $checked50></td>
                  <td align="center"><input name="req50" type="checkbox" id="req50" value="checkbox" $reqchecked50></td>
                   <td align="center">$sort50</td>
                  <td align="center"><input name="text50" type="text" id="text50" value="$text50" size="40">
                    <br>
                    $detail50</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１４</td>
                  <td align="center"><input name="fm51" type="checkbox" id="fm51" value="checkbox" $checked51></td>
                  <td align="center"><input name="req51" type="checkbox" id="req51" value="checkbox" $reqchecked51></td>
                   <td align="center">$sort51</td>
                  <td align="center"><input name="text51" type="text" id="text51" value="$text51" size="40">
                    <br>
                    $detail51</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１５</td>
                  <td align="center"><input name="fm52" type="checkbox" id="fm52" value="checkbox" $checked52></td>
                  <td align="center"><input name="req52" type="checkbox" id="req52" value="checkbox" $reqchecked52></td>
                   <td align="center">$sort52</td>
                  <td align="center"><input name="text52" type="text" id="text52" value="$text52" size="40">
                    <br>
                    $detail52</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１６</td>
                  <td align="center"><input name="fm53" type="checkbox" id="fm53" value="checkbox" $checked53></td>
                  <td align="center"><input name="req53" type="checkbox" id="req53" value="checkbox" $reqchecked53></td>
                   <td align="center">$sort53</td>
                  <td align="center"><input name="text53" type="text" id="text53" value="$text53" size="40">
                    <br>
                    $detail53</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１７</td>
                  <td align="center"><input name="fm54" type="checkbox" id="fm54" value="checkbox" $checked54></td>
                  <td align="center"><input name="req54" type="checkbox" id="req54" value="checkbox" $reqchecked54></td>
                   <td align="center">$sort54</td>
                  <td align="center"><input name="text54" type="text" id="text54" value="$text54" size="40">
                    <br>
                    $detail54</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１８</td>
                  <td align="center"><input name="fm55" type="checkbox" id="fm55" value="checkbox" $checked55></td>
                  <td align="center"><input name="req55" type="checkbox" id="req55" value="checkbox" $reqchecked55></td>
                  <td align="center">$sort55</td>
                  <td align="center"><input name="text55" type="text" id="text55" value="$text55" size="40">
                    <br>
                    $detail55</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目１９</td>
                  <td align="center"><input name="fm56" type="checkbox" id="fm56" value="checkbox" $checked56></td>
                  <td align="center"><input name="req56" type="checkbox" id="req56" value="checkbox" $reqchecked56></td>
                   <td align="center">$sort56</td>
                  <td align="center"><input name="text56" type="text" id="text56" value="$text56" size="40">
                    <br>
                    $detail56</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２０</td>
                  <td align="center"><input name="fm57" type="checkbox" id="fm57" value="checkbox" $checked57></td>
                  <td align="center"><input name="req57" type="checkbox" id="req57" value="checkbox" $reqchecked57></td>
                   <td align="center">$sort57</td>
                  <td align="center"><input name="text57" type="text" id="text57" value="$text57" size="40">
                    <br>
                    $detail57</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２１</td>
                  <td align="center"><input name="fm66" type="checkbox" id="fm66" value="checkbox" $checked66 /></td>
                  <td align="center"><input name="req66" type="checkbox" id="req66" value="checkbox" $reqchecked66 /></td>
                   <td align="center">$sort66</td>
                  <td align="center"><input name="text66" type="text" id="text66" value="$text66" size="40" />
                    <br />
                    $detail66</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２２</td>
                  <td align="center"><input name="fm67" type="checkbox" id="fm67" value="checkbox" $checked67 /></td>
                  <td align="center"><input name="req67" type="checkbox" id="req67" value="checkbox" $reqchecked67 /></td>
                   <td align="center">$sort67</td>
                  <td align="center"><input name="text67" type="text" id="text67" value="$text67" size="40" />
                    <br />
                    $detail67</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２３</td>
                  <td align="center"><input name="fm68" type="checkbox" id="fm68" value="checkbox" $checked68 /></td>
                  <td align="center"><input name="req68" type="checkbox" id="req68" value="checkbox" $reqchecked68 /></td>
                   <td align="center">$sort68</td>
                  <td align="center"><input name="text68" type="text" id="text68" value="$text68" size="40" />
                    <br />
                    $detail68</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２４</td>
                  <td align="center"><input name="fm69" type="checkbox" id="fm69" value="checkbox" $checked69 /></td>
                  <td align="center"><input name="req69" type="checkbox" id="req69" value="checkbox" $reqchecked69 /></td>
                   <td align="center">$sort69</td>
                  <td align="center"><input name="text69" type="text" id="text69" value="$text69" size="40" />
                    <br />
                    $detail69</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２５</td>
                  <td align="center"><input name="fm70" type="checkbox" id="fm70" value="checkbox" $checked70 /></td>
                  <td align="center"><input name="req70" type="checkbox" id="req70" value="checkbox" $reqchecked70 /></td>
                  <td align="center">$sort70</td>
                  <td align="center"><input name="text70" type="text" id="text70" value="$text70" size="40" />
                    <br />
                    $detail70</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２６</td>
                  <td align="center"><input name="fm71" type="checkbox" id="fm71" value="checkbox" $checked71 /></td>
                  <td align="center"><input name="req71" type="checkbox" id="req71" value="checkbox" $reqchecked71 /></td>
                  <td align="center">$sort71</td>
                  <td align="center"><input name="text71" type="text" id="text71" value="$text71" size="40" />
                    <br />
                    $detail71</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２７</td>
                  <td align="center"><input name="fm72" type="checkbox" id="fm72" value="checkbox" $checked72 /></td>
                  <td align="center"><input name="req72" type="checkbox" id="req72" value="checkbox" $reqchecked72 /></td>
                  <td align="center">$sort72</td>
                  <td align="center"><input name="text72" type="text" id="text72" value="$text72" size="40" />
                    <br />
                    $detail72</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２８</td>
                  <td align="center"><input name="fm73" type="checkbox" id="fm73" value="checkbox" $checked73 /></td>
                  <td align="center"><input name="req73" type="checkbox" id="req73" value="checkbox" $reqchecked73 /></td>
                   <td align="center">$sort73</td>
                  <td align="center"><input name="text73" type="text" id="text73" value="$text73" size="40" />
                    <br />
                    $detail73</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目２９</td>
                  <td align="center"><input name="fm74" type="checkbox" id="fm74" value="checkbox" $checked74 /></td>
                  <td align="center"><input name="req74" type="checkbox" id="req74" value="checkbox" $reqchecked74 /></td>
                    <td align="center">$sort74</td>
                  <td align="center"><input name="text74" type="text" id="text74" value="$text74" size="40" />
                    <br />
                    $detail74</td>
                </tr>
                <tr bgcolor="#F4FAFF">
                  <td>フリー項目３０</td>
                  <td align="center"><input name="fm75" type="checkbox" id="fm75" value="checkbox" $checked75 /></td>
                  <td align="center"><input name="req75" type="checkbox" id="req75" value="checkbox" $reqchecked75 /></td>
                   <td align="center">$sort75</td>
                  <td align="center"><input name="text75" type="text" id="text75" value="$text75" size="40" />
                    <br />
                    $detail75</td>
                </tr>
              </table>
              <a href="./$main'indexcgi?md=mf1&id=$id"><font color="#0000FF">&gt;&gt;サンプルHTMLソ\ースを表\示</font></a></td>
          </tr>
          <tr>
            <td><br>
              <font color="#FF0000">
               ●チェックボックスは複数選択が反映されないため、項目１つにつき１フリー項目を割り当ててください。<br>
               ●「表\示順」は指定したものから優先的に表\示されます。特に必要がない場合は、指定する必要はありません。<br>
               ●更新の反映は、「基本」「フリー」項目すべての設定が保存されます。<br>
               ●項目情報を更新した場合、更新内容を「入力確認画面」へ反映するには、カスタマイズ画面で、一度初期化を行う必要があります。
              </font>
            </td>
          </tr>
          <tr>
            <td align="center"><input name="action" type="hidden" id="action" value="form1">
              <input name="md" type="hidden" id="md" value="text">
              <input name="id" type="hidden" id="id" value="$id">
              <input type="submit" name="Submit" value="　更新を反映　">
              <input name="st" type="hidden" id="st" value="0"></td>
          </tr>
        </table>
        <br>
        <table width="100%" border="0">
          <tr>
            <td width="20" valign="top"><a name="1"></a><font color="#FF0000">※1</font></td>
            <td>「姓」「名」項目をご利用の場合、データ管理上この項目データには「姓」「名」の入力データが自動的に登録されますが、システム利用上問題はございません。</td>
          </tr>
          <tr>
            <td width="20" valign="top"><a name="2"></a><font color="#FF0000">※2</font></td>
            <td>「姓フリガナ」「名フリガナ」項目をご利用の場合、データ管理上この項目データには「姓」「名」の入力データが自動的に登録されますが、システム利用上問題はございません。</td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
<script type="text/javascript">
<!--
var batb;
var ftb;
function elm(){
	if ( document.getElementById ){
		batb = document.getElementById ( "btb" );
		ftb = document.getElementById ( "ftb" );
	}else{
		batb = document.all ["btb"];
		ftb = document.all ["ftb"];
	}
	hid();
}
function hid(){
	var t = document.form1.st.value;
	batb.style.display = "none";
	ftb.style.display = "none";
	if(  t == 0  )
		batb.style.display = "";
	if(  t == 1  )
		ftb.style.display = "";
	
}
function setSt(st){
	document.form1.st.value = st;
	hid();
}
window.onload = elm;
// -->
</script>
END
	return $main_form;
}

sub form_detail
{
	my $error = shift;
	my $id    = $main'param{'id'} - 0;
	my $fn    = $main'param{'fn'} - 0;
	
	my %detail = &_get_detail( $id, $fn );
	# inputタイプ
	my @data = split( /\t/, $detail{$fn} );
	my $check_text     = ($data[2] eq 'text' || $data[2] eq '')? ' checked': '';
	my $check_textarea = ($data[2] eq 'textarea')? ' checked': '';
	my $check_select   = ($data[2] eq 'select')? ' checked': '';
	my $check_checkbox = ($data[2] eq 'checkbox')? ' checked': '';
	my $check_radio    = ($data[2] eq 'radio')? ' checked': '';
	
	my $input_text     = &_text( 'text' );
	my $input_textarea = &_textarea( 'textarea' );
	my $input_select   = &_select( 'select', $data[3] );
	my $input_checkbox = &_checkbox( 'checkbox', $data[4] );
	my $input_radio    = &_radio( 'radio', $data[5] );
	if( $input_select eq '' ){
		$input_select = qq|<font color="#555555">要素が登録されていません</font>|;
	}
	if( $input_checkbox eq '' ){
		$input_checkbox = qq|<font color="#555555">要素が登録されていません</font>|;
	}
	if( $input_radio eq '' ){
		$input_radio = qq|<font color="#555555">要素が登録されていません</font>|;
	}
	
	# フリー項目用span id
	$fname = 'free'. $fn;
	
	# エラー表示
	if( $error ne '' ){
		$error = qq|<br><font color="#FF0000">$error</font><br>　 |;
	}
	
	print <<"END";
Content-type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis" />
<title>登録フォーム生成</title>
<link href="$main'image_dir\style.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form id="form1" name="form1" method="post" action="$main'indexcgi">
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td><br />
      □ 登録フォーム生成＞　フリー項目 $fn<br /> </td>
    </tr>
    <tr>
      <td align="center">$error</td>
    </tr>
    <tr>
      <td><table width="500" border="1" cellspacing="0" cellpadding="3">
          <tr>
            <td width="30" align="center" bgcolor="#EFEFEF">選択</td>
            <td align="center" bgcolor="#EFEFEF">確認</td>
            <td width="60" align="center" bgcolor="#EFEFEF">要素設定</td>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF"><input name="type" type="radio" value="text"$check_text /></td>
            <td bgcolor="#FFFFFF"><font color="#666666">[テキストフォーム]</font><br />
              <br />
            $input_text &nbsp;</td>
            <td align="center" bgcolor="#FFFFFF">---</td>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF"><input name="type" type="radio" value="textarea"$check_textarea /></td>
            <td bgcolor="#FFFFFF"><font color="#666666">[テキストエリア]</font><br />
              <br />$input_textarea &nbsp;</td>
            <td align="center" bgcolor="#FFFFFF">---</td>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF"><input name="type" type="radio" value="select"$check_select /></td>
            <td bgcolor="#FFFFFF"><font color="#666666">[セレクトフォーム]</font><br />
              <br />$input_select &nbsp;</td>
            <td align="center" bgcolor="#FFFFFF"><a href="$main'index?md=fdetail&id=$id&fn=$fn&act=fs"><font color="#0000FF">編集する</font></a></td>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF"><input name="type" type="radio" value="checkbox"$check_checkbox /></td>
            <td bgcolor="#FFFFFF"><font color="#666666">[チェックボックス]</font><br />
              <br />$input_checkbox &nbsp;</td>
            <td align="center" bgcolor="#FFFFFF"><a href="$main'index?md=fdetail&id=$id&fn=$fn&act=fc"><font color="#0000FF">編集する</font></a></td>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF"><input name="type" type="radio" value="radio"$check_radio /></td>
            <td bgcolor="#FFFFFF"><font color="#666666">[ラジオボタン]</font><br />
              <br />$input_radio &nbsp;</td>
            <td align="center" bgcolor="#FFFFFF"><a href="$main'index?md=fdetail&id=$id&fn=$fn&act=fr"><font color="#0000FF">編集する</font></a></td>
          </tr>
        </table></td>
    </tr>
    <tr>
      <td align="center"><br />
        <input type="submit" value="　　更新を反映する　　" onclick="setFm(this.form);">
	  <input type="button" value="　　閉じる　　" onClick="window.close();">
	  <input name="md" type="hidden" id="md" value="fdetail" />
	  <input name="id" type="hidden" id="id" value="$id" />
	  <input name="fn" type="hidden" id="fn" value="$fn" />
	  <input name="act" type="hidden" id="act" value="set_type" /></td>
    </tr>
    <tr>
      <td><table width="500" border="0" cellspacing="0" cellpadding="10">
        <tr>
          <td>利用するフォームタイプを選択後、「更新を反映する」で決定してください。</td>
        </tr>
      </table></td>
    </tr>
  </table>
</form>
<script type="text/javascript">
<!--
var ftext = new Array();
ftext[0] = 'テキストフォーム';
ftext[1] = 'テキストエリア';
ftext[2] = 'セレクトメニュー';
ftext[3] = 'チェックボックス';
ftext[4] = 'ラジオボタン';

//var iTT = window.opener.document.all.$fname.innerText;alert(iTT);
function setFm(form){
	//alert(form);
	var str = ftext[0];
	for(i = 0; i < form.type.length; i++) //全てのラジオボタンをスキャン
		if(form.type[i].checked) {        //チェックされていたら
			str = ftext[i];
			break;
		}
	
	//alert(window.opener.document.all.$fname.textContent);
	window.opener.document.all.$fname.textContent = str;
	window.opener.document.all.$fname.innerText = str;
}
// -->
</script>
</body>
</html>
END
	exit;
}

sub form_detail_prop
{
	my $type = shift;
	my $id = $main'param{'id'} - 0;
	my $fn = $main'param{'fn'} - 0;
	
	my %detail= &_get_detail( $id, $fn );
	my @data = split( /\t/, $detail{$fn} );
	my $input_data;
	$input_data = $data[3] if( $type eq 'select' );
	$input_data = $data[4] if( $type eq 'checkbox' );
	$input_data = $data[5] if( $type eq 'radio' );
	
	my @prop    = split(/<>/, $input_data);
	my $propdata;
	my $addform;
	# チェックボックスは例外
	if( $type ne 'checkbox' ){
		my $n = 0;
		foreach( @prop ){
			$n++;
			$propdata .= qq|<input type="text" name="item-$n" size="50" value="$_"><br>|;
		}
		if( $n > 0 ){
			$propdata .= qq|<font color="#FF0000">※データを空白にすることで削除することができます。</font>|;
		}else{
			$propdata  = qq|<br><font color="#555555">要素は登録されていません。<br>追加用よりデータを登録してください。</font><br>　|;
		}
		
		$addform = <<"END";
          <tr>
            <td align="center" bgcolor="#EFEFEF">要素追加用</td>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF"><input name="add" type="text" id="add" size="50" /></td>
          </tr>
END
	}else{
		$propdata = qq|<input type="text" name="item-1" size="50" value="$prop[0]">|;
	}
	
	# フォームタイプ名
	my $fname;
	$fname = 'セレクトメニュー' if( $type eq 'select' );
	$fname = 'チェックボックス' if( $type eq 'checkbox' );
	$fname = 'ラジオボタン' if( $type eq 'radio' );
	
	print <<"END";
Content-type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis" />
<title>登録フォーム生成</title>
<link href="$main'image_dir\style.css" rel="stylesheet" type="text/css" />
</head>
<body>
<form id="form1" name="form1" method="post" action="">
  <table width="400" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td><br />
      □登録フォーム生成＞　フリー項目 $fn＞　 $fname<br />
       　 
      </td>
    </tr>
    <tr>
      <td><table width="400" border="1" cellspacing="0" cellpadding="3">
          <tr>
            <td align="center" bgcolor="#EFEFEF">要素データ</td>
          </tr>
          <tr>
            <td align="center" bgcolor="#FFFFFF">$propdata &nbsp;</td>
          </tr>
$addform
          <tr>
            <td align="center" bgcolor="#FFFFFF"><input type="submit" name="Submit" value="更新を反映" />
            <input name="md" type="hidden" id="md" value="fdetail" />
            <input name="id" type="hidden" id="id" value="$id" />
            <input name="fn" type="hidden" id="fn" value="$fn" />
            <input name="type" type="hidden" id="type" value="$type" />
            <input name="act" type="hidden" id="act" value="set_prop" /></td>
          </tr>
          
        </table></td>
    </tr>
    <tr>
      <td align="center"><br />
        <br />
        <input name="submit" type="button" value="フォームタイプ選択画面へ戻る" onClick="location.href('$main'index?md=fdetail&act=wd&id=$id&fn=$fn');" />
        <input name="button" type="button" onclick="window.close();" value="　　閉じる　　" /></td>
    </tr>
  </table>
</form>
</body>
</html>
END
	exit;
}

sub makeform
{
	my( $name, $detail, $mobile ) = @_;
	my @detail = split(/\t/,$detail);
	my $type = $detail[2];
	my $size = ( $mobile )? 14: 25;
	my $input;
	if( $type eq '' || $type eq 'text' ){
		$input = &_text( $name, $size );
	}elsif( $type eq 'textarea' ){
		$input = &_textarea( $name, $size );
	}elsif( $type eq 'select' ){
		$input = &_select( $name, $detail[3], $size );
	}elsif( $type eq 'checkbox' ){
		$input = &_checkbox( $name, $detail[4] );
	}elsif( $type eq 'radio' ){
		$input = &_radio( $name, $detail[5] );
	}
	return $input;
}

sub _text
{
	my( $name, $size ) = @_;
	$size = 25 unless( $size > 0 );
	return qq|<input type="text" name="$name" size="$size">|;
}

sub _textarea
{
	my( $name, $width, $height ) = @_;
	$width  = 20 unless( $width > 0 );
	$height = 3  unless( $height > 0 );
	return qq|<textarea name="$name" cols="$width" rows="$height"></textarea>|;
}

sub _select
{
	my( $name, $value, $mobile ) = @_;
	my @value = split( /<>/, $value );
	return unless( @value );
	my $input = qq|<select name="$name">|;
	foreach( @value ){
		my $option .= qq|<option value="$_">$_</option>\n|;
		my $option_m .= qq|<option value="$_">$_\n|;
		$input .= ( $mobile )? $option_m: $option;
	}
	$input .= qq|</select>|;
	return $input;
}

sub _checkbox
{
	my( $name, $value ) = @_;
	return if( $value eq '' );
	return qq|<input type="checkbox" name="$name" value="$value">$value\n|;
}

sub _radio
{
	my( $name, $value ) = @_;
	my @value = split( /<>/, $value );
	return unless( @value );
	my $input;
	my @prop;
	foreach( @value ){
		push @prop, qq|<input type="radio" name="$name" value="$_">$_|;
	}
	return join("<br>\n", @prop);
}

sub set_type
{
	&set( 'type' );
	&form_detail();
	exit;
}

sub set_prop
{
	&set();
	my $type = $main'param{'type'};
	&form_detail_prop( $type );
	exit;
}

sub set
{
	my $action = shift;
	my $id     = $main'param{'id'} - 0;
	my $fn     = $main'param{'fn'} - 0;
	my $type   = $main'param{'type'};
	
	# フォーム要素を取得
	my %items;
	foreach( keys %main'param ){
		if( /^item-(\d+)$/ ){
			$items{$1} = &main'deltag($main'param{"item-$1"}) if($main'param{"item-$1"} ne '');
		}
	}
	my @_data;
	foreach( sort{ $a <=> $b } keys %items ){
		push @_data, $items{$_};
	}
	my $_new = &main'deltag($main'param{'add'});
	push @_data, $_new if( $_new ne '' );
	my $itemdata = join("<>", @_data);
	
	# 更新対象を取得
	#[3]・・セレクト
	#[4]・・チェックボックス
	#[5]・・ラジオボタン
	my $reindex;
	$reindex = 3 if( $type eq 'select' );
	$reindex = 4 if( $type eq 'checkbox' );
	$reindex = 5 if( $type eq 'radio' );
	
	# ダミーファイルを生成
	my $tmpfile = $Dir . 'MK-' . time . $$ . '.cgi';
	unless( open(TMP, ">$tmpfile") ){
		&main'error('システムエラー', "ダミーファイルが作成できません。$Dir のパーミッションをご確認ください。");
	}
	# ログデータを読み込み
	unless( open(LOG, $logfile) ){
		unlink $tmpfile;
		&main'error('システムエラー', "$logfileが開けません。パーミッションをご確認ください。");
	}
	my $flag = 0; # 保存済みチェック
	while(<LOG>){
		chomp;
		my @data = split(/\t/);
		if( $action eq 'delete' ){
			$flag = 1;
			if( $id eq $data[0] ){
				next;
			}
			goto INSERT;
		}
		goto INSERT if( $id ne $data[0] || $fn ne $data[1] );
		$flag = 1;
		if( $action eq 'type' ){
			$data[2] = $type;
			if( $data[$reindex] eq '' ){
				close(TMP);
				unlink $tmpfile;
				&form_detail( 'エラー: 選択したフォームタイプは要素が登録されていません。' );
				exit;
			}
			goto INSERT;
		}
		$data[$reindex] = $itemdata if( $reindex > 2 );
		# 書き込み
		INSERT:
		my $line = join("\t", @data);
		print TMP "$line\n";
	}
	if( !$flag ){
		# フォームタイプ選択の場合
		if( $action eq 'type' && $reindex > 2 ){
			close(TMP);
			unlink $tmpfile;
			&form_detail( 'エラー: 選択したフォームタイプは要素が登録されていません。' );
			exit;
		}
		my @_data;
		$_data[0]        = $id;
		$_data[1]        = $fn;
		$_data[2]        = $type if( $action eq 'type' );
		$_data[$reindex] = $itemdata if( $reindex > 2 );
		my $line = join("\t", @_data);
		print TMP "$line\n";
	}
	close(TMP);
	close(LOG);
	rename $tmpfile, $logfile;
}

sub _get_detail
{
	my( $id, $fn ) = @_;
	my %hash;
	unless( open(LOG, $logfile) ){
		&main'error('システムエラー', "$logfile が開けません。<br>$Dir のパーミッションをご確認ください。");
	}
	while(<LOG>){
		chomp;
		my @data = split(/\t/);
		if( $id eq $data[0] ){
			next if( $fn ne '' && $fn ne $data[1] );
			$hash{$data[1]} = $_;
		}
	}
	close(LOG);
	return %hash;
}
sub _get_detail_list
{
	my( $id, $all ) = @_;
	my %hash;
	unless( open(LOG, $logfile) ){
		&main'error('システムエラー', "$logfile が開けません。<br>$Dir のパーミッションをご確認ください。");
	}
	while(<LOG>){
		chomp;
		my @data = split(/\t/);
		if( $id eq $data[0] ){
			if( $all ){
				my @select = split(/<>/,$data[3]);
				my @checkbox = split(/<>/,$data[4]);
				my @radio = split(/<>/,$data[5]);
				$hash{$data[1]} = [$data[2],[@select],[@checkbox],[@radio]];
			}else{
				$hash{$data[1]} = $data[2];
			}
		}
	}
	close(LOG);
	return %hash;
}

sub _getSort
{
	my( $name, $n ) = @_;
	my $select .= qq|<select name="sort$name">\n|;
	$select .= qq|<option value="">--</option>\n|;
	foreach( 1 .. 48 ){
		my $selected = ' selected="selected"' if( $_ == $n );
		$select .= qq|<option value="$_"$selected>$_</option>\n|;
	}
	$select .= qq|</select>\n|;
	return $select;
}

sub _getDesignTemplate
{
	my $config = $main'myroot . $main'template. $main'DesignTemplate;
	
	open( CONFIG, "<$config" );
	my @array;
	while (my $line = <CONFIG>) {
		$line .= <CONFIG> while ($line =~ tr/"// % 2 and !eof(CONFIG));
		
		$line =~ s/(?:\x0D\x0A|[\x0D\x0A])?$/,/;
		@values = map {/^"(.*)"$/s ? scalar($_ = $1, s/""/"/g, $_) : $_}
                ($line =~ /("[^"]*(?:""[^"]*)*"|[^,]*),/g);
		
		push @array, [@values];
	}
	return [@array];

}

sub _analyTemplate
{
	my( $design, $mobile ) = @_;
	
	my $dir = $main'myroot . $main'template;
	my $fullpath = $dir . $main'FormTemplate;
	my $array = &_getDesignTemplate();
	foreach( @$array ){
		$fullpath = $dir . $_->[1] if( $_->[1] eq $design );
	}
	
	# 携帯用
	$fullpath = $dir . $design if( $mobile );
	
	open( FILE, "<$fullpath" );
	
	my $base;
	my $line;
	while(<FILE>){
		if( /(.*)<%__START-FORM-LINE__%>(.*)/i ){
			$base .= $1;
			my $prop = $2;
			my $exchang = qq|<%__ROW-exchang__%>\n|;
			my $after = $3;
			$base .= $exchang;
			while( <FILE> ){
				# 検出行の残りを対象に加える
				if( $after ne '' ){
					$_ = $after. $_;
					$after = '';
				}
				if( /(.*)<%__END-FORM-LINE__%>(.*)/i ){
					$line .= $1;
					$base .= $2;
					last;
				}else{
					$line .= $_;
				}
			}
		}else{
			$base .= $_;
		}
	}
	close(FILE);
	return $base, $line;
}

sub include
{
	local $_ = shift;
	my $hash = shift;
	while( ( $parameter ) = ( /<%([^<>\%]+)%>/oi ) ) {
		s//$hash->{$parameter}/;
	}
	return $_;
}

1;
