#---------------------------------------------------------
# �y���[��pro
#
# �z�M�p�֐��Q send.pl
# v 2.3
#
#---------------------------------------------------------

$limit     = 60 * 60; # �ꎞ�ԁi�Ō�ɑ��M����j
$extension = '.process'; # �v���Z�X�Ǘ��p�t�@�C���g���q

# ���M�����f�[�^
sub send_method
{
	my $errors = shift;
	unless( open(MET, "$myroot$data_dir$methodtxt")  ){
		push @$errors, '���M�����p�f�[�^�t�@�C�����J���܂���';
	}
	my %methods;
	my $method    = 1;
	my $each      = 100;
	my $sleep     = 30;
	my $partition = 50;
	while( <MET> ) {
		chomp;
		my ( $nam, $val ) = split(/\t/);
		$nam = &deltag( $nam );
		$val -= 0;
		$methods{$nam} = $val;
	}
	close(MET);
	$method    = $methods{'method'}    if ( $methods{'method'} ne '' );
	$each      = $methods{'each'}      if ( $methods{'each'} ne '' );
	$sleep     = $methods{'sleep'}     if ( $methods{'sleep'} ne '' );
	$partition = $methods{'partition'} if ( $methods{'partition'} ne '' );
	return $method, $each, $sleep, $partition;
}

# CSV�ꗗ�A�b�v���[�h���̓o�^�����[���z�M�f�[�^
sub upload_prop
{
	my $id;
	my $session = $param{'ss'};
	$session =~ s/[\.\\\/]//g; # ���K��
	my $target;
	my $dir     = "$myroot$data_dir$csv_dir";
	opendir DIR, $dir;
	my @files = readdir DIR;
	closedir DIR;
	foreach my $filename ( @files ){
		if( $filename =~ /^CUR-($session)_(\d+)\.cgi$/ ){
			$target = $dir . $filename;
			$id = $2;
			last;
		}
	}
	return $id, $target, $session;
}


# �Ǘ���ʂ���N��
sub csvupload_each
{
	local @errors;
	local( $id, $filename, $session )           = &upload_prop( \@errors );
	local( $method, $each, $sleep, $partition ) = &send_method( \@errors );
	if( @errors ){
		my $message;
		foreach( @errors ){
			$message .= qq|$_<br>\n|;
		}
		&error('�V�X�e���G���[', $message );
		exit;
	}
	
	#local $process = &permission();
	my( $rest, $sended ) = &csvupload_sender( $id, $filename, $session, $each );
	$param{'id'} = $id;
	if( $main'param{'start'} ){
		&make_plan_page( 'plan', 'up_error' );
	}
	if( $rest > 0 ){
		&make_plan_page( 'plan', 'up' );
	}else{
		&make_plan_page( 'plan', 'guest' );
	}
	exit;
}


# CSV�ꗗ�A�b�v���[�h���̓o�^�����[���z�M���s
sub csvupload_sender
{
	my( $id, $filename, $session, $each ) = @_;
	$param{'id'} = $id;
	my %new_csvdata = ();
	my $fullpath = &lock();
	
	# ���M�ςݒZ�kURL���擾
	my $forward = &Click'getForward_url();
	
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $fullpath );
		&format_pro( $process );
		&error('�V�X�e���G���[',"$file ���J���܂���B<br>���݂��邩�A�p�[�~�b�V���������m�F���������B");
		exit;
	}
	my $csvpath;
	my $queuepath;
	my $logpath;
	my $header;
	my $cancel;
	my $footer;
	my $sk;
	my $tag_data;
	while( <PLAN> ) {
		chomp;
		my @plan = split(/\t/);
		next if( $plan[0] ne $id );
		#next if ( !$plan[37] );# �ғ���~��
		$csvpath   = "$myroot$data_dir$csv_dir$plan[6]";
		$queuepath = "$myroot$data_dir$queue_dir$plan[7]";
		$logpath   = "$myroot$data_dir$log_dir$plan[8]";
		$plan[9]   =~ s/<br>/\n/gi; $header = $plan[9];
		$plan[10]  =~ s/<br>/\n/gi; $cancel = $plan[10];
		$plan[11]  =~ s/<br>/\n/gi; $footer = $plan[11];
		$sender    = $plan[3];
		$admin     = $plan[4];
		$tag_data = $plan[82];
		&Pub'ssl($plan[83]);
		$sk        = ( split(/,/, $plan[35]) )[1]; # �o�^�����[���z�M�t���O
	}
	close(PLAN);
	
	#---------------------------#
	# �]���p�^�O�擾            #
	#---------------------------#
	my( $urlTag, $other ) = &Click'roadTag( $tag_data );
	
	# �o�^���[���擾
	my $rh_body = &get_body( $queuepath );
	local ( $_subject, $_message ) = &make_send_body( 0, $rh_body, $header, $cancel, $footer );
	
	# �z�M���O�t�@�C�����J��
	unless ( open(LOG, ">>$logpath") ) {
		&rename_unlock( $fullpath );
		&format_pro( $process );
		&error('�V�X�e���G���[', "���O�t�@�C�����J���܂���($logpath)");
		exit;
	}
	# �V�K�o�^�҂��J��
	unless ( open(LIST, "$filename") ) {
		&rename_unlock( $fullpath );
		&format_pro( $process );
		&error('�V�X�e���G���[', '�V�K�o�^�҃��X�g���J���܂���B');
		exit;
	}
	# ���X�g�X�V�t�@�C�����쐬
	my $tmplist = "$myroot$data_dir$csv_dir" . $session . '.cgi';
	unless ( open(TMPLIST, ">$tmplist") ) {
		&rename_unlock( $fullpath );
		&format_pro( $process );
		&error('�V�X�e���G���[', "$myroot$data_dir$csv_dir �Ƀt�@�C�����쐬�ł��܂���B");
		exit;
	}
	chmod 0606, $tmplist;
	my %ADDR;
	my $sended = 0;
	my $rest   = 0;
	my $n = 0;
	while(<LIST>){
		if( $n > 1000 ){
			$n = 0;
			select(undef, undef, undef, 0.20);
		}
		chomp;
		
		# �X�V�t�@�C���ɔ��f
		if( $each <= $sended ){
			print TMPLIST "$_\n";
			$rest++;
			next;
		}
		my @par = split(/\t/);
		#next if( defined $ADDR{$par[5]} ); # �d���A�h���X
		
		$par[20]    = 0; # �ς݉��o�^����
		my $newline = join("\t", @par);
		# �ȈՃ^�O�}���p�ɏC��
		my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
		$subject = &include( \@par, $_subject );
		
		# �]���^�O�ϊ�
		my $unic = $id. '-0';
		my $forward_urls;
		($message, $forward_urls) = &Click'analyTag($par[0], $_message, $urlTag, $unic, $forward);
		$message = &include( \@par, $message, $jis );
		
		if ( !$sk ) {
			$senderror = &send( $admin, $sender, $par[5], $subject, $message );
			# �z�M���O�ɒǉ�
			unless ( $senderror ) {
				my $date = time;
				open(LOG, ">>$logpath");
				print LOG "$par[0]\t$par[5]\t$par[3]\t$date\t0\t$subject\n";
				close(LOG);
				my $sid = $par[0] -0;
				$new_csvdata{$sid} = $newline;
			}else{
				unlink $tmplist;
				&format_pro( $process );
				&rename_unlock( $lockfull );
				&error('�V�X�e���G���[','���[�������M�ł��܂���B�isendmail���N���ł��܂���j');
			}
			# �A�N�Z�X�W�v�p�f�[�^����
			&Click'setForward_t( $forward_urls, $unic );
		}
		$ADDR{$par[5]} = 1;
		$sended++;
	}
    close(LIST);
	close(TMPLIST);
	if ( (keys %new_csvdata) ) {
		# �o�^�҂̍X�V
		&renew_csv_data( $csvpath, \%new_csvdata );
	}
	if( $rest ){
		unless( rename $tmplist, $filename ){
			&rename_unlock( $fullpath );
			&error('�V�X�e���G���[', "$tmplist �� $filename �Ƀt�@�C�����쐬�ł��܂���B");
			exit;
		}
	}else{
		unlink $tmplist;
		unlink $filename;
		unlink "$myroot$data_dir$csv_dir" . $session;
	}
	&rename_unlock( $fullpath );
	&format_pro( $process );
	
	# �A�N�Z�X�W�v
	&Click'pickup( 1 );
	
	# �z�M�I��
	return $rest, $sended;
}

#--------------------------------#
# �o�^�҃f�[�^�̍X�V             #
#--------------------------------#
sub renew_csv_data {
	my ( $file, $rh_data ) = @_;
	open(CSV, "$file");
	my $tmp = "$myroot$data_dir$csv_dir" . $$ . time . '.cgi';
	open(TMP, ">$tmp");
	my $n = 0;
	while( <CSV> ) {
		$n++;
		if( $n > 1000 ){
			$n = 0;
			select(undef, undef, undef, 0.20);
		}
		my $index = $_-0;
		if ( $rh_data->{$index} ne '' ) {
			$_ = $rh_data->{$index} . "\n";
		}
		print TMP "$_";
	}
	close(CSV);
	close(TMP);
	rename $tmp, $file;
	eval{ chmod 0606, $file; };
	%$rh_data = (); # ������
}

#-------------------------------------------#
# �v���Z�X�Ǘ��֐��Q                        #
#-------------------------------------------#

# �v���Z�X�̍쐬
sub pro {

	my $now = time;
	my $file = $myroot . $data_dir . $now . $extension;
	
	open(PRO, ">$file");
	print PRO "$now\n";
	close(PRO);
	return $file;
	
}

# �v���Z�X�̊Ǘ�
sub permission {

	opendir DIR, "$myroot$data_dir";
	my @files = readdir DIR;
	foreach my $file ( @files ) {
		if ( $file =~ /(\d+)$extension$/ ) {
			# �z�M���ł�
			my $now = time;
			if ( $now - $1 >= $limit ) {
				&format_pro( "$myroot$data_dir$file", $1 );
				next;
			}
	
			# �z�M����`���郁�b�Z�[�W��\��
			if ( !$ENV{'REQUEST_METHOD'} ) {
				# �N�[��������̋N����
				print <<"END";
�u�y���[���v�͔z�M���ł��B

�z�M�󋵂͊Ǘ���ʁu�z�M���O�v�Ŋm�F���Ă�������
END
			}else{
				&error( '�u�y���[���v�͔z�M���ł��B', '�z�M�󋵂͊Ǘ���ʁu�z�M���O�v�Ŋm�F���Ă�������' );
			}
			exit;
		}
	}
	# �z�M���ł͂Ȃ�
	my $file = &pro();
	return $file;

}

sub format_pro {
	my( $file, $t ) = @_;
	unlink "$file";
	return if( $t <= 0 );
	
	&print_errlog($t, '�ɋN�������z�M������ɏI�����܂���ł����B');
}

sub get_csvup_session
{
	my $id   = shift;
	my $dir  = "$myroot$data_dir$csv_dir";
	opendir DIR, $dir;
	my @files = readdir DIR;
	closedir DIR;
	my $session;
	my $target;
	foreach my $filename ( @files ){
		if( $filename =~ /^CUR-(.+)_(\d+)\.cgi$/ ){
			if( $id eq $2 ){
				$target = $dir . $filename;
				$session = $1;
				last;
			}
		}
	}
	return $session, $target;
}

# CSV�A�b�v���[�h���̓o�^�����[�����M�pIMG�^�O����
sub csvup_sendtag
{
	my $session = shift;
	#my $sendurl = $applycgi;
	#$sendurl  =~ s/\/[^\/]+\.[^\/]+$//;
	#$sendurl .= "/$sendpl";
	my $sendtag = qq|<img src="./$sendcgi?ss=$session" border="0" width="1" height="1">|;
	return $sendtag;
}

sub sender_chk
{
	my( $method, $each, $sleep, $partition ) = @_;
	
	my $dir = "$myroot$data_dir$csv_dir";
	opendir DIR, $dir;
	my @files = readdir DIR;
	closedir DIR;
	
	my @UP_LIST;
	my $now = time;
	my $csvup = 0;
	@files = sort { (stat("$dir$a"))[9] <=> (stat("$dir$b"))[9] } @files;
	foreach my $filename ( @files ){
		my $filepath = $dir . $filename;
		my $date = ( stat($filepath) )[9];
		next if( ( $date + (60*5) ) > $now );
		if( $filename =~ /^CUR-(.+)_(\d+)\.cgi$/ ){
			my $session = $1;
			my $id = $2;
			push @UP_LIST, [$id,$session, $filepath];
			$csvup++;
		}
	}
	
	# ���݂��Ȃ��ꍇ�͍Ĕz�M�����I��
	return if( !$csvup );
	
	if( $method ){
		
		CKH_FORK: {
			if( $pid = fork ) {
				if ( !$set ) {
					my $message = "�u�y���[���v�z�M���J�n���܂����B!!\n";
					my $body = qq|<html><head><meta HTTP-EQUIV='Content-type' CONTENT='text/html; charset=shift_jis'><title>$title</title></head><body>$message</body></html>|;
					my $length = length $body;
					$| = 1;
					if ( $ENV{'REQUEST_METHOD'} ) {
						# �u���E�U����̋N��
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
				
				# CSV���M
				my $send_result = 0;
				foreach my $CSV ( @UP_LIST ){
					my $id = $CSV->[0];
					my $session = $CSV->[1];
					my $filename = $CSV->[2];
					&print_errlog( (stat($filename))[9], '����CSV�A�b�v���[�h�o�^���z�M�������I�����ꂽ�\��������܂��B' );
					CHK_CSVUP:
					my($rest, $sended ) = &csvupload_sender( $id, $filename, $session, $partition );
					if( $rest > 0 ){
						sleep($sleep);
						goto CHK_CSVUP;
					}
					$send_result = $sended;
				}
				
				# �ʏ�X�e�b�v���[���z�M
				$process = &permission();
				&main_loop();
				exit;
				
			} elsif ( $! =~ /No more process/) {
				# �v���Z�X���������鎞�́A���Ԃ�u���čă`�������W�B
				sleep 5;
				redo CHK_FORK;
			} else {
				# fork�g�p�s�T�[�o�[�B
				&format_pro( $process );
				&error('�V�X�e���G���[',"�o�b�N�O�����h��CGI�����s�ł��Ȃ����߁A�����z�M���o���܂���B<br>���M�������u�A�N�Z�X���ɑ��M����v�ɐݒ肵�Ă��������B");
				exit;
			}
		}
		
		
	}else{
		
		# �z�M�r������Ԃ�(�X�e�b�v���[�����M�ɗ��p)
		my $send_result = 0;
		foreach my $CSV ( @UP_LIST ){
			my $id = $CSV->[0];
			my $session = $CSV->[1];
			my $filename = $CSV->[2];
			&print_errlog( (stat($filename))[9] );
			my($rest, $sended ) = &csvupload_sender( $id, $filename, $session, $each );
			$send_result = $sended;
		}
		return $send_result;
	}
	
	exit;
	
}

# �e�X�e�b�v�̋N�Z�����擾
sub getBaseTime
{
	my( $basedate, $intervals, $sended, $target ) = @_;
	# $target ���M�ς�
	# $next �w���
	
	my @interval = split( /,/, (split(/<>/,$intervals))[0] );
	my %Date;
	foreach( split(/<>/,$sended) ){
		my( $stepNum, $date ) = split(/\// );
		$Date{$stepNum} = $date;
	}
	$Date{'1'} = $basedate; # �o�^��
	
	# �Ώۂ̋N�Z����擾
	my $baseStepNum = &getBaseNum( $intervals, $target );
	
	my $lastStep = 1;
	my $n = 2;
	my %StepBase;
	foreach( @interval ){
		my( $int, $config, $uniq ) = split( /\// );
		$Date{$n} = $basedate + (60*60*24*$int) if( $Date{$n} <= 0 && !$config );
		$lastStep = $n if( $Date{$n} );
		if( $config ){
			$basedate = ( $baseStepNum == $n )? $Date{$lastStep}: time;
		}
		$StepBase{$n} = $basedate;
		$n++;
	}
	#&main'error($lastStep);
	$str .= "�o�^�� =>". &make_date3($Date{'1'}). '<BR>';
	foreach( sort{ $a <=> $b } keys %StepBase ){
		$str .= $_. ' => '. &make_date3($StepBase{$_}). '<BR>';
	}
	#&main'error($str);
	return {%StepBase};
}

sub getBaseNum
{
	my( $intervals, $target ) = @_;
	# �Ώۂ̋N�Z����擾
	my $baseStepNum = 1;
	my $count = 2;
	my @interval = split( /,/, (split(/<>/,$intervals))[0] );
	foreach( @interval ){
		my( $int, $config, $uniq ) = split( /\// );
		last if( $target < $count );
		if( $config ){
			$baseStepNum = $count;
		}
		$count++;
	}
	return $baseStepNum;
}

sub print_errlog
{
	my( $_date, $message ) = @_;
	my $logfile = $main'myroot . $main'data_dir . 'errorlog.cgi';
	my $tmp = $main'myroot . $main'data_dir. 'ERR-TMP-'. $$. time. '.cgi';
	
	open( ERRTMP, ">$tmp" );
	open( ERR, "<$logfile" );
	while( <ERR> ){
		print ERRTMP $_;
	}
	
	my($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($_date+(60*60*9));
	my $date = sprintf ( "%04d/%02d/%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec );
	print ERRTMP qq|$date | . $message . qq|\n|;
	close(ERR);
	close(ERRTMP);
	eval{ chmod 0606, $tmp; };
	rename $tmp, $logfile;
}

sub debug
{
	print "Content-type: text/html\n\n";
	print "<html><head><title>CGI</title></head>\n";
	print "<body>\n";
	print "$_[0]";
	print "</body></html>\n";
	exit;
}


1;
