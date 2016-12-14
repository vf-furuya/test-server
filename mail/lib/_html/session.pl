
package Session;
#==========================================================================#
#                                                                          #
#                                                                          #
#   -- セッション管理  --                                                  #
#                                                                          #
#   version 1.0                                                            #
#                                                                          #
#==========================================================================#

sub check
{
	my( $error )  = @_;
	my $ERR = ( $error eq '' )? \&error: $error;
	
	my $logfile = $main'Session{'dir'} . $main'Session{'file'};
	&clean( $logfile, $ERR );
	local %COOKIE;
	&getCookie( \%COOKIE, $main'Session{'cookie_id'} );
	
	open( FILE, $logfile );
	my $flag = 0;
	while( <FILE> ){
		chomp;
		my @data = split(/\t/);
		if( $data[0] eq $COOKIE{'SSID'} ){
			$flag = 1;
			last;
		}
	}
	close(FILE);
	&over( \%COOKIE, $logfile, $ERR ) if( $flag );
	return $flag;
}
sub clean
{
	my( $logfile, $ERR ) = @_;
	open( FILE, $logfile );
	my $tmpfile = $main'Session{'dir'} . time . $$ . '.cgi';
	unless( open( TMP, ">$tmpfile" ) ){
		$ERR->( "パーミッションエラー","$main'Session{'dir'}のパーミッションが[707]であるかご確認ください。");
		exit;
	}
	eval{ chmod 0606, $tmpfile; };
	while(<FILE>){
		chomp;
		@data = split(/\t/);
		my $now = time;
		next if( $data[1] < $now );
		print TMP "$_\n";
	}
	close(FILE);
	close(TMP);
	rename $tmpfile, $logfile;
}
sub set
{
	my( $sult, $error )  = @_;
	my $ERR = ( $error eq '' )? \&error: $error;
	my $logfile = $main'Session{'dir'} . $main'Session{'file'};
	
	local %COOKIE;
	$COOKIE{'SSID'} = &make_id( $sult );
	my $limit       = time + ($main'Session{'limit'} * 60);
	my $line        = qq|$COOKIE{'SSID'}\t$limit\n|;
	my $secure      = 1 if( $main'Session{'ssl'} );
	&setCookie( \%COOKIE, $main'Session{'cookie_id'}, '', $secure );
	unless( open( FILE, ">>$logfile" ) ){
		$ERR->( "パーミッションエラー","$main'Session{'dir'}のパーミッションが[707]であるかご確認ください。");
		exit;
	}
	print FILE $line;
	close(FILE);
}

sub reset
{
	my( $sult, $error )  = @_;
	my $ERR = ( $error eq '' )? \&error: $error;
	my $logfile = $main'Session{'dir'} . $main'Session{'file'};
	
	local %COOKIE;
	&getCookie( \%COOKIE, $main'Session{'cookie_id'} );
	my $dir     = $main'Session{'dir'};
	my $tmpfile = $dir . time . $$ . '.cgi';
	my $limit   = time + ($main'Session{'limit'} * 60);
	my $line    = qq|$COOKIE{'SSID'}\n$limit\n|;
	
	open( FILE, $logfile );
	unless( open(TPL, ">$tmpfile") ){
		$ERR->( "パーミッションエラー","$main'Session{'dir'}のパーミッションが[707]であるかご確認ください。");
		exit;
	}
	while(<FILE>){
		chomp;
		my @data = split(/\t/);
		next if( $data[0] eq $COOKIE{'SSID'} );
		print TPL "$_\n";
	}
	close(FILE);
	close(TPL);
	eval{ chmod 0606, $tmpfile; };
	rename $tmpfile, $logfile;
	&setCookie( \%COOKIE, $main'Session{'cookie_id'}, -1 );
}

sub over
{
	my( $COOKIE, $logfile, $ERR )  = @_;
	my $dir     = $main'Session{'dir'};
	my $tmpfile = $dir . time . $$ . '.cgi';
	my $limit   = time + ($main'Session{'limit'} * 60);
	my $line    = qq|$COOKIE->{'SSID'}\n$limit\n|;
	
	unless( open( FILE, $logfile ) ){
		$ERR->( "パーミッションエラー","$main'Session{'dir'}のパーミッションが[707]であるかご確認ください。");
		exit;
	}
	unless( open(TPL, ">$tmpfile") ){
		$ERR->( "パーミッションエラー","$main'Session{'dir'}のパーミッションが[707]であるかご確認ください。");
		exit;
	}
	while(<FILE>){
		chomp;
		my @data = split(/\t/);
		if( $data[0] eq $COOKIE->{'SSID'} ){
			my $limit = time + ($main'Session{'limit'} * 60);
			$_ = qq|$COOKIE->{'SSID'}\t$limit|;
		}
		print TPL "$_\n";
	}
	close(FILE);
	close(TPL);
	eval{ chmod 0606, $tmpfile; };
	rename $tmpfile, $logfile;
}

sub error
{
	print "Content-type: text/html\n\n";
	print <<"END";
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis" />
<title>Error!</title>
</head>
$_[0]
<body>
</body>
</html>
END
	exit;
}

sub make_id {
	
	my $str = shift;
	return crypt( $str, &make_salt() );
}

sub make_salt {
	srand (time + $$);
	return pack ('CC', int (rand(26) + 65), int (rand(10) +48));
}

sub getCookie{
	my( $COOKIE, $cookie_id ) = @_;
	my %all_cookies;
	foreach (split (/; /, $main'ENV{'HTTP_COOKIE'})){
		my ($key, $val) = split (/=/);
		$all_cookies{$key} = $val;
	}
	foreach (split (/&/, $all_cookies{$cookie_id})){
		my ($key, $val) =  split(/:/);
		$COOKIE->{&unescape($key)} = &unescape($val);
	}
}

sub setCookie{
	my( $COOKIE, $cookie_id, $e, $s ) = @_;
	my @pairs = ();
	foreach (sort keys %$COOKIE){
		push(@paris, &escape($_).":".&escape($COOKIE->{$_}));
	}
	my $new_cookie = join ('&', @paris);
	my $expires;
	my $secure;
	if( $e ne '' ){
		my $now = time;
		my $gmt = &gmt_date( $now );
		$expires = " expires=$gmt;";
	}
	$secure = " secure" if( $s );
	if ($new_cookie ne $all_cookies{$cookie_id}){
		print "Set-Cookie: $cookie_id=$new_cookie;$expires$secure\n";
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
1;
