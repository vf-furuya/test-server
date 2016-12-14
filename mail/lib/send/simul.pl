
package Simul;

#--------------------------------------------
# �y���[��pro
# ��ă��[�����M�֘A�֐��Q
# ver2.4
#--------------------------------------------

# �݊����`�F�b�N
&compatibility();

sub running
{
	my $chk = shift;
	my $hash_path = &get_path();
	my $hash_rule = &get_send_rule();
	
	# �z�M���̏ꍇ
	if( -e $hash_path->{'control'} ){
		
		my $method = $hash_rule->{'method'} - 0;
		if( $method > 0 ){
			my $now = time;
			my $date = ( stat($hash_path->{'control'}) )[9];
			# �Ō�̍X�V����5���ȓ��ł���Δz�M��
			if( $date + (60*5) > $now ){
				return 0 if( $chk );
				&disp_background(0, 0, $hash_rule );
			}
			# ���M�t���O
			&make_flag( $hash_path->{'flag'}, 0 );
			# �G���[���O�֒ǉ�
			&print_errlog( $date );
			return 1 if( $chk );
			&disp_background( 1, 1, $hash_rule );
		}else{
			return 0 if( $chk );
			&disp_manual( 2, $hash_rule );
		}
	}
}


sub get_method
{
	my $path = $main'myroot . $main'data_dir . $main'methodtxt;
	unless ( open(MET, $path) ) {
		&error('�V�X�e���G���[', '���M�`���f�[�^�t�@�C�����J���܂���');
	}
	my %METHOD;
	while( <MET> ) {
		chomp;
		my ( $name, $val ) = split(/\t/);
		$METHOD{$name} = $val;
	}
	close(MET);
	
	$METHOD{'each'}      = 100 if($METHOD{'each'} <= 0);
	$METHOD{'sleep'}     = 30 if($METHOD{'sleep'} <= 0);
	$METHOD{'partition'} = 50 if($METHOD{'partition'} <= 0);
	
	return \%METHOD;
}


sub make_config
{
	my $action = shift;
	my $hash_path = &get_path();
	my $hash_plan = &get_plan();
	my $method = $main'param{'method'} - 0;
	
	# ���j�[�NID���`�F�b�N
	open( UNIQ, "<$hash_path->{'uniq'}" );
	my $uniq = <UNIQ>;
	close(UNIQ);
	
	if( $uniq eq $main'param{'uniq'} ){
		&main'make_plan_page( 'plan', 'mail' );
		exit;
	}
	my $dir = &compatibility();
	my $tmp = $dir. 'U-'. $$. time. '.cgi';
	open( UNIQ, ">$tmp" );
	print UNIQ $main'param{'uniq'};
	close(UNIQ);
	chmod 0606, $tmp;
	rename $tmp, $hash_path->{'uniq'};
	
	
	# �z�M���[����ݒ�
	&make_rule( $hash_path->{'rule'}, $hash_plan );
	
	# �{����ݒ�
	&make_mail( $hash_path->{'mail'}, $hash_plan );
	
	# �z�M���X�g��ݒ�
	&make_list( $hash_path->{'list'}, $action );
	
	# �z�M����t�@�C���̗L������ON�ɐݒ�
	&make_control( $hash_path->{'control'}, 'default' );
	
	# ���M�t���O
	&make_flag( $hash_path->{'flag'}, 0 );
	
	# ��ʑJ��
	if( $method > 0 ){
		# �o�b�N�O���E���h�z�M
		&disp_background( 1 );
	}else{
		# �蓮�z�M(��x�����z�M�����s)
		&make_flag( $hash_path->{'flag'}, 1 );
		&send_manual();
	}
}

sub make_rule
{
	my( $path, $hash_plan ) = @_;
	my $method = $main'param{'method'} - 0;
	my $id = $main'param{'id'} - 0;
	my $start = time;
	my $subject = &main'_deltag( $main'param{'title'} );
	
	my $dir = &compatibility();
	my $tmp = $dir. 'R-'. $$. time. '.cgi';
	open( RULE, ">$tmp" );
	print RULE "$method\n";
	print RULE "$id\n";
	print RULE "$hash_plan->{'plan_name'}\n";
	print RULE "$start\n";
	print RULE "$subject\n";
	print RULE "$hash_plan->{'admin'}\n";
	print RULE "$main'param{'uniq'}\n";
	close(RULE);
	chmod 0606, $tmp;
	rename $tmp, $path;
}

sub make_mail
{
	my( $path, $hash_plan ) = @_;
	
	local $subject = &main'_deltag( $main'param{'title'} );
	local $message;
	$message .= $hash_plan->{'header'} . "\n" if ($main'param{'header'} ne '');
	$message .= &main'_deltag( $main'param{'body'} ) . "\n";
	$message .= $hash_plan->{'cancel'} . "\n" if ($main'param{'cancel'} ne '');
	$message .= "\n" . $hash_plan->{'footer'} if ($main'param{'footer'} ne '');
	
	$message =~ s/<br>/\n/ig;
	
	my $name = $hash_plan->{'name'};
	my $from = $hash_plan->{'from'};
	
	# ------------------   ���b�Z�[�W�t�H�[�}�b�g   ---------------
	my $return  = $from;
	$from       = qq| <$from>|;
	if( $name ne '' ){
		$name =~ s/&lt;/</gi;
		$name =~ s/&gt;/>/gi;
		$name =~ s/&quot;/"/gi;
		$name = &main'mail64encode( $name );
	}

	# ���[�U�̃����[�gIP�A�h���X
	$remote_host_name   = $ENV{'REMOTE_HOST'};
	$remote_addr = $ENV{'REMOTE_ADDR'};
	$host_addr   = $ENV{'HTTP_X_FORWARDED_FOR'};

	local $data = <<"END";
Return-Path: <$return>
From: $name$from
Reply-to: $return
To: <%mail%>
<%subject%>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Mailer: $remote_host_name($remote_addr:$host_addr)

$message
END
#-------------------------------------------------------------
	&jcode'sjis2jis( \$data, 'z' );
	
	my $dir = &compatibility();
	my $tmp = $dir. 'M-'. $$. time. '.cgi';
	open( BODY, ">$tmp" );
	print BODY $data;
	close(BODY);
	chmod 0606, $tmp;
	rename $tmp, $path;
}

sub make_list
{
	my( $path, $action ) = @_;
	
	# �����w��
	if( $action eq 'cdn' ){
		my( $cdn_sid, $cdn_filepath ) = &cdn_session();
		rename $cdn_filepath, $path;
		return;
	}
	
	my $all = $main'param{'all'} - 0;
	my $id = $main'param{'id'} - 0;
	my @csvs = &main'get_csvdata( $id );
	
	my $sendid = 1;
	
	my %Email;
	my $dir = &compatibility();
	my $tmp = $dir. 'L-'. $$. time. '.cgi';
	open( LIST, ">$tmp" );
	foreach( @csvs ){
		chomp;
		my @csv = split(/\t/);
		my $check = $main'param{"sm$csv[0]"};
		
		# ���X�g�ɓo�^�ς�
		next if( $Email{$csv[5]} );
		$Email{$csv[5]} = 1;
		
		if( $all == 1 ){
			next if( $check <= 0);
		}elsif( $all == 2 ){
			next if( $check > 0 );
		}
		unshift @csv, $id;
		unshift @csv, $sendid;
		
		my $line = join( "\t", @csv );
		print LIST "$line\n";
		$sendid++;
	}
	close(LIST);
	chmod 0606, $tmp;
	rename $tmp, $path;
}

sub make_control
{
	my( $path, $flag ) = @_;
	open( CTL, $path );
	my @control = <CTL>;
	close(CTL);
	
	if( $flag eq 'default' ){
		$control[0] = "start\n";
		$control[1] = "0\n";
	}else{
		$control[0] = "running\n";
		$control[1] = "$flag\n";
	}
	
	my $dir = &compatibility();
	my $tmp = $dir. 'C-'. $$. time. '.cgi';
	open(CTL, ">$tmp");
	print CTL @control;
	close(CTL);
	chmod 0606, $tmp;
	rename $tmp, $path;
}

sub make_flag
{
	my( $path, $act ) = @_;
	if( $act ){
		unlink $path;
	}else{
		open( FLAG, ">$path" );
		close(FLAG);
	}
}

sub send_manual
{
	my $hash_rule = &get_send_rule();
	my $hash_method = &get_method();
	
	my $each = $hash_method->{'each'} - 0;
	my $subject = $hash_rule->{'subject'};
	my $admin = $hash_rule->{'admin'};
	my $uniq = $hash_rule->{'uniq'};
	my $id = $hash_rule->{'id'};
	my $flag = &send( $each, $subject, $admin, $id, $uniq );
	
	&disp_manual( $flag, $hash_rule );
}

sub send_background
{
	my $hash_path = &get_path();
	unless( -e $hash_path->{'flag'} ){
		&running();
		exit;
	}
	# �z�M�t���O���폜
	&make_flag( $hash_path->{'flag'}, 1 );
	
	my $hash_rule = &get_send_rule();
	
	# fork
	FORK: {
		if( $pid = fork ) {
			my $message = "��ă��[���z�M���J�n���܂����B\n";
			my $body = qq|<html><head><meta HTTP-EQUIV='Content-type' CONTENT='text/html; charset=shift_jis'><meta name="robots" content="none"><title>$title</title></head><body>$message</body></html>|;
			my $length = length $body;
			$| = 1;
			print "Content-type: text/html", "\n";
			print "Content-Length: $length\n\n";
			print "$body";
			close(STDOUT);
			wait;
		
		} elsif (defined $pid) {
			$| = 1;
			close(STDOUT);
			&background_roop( $hash_rule );
			exit;
		
		} elsif ( $! =~ /No more process/) {
    		# �v���Z�X���������鎞�́A���Ԃ�u���čă`�������W�B
    		sleep 5;
    		redo FORK;
		} else {
    		# fork�g�p�s�T�[�o�[�B
			exit;
		}
	}
	
}

sub background_roop
{
	my $hash_rule = shift;
	
	my $subject = $hash_rule->{'subject'};
	my $admin = $hash_rule->{'admin'};
	my $uniq = $hash_rule->{'uniq'};
	my $id = $hash_rule->{'id'};
	
	while(1){
		# �A�N�Z�X�W�v
		&Click'pickup( 1 );
		
		my $hash_method = &get_method();
		my $each = $hash_method->{'partition'} - 0;
		my $sleep = $hash_method->{'sleep'} - 0;
		my $flag = &send( $each, $subject, $admin, $id, $uniq );
		last unless( $flag );
		sleep($sleep);
	}
	&cdn_clean();
}

sub background_check
{
	# fork
	FORK: {
		if( $pid = fork ) {
			wait;
		} elsif (defined $pid) {
			exit;
		} else {
    		# fork�g�p�s�T�[�o�[�B
			&main'make_plan_page( 'plan', '', "�����p�̃T�[�o�[�ł̓o�b�N�O���E���h�z�M�����p�ł��Ȃ��\\�����������܂��B<br>�T�[�o�[��Зl�ւ��⍇�����������B", '1' );
			exit;
		}
	}
}

sub send
{
	my( $each, $subject, $admin, $id, $uniq ) = @_;
	my $hash_path = &get_path();
	
	#�r������
	my $fullpath = &main'lock();
	
	# SSL�ݒ�擾
	my $file = "$main'myroot$main'data_dir$main'log_dir$main'plan_txt";
	unless ( open(PLAN, "$file" ) ) {
    	push @errors, '�z�M�v�����t�@�C�����J���܂���';
	}
	while( <PLAN> ) {
		chomp;
		my @plan = split(/\t/);
		if( $plan[0] == $id ){
			&Pub'ssl($plan[83]);
		}
	}
	close(PLAN);
	
	#---------------------------#
	# ���M�ςݒZ�kURL���擾     #
	#---------------------------#
	my $forward = &Click'getForward_url();
	my $forward_subject = $subject;
	
	#---------------------------#
	# �]���p�^�O�擾            #
	#---------------------------#
	$main'param{'id'} = $id;
	my( $urlTag, $other ) = &Click'getTag( $id, 1 );
	
	# �]���A�h���X
	my $uniq_code = $id. '-S-'. $uniq;
	
	# �z�M�ςݑ��MID���擾
	open( CTL, $hash_path->{'control'} );
	my @ctl = <CTL>;
	close(CTL);
	
	my $sended = $ctl[1] - 0;
	my $number = 0;
	
	if( $sended <= 0 && index( $ctl[0], 'start' ) < 0 ){
		# ����G���[
		&main'rename_unlock( $fullpath );
		&main'make_plan_page( 'plan', '', "�G���[���������܂����B<br><br>�p�[�~�b�V�����ݒ�����m�F���������B", '1' );
		exit;
	}
	if( $sended > 0 && index( $ctl[0], 'running' ) < 0 ){
		# ����G���[
		&main'rename_unlock( $fullpath );
		&main'make_plan_page( 'plan', '', "�G���[���������܂����B<br><br>�p�[�~�b�V�����ݒ�����m�F���������B", '1' );
		exit;
	}
	
	# �{�����擾
	#my @mailbody;
	open( BODY, $hash_path->{'mail'} );
	my $mailbody;
	while(<BODY>){
		$mailbody .= $_;
	}
	close(BODY);
	
	# ���M�������擾
	my $op_f;
	my $hash_method = &get_method();
	if( $hash_method->{'chk_f'} ){
		$op_f = qq| -f $hash_method->{'f_mail'}|;
	}
	# �҂�����
	my $r_sleep;
	if( $hash_method->{'chk_sleep'} ){
		$r_sleep = $hash_method->{'r_sleep'};
	}
	my $n = 0;
	open(LIST, $hash_path->{'list'} );
	while(<LIST>){
		my $target_id = $_ -0;
		next if( $sended >= $target_id );
		
		$n++;
		if( $n > 1000 ){
			$n = 0;
			select(undef, undef, undef, 0.20);
		}
		
		chomp($_);
		my @csv = split(/\t/);
		my $target = shift @csv;
		my $id = shift @csv;
		
		# �]���^�O�ϊ�
		my( $sendbody, $forward_urls) = &Click'analyTag($csv[0], $mailbody, $urlTag, $uniq_code, $forward);
		
		$main'param{'id'} = $id;
		&sender( $subject, $sendbody, [@csv], $op_f, $r_sleep );
		&log( $id, [@csv], $subject );
		
		# �A�N�Z�X�W�v�p�f�[�^����
		&Click'setForward_t( $forward_urls, $uniq_code, $forward_subject );
		
		$number++;
		&make_control( $hash_path->{'control'}, $target_id );
		if( $number >= $each ){
			last;
		}
	}
	my $line = <LIST>;
	close(LIST);
	
	# �r����������
	&main'rename_unlock( $fullpath );
	
	if( $line eq '' ){
		# �z�M�I��
		$main'temdata_base[5] = $admin;
		my( $sendbody, $forward_urls) = &Click'analyTag('', $mailbody, $urlTag, $uniq_code, $forward);
		&sender( $subject, $sendbody, [@main'temdata_base], $op_f, $r_sleep, 1 );
		&finish();
		return 0;
	}
	
	return 1;
}

sub sender
{
	my( $_subject, $mailbody, $csv, $op_f, $r_sleep, $preview ) = @_;
	
	# Subject �𒲐�
	local $subject = $_subject;
	$subject = &main'include( $csv, $subject, '', $preview );
	&jcode'sjis2jis( \$subject, 'z' );
	$subject = &main'mail64encode( $subject );
	
	my $body;
	#foreach( @$mailbody ){
		#chomp;
		#local $line = $_;
		$mailbody =~ s/<%subject%>/Subject: $subject/i;
		$mailbody = &main'include( $csv, $mailbody, 1, $preview );
		#$body .= "\n";
	#}
	
	# ���M
	my $senderror=0;
	unless ( open (MAIL, "| $main'sendmail$op_f -t") ) {
		$senderror = 1;
	}
	print MAIL $mailbody;
	close(MAIL);
	
	sleep($r_sleep) if( $r_sleep );
}


sub log
{
	local( $id, $csv, $subject ) = @_;
	my $logfile = $main'myroot . $main'data_dir . $main'log_dir . 'L' . $id . '.cgi';
	my $now = time;
	
	my $userid = $csv->[0];
	my $email = $csv->[5];
	my $name  = $csv->[3];
	
	$subject = &main'include( $csv, $subject );
	
	open(LOG, ">>$logfile");
	print LOG "$userid\t$email\t$name\t$now\tS\t$subject\n";
	close(LOG);
}

sub compatibility
{
	my $dir = $main'myroot . $main'data_dir;
	my $path_dir = $dir . 'simul/';
	
	unless( -d $path_dir ){
		my $flag = mkdir $path_dir, 0707;
		if( !$flag ){
			&main'error("<strong>�f�B���N�g�����쐬�ł��܂���B","</strong><br><br><br>$dir<br><br>�̃p�[�~�b�V���������������ݒ肳��Ă��邩���m�F���������B");
		}
		chmod 0707, $dir;
	}
	if( !( -x $dir) || !( -w $dir) ){
		&main'error("�p�[�~�b�V�����G���[","<br><br><br>$dir<br><br>�̃p�[�~�b�V������[707]�ɐ������ݒ肳��Ă��邩���m�F���������B");
	}
	
	return $path_dir;
}

sub get_path
{
	my $dir = &compatibility();
	my $rule = $dir . 'rule.cgi';
	my $list = $dir . 'list.cgi';
	my $mail = $dir . 'mail.cgi';
	my $uniq = $dir . 'uniq.cgi'; # �Ō�̑��MID��ۑ�
	
	# ���M������t�@�C��
	my $control = $dir . 'control.cgi';
	my $flag = $dir . 'flag';
	
	my %PATH;
	$PATH{'rule'} = $rule;
	$PATH{'list'} = $list;
	$PATH{'mail'} = $mail;
	$PATH{'control'} = $control;
	$PATH{'flag'} = $flag;
	$PATH{'uniq'} = $uniq;
	return \%PATH;
}

sub get_plan
{
	my $id = $main'param{'id'} - 0;
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = $main'myroot . $main'data_dir . $main'log_dir . $main'plan_txt;
	
	unless ( open(PLAN, "$file" ) ) {
		&main'make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	local ( $index, $plan_name, $name, $from, $admin, $header, $cancel, $footer );
	while( <PLAN> ) {
		chomp;
		my ( $index, $_plan_name, $_name, $_from, $_admin, $_header, $_cancel, $_footer ) = ( split(/\t/) )[0, 2, 3, 4, 5, 9, 10, 11];
		if ( $index eq $id ) {
			$plan_name = $_plan_name;
			$name = $_name;
			$from = $_from;
			$admin = $_admin;
			$admin = ( split(/,/,$_admin) )[0];
			$header = $_header;
			$cancel = $_cancel;
			$footer = $_footer;
            last;
        }
    }
    if ( $admin eq '' ) {
        &main'make_plan_page( 'plan', '', "�Ǘ��҂̃��[���A�h���X���擾�ł��܂���B<br><br>�Ǘ��҃��[���A�h���X����͂��Ă�������");
    }
    close(PLAN);
	
	my %PLAN;
	$PLAN{'plan_name'} = $plan_name;
	$PLAN{'name'} = $name;
	$PLAN{'from'} = $from;
	$PLAN{'admin'} = $admin;
	$PLAN{'header'} = $header;
	$PLAN{'cancel'} = $cancel;
	$PLAN{'footer'} = $footer;
	return \%PLAN;
}

sub get_send_rule
{
	my %SEND_CONF;
	my $hash_path = &get_path();
	open( MET, $hash_path->{'rule'} );
	chomp( my @rule = <MET> );
	close(MET);
	
	$SEND_CONF{'method'} = $rule[0];
	$SEND_CONF{'id'} = $rule[1];
	$SEND_CONF{'plan_name'} = $rule[2];
	$SEND_CONF{'start'} = $rule[3];
	$SEND_CONF{'subject'} = $rule[4];
	$SEND_CONF{'admin'} = $rule[5];
	$SEND_CONF{'uniq'} = $rule[6];
	
	return \%SEND_CONF;
}

sub disp_manual
{
	my( $sended, $hash_rule ) = @_;
	my $hash_path = &get_path();
	my $hash_method = &get_method();
	my $id = $main'param{'id'} - 0;
	
	if( $sended >= 1 ){
		my $screen;
		if( $id eq $hash_rule->{'id'} ){
			if( $sended == 1 ){
			
				$screen = <<"END";
<form action="$main'indexcgi" method="POST">
���M�� $hash_method->{'each'}���𒴂������ߑ��M�����f�������ł��܂���ł����B<br>
�c�茏���𑗐M���Ă��������B
<input type="submit" value="���M����" onClick="return confir('���M���܂����H');">
<input type="hidden" name="md" value="mailsend">
<input type="hidden" name="next" value="1">
<input type="hidden" name="id" value="$id">
</form>
END

			}elsif($sended == 2 ){
				
				$screen = <<"END";
<form action="$main'indexcgi" method="POST">
�O�񂱂̃v�����ł̈�ă��[�����ɂ����āA����Ɋ������Ȃ������ׁA<br>�z�M�����f����Ă��܂��B<br>
���̃{�^���ɂ��A�z�M���ĊJ���Ă�������<br>
<input type="submit" value="���M����" onClick="return confir('���M���܂����H');">
<input type="hidden" name="md" value="mailsend">
<input type="hidden" name="next" value="1">
<input type="hidden" name="id" value="$id">
</form>
END
				
			}
		}else{
			$screen = <<"END";
<font color="#FF0000">���Ɉ�ă��[�����z�M���ł�</font><br><br>
<table>
<tr><td colspan="2"><strong>�� �z�M���</strong></td></tr>
<tr><td width="50">�v�����F</td><td width="350" align="left">$hash_rule->{'plan_name'}</td></tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr><td colspan="2">���s�ς݂̔z�M�����������Ă��������B<br>
������c��̔z�M�����s����ɂ́@<a href="$main'indexcgi\?md=mail&id=$hash_rule->{'id'}"><font color="#0000FF">������</font></a></td></tr>
</table>
END
		}
		&main'make_plan_page( 'plan', '', "$screen", '1' );
		exit;
	
	}else{
		# �����e���|�����[�t�@�C�����폜
		&cdn_clean();
		# ���M����
		&main'make_plan_page( 'plan', '', "���M���������܂���", '1' );
		exit;
	}
}

sub disp_background
{
	my( $sended, $re, $hash_rule ) = @_;
	my $smid = $hash_rule->{'id'};
	$main'param{'id'} = $smid if( $main'param{'id'} <= 0 );
	
	my $screen;
	if( $sended ){
		if( $re ){
			$re_message = qq|�T�[�o�[���׋y�ё��M�����f���Ă����ׁA<br>�ēx|;
		}
		$screen = <<"END";
<font color="#FF0000">$re_message�o�b�N�O���E���h�Ŕz�M���J�n���܂����B</font><br><br>
���̏�������́u�Ǘ���ʁv�̃����N���N���b�N�����ۂ̓��삪<br>
�d���Ȃ�ꍇ������܂��B<br> 
���̍ۂ́A������x�Y���̃����N���N���b�N���Ă��������B<br><br>
���A���[���̑��M�̓o�b�N�O���E���h�ōs���܂��̂�<br>���O�A�E�g�y�ѓd�������؂�ɂȂ��Ă�
��育�����܂���B
<img src="$main'indexcgi\?md=simul" border="0" width="1" height="1">
END
		&main'make_plan_page( 'plan', '', "$screen", '1' );
		exit;
	}
	$screen = <<"END";
<font color="#FF0000">�o�b�N�O���E���h�Ŕz�M���ł��B</font><br><br>
��ă��[���̔z�M�́A�O��̔z�M���I����������s�\\�ƂȂ�܂��̂ŁA<br>���΂炭���҂����������B
END
	&main'make_plan_page( 'plan', '', "$screen", '1' );
}

sub finish
{
	my $hash_path = &get_path();
	foreach( keys %$hash_path ){
		next if( $_ eq 'uniq' );
		my $filepath = $hash_path->{$_};
		unlink $filepath;
	}
}

sub debug
{
	print "Content-type: text/html\n\n";
	print "<html><head><title>CGI</title></head>\n";
	print "<body>\n";
	print "<br>$_[0]<br>";
	print "</body></html>\n";
	exit;
}

sub _debug
{
	my $str = shift;
	open( DG, '>>../data/simul/mailbody.txt' );
	print DG $str;
	close(DG);
	
	#&debug('OK!');
}

sub slch
{
	my $imgfile = $main'myroot . $main'image_dir . $main'imagefile;
	if( &running( 1 ) ){
		&send_background();
	}else{
		open( IMG, $imgfile );
		print "Content-type: image/gig", "\n\n";
		binmode IMG;
		while(<IMG>){
			print $_;
		}
		close(IMG);
		exit;
	}
}

sub print_errlog
{
	my $_date = shift;
	my $logfile = $main'myroot . $main'data_dir . 'errorlog.cgi';
	my $tmp = $main'myroot . $main'data_dir. 'ERR-TMP-'. $$. time. '.cgi';
	
	open( ERRTMP, ">$tmp" );
	open( ERR, "<$logfile" );
	while( <ERR> ){
		print ERRTMP $_;
	}
	
	my($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($_date+(60*60*9));
	my $date = sprintf ( "%04d/%02d/%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec );
	
	print ERR qq|$date | . '���Ɉ�ă��[���z�M�������I�����ꂽ�\��������܂��B' . qq|\n|;
	close(ERR);
	close(ERRTMP);
	eval{ chmod 0606, $tmp; };
	rename $tmp, $logfile;
}

sub cdn_form
{
	my( @line ) = @_;
	
	my $id = $main'param{'id'} -0;
	my $method = $main'param{'method'} -0;
	my( $cdn_sid, $cdn_filename ) = &cdn_session();
	
	# �t�H�[���ݒ���
	my @names = @Ctm'names;
	# ���ڔԍ� �t�H�[���ݒ�
	my %rFORM = &Ctm'regulation_dataline();
	# �ڍאݒ�
	my %detail = &MF'_get_detail_list( $id, 1 );
	
	# �\����On
	my @SortOn;
	# �\����Off
	my @SortOff;
	
	my $cdn_table;
	my $fn = 0;
	for ( my $i=1; $i<@names; $i++ ) {
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		my $prop = 'text';
		if( $i > 18 ){
			$fn++;
		}
		my $bgcolor = '#FFFFFF';
		my $form;
		if ( ( split(/<>/, $line[$r_num]) )[0] ) {
			my $inname = ( split(/<>/, $line[$r_num]) )[2];
			$inname = &main'deltag( $inname );
			my $fname = ( $inmame eq '' )? $r_val: $inname;
			my $input;
			my $select;
			my $checkbox;
			my $raido;
			if( $fn > 0 ){
				# �t���[����
				$prop = $detail{$fn}->[0];
				$select = $detail{$fn}->[1];
				$checkbox = $detail{$fn}->[2];
				$raido = $detail{$fn}->[3];
				$bgcolor = '#F4FAFF';
			}
			if( $r_name eq 'address' ){
				$input = &_cdn_ken( $r_name );
			}elsif( $r_name eq '_mail' ){
				next;
			}else{
				$input = &_cdn_detail( $prop, $r_name, $select, $checkbox, $raido );
			}
			$form = <<"END";
<tr bgcolor="$bgcolor"><td>$fname</td><td>$input</td></tr>\n
END
			my $sort = ( split(/<>/, $line[$r_num]) )[3];
			if( $sort > 0 ){
				$SortOn[$sort] = $form;
			}else{
				push @SortOff, $form;
			}
		}
	}
	
	foreach( @SortOn ){
		$cdn_table .= $_;
	}
	foreach( @SortOff ){
		$cdn_table .= $_;
	}
	
	my $_btitle = &main'deltag( $main'param{'title'} );
	my $body = &main'the_text( $main'param{'body'} );
	$body  = &main'make_text( $body );
	my $header = ($main'param{'header'})? 1: 0;
	my $cancel = ($main'param{'cancel'})? 1: 0;
	my $footer = ($main'param{'footer'})? 1: 0;
	
	
	my $main_table = <<"END";
                               <form name="f1" method="post" action="$main'indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="503"><table width="100%" border="0" cellspacing="0" cellpadding="2">
                                          <tr> 
                                            <td>���[���𑗐M����<strong>�u�o�^�ҏ��v</strong>�̏������w�肵�Ă��������B</td>
                                          </tr>
                                          <tr> 
                                            <td>�����Ƃ��Đݒ�ł���̂́A�u�o�^�p�t�H�[���v�őI������Ă���S���ڂƂȂ�܂��B</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          
                                          <tr> 
                                            <td>�w���A<strong>�u���s����v</strong>�{�^�����N���b�N���Ă�������</td>
                                          </tr>
                                          <tr> 
                                            <td><table width="100%" border="1" cellspacing="0" cellpadding="1">
                                                <tr> 
                                                  <td width="146" align="center" bgcolor="#CCCCCC">����</td>
                                                  <td width="261" align="center" bgcolor="#CCCCCC">����</td>
                                                </tr>
$cdn_table
                                              </table></td>
                                          </tr>
                                             <tr> 
                                             <td>&nbsp;</td> 
                                           </tr> 
                                          <tr> 
                                            <td align="center"><input name="md" type="hidden" id="md" value="simul_cdn_conf"> 
                                              <input name="id" type="hidden" id="id" value="$id"> 
                                              <input name="method" type="hidden" id="method" value="$method">
                                              <input name="title" type="hidden" value="$_btitle">
                                              <input name="body" type="hidden" value="$body">
                                              <input name="header" type="hidden"  value="$header">
                                              <input name="cancel" type="hidden"  value="$cancel">
                                              <input name="footer" type="hidden" value="$footer">
                                              <input name="cdn_sid" type="hidden" value="$cdn_sid">
                                              <input type="submit" value="�@���s����@" name="SUMIL" onClick="return fncOnClick();"></td>
                                          </tr>
                                        </table>
                                         <br></td>
                                    </tr>
                                  </table>
                                </form>
<SCRIPT LANGUAGE="JavaScript">
<!--
i = 0;
function fncOnClick()
{
	var ret = confir('�o�^�Ґ� ����� �w����� �������ꍇ�A�����ɕ��ׂ܂��͎��Ԃ�������ꍇ������܂��B');
	if( ret == false ){
        return false;
	}
	
	if(i==0){
		document.f1.handleEvent = "submit";
		document.f1.submit();
		document.f1.SUMIL.disabled=true;
		i++;
	}
	else {
	}
}
//-->
</SCRIPT>
END
	return $main_table;
}

sub cdn_conf
{
	my( @line ) = @_;
	
	# ���j�[�NID
	my $uniq =  crypt( $$, &main'make_salt() );
	
	
	my $id = $main'param{'id'} -0;
	my $method = $main'param{'method'} -0;
	my( $cdn_sid, $cdn_filename ) = &cdn_session();
	my( $search, $cdn_table, $hidden ) = &cdn_prop( $id, [@line] );
	
	# ����
	my $total = &cdn_search( $line[6], $search );
	
	my $submit = qq|<input type="submit" value="���M���J�n����" onClick="return confir('���M���܂����H');">| if($total > 0);
	
	my $ptitle = &main'make_text( $main'param{'title'} );
	$ptitle = &main'reInclude( $ptitle );
	$ptitle = &main'include( \@main'temdata, $ptitle, '', 1 );
	
	
	my $_btitle = &main'deltag( $main'param{'title'} );
	my $body = &main'the_text( $main'param{'body'} );
	$body  = &main'make_text( $body );
	
	# �]���ϊ�
	$pbody = &Click'prev1( $id, $main'param{'body'} );
		
	$pbody = &main'make_text( $pbody );
	$pbody = &main'reInclude( $pbody );
	$pbody = &main'include( \@main'temdata, $pbody, '', 1 );
	$pbody =~ s/\n/<br \/>/ig;
	
	# �]���ϊ�(�v���r���[�p)
	$pbody = &Click'prev2( $pbody );
	
	
	my $header  = $main'param{'header'} -0;
	my $cancel  = $main'param{'cancel'} -0;
	my $footer  = $main'param{'footer'} -0;
	
	my $pheader  = $line[9] if ($header);
	my $pcancel  = $line[10] if ($cancel);
	my $pfooter  = $line[11] if ($footer);
	
	$pheader = &main'make_text( $pheader );
	$pheader = &main'reInclude( $pheader );
	$pheader = &main'include( \@main'temdata, $pheader, '', 1 );
	
	$pcancel = &main'make_text( $pcancel );
	$pcancel = &main'reInclude( $pcancel );
	$pcancel = &main'include( \@main'temdata, $pcancel, '', 1 );
	
	$pfooter = &main'make_text( $pfooter );
	$pfooter = &main'reInclude( $pfooter );
	$pfooter = &main'include( \@main'temdata, $pfooter, '', 1 );
	
	my $main_table = <<"END";
                               <form name="f1" method="post" action="$main'indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="503"><table width="100%" border="0" cellspacing="0" cellpadding="2">
                                          <tr> 
                                            <td>�{������я��������m�F���������B</td>
                                          </tr>
                                          <tr> 
                                            <td>�{�����C������ꍇ��<strong>�u�{�����C������v</strong>���A</td>
                                          </tr>
                                          <tr> 
                                            <td>���[���𑗐M����ꍇ<strong>�u���M���J�n����v</strong>�{�^�����A</td>
                                          </tr>
                                          <tr> 
                                            <td>������ύX����ꍇ��<strong>�u������ݒ肵�����v</strong>�{�^�����A</td>
                                          </tr>
                                          <tr> 
                                            <td>�N���b�N���Ă��������B</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>$ptitle</td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$pheader</td>
                                          </tr>
                                          <tr> 
                                            <td>$pbody</td>
                                          </tr>
                                          <tr> 
                                            <td>$pcancel</td>
                                          </tr>
                                          <tr> 
                                            <td>$pfooter</td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td><table width="100%" border="1" cellspacing="0" cellpadding="1">
                                                <tr> 
                                                  <td width="146" align="center" bgcolor="#CCCCCC">����</td>
                                                  <td width="261" align="center" bgcolor="#CCCCCC">����</td>
                                                </tr>
$cdn_table
                                              </table></td>
                                          </tr>
                                             <tr> 
                                             <td>&nbsp;</td> 
                                           </tr>
                                             <tr>
                                               <td>�����Ɉ�v�����o�^�Ґ��F�@<strong><font size="4">$total</font></strong> �� </td>
                                             </tr>
                                             <tr>
                                               <td>&nbsp;</td>
                                             </tr> 
                                          <tr> 
                                            <td align="center"><input name="md" type="hidden" id="md" value="simul_cdn_set"> 
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="method" type="hidden" id="method" value="$method">
                                              <input name="title" type="hidden" id="title" value="$_btitle">
                                              <input name="body" type="hidden" id="body" value="$body">
                                              <input name="header" type="hidden" id="header" value="$header">
                                              <input name="cancel" type="hidden" id="cancel" value="$cancel">
                                              <input name="footer" type="hidden" id="footer" value="$footer">
                                              <input name="cdn_sid" type="hidden" value="$cdn_sid">
                                              <input name="uniq" type="hidden" value="$uniq">
                                              <input name="make_body" type="submit" id="make_body" value="�{�����C������"> 
$submit
                                              <input name="back" type="submit" id="back" value="������ݒ肵����"> 
$hidden
                                              </td>
                                          </tr>
                                        </table>
                                         <br></td>
                                    </tr>
                                  </table>
                                </form>
END
	return $main_table;
}

sub cdn_prop
{
	my( $id, $rline ) = @_;
	my @line = @$rline;
	
	# �t�H�[���ݒ���
	my @names = @Ctm'names;
	# ���ڔԍ� �t�H�[���ݒ�
	my %rFORM = &Ctm'regulation_dataline();
	# �ڍאݒ�
	my %detail = &MF'_get_detail_list( $id, 1 );
	
	# �o�^�ҏ��f�[�^�ԍ����擾
	my %csv = &Ctm'regulation_csvline();
	
	# �\����On
	my @SortOn;
	# �\����Off
	my @SortOff;
	
	my $cdn_table;
	my $hidden;
	my $fn = 0;
	my %search;
	for ( my $i=1; $i<@names; $i++ ) {
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		my $prop = 'text';
		# ���[���A�h���X�m�F
		if( $r_name eq '_mail' ){
			next;
		}
		# �t���[����
		if( $i > 18 ){
			$fn++;
		}
		my $bgcolor = '#FFFFFF';
		my $form;
		if ( ( split(/<>/, $line[$r_num]) )[0] ) {
			my $inname = ( split(/<>/, $line[$r_num]) )[2];
			$inname = &main'deltag( $inname );
			my $fname = ( $inmame eq '' )? $r_val: $inname;
			my $input;
			my $value = &main'deltag( $main'param{$r_name} );
			my $pvalue = ($value ne '')? $value: '---';
			if( $fn > 0 ){
				# �t���[����
				$bgcolor = '#F4FAFF';
			}
			$form .= <<"END";
<tr bgcolor="$bgcolor"><td>$fname</td><td>$pvalue&nbsp;</td></tr>\n
END
			$hidden .= qq|<input type="hidden" name="$r_name" value="$value">\n|;
			
			# �����f�[�^���K��
			if( $value ne '' ){
				my $index = $csv{$r_name};
				$search{$index} = $value ;
			}
			my $sort = ( split(/<>/, $line[$r_num]) )[3];
			if( $sort > 0 ){
				$SortOn[$sort] = $form;
			}else{
				push @SortOff, $form;
			}
		}
	}
	
	foreach( @SortOn ){
		$cdn_table .= $_;
	}
	foreach( @SortOff ){
		$cdn_table .= $_;
	}
	
	return {%search}, $cdn_table, $hidden;
}

sub cdn_set
{
	my( $cdn_sid, $cdn_filepath ) = &cdn_session();
	if( defined $main'param{'make_body'} ){
		&main'make_plan_page( 'plan', 'mail' );
		exit;
	}
	if( defined $main'param{'back'} ){
		if( -f $cdn_filepath ){
			unlink $cdn_filepath;
		}
		&main'make_plan_page( 'plan', 'simul_cdn' );
		exit;
	}
	unless( -f $cdn_filepath ){
		&main'make_plan_page( 'plan', 'simul_cdn' );
	}
	&make_config( 'cdn' );
}

sub cdn_session
{
	my $sid;
	$sid = ( $main'param{'cdn_sid'} )? $main'param{'cdn_sid'}-0: time . $$;
	my $dir = &compatibility();
	my $filename = $dir. 'CDN-'. $sid . '.cgi';
	return $sid, $filename;
}

sub cdn_clean
{
	my $limit = shift;
	my $now = time;
	my $dir = &compatibility();
	opendir DIR, $dir;
	my @file = readdir DIR;
	close(DIR);
	foreach( @file ){
		if( /^CDN-(\d+)/ ){
			my $path = $dir. $_;
			if( $limit ){
				my $date = ( stat($path) )[9];
				if( $date + (60*60*10) < $now  ){
					unlink $path;
				}
			}else{
				unlink $path;
			}
		}
	}
}

sub _cdn_detail
{
	my( $prop, $name, $select, $checkbox, $radio ) = @_;
	my $input;
	my $value = &main'deltag( $main'param{$name} );
	
	if( $prop eq 'textarea' ){
		$input = &_cdn_text( $name, $value );
	}elsif( $prop eq 'select' ){
		$input = &_cdn_select( $name, $value, $select );
	}elsif( $prop eq 'checkbox' ){
		$input = &_cdn_checkbox( $name, $value, $checkbox );
	}elsif( $prop eq 'radio' ){
		$input = &_cdn_radio( $name, $value, $radio );
	}else{
		$input = &_cdn_text( $name, $value );
	}
	return $input;
}
sub _cdn_text
{
	my( $name, $value ) = @_;
	return qq|<input type="text" name="$name" value="$value" size="40">���܂�|;
}
sub _cdn_textarea
{
	
}
sub _cdn_select
{
	my( $name, $value, $element ) = @_;
	my $select = qq|<select name="$name"><option value="">�I�����Ă�������</option>|;
	foreach( @$element ){
		my $selected = ' selected' if( $value eq $_ );
		$select .= qq|<option value="$_"$selected>$_</option>|;
	}
	$select .= qq|</select>|;
	return $select;
}
sub _cdn_checkbox
{
	my( $name, $value, $element ) = @_;
	my $checked = ' checked="checked"' if( $value eq $element->[0] );
	return  qq|<input type="checkbox" name="$name" value="$element->[0]"$checked>$element->[0]|;
}
sub _cdn_radio
{
	my( $name, $value, $element ) = @_;
	my $radio = qq|<input type="radio" name="$name" value="">�w�肵�Ȃ�<br>|;
	foreach( @$element ){
		my $checked = ' checked="checked"' if( $value eq $_ );
		$radio .= qq|<input type="radio" name="$name" value="$_"$checked>$_<br>|;
	}
	return $radio;
}
sub _cdn_ken
{
	my $name = shift;
	%Ken = (
	'1' => '�k�C��',
	'2' => '�X��',
	'3' => '��茧',
	'4' => '�{�錧',
	'5' => '�H�c��',
	'6' => '�R�`��',
	'7' => '������',
	'8' => '��錧',
	'9' => '�Ȗ،�',
	'10' => '�Q�n��',
	'11' => '��ʌ�',
	'12' => '��t��',
	'13' => '�����s',
	'14' => '�_�ސ쌧',
	'15' => '�V����',
	'16' => '�x�R��',
	'17' => '�ΐ쌧',
	'18' => '���䌧',
	'19' => '�R����',
	'20' => '���쌧',
	'21' => '�򕌌�',
	'22' => '�É���',
	'23' => '���m��',
	'24' => '�O�d��',
	'25' => '���ꌧ',
	'26' => '���s�{',
	'27' => '���{',
	'28' => '���Ɍ�',
	'29' => '�ޗǌ�',
	'30' => '�a�̎R��',
	'31' => '���挧',
	'32' => '������',
	'33' => '���R��',
	'34' => '�L����',
	'35' => '�R����',
	'36' => '������',
	'37' => '���쌧',
	'38' => '���Q��',
	'39' => '���m��',
	'40' => '������',
	'41' => '���ꌧ',
	'42' => '���茧',
	'43' => '�F�{��',
	'44' => '�啪��',
	'45' => '�{�茧',
	'46' => '��������',
	'47' => '���ꌧ'
	);
	my $value = &main'deltag($main'param{$name});
	my $input .= qq|<select name="$name"><option value="">�I�����Ă�������</option>|;
	foreach( sort keys %Ken ){
		my $ken_name = $Ken{$_};
		my $selected = ' selected' if( $value eq $ken_name );
		$input .= qq|<option value="$ken_name"$selected>$ken_name</option>|;
	}
	$input .= qq|</select>|;
	return $input;
}

sub cdn_search
{
	my( $csvfile, $search ) = @_;
	
	my $id = $main'param{'id'} -0;
	my( $cdn_sid, $cdn_filepath ) = &cdn_session();
	my $sendid = 0;
	
	if( $main'param{'rebody'} && -f $cdn_filepath ){
		open( CDN, $cdn_filepath );
		while(<CDN>){
			$sendid++;
		}
		close(CDN);
		return $sendid;
	}
	
	my $csvfilepath = $main'myroot . $main'data_dir . $main'csv_dir . $csvfile;
	open( CDN, ">$cdn_filepath" );
	open( CSV, "<$csvfilepath" );
	my %mail;
	my $count = 0;
	while(<CSV>){
		chomp;
		my @csvs = split(/\t/);
		next if( $mail{$csvs[5]} );
		my $flag = 1;
		foreach $ind ( keys %$search ){
			if( $count >= 1000 ){
				$count = 0;
				select(undef, undef, undef, 0.20);
			}
			$count++;
			my $val = $search->{$ind};
			if( index( $csvs[$ind], $val ) < 0 ){
				$flag = 0;
				last;
			}
		}
		next if( !$flag );
		$sendid++;
		$mail{$csvs[5]} = 1;
		print CDN qq|$sendid\t$id\t$_\n|;
	}
	close(CDN);
	close(CSV);
	chmod 0606, $cdn_filepath;
	
	if( $sendid <= 0 ){
		unlink $cdn_filepath;
	}
	return $sendid;
}
1;
