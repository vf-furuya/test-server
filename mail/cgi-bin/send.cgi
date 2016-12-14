#!/usr/bin/perl

#---------------------------------------
# �y���[��pro
#
# �X�e�b�v���[�����M��pCGI�t�@�C�� send.cgi
# v 2.4
#---------------------------------------

# distribute�f�B���N�g���̑��΃p�X�icron���g�p����ꍇ�́u��΃p�X�v�j
$myroot = '../';

# ��΃p�X�ݒ��
# $myroot = '/home/rakumail/public_html/distribute/';

# ���C�u�����C���|�[�g
require "${'myroot'}lib/send/send.pl";
require "${'myroot'}lib/Pub.pl";
require "${'myroot'}lib/System.pl";
require "${'myroot'}lib/cgi_lib.pl";
require "${'myroot'}lib/jcode.pl";
require "${'myroot'}lib/_html/Click.pl";

&Pub'Server();

$title         = '�u�y���[���v�z�M�Ǘ�';
&method_ck();

my @errors;
local( $method, $each, $sleep, $partition ) = &send_method( \@errors );

# �Ĕz�M���M�ςݐ�
$csvsum = 0;
#----------------------------------------------------------------------------#
# CSV�A�b�v���[�h�z�M
#----------------------------------------------------------------------------#
if( $param{'ss'} ne '' ){
	&csvupload_fork();
	exit;
}else{
	
	# �z�M�ĊJ�`�F�b�N
	$csvsum = &sender_chk($method, $each, $sleep, $partition);
}

local $process = &permission();
#----------------------------------------------------------------------------#
# �X�e�b�v���[���z�M
#----------------------------------------------------------------------------#
if ( $method ) {

FORK: {
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
		&main_loop();
    	exit;
	
	} elsif ( $! =~ /No more process/) {
    	# �v���Z�X���������鎞�́A���Ԃ�u���čă`�������W�B
    	sleep 5;
    	redo FORK;
	} else {
    	# fork�g�p�s�T�[�o�[�B
		&format_pro( $process );
    	&error('�V�X�e���G���[',"�o�b�N�O���E���h��CGI�����s�ł��Ȃ����߁A�����z�M���o���܂���B<br>���M�������u�A�N�Z�X���ɑ��M����v�ɐݒ肵�Ă��������B");
		exit;
	}
}

}else{
	&main_loop( $csvsum );
}

# -----------------------------------------------------------------------------------
# ��`�֐�
# -----------------------------------------------------------------------------------

sub main_loop {

my $csvsum = shift;
my $sum = 0;
my $start_time = (times)[0];

$sum += $csvsum if( $csvsum > 0 );

MAINLOOP:

# �A�N�Z�X�W�v
&Click'pickup( 1 );

# ���M�ςݒZ�kURL���擾
my $forward = &Click'getForward_url();

my %new_csvdata = ();
my $fullpath = &lock();

#--------------------------#
# �����̃v�����f�[�^���擾 #
#--------------------------#
my $file = "$myroot$data_dir$log_dir$plan_txt";

unless ( open(PLAN, "$file" ) ) {
    push @errors, '�z�M�v�����t�@�C�����J���܂���';
}
while( <PLAN> ) {
	last if ( !$method && ($sum >= $each) );
	
	if( $method && ($sum >= $partition) ) {
		$sum = 0; # ������
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
    next if ( !$plan[37] );# �ғ���~��
	
	&Pub'ssl($plan[83]);
	
	#---------------------------#
	# �ȈՉғ��w��              #
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
    my ( $count, @input_check ) = split(/,/, $plan[35]); # �z�M���A�}���`�F�b�N
	my ( $intervals, $dates ) = split( /<>/, $plan[36] );
    my @interval = split(/,/, $intervals);                # �z�M����
	my @dates = split( /,/, $dates );
    my $rh_body = &get_body( $queuepath );
    unless ( open(LOG, ">>$logpath") ) {
        push @errors, '���O�t�@�C�����J���܂���';
    }
    
    unless ( open(CSV, "$csvpath") ) {
        push @errors, '�o�^�҃f�[�^���擾�ł��܂���';
    }
	
	#---------------------------#
	# �]���p�^�O�擾            #
	#---------------------------#
	my( $urlTag, $other ) = &Click'roadTag( $plan[82] );
	
	my $SENDED_INFO;
    while( <CSV> ) {
		last if ( !$method && ($sum >= $each) );
		
		if( $method && ($sum >= $partition) ) {
			$sum = 0; # ������
			close(PLAN);
			close(CSV);
			close(LOG);
			if ( (keys %new_csvdata) ) {
				# �o�^�҂̍X�V
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
		# ���t�w�萧��p
		#--------------------------------------------------------
		my $inputed_codedate = &make_datecode($csv[21]); # �ŏI���M���i�b�j���t�w�著�M�Ɏg�p
		my $inputed_codedate_day = substr( &make_datecode($csv[21]), 4 ); # �ŏI���M���i�b�j���t�w�著�M�Ɏg�p
		my $now = time;
		$nowcode = &make_datecode($now);
		$nowcode_day = substr( &make_datecode($now), 4);
		my $flag = 0;
        my $n = 0;
		
        # ���t�w��̏ꍇ
		foreach my $_date ( @dates ) {
			last if ( !$method && ($sum >= $each) );
			if( $method && ($sum >= $partition) ) {
				$sum = 0; # ������
				close(PLAN);
				close(CSV);
				close(LOG);
				if ( (keys %new_csvdata) ) {
					# �o�^�҂̍X�V
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
			# �ŏI���M�����{���Ŗ����ꍇ
        	if ( $inputed_codedate ne $nowcode ) {
				
        		next if ( $code_year > 0 && $code_year.$code_day ne $nowcode );
				next if ( $code_year <= 0 && $code_day ne $nowcode_day );
					
					#my $edcode = $csv[5] . "[$nowcode]";
					# ���ꃁ�[���A�h���X�ɂ́A���M���Ȃ�
					if( index( $SENDED_INFO, $SENDED_CODE ) >= 0 ){
						$csv[21] = $now; # �ŏI���M���i�b�j���t�w��
                		my $line = join("\t", @csv);
						my $sid = $csv[0] -0;
                		$new_csvdata{$sid} = $line;
						goto STEP;
					}
					$SENDED_INFO .= "#$SENDED_CODE";
					my $code = $code_day;
					$code .= $code_year if( $code_year > 0 );
					
					# ���M���[���쐬
        			local ( $subject, $message ) = &make_send_body( "d$code", $rh_body, $header, $cancel, $footer );
					
        			my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
        			$subject = &include( \@incsv, $subject );
					$message = &include( \@incsv, $message, $jis );
					$senderror = &send( $plan[4], $plan[3], $csv[5], $subject, $message );
					if ( !$senderror ) {
                		print LOG "$csv[0]\t$csv[5]\t$csv[3]\t$now\td$code\t$subject\n";
                		$csv[21] = $now; # �ŏI���M���i�b�j���t�w��
                		my $line = join("\t", @csv);
						my $sid = $csv[0] -0;
                		$new_csvdata{$sid} = $line;
						
            		} else {
					
                		push @errors, '���[�������M�ł��܂���';
                		last;
						
            		}
					$sum++;
				
				
			}
		}
		
		STEP:
		#----------------------------------------------------------
		# �����Ԋu�̏ꍇ
		#----------------------------------------------------------
        my $registDate = $csv[19]-0; # �o�^���i�b�j
		my $targetStep = $csv[51]; # �z�M��w��
		my $stop = $csv[52] -0;
		my %baseTime; # �ĊJ���t
		foreach( split(/<>/,$csv[53] ) ){
			my( $n, $date ) = split(/\//);
			$baseTime{$n} = $date;
		}
		my( $targetInterval, $targetBase ) = split(/\//, $csv[54]); # �w���̋N�Z�����ƋN�Z���t
		
		
		# �z�M�����̏ꍇ
		next if( $targetStep eq 'end' );
		
		my $sendStepNum = ( $csv[51] > 0 )? $csv[51]: $csv[20];
		my $stepBase = &getBaseTime( $registDate, $intervals, $csv[53], $sendStepNum );
		
		my $n = 1;
		#my $date = $registDate; # �o�^��
        foreach my $_int ( @interval ) {
			my( $int, $config, $unic ) = split( /\//,$_int );
			$n++; # �z�M�񐔂�i�߂�
			
			# �N�Z�����̊�{���t���擾
			#if( $config ){
			#	$date = $baseTime{$n} if( $baseTime{$n} > 0 );
			#}
			#if( $targetInterval > 0 ){
			#	$date = $targetBase if( $targetBase > 0 );
			#	$int = $targetInterval;
			#}
			
			last if ( !$method && ($sum >= $each) );
			if( $method && ($sum >= $partition) ) {
				$sum = 0; # ������
				close(PLAN);
				close(CSV);
				close(LOG);
				if ( (keys %new_csvdata) ) {
					# �o�^�҂̍X�V
					&renew_csv_data( $csvpath, \%new_csvdata );
				}
				&rename_unlock( $fullpath );
				&format_pro( $process );
				$process = &pro();
				sleep( $sleep );
				goto MAINLOOP;
			}
			# �ꎞ��~�̏ꍇ
			last if( $stop );
			# �z�M�ς݂̏ꍇ
			next if( $n <= $csv[20] );
			# �w��񂪂���ꍇ
			next if( $targetStep > 0 && $n < $targetStep );
			# �N�Z���t
			my $date = $stepBase->{$n};
			# �ĊJ�w�肪�L��ꍇ
			if( $targetInterval > 0 ){
				$date = $targetBase;
				$int = $targetInterval;
			}
			$datecode = &make_datecode( $date+(60*60*24*$int) ); # �z�M��
			
			# �o�^���ɒB���Ă��Ȃ��ꍇ
			last if ( $nowcode < $datecode );
			
			
			# ���z�M�Ɉꎞ��~���L��ꍇ�́A�����܂�
			if( $config && !$targetInterval ){
				$stop = 1;
				$csv[52] = 1;
				my $line = join("\t", @csv);
				my $sid = $csv[0] -0;
				$new_csvdata{$sid} = $line;
				last;
			}
			
			#$flag = 2 if ( $nowcode >= $datecode );
			# ���M���[���쐬
			local ( $subject, $message ) = &make_send_body( $n-1, $rh_body, $header, $cancel, $footer );
			# �]���^�O�ϊ�
			my $forward_urls;
			($message, $forward_urls) = &Click'analyTag($csv[0], $message, $urlTag, $unic, $forward);
			
			my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
			$subject = &include( \@incsv, $subject );
			$message = &include( \@incsv, $message, $jis );
			$senderror = &send( $plan[4], $plan[3], $csv[5], $subject, $message );
			if ( !$senderror ) {
				my $sendNum = $n -1;
				print LOG "$csv[0]\t$csv[5]\t$csv[3]\t$now\t$sendNum\t$subject\n";
				$csv[20] = $n; # �ŏI�z�M�ԍ��̍X�V
				my $def = 0;
				if( $targetStep == $n || $targetInterval ){
					$targetStep = '';
					$targetInterval = '';
					$targetBase = '';
					$csv[51] = ''; # �w���
					$csv[54] = ''; # �w��z�M�J�n��
					$def = 1;
				}
				$baseTime{$n} = time;
				my @base;
				foreach( keys %baseTime ){
					push @base, qq|$_/$baseTime{$_}|;
				}
				$csv[53] = join( "<>", @base );
				$csv[52] = 0; # �ꎞ��~������
				$stop = 0;
				my $line = join("\t", @csv);
				my $sid = $csv[0] -0;
				$new_csvdata{$sid} = $line;
				
				# �A�N�Z�X�W�v�p�f�[�^����
				&Click'setForward_t( $forward_urls, $unic );
				
				if( $def ){
					$sum++;
					goto STEP;
				}
				
			} else {
			
				push @errors, '���[�������M�ł��܂���';
				last;
				
			}
			$sum++;
		}
	}
	close(CSV);
	
	if ( (keys %new_csvdata) ) {
		# �o�^�҂̍X�V
		&renew_csv_data( $csvpath, \%new_csvdata );
	}
	
}
close(PLAN);
&rename_unlock( $fullpath );
&format_pro( $process );
# �z�M�I��

return if defined $pid; # �q�v���Z�X�Ȃ�I��

my $end_time = (times)[0];
my $search_time = sprintf ("%.3f",$end_time - $start_time);
if ( !$set ) {
	my $more = '<br><br>���[�����M�̐������ɒB�����ׁA���M�𒆒f���܂���<br>������x�A�A�N�Z�X���Ă�������' if ( !$method && ($sum >= $each) );
    #--------------#
    # �o��         #
    #--------------#
    if ( !$ENV{'REQUEST_METHOD'} ) {
        if ( @errors ) {
            foreach ( @errors ) {
                print $_, '<br>';
            }
        } else {
            print <<"END";
[ ���[�������z�M ]
����ɔz�M���I�����܂���

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
            &error('�������܂���',"$sum ���̃��[����z�M���܂���<br>���M�ɂ����������� $search_time$more");
        }
    }
    exit;
}


}


sub csvupload_fork
{
	unless( $method ){
		&format_pro( $process );
		&error('�V�X�e���G���[', '������Ă��Ȃ�����ł��B');
	}
	local( $id, $filename, $session ) = &upload_prop( \@errors );
	
	UPFORK: {
		if( $pid = fork ) {
			my $message = "�u�y���[���v�o�^����ă��[���z�M���J�n���܂����B!!\n";
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
			# �v���Z�X���������鎞�́A���Ԃ�u���čă`�������W�B
			sleep 5;
			redo UPFORK;
		} else {
			# fork�g�p�s�T�[�o�[�B
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
