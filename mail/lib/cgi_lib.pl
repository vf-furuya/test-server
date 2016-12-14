#---------------------------------------
# 楽メールpro
#
# 共通関数群 cgi_lib.pl
# v 2.1.4
#---------------------------------------
# 入力パラメータの解析
sub get_param{
    local($alldata) = @_;
    local($data, $key, $val);
    foreach $data (split(/&/, $alldata)){
        ($key, $val) = split(/=/, $data);
        $val =~ tr/+/ /;
        $val =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack('C',hex($1))/eg;
        $val =~ s/\t//g;
        &jcode'convert(*val, 'sjis');
        $param{$key} = $val;
	}
}

# マルチフォームからのパラメータの取得
sub get_multipart_params{
    my($delim,$id,$value,$filename,$mimetype,$size);binmode STDIN;
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

# ファイルのアップロード
sub the_filedata{
    my( $id )=@_;
    $oname=$paramfile{$id};
    $oname=~ s/\xC3\xDE\xBD\xB8\xC4\xAF\xCC\xDF/デスクトップ/g;
    
    $oname=~ s/\t//g;
    &jcode'convert(*oname,'sjis');
    
    if($paramtype{$id} eq 'big'){
        return "big";
    }
    if($param{$id} =~ /^\s*$/){
        return '';
    }
    %exts=(
        "image/gif",         "gif",
        "image/jpeg",        "jpg",
        "image/x-xbitmap",   "xbm",
        "audio/midi",        "mid",
    );
    $oname =~ /([^\/\\]*)\.([^.\/\\]*)$/;
    
    my $file=$1;
    $ext=$2 || $exts{$paramtype{$id}} || 'txt';
    $file =~ s/([^-.\w])/unpack('H2',$1)/ge;
    $ext=~ s/([^-\w])/unpack('H2',$1)/ge;
    $ext=~ tr/A-Z/a-z/;
    
	$file = $file . '.'.  $ext;
    return $file;
}

# 前後のスペースを削除する
sub delspace{
    local($_) = @_;
    s/^\s+//;
    s/\s+$//;
    return $_;
}

# 入力されたテキストを正規化
sub the_text{
    local($_) = @_;
    s/\r?\n/\r/g;
    # s/^\r+//;
    # s/\r+$//;
    s/\r/<br>/g;
    s/<([^<]*)>/&qcheck($1)/ge;
    return $_;
}

sub qcheck{
    local($_) = @_;
    if (tr/"/"/ % 2){
        s/\s*$/"/;
    }
    return "<$_>";
}

# HTMLタグとダブルクォートを無効にする
sub deltag{
    local($_) = @_;
    s/&/&amp;/g;
    s/"/&quot;/g;
    s/</&lt;/g;
    s/>/&gt;/g;
    return $_;
}

# HTMLタグとダブルクォートを有効する
sub _deltag{
    local($_) = @_;
    s/&amp;/&/g;
    s/&quot;/"/g;
    s/&lt;/</g;
    s/&gt;/>/g;
    return $_;
}
# 表示用の日時データを作成
sub make_date{
    local($t) = @_;
    local($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($t+(60*60*9));
    local(@wdays) = ('日', '月' ,'火' ,'水' ,'木' ,'金', '土');
    return sprintf ("%04d年%02d月%02d日(%s) %02d時%02d分", $year+1900, $mon+1, $day, $wdays[$wday], $hour, $min);
}
sub make_date2{
    local($t) = @_;
    my($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($t+(60*60*9));
    return sprintf ("%04d/%02d/%02d %02d:%02d", $year+1900, $mon+1, $day, $hour, $min);
}
sub make_date3{
    local($t) = @_;
    my($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($t+(60*60*9));
    return sprintf ("%04d/%02d/%02d", $year+1900, $mon+1, $day);
}
sub make_datecode{
    local($t) = @_;
    my($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($t+(60*60*9));
    return sprintf ("%04d%02d%02d", $year+1900, $mon+1, $day);
}

sub chk_email
{
	my( $mail ) = @_;
	if ($mail !~ /^[0-9a-zA-Z\-\_\.\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\|\}\~]+\@[0-9a-zA-Z\-\_\.]+$/ ) {
		return 1;
	}
	return 0;
}

# 名前とURLからリンクを作成
sub make_link{
    my($name, $addr) = @_;
    $name = &deltag($name);
    $addr = &deltag($addr);
    if ($addr eq ''){
        return $name;
    }
    else{
        unless ($addr =~ /^http:|^mailto:/){
            $addr = "mailto:$addr";
        }
        return qq|<a href="$addr">$name</a>|;
    }
}

# 表示用の本文データを作成
sub make_text{
    local($_) = @_;
    $_ = &deltag($_);
    s/&lt;br\s*&gt;/<br>/gi;
    return $_;
}

# エラー出力
sub error {
	($error,$mes) = @_;
    print "Content-type: text/html", "\n\n";
    print <<"END";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<title>- $title -</title>
<link href="style.css" rel="stylesheet" type="text/css">
<script type="text/javascript"><!--
--></script>
</head>
<body>
<center>
<table width="500" border="0" cellpadding="0" cellspacing="10">
<tr>
<td>
  <table width="500" border="1" cellspacing="5" bordercolor="#8AE5C7">
    <tr> 
      <td>
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr> 
            <td colspan="3" bgcolor="#ABDCE5"> 
              <table width="100%" border="0" cellspacing="5" cellpadding="5">
                <tr> 
                  <td><font color="#000000" size="+1"><strong>$error</strong></font></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3" bgcolor="#FFFFFF">
              <table width="100%" border="0" cellspacing="0" cellpadding="10">
                <tr> 
                  <td><font color="#666666" size="-1">
                    $mes
                    <br><br>ブラウザの「戻る」ボタンまたは 
                    <a href="#" onClick="history.back();"><font color="#0000FF"><strong>ここ</strong></font></a> をクリックしてください</td>
                </tr>
              </table></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</td>
</tr>
</table>
</center>
</body>
</html>
END
	exit;

}

# ユーザー定義関数

# METHODの判定
sub method_ck{

	my($all);
	unless($ENV{'REQUEST_METHOD'} eq 'POST'){
		$all= $ENV{'QUERY_STRING'};
		&get_param($all);
	}else{
		if ( $ENV{'CONTENT_TYPE'} =~ m|multipart/form-data; boundary=([^\r\n]*)$|io ){
			&get_multipart_params();
		}else{
			read(STDIN, $all, $ENV{'CONTENT_LENGTH'});
			&get_param($all);
		}
	}
	$mode= &delspace($param{'md'});
}

# HTMLヘッダーの出力
sub html_header{
	my($header);
	$header .= "Cache-Control: no-cache\n";
	$header .= "Content-type: text/html\n\n";
	$header .= "<html lang=\"ja\"><head>\n";
	$header .= "<meta HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">\n";
	$header .= "<meta HTTP-EQUIV='Content-type' CONTENT='text/html; charset=shift_jis'>\n";
	$header .= "<meta content=\"MSHTML 6.00.2713.1100\" name=GENERATOR>\n";
	$header .= "<title>$title</title>\n";
	$header .= "<script type=\"text/javascript\" src=\"$js\"></script>\n";
	$header .= "<link rel='stylesheet' href='$image_dir$css' type='text/css'>", "\n";
	$header .= "</HEAD>\n";
	return $header;
}
sub the_url{
	my($url) = @_;
	$url = &delspace($url);
	$url = '' if ($url eq 'http://');
	return $url;
}

sub get_host{
	$host = $ENV{'REMOTE_HOST'} || $ENV{'REMOTE_ADDR'};
	foreach $e ('HTTP_VIA', 'HTTP_FORWARDED', 'HTTP_FROM', 'HTTP_X_FORWARDED_FOR'){
		$host .= " / $e=$ENV{$e}" if (defined $ENV{$e});
	}
	return $host;
}

# クッキー関連のサブルーチン
sub get_cookie{
    foreach (split (/; /, $ENV{'HTTP_COOKIE'})){
        ($key, $val) = split (/=/);
        $all_cookies{$key} = $val;
    }
    foreach (split (/&/, $all_cookies{$cookie_id})){
        ($key, $val) =  split(/:/);
        $cookie{&unescape($key)} = &unescape($val);
    }
}
sub set_cookie{
    if (time > $cookie{'refresh'} + 2592000){
        $cookie{'refresh'} = time;
    }
    @pairs = ();
    foreach (sort keys %cookie){
        push(@paris, &escape($_).":".&escape($cookie{$_}));
    }
    $new_cookie = join ('&', @paris);
    $date = &gmt_date(time + $hold_days * 86400);
    if ($new_cookie ne $all_cookies{$cookie_id}){
        print "Set-Cookie: $cookie_id=$new_cookie; expires=$date\n";
    }
}
sub del_cookie {
    if ($all_cookies{'$cookie_id'} ne ''){
        print "Set-Cookie: $cookie_id=\n";
    }
}
sub escape{
    local($_) = @_;
    s/([&:;=%\x00-\x21])/sprintf("%%%02x",unpack('C',$1))/ge;
    return $_;
}
sub unescape{
    local($_) = @_;
    s/%([a-fA-F0-9]{a-fA-F0-9])/pack('C',hex($1))/ge;
    return $_;
}
sub gmt_date{
    my($t) = @_;
    ($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($t);
    return sprintf ("%s, %02d %s %04d %02d:%02d:%02d GMT",
    (Sun, Mon, Tue, Wed, Thr, Fri, Sat)[$wday], $day,
    (Jan, Fed, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)[$mon],
    $year + 1900, $hour, $min, $sec);
}

# ファイルロック
sub lock {
	my $lockpath = "$myroot$lockdir" . $lockfile;
	my $lockfull = $lockpath . $$ . '.' . time;
	my $count;
	while(1){
		if ( rename ( $lockpath, $lockfull ) ) {
			return $lockfull;
		}else{
		    if ( &re_lock( "$myroot$lockdir", $lockfull ) ) {
				return $lockfull;
			}
		}
		sleep(1);
		$count++;
		if( $count > 10 ){
			my $errorMessage = 'ファイルロックエラー<br>';
			$errorMessage .= "アクセスできません。<br>しばらく時間を置いて再度アクセスしてください。";
			&error("$errorMessage");
			exit;
		}
	}
}
# ロックファイルのファイル名が変更されたままだったら
# 60秒以上の場合、ファイル名を変更する
sub re_lock{
	my ( $lockdir, $lockfull ) = @_;
	my $flag = 0;
	unless( opendir (LOCKDIR,"$lockdir") ) {
	    &error("ロック用ディレクトリ $lockdir が開けません");
	}
	@lockfiles = readdir 'LOCKDIR';
	close(LOCKDIR);
	foreach (@lockfiles){
		
		if(/^$lockfile(\d+)\.(\d+)$/){
		    if(time-$2 >= 60){
				$re_name = rename( "$lockdir$_", "$lockfull" );
				return $re_name;
			}
			$flag = 1;
		}
	}
	if ( !$flag ){
		# パーミッションのエラーを確認
		unless( -w $lockdir || -x $lockdir ){
			&error("ロック用ディレクトリのパーミッションに誤りがあります。<br> $lockdir を[707]に変更してください。");
		}
		unless( -e "$lockdir$lockfile" ){
			open( LOCK, ">$lockdir$lockfile" );
			chmod 0606, "$lockdir$lockfile";
			close(LOCK);
		}
	}
}
# ロックファイルのファイル名を初期名に戻す(ロックの解除)
sub rename_unlock{
	my ( $lockfull ) = @_;
	my $lockpath = "$myroot$lockdir" . $lockfile;
	if ( rename( "$lockfull", $lockpath ) ) {
		return 1;
	} else {
		return 0;
	}
}

# -----------------------------------------------------------------------
# メール送信関連
# -----------------------------------------------------------------------

#--------------------------------#
# 本文の連想配列を作成           #
#--------------------------------#
sub get_body {
	my $file = shift;
	my %hash;
	unless ( open(FILE, $file) ) {
		push @errors, '本文データが取得できません';
	}
	while( <FILE> ) {
		chomp;
		my ( $id, $subject, $header, $cancel, $body, $footer, $ctype, $filename ) = split(/\t/);
		$ctype -= 0;
		$body =~ s/<br>/\n/gi;
		$hash{$id} = {
			'subject' => $subject,
			'header'  => $header,
			'cancel'  => $cancel,
			'body'    => $body,
			'footer'  => $footer,
			'ctype'   => $ctype,
			'filename'=> $filename,
		};
	}
	close(FILE);
	return \%hash;
}

#--------------------------------#
# 送信用の本文を作成             #
#--------------------------------#
sub make_send_body {
	
	my ( $n, $rh_body, $header, $cancel, $footer, $flag ) = @_;
	# 登録者情報を挿入
	my $message;
	
	if( &chk_ctype($rh_body->{$n}->{'ctype'}) ){
		
		$CONTENT_TYPE = 'text/html';
		my $htmlpath = "$myroot$data_dir$queue_dir" . $rh_body->{$n}->{'filename'};
		
		unless( open( HTML, $htmlpath ) ){
			if( $flag ){
				&make_plan_page( 'plan', '', 'エラー<br>該当するHTMLファイルがありません。');
        		exit;
			}
		}
		while( my $line = <HTML> ){
			$message .= $line;
		}
		close(HTML);
		
	}else{
		$CONTENT_TYPE = '';
		$message = "$header\n" if ( $rh_body->{$n}->{'header'} );
		$message .= "$rh_body->{$n}->{'body'}\n";
		$message .= "$cancel\n" if ( $rh_body->{$n}->{'cancel'} );
		$message .= $footer if ( $rh_body->{$n}->{'footer'} );
	}
	
	# デフォルト設定
	if( $rh_body->{$n}->{'subject'} eq '' ){
		my $def;
		if( $n eq '0' ){
			$def = '登録時';
		}elsif( $n eq 'r' ){
			$def = '変更時';
		}elsif( $n eq 'c' ){
			$def = '解除時';
		}elsif( $n =~ /^\d+$/ ){
			my $number = $n + 1;
			$def = '第' . $number . '回配信';
		}elsif( $n =~ /^d(\d\d)(\d\d)$/ ){
			$def = '日付指定' . $1 . '/' . $2 . '配信';
		}
		$def .= '(題名が未設定です)';
		$rh_body->{$n}->{'subject'} = $def;
	}
	if( $message =~ /^\s*$/ ){
		my $def;
		if( $n eq '0' ){
			$def = '登録時';
		}elsif( $n eq 'r' ){
			$def = '変更時';
		}elsif( $n eq 'c' ){
			$def = '解除時';
		}elsif( $n =~ /^\d+$/ ){
			my $number = $n + 1;
			$def = '第' . $number . '回配信';
		}elsif( $n =~ /^d(\d\d)(\d\d)$/ ){
			$def = '日付指定' . $1 . '/' . $2 . '配信';
		}
		$def .= '(本文が未設定です)';
		$message = $def;
	}
	
    return $rh_body->{$n}->{'subject'}, $message;
}

#--------------------------------#
# 登録情報を本文に挿入           #
#--------------------------------#
sub include {
	my $rl_csv = shift;
	local $str = shift;
	my $jis    = shift;
	my $preview = shift;
	my $_str;
	my $id = $param{'id'} - 0;
	local @csv = @$rl_csv;
	
	if( !$preview ){
		$csv[0] = sprintf( "%05d", $csv[0] ); # IDの正規化
		#my @senddata = splice( @csv, 19, 3 );
		my $now = time;
		my($reg_sec, $reg_min, $reg_hour, $reg_day, $reg_mon, $reg_year, $reg_wday) = gmtime($csv[19]+(60*60*9));
		my($n_sec, $n_min, $n_hour, $n_day, $n_mon, $n_year, $n_wday)               = gmtime($now+(60*60*9));
		$reg_year += 1900;
		$reg_mon  += 1;
		$n_year += 1900;
		$n_mon  += 1;
		$csv[51] = $reg_year;
		$csv[52] = $reg_mon;
		$csv[53] = $reg_day;
		$csv[54] = $n_year;
		$csv[55] = $n_mon;
		$csv[56] = $n_day;
		$csv[57] = qq|$applycgi\?id=$id&md=cancel&userid=$csv[0]&mail=$csv[5]|;
	}
	
	my %hash = (
		id => 0,
		co => 1,
		_co => 2,
		name => 3,
		_name => 4,
		mail => 5,
		tel => 6,
		fax => 7,
		url => 8,
		code => 9,
		address => 10,
		address1 => 11,
		address2 => 12,
		address3 => 13,
		free1 => 14,
		free2 => 15,
		free3 => 16,
		free4 => 17,
		free5 => 18,
		free6 => 22,
		free7 => 23,
		free8 => 24,
		free9 => 25,
		free10 => 26,
		free11 => 27,
		free12 => 28,
		free13 => 29,
		free14 => 30,
		free15 => 31,
		free16 => 32,
		free17 => 33,
		free18 => 34,
		free19 => 35,
		free20 => 36,
		sei => 37,
		_sei => 38,
		mei => 39,
		_mei => 40,
		free21 => 41,
		free22 => 42,
		free23 => 43,
		free24 => 44,
		free25 => 45,
		free26 => 46,
		free27 => 47,
		free28 => 48,
		free29 => 49,
		free30 => 50,
		ryear  => 51,
		rmon   => 52,
		rday   => 53,
		year   => 54,
		mon    => 55,
		day    => 56,
		cancel => 57,
	);
	my $line = 0;
	foreach( split( /\n/, $str ) ){
		
		if( /<%([^<>\%]+)%>/oi ){
			local $_line = $_;
			
			# SJISに統一する
			if( $jis > 0 ){
				&jcode'jis2sjis( \$_line, 'z' );
				$_ = $_line;
			}
			while( ( $parameter ) = ( /<%([^<>\%]+)%>/oi ) ) {
				$csv[$hash{$parameter}] = '' if( $hash{$parameter} eq '' );
				$after = &convbodyLF( $csv[$hash{$parameter}] );
				s//$after/;
			}
			if( $jis > 0 ){
				local $newline = $_;
				&jcode'sjis2jis( \$newline, 'z' );
				$_ = $newline;
			}
		}
		$_str .= "\n" if( $line );
		$_str .= "$_";
		$line++;
	}
	return $_str;
}

sub convbodyLF
{
	local($_) = @_;
	if( $CONTENT_TYPE eq 'text/html' ){
		s/\r?\n/\r/g;
		s/\r/<br>/g;
	}else{
    	s/<br>/\n/gi;
		$_ = &_deltag( $_ );
	}
	return $_;
}

sub reInclude
{
	local $_ = shift;
	while( ( $parameter ) = ( /&lt;%([^<>\%]+)%&gt;/oi ) ) {
		$after = '<%'.$parameter.'%>';
		s//$after/;
	}
	return $_;
}

#-------------------------#
# 送信                    #
#-------------------------#
sub send {
	local ( $from, $name, $to, $subject, $message, $admin, $ra_conf ) = @_;
	require $mime;
	
	my $type = ( $CONTENT_TYPE eq '' )? 'text/plain': $CONTENT_TYPE;
	# ------------------   メッセージフォーマット   ---------------
	my $return  = $from;
	if( $ra_conf->{'flag'} ){
		$from = $ra_conf->{'addr'};
	}
	
	$from       = qq| <$from>|;
	if( $name ne '' ){
		$name =~ s/&lt;/</gi;
		$name =~ s/&gt;/>/gi;
		$name =~ s/&quot;/"/gi;
		$name = &mail64encode( $name );
	}
	$subject = &mail64encode($subject);
	&jcode'convert(*message,'jis');
	
	# ユーザのリモートIPアドレス
	$remote_host_name   = $ENV{'REMOTE_HOST'};
	$remote_addr = $ENV{'REMOTE_ADDR'};
	$host_addr   = $ENV{'HTTP_X_FORWARDED_FOR'};

	$data = <<"END";
Return-Path: <$return>
From: $name$from
Reply-to: $from
To: $to
Subject: $subject
MIME-Version: 1.0
Content-Type: $type;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Mailer: $remote_host_name($remote_addr:$host_addr)

$message
END
#-------------------------------------------------------------
	
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
	my $op_f;
	if( $method{'chk_f'} ){
		$op_f = qq| -f $method{'f_mail'}|;
	}
	
	# 送信
	my $senderror=0;
	unless ( open (MAIL, "| $sendmail$op_f -t") ) {
		$senderror = 1;
	}
	print MAIL $data;
	close(MAIL);
	
	# 待ち時間
	if( $method{'chk_sleep'} ){
		sleep( $method{'r_sleep'} );
	}
    return $senderror;

}

sub mail64encode {
  local($xx) = $_[0];
  &jcode'convert(*xx, "jis");
  $xx =~ s/\x1b\x28\x42/\x1b\x28\x4a/g; # 不要かも
  $xx = &base64encode($xx);
  return("=?iso-2022-jp?B?$xx?=");
}

sub base64encode {
  local($base) = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
               . "abcdefghijklmnopqrstuvwxyz"
               . "0123456789+/";
  local($xx, $yy, $zz, $i);
  $xx = unpack("B*", $_[0]);
  for ($i = 0; $yy = substr($xx, $i, 6); $i += 6) {
    $zz .= substr($base, ord(pack("B*", "00" . $yy)), 1);
    if (length($yy) == 2) {
      $zz .= "==";
    } elsif (length($yy) == 4) {
      $zz .= "=";
    }
  }
  return($zz);
}

sub chk_ctype
{
	my $check = shift;
	$check -= 0;
	return 1 if( $check );
	return 0;
}
1;
