package Pub;

$scriptName = &getScriptName();


sub getScriptName
{
	my $ssl = shift;
	my $script_name = $ENV{'SCRIPT_NAME'};
	$script_name =~ /(.*\/)([^\/]+)$/;
	my $localpath = $1;
	my $url = 'http://' . $ENV{'SERVER_NAME'} . $localpath;
	return $url;
}


sub getServerData
{
	my $R_SEV = shift;
	open( SEV, $main'DATA{'server'} );
	my %server;
	while(<SEV>){
		chomp;
		my( $name, $val ) = split(/\t/);
		$R_SEV->{$name} = $val;
	}
	close(SEV);
	my $imgpath = $R_SEV->{'imgpath'};
	my $imglocal = $R_SEV->{'imglocal'};
	#my $auto = $R_SEV->{'auto'};
	my $sendmail = $R_SEV->{'sendmail'};
	#my $each = $R_SEV->{'each'};
	#my $limit = $R_SEV->{'limit'};
	
	# デフォルト設定
	#eval "$_sendmail = qx( which sendmail );";
	
	# v2.4以前は、DEF_image_dirを参照（config.pl）
	my $ImageDir = ( $DEF_image_dir )? $main'DEF_image_dir: $main'image_dir;
	
	$R_SEV->{'sendmail'} = ( $sendmail eq '' )? &getSendmail(): $sendmail;
	#$R_SEV->{'each'} = ( $each eq '' )? $DEF_EACH: $each;
	$R_SEV->{'imgpath'} = ( $imgpath eq '' )? $ImageDir: $imgpath;
	$R_SEV->{'imgpath'} = ( $R_SEV->{'imgpath'} =~ /\/$/ )? $R_SEV->{'imgpath'}: $R_SEV->{'imgpath'} . '/';
	#$R_SEV->{'auto'} = $auto -0;
	if(  $imglocal ne '' ){
		$R_SEV->{'imglocal'} = $imglocal;
		$R_SEV->{'imglocal'} = ( $R_SEV->{'imglocal'} =~ /\/$/ )? $R_SEV->{'imglocal'}: $R_SEV->{'imglocal'} . '/';
	}else{
		$R_SEV->{'imglocal'} = $R_SEV->{'imgpath'};
	}
	#$R_SEV->{'limit'} = ( $log_limit )? $log_limit: $DEF_LIMIT;
	$R_SEV->{'imgpath'} =~ s/^\///;
}

sub getSendmail
{
	my $sendmail;
	foreach( @main'SENDMAIL ){
		if( -x $_ ){
			$sendmail = $_;
			last;
		}
	}
	return $sendmail;
}

sub setUrlPath
{
	local $_ = shift;
	my( $http, $path ) = split( /\/\// );
	$path =~ /([^\/]+\/)(.+)$/;
	my $domain = $1;
	my @dirs = split(/\//,$2);
	my $count = 0;
	my @result;
	for( my $i=$#dirs; $i>=0; $i-- ){
		local $_ = $dirs[$i];
		next if( /^\s$/ );
		next if( /^\.$/ );
		s/^\.+$/\.\./g;
		next if( /^\.$/ );
		if( /^\.\.$/ ){
			$count++;
			next;
		}
		if( $count ){
			$count--;
			next;
		}
		$count = 0;
		my $p = $dirs[$i];
		unshift @result, $_;
	}
	if( $result[-1] !~ /\./ ){
		$result[-1] .= '/';
	}
	
	my $getpath = join( "/", @result );
	my $fullpath = $http . '//' . $domain . $getpath;
	return $fullpath;
}

sub setHttp
{
	my( $href, $http, $opt ) = @_;
	$href =~ s/^http(s)?:\/\///;
	
	if( $opt eq '' ){
		return $href;
	}
	$http = 'http://' if( $http !~ /^https:\/\// );
	return $http.$href;
}

sub ssl
{
	my( $flag ) = @_;
	if( $flag ){
		if( $main'applycgi !~ /^https/ ){
			$main'applycgi =~ s/^http/https/;
		}
	}else{
		if( $main'applycgi =~ /^https/ ){
			$main'applycgi =~ s/^https/http/;
		}
	}
}

# 画像表示
sub image
{
	my $filename = $main'param{'p'};
	$filename =~ s/\.*[\\|\/]//gi;
	
	if( $param{'n'} ){
		print "Cache-Control: no-cache\n";
	}
	
	#my $css;
	#my $self = &get_self();
	#my $url = &getUrlPath();
	
	if( $filename =~ /\.js$/ ){
		print "Content-type: text/plain", "\n\n";
	}elsif( $filename =~ /\.css$/ ){
		print "Content-type: text/css", "\n\n";
		$css = $url. $self. '?mode=img&p=';
	}elsif( $filename =~ /\.csv/ ){
		print qq|Content-Disposition: attachment; filename="$filename"| , "\n";
		print "Content-type: application/x-csv", "\n\n";
	}else{
		$filename =~ /([^\/\\]*)\.([^.\/\\]*)$/;
		my $ext = $2  || 'gif';
		print "Content-type: image/$ext", "\n\n";
	}
	
	my $filepath = $main'myroot. $main'template . $filename;
	open( FILE, $filepath );
	binmode(STDOUT);
	binmode(FILE);
	while(<FILE>){
		if( $css ne '' ){
			s/\.\//$css/ig;
		}
		print $_;
	}
	exit;
}

sub Server
{
	my( $chk ) = @_;
	my %SEV;
	&getServerData(\%SEV);
	if( $chk ){
		$SEV{'apply'} = $main'applycgi;
		my $tmpfile = $main'myroot. $main'data_dir. 'SEV-'. $$. time. '.cgi';
		open(TMP, ">$tmpfile");
		foreach( keys %SEV ){
			print TMP "$_\t$SEV{$_}\n";
		}
		close(TMP);
		eval{ chmod 0606, $tmpfile; };
		rename $tmpfile, $main'DATA{'server'};
	}
	$main'sendmail = $SEV{'sendmail'};
	$main'image_dir = $SEV{'imgpath'};
	$main'image_local = $SEV{'imglocal'};
	$main'applycgi = $SEV{'apply'};
}

1;
