#!/usr/bin/perl

#---------------------------------------
# �y���[��pro
#
# ���[�U�o�^��pCGI�t�@�C�� apply.cgi
# v 2.4
#---------------------------------------
require '../lib/Pub.pl';
require '../lib/System.pl';
require "${'myroot'}lib/cgi_lib.pl";
require "${'myroot'}lib/jcode.pl";
require "${'myroot'}lib/composition.pl";

local @codes;
local $code;
&my_method_ck();

if( $param{'U'} ne '' ){
	&Click'pickup( 1 );
	&Click'forwarding();
	exit;
}

&Pub'Server();

# �����R�[�h�ϊ��p
$CODE;
$VCODE;
$utf;
$jcodeconvert;
$jcodegetcode;

if ( $mode eq 'guest' ) { &reguest(); }
elsif ( $mode eq 'renew' ) { &renewguest(); }
elsif ( $mode eq 'cancel' ) { &renewguest(); }
&print_error('�G���[���������܂���', '���ڂ̃A�N�Z�X<br>��������<br>�t�H�[��������ɓ\��t�����Ă��Ȃ��ׁA�G���[���������܂����B<br><br>�\��t�����t�H�[������A�N�Z�X���Ă��̉�ʂ��\�������ꍇ�́A�ēx�\��t�����t�H�[���ɊԈႢ���Ȃ����m�F���Ă��������B', 0, 'err');

#------------------------------------------------------#
# ���[�U�[�o�^                                         #
#------------------------------------------------------#
sub reguest {
	
	local $id = $param{'id'} - 0;
	
	# ���M�ςݒZ�kURL���擾
	my $forward = &Click'getForward_url();
	
	my $date = time;
	my $lockfull = &lock();
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">�V�X�e���G���[</font>', "�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V������[606]�ɐݒ肳��Ă��邩<br>���m�F���Ă�������", 0, 'err');
		exit;
	}
	local @line;
	my $csvpath;
	my $queuepath;
	my $logpath;
	my $ra_conf;
	my $tag_data;
	while( <PLAN> ) {
		chomp;
		@line = split(/\t/);
		if ( $line[0] eq $id ) {
			$csvpath = "$myroot$data_dir$csv_dir$line[6]";
			$queuepath = "$myroot$data_dir$queue_dir$line[7]";
			$logpath = "$myroot$data_dir$log_dir$line[8]";
			$utf = $line[60]-0;
			$ra_conf = $line[77] -0; # �Ǘ��Ғʒm��p�{�����p�t���O
			$tag_data = $line[82];
			&Pub'ssl($line[83]);
			last;
		}
	}
	close(PLAN);
	
	my $mobile = &Jcode( $utf );
	
	if ( !$line[37] ) {
		&rename_unlock( $lockfull );
		&print_error('�o�^�ł��܂���', '��ϐ\���󂠂�܂���<br>���݁A�\�����݂��~���Ă��܂��B', 0, 'err' );
	}
	
	#---------------------------#
	# �]���p�^�O�擾            #
	#---------------------------#
	my( $urlTag, $other ) = &Click'roadTag( $tag_data );
	
	my( $step, $dates ) = split(/<>/, $line[36] );
	my $n = 2;
	my %stepConf;
	foreach( split(/,/, $step ) ){
		my( $inter, $config, $code ) = split(/\//);
		$stepConf{$n} = $config -0;
		$uniq = $code if( $n == $target );
		$n++;
	}
	
	#--------------------------------#
	# �����̓o�^�҃f�[�^����ID���擾 #
	#--------------------------------#
	my $index;
	unless ( $csvpath ) {
		&rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">�V�X�e���G���[</font>', "�Y������f�[�^������܂���B", 0, 'err' );
		exit;
	}
	unless ( open(CSV, "$csvpath" ) ) {
		if ( -e $csvpath ) {
			&rename_unlock( $lockfull );
			&print_error('<font color="#CC0000">�V�X�e���G���[</font>', "�t�@�C�����J���܂���<br>$csvpath�̃p�[�~�b�V�������m�F���Ă��������B", 0, 'err' );
			exit;
		}
		unless ( open(CSV, ">>$csvpath") ) {
			&rename_unlock( $lockfull );
			&print_error('<font color="#CC0000">�V�X�e���G���[</font>', "���[�U�[�o�^���ł��܂���<br>$csvpath�̃p�[�~�b�V������[606]�ɐ������ݒ肳��Ă��邩�m�F���Ă��������B", 0, 'err' );
			exit;
		}
		$index = 0;
	}else {
		while( <CSV> ) {
			chomp;
			my ( $id, $mail ) = ( split(/\t/) )[0, 5];
			if ( !$line[42] && $param{'mail'} eq $mail ) {
				&rename_unlock( $lockfull );
				&print_error("���̓G���[", '����̃��[���A�h���X���o�^����Ă��܂��B', 0, 'err' );
				exit;
			}
			$index = $id if( $index < $id );
		}
	}
	close(CSV);
	$index++;
	
	#--------------------#
	# ���͒l�̎擾�ƌ��� #
	#--------------------#
	my @par;    # ���͒l�iCSV�`�����j
	local $registform; # ���͊m�F�pinput�^�O
	
	# ���ڔԍ� �t�H�[���ݒ�
	%rFORM = &Ctm'regulation_dataline();
	
	# ���ڔԍ� �o�^�ҏ��CSV�ԍ�
	%rCSV = &Ctm'regulation_csvline();
	
	# ���ڕ\����
	my @names = @Ctm'names;
	
	# �\����On
	my @SortOn;
	# �\����Off
	my @SortOff;
	
	my @sort;
	for ( my $i=1; $i<@names; $i++ ) {
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		
		my $sort = ( split(/<>/, $line[$r_num]) )[3];
		if( $sort > 0 ){
			$SortOn[$sort] = $names[$i];
		}else{
			push @SortOff, $names[$i];
		}
	}
	push @sort, @SortOn;
	push @sort, @SortOff;
	
	for ( my $i=0; $i<@sort; $i++ ) {
		next if( $sort[$i] eq '' );
		my $r_name = $sort[$i]->{'name'};
		my $r_val  = $sort[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		my $indata = '';
		if ( ( split(/<>/, $line[$r_num]) )[0] ) {
			
			
			# �����ʁi�������ʃt���O�폜 v2.2���o�^���̂ݐݒ���Q�Ɓj
			if( $r_name eq 'name'  && !defined $param{'reged'}){
				my $_name1 = &deltag( $param{'_name1'} );
				my $_name2 = &deltag( $param{'_name2'} );
				$indata = ($_name1 ne '' && $_name2 ne '')? $_name1 . $_name2: '';
			}
			if( $r_name eq '_name'  && !defined $param{'reged'}){
				my $_name1 = &deltag( $param{'_kana1'} );
				my $_name2 = &deltag( $param{'_kana2'} );
				$indata = ($_name1 ne '' && $_name2 ne '')? $_name1 . $_name2: '';
			}
			$indata   = &deltag( $param{$r_name} ) if( $indata eq '' );
			$jcodeconvert->(\$indata, 'sjis', $CODE );
			&jcode'h2z_sjis(\$indata);
			
			local $confdata = &the_text($indata);
			$jcodeconvert->(\$confdata, $VCODE, 'sjis' );
			
			$$r_name = $confdata;
			
			if ( (split(/<>/,$line[$r_num]))[2]  || $r_name eq 'mail' || $r_name eq '_mail' ) {
				if ( $r_name eq 'mail' ) {
					if (&chk_email($indata) ) {
						&rename_unlock( $lockfull );
						&print_error( "���̓G���[", '���[���A�h���X�̌`��������������܂���B', 0, 'err');
						exit;
					}
				}elsif( $r_name eq '_mail' ) {
					
					# ���[���A�h���X�m�F
					if( $param{'mail'} ne $param{'_mail'} ){
						&rename_unlock( $lockfull );
						&print_error( "���̓G���[", '���[���A�h���X�̓��͂���v���܂���B', 0, 'err');
						exit;
					}
					
				}else {
					if ( $indata eq '' ) {
						my $mes = ( (split(/<>/,$line[$r_num]))[1] )? &deltag( (split(/<>/,$line[$r_num]))[1] ): $r_val;
						&rename_unlock( $lockfull );
						&print_error('���̓G���[', "[ $mes ] �ɓ��͂��Ă��������B", 0, 'err');
						exit;
					}
			 	}
				
			}
			
			# �m�F��ʗp�f�[�^
			if ( $line[41] ) {
				$registform .= qq|<input type="hidden" name="$r_name" value="$indata">\n|;
				
			}
		}
		$par[$rCSV{$r_name}] = &the_text($indata);
		$indata='';
	}
	
	# ��t����
	if ( $line[38] ) {
		foreach ( (split(/,/, $line[38])) ) {
			if ( index($par[5], $_) >= 0 ) {
				&rename_unlock( $lockfull );
				&print_error( '���̓G���[','�o�^�ł��܂���B<br>�����͂̃��[���A�h���X�͓o�^���󂯕t���Ă���܂���B', 0, 'err');
				exit;
			}
		}
	}
	
	#-------------------------------#
	# ���͊m�F�y�[�W                #
	#-------------------------------#
	if ( $line[41] && !defined $param{'reged'} ) {
		&rename_unlock( $lockfull );
		if( &cMobile() ){
			$registform .= qq|<input type="hidden" name="m_prop" value="id:$id,md:guest,cd:����,mbl:1,reged:1">\n|;
		}else{
			$registform .= qq|<input type="hidden" name="reged" value="1">\n|;
			$registform .= qq|<input type="hidden" name="cd" value="����">\n|;
		}
		if( $VCODE eq 'utf8' ){
			$jcodeconvert->(\$registtable, 'utf8', 'sjis');
			$jcodeconvert->(\$registform, 'utf8', 'sjis');
		}
		local $submit = 'reged';
		
		&print_error('���͊m�F', '', '', 'conf');
		exit;
	}
	
	$index = sprintf("%05d", $index);
	$userID = $index;
	my $sk = ( split(/,/, $line[35]) )[1];
	my $check = ($sk)? '': 0;
	#unshift @par, $index;
	#splice( @par, 19, 0, $date );  # �o�^���i�b�j
	#splice( @par, 20, 0, $check ); # �ŏI�z�M��
	#splice( @par, 21, 0, $date );  # �ŏI�z�M���i�b�j
	$par[19] = &the_text($date);
	$par[20] = &the_text($check);
	$par[21] = &the_text($date);
	$par[0]  = $index;
	
	$par[3] = $par[37] . $par[39] if( $par[37] ne '' || $par[39] ne '' ); # �����O�f�[�^�̘A��
	$par[4] = $par[38] . $par[40] if( $par[38] ne '' || $par[40] ne '' ); # �����O�f�[�^�̘A��
	
	if( $stepConf{'2'} ){
		$par[52] = 1;
	}
	
	my $line =  join("\t", @par) . "\n";
	# �ȈՃ^�O�}���p�ɏC��
	#splice( @par, 19, 3 );
	my $senderror;
	if ( !$sk || $line[40] ) {
		# �o�^���[���̑��M
		my $rh_body = &get_body( $queuepath );
		$line[9] =~ s/<br>/\n/gi;
		$line[10] =~ s/<br>/\n/gi;
		$line[11] =~ s/<br>/\n/gi;
		
		local ( $subject, $message ) = &make_send_body( 0, $rh_body, $line[9], $line[10], $line[11] );
		# �]���^�O�ϊ�
		my $unic = $id. '-0';
		my $forward_urls;
		($message, $forward_urls) = &Click'analyTag($par[0], $message, $urlTag, $unic, $forward);
		
		my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
        $subject = &include( \@par, $subject );
		$message = &include( \@par, $message, $jis );
		if ( !$sk ) {
			$senderror = &send( $line[4], $line[3], $par[5], $subject, $message );
			# �z�M���O�ɒǉ�
			unless ( $senderror ) {
				open(LOG, ">>$logpath");
				print LOG "$par[0]\t$par[5]\t$par[3]\t$date\t0\t$subject\n";
				close(LOG);
			}else{
				&rename_unlock( $lockfull );
				&print_error('<font color="#CC0000">�V�X�e���G���[</font>','�o�^�ł��܂���B<br>���[�����M�v���O��������~���Ă��邩�A�w��Ɍ�肪���邽��<br>���[�������M�ł��܂���ł����B<br>�Ǘ��҂ɂ��⍇�����������B', 0, 'err');
			}
			# �A�N�Z�X�W�v�p�f�[�^����
			&Click'setForward_t( $forward_urls, $unic );
		}
		# �Ǘ��҈��֑��M
		if ( $line[40] ) {
			local %ra;
			$ra{'flag'} = 0;
			if( $ra_conf ){
				local ( $ra_subject, $ra_message ) = &make_send_body( 'ra', $rh_body, $line[9], $line[10], $line[11] );
				my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
        		$subject = &include( \@par, $ra_subject );
				$message = &include( \@par, $ra_message, $jis );
				$ra{'flag'} = 1;
				$ra{'addr'} = $par[5];
			}
			&send( $line[4], $line[3], $line[5], $subject, $message, '', {%ra} );
		}
	}
	
	#-------#
	# �ǉ�  #
	#-------#
	my $tmp = $myroot. $data_dir. $csv_dir. 'TMP-'. $$. time. '.cgi';
	open(CSV, "<$csvpath");
	open(TMP, ">$tmp");
	while(<CSV>){
		print TMP $_;
	}
	print TMP $line;
	close(CSV);
	close(TMP);
	chmod 0606, $tmp;
	rename $tmp, $csvpath;
	&rename_unlock( $lockfull );
	
	#----------------------------------#
	# �܂��܂��o�^                     #
	#----------------------------------#
	&Magu::Magumagu( $par[5] );
	
	# ���_�C���N�g
	if ( !$mobile && $line[12] && !$line[39] ) {
		my $href = &Pub'setHttp( $line[12], $line[78], 'all' );
		print "Location: $href", "\n\n";
		exit;
	}
	my $url = qq|<a href="http://$line[12]"><font color="#0000FF">�߂�</font></a>| if( $line[12] );
	&print_error('�o�^���������܂���', '', $url, 'end');
	exit;
	
}
#------------------------------------------------------#
# ���[�U�[�̕ύX�A����                                 #
#------------------------------------------------------#
sub renewguest {
	local $utf_error;
    local $id = $param{'id'} - 0;
    my $mail = $param{'mail'};
    my $nmail = $param{'nmail'};
    
	my $number;
	my $fnum;
	my $mes;
	my $target;
	my $turl;
	my $http_index;
	my $conf;
	if ($mode eq 'renew') {
		$number = 33;
		$fnum = 2;
		$target = 'r';
		$turl = 13;
		$http_index = 79;
		$conf = 'renew';
		# $mes = '���[���A�h���X��ύX���܂���';
	}elsif ($mode eq 'cancel') {
		$number = 34;
		$fnum = 3;
		$target = 'c';
		$turl = 14;
		$http_index = 80;
		$conf = 'delete';
		# $mes = '�o�^���������܂���';
	}
	my $lockfull = &lock();
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
        &rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">�V�X�e���G���[</font>', "�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
    my @line;
    my $csvpath;
    my $queuepath;
    my $logpath;
    my $sendck; # �������M�m�F
    my $formck; # ID�̓��͕K�{�m�F
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
			&Pub'ssl($line[83]);
            last;
        }
    }
    close(PLAN);
	$utf = $line[60];
	my $mobile = &Jcode( $utf );
	
	if ( &chk_email($mail) || ($mode eq 'renew' && &chk_email($nmail)) ) {
        &rename_unlock( $lockfull );
		&print_error('���̓G���[', "���[���A�h���X�̌`��������������܂���B");
        exit;
    }
	
    #--------------------------------#
	# �����̓o�^�҃f�[�^����ID���擾 #
	#--------------------------------#
    my $index;
    unless ( $csvpath ) {
        &rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">�V�X�e���G���[</font>','�Y������f�[�^������܂���B');
		exit;
	}
    unless ( open(CSV, "$csvpath") ) {
        &rename_unlock( $lockfull );
        &print_error('<font color="#CC0000">�V�X�e���G���[</font>', "$csvpath���J���܂���B");
		exit;
	}
    my $tmp = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
    unless ( open(TMP, ">$tmp") ) {
        &rename_unlock( $lockfull );
		&print_error('<font color="#CC0000">�V�X�e���G���[</font>',"�e���|�����[�t�@�C�����J���܂���<br>$csv_dir�̃p�[�~�b�V�������m�F���Ă��������B");
		exit;
	}
	my $flag  = 0;
	my $agree = 0;
	my @csvs;
	my %Email;
	while( <CSV> ) {
		chomp;
		my @csv = split(/\t/);
		$csv[0] = sprintf( "%05d", $csv[0] );
		if ( $mail eq $csv[5] ) {
			$flag = 1;
			if ( !$formck || $csv[0] eq $userid ) {
				$agree = 1;
				if ( $mode eq 'renew' ) {
					$csv[5] = $nmail;
					$_ = join("\t", @csv);
					@csvs = @csv;
				} else {
					@csvs = @csv;
					next;
				}
			}
		}else{
			$Email{$csv[5]} = 1;
		}
		print TMP "$_\n";
	}
	close(TMP);
	close(CSV);
	if ( !$flag ) {
		unlink $tmp;
		&rename_unlock( $lockfull );
		&print_error('���̓G���[', "���[���A�h���X����v���܂���B");
	}
	if ( $formck && !$agree ) {
		unlink $tmp;
		&rename_unlock( $lockfull );
		&print_error('���̓G���[', "ID����v���܂���B");
	}
	if( !$line[42] && $Email{$nmail} ){
		unlink $tmp;
		&rename_unlock( $lockfull );
		&print_error('���̓G���[', "���łɓ���̃��[���A�h���X���o�^����Ă��܂��B");
	}
	# �ȈՃ^�O�}���p�ɏC��
	#splice( @csvs, 19, 3 );
    my $senderror;
    unless ( $sendck ) {
        # �ύX�A�������[���̑��M
        my $rh_body = &get_body( $queuepath );
        $line[9] =~ s/<br>/\n/gi;
        $line[10] =~ s/<br>/\n/gi;
        $line[11] =~ s/<br>/\n/gi;
        local ( $subject, $message ) = &make_send_body( $target, $rh_body, $line[9], $line[10], $line[11] );
		my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
        $subject = &include( \@csvs, $subject );
		$message = &include( \@csvs, $message, $jis );
        $senderror = &send( $line[4], $line[3], $csvs[5], $subject, $message );
        # �z�M���O�ɒǉ�
        my $now = time;
        unless ( $senderror ) {
            open(LOG, ">>$logpath");
            print LOG "$csvs[0]\t$csvs[5]\t$csvs[3]\t$now\t$target\t$subject\n";
            close(LOG);
        }else{
            &rename_unlock( $lockfull );
            &print_error('<font color="#CC0000">�V�X�e���G���[</font>', '�o�^�ł��܂���');
        }
    }
	chmod 0606, $tmp;
    rename $tmp, $csvpath;
    &rename_unlock( $lockfull );
    # ���_�C���N�g
	my $redirect_url = &Pub'setHttp( $line[$turl], $line[$http_index], 'all' );
	
    if ( !$mobile && $line[$turl] && !$line[39] ) {
        print "Location: $redirect_url", "\n\n";
        exit;
    }
    my $url = qq|<a href="$redirect_url"><font color="#0000FF">�߂�</font></a>| if( $line[$turl] );
    &print_error('', '', $url, $conf);
    exit;
}

# ��ʕ\��
sub print_error {
    local ( $subject, $message, $_url, $type ) = @_;
	
	$type = 'err' if( $type eq '' );
	
	if( $jcodeconvert eq '' ){
		($jcodeconvert, $jcodegetcode ) = &jcode_rap();
	}
	
	my $mobile = &cMobile();
	
	# �\�[�X���擾
	local $array_source = &Ctm'find( $id, $type, $utf, $mobile );
	# <%registtable%>�������擾
	local $source_table = &Ctm'_table( [@line], '',$mobile ) if( $type eq 'conf' );
	local $url = $_url if( $type ne 'conf' );
	
	if( $VCODE eq 'utf8' ){
		$jcodeconvert->(\$subject, 'utf8', 'sjis' );
		$jcodeconvert->(\$message, 'utf8', 'sjis');
		$jcodeconvert->(\$url, 'utf8', 'sjis');
		$jcodeconvert->(\$source_table, 'utf8', 'sjis');
	}
    
	local $meta;
	my @source;
	foreach( @$array_source ){
		local $line = $_;
		if( $VCODE eq 'utf8' ){
			$meta = qq|<meta http-equiv="Content-Type" content="text/html; charset=utf-8">|;
			$jcodeconvert->(\$line, 'utf8');
			
		}else{
			$meta = qq|<meta http-equiv="Content-Type" content="text/html; charset=shift_jis">|;
			$jcodeconvert->(\$line, 'sjis');
		}
		
		# <%registtable%>��ϊ�
		$line =~ s/<%registtable%>/$source_table/;
		
		push @source, $line;
	}
	
	if( $type eq 'end' ){
		$id = $userID;
	}
	
    my $body;
	foreach( @source ) {
		local $line = $_;
		$line =~ s/(<\s*meta.*http-equiv.*charset.*>)/$meta/i;
		$_ = $line;
		while( ( $parameter ) = ( /<%([^<>\%]+)%>/oi ) ) {
			s//$$parameter/;
		}
        $body .= $_;
    }
	my $length = length $body;
	print "Content-type: text/html", "\n";
	print "Content-length: $length", "\n" if( $mobile );
	print "\n";
	print $body;
    exit;
}

#-----------------------#
# ���{��ϊ��֐��̎w��  #
#-----------------------#
sub jcode_rap {
	my( $utf ) = @_;
	
	if( $utf ){
		eval 'use Jcode;';
		unless( $@ ){
			return \&Jcode'convert, sub{ $str = shift; my($code, $len )= &Jcode'getcode($str); return $code;};
		}
	}
	return \&jcode'convert, sub{ $str = shift; my $code = &jcode'getcode(\$str); return $code;};
}

BEGIN {
	push( @INC, "../lib/Jcode" );
}

sub my_method_ck{

	my($all);
	unless($ENV{'REQUEST_METHOD'} eq 'POST'){
		$all= $ENV{'QUERY_STRING'};
		&get_param($all);
	}else{
		if ( $ENV{'CONTENT_TYPE'} =~ m|multipart/form-data; boundary=([^\r\n]*)$|io ){
			&get_multipart_params();
		}else{
			read(STDIN, $all, $ENV{'CONTENT_LENGTH'});
			&my_get_param($all);
		}
	}
	# �g�їp�Ƀp�����[�^���敪��
	if( defined $param{'m_prop'} ){
		my @value = split(/,/, $param{'m_prop'} );
		foreach( @value ){
			my( $key, $val ) = split(/:/);
			$param{$key} = $val;
		}
	}
	$mode= &delspace($param{'md'});
}

sub my_get_param{
    local($alldata) = @_;
    local($data, $key, $val);
    foreach $data (split(/&/, $alldata)){
        ($key, $val) = split(/=/, $data);
		$key =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack('C',hex($1))/eg;
        $val =~ tr/+/ /;
        $val =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack('C',hex($1))/eg;
        $val =~ s/\t//g;
        $param{$key} = $val;
    }
	
}

# �}���`�t�H�[������̃p�����[�^�̎擾
sub my_get_multipart_params{
    my($delim,$id,$value,$filename,$mimetype,$size);
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

sub my_replace
{
	my $code = $jcodegetcode->($param{'cd'}) if( $param{'cd'} ne '' );
	my @keys = keys %param;
	foreach my $key ( @keys ){
		local $val = $param{$key};
		if( $code ne '' ){
			$jcodeconvert->(\$val, 'sjis', $code);
			
		}else{
			$jcodeconvert->(\$val, 'sjis');
		}
		$param{$key} = $val;
	}
}
sub Jcode
{
	my( $utf ) = @_;
	#my $mobile = &cAgent();
	my $mobile = &cMobile();
	# �����R�[�h�ϊ��p
	my $convUTF = ( $utf )? 1: 0;
	($jcodeconvert, $jcodegetcode ) = &jcode_rap( $convUTF );
	
	$CODE = $jcodegetcode->($param{'cd'}) if( $param{'cd'} ne '' );
	if( $mobile && $utf ){
		$VCODE = ( $CODE ne 'utf8' )? 'sjis': $CODE;
	}elsif( $mobile && !$utf ){
		$VCODE = 'sjis';
	}elsif( $utf ){
		$VCODE = 'utf8';
	}else{
		$VCODE = 'sjis';
	}
	
	return $mobile;
}


# ���p���Ȃ�
sub cAgent
{
	my $mobile = 0;
	#���[�U�[�G�[�W�F���g�݂̂Ŕ��ʂ���ꍇ
	if($ENV{'HTTP_USER_AGENT'} =~ /^DoCoMo/){
		$mobile = 1;
	}elsif($ENV{'HTTP_USER_AGENT'} =~ /^J-PHONE|^Vodafone|^SoftBank|^Semulator/){
		$softbank = 1;
		$mobile = 1;
	}elsif($ENV{'HTTP_USER_AGENT'} =~ /^UP.Browser|^KDDI/){
		$mobile = 1;
	}
	return $mobile;
}
sub cMobile
{
	if( defined $param{'mbl'} ){
		return 1;
	}
	return 0;
}
