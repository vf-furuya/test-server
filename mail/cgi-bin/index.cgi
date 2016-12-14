#!/usr/bin/perl

#---------------------------------------------------------------------
# �y���[��pro
#
# �o�[�W����
$Version = '2.4.0.3';
#---------------------------------------------------------------------
# v2.4�ȑO�̂���config.pl��ǂݍ���Ŋe��ݒ��ێ�
&peculiar();

require '../lib/Pub.pl';
require '../lib/System.pl';
require "${'myroot'}lib/cgi_lib.pl";
require "${'myroot'}lib/jcode.pl";


&method_ck();
# �摜�\��
if( $mode eq 'img' ){
	&Pub'image();
}

# �Z�b�g�A�b�v�m�F
require "${'myroot'}lib/setup.pl";

require "${'myroot'}lib/_html/session.pl";
require "../lib/composition.pl";

&Pub'Server(1);

&Simul'slch() if( $mode eq 'slch' );
&pass_check() if ($mode eq 'ck');
#&get_cookie();
#----------------------------------------------------------------------
# �F��
#----------------------------------------------------------------------
unless( &Session'check( \&error ) ){
	if( $mode eq 'imgupload' || $mode eq 'fdetail' || $mode eq 'manual' || $mode eq 'ctm_regprev' ){
		&error('���O�C�����Ă��������B','�A�N�Z�X�̗L���������߂��܂����B<br>���萔�ł�����x���O�A�E�g���A�ēx���O�C�����Ă��������B');
		exit;
	}
	&html_pass();
}
&make_mailtag_tmp();
# �]���f�[�^�̏W�v
&Click'pickup();

if ( $mode eq 'new' )      { &make_page( 'new' ); }
elsif ( $mode eq 'list' )  { &make_page( 'list' ); }
elsif ( $mode eq 'admin' ) { &make_page( 'admin' ); }
elsif ( $mode eq 'method' ){ &make_page( 'method' ); }
elsif ( $mode eq 'help' )  { &make_page( 'help' ); }
elsif ( $mode eq 'all' )   { &make_plan_page('plan', 'all'); }
elsif ( $mode eq 'log' )   { &make_plan_page('plan', 'log'); }
elsif ( $mode eq 'pname' ) { &make_plan_page('plan', 'pname'); }
elsif ( $mode eq 'bs' )    { &make_plan_page('plan', 'bs'); }
elsif ( $mode eq 'header' ){ &make_plan_page('plan', 'header'); }
elsif ( $mode eq 'footer' ){ &make_plan_page('plan', 'footer'); }
elsif ( $mode eq 'cl' )    { &make_plan_page('plan', 'cl'); }
elsif ( $mode eq 'form1' ) { &make_plan_page('plan', 'form1'); }
elsif ( $mode eq 'form2' ) { &make_plan_page('plan', 'form2'); }
elsif ( $mode eq 'l' )     { &make_plan_page('plan', 'schedule'); }
elsif ( $mode eq 'p' )     { &make_plan_page('plan', 'preview'); }
elsif ( $mode eq 'ml' )    { &make_plan_page('plan', 'body'); }
# HTML�ҏW���
elsif ( $mode eq 'mb_html'){ &make_plan_page('plan', 'html'); }
elsif ( $mode eq 'mf1' )   { &make_plan_page('plan', 'mf1'); }
elsif ( $mode eq 'mf2' )   { &make_plan_page('plan', 'mf2'); }
elsif ( $mode eq 'mf3' )   { &make_plan_page('plan', 'mf3'); }
elsif ( $mode eq 'fdetail'){ &MF'action(); }
# �t�H�[���v���r���[
elsif ( $mode eq 'sprev' ){ &make_plan_page('plan', 'sprev'); }
# ��ʃJ�X�^�}�C�Y
elsif ( $mode eq 'ctm_regdisp' ) { &make_plan_page('plan', 'ctm_regdisp'); }
elsif ( $mode eq 'ctm_regprev' ){ &make_plan_page('plan', 'ctm_regprev'); }

elsif ( $mode eq 'g' )     {
	if( $param{'pnum'} eq '' ){
		print "Set-Cookie: raku_search=", "\n"; # Cookie������
		$all_cookies{'raku_search'} = '';  # �����v�f������
		$param{'def_search'} = 1;
	}
	&make_plan_page('plan', 'guest'); }
elsif ( $mode eq 'add' )   { &make_plan_page('plan', 'add'); }
elsif ( $mode eq 'up' )    { &make_plan_page('plan', 'up'); }
elsif ( $mode eq 'upsend' ){ &csvupload_each(); }
elsif ( $mode eq 'ref' )   { &make_plan_page('plan', 'ref'); }
elsif ( $mode eq 'mail' )  { &make_plan_page('plan', 'mail'); }
elsif ( $mode eq 'mailnext'){&make_plan_page('plan', 'mailnext');}
# ��ă��[��(�o�b�N�O���E���h)
elsif ( $mode eq 'simul')  {&Simul'send_background();}
elsif ( $mode eq 'redirect'){ &make_plan_page('plan', 'redirect');}
# ��ă��[��(�����w��)
elsif ( $mode eq 'simul_cdn_conf' ){ &make_plan_page( 'plan', 'simul_cdn_conf' ); }
elsif ( $mode eq 'simul_cdn_set' ){ &Simul'cdn_set(); }
# �폜�m�F���
elsif ( $mode eq 'confdel'){ &make_plan_page('plan', 'delete');}

elsif ( $mode eq 'resche' ){ &reschedule(); } 
elsif ( $mode eq 'body' )  { &body(); }
# HTML�̕ҏW
elsif ( $mode eq 'html' )  { &body_html(); }
elsif ( $mode eq 'htmlprev'){ &htmlprev(); }
elsif ( $mode eq 'text' )  { &renew(); }
elsif ( $mode eq 'next' )  { &regist(); }
elsif ( $mode eq 'st' )    { &sendtest(); }
#elsif ( $mode eq 'guest' ) { &reguest(); }
elsif ( $mode eq 'addguest'){ &guest(); }
#elsif ( $mode eq 'renew' ) { &renewguest(); }
#elsif ( $mode eq 'cancel' ){ &renewguest(); }
elsif ( $mode eq 'get' )   { &csv(); }
elsif ( $mode eq 'upload' ){ &upload(); }
elsif ( $mode eq 'mailsend'){ &mailsend(); }
elsif ( $mode eq 'ipchange'){ &ipchange(); }
elsif ( $mode eq 'remethod'){ &method(); }
elsif ( $mode eq 'run')     { &renew(); }
elsif ( $mode eq 'logout' ){ &logout(); }
# �摜�A�b�v���[�h
elsif ( $mode eq 'imgupload' ){ &imgupload(); }

# �܂��܂��o�^�@�\
elsif ( $mode eq 'f_magu' ){ &make_plan_page('plan', 'magu'); }
elsif ( $mode eq 'k_magu' ){ &Magu::Keep(); }

# �ݒ�t�@�C�����J
elsif ( $mode eq 'config' ){ &disp_config(); }
elsif ( $mode eq 'manual' ){ &manual(); }
# �v�����R�s�[
elsif ( $mode eq 'copy' ){ &make_plan_page('plan', 'copy'); }
elsif ( $mode eq 'make_copy' ){ &Copy'copy(); }
# �z�M�ĊJ
elsif ( $mode eq 'restart' ){ &restart(); }
# �{��CSV
elsif ( $mode eq 'down_step' ){ &down_step(); }
elsif ( $mode eq 'upload_step' ){ &upload_step(); }
# �N���b�N����
elsif ( $mode eq 'click_analy' ){ &make_plan_page( 'plan', 'click_analy' ); }
# �G���[�t�@�C�����J
elsif ( $mode eq 'error' ){ &disp_error(); }
elsif ( $mode eq 'pms' ){ &disp_pms(); }
elsif ( $mode eq 'file' ){ &getControl(); }
&make_page( 'help' );

exit;
# --------------------------------------------------------------------------------
# ���[�U�[��`�֐�
# --------------------------------------------------------------------------------

#--------------------------------------------------#
# �F��                                             #
#--------------------------------------------------#
sub pass_check {
	my $input_id = &delspace($param{'input_id'});
	my $input_pass = &delspace($param{'input_pass'});
	my $path = $myroot . $data_dir . $log_dir . $admin_txt;
	
	unless ( open(PASS, "$path" ) ) {
		&html_main("�V�X�e���G���[<br><br>$path���J���܂���");
	}
	my $id = <PASS>;
	my $pass = <PASS>;
	chomp( $id );
	chomp( $pass );
	if ( $id eq '' || $pass eq '' ) {
		unless ($defid eq $input_id && $defpass eq $input_pass) {
			&error('�F�؃G���[', "�F�؂Ɏ��s���܂���");
		}
	}else{
		unless ( $id eq $input_id && $pass eq crypt($input_pass,$pass) ) {
			&error('�F�؃G���[', "�F�؂Ɏ��s���܂���");
		}
	}
	# �t�H�[�������������O�t�@�C���̗L���m�F
	&MF'logfile_find();
	
	# ��ă��[�������I���m�F
	my $run_simul = 0;
	if( &Simul'running( 1 ) ){
		$run_simul = 1;
	}
	# ���O�C���F�؎�(Session���s)
	&Session'set($pass);
	
	# ��ď����w�胁�[���e���|�����[�t�@�C�����폜
	&Simul'cdn_clean( 1 );
	&make_page( 'help', '', '', '', $run_simul );
}

#--------------------------------------------------#
# ���O�A�E�g                                       #
#--------------------------------------------------#
sub logout {
    &Session'reset();
    &html_pass();
    exit;
}

#--------------------------------------------------#
# ���M�����̐ݒ�                                   #
#--------------------------------------------------#
sub method {
    
	my $method = $param{'method'}-0;
	my $each  = $param{'each'}-0;
	$each = 200 if ( $each > 200 );
	my $sleep  = $param{'sleep'}-0;
	$sleep = 60 if ( $sleep > 60 );
	my $partition  = $param{'partition'}-0;
	$partition = 100 if ( $partition > 100 );
	
	my $chk_sleep = $param{'chk_sleep'} -0;
	my $r_sleep   = $param{'r_sleep'} -0;
	my $chk_f     = $param{'chk_f'} -0;
	my $f_mail    = $param{'f_mail'};
	
	$r_sleep = 10 if( $r_sleep > 10 );
	if( $chk_sleep && !$r_sleep ){
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>�҂����Ԃ���͂��Ă��������B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
        &html_main( $table );
	}
	if( $chk_f && &chk_email($f_mail) ){
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>���[���A�h���X�̌`���Ɍ�肪����܂��B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
        &html_main( $table );
		exit;
	}
	
	my $dummy = $myroot . $data_dir . $$ . time . '.dummy';
	my $lockfull = &lock();
	unless ( open(DUMMY, ">$dummy") ) {
		&rename_unlock( $lockfull );
		&error('�V�X�e���G���[', '�_�~�[�t�@�C�����쐬�ł��܂���');
	}
	print DUMMY "method\t$method\n";
	print DUMMY "each\t$each\n";
	print DUMMY "sleep\t$sleep\n";
	print DUMMY "partition\t$partition\n";
	print DUMMY "chk_sleep\t$chk_sleep\n";
	print DUMMY "r_sleep\t$r_sleep\n";
	print DUMMY "chk_f\t$chk_f\n";
	print DUMMY "f_mail\t$f_mail\n";
	close(DUMMY);
	rename $dummy,"$myroot$data_dir$methodtxt";
	&rename_unlock( $lockfull );
	&make_page( 'method' );
    exit;
}

#--------------------------------------------------#
# ID�A�p�X���[�h�̕ύX                             #
#--------------------------------------------------#
sub ipchange {
    
    my $nid = $param{'nid'};
    my $npass = $param{'npass'};
    my $rpass = $param{'rpass'};
    my $input_id = $param{'input_id'};
    my $input_pass = $param{'input_pass'};
    if ( $npass eq '' ) {
	
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>�p�X���[�h����͂��Ă��������B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
        &html_main( $table );
    }
    if ( $npass ne $rpass ) {
	
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>�m�F�p�X���[�h����v���܂���B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
        &html_main( $table );
    }
    my $new_pass = crypt( $npass, &make_salt() );
    my $fullpath = &lock();
    my $path = $myroot . $data_dir . $log_dir . $admin_txt;
    unless ( open(PASS, "$path" ) ) {
        &rename_unlock( $fullpath );
		
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>�V�X�e���G���[<br><br>$path���J���܂���B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
        &html_main( $table );
    }
    my $id = <PASS>;
    my $pass = <PASS>;
    close(PASS);
    chomp( $id, $pass );
    $nid = $id if !$nid;
    if ( $id eq '' || $pass eq '' ) {
	    unless ($defid eq $input_id && $defpass eq $input_pass) {
            &rename_unlock( $fullpath );
			
			my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>�p�X���[�h���Ⴂ�܂��B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
        	&html_main( $table );
        }
    }else{
        unless ( $id eq $input_id && $pass eq crypt($input_pass,$pass) ) {
            &rename_unlock( $fullpath );
			
			my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>�p�X���[�h���Ⴂ�܂��B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
			&html_main( $table );
		}
	}
	
	my $tmp = $myroot . $data_dir . $log_dir . $$ . time . '.tmp';
	unless ( open(TMP, ">$tmp" ) ) {
		&rename_unlock( $fullpath );
		
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>�V�X�e���G���[<br><br>�e���|�����[�t�@�C�����쐬�ł��܂���$data_dir�̃p�[�~�b�V�������m�F���Ă��������B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
		&html_main( $table );
	}
	$nid = $defid if !$nid;
	print TMP "$nid\n";
	print TMP "$new_pass\n";
	close(TMP);
	rename $tmp, $path;
	&rename_unlock( $fullpath );
	&make_page( 'list' );
    exit;
}
#--------------------------------------------------#
# �Í����̃L�[�쐬                                 #
#--------------------------------------------------#
sub make_salt {
    srand (time + $$);
    return pack ('CC', int (rand(26) + 65), int (rand(10) +48));
}
#--------------------------------------------------#
# �z�M�v�����̍X�V                                 #
#--------------------------------------------------#
sub renew {
	#----------------------------#
	# �X�V���鍀�ڂ̃Z�b�g       #
	#----------------------------#
	my $id = &delspace( $param{'id'} );
	my $data;
	my $index;
	my $action = &delspace( $param{'action'} );
	if($action eq ''){&make_plan_page( 'plan', '', '�G���[' );exit;}
	if    ( $action eq 'pname' )  { $data = &the_text( $param{'text'} ); $index=2; }
	elsif ( $action eq 'header' ) { $data = &the_text( $param{'text'} ); $index=9; }
	elsif ( $action eq 'cl' )     { $data = &the_text( $param{'text'} ); $index=10; }
	elsif ( $action eq 'footer' ) { $data = &the_text( $param{'text'} ); $index=11; }
	
	# �z�M�����
	my ( $pname, $sname, $address, $address2 );
	if ( $action eq 'bs' ) { 
		$pname    = &deltag( $param{'pname'} );
		$sname    = &deltag( $param{'sname'} );
		$address  = &the_text( $param{'address'} );
		if (&chk_email($address) ) {
			&make_plan_page( 'plan', 'g', '���[���A�h���X�̌`��������������܂���');
			exit;
        }
		$address2 = &the_text( $param{'address2'} );
		foreach my $_email ( split(/,/, $address2) ){
			if( &chk_email($_email) ) {
				&make_plan_page( 'plan', 'g', '���[���A�h���X�̌`��������������܂���');
				exit;
			}
		}
	}
	
	# �o�^�p�t�H�[��
	my %form1;
	my @findex;
	my $st   = 15; # �i�[�f�[�^�̊J�n�C���f�b�N�X
	my $end  = 32; # �i�[�f�[�^�̏I���C���f�b�N�X
	foreach my $i ( 15 .. 32 ){
		push @findex, $i;
	}
	my $st2  = 43; # �i�[�f�[�^�̊J�n�C���f�b�N�X�i04/6/17�ǉ��C���j
	my $end2 = 57; # �i�[�f�[�^�̏I���C���f�b�N�X�i04/6/17�ǉ��C���j
	foreach my $i ( 43 .. 57 ){
		push @findex, $i;
	}
	my $st3  = 61; # �i�[�f�[�^�̊J�n�C���f�b�N�X�i06/12/21�ǉ��C�� v2.2�j
	my $end3 = 65; # �i�[�f�[�^�̏I���C���f�b�N�X�i06/12/21�ǉ��C�� v2.2�j
	foreach my $i ( 61 .. 65 ){
		push @findex, $i;
	}
	# 58,59�͐����ʂ̊i�[�f�[�^
	my $st3  = 66; # �i�[�f�[�^�̊J�n�C���f�b�N�X�i07/06/14�ǉ��C�� v2.3�j
	my $end3 = 75; # �i�[�f�[�^�̏I���C���f�b�N�X�i07/06/14�ǉ��C�� v2.3�j
	foreach my $i ( 66 .. 75 ){
		push @findex, $i;
	}
	my $setDesign = 0;
	if ( $action eq 'form1' ) {
		
		# �f�U�C���I��
		if( defined $param{'setDesign'} ){
			$design = $param{'design'};
			$setDesign = 1;
			goto INPUT;
		}
		
		my %Sort;
		foreach my $i ( @findex ) {
			my $ck = ($param{"fm$i"})? 1: 0;
			my $req = ($param{"req$i"})? 1: 0;
			$ck = 1 if($i == 19); # ���[���A�h���X
			$req = 1 if($i == 19);
			$req = 1 if($i == 65 && $ck == 1 ); # ���[���A�h���X�m�F
			$form1{$i} = $ck . '<>' . &deltag($param{"text$i"}) . '<>' . $req. '<>'. $param{"sort$i"};
			
			if( defined $Sort{$param{"sort$i"}} ){
				&make_plan_page( "plan", "", "�\\�����̎w��Ɍ�肪����܂��B" );
				exit;
			}
			$Sort{$param{"sort$i"}} = 1 if( $param{"sort$i"} > 0 );
			
			#������
			#if( $i eq 17 ){
			#	my $sep = ($param{'_fm17'})? 1: 0;
			#	my $sep1 = &deltag( $param{'_text17_1'} );
			#	my $sep2 = &deltag( $param{'_text17_2'} );
			#	$form1{'58'} = $sep . '<>' . $sep1 . '<>' . $sep2;
			#}
			#if( $i eq 18 ){
			#	my $sep = ($param{'_fm18'})? 1: 0;
			#	my $sep1 = &deltag( $param{'_text18_1'} );
			#	my $sep2 = &deltag( $param{'_text18_2'} );
			#	$form1{'59'} = $sep . '<>' . $sep1 . '<>' . $sep2;
			#}
		}
	}
	
	
    # �ύX�A�폜�p�t�H�[��
    my $re;
    my $de;
    if ( $action eq 'form2' ) {
		my $ck1 = ($param{'fr'})? 1: 0;
        my $ck2 = ($param{'fd'})? 1: 0;
        my $rmail = &deltag( $param{'rmail'} );
        my $rnmail = &deltag( $param{'rnmail'} );
        my $dmail = &deltag( $param{'dmail'} );
        my $rid = &deltag( $param{'ruserid'} );
        my $did = &deltag( $param{'duserid'} );
        $re = "$ck1<>$rid<>$rmail<>$rnmail";
        $de = "$ck2<>$did<>$dmail";
	}
	# ���_�C���N�gURL
	my ( $rurl, $nrul, $crul, $out, $ck, $ck2, $ck3 );
	if ( $action eq 'redirect' ) {
		$rurl = &deltag( $param{'regist'} );
		$nurl = &deltag( $param{'renew'} );
		$curl = &deltag( $param{'cancel'} );
		$ck = ( $param{'ck'} )? 1: 0;
		$ck2 = ( $param{'notice'} )? 1: 0;
		$ck3 = ( $param{'confirm'} )? 1: 0;
		$dck = ( $param{'dck'} )? 1: 0;
		$out = &deltag( $param{'out'} );
		$utf = $param{'utf'} -0;
		$ssl = $param{'ssl'} -0;
		# HTTP���
		$http_regist = &deltag( $param{'http_regist'});
		$http_renew = &deltag( $param{'http_renew'});
		$http_cancel = &deltag( $param{'http_cancel'});
		
		# Jcode���C�u�����̊m�F
		if( $utf ){
			unless( &Ctm'jcode_check() ){
				&make_plan_page( "plan", "", "Jcode���C�u�������������ݒu����Ă���܂���B<br>�����R�[�h�ɁuUTF-8�v�𗘗p����ɂ́A<br>�ꎮ�����́wUTF8�������p�̏ꍇ�x���Q�Ƃ����������C���X�g�[�����������B" );
			}
		}
    }
    # �ғ��A��~
    if ( $mode eq 'run' ) {
        $data = $param{'action'}-0;
        $index = 37;
    }
	if( $action eq 'body' ){
		$data = $param{'ra_conf'} -0;
		$index = 77;
	}
	
	
	INPUT:
	#---------------------#
	# �r������            #
	#---------------------#
	my $lockfull = &lock();
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page('plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	#---------------------#
	# �e���|�����t�@�C��  #
	#---------------------#
	my $tmp = $myroot . $data_dir . $log_dir . $id . '.tmp';
	unless ( open(TMP, ">$tmp" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����t�@�C�����쐬�ł��܂���<br>$data_dir�f�B���N�g���̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	while( <PLAN> ) {
		chomp;
		my @line = split(/\t/);
		if( $action eq 'runtime' ){
			my $st = $param{"$line[0]\_s"} -0;
			my $ed = $param{"$line[0]\_e"} -0;
			$line[76] = "$st<>$ed";
		}
		if ( $line[0] eq $id ) {
			if ( $action eq 'bs' ) {
				# �z�M��
				$line[2] = $pname;
				$line[3] = $sname;
				$line[4] = $address;
				$line[5] = $address2;
			}elsif ( $action eq 'form1' ) {
				# �o�^�p�t�H�[��
				if( defined $param{'setDesign'} ){
					$line[81] = $design;
				}else{
					foreach my $i ( @findex ) {
						$line[$i] = $form1{$i};
					}
				}
				#$line[58] = $form1{'58'};
				#$line[59] = $form1{'59'};
				
			}elsif ( $action eq 'form2' ) {
				# �ύX�E�����p�t�H�[��
				$line[33] = $re;
                $line[34] = $de;
			}elsif ( $action eq 'delete' ) {
				# �z�M�v�����폜
				unless ( open(QUEUE, "$myroot$data_dir$queue_dir$line[7]" ) ) {
					close(TMP);
					unlink $tmp;
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�f�[�^�t�@�C�����J���܂���B�i�{���ݒ�j");
					exit;
				}
				while(<QUEUE>){
					chomp;
					my $filename = ( split(/\t/) )[7];
					my $filepath = $myroot . $data_dir . $queue_dir . $filename;
					if( -e $filepath ){
						unlink $filepath;
					}
				}
				close(QUEUE);
				
				# �܂��܂��o�^�ݒ�̍폜
				&Magu::delete( $id );
				# �t�H�[�����������ݒ�̍폜
				&MF'set('delete');
				# �J�X�^�}�C�Y�폜
				&Ctm'clean( $id );
				# �A�N�Z�X�W�v�폜
				my @ids;
				my( $sche, $da ) = split(/<>/,$line[36]);
				foreach( split(/,/,$sche ) ){
					my $code = (split(/\//) )[2];
					push @ids, $code;
				}
				push @ids, $id;
				&Click'clean( @ids );
				
				unlink "$myroot$data_dir$csv_dir$line[6]", "$myroot$data_dir$queue_dir$line[7]","$myroot$data_dir$log_dir$line[8]";
				next;
			}elsif ( $action eq 'redirect' ) {
				$line[12] = $rurl;
				$line[13] = $nurl;
				$line[14] = $curl;
				$line[38] = $out;
				$line[39] = $ck;
				$line[40] = $ck2;
				$line[41] = $ck3;
				$line[42] = $dck;
				$line[60] = $utf;
				$line[78] = $http_regist;
				$line[79] = $http_renew;
				$line[80] = $http_cancel;
				$line[83] = $ssl;
            }elsif( $action eq 'click_analy' ){
				$line[82] = $param{'addr'}; # Click.pl �Ő���
			}else {
				$line[$index] = $data if( $index ne '' );
			}
			
		}
		$_ = join("\t", @line);
		print TMP "$_\n";
	}
	close(TMP);
	close(PLAN);
	rename $tmp, $file;
	#---------------------#
	# �r�������r��        #
	#---------------------#
	&rename_unlock( $lockfull );
	
	# �Ǘ��Ғʒm�ݒ�̏ꍇ
	if( $mode eq 'body' ){
		return;
	}
	# �N���b�N����
	if( $mode eq 'click_analy' ){
		return;
	}
    &make_page( 'list' ) if ( $action eq 'delete' || $action eq 'runtime' );
	&make_plan_page( 'plan', 'form1' ) if( $setDesign );
	&make_plan_page( 'plan', 'all' );
	exit;
}

#--------------------------------------------------#
# �z�M�v�����̐V�K�ǉ�                             #
#--------------------------------------------------#
sub regist {
	
	my $pname = &delspace( $param{'p_title'} );
	if ( $pname eq '' ) {
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>���ʖ�����͂��Ă��������B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
        &html_main( $table );
    }
	my $count = $param{'count'} - 0;
	my $interval = $param{'interval'} - 0;
	my @intervals;
    my $int;
	for( my $i=0; $i<$count; $i++ ){
        $int += $interval;
		$intervals[$i] = $int;
	}
    my $intervals = join(",", @intervals);
	my $now = time;
	my $id = $now . $$;
	my $csv = 'C' . $id . '.cgi';
	my $queue = 'Q' . $id . '.cgi';
	my $sendlog = 'L' . $id . '.cgi';
	my $date = &make_date2( $now );
	
	if( $count > 0 && !$interval ){
		my $table = <<"END";
<table width="550" cellpadding="10">
<tr>
<td>�z�M�Ԋu���w�肵�Ă��������B</td>
</tr>
<tr>
<td><font color="#0000FF">�u���E�U��<strong>�u�߂�v</strong>�{�^�����N���b�N���A�ēx���͂��Ă��������B</font></td>
</tr>
</table>
END
		&html_main( $table );
		exit;
	}
	
	
	
	#---------------------#
	# �r������            #
	#---------------------#
	my $lockfull = &lock();
	#-------------------------------#
	# �o�^�҃��X�gCSV�t�@�C���̍쐬 #
	#-------------------------------#
	my $csvpath = "$myroot$data_dir$csv_dir$csv";
	unless ( open(CSV, ">$csvpath" ) ) {
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�o�^�҃��X�g�t�@�C�����쐬�ł��܂���<br>$csv_dir�f�B���N�g���̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	close(CSV);
	#-------------------------------#
	# �v�����̖{���t�@�C���̍쐬    #
	#-------------------------------#
	my $queuepath = "$myroot$data_dir$queue_dir$queue";
	unless ( open(QUE, ">$queuepath" ) ) {
		unlink $csvpath;
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�v�����{���t�@�C�����쐬�ł��܂���<br>$queue_dir�f�B���N�g���̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	close(QUE);
	#-------------------------------#
	# ���M�̏ڍ׃��O�t�@�C���̍쐬  #
	#-------------------------------#
	my $sendlogpath = "$myroot$data_dir$log_dir$sendlog";
	unless ( open(QUE, ">$sendlogpath" ) ) {
		unlink $csvpath, $queuepath;
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�v�����{���t�@�C�����쐬�ł��܂���<br>$queue_dir�f�B���N�g���̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	close(QUE);
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		unlink $csvpath, $queuepath, $sendlogpath;
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	#---------------------#
	# �e���|�����t�@�C��  #
	#---------------------#
	my $tmp = $myroot . $data_dir . $log_dir . $id . '.tmp';
	unless ( open(TMP, ">$tmp" ) ) {
		unlink $csvpath, $queuepath, $sendlogpath;
		&rename_unlock( $lockfull );
		&html_main("<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����t�@�C�����쐬�ł��܂���<br>$data_dir�f�B���N�g���̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	chmod 0606, $tmp;
	#---------------------#
	# �f�[�^��ǉ�        #
	#---------------------#
	my $line = qq|$id\t$date\t$pname\t$sname\t$address\t$address2\t$csv\t$queue\t$sendlog\t$header\t$cancel\t$footer\t$thankurl\t$chageurl\t$stopurl\t$co\t$_co\t$name\t$_name\t1<><>1\t$tel\t$fax\t$url\t$code\t$ken\t$ken1\t$ken2\t$ken3\t$free1\t$free2\t$free3\t$free4\t$free5\t$renew\t$crossout\t$count\t$intervals\t0\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t1\t1\n|;
	print TMP $line;
	while( <PLAN> ) {
		print TMP;
	}
	close(TMP);
	close(PLAN);
	rename $tmp, $file;
	#---------------------#
	# �r�������r��        #
	#---------------------#
	&rename_unlock( $lockfull );
	
	$param{'id'} = $id;
	&make_plan_page( 'plan', 'all' );
	exit;
}

#------------------------------------------------------#
# �����̍X�V                                           #
#------------------------------------------------------#
sub reschedule {
    
    my $id = $param{'id'} - 0;
	my $type = $param{'type'};
	my $count;
	my $interval;
	my $dnum;
	my $addnum;
	my %change;
	my $sort_date;
	my $scheduleRenew = 0;
	my %def_intervals;
	my %stopConfig;
	my $dcode;
	
	
	my $plantxt = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$plantxt" ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	my %def_intervals;
	my $def_dates;
	while( <PLAN> ) {
		chomp;
		my @line = split(/\t/);
		if ( $line[0] eq $id ) {
			my ( $def_interval, $def_dates ) = split( /<>/, $line[36] );
			my $n = 2;
			foreach( split( /,/, $def_interval ) ){
				my( $int, $config, $code ) = split( /\//);
				$def_intervals{$n} = [$int, $config, $code];
				$n++;
			}
		}
	}
	close(PLAN);
    #--------------------------------------------------------------#
	# �z�M�v�����f�[�^�����X�V                                     #
	#--------------------------------------------------------------#
	if ( $type ne 'date' ) {
		$count = $param{'count'} - 0;
		my $_count = $count;
		my @intervals;
		my $er = 0;
		my $max = 0;
		my $add_flag = 0;
		my $stepNum = 2; # �z�M�ԍ�
		# ��2��̒ǉ��`�F�b�N
		if(  defined $param{"add0"} ){
			$max++;
			my $uniq = crypt( $max, &main'make_salt() );
			$uniq =~ s/[\.|\/|\,]//gi;
			push @intervals, "$max//$uniq";
			$_count++;
			$add_flag = 1;
			$addnum = 1;
			$scheduleRenew = 1;
			$stepNum++;
		}
		
		for ( my $i=1; $i<=$count; $i++ ) {
			
			my $c_name = 'int' . $i;
			my $stop = 'stop'. $i;
			my $def_stop = 'def_stop'. $i;
			$param{$c_name} -= 0;
			$param{$stop} -= 0;
			$param{$def_stop} -= 0;
			my $def_stepNum = $i+1;
			my $def_uniq = $def_intervals{$def_stepNum}->[2];
			
			# �ǉ��̏ꍇ�́A�N�Z������ǉ�
			if ( $add_flag && $max >= $param{$c_name}) {
				$param{$c_name}++;
			}
			# �z�M�����̍폜
			if ( defined $param{"del$i"} ) {
				$dnum = $i;
				$dcode = $def_uniq;
				$_count--;
				$scheduleRenew = 1;
				next;
			}
			# �u�ꎞ��~�v����擾�i�ŐV�j
			$stopConfig{$stepNum} = 1 if( $param{$stop} );
			
			# �u�ꎞ��~�v���X�V���ꂽ�ꍇ
			$scheduleRenew = 1 if( $param{$stop} != $param{$def_stop} );
			
			# �ꎞ��~�̏ꍇ�́A�N�Z������������
			if( $param{$stop} ){
				$param{$c_name} = "";
				$max = 0;
				
			}else{
				if ( !$param{$c_name} ){
					&make_plan_page( 'plan', '', "�z�M�Ԋu�́A1����ȏ�ɐݒ肵�Ă�������");
				}
				if ( $max >= $param{$c_name} ){
					&make_plan_page( 'plan', '', "�������������ݒ肳��Ă���܂���B<br>�z�M�Ԋu�ݒ�����m�F���������B");
				}
				$max = $param{$c_name};
			}
			
			push @intervals, "$param{$c_name}/$param{$stop}/$def_uniq";
			$stepNum++;
			
			# �z�M�����̒ǉ�
			if ( defined $param{"add$i"} ) {
				$max++;
				my $uniq = crypt( $max, &main'make_salt() );
				$uniq =~ s/[\.|\/|\,]//gi;
				push @intervals, "$max//$uniq";
				$_count++;
				$add_flag = 1;
				$addnum = $i + 1;
				$stepNum++;
				$scheduleRenew = 1
			}
			
		}
		$interval = join(',', @intervals);
		
		# �o�^���E�ύX���E������
		my $r = ($param{'r'})? 1: 0;
		my $r2 = ($param{'r2'})? 1: 0;
		my $r3 = ($param{'r3'})? 1: 0;
		$count = "$_count,$r,$r2,$r3";
		
	} else {
		my %dates;
		my %InDate;
		foreach ( keys %param ) {
			if ( /mon(\d+)/ ) {
				my $date = $1;
				if ( defined $param{"day$date"} ) {
					if ( defined $param{"del$date"} ) {
						$dnum = "d$date";
						next;
					}
					my $mon = sprintf( "%02d", $param{"mon$date"}-0 );
					my $day = sprintf( "%02d", $param{"day$date"}-0 );
					
					# �N�f�[�^�͓���i�����ꍇ���N�j
					my $year;
					$year = sprintf( "%04d", $param{"year$date"} -0) if( $param{"year$date"} > 0 );
					if ( $InDate{"$mon$day"} ) {
						&make_plan_page( 'plan', '', "���łɓ������t���o�^�����Ă��܂�");
					}
					$change{"d$date"} = "d$mon$day$year" if ( $date ne "$mon$day$year" );
					$dates{"$mon$day$year"} = qq|$param{"mon$date"}/$param{"day$date"}|;
					$dates{"$mon$day$year"} .= qq|/$param{"year$date"}| if($param{"year$date"} > 0) ;
					$InDate{"$mon$day"} = 1;
				}
			}
		}
		my $year = sprintf( "%04d", $param{"addyear"} );
		my $mon = sprintf( "%02d", $param{"addmon"} );
		my $day = sprintf( "%02d", $param{"addday"} );
		my $add = $mon. $day;
		$add .= $year if( $year > 0 );
		if ( $add > 0 ) {
			if ( $mon <= 0 || $day <= 0 || $param{"addyear"} eq '' ) {
				&make_plan_page( 'plan', '', "�ǉ��p�̓��t���������ݒ肳��Ă��܂���");
			}
			if ( $InDate{"$mon$day"} ) {
				&make_plan_page( 'plan', '', "�ǉ��������t�́A���łɓo�^�����Ă��܂�");
			}
			$dates{$add} = "$mon/$day";
			$dates{$add} .= "/$year" if( $year > 0);
		}
		my @after;
		foreach ( sort{ sprintf( "%04d", substr($a,4,4) ).substr($a,0,4) <=> sprintf( "%04d", substr($b,4,4) ).substr($b,0,4) } keys %dates ) {
			push @after, $dates{$_};
		}
		$sort_date = join(",", @after );
	}
	
    #-------------#
	# �r������    #
	#-------------#
    my $lockfull = &lock();
    #--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	#---------------------#
	# �e���|�����t�@�C��  #
	#---------------------#
	my $tmp_plan = $myroot . $data_dir . $log_dir . $id . '.tmp';
	unless ( open(TMP, ">$tmp_plan" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����t�@�C�����쐬�ł��܂���<br>$log_dir�f�B���N�g���̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	chmod 0606, $tmp_plan;
	#---------------------#
	# �f�[�^���X�V        #
	#---------------------#
	my ( $csv, $queue, $sendlog );
	while( <PLAN> ) {
		chomp;
		my @line = split(/\t/);
		if ( $line[0] eq $id ) {
			my ( $int, $dat ) = split( /<>/, $line[36] );
			if ( $type ne 'date' ) {
				$line[35] = $count;
				$line[36] = "$interval<>$dat";
			} else {
				$line[36] = "$int<>$sort_date";
			}
			$_ = join("\t", @line);
			$csv     = $line[6];
			$queue   = $line[7];
			$sendlog = $line[8];
		}
		print TMP "$_\n";
	}
	close(TMP);
	close(PLAN);
	
	
	#----------------#
	# �{�����X�V     #
	#----------------#
	my $tmp_queue = '';
	my $queuepath = $myroot . $data_dir . $queue_dir . $queue;
	if ( $dnum ne '' || $addnum || keys %change ) {
		unless ( open(BODY, $queuepath ) ) {
		    unless (-e $queuepath ) {
			    unless (open(BODY, ">>$queuepath") ) {
					unlink $tmp_plan;
				    &rename_unlock( $lockfull );
				    &make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$data_dir�̃p�[�~�b�V�������m�F���Ă�������");
				    exit;
			    }
			} else {
				unlink $tmp_plan;
				&rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$queuepath�̃p�[�~�b�V�������m�F���Ă�������");
				exit;
			}
		}
		$tmp_queue = $myroot . $data_dir . $queue_dir . time . $$ . '.tmp';
		unless ( open(TMP, ">>$tmp_queue" ) ) {
			unlink $tmp_plan;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$queue_dir�̃p�[�~�b�V�������m�F���Ă�������");
			exit;
		}
		chmod 0606, $tmp_queue;
		while( <BODY> ) {
			chomp;
			my @lines  = split(/\t/);
			if ( $lines[0] eq $dnum ) {
				if( $lines[7] ne '' ){
					my $path = $myroot . $data_dir . $queue_dir . $lines[7];
					if( -e $path ){
						unlink $path;
					}
				}
				next;
			}
			if ( $type ne 'date' ) {
				if ( $dnum ne '' && $dnum !~ /^d(\d+)/ && $lines[0] > $dnum ) {
					$lines[0] = $lines[0] - 1;
					$_ = join( "\t", @lines );
				}
				if ( $addnum ne '' && $addnum !~ /^d(\d+)/ && $lines[0] >= $addnum ) {
					$lines[0] = $lines[0] + 1;
					$_ = join( "\t", @lines );
				}
			}
			if ( defined $change{$lines[0]} ) {
				$lines[0] = $change{$lines[0]};
				$_ = join( "\t", @lines );
			}
			print TMP "$_\n";
		}
		close(TMP);
		close(BODY);
	}
	
	#-------------------------------#
	# CSV�̑��M�ς݃��[���ԍ����C�� #
	#-------------------------------#
	my $tmp_csv = '';
	my $csvpath = $myroot . $data_dir . $csv_dir . $csv;
	if ( $type ne 'date' && $scheduleRenew ) {
		unless ( open(CSV, $csvpath ) ) {
			unless (-e $csvpath ) {
				unless (open(CSV, ">>$csvpath") ) {
					unlink $tmp_plan;
					unlink $tmp_queue;
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$data_dir�̃p�[�~�b�V�������m�F���Ă�������");
					exit;
			    }
		    } else {
				unlink $tmp_plan;
				unlink $tmp_queue;
			    &rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$csvpath�̃p�[�~�b�V�������m�F���Ă�������");
				exit;
			}
		}
		$tmp_csv = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
		unless( open(TMP, ">$tmp_csv") ){
			unlink $tmp_plan;
			unlink $tmp_queue;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$csv_dir�̃p�[�~�b�V�������m�F���Ă�������");
			exit;
		}
		chmod 0606, $tmp_csv;
		my $loop = 0;
		while( <CSV> ) {
			chomp;
			my @csvdata = split(/\t/);
			my $sendNum = ( $csvdata[20] >= 2 )? $csvdata[20]: 0; # ���z�M�ς݉�
			
			$csvdata[20] -= 1 if ( $dnum >0 && $dnum < $csvdata[20] );
			$csvdata[20] += 1 if ( $addnum > 0 && $addnum < $csvdata[20] );
			$csvdata[51] -= 1 if ( $csvdata[51] > 0 && $dnum >0 && $dnum < $csvdata[51] );
			$csvdata[51] += 1 if ( $csvdata[51] > 0 && $addnum > 0 && $addnum < $csvdata[51] );
			$csvdata[51] = '' if( $csvdata[51] < 2 );
			
			my $nextStep = ($csvdata[20] > 1)? $csvdata[20]+1: 2; # ����z�M��
			
			$csvdata[52] = 1 if( $stopConfig{$nextStep} );
			$csvdata[52] = 0 unless( defined $stopConfig{$nextStep} );
			
			# �w��񂪗L��ꍇ�́A�ҋ@��Ԃł͂Ȃ�
			$csvdata[52] = 0 if( $csvdata[51] ne '' );
			
			# �������Ȃ��ꍇ�͎w�������������
			$csvdata[54] = '' if( $interval eq '' );
			
			# �ۑ��O�̑��M�������m�F&�ۑ�
			# �����Ŋe�X�e�b�v�̑��M����ێ�����i���M�ς݂̂݁j
			# �ʏ�͔z�M���ɕۑ� v2.4�ȑO�ł͗�����ۑ����Ȃ����߁A�����ŋ����I�ɕۑ�
			my @sended = split( /<>/, $csvdata[53] );
			my @result;
			foreach( @sended){
				my( $n, $data ) = split(/\//);
				if( $dnum > 0 ){
					my $deleteStepNum = $dnum+1; # �X�e�b�v�ԍ��ɕϊ�
					# �폜
					next if( $n == $deleteStepNum );
					$n -= 1 if ( $deleteStepNum <= $n );
				}elsif ( $addnum > 0 ){
					my $addStepNum = $addnum+1; # �X�e�b�v�ԍ��ɕϊ�
					$n += 1 if( $addStepNum <= $n );
				}
				push @result, qq|$n/$data|;
			}
			$csvdata[53] = join("<>", @result );
			$_ = join("\t", @csvdata);
			print TMP "$_\n";
			
			if( $loop > 2000 ){
				select(undef, undef, undef, 0.10);
				$loop = 0;
			}
			$loop++;
		}
		close(CSV);
		close(TMP);
		
	}
	
	#----------------#
	# �z�M���O���C�� #
	#----------------#
	my $tmp_log = '';
	my $logpath = $myroot . $data_dir . $log_dir . $sendlog;
	if ( $dnum ne '' || $addnum || keys %change ) {
		unless ( open(LOG, $logpath ) ) {
			unless (-e $logpath ) {
				unless (open(LOG, ">>$logpath") ) {
					unlink $tmp_plan;
					unlink $tmp_queue;
					unlink $tmp_csv;
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$data_dir�̃p�[�~�b�V�������m�F���Ă�������");
					exit;
			    }
		    } else {
				unlink $tmp_plan;
				unlink $tmp_queue;
				unlink $tmp_csv;
			    &rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$logpath�̃p�[�~�b�V�������m�F���Ă�������");
				exit;
			}
		}
		$tmp_log = "$myroot$data_dir$log_dir" . $$ . time . '.tmp';
		unless( open(TMP, ">$tmp_log") ){
			unlink $tmp_plan;
			unlink $tmp_queue;
			unlink $tmp_csv;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$log_dir�̃p�[�~�b�V�������m�F���Ă�������");
			exit;
		}
		chmod 0606, $tmp_log;
		$loop = 0;
		while( <LOG> ) {
			chomp;
			my @logs = split(/\t/);
			if( $type ne 'date' ) {
				if ( $logs[4] eq $dnum ) {
					$logs[4]  = '';
				}else{
					$logs[4] -= 1  if ( $dnum > 0 && $dnum < $logs[4] );
					$logs[4] += 1  if ( $addnum > 0 && $addnum <= $logs[4] );
				}
			}else{
				if ( defined $change{$logs[4]} ){
					$logs[4] = $change{$logs[4]};
				}
				$logs[4] = '' if ( $dnum eq $logs[4] );
			}
			$_ = join("\t", @logs);
			print TMP "$_\n";
			
			if( $loop > 2000 ){
				select(undef, undef, undef, 0.10);
				$loop = 0;
			}
			$loop++;
		}
		close(LOG);
		close(TMP);
		
	}
	
	#--------------#
	# �f�[�^�ۑ����f
	#--------------#
	
	# �v�����f�[�^
	rename $tmp_plan, $file;
	# �{���f�[�^
	rename $tmp_queue, $queuepath if( $tmp_queue ne '' );
	# �o�^�҃f�[�^
	rename $tmp_csv, $csvpath if( $tmp_csv ne '' );
	# �z�M���O�f�[�^
	rename $tmp_log, $logpath if( $tmp_log ne '' );
	# �A�N�Z�X����
	&Click'default( $dcode, 1 ) if( $type ne 'date' );
	
	#--------------#
	# �r���������� #
	#--------------#
    &rename_unlock( $lockfull );
    &make_plan_page( 'plan', 'schedule' );
    exit;
}

# �e�v�����̃X�e�b�v�Ƀ��j�[�N�R�[�h��ݒ肷��(v2.4����K�v)
sub schedule_disorder
{
	my $plantxt = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$plantxt" ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	my %def_intervals;
	my $def_dates;
	while( <PLAN> ) {
		chomp;
		my @line = split(/\t/);
		if ( $line[0] eq $id ) {
			my ( $def_interval, $def_dates ) = split( /<>/, $line[36] );
			my $n = 2;
			foreach( split( /,/, $def_interval ) ){
				my( $int, $config, $code ) = split( /\//);
				$def_intervals{$n} = [$int, $config, $code];
				$n++;
			}
		}
	}
	close(PLAN);
	
	unless ( open(CSV, $csvpath ) ) {
		$tmp_csv = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
		unless( open(TMP, ">$tmp_csv") ){
			unlink $tmp_plan;
			unlink $tmp_queue;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$csv_dir�̃p�[�~�b�V�������m�F���Ă�������");
			exit;
		}
		chmod 0606, $tmp_csv;
		my $loop = 0;
		while( <CSV> ) {
			chomp;
			my @csvdata = split(/\t/);
			my $sendNum = ( $csvdata[20] >= 2 )? $csvdata[20]: 0; # ���z�M�ς݉�
			
			
			# �ۑ��O�̑��M�������m�F&�ۑ�
			# �����Ŋe�X�e�b�v�̑��M����ێ�����i���M�ς݂̂݁j
			# �ʏ�͔z�M���ɕۑ� v2.4�ȑO�ł͗�����ۑ����Ȃ����߁A�����ŋ����I�ɕۑ�
			my %sendLog;
			foreach( sort{ $a <=> $b } keys %def_intervals ){
				my $int = $def_intervals{$_}->[0];
				next if( $sendLog{$_} > 0 ); # ���łɕێ����Ă���ꍇ
				next if( $sendNum < $_ );    # �z�M�ς݉����̏ꍇ�̓X�L�b�v
				$sendLog{$_} = $csvdata[19] + ($int*60*60*24);
			}
			my @result;
			foreach( sort{ $a <=> $b } keys %sendLog ){
				push @result, qq|$_/$sendLog{$_}|;
			}
			$csvdata[53] = join("<>", @result );
			$_ = join("\t", @csvdata);
			print TMP "$_\n";
			
			if( $loop > 2000 ){
				select(undef, undef, undef, 0.10);
				$loop = 0;
			}
			$loop++;
		}
		close(CSV);
		close(TMP);
		
		rename $tmp_csv, $cav_path;
	}
}

#------------------------------------------------------#
# �{���̍X�V                                           #
#------------------------------------------------------#
sub body {
	my $id = &delspace( $param{'id'} -0 );
	my $n = &delspace( $param{'n'} );
    $n -= 0 if ( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );
	my $t_title = &delspace( $param{'btitle'} );
	$param{'body'} =~ s/(\s\s)$//;
	my $body = &the_text( $param{'body'} );
	
	my $h = ( $param{'header'} )? 1: 0;
	my $c = ( $param{'cancel'} )? 1: 0;
	my $f = ( $param{'footer'} )? 1: 0;
	
	# HTML�`��
	my $ctype = ( $param{'content-type'}-0 )? 1: 0;
	my $line = qq|$n\t$t_title\t$h\t$c\t$body\t$f\t$ctype|;
	my $lockfull = &lock();
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	my $queue;
	while( <PLAN> ) {
		my ( $index, $file ) = ( split(/\t/) )[0, 7];
		if ( $index eq $id ) {
			$queue = $myroot . $data_dir . $queue_dir . $file;
			last;
		}
	}
	close(PLAN);
	&make_plan_page( 'plan', '', '�G���[<br>�Y������v����������܂���') if (!$queue);
	unless ( open(BODY, $queue ) ) {
		unless (-e $queue ) {
			unless (open(BODY, ">>$queue") ) {
				&rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$queue_dir�̃p�[�~�b�V�������m�F���Ă�������");
				exit;
			}
		} else {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$queue�̃p�[�~�b�V�������m�F���Ă�������");
			exit;
		}
	}
	my $tmp = $myroot . $data_dir . $queue_dir . time . $$ . '.tmp';
	unless ( open(TMP, ">>$tmp" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$queue_dir�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	chmod 0606, $tmp;
	my $flag = 0;
	while( <BODY> ) {
		chomp;
		my ( $index, $filename ) = ( split(/\t/) )[0, 7];
		if ( $index eq $n ) {
			$flag = 1;
			$_ = "$line\t$filename";
		}
		print TMP "$_\n";
	}
	print TMP "$line\n" if ( !$flag );
	close(TMP);
	close(BODY);
	rename $tmp, $queue;
	&rename_unlock( $lockfull );
	
	if( $n eq 'ra' ){
		$main'param{'action'} = $mode;
		&renew();
	}
	
	&make_plan_page('plan', 'preview');
	exit;
}

sub body_html {
	
	my $id = &delspace( $param{'id'} -0 );
	my $n = &delspace( $param{'n'} );
    $n -= 0 if ( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );
	
	my $filename = &the_filedata( 'html' );
	
	if( $filename !~ /.htm(l)*$/ && !defined $param{'del'} ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">���̓G���[</font><br><br>HTML�t�@�C�����w�肵�Ă��������B");
		exit;
	}
	
	my $lockfull = &lock();
	
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	my( $queuedir, $queue, $filepath );
	while( <PLAN> ) {
		my ( $index, $file ) = ( split(/\t/) )[0, 7];
		if ( $index eq $id ) {
			$queuedir = $myroot . $data_dir . $queue_dir;
			$queue    = $queuedir . $file;
			$filepath = $queuedir . $filename;
			last;
		}
	}
	close(PLAN);
	
	if (!$queue){
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', '�G���[<br>�Y������v����������܂���');
		exit;
	}
	
	unless ( open(BODY, $queue ) ) {
		unless (-e $queue ) {
			unless (open(BODY, ">>$queue") ) {
				&rename_unlock( $lockfull );
				&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$queue_dir�̃p�[�~�b�V�������m�F���Ă�������");
				exit;
			}
		} else {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$queue�̃p�[�~�b�V�������m�F���Ă�������");
			exit;
		}
	}
	my $tmp = $myroot . $data_dir . $queue_dir . time . $$ . '.tmp';
	unless ( open(TMP, ">>$tmp" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����쐬�ł��܂���<br>$queue_dir�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	chmod 0606, $tmp;
	my $flag = 0;
	my $def_filename;
	while( <BODY> ) {
		chomp;
		my @_lines = split(/\t/);
		if ( $_lines[0] eq $n ) {
			$flag = 1;
			$def_filename = $_lines[7];
			my $path = $queuedir . $_lines[7];
			unlink $path;
			if( defined $param{'del'} ){
				$_lines[7] = '';
			}else{
				if( $filename ne $def_filename && -e $filepath ){
					close(TMP);
					unlink $tmp;
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�����t�@�C�����A�b�v���[�h����Ă��܂��B", '', 'html' );
					exit;
				}
				$_lines[7] = $filename;
			}
			$_ = join( "\t", @_lines );
		}
		print TMP "$_\n";
	}
	if( !$flag ){
		print TMP qq|$n\t$t_title\t$h\t$c\t$body\t$f\t$ctype\t$filename\n|;
	}
	
	close(TMP);
	close(BODY);
	rename $tmp, $queue;
	
	#--------------------------#
	# HTML�t�@�C����ۑ�       #
	#--------------------------#
	unless( defined $param{'del'} ){
		unless( open(HTML, ">$filepath") ){
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "<font color=\"#CC0000\">���̓G���[</font><br><br>HTML�t�@�C�����쐬�ł��܂���B<br>$image_dir �̃p�[�~�b�V������[ 707 ]�ł��邩�m�F���Ă��������B");
			exit;
		}
		local $_HTML = $param{'html'};
		&jcode::convert( \$_HTML, 'jis' );
		print HTML $_HTML;
		close(HTML);
		chmod 0606, $filepath;
	}
	
	
	&rename_unlock( $lockfull );
	&make_plan_page('plan', 'html');
	exit;
}


#------------------------------------------------------#
# �{���̑��M�e�X�g�p�p�����[�^�̎擾                   #
#------------------------------------------------------#
sub sendtest {
    my $id = $param{'id'} - 0;
    my $n = $param{'n'};
    $n -= 0 if( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );
    
	# ���M�ςݒZ�kURL���擾
	my $forward = &Click'getForward_url();
	
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	local ( $queuedir, $queue, $name, $from, $to, $header, $cancel, $footer, $tag_data, $step, $ssl );
	while( <PLAN> ) {
        chomp;
		my ( $index, $_name, $_from, $_to, $file, $_header, $_cancel, $_footer, $_step, $_tag_data, $ssl ) = ( split(/\t/) )[0, 3, 4, 5, 7, 9, 10, 11, 36, 82, 83];
		if ( $index eq $id ) {
			$queuedir = $myroot . $data_dir . $queue_dir;
			$queue  = $queuedir . $file;
			$name   = $_name;
			$from   = $_from;
			$to     = ( split(/,/, $_to) )[0];
			$header = $_header;
			$cancel = $_cancel;
			$footer = $_footer;
			$tag_data = $_tag_data;
			$step = $_step;
			&Pub'ssl($ssl);
			last;
		}
	}
	close(PLAN);
    if (!$queue){
	    &make_plan_page( 'plan', '', '�G���[<br>�Y������v����������܂���');
        exit;
    }
	#---------------------------#
	# �]���p�^�O�擾            #
	#---------------------------#
	my( $urlTag, $other ) = &Click'roadTag( $tag_data );
	
	my( $schedule, $dates ) = split( /<>/, $step );
	my $c=1;
	my %SIDS;
	$UIDS{'0'} = $id. '-0';
	foreach( split(/,/, $schedule ) ){
		my( $int, $config, $sid ) = split(/\//);
		$UIDS{$c} = $sid;
		$c++;
	}
	my $unic = $UIDS{$n};
	
    #--------------------------#
	# �����̖{���f�[�^���擾   #
	#--------------------------#
	unless ( open(BODY, $queue ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$queue�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
    my $body;
	while( <BODY> ) {
		chomp;
		my ( $index ) = ( split(/\t/) )[0];
		if ( $index eq $n ) {
			$body = $_;
            last;
		}
	}
    close(BODY);
    if (!$body) {
	    &make_plan_page( 'plan', '', '�G���[<br>�Y������{��������܂���');
        exit;
    }
    #--------------------------#
	# ���M�e�X�g���[���̍쐬   #
	#--------------------------#
	$header =~ s/<br>/\n/gi;
	$cancel =~ s/<br>/\n/gi;
	$footer =~ s/<br>/\n/gi;
	my @bodys = split(/\t/, $body);
	
	local $subject = $bodys[1];
	$subject = &include( \@temdata_base, $subject, '', 1 );
	local $message;
	local $CONTENT_TYPE;
	
	my $forward_urls;
	# �e�L�X�g�`��
	if( $bodys[6] <= 0 ){
		local $mes = $bodys[4];
		$mes =~ s/<br>/\n/gi;
		$message .= "$header\n" if ( $bodys[2] );
		$message .= "$mes\n";
		$message .= "$cancel\n" if ( $bodys[3] );
		$message .= "$footer" if ( $bodys[5] );
		
		# �]���^�O�ϊ�
		($message, $forward_urls) = &Click'analyTag('', $message, $urlTag, $unic, $forward) if( $n =~ /^\d+$/ );
		$message = &include( \@temdata_base, $message, '', 1 );
	}
	# HTML�`��
	else{
		$CONTENT_TYPE = 'text/html';
		my $htmlpath = $queuedir . $bodys[7];
		unless( open( HTML, $htmlpath ) ){
			&make_plan_page( 'plan', '', '�G���[<br>�Y������HTML�t�@�C��������܂���B');
        exit;
		}
		while(<HTML>){
			$message .= $_;
		}
		close(HTML);
		# �]���^�O�ϊ�
		($message, $forward_urls) = &Click'analyTag('', $message, $urlTag, $unic, $forward) if( $n =~ /^\d+$/ );
		$message = &include( \@temdata_base, $message, 1, 1 );
	}
	
	
	if ( &send( $from, $name, $to, $subject, $message ) ){
		&make_plan_page( 'plan', '', '���[�������M�ł��܂���' );
	}
	# �A�N�Z�X�W�v�p�f�[�^����
	&Click'setForward_t( $forward_urls, $unic, '', 1 );
	&make_plan_page('plan', 'all');
	exit;
}

#------------------------------------------------------#
# �Ǘ��҂ɂ�郆�[�U�[�o�^                             #
#------------------------------------------------------#
sub ____reguest {
    my $id = $param{'id'} - 0;
    my $date = time;
    my $lockfull = &lock();
    #--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
    my @line;
    my $csvpath;
    my $queuepath;
    my $logpath;
    while( <PLAN> ) {
		chomp;
		@line = split(/\t/);
		if ( $line[0] eq $id ) {
			$csvpath = "$myroot$data_dir$csv_dir$line[6]";
			$queuepath = "$myroot$data_dir$queue_dir$line[7]";
			$logpath = "$myroot$data_dir$log_dir$line[8]";
			last;
		}
	}
	close(PLAN);
	#--------------------------------#
	# �����̓o�^�҃f�[�^����ID���擾 #
	#--------------------------------#
	my $index;
	unless ( $csvpath ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�Y������f�[�^������܂���");
		exit;
	}
	unless ( open(CSV, "$csvpath" ) ) {
		if ( -e $csvpath ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$csvpath�̃p�[�~�b�V�������m�F���Ă�������");
			exit;
		}
		unless ( open(CSV, ">>$csvpath") ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>���[�U�[�o�^���ł��܂���<br>$data_dir�̃p�[�~�b�V�������m�F���Ă�������");
			exit;
		}
		$index = 0;
	}else {
        while( <CSV> ) {
            chomp;
            my ( $id, $mail ) = ( split(/\t/) )[0, 5];
            if ( $param{'mail'} eq $mail ) {
                &rename_unlock( $lockfull );
                &make_plan_page( 'plan', 'g', '����̃��[���A�h���X���o�^����Ă��܂�');
                exit;
            }
            $index = $id;
        }
    }
    close(CSV);
    $index++;
    my @names = (
			{'name' => 'co', 'value' => '��Ж�'},
			{'name' => '_co', 'value' => '��Ж��t���K�i'},
			{'name' => 'name', 'value' => '�����O'},
			{'name' => '_name', 'value' => '�����O�t���K�i'},
			{'name' => 'mail', 'value' => '���[���A�h���X'},
			{'name' => 'tel', 'value' => '�d�b�ԍ�'},
			{'name' => 'fax', 'value' => 'FAX�ԍ�'},
			{'name' => 'url', 'value' => 'URL'},
			{'name' => 'code', 'value' => '�X�֔ԍ�'},
			{'name' => 'address', 'value' => '�s���{��'},
			{'name' => 'address1', 'value' => '�Z���P'},
			{'name' => 'address2', 'value' => '�Z���Q'},
			{'name' => 'address3', 'value' => '�Z���R'},
			{'name' => 'free1', 'value' => '�t���[���ڂP'},
			{'name' => 'free2', 'value' => '�t���[���ڂQ'},
			{'name' => 'free3', 'value' => '�t���[���ڂR'},
			{'name' => 'free4', 'value' => '�t���[���ڂS'},
			{'name' => 'free5', 'value' => '�t���[���ڂT'},
			{'name' => 'free6', 'value' => '�t���[���ڂU'},
			{'name' => 'free7', 'value' => '�t���[���ڂV'},
			{'name' => 'free8', 'value' => '�t���[���ڂW'},
			{'name' => 'free9', 'value' => '�t���[���ڂX'},
			{'name' => 'free10', 'value' => '�t���[���ڂP�O'},
			{'name' => 'free11', 'value' => '�t���[���ڂP�P'},
			{'name' => 'free12', 'value' => '�t���[���ڂP�Q'},
			{'name' => 'free13', 'value' => '�t���[���ڂP�R'},
			{'name' => 'free14', 'value' => '�t���[���ڂP�S'},
			{'name' => 'free15', 'value' => '�t���[���ڂP�T'},
			{'name' => 'free16', 'value' => '�t���[���ڂP�U'},
			{'name' => 'free17', 'value' => '�t���[���ڂP�V'},
			{'name' => 'free18', 'value' => '�t���[���ڂP�W'},
			{'name' => 'free19', 'value' => '�t���[���ڂP�X'},
			{'name' => 'free20', 'value' => '�t���[���ڂQ�O'},
		);
    #--------------------#
    # ���͒l�̎擾�ƌ��� #
    #--------------------#
    my @par;
    my $n = 15;
    for ( my $i=0; $i<@names; $i++ ) {
        my $indata;
        if ( (split(/<>/,$line[$n]))[0] ) {
			my $r_name = $names[$i]->{'name'};
			my $r_val = $names[$i]->{'value'};
            $indata = $param{$r_name};
            if ( (split(/<>/,$line[$n]))[2] || $names[$i]->{'name'} eq 'mail') {
            	if ( $names[$i]->{'name'} eq 'mail' ) {
                	if( &chk_email($indata) ) {
                    	&rename_unlock( $lockfull );
                    	&make_plan_page( 'plan', '', '���̓G���[<br>���[���A�h���X�̌`��������������܂���');
                    	exit;
					}
            	} else {
                	if ( $indata eq '' ) {
						my $mes = ( (split(/<>/,$line[$n]))[1] )? &deltag( (split(/<>/,$line[$n]))[1] ): $r_val;
                    	&rename_unlock( $lockfull );
                    	&make_plan_page( 'plan', '', "���̓G���[<br>[ $mes ] �ɓ��͂��Ă�������");
                    	exit;
                	}
            	}
			}
        }
        push @par, $indata;
		if( $n == 32 ){
			$n = 43;
		}else{
			$n++;
		}
        $indata='';
    }
    # ��t����
    if ( $line[38] ) {
        foreach ( (split(/,/, $line[38])) ) {
            if ( index($par[4], $_) >= 0 ) {
                &rename_unlock( $fullpath );
                &make_plan_page( 'plan', 'g', '�o�^�ł��܂���');
                exit;
            }
        }
    }
    $index = sprintf( "%05d", $index );
    my $sk = ( split(/,/, $line[35]) )[1];
    my $res = $param{'res'};
    my $check = ( $sk || $res )? '': 0;
    unshift @par, $index;
    splice( @par, 19, 0, $date );  # �o�^���i�b�j
    splice( @par, 20, 0, $check ); # �ŏI�z�M��
    splice( @par, 21, 0, $date );  # �ŏI�z�M���i�b�j
    my $line =  join("\t", @par) . "\n";
    my $senderror;
    if ( !$sk && !$res ) {
        # �o�^���[���̑��M
        my $rh_body = &get_body( $queuepath );
        $line[9] =~ s/<br>/\n/gi;
        $line[10] =~ s/<br>/\n/gi;
        $line[11] =~ s/<br>/\n/gi;
        local ( $subject, $message ) = &make_send_body( 0, $rh_body, $line[9], $line[10], $line[11] );
        $subject = &include( \@par, $subject );
		$message = &include( \@par, $message );
        if ( !$sk && !$res ) {
			$senderror = &send( $line[4], $line[3], $par[5], $subject, $message );
			# �z�M���O�ɒǉ�
        	unless ( $senderror ) {
            	open(LOG, ">>$logpath");
            	print LOG "$par[0]\t$par[5]\t$par[3]\t$date\t0\t$subject\n";
            	close(LOG);
        	}else{
				&make_plan_page( 'plan', '', '�o�^�ł��܂���');
        	}
		}
        # �Ǘ��҈��֑��M
		#if ( $line[40] ) {
		#	$senderror = &send( $line[4], $line[3], $line[5], $subject, $message );
		#}
    }
    #-------#
    # �ǉ�  #
    #-------#
    open(CSV, ">>$csvpath");
    print CSV $line;
    close(CSV);
    &rename_unlock( $lockfull );
    # ���_�C���N�g
    &make_plan_page( 'plan', 'guest' );
    exit;
}
#------------------------------------------------------#
# �Ǘ��҂ɂ�郆�[�U�[�̕ύX�A����                     #
#------------------------------------------------------#
sub ____renewguest {
    my $id = $param{'id'} - 0;
    my $mail = $param{'mail'};
    my $nmail = $param{'nmail'};
    if ( &chk_email($mail) || ($mode eq 'renew' && &chk_email($nmail)) ) {
        &rename_unlock( $lockfull );
        &make_plan_page( 'plan', 'g', '���[���A�h���X�̌`��������������܂���');
        exit;
    }
    my $number;
    my $fnum;
    my $mes;
    my $target;
    my $turl;
    if ($mode eq 'renew') {
        $number = 33;
        $fnum = 2;
        $target = 'r';
        $turl = 13;
        $mes = '���[���A�h���X��ύX���܂���';
    }elsif ($mode eq 'cancel') {
        $number = 34;
        $fnum = 3;
        $target = 'c';
        $turl = 14;
        $mes = '�o�^���������܂���';
    }
    my $lockfull = &lock();
    #--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
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
            last;
        }
    }
    close(PLAN);
    #--------------------------------#
	# �����̓o�^�҃f�[�^����ID���擾 #
	#--------------------------------#
    my $index;
    unless ( $csvpath ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�Y������f�[�^������܂���");
		exit;
	}
    unless ( open(CSV, "$csvpath") ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>$csvpath���J���܂���");
		exit;
	}
    my $tmp = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
    unless ( open(TMP, ">$tmp") ) {
        &rename_unlock( $lockfull );
		&make_plan_page( 'plan', 'g', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����J���܂���<br>$data_dir�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	chmod 0606, $tmp;
    my $flag = 0;
    my @csvs;
    while( <CSV> ) {
        chomp;
        my @csv = split(/\t/);
        if ( $mail eq $csv[5] ) {
            $flag = 1;
            if ( $formck & $csv[0] ne $userid ) {
                unlink $tmp;
                &rename_unlock( $lockfull );
                &make_plan_page( 'plan', 'g', "ID����v���܂���");
                last;
            }
            if ( $mode eq 'renew' ) {
                $csv[5] = $nmail;
                $_ = join("\t", @csv);
                @csvs = @csv;
            } else {
                @csvs = @csv;
                next;
            }
        }
        print TMP "$_\n";
    }
    if ( !$flag ) {
        unlink $tmp;
        &rename_unlock( $lockfull );
        &make_plan_page( 'plan', 'g', "���[���A�h���X����v���܂���");
    }
    close(TMP);
    close(CSV);
    my $res = $param{'res'};
    my $senderror;
    if ( !$sendck && !$res ) {
        # �ύX�A�������[���̑��M
        my $rh_body = &get_body( $queuepath );
        $line[9] =~ s/<br>/\n/gi;
        $line[10] =~ s/<br>/\n/gi;
        $line[11] =~ s/<br>/\n/gi;
        local ( $subject, $message ) = &make_send_body( $target, $rh_body, $line[9], $line[10], $line[11] );
        $subject = &include( \@csvs, $subject );
		$message = &include( \@csvs, $message );
        $senderror = &send( $line[4], $line[3], $csvs[5], $subject, $message );
        # �z�M���O�ɒǉ�
        my $now = time;
        unless ( $senderror ) {
            open(LOG, ">>$logpath");
            print LOG "$csvs[0]\t$csvs[5]\t$cavs[3]\t$now\t$target\t$subject\n";
            close(LOG);
        }else{
            &rename_unlock( $lockfull );
            unlink $tmp;
            &make_plan_page( 'plan', 'g', "$mes");
        }
    }
    rename $tmp, $csvpath;
    &rename_unlock( $lockfull );
    # ���_�C���N�g
    &make_plan_page( 'plan', 'guest' );
    exit;
}

#--------------------------#
# �o�^�҃f�[�^���擾       #
#--------------------------#
sub get_csvdata {
    my ( $id, $userid ) = @_;
    #--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
    my $csvpath;
    while( <PLAN> ) {
        chomp;
        my ( $index, $csv ) = ( split(/\t/) )[0, 6];
        if ( $index eq $id ) {
            $csvpath = "$myroot$data_dir$csv_dir$csv";
            last;
        }
    }
    close(PLAN);
    #--------------------------------#
	# �����̓o�^�҃f�[�^����ID���擾 #
	#--------------------------------#
    my $index;
    unless ( open(CSV, "$csvpath") ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>$csvpath���J���܂���");
		exit;
	}
    if ( $userid eq '' ) {
        return <CSV>;
    }
    while( <CSV> ) {
        chomp;
        my @csvs = split(/\t/);
        if ( $csvs[0] eq $userid ) {
            return @csvs;
            last;
        }
    }
    close(CSV);
	&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�Y������f�[�^������܂���");
	exit;
}

#----------------------------#
# �o�^�ҏ��y�[�W����̍X�V #
#----------------------------#
sub guest {
	
    my $id = $param{'id'} - 0;
	
	#---------------------#
	# �r������            #
	#---------------------#
	my $lockfull = &lock();
	
    #--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	my @line;
	my $csvpath;
	my $queuepath;
	my $logpath;
	my $count;
	my %ra_conf;
	while( <PLAN> ) {
		chomp;
		@line = split(/\t/);
		if ( $line[0] eq $id ) {
			$csvpath   = "$myroot$data_dir$csv_dir$line[6]";
			$queuepath = "$myroot$data_dir$queue_dir$line[7]";
			$logpath   = "$myroot$data_dir$log_dir$line[8]";
			$count = (split( /,/, $line[35]) )[0];
			$dck       = $line[42];
			&Pub'ssl($line[83]);
			last;
		}
	}
	close(PLAN);
	
    my $userid = &deltag( $param{'n'} );
	my $def_mail = &deltag( $param{'def_mail'} );
    my $co     = &deltag( $param{'co'} );
    my $_co    = &deltag( $param{'_co'} );
    my $name   = &deltag( $param{'name'} );
    my $_name  = &deltag( $param{'_name'} );
    my $mail   = $param{'mail'};
	
	# �z�M���X�V
	my $reStep = 0;
	my $step = $param{'step'};
	my $stop = $param{'stop'};
	my $interval = $param{'interval'};
	my $restart;
	my $sendStepNum;
	my $baseStepNum;
	
	if( defined $param{"stepInfo"} ){
		$reStep = 1;
	}else{
		if ( !defined $param{'de'} && &chk_email($mail) ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "���[���A�h���X�̌`��������������܂���");
			exit;
		}
		if ( !defined $param{'de'} && $mail eq '' ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "���[���A�h���X����͂��Ă�������");
			exit;
		}
	}
	
	# �ǉ��Ɣz�M���X�V�̏ꍇ
	my $stopFlag = 0;
	if( !defined $param{'re'} && !defined $param{'de'} ){
		if( $step ne 'end' ){
			my( $inter, $config ) = split( /\//, ( split( /,/, (split(/<>/,$line[36]))[0] ) )[$step-2] );
			if( $config ){
				$stopFlag = 1;
				if( !$reStep && $interval <= 0 ){
					&rename_unlock( $lockfull );
					&make_plan_page( 'plan', '', "�z�M�J�n�����w�肵�Ă��������B");
					exit;
				}
			}else{
				$interval = '';
			}
		}
	}
	
    my $tel      = &deltag( $param{'tel'} );
    my $fax      = &deltag( $param{'fax'} );
    my $url      = &deltag( $param{'url'} );
    my $code     = &deltag( $param{'code'} );
    my $address  = &deltag( $param{'address'} );
    my $address1 = &deltag( $param{'address1'} );
    my $address2 = &deltag( $param{'address2'} );
    my $address3 = &deltag( $param{'address3'} );
    my $free1    = &deltag( $param{'free1'} );
    my $free2    = &deltag( $param{'free2'} );
    my $free3    = &deltag( $param{'free3'} );
    my $free4    = &deltag( $param{'free4'} );
    my $free5    = &deltag( $param{'free5'} );
	my $free6    = &deltag( $param{'free6'} );
    my $free7    = &deltag( $param{'free7'} );
    my $free8    = &deltag( $param{'free8'} );
    my $free9    = &deltag( $param{'free9'} );
    my $free10   = &deltag( $param{'free10'} );
	my $free11   = &deltag( $param{'free11'} );
    my $free12   = &deltag( $param{'free12'} );
    my $free13   = &deltag( $param{'free13'} );
    my $free14   = &deltag( $param{'free14'} );
    my $free15   = &deltag( $param{'free15'} );
	my $free16   = &deltag( $param{'free16'} );
    my $free17   = &deltag( $param{'free17'} );
    my $free18   = &deltag( $param{'free18'} );
    my $free19   = &deltag( $param{'free19'} );
    my $free20   = &deltag( $param{'free20'} );
	my $free21   = &deltag( $param{'free21'} );
    my $free22   = &deltag( $param{'free22'} );
    my $free23   = &deltag( $param{'free23'} );
    my $free24   = &deltag( $param{'free24'} );
    my $free25   = &deltag( $param{'free25'} );
	my $free26   = &deltag( $param{'free26'} );
    my $free27   = &deltag( $param{'free27'} );
    my $free28   = &deltag( $param{'free28'} );
    my $free29   = &deltag( $param{'free29'} );
    my $free30   = &deltag( $param{'free30'} );
	
	my $sei      = &deltag( $param{'sei'} );
	my $_sei     = &deltag( $param{'_sei'} );
	my $mei      = &deltag( $param{'mei'} );
	my $_mei     = &deltag( $param{'_mei'} );
	
	# �������ڂƂ����O���ڂ̘A��
	if( $sei ne '' || $mei ne '' ){
		$name = $sei . $mei;
	}
	if( $_sei ne '' || $_mei ne '' ){
		$_name = $_sei . $_mei;
	}
	
    my $date = time;
	
	#--------------------------------#
	# �����̓o�^�҃f�[�^����ID���擾 #
	#--------------------------------#
	my $index;
	unless ( open(CSV, "$csvpath") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>$csvpath���J���܂���");
		exit;
	}
	my $tmp = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
	unless ( open(TMP, ">$tmp") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����J���܂���<br>$csv_dir�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	chmod 0606, $tmp;
	my @csvs;
	my %Email;
	my $M_index = 0;
	while( <CSV> ) {
		chomp;
		$M_index++;
		@csv = split(/\t/);
		my $tar_mail;
		if ( $csv[0] eq $userid && $def_mail eq $csv[5] ) {
			# �z�M���X�V
			if( $reStep ){
				my $nextStep = ( $csv[20] > 1 )? $csv[20]+1: 2;
				
				if( $csv[51] ne '' ){
					# �w���̏ꍇ
					if( $csv[51] ne $step ){
						if( $stopFlag && $interval <= 0 ){
							close(TMP);
							unlink $tmp;
							&rename_unlock( $lockfull );
							&make_plan_page( 'plan', '', "�z�M�J�n�����w�肵�Ă��������B");
							exit;
						}
						$csv[52] = '';
						my $now = time;
						$csv[54] = ( $step eq 'end' || !$stopFlag )? '': qq|$interval/$now|;
						
						my $bsseStepNum = &getBaseNum( $line[36],$step );
						my $cur_bsseStepNum = &getBaseNum( $line[36],$csv[20] );
						if( $bsseStepNum != $cur_bsseStepNum ){
							my %sendLog;
							foreach( split( /<>/, $csv[53]) ){
								my( $n, $date ) = split(/\//);
								$sendLog{$n} = $date;
							}
							$sendLog{$bsseStepNum} = time;
							my @result;
							foreach( sort{ $a <=> $b } keys %sendLog ){
								push @result, qq|$_/$sendLog{$_}|;
							}
							$csv[53] = join( "<>", @result );
						}
					}
				}else{
					# �ʏ�̃X�e�b�v�̏ꍇ
					if( $nextStep ne $step ){
						if( $stopFlag && $interval <= 0 ){
							close(TMP);
							unlink $tmp;
							&rename_unlock( $lockfull );
							&make_plan_page( 'plan', '', "�z�M�J�n�����w�肵�Ă��������B");
							exit;
						}
						$csv[52] = '';
						my $now = time;
						$csv[54] = ( $step eq 'end' || !$stopFlag )? '': qq|$interval/$now|;
						
						my $bsseStepNum = &getBaseNum( $line[36],$step );
						my $cur_bsseStepNum = &getBaseNum( $line[36],$csv[20] );
						if( $bsseStepNum != $cur_bsseStepNum ){
							my %sendLog;
							foreach( split( /<>/, $csv[53]) ){
								my( $n, $date ) = split(/\//);
								$sendLog{$n} = $date;
							}
							$sendLog{$bsseStepNum} = time;
							my @result;
							foreach( sort{ $a <=> $b } keys %sendLog ){
								push @result, qq|$_/$sendLog{$_}|;
							}
							$csv[53] = join( "<>", @result );
						}
						
						
					}else{
						# �z�M�ĊJ�̏ꍇ
						if( $csv[52] && !$stop ){
							$restart = 1;
							$sendStepNum = ( $csv[20] > 1 )? $csv[20]+1: 2;
							$csv[54] = '';
						}
					}
				}
				$csv[51] = $step if( $step eq 'end' || $nextStep < $step );
				# �z�M�ς݂̎�����w�肳��Ă��ꍇ�A�ʏ�ɖ߂�
				$csv[51] = ''if( $nextStep == $step );
				@csvs = @csv;
				$_ = join( "\t", @csv );
			}
			# �o�^�ҏ��X�V
			elsif ( defined $param{'re'} ) {
				my $_address = ( $address eq '' )? $csv[10]: $address;
				$_  = "$csv[0]\t$co\t$_co\t$name\t$_name\t$mail\t$tel\t$fax\t$url\t$code\t$_address\t$address1\t$address2\t$address3\t";
				$_ .= "$free1\t$free2\t$free3\t$free4\t$free5\t$csv[19]\t$csv[20]\t$csv[21]\t$free6\t$free7\t$free8\t$free9\t$free10\t";
				$_ .= "$free11\t$free12\t$free13\t$free14\t$free15\t$free16\t$free17\t$free18\t$free19\t$free20\t";
				$_ .= "$sei\t$_sei\t$mei\t$_mei\t";
				$_ .= "$free21\t$free22\t$free23\t$free24\t$free25\t$free26\t$free27\t$free28\t$free29\t$free30\t";
				$_ .= "$csv[51]\t$csv[52]\t$csv[53]\t$csv[54]";
				@csvs = split(/\t/,$_);
				$tar_mail = $mail;
			}
			# �o�^�폜
			elsif ( defined $param{'de'} ) {
				@csvs = split(/\t/,$_);
				next;
			}
		}else{
			$tar_mail = $csv[5];
		}
		$index = $csv[0] if( $index < $csv[0] );
		print TMP "$_\n";
		
		if( !$dck && $Email{$tar_mail}>0 && !defined $param{'de'}  && !$reStep ) {
			close(TMP);
			unlink $tmp;
			&rename_unlock( $fullpath );
			&make_plan_page( 'plan', '', qq|<font color="#CC0000">���̓G���[</font><br><br>���[���A�h���X���d�����Ă��܂��B<br>�d���������[���A�h���X <strong><font color="#0000EE">$tar_mail</font> [ Line: $Email{$tar_mail} $M_index ]</strong><br><br>�y�o�^�ݒ�z�o�^���[���A�h���X�̏d�������ɐݒ肷�邩�A<br>�d������f�[�^���폜���Ă��������B|);
			exit;
		}
		$Email{$tar_mail} = $M_index;
	}
	$index++;
	my $target;
	my $res = $param{'res'};
	my @sends = split(/,/, $line[35]);
	my $sendck;
	if ( defined $param{'re'} ) {
		$target = 'r';
		$sendck = $sends[2];
	}elsif ( defined $param{'de'} ) {
		$target = 'c';
		$sendck = $sends[3];
	}elsif( !$reStep ) {
		
		if( !$dck && $Email{$mail}>0 ) {
			close(TMP);
			unlink $tmp;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', qq|<font color="#CC0000">���̓G���[</font><br><br>���[���A�h���X���d�����Ă��܂��B[ <strong>Line: $Email{$mail}</strong> ]<br><br>�y�o�^�ݒ�z�o�^���[���A�h���X�̏d�������ɐݒ肵�Ă��������B|);
			exit;
		}
		$sendck = $sends[1];
		$target = 0;
		$snumber = ( !$res && !$sendck )? 0: '';
		$index = sprintf( "%05d", $index );
		# �z�M���
		$step = '' if( $step == 2 || $count <= 0 );
		my $sendlog;
		if( $step ne '' ){
			my $baseNum = &getBaseNum( $line[36], $step );
			if( $baseNum > 1 ){
				my $now = time;
				$sendlog = qq|$baseNum/$now|;
			}
		}
		
		my $newline = qq|$index\t$co\t$_co\t$name\t$_name\t$mail\t$tel\t$fax\t$url\t$code\t$address\t$address1\t$address2\t$address3\t|;
		$newline .= qq|$free1\t$free2\t$free3\t$free4\t$free5\t|;
		$newline .= qq|$date\t$snumber\t$date\t|;
		$newline .= qq|$free6\t$free7\t$free8\t$free9\t$free10\t|;
		$newline .= qq|$free11\t$free12\t$free13\t$free14\t$free15\t$free16\t$free17\t$free18\t$free19\t$free20\t|;
		$newline .= qq|$sei\t$_sei\t$mei\t$_mei\t|;
		$newline .= qq|$free21\t$free22\t$free23\t$free24\t$free25\t$free26\t$free27\t$free28\t$free29\t$free30\t|;
		$newline .= qq|$step\t\t$sendlog\t$interval|;
		print TMP "$newline\n";
		@csvs = split(/\t/, $newline);
		
	}
	close(CSV);
	close(TMP);
	# �ȈՃ^�O�}���p�ɏC��
	#splice( @csvs, 19, 3 );
	if ( !$res && !$sendck) {
		# �ύX�A�������[���̑��M
		my $rh_body = &get_body( $queuepath );
		$line[9] =~ s/<br>/\n/gi;
		$line[10] =~ s/<br>/\n/gi;
		$line[11] =~ s/<br>/\n/gi;
		local ( $subject, $message ) = &make_send_body( $target, $rh_body, $line[9], $line[10], $line[11] );
		
		my $forward_urls;
		my $uniq = $id. '-0';
		if( $target eq '0' ){
			# ���M�ςݒZ�kURL���擾
			my $forward = &Click'getForward_url();
			#---------------------------#
			# �]���p�^�O�擾            #
			#---------------------------#
			my( $urlTag, $other ) = &Click'roadTag( $line[82] );
			# �]���^�O�ϊ�
			($message, $forward_urls) = &Click'analyTag($csvs[0], $message, $urlTag, $uniq, $forward);
		}
		
		my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
		$subject = &include( \@csvs, $subject );
		$message = &include( \@csvs, $message, $jis );
		$senderror = &send( $line[4], $line[3], $csvs[5], $subject, $message, '' );
		# �z�M���O�ɒǉ�
		my $now = time;
		unless ( $senderror ) {
			open(LOG, ">>$logpath");
			print LOG "$csvs[0]\t$csvs[5]\t$csvs[3]\t$now\t$target\t$subject\n";
			close(LOG);
			# �A�N�Z�X�W�v�p�f�[�^����
			&Click'setForward_t( $forward_urls, $uniq ) if( $target eq '0' );
		}else{
			unlink $tmp;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', 'g', '���[�����M�Ɏ��s���܂���');
			exit;
		}
	}
	rename $tmp, $csvpath;
	&rename_unlock( $lockfull );
	
	if( $restart ){
		&restart_action( $id, $userid, $sendStepNum );
	}
	
	&make_plan_page( 'plan', 'guest' );
	exit;
}

#-------------------------#
# �o�^��CSV�̃_�E�����[�h #
#-------------------------#
sub csv {
	
	my $id = $param{'id'} - 0;
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, $file) ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>$file���J���܂���");
		exit;
	}
	my $path;
	while( <PLAN> ) {
		chomp;
		my ( $index, $csv ) = ( split(/\t/) )[0, 6];
		if ( $index eq $id ) {
			$path = "$myroot$data_dir$csv_dir$csv";
			last;
		}
	}
	close(PLAN);
	unless ( $path ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>�Y������f�[�^������܂���");
		exit;
	}
	unless ( open(CSV, "$path") ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>$path���J���܂���");
		exit;
	}
	my @csvdata;
	while( <CSV> ) {
		chomp;
		my @csvs;
		my @lines = split(/\t/);
		#my @seimei = splice( @lines, 37, 4 );
		#my @senddata = splice( @lines, 19, 3 );
		my $date = &make_date( $lines[19] );
		#my $email = splice( @lines, 5, 1 );
		
		$csvs[0] = $lines[5];
		$csvs[1] = $lines[1];
		$csvs[2] = $lines[2];
		$csvs[3] = $lines[37];
		$csvs[4] = $lines[38];
		$csvs[5] = $lines[39];
		$csvs[6] = $lines[40];
		$csvs[7] = $lines[3];
		$csvs[8] = $lines[4];
		$csvs[9] = $lines[6];
		$csvs[10] = $lines[7];
		$csvs[11] = $lines[8];
		$csvs[12] = $lines[9];
		$csvs[13] = $lines[10];
		$csvs[14] = $lines[11];
		$csvs[15] = $lines[12];
		$csvs[16] = $lines[13];
		$csvs[17] = $lines[14];
		$csvs[18] = $lines[15];
		$csvs[19] = $lines[16];
		$csvs[20] = $lines[17];
		$csvs[21] = $lines[18];
		$csvs[22] = $lines[22];
		$csvs[23] = $lines[23];
		$csvs[24] = $lines[24];
		$csvs[25] = $lines[25];
		$csvs[26] = $lines[26];
		$csvs[27] = $lines[27];
		$csvs[28] = $lines[28];
		$csvs[29] = $lines[29];
		$csvs[30] = $lines[30];
		$csvs[31] = $lines[31];
		$csvs[32] = $lines[32];
		$csvs[33] = $lines[33];
		$csvs[34] = $lines[34];
		$csvs[35] = $lines[35];
		$csvs[36] = $lines[36];
		$csvs[37] = '';
		$csvs[38] = '';
		$csvs[39] = $date;
		$csvs[40] = $lines[41];
		$csvs[41] = $lines[42];
		$csvs[42] = $lines[43];
		$csvs[43] = $lines[44];
		$csvs[44] = $lines[45];
		$csvs[45] = $lines[46];
		$csvs[46] = $lines[47];
		$csvs[47] = $lines[48];
		$csvs[48] = $lines[49];
		$csvs[49] = $lines[50];
		my $line = '';
		foreach( @csvs ){
			s/<br>/\n/ig;
			s/"/""/g;
			$line .= ',' if( $line ne '');
			$line .= qq|"$_"|;
		}
		push @csvdata, "$line\n";
	}
	close(CSV);
	my $filename = $id . '.csv';
	print qq|Content-Disposition: attachment; filename="$filename"| , "\n";
	print "Content-type: application/x-csv", "\n";
	# print "Content-length: ", "\n";
	print "\n";
	print @csvdata;
	exit;
	
}

#-------------------------#
# �o�^��CSV�̃A�b�v���[�h #
#-------------------------#
sub upload {
	
	my $id       = $param{'id'} - 0;
	my $file     = "$myroot$data_dir$log_dir$plan_txt";
	my $filedata = $param{'csvfile'};
	my $stepNum = &delspace($param{'step'});
	my $interval = &delspace($param{'interval'});
	
	# �o�^�ςݏd�����X�g
	my %mail_overlap;
	# �󃊃X�g
	my %mail_undef;
	# �s���A�h���X���X�g
	my %mail_format;
	# �d���A�h���X
	my %mail_repeat;
	# �o�^�ς݃��X�g�i�ǉ��̏ꍇ�j
	my %mail_alr;
	# �G���[�t���O
	my $errflag = 0;
	
	if( $param{'addcheck'} eq '' ){
		&main'make_plan_page( 'plan', '', "�A�b�v���[�h������I�����Ă��������B", '1' );
	}
	
	my $addcheck = $param{'addcheck'} - 0; # �ǉ��A�b�v���[�h�t���O
	my $sendflag = $param{'sendflag'} - 0;     # �o�^�����M�t���O
	my $dup      = $param{'dup'} - 0; # �d���폜
	
	my $csvfilename = &the_filedata( 'csvfile' );
	if ( $csvfilename !~ /\.csv$/ ) {
		&make_plan_page( 'plan', '', "�X�V�G���[<br>CSV�t�@�C�����w�肵�Ă�������");
	}
	
	unless ( open(PLAN, $file) ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>$file���J���܂���");
		exit;
	}
	my $path;
	my $dck;
	my $step;
	my $schedule;
	while( <PLAN> ) {
		chomp;
		my ( $index, $csv, $_step, $_schedule, $check ) = ( split(/\t/) )[0, 6, 35, 36, 42 ];
		if ( $index eq $id ) {
			$path = "$myroot$data_dir$csv_dir$csv";
			$dck  = $check;
			$step = $_step;
			$schedule = $_schedule;
			last;
		}
	}
	close(PLAN);
	unless ( $path ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>�Y������f�[�^������܂���");
		exit;
	}
	my $In = 0;
	my $count = (split( /,/, $step ))[0];
	my @step = split( /,/, (split(/<>/,$schedule))[0] );
	for( my $i=0; $i<$count; $i++ ){
		my $n = $i+2;
		my( $inter, $config ) = split(/\//,$step[$i]);
		if( $n eq $stepNum ){
			$In = 1;
			if( $config ){
				if( $interval <= 0 ){
					&make_plan_page( 'plan', '', "�z�M�J�n�����w�肵�Ă��������B");
					exit;
				}
				my $now = time;
				$interval = qq|$interval/$now|;
			}else{
				$interval = '';
			}
		}
	}
	my $sendlog;
	if( $step ne '' ){
		my $baseNum = &getBaseNum( $schedule, $stepNum );
		if( $baseNum > 1 ){
			my $now = time;
			$sendlog = qq|$baseNum/$now|;
		}
	}
	
	if( $stepNum > 1 && !$In ){
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>�w�肵���z�M��́A�폜���ꂽ�\\��������܂��B<br>�ŐV�̓��������m�F���������B");
		exit;
	}
	
	my $lockfull = &lock();
	unless ( open(CSV, "$path") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>$path���J���܂���");
		exit;
	}
	my $tmp = "$myroot$data_dir$csv_dir" . time . $$ . '.tmp';
	unless ( open(TMP, ">$tmp") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>$path���J���܂���");
		exit;
	}
	chmod 0606, $tmp;
	
	#--------------------------------------
	# �o�^�����M�̏ꍇ
	#--------------------------------------
	my $regist_path;
	if( $sendflag ){
		$regist_path = "$myroot$data_dir$csv_dir" . 'REG-'. time. $$ . "-$id" . '.cgi';
		unless ( open(REG, ">>$regist_path") ) {
			close(TMP);
			unlink $tmp;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "�V�X�e���G���[<br>�t�@�C�����쐬�ł��܂���B$csv_dir�̃p�[�~�b�V���������m�F���������B");
			exit;
		}
		chmod 0606, $regist_path;
	}
	
	my $now = time;
	my $max = 0;
	my %CSV;
    while( <CSV> ) {
		chomp;
		my ( $id, $email ) = ( split(/\t/) )[0,5];
		$max = $id if ( $max < $id );
		if( defined $CSV{$email} ) {
			next if( $dup ); # �d���폜
			push @{ $CSV_RAP{$email} }, $_;
			next;
		}
		$CSV{$email} = $_;
	}
	close(CSV);
	my @senddata = ( $now, '', $now );
	my $n        = 0;
	my $newaddr  = 0;
	
	my $csvindex = 0;
	my @csvdata = split( /\r?\n|\r/, $filedata );
	for( my $csvindex=0; $csvindex <= $#csvdata; $csvindex++) {
		
		$line = $csvdata[$csvindex];
		# �s����i�߂�
		$n++;
		
		while( $line =~ tr/"// % 2 && $csvindex < $#csvdata ){
			$csvindex++;
			$_line = $csvdata[$csvindex];
			$line .= "\n$_line";
		}
		$line =~ s/(?:\x0D\x0A|[\x0D\x0A])?$/,/;
		my @lines = map {/^"(.*)"$/s ? scalar($_ = $1, s/""/"/g, $_) : $_}
                ($line =~ /("[^"]*(?:""[^"]*)*"|[^,]*),/g);
		my $newline = join("\t",@lines);
		$newline =~ s/"//g;
		$newline = &deltag( $newline );
		$newline = &the_text( $newline );
		my @line = split( /\t/, $newline );
		
		# �\���E�o�^�������ڂ��폜
		splice( @line, 37, 3 );
		my $email = shift @line;
		my @seimei = splice( @line, 2, 4 );
		if( $seimei[0] ne '' || $seimei[2] ne '' ){
			$line[2] = $seimei[0] . $seimei[2];
		}
		if( $seimei[1] ne '' || $seimei[3] ne '' ){
			$line[3] = $seimei[1] . $seimei[3];
		}
		$email = &delspace( $email );
		
		#------------------------------
		# ��`�F�b�N
		#------------------------------
		if( $email eq '' ){
			$mail_undef{$n} = 1;
			next;
		}
		#------------------------------
		# ���[���A�h���X�`���`�F�b�N
		#------------------------------
		if( &chk_email($email) ){
			$mail_format{$n} = $email;
			next;
		}
		#------------------------------
		# �d���`�F�b�N
		#------------------------------
		if( $Email{$email} ) {
			if( $dup ){
				next;
			}
			$mail_repeat{$n} = $email;
			next;
		}
		
		#------------------------------
		# �o�^�ς݃`�F�b�N(�ǉ��̏ꍇ)
		#------------------------------
		if( $addcheck && $CSV{$email} ne '' ) {
			if( $dup ){
				next;
			}
			$mail_alr{$n} = $email;
			next;
		}
		
		if( $CSV{$email} eq '' ) {
			$max++; # ID��i�߂�
			$newaddr++;
			my $id = sprintf( "%05d", $max );
			unshift @line, $id;
			
			if( $#line < 5 ){
				$line[5] = $email;
				
			}else{
				splice( @line, 5, 0, $email );
			}
			if( $#line < 19 ){
				$line[19] = $now;
				$line[20] = '';
				$line[21] = $now;
			}else{
				splice( @line, 19,0, @senddata );
			}
			
			if( $#line < 37 ){
				$line[37] = $seimei[0];
				$line[38] = $seimei[1];
				$line[39] = $seimei[2];
				$line[40] = $seimei[3];
			}else{
				splice( @line, 37, 0, @seimei );
			}
			
			if( $#line < 51 ){
				$line[51] = $stepNum if( $stepNum > 2 || $stepNum eq 'end' );
			}else{
				splice( @line, 51, 0, $stepNum ) if( $stepNum > 2 || $stepNum eq 'end' );
			}
			if( $#line < 53 ){
				$line[53] = $sendlog;
			}else{
				splice( @line, 53, 0, $sendlog );
			}
			if( $#line < 54 ){
				$line[54] = $interval;
			}else{
				splice( @line, 54, 0, $interval );
			}
			
			my $sendlist = join( "\t", @line );
			print REG "$sendlist\n";
			
		}else{
			
			if( @{ $CSV_RAP{$email} } > 0 ){
				print TMP "$CSV{$email}\n";
				foreach my $line ( @{ $CSV_RAP{$email} } ){
					print TMP "$line\n";
				}
				$mail_overlap{$n} = $email if( !$addcheck );
				$Email{$email} = $n;
				next;
			}
			
			my ( $id, @senddata ) = ( split(/\t/, $CSV{$email}) )[0,19,20,21, 51,52,53,54];
			unshift @line, $id;
			if( $#line < 5 ){
				$line[5] = $email;
				
			}else{
				splice( @line, 5, 0, $email );
			}
			if( $#line < 19 ){
				$line[19] = $senddata[0];
				$line[20] = $senddata[1];
				$line[21] = $senddata[2];
			}else{
				my @stepInfo = ($senddata[0],$senddata[1],$senddata[2]);
				splice( @line, 19,0, @stepInfo );
			}
			
			if( $#line < 37 ){
				$line[37] = $seimei[0];
				$line[38] = $seimei[1];
				$line[39] = $seimei[2];
				$line[40] = $seimei[3];
			}else{
				splice( @line, 37, 0, @seimei );
			}
			
			if( $#line < 51 ){
				$line[51] = $senddata[3];
				$line[52] = $senddata[4];
				$line[53] = $senddata[5];
				$line[54] = $senddata[6];
			}else{
				my @stepInfo = ($senddata[3],$senddata[4],$senddata[5], $senddata[6]);
				splice( @line, 51, 0, @stepInfo );
			}
		}
		
		my $new = join( "\t", @line );
		print TMP "$new\n";
		$Email{$email} = $n;
	}
	close(TMP);
	close(REG);
	#------------------------------------------------
	# �G���[�s�̊m�F
	#------------------------------------------------
	my $errflag = 0;
	if( keys %mail_overlap ){
		$param{'mail_overlap'} = {%mail_overlap};
		$errflag = 1;
	}
	if( keys %mail_undef ){
		$param{'mail_undef'} = {%mail_undef};
	}
	if( keys %mail_format ){
		$param{'mail_format'} = {%mail_format};
		$errflag = 1;
	}
	if( keys %mail_repeat ){
		$param{'mail_repeat'} = {%mail_repeat};
		$errflag = 1;
	}
	if( keys %mail_alr ){
		$param{'mail_alr'} = {%mail_alr};
		$errflag = 1;
	}
	
	if( $addcheck ){
		my $tmp2 = $myroot. $data_dir. $csv_dir. 'UP-'. $$. time. '.cgi';
		open( TMP, "<$tmp ");
		open( CSV, "<$path" );
		open( TEMPLATE, ">$tmp2");
		while(<CSV>){
			print TEMPLATE $_;
		}
		while(<TMP>){
			print TEMPLATE $_;
		}
		close(CSV);
		close(TMP);
		close(TEMPLATE);
		chmod 0606, $tmp2;
		rename $tmp2, $path;
		unlink $tmp;
	}else{
		chmod 0606, $tmp;
		rename $tmp, $path;
	}
	chmod 0606, $path;
	&rename_unlock( $lockfull );
	#--------------------------
	# �ʏ�I��
	#--------------------------
	
	# �o�^�����[���̑Ώۂ��Ȃ��ꍇ
	if( $sendflag ){
		if( $newaddr <= 0 ){
			unlink $regist_path;
			$sendflag = 0;
		}
	}
	
	#--------------------------------------------------------------
	# �o�^�����M�̏ꍇ�́AJavascrpt�𗘗p���Ĕz�M�^�O��\������
	#--------------------------------------------------------------
	if( $sendflag ){
		# ���M����
		my $session = &regsender($id, $regist_path);
		local( $method, $each, $sleep, $partition ) = &send_method( \@errors );
		# �����z�M
		if( $method ){
			&make_plan_page('plan', 'up_error', '', '');
		}else{
		# �A�N�Z�X���z�M
			$param{'ss'} = $session;
			$param{'start'} = 1;
			&csvupload_each();
			exit;
		}
	}
	
	&make_plan_page( 'plan', 'up_error' );
	exit;
}

sub regsender
{
	my( $id,$regist_path ) = @_;
	( $session, $session_path ) = &get_csvup_session( $id );
	if( $session eq '' ){
		$session      = crypt( $cookie_id, &make_salt() );
		$session      =~ s/[\.\\\/]//g;
		$session_path = "$myroot$data_dir$csv_dir" . 'CUR-' . $session . "_$id" . '.cgi';
	}
	
	rename $regist_path, $session_path;
	return $session;
}


#-------------------------#
# �o�^�҂ւ̃��[�����M    #
#-------------------------#
sub mailsend {
	
	# �����w��y�[�W��
	if( defined $param{'simul_cdn'} ){
		&make_plan_page( 'plan', 'simul_cdn', '', '', '' );
	}
	
	if( $param{'next'} > 0 ){
		&Simul'send_manual();
	}
	&Simul'make_config();
	exit;
}

# ----------------------------------------------------------------------------------------
# �ȉ�HTML�o�͊֌W
# ----------------------------------------------------------------------------------------

#------------------------------------------------------#
# �e�\���y�[�W���̏o�̓e�[�u�����쐬���y�[�W���o�͂��� #
#------------------------------------------------------#
sub make_plan_page {
	my ( $type, $page, $error, $send, $etc ) = @_;
	my $table;
	my $pname;
	my $main_title;
	my $main_table;
	my $id = $param{'id'} - 0;
	my @line; # �f�[�^�̔z��
	my $help;
	
	#-------------------------#
	# �y�[�W�̃^�C�g��        #
	#-------------------------#
	if (    $page eq 'all' )    { $main_title = '�ڍ�'; $help = qq|"#" onClick="wopen('$self?md=manual&p=detail', 'detail');" |; }
	elsif ( $page eq 'bs' )     { $main_title = '�z�M�����'; $help = qq|"#" onClick="wopen('$self?md=manual&p=sender', 'sender');" |; }
    elsif ( $page eq 'redirect'){ $main_title = '�o�^�ݒ�'; $help = qq|"#" onClick="wopen('$self?md=manual&p=redirect', 'redirect');" |;}
	elsif ( $page eq 'header' ) { $main_title = '�w�b�_'; $help = qq|"#" onClick="wopen('$$self?md=manual&p=header', 'header');" |; }
	elsif ( $page eq 'footer' ) { $main_title = '�t�b�^'; $help = qq|"#" onClick="wopen('$self?md=manual&p=footer', 'footer');" |; }
	elsif ( $page eq 'cl' )     { $main_title = '�����ē�'; $help = qq|"#" onClick="wopen('$self?md=manual&p=cancel', 'cnacel');" |; }
	elsif ( $page eq 'form1' )  { $main_title = '�o�^�t�H�[��'; $help = qq|"#" onClick="wopen('$self?md=manual&p=form1', 'form1');" |;}
	elsif ( $page eq 'form2' )  { $main_title = '�ύX�E�����t�H�[��'; $help = qq|"#" onClick="wopen('$self?md=manual&p=form2', 'form2');" |;}
	elsif ( $page eq 'preview' ){ $main_title = '�{���̃v���r���['; $help = qq|"#" onClick="wopen('$self?md=manual&p=preview', 'preview');"|;}
	elsif ( $page eq 'body' )   { $main_title = '�{���̕ҏW�g�b�v'; $help = qq|"#" onClick="wopen('$self?md=manual&p=body', 'body');"|;}
	# HTML�ҏW���
	elsif ( $page eq 'html' )   { $main_title = '�{��(HTML)�̕ҏW'; $help = qq|"#" onClick="javascript: return false;" |;}
	elsif ( $page eq 'schedule'){ $main_title = '�z�M����'; $help = qq|"#" onClick="wopen('$self?md=manual&p=schedule', 'schedule');" |;}
	elsif ( $page eq 'mf1' )    { $main_title = '�o�^�p�t�H�[����HTML�\�[�X'; $help = qq|"#" onClick="wopen('$self?md=manual&p=fsample1', 'fsample1');" |; }
	elsif ( $page eq 'mf2' )    { $main_title = '�ύX�p�t�H�[����HTML�\�[�X'; $help = qq|"#" onClick="wopen('$self?md=manual&p=fsample2', 'fsample2');" |; }
	elsif ( $page eq 'mf3' )    { $main_title = '�����p�t�H�[����HTML�\�[�X'; $help = qq|"#" onClick="wopen('$self?md=manual&p=fsample3', 'fsample3');" |; }
	
	# ��ʃJ�X�^�}�C�Y
	elsif ( $page eq 'ctm_regdisp' ){ my $sub_title = '�i�g�їp�j' if($param{'m'}>0); $main_title = '��ʃJ�X�^�}�C�Y'.$sub_title; $help = qq|"#" onClick="javascript: return false;" |; }
	
	elsif ( $page eq 'guest' )  { $main_title = '�o�^�ҏ��'; $help = qq|"#" onClick="wopen('$self?md=manual&p=guest', 'guest');" |; }
	elsif ( $page eq 'add' )    { $main_title = '�o�^�҂̒ǉ�'; $help = qq|"#" onClick="wopen('$self?md=manual&p=grenew', 'grenew');" |; }
	elsif ( $page eq 'ref' )    { $main_title = '�o�^�҂̕ҏW'; $help = qq|"#" onClick="wopen('$self?md=manual&p=grenew', 'grenew');" |; }
	elsif ( $page eq 'mail' )   { $main_title = '�o�^�҂Ƀ��[���𑗐M [ �{�� ]'; $help = qq|"#" onClick="wopen('$self?md=manual&p=body', 'body');"|;}
	elsif ( $page eq 'mailnext'){ $main_title = '�o�^�҂Ƀ��[���𑗐M [ �I�� ]'; $help = qq|"#" onClick="wopen('$self?md=manual&p=select', 'select');"|;}
	elsif ( $page eq 'log' )    { $main_title = '�z�M���O'; $help = qq|"#" onClick="wopen('$self?md=manual&p=log', 'log');" |; }
	elsif ( $page eq 'up' )     { $main_title = '�ꗗ���A�b�v���[�h'; $help = qq|"#" onClick="wopen('$self?md=manual&p=guest', 'guest');" |; }
	elsif ( $page eq 'up_error'){ $main_title = '�ꗗ���A�b�v���[�h'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# �����w��
	elsif ( $page eq 'simul_cdn' ){ $main_title = '�o�^�҂Ƀ��[�����M [ �����w�� ]'; $help = qq|"#" onClick="javascript: return false;" |; }
	elsif ( $page eq 'simul_cdn_conf' ){ $main_title = '�o�^�҂Ƀ��[�����M [ �����w��m�F ]'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# �v�����폜���
	elsif ( $page eq 'delete' ) { $main_title = '�z�M�v�����폜'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# �܂��܂��o�^�@�\���
	elsif ( $page eq 'magu' ){ $main_title = '�܂��܂��o�^'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# �v�����R�s�[
	elsif ( $page eq 'copy' ){ $main_title = '�R�s�[�v�����쐬'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	# �N���b�N����
	elsif ( $page eq 'click_analy' ){ $main_title = '�N���b�N���́E�v��'; $help = qq|"#" onClick="javascript: return false;" |; }
	
	if ( $error ) {
        $main_title = '�G���[';
        $page = 'error';
        $page = 'send' if ( $send ne '' );
        $main_title = '�o�^�҂Ƀ��[�����M' if ( $send ne '' );
    }
    
	#-------------------------#
	# �Y������f�[�^���擾    #
	#-------------------------#
	if ( $type eq 'plan' ) {
		my $file = $myroot . $data_dir . $log_dir . $plan_txt;
		unless ( open (FILE, $file) ) {
			&error( 'plan', '', "�V�X�e���G���[<br><br>$file���J���܂���<br>�p�[�~�b�V�������m�F���Ă�������" );
		}
		while( <FILE> ) {
			chomp;
			@line = split(/\t/);
			if( $line[0] eq $id ) {
				last;
			}else  {
				undef @line;
			}
		}
		close(FILE);
		$pname = $line[2];
		
		# �z�M���O�̂ݏ������ݐ������m�F
		my $log_path = $myroot. $data_dir. $log_dir. $line[8];
		if( !( -w $log_path ) ){
			my $tmp = $myroot. $data_dir. $log_dir. 'TMP-'. $$. time. '.cgi';
			open( LOG, "<$log_path" );
			open( TMP, ">$tmp" );
			while(<LOG>){
				print TMP $_;
			}
			close(LOG);
			close(TMP);
			chmod 0606, $tmp;
			rename $tmp, $log_path
		}
		
	}
	&Pub'ssl($line[83]);
    my $auterun = ($line[37])? '�ғ���': '��~��';
    my $run = ($line[37])? "��~����": "�ғ�����";
    my $alert = ($line[37])? "��~���܂��B��낵���ł����H": "�ғ����܂��B��낵���ł����H";
    my $link = ($line[37])? '0': '1';
    my $runlink = qq|<a href="$indexcgi\?md=run&id=$id&action=$link" onClick="return confir('$alert');"><font color="#0000FF">$run</font></a>|;
	#my $sendmsg = ($line[37])? '�z�M�����s����': '';
	#my $distance = ($line[37])? ' / ': '';
	#my $sendtag = qq|$distance<a href="#" onClick="alert('�z�M�����s���܂�');wopen('$sendpl', 'raku_mail');"><font color="#0000FF"><strong>$sendmsg</strong></font></a>|;
	
	#----------------------------#
	# ���C�������̃e�[�u�����쐬 #
	#----------------------------#
	if ( $page eq 'all' ) {
		# �ڍ�
		foreach ( @line ) {
			$_ = '&nbsp;' unless ( $_ );
		}
		$line[5] =~ s/\,/<br>/g;
		my $header = $line[9] if($line[9]  ne '&nbsp;');
		my $cancel = $line[10] if($line[10] ne '&nbsp;');
		my $footer = $line[11] if($line[11] ne '&nbsp;');
		
		$header = &make_text( $header );
		$header = &reInclude( $header );
		$header = &include( \@temdata, $header, '', 1 );
		
		$cancel = &make_text( $cancel );
		$cancel = &reInclude( $cancel );
		$cancel = &include( \@temdata, $cancel, '', 1 );
		
		$footer = &make_text( $footer );
		$footer = &reInclude( $footer );
		$footer = &include( \@temdata, $footer, '', 1 );
		
		
		# �o�^�p�t�H�[���̍쐬
		my $st = 15;
		my $end = 32;
		my( $form1, $form1_m ) = &make_form( '1', $id, 'form1', $line[12], $line[39], $line[58], $line[59], $line[81], @line[15 .. 32], @line[43 .. 57], @line[61 .. 65], @line[66 .. 75] );
        my( $form2, $form2_m ) = &make_form( '1', $id, 'form2', $line[13], $line[39], $line[58], $line[59], $line[81], $line[33] );
        my( $form3, $form3_m ) = &make_form( '1', $id, 'form3', $line[14], $line[39], $line[58], $line[59], $line[81], $line[34] );
		my $schedule = &make_schedule( $id, 0, $line[35], $line[36], $line[7] );
        my $redirect = &make_redirect_table( $line[12], $line[13], $line[14], $line[38], $line[40], $line[78], $line[79], $line[80] );
		$main_table = <<"END";
<table width="470" border="0" align="center" cellpadding="1" cellspacing="0">
          <tr>
            <td bgcolor="#000000"><table width="470" border="0" cellspacing="0" cellpadding="10">
              <tr>
                <td bgcolor="#FFFFFF"><font color="#FF0000">�y�����Ӂz<br>
                </font>�T�[�o����t�ɂȂ�ƁA�s���������\\��������̂ŁA�T�[�o�̗e�ʂɂ͂����ӂ��������B
                  ����ɔ����āA����I�Ɍڋq���X�g�y�і{���̃o�b�N�A�b�v�������ɂȂ邱�Ƃ������߂������܂��B</td>
              </tr>
            </table></td>
          </tr>
        </table><br>
                                      <table width="100%" border="1" cellpadding="3" cellspacing="1" bordercolor="#99CCFF">
                                        <tr> 
                                          <td width="100" align="left" bgcolor="#99CCFF">�z�M�v������</td>
                                          <td>$line[2]</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#99CCFF">�z�M����</td>
                                          <td>$line[3]</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�z�M���A�h���X</td>
                                          <td>$line[4]</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�Ǘ��҃A�h���X</td>
                                          <td>$line[5]</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�z�M����</td>
                                          <td>$schedule</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�w�b�_�[</td>
                                          <td>$header&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�����ē�</td>
                                          <td>$cancel&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�t�b�^�[</td>
                                          <td>$footer&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�o�^�ݒ�</td>
                                          <td>$redirect
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�o�^�p�t�H�[��</td>
                                          <td>$form1<a href="$index?md=mf1&id=$id"><font color="#0000FF">HTML�\\�[�X�̃T���v����\\��</font></a><br><a href="javascript: void(0);" onClick="wopen('$main'indexcgi?md=manual&p=html_edit', 'html_edit', 840, 360);"><font color="#0000FF">���E�������ɕҏW������@�ɂ���</font></a></td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�ύX�t�H�[��</td>
                                          <td>$form2<a href="$index?md=mf2&id=$id"><font color="#0000FF">HTML�\\�[�X�̃T���v����\\��</font></a></td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#99CCFF">�����t�H�[��</td>
                                          <td>$form3<a href="$index?md=mf3&id=$id"><font color="#0000FF">HTML�\\�[�X�̃T���v����\\��</font></a></td>
                                        </tr>
                                      </table>
END
	} elsif ( $page eq 'bs' ) {
		# �z�M�����
		$main_table = <<"END";
                                <form name="form1" method="post" action="$indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="502"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="3">
                                          <tr> 
                                            <td>�z�M���̏����X�V���܂�</td>
                                          </tr>
                                          <tr> 
                                            <td>���͌�A�u�X�V�𔽉f�v�{�^�����N���b�N���Ă�������</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                          <td>
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                            <td bgcolor="#ABDCE5">
                                            <table width="100%" border="0" cellpadding="3" cellspacing="1">
                                              <tr> 
                                                <td width="142" bgcolor="#E5FDFF" rowspan="2">�z�M�v������</td>
                                                <td width="348" bgcolor="#FFFFFF">
                                                  <input name="pname" type="text" id="sname" value="$line[2]" size="50"></td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#FFFFFF">�z�M�v�������͎��ʖ��Ȃ̂ŁA�C�ӂɕύX�\\�ł��B</td>
                                              </tr>
                                              <tr> 
                                                <td width="142" bgcolor="#E5FDFF">�z�M����</td>
                                                <td width="348" bgcolor="#FFFFFF">
                                                  <input name="sname" type="text" id="sname" value="$line[3]" size="50"></td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#E5FDFF">�z�M�����[���A�h���X</td>
                                                <td bgcolor="#FFFFFF">
                                                  <input name="address" type="text" id="address" value="$line[4]" size="50"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2" bgcolor="#FFFFFF" nowrap>�z�M�����E�z�M�����[���A�h���X���A�o�^�҈��ɓ͂����[���̍��o�l�Ƃ��Ĉ����܂��B</td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#E5FDFF">�Ǘ��҃��[���A�h���X</td>
                                                <td bgcolor="#FFFFFF">
                                                  <input name="address2" type="text" id="address2" value="$line[5]" size="50">
                                                  <table width="300" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                      <td><font color="#0000FF" size="-1">��</font><font color="#0000FF" size="-1">�����w�肷��ꍇ�͔��p�u,�v�ŋ�؂��Ă�������</font></td>
                                                    </tr>
                                                  </table>                                                  
                                                </td>
                                              <tr> 
                                                <td colspan="2" bgcolor="#FFFFFF" nowrap>�o�^���̊m�F���[���⑗�M�e�X�g�͂�����̊Ǘ��l���[���A�h���X�ɓ͂��܂��B</td>
                                              </tr>
                                              </tr>
                                            </table>
                                            </td>
                                            </tr>
                                            </table>
                                          </td>
                                          </tr>
                                          <tr> 
                                            <td><br><table width="450" border="0">
                                              <tr>
                                                <td>��<strong>�Ǘ��҃��[���A�h���X�𕡐��w�肵���ꍇ</strong></td>
                                              </tr>
                                              <tr>
                                                <td>�u,�v�J���}�ŋ�؂����擪�̃��[���A�h���X���ȉ��Ɏg�p���A���̑��̃��[���A�h���X�͓o�^���̊Ǘ��҂ւ̒ʒm���[���Ɏg�p����܂��B<br>                                                  <br>
                                                  �E�{���̑��M�e�X�g<br>
                                                  �E�o�^�҂ւ̃��[�����M�i�z�M�����ɂȂ����[���𑗐M�j</td>
                                              </tr>
                                            </table></td>
                                          </tr>
                                          <tr align="center"> 
                                            <td><input name="id" type="hidden" id="id" value="$id">
                                              <input name="action" type="hidden" id="action" value="bs">
                                              <input name="md" type="hidden" id="md" value="text">
                                              <input type="submit" name="Submit" value="�@�X�V�𔽉f�@"></td>
                                          </tr>
                                        </table></td>
                                      <td width="21">&nbsp;</td>
                                    </tr>
                                  </table>
                                </form>
END
	} elsif ( $page eq 'redirect' ) {
		# �o�^��������
        my $checked = 'checked' if ( $line[39] );
		my $checked2 = 'checked' if ( $line[40] );
		my $checked3 = 'checked' if ( $line[41] );
		my $checked4 = 'checked' if ( $line[42] );
		my $checked_utf = 'checked' if( $line[60] );
		my $checked_ssl = 'checked' if( $line[83] );
		
		my $href_regist = &Pub'setHttp($line[12]);
		my $href_renew = &Pub'setHttp($line[13]);
		my $href_cancel = &Pub'setHttp($line[14]);
		
		my $selected_regist_0 = ( $line[78] ne 'https://' )? ' selected="selected"': '';
		my $selected_regist_1 = ( $line[78] eq 'https://' )? ' selected="selected"': '';
		my $selected_renew_0 = ( $line[79] ne 'https://' )? ' selected="selected"': '';
		my $selected_renew_1 = ( $line[79] eq 'https://' )? ' selected="selected"': '';
		my $selected_cancel_0 = ( $line[80] ne 'https://' )? ' selected="selected"': '';
		my $selected_cancel_1 = ( $line[80] eq 'https://' )? ' selected="selected"': '';
		
		$main_table = <<"END";
                                <form name="form1" method="post" action="$indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="502"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="3">
                                          <tr> 
                                            <td><strong>�o�^�ݒ�</strong>���X�V���܂�</td>
                                          </tr>
                                          <tr> 
                                            <td>���͌�A�u�X�V�𔽉f�v�{�^�����N���b�N���Ă�������
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                          <td><font color="#FF0033">���w�肪�Ȃ��ꍇ�͊ȈՃy�[�W���o�͂���܂��B<br>�@ �ڂ����̓��j���[�̃w���v���N���b�N���Ă��������B</font>
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr>
                                              <td>
                                                
                                              </td>
                                            </tr>
                                            <tr>
                                            <td bgcolor="#ABDCE5">
                                              <table width="100%" border="0" cellpadding="5" cellspacing="1">
                                              <tr>
                                                <td bgcolor="#E5FDFF" rowspan="2">�o�^��ʒm���� </td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="notice" value="checkbox" $checked2>�Ǘ��҂ɒʒm</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">�����Ƀ`�F�b�N������ƁA�u�o�^���v�̃��[�����Ǘ��҂̃��[���A�h���X�ɂ����M����܂��B</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#E5FDFF" rowspan="2" nowrap>�o�^���̓��͊m�F </td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="confirm" value="checkbox" $checked3>���͊m�F�y�[�W��\\������</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">�����Ƀ`�F�b�N������ƁA�t�H�[���ւ̓��͓��e�m�F��ʂ�\\�����܂��B</td>
                                              </tr>
                                              
                                              <tr>
                                                <td rowspan="2" nowrap bgcolor="#E5FDFF">�����R�[�h�ݒ�</td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="utf" value="1" $checked_utf />
                                                  UTF-8�𗘗p����</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">�o�^���Ɋy���[�����\\������y�[�W�i���͊m�F�E�G���[�E������ʁj�̕����R�[�h��UTF-8���g���܂��B</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#E5FDFF" rowspan="2">�o�^���[���A�h���X�̏d�� </td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="dck" value="checkbox" $checked4>������</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">�o�^���Ɋy���[�����\\������y�[�W�i���͊m�F�E�G���[�E������ʁj�̕����R�[�h��UTF-8���g���܂��B</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#E5FDFF" rowspan="2">SSL�ݒ� </td>
                                                <td bgcolor="#FFFFFF"><input type="checkbox" name="ssl" value="1" $checked_ssl>SSL�Ŏg�p����</td>
                                              </tr>
                                              <tr>
                                                <td bgcolor="#FFFFFF">SSL���g�p�\\�ȃT�[�o�[�ɂ����āASSL�̈�Ɋy���[��PRO��ݒu�����ꍇ�ɐݒ肵�Ă��������B<br>
                                                   �o�^�pCGI(apply.cgi)��URL��SSL(https://)�ƂȂ�A<br>
                                                   �E�u�o�^/�ύX/�����p�v�t�H�[���̃T���v���\\�[�X<br>
                                                   �E�����N���b�N���������N<br>�E�A�N�Z�X���͗p�����N<br>
                                                   �̃A�N�Z�X��URL�Ƃ��Ďg���ASSL���g�p�\\�ɂȂ�܂��B<br><br>
                                                   <font color="#FF0000">�ySSL�g�p����URL���قȂ�T�[�o�[�̏ꍇ�z</font><br>�uSSL�ݒ�v��L���ɂ��āA�Ȍ�uSSL�p��URL�v�ŊǗ���ʂɃ��O�C�����Ă��������B<br>
                                                   ����ɂ��A�o�^CGI(apply.cgi)���uSSL�p��URL�v�Ƃ��Đݒ肳��܂��B<br><br>
                                                   <font color="#FF0000">���ݒ��ύX�����ꍇ�́A�o�^�p�t�H�[����HTML���ŐV�̂��̂ɓ\\��t���Ȃ����Ă��������B</font>
                                               </td>
                                              </tr>
                                               <tr> 
                                                <td bgcolor="#E5FDFF">�o�^��������URL</td>
                                                <td bgcolor="#FFFFFF"><select name="http_regist">
                                                    <option$selected_regist_0>http://</option>
                                                    <option$selected_regist_1>https://</option>
                                                  </select>
                                                  <input name="regist" type="text" value="$href_regist" size="45"></td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#E5FDFF">�ύX��������URL</td>
                                                <td bgcolor="#FFFFFF"><select name="http_renew">
                                                    <option$selected_renew_0>http://</option>
                                                    <option$selected_renew_1>https://</option>
                                                  </select>
                                                  <input name="renew" type="text" value="$href_renew" size="45"></td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#E5FDFF">������������URL</td>
                                                <td bgcolor="#FFFFFF"><select name="http_cancel">
                                                    <option$selected_cancel_0>http://</option>
                                                    <option$selected_cancel_1>https://</option>
                                                  </select>
                                                  <input name="cancel" type="text"  value="$href_cancel" size="45"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="2" bgcolor="#FFFFFF">��L�t�H�[����URL�A�h���X�����邱�ƂŁA�o�^���E�ύX���E�������ɔC�ӂ̃y�[�W��\\�����邱�Ƃ��ł��܂��B<br><font color="#FF0000">������URL�́APC����̃A�N�Z�X��p�ł��B</font>
                                                <br><br>
                                                <table width="100%" border="0" cellpadding="3" cellspacing="1">
                                                  <tr>
                                                  <td><input name="ck" type="checkbox" $checked></td>
                                                  <td><font color="#FF0000">�T�[�o�[�ɂ���Ă͏�LURL���w�肷�邱�ƂŐ���ɓ��삵�Ȃ��ꍇ������܂��B
                                                      ���̏ꍇ�͂������`�F�b�N���Ă��������B</font></td>
                                                  </tr>
                                                </table></td>
                                              </tr>
                                              </table>
                                            </td>
                                            </tr>
                                            </table>
                                          </td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                          <td>
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                            <td bgcolor="#ABDCE5">
                                            <table width="100%" border="0" cellpadding="3" cellspacing="1">
                                              <tr>
                                                <td bgcolor="#E5FDFF">
                                                ����h���C���E���[���A�h���X�̎�t����
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td bgcolor="#FFFFFF">
                                                �i�����w�肷��ꍇ�͔��p�u,�v�ŋ�؂��Ă��������j<br>
                                                <input name="out" type="text" value="$line[38]" size="80"></td>
                                              </tr>
                                            </table>
                                            </td>
                                            </tr>
                                            </table>
                                          </td>
                                          </tr>
                                          <tr align="center"> 
                                            <td><input name="id" type="hidden" id="id" value="$id">
                                              <input name="action" type="hidden" id="action" value="redirect">
                                              <input name="md" type="hidden" id="md" value="text">
                                              <input type="submit" name="Submit" value="�@�X�V�𔽉f�@"></td>
                                          </tr>
                                        </table></td>
                                      <td width="21">&nbsp;</td>
                                    </tr>
                                  </table>
                                </form>
END
	}elsif ( $page eq 'header' || $page eq 'footer' || $page eq 'cl' ) {
	    # �{���̃w�b�_�A�t�b�^�A�����ē�
		my $subtitle;
		my $text;
		my $submit = $page;
		$subtitle = '�`������' if ( $page eq 'header' );
		$subtitle = '��������' if ( $page eq 'footer' );
		$subtitle = '�����ē���' if ( $page eq 'cl' );
		$text = $line[9] if ( $page eq 'header' );
		$text = $line[10] if ( $page eq 'cl' );
		$text = $line[11] if ( $page eq 'footer' );
		
		$text =~ s/<br>/\n/ig;
		$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>�z�M���郁�[����<strong>$subtitle�i�{�����j</strong>���X�V���܂�</td>
                                          </tr>
                                          <tr> 
                                            <td>���͌�A�u�X�V�𔽉f�v�{�^�����N���b�N���Ă�������</td>
                                          </tr>
                                          <tr> 
                                            <td><textarea name="text" cols="55" rows="10" id="text">$text</textarea></td>
                                          </tr>
                                          <tr> 
                                            <td align="center"><input name="md" type="hidden" id="md" value="text">
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="action" type="hidden" id="action" value="$submit">
                                              <input type="submit" name="Submit" value="�@�X�V�𔽉f�@"></td>
                                          </tr>
                                          <tr> 
                                            <td><font color="#FF0000">���X�e�b�v���[���{����o�^�҂ւ̃��[�����M���ŁA���͂�����L�f�[�^��}������ꍇ�A�X�V���e�͂��ׂẴ��[���ɔ��f����܂��B</font></td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
	} elsif ( $page eq 'form1' ) {
		# �o�^�p�t�H�[���̎w��t�H�[��
		$main_table = &MF'form_top( $id, @line );
	} elsif ( $page eq 'form2' ) {
        # �ύX�A����
        my ( $ck1, $uid1, $mail1, $rmail ) = split(/<>/, $line[33]);
        my $checked1 = 'checked' if $ck1;
        my ( $ck2, $uid2, $mail2 ) = split(/<>/, $line[34]);
        my $checked2 = 'checked' if $ck2;
		$main_table = <<"END";
                                <form name="form1" method="post" action="$indexcgi">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="20">&nbsp;</td>
                                      <td width="503"><table width="100%" border="0" cellspacing="0" cellpadding="2">
                                          <tr> 
                                            <td>�o�^���ꂽ���[���A�h���X�ύX�p�A�o�^�����̓��̓t�H�[�����w�肵�Ă�������</td>
                                          </tr>
                                          <tr> 
                                            <td>���͍��ڂɎw�肵�����ꍇ��<strong>�u���̓`�F�b�N�v</strong>�Ƀ`�F�b�N���Ă�������</td>
                                          </tr>
                                          <tr> 
                                            <td>�܂��A�\\�����鍀�ڂ̖��̂�ύX�������ꍇ��<strong>�u�\\�����́v</strong>�ɓ��͂��Ă�������</td>
                                          </tr>
                                          <tr> 
                                            <td>�����A<strong>�u�X�V�𔽉f�v</strong>�{�^�����N���b�N���Ă�������</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td><strong>�o�^�ύX�p</strong></td>
                                          </tr>
                                          <tr> 
                                            <td><table width="100%" border="1" cellspacing="0" cellpadding="1">
                                                <tr> 
                                                  <td width="146" align="center" bgcolor="#CCCCCC">����</td>
                                                  <td width="92" align="center" bgcolor="#CCCCCC">���̓`�F�b�N</td>
                                                  <td width="261" align="center" bgcolor="#CCCCCC">�\\������</td>
                                                </tr>
                                                <tr> 
                                                  <td>�o�^��ID</td>
                                                  <td align="center"><input name="fr" type="checkbox" id="fm19" value="checkbox" $checked1></td>
                                                  <td align="center"><input name="ruserid" type="text" value="$uid1" size="40"></td>
                                                </tr>
                                                <tr> 
                                                  <td>�ύX�O���[���A�h���X</td>
                                                  <td align="center">�K�{</td>
                                                  <td align="center"><input name="rmail" type="text" value="$mail1" size="40"></td>
                                                </tr>
                                                <tr> 
                                                  <td>�ύX�チ�[���A�h���X</td>
                                                  <td align="center">�K�{</td>
                                                  <td align="center"><input name="rnmail" type="text" value="$rmail1" size="40"></td>
                                                </tr>
                                              </table></td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td><strong>�o�^�����p</strong></td>
                                          </tr>
                                          <tr> 
                                            <td><table width="100%" border="1" cellspacing="0" cellpadding="1">
                                                <tr> 
                                                  <td width="146" align="center" bgcolor="#CCCCCC">����</td>
                                                  <td width="92" align="center" bgcolor="#CCCCCC">���̓`�F�b�N</td>
                                                  <td width="261" align="center" bgcolor="#CCCCCC">�\\������</td>
                                                </tr>
                                                <tr> 
                                                  <td>�o�^��ID</td>
                                                  <td align="center"><input name="fd" type="checkbox" id="fm19" value="checkbox" $checked2></td>
                                                  <td align="center"><input name="duserid" type="text" value="$uid2" size="40"></td>
                                                </tr>
                                                <tr> 
                                                  <td>���[���A�h���X</td>
                                                  <td align="center">�K�{</td>
                                                  <td align="center"><input name="dmail" type="text" value="$mail2" size="40"></td>
                                                </tr>
                                              </table>
                                              &nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td align="center">
                                            <input type="hidden" name="id" value="$id">
                                            <input type="hidden" name="md" value="text">
                                            <input type="hidden" name="action" value="form2">
                                            <input type="submit" name="Submit" value="�@�X�V�𔽉f�@"></td>
                                          </tr>
                                          <tr><td><font color="#FF0000">
                                            <strong>���u�o�^��ID�v�Ƃ�</strong><br>
                                            �e�o�^�҂ɑ΂��āA�o�^���Ɏ�����������锼�p�����̒ʂ��ԍ��ł��B<br>�u�o�^�����[���v�Ȃǂ��g���ēo�^�҂ɒʒm���邱�ƂŁA�ύX�E�����̍ۂɓo�^�҂̌ŗL���Ƃ��ė��p�ł��܂��B</font></td></tr>
                                        </table></td>
                                    </tr>
                                  </table>
                                </form>
END
	}elsif ( $page eq 'add' || $page eq 'ref' ) {
        my $n = $param{'n'};
        my @csvs = &get_csvdata( $id, $n ) if( $page ne 'add' && $n > 0);
		if ( @csvs ) {
			foreach( 1 .. 50 ){
				$csvs[$_] =~ s/<br>/\n/gi;
			}
		}
		my $message;
		my $message2;
		my $submit;
		my $info;
		my $userid;
		my $sended;
		my $step;
		# �������
		my @step = split( /,/, (split(/<>/,$line[36]))[0] );
		
		if ( $page eq 'add' ) {
			$submit   = qq|<input type="submit" value="�@�ǉ�����@" onClick="return confir('�ǉ����܂����H');">|;
			$message  = '�ǉ�';
			$message2 = qq|���͌�A�u<strong>�ǉ�����</strong>�v�{�^�����N���b�N���Ă�������|;
			$userid   = ' ���p�����Œʂ��ԍ����쐬���܂��B<br>�����̃v����������ŗL����ID�ł��B';
			# �X�e�b�v���[���������擾
			( $option, $script_array ) = &scheduleOption( $line[35], $line[36] );
		}else {
			$submit = qq|<input type="submit" name="re" value="�@�X�V�𔽉f����@"><input type="submit" name="de" value="�@�폜����@" onClick="return confir('�{���ɍ폜���܂���?');">|;
			$message = '�X�V�A�폜';
			$message2 = qq|���͂𔽉f���ĕҏW����ꍇ�́u<strong>�X�V�𔽉f����</strong>�v�{�^����<br>���̓o�^�҂��폜����ꍇ�́u<strong>�폜����</strong>�v�{�^�����N���b�N���Ă�������<br>�s���{���͕ύX����ꍇ�I�����Ă�������|;
			$info     = <<"END";
                                <tr>
                                  <td bgcolor="#FFFFFF" colspan="2"><strong>�����ԐM</strong></td>
								</tr>
								<tr>
                                <td bgcolor="#FFFFFF" colspan="2">
                                <input type="radio" name="res" value="0">�u�ύX�������͉������v�̃��[���𑗐M����<br>�@�@�i�X�V�シ���Ƀ��[�������M����܂��j<br>
                                <input type="radio" name="res" value="1" checked>���M���Ȃ�
                                </td>
                                </tr>
END
			my $id_number = sprintf( "%05d",$csvs[0] );
			$userid   = "<strong>$id_number</strong><br>�����̃v����������ŗL����ID�ł��B";
			$stop_message = qq|������z�M���ύX����Ɓu�ꎞ��~�v��Ԃ͉�������܂��B<br>| if( $csvs[52] > 0 );
			
			# �X�e�b�v���[���������擾
			( $option, $script_array ) = &scheduleOption( $line[35], $line[36], 1, $csvs[20], $csvs[51], $csvs[19], $csvs[53] );
			
			# �X�e�b�v���[������擾
			$sended = '���z�M' if($csvs[20] eq '' );
			$sended = '�o�^��' if($csvs[20] eq '0' );
			$sended = '��'.$csvs[20]. '��' if($csvs[20] > 0 );
			
		}
		$main_table = <<"END";
<script type="text/javascript"><!--

chk = new Array();
chk['end'] = 0;
$script_array

function Interval(){
	var index = document.form1.step.selectedIndex;
	var val = document.form1.step.options[index].value;
	if( val == ''){
		return;
	}
	if( chk[val] > 0 ){
		document.form1.interval.disabled = false;
		document.form1.interval.style.backgroundColor = '#FFFFFF';
		
	}else{
		document.form1.interval.disabled = true;
		document.form1.interval.value = '';
		document.form1.interval.style.backgroundColor = '#CCCCCC';
	}
}
function winLoad(){
	if (window.addEventListener) { //for W3C DOM
		window.addEventListener("load", Interval, false);
	}else if (window.attachEvent) { //for IE
		window.attachEvent("onload", Interval);
	}else  {
		window.onload = Interval;
	}
}
winLoad();

function reStart(){
	
	if( document.form1.step.selectedIndex == 0 && document.form1.restart_flag.value == 1 ){
		return confir('�z�M���ĊJ���܂��B\\n�X�V�シ���ɁA�Y���̃X�e�b�v���[�������M����܂��B\\n\\n��낵���ł���?');
	}
}

// -->
</script>
                              <table  width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                              <td width="50">&nbsp;
                              </td>
                              <td width="400">
                              
                                <form action="$indexcgi" method="POST" name="form1">
                                <table  width="100%" border="0" cellspacing="0" cellpadding="4">
                                <tr>
                                <td width="450" colspan="2"><strong>�o�^��</strong>��$message���܂�
                                </td>
                                </tr>
                                <tr>
                                <td colspan="2">$message2
                                </td>
                                </tr>
                                <tr>
                                <td colspan="2">&nbsp;
                                </td>
                                </tr>
                                                <tr>
                                                  <td colspan="2" bgcolor="#FFCC66">���z�M���</td>
                                                </tr>
END
		# �o�^�Ғǉ�
		if( $page eq 'add' ){
			$main_table .= <<"END";
                                                <tr>
                                                  <td width="25%">�z�M�J�n��</td>
                                                  <td widht=""><select name="step" onchange="Interval();">
                                                      $option
                                                    </select></td>
                                                </tr>
                                                 <tr><td colspan="2"><font color="#FF0000">���\\������Ă���z�M���́A�z�M����w�肵���ۂ̊J�n���t�ł��B</font><br>
                                                    </td></tr>
                                                <tr>
                                                <tr>
                                                  <td width="25%">�z�M�J�n��</td>
                                                  <td widht=""><input id="interval" type="text" name="interval" size="5" disabled style="background-color:#CCCCCC;">���ォ��J�n</td>
                                                </tr>
                                                 <tr><td colspan="2"><font color="#FF0000">���ĊJ���z�M����w�肵���ꍇ�́A���͂��Ă��������B</font>
                                                    </td></tr>
                                                <tr>
                                                <tr>
                                                  <td>�o�^�����[��</td>
                                                  <td widht=""><input name="res" type="radio" value="0">
                                                    ���M����<br>
                                                    <input name="res" type="radio" value="1" checked="checked">
                                                    ���M���Ȃ�</td>
                                                </tr>
END
		}
		# �o�^�ҕҏW
		if( $page eq 'ref' ){
			$main_table .= <<"END";
                                               <tr>
                                                  <td>���[���A�h���X</td>
                                                  <td widht="">$csvs[5]</td>
                                                </tr>
                                                <tr>
                                                  <td>�z�M�ς݉�</td>
                                                  <td widht="">$sended</td>
                                                </tr>
                                                <tr>
                                                  <td width="25%">����z�M��</td>
                                                  <td widht=""><select name="step" onchange="Interval();">
                                                      $option
                                                    </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                  <td width="25%">�z�M�J�n��</td>
                                                  <td widht=""><input id="interval" type="text" name="interval" size="5" disabled style="background-color:#CCCCCC;">���ォ��J�n</td>
                                                </tr>
                                                 <tr><td colspan="2"><font color="#FF0000">���ĊJ���z�M����w�肵���ꍇ�́A���͂��Ă��������B</font>
                                                    </td></tr>
                                                <tr>
END
		}
		# �o�^�ҕҏW(�ꎞ�ҋ@)
		if( $page eq 'ref' && $csvs[52] > 0 ){
			$main_table .= <<"END";
                                                <tr>
                                                  <td>�z�M���</td>
                                                  <td widht=""><input name="stop" type="radio" value="1" onclick="document.form1.restart_flag.value = 0" checked>
                                                    �z�M���ĊJ���Ȃ�
                                                    <br>
                                                    <input name="stop" type="radio" value="0" onclick="document.form1.restart_flag.value = 1">
                                                    �z�M���ĊJ����</td>
                                                </tr>
END
		}
		# �o�^�ҕҏW
		if( $page eq 'ref' ){
			$main_table .= <<"END";
												<tr><td colspan="2"><font color="#FF0000">$stop_message
												���\\������Ă���z�M���́A�z�M���ύX�����ۂ̊J�n���t�ł��B<br>
												���w���ɂ���ẮA�z�M���ɕ����̃X�e�b�v�����M����܂��B</font><br>
                                                </td></tr>
                                                <tr>
                                                  <td colspan="2"><input type="submit" name="stepInfo" value="�@�z�M�����X�V����@" onclick="return reStart();">
                                                  <input type="reset" name="Submit2" value="���ɖ߂�"><input type="hidden" name="restart_flag"></td>
                                                </tr>
END
		}
		$main_table .= <<"END";
                                                <tr>
                                                  <td>&nbsp;</td>
                                                  <td widht="">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2" bgcolor="#FFCC66">���o�^�ҏ��</td>
                                                </tr>
                                <tr>
                                <td width="">�o�^��ID
                                </td>
                                <td widht="">$userid<input type="hidden" name="def_mail" value="$csvs[5]">
                                </td>
                                </tr>
                                <tr>
                                <td width="">��Ж�
                                </td>
                                <td widht=""><input type="text" name="co" value="$csvs[1]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>��Ж��t���K�i
                                </td>
                                <td><input type="text" name="_co" value="$csvs[2]" size="40">
                                </td>
                                </tr>

                                <tr>
                                <td>��
                                </td>
                                <td><input type="text" name="sei" value="$csvs[37]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>���t���K�i
                                </td>
                                <td><input type="text" name="_sei" value="$csvs[38]" size="40">
                                </td>
                                </tr>

                                <tr>
                                <td>��
                                </td>
                                <td><input type="text" name="mei" value="$csvs[39]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>���t���K�i
                                </td>
                                <td><input type="text" name="_mei" value="$csvs[40]" size="40">
                                </td>
                                </tr>

                                <tr>
                                <td>�����O<br><a href="#1"><font color="#FF0000">(��1)</font></a>
                                </td>
                                <td><input type="text" name="name" value="$csvs[3]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�����O�t���K�i<br><a href="#2"><font color="#FF0000">(��2)</font></a>
                                </td>
                                <td><input type="text" name="_name" value="$csvs[4]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>���[���A�h���X
                                </td>
                                <td><input type="text" name="mail" value="$csvs[5]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�d�b�ԍ�
                                </td>
                                <td><input type="text" name="tel" value="$csvs[6]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>FAX�ԍ�
                                </td>
                                <td><input type="text" name="fax" value="$csvs[7]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>URL
                                </td>
                                <td><input type="text" name="url" value="$csvs[8]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�X�֔ԍ�
                                </td>
                                <td><input type="text" name="code" value="$csvs[9]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�s���{��
                                </td>
                                <td>$csvs[10]
                                    <select name="address" size="1"><option value=''>�I�����Ă�������</option><option>�k�C��</option><option>�X��</option><option>��茧</option><option>�{�錧</option><option>�H�c��</option><option>�R�`��</option><option>������</option><option>��錧</option><option>�Ȗ،�</option><option>�Q�n��</option><option>��ʌ�</option><option>��t��</option><option>�����s</option><option>�_�ސ쌧</option><option>�V����</option><option>�x�R��</option><option>�ΐ쌧</option><option>���䌧</option><option>�R����</option><option>���쌧</option><option>�򕌌�</option><option>�É���</option><option>���m��</option><option>�O�d��</option><option>���ꌧ</option><option>���s�{</option><option>���{</option><option>���Ɍ�</option><option>�ޗǌ�</option><option>�a�̎R��</option><option>���挧</option><option>������</option><option>���R��</option><option>�L����</option><option>�R����</option><option>������</option><option>���쌧</option><option>���Q��</option><option>���m��</option><option>������</option>
                                    <option>���ꌧ</option><option>���茧</option><option>�F�{��</option><option>�啪��</option><option>�{�茧</option><option>��������</option><option>���ꌧ</option><option>�S��</option><option>�C�O</option></select>
                                </td>
                                </tr>
                                <tr>
                                <td>�Z���P
                                </td>
                                <td><input type="text" name="address1" value="$csvs[11]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�Z���Q
                                </td>
                                <td><input type="text" name="address2" value="$csvs[12]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�Z���R
                                </td>
                                <td><input type="text" name="address3" value="$csvs[13]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP
                                </td>
                                <td><input type="text" name="free1" value="$csvs[14]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ
                                </td>
                                <td><input type="text" name="free2" value="$csvs[15]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂR
                                </td>
                                <td><input type="text" name="free3" value="$csvs[16]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂS
                                </td>
                                <td><input type="text" name="free4" value="$csvs[17]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂT
                                </td>
                                <td><input type="text" name="free5" value="$csvs[18]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂU
                                </td>
                                <td><input type="text" name="free6" value="$csvs[22]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂV
                                </td>
                                <td><input type="text" name="free7" value="$csvs[23]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂW
                                </td>
                                <td><input type="text" name="free8" value="$csvs[24]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂX
                                </td>
                                <td><input type="text" name="free9" value="$csvs[25]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP�O
                                </td>
                                <td><input type="text" name="free10" value="$csvs[26]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP�P
                                </td>
                                <td><input type="text" name="free11" value="$csvs[27]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP�Q
                                </td>
                                <td><input type="text" name="free12" value="$csvs[28]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP�R
                                </td>
                                <td><input type="text" name="free13" value="$csvs[29]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP�S
                                </td>
                                <td><input type="text" name="free14" value="$csvs[30]" size="40">
                                </td>
                                </tr>
                                 <tr>
                                <td>�t���[���ڂP�T
                                </td>
                                <td><input type="text" name="free15" value="$csvs[31]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP�U
                                </td>
                                <td><input type="text" name="free16" value="$csvs[32]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP�V
                                </td>
                                <td><input type="text" name="free17" value="$csvs[33]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP�W
                                </td>
                                <td><input type="text" name="free18" value="$csvs[34]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂP�X
                                </td>
                                <td><input type="text" name="free19" value="$csvs[35]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ�O
                                </td>
                                <td><input type="text" name="free20" value="$csvs[36]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ�P
                                </td>
                                <td><input type="text" name="free21" value="$csvs[41]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ�Q
                                </td>
                                <td><input type="text" name="free22" value="$csvs[42]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ�R
                                </td>
                                <td><input type="text" name="free23" value="$csvs[43]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ�S
                                </td>
                                <td><input type="text" name="free24" value="$csvs[44]" size="40">
                                </td>
                                </tr>
                                 <tr>
                                <td>�t���[���ڂQ�T
                                </td>
                                <td><input type="text" name="free25" value="$csvs[45]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ�U
                                </td>
                                <td><input type="text" name="free26" value="$csvs[46]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ�V
                                </td>
                                <td><input type="text" name="free27" value="$csvs[47]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ�W
                                </td>
                                <td><input type="text" name="free28" value="$csvs[48]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂQ�X
                                </td>
                                <td><input type="text" name="free29" value="$csvs[49]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td>�t���[���ڂR�O
                                </td>
                                <td><input type="text" name="free30" value="$csvs[50]" size="40">
                                </td>
                                </tr>
                                <tr>
                                <td colspan="2">&nbsp;
                                </td>
                                </tr>
$info
                                <tr>
                                <td colspan="2">$submit
                                </td>
                                </tr>
                                </table>
                                <input type="hidden" name="md" value="addguest">
                                <input type="hidden" name="n" value="$n" size="40">
                                <input type="hidden" name="id" value="$id">
                                </form>
                                         <br> 
                                        <table width="100%" border="0"> 
                                           <tr> 
                                             <td width="20" valign="top"><a name="1"></a><font color="#FF0000">��1</font></td><td>�u���v�u���v���ڂ������p�̏ꍇ�A�f�[�^�Ǘ��ケ�̍��ڃf�[�^�ɂ́u���v�u���v�̓��̓f�[�^�������I�ɓo�^����܂����A�V�X�e�����p����͂������܂���B</td> 
                                           </tr> 
                                           <tr> 
                                             <td width="20" valign="top"><a name="2"></a><font color="#FF0000">��2</font></td><td>�u���t���K�i�v�u���t���K�i�v���ڂ������p�̏ꍇ�A�f�[�^�Ǘ��ケ�̍��ڃf�[�^�ɂ́u���v�u���v�̓��̓f�[�^�������I�ɓo�^����܂����A�V�X�e�����p����͂������܂���B</td> 
                                           </tr>
                                        </table>                             
                              
                              </td>
                              </tr>
                              </table>
END
	}elsif ( $page eq 'up' ) {
		# �X�e�b�v���[���������擾
		my( $step, $script_array ) = &scheduleOption( $line[35], $line[36] );
		
		# �o�^�������z�M���s�m�F
		my( $session, $target ) = &get_csvup_session( $id );
		my $sendtable;
		if( $session ne '' ){
			local( $method, $each, $sleep, $partition ) = &send_method( \@errors );
			if( $method ){
				my $sendtag;
				my $message;
				my $sendact;
				my $flag    = "$myroot$data_dir$csv_dir" . $session;
				unless( -e $flag ){
					# �z�M�t���O�t�@�C�����쐬
					open(FLAG, ">$flag");
					close(FLAG);
					# �z�M�pIMG�^�O�쐬
					$sendtag = &csvup_sendtag( $session );
					$sendact = qq|�z�M���J�n���܂����B|;
					$message = qq|<br><br>���̏�������́u�Ǘ���ʁv�̃����N���N���b�N�����ۂ̓��삪�d�����Ȃ�ꍇ������܂��B���̍ۂ́A������x�Y���̃����N���N���b�N���Ă��������B|;
				}else{
					$sendact = qq|�z�M���ł��B|;
				}
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
       <tr>
        <td bgcolor="#FFFFFF"><font color="#FF0000"><strong>�ꗗ�A�b�v���[�h���V�K�ǉ������o�^�҂ցu�o�^�����[���v���o�b�N�O���E���h��$sendact</strong>$message</font>$sendtag</td>
       </tr>
      </table>
    </td>
  </tr>
</table><br>�@
END
			}else{
				open(LIST,$target);
				my $n = 0;
				while(<LIST>){
					$n++;
				}
				close(LIST);
				my $next = ( $each > $n )? $n: $each;
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
        <tr>
          <td bgcolor="#FFFFFF"><strong><font color="#FF0000">�ꗗ�A�b�v���[�h���V�K�ǉ������o�^�҂ւ̓o�^�����[�����z�M���𑗐M���Ă��������B</font>(�c��F$n��)</strong>
           <br><br><a href="$indexcgi?md=upsend&ss=$session"><font color="#0000FF">&gt;&gt;����$next���𑗐M����</font></a><br><br>
           �A���Ŕz�M���s���܂��ƁA�����p�̃T�[�o�̔\\�͂ɂ��܂��Ă͑�ʔz�M�ɂ�蕉�ׂ��������邱�Ƃɂ��z�M�G���[��������\\�����������܂��B
           ��ʂ̃��X�g���ꊇ�o�^������A���[�U�[�������Ȃ�����Ԃł̈ꊇ���M�y�ѓ��t�w��z�M���s���ꍇ�͂����p�җl�̐ӔC�ɂ����ĐT�d�ɂ��肢�������܂��B</td>
        </tr>
      </table>
    </td>
  </tr>
</table><br>�@
END
			}
		}
		
		$main_table = <<"END";
$sendtable
<script type="text/javascript"><!--

chk = new Array();
chk['end'] = 0;
$script_array

function Interval(){
	var index = document.form1.step.selectedIndex;
	var val = document.form1.step.options[index].value;
	if( val == ''){
		return;
	}
	if( chk[val] > 0 ){
		document.form1.interval.disabled = false;
		document.form1.interval.style.backgroundColor = '#FFFFFF';
		
	}else{
		document.form1.interval.disabled = true;
		document.form1.interval.value = '';
		document.form1.interval.style.backgroundColor = '#CCCCCC';
	}
}
function winLoad(){
	if (window.addEventListener) { //for W3C DOM
		window.addEventListener("load", Interval, false);
	}else if (window.attachEvent) { //for IE
		window.attachEvent("onload", Interval);
	}else  {
		window.onload = Interval;
	}
}
winLoad();

// -->
</script>
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td width="20">&nbsp;</td>
                                          <td width="441"><form name="form1" method="post" action="$main'indexcgi" enctype="multipart/form-data">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                <tr>
                                                  <td><strong>CSV�t�@�C��</strong>���f�[�^��o�^���܂��B</td>
                                                </tr>
                                                <tr>
                                                  <td>�A�b�v���[�h������I����CSV�t�@�C�������w���A�u�o�^�v�{�^�����N���b�N���Ă��������B</td>
                                                </tr>
                                                <tr align="center">
                                                  <td><br>
                                                    <table width="480" border="0" cellspacing="0" cellpadding="0">
                                                      <tr>
                                                        <td bgcolor="#666666"><table width="480" border="0" cellpadding="15" cellspacing="1">
                                                            <tr>
                                                              <td bgcolor="#FFFFFF">�yCSV�t�@�C�����m���ɃA�b�v���[�h����ɂ͈ȉ��̎菇�����������������z<br>
                                                                <br />
                                                                �P�j �v�������쐬<br />
                                                                �Q�j �o�^�p�t�H�[���̃y�[�W�ō��ڂ�ݒ�<br />
                                                                �R�j �u�o�^�ҏ��v�̃y�[�W����u�ǉ��v���N���b�N���A�S�Ă̏�������1���o�^<br />
                                                                �S�j �ꗗ���_�E�����[�h��CSV�t�@�C���f�[�^���擾<br />
                                                                �T�j �S���Q�ƂɁA�f�[�^��ǉ����āACSV�t�@�C���f�[�^���쐬<br />
                                                                �U�j �T���ăA�b�v���[�h<br />
                                                              </td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                    </table>
                                                    <br>
                                                    &nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td bgcolor="#FFFFE6"><table width="500" border="0" cellspacing="1" cellpadding="5">
                                                      <tr>
                                                        <td colspan="2" bgcolor="#FFE4CA">(�P)�A�b�v���[�h����</td>
                                                      </tr>
                                                      <tr>
                                                        <td width="20%" valign="top"><input name="addcheck" type="radio" value="1" />
                                                          �ǉ��A�b�v���[�h<br />
                                                          <br /></td>
                                                        <td width="80%">CSV�t�@�C���̃f�[�^��V�K�o�^���܂��B<br>
                                                          <font color="#FF0000"><br>
                                                          <strong>���u�o�^�ҏ��v�ɓo�^����Ă��郁�[���A�h���X�͍폜����܂���B </strong></font></td>
                                                      </tr>
                                                      <tr>
                                                        <td valign="top" nowrap><input name="addcheck" type="radio" value="0" />
                                                          �㏑���A�b�v���[�h</td>
                                                        <td valign="top">CSV�t�@�C���̃f�[�^�Łu�o�^�ҏ��v���㏑�����܂��B<br>
                                                          �u�o�^�ҏ��v�ɓo�^�ς݂̃f�[�^�͏㏑������A<br>
                                                          ���o�^�̃f�[�^�͐V�K�o�^����܂��B <br>
                                                          <br>
                                                          <strong><font color="#FF0000">��CSV�t�@�C���f�[�^�ɖ������[���A�h���X�́u�o�^�ҏ��v����폜����܂��B</font></strong></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><table width="450" align="center" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td bgcolor="#999999"><table width="450" border="0" cellpadding="10" cellspacing="1">
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF">�y�����Ӂz<br>
                                                                      <br>
                                                                      �u�A�b�v���[�h�����v�̑I���Ɋ֌W�Ȃ��ACSV�t�@�C���ɏd�����ēo�^����Ă��郁�[���A�h���X�́A��ʂ̃��[���A�h���X���c���폜����܂��B<br>
                                                                      �܂��A���[���A�h���X���ڂ��󔒂̃f�[�^�s�͖�������܂��B</td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" bgcolor="#FFE4CA">(�Q)�d�����ēo�^����Ă��郁�[���A�h���X�̍폜</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><input name="dup" type="checkbox" id="dup" value="1" />
                                                          �d�����ēo�^����Ă��郁�[���A�h���X���폜����</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" align="center"><table width="450" border="0" cellspacing="0" cellpadding="2">
                                                            <tr>
                                                              <td width="450">�u�㏑���A�b�v���[�h�v��CSV�t�@�C�����A�b�v���[�h����ꍇ�A�u�o�^�ҏ��v�ɏd�����ēo�^����Ă��郁�[���A�h���X�͏㏑���X�V����܂���B<br>
                                                                �d�����ēo�^����Ă��郁�[���A�h���X���㏑���X�V���邽�߂ɂ́A�u�o�^�ҏ��v����d�����ēo�^����Ă��郁�[���A�h���X���폜����K�v������܂��B</td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><table width="450" align="center" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td bgcolor="#999999"><table width="450" border="0" cellpadding="10" cellspacing="1">
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF">�y�����Ӂz<br>
                                                                      <br>
                                                                      �u�o�^�ҏ��v�ɏd�����ēo�^����Ă��郁�[���A�h���X�́A��ԌÂ������c���폜����܂��B</td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" bgcolor="#FFE4CA">(�R)�z�M��w�� (�V�K�o�^���郆�[�U�[)</td>
                                                      </tr>
                                                      <tr>
                                                        <td align="right">�z�M�J�n��</td>
                                                        <td><select name="step" onchange="Interval();">
                                                            $step
                                                          </select><br><font color="#FF0000">���z�M���͔z�M����w�肵���ۂ̊J�n���t�ł��B</font></td>
                                                      </tr>
                                                      <tr>
                                                        <td align="right">�z�M�J�n��</td>
                                                        <td><input id="interval" type="text" name="interval" size="5" disabled style="background-color:#CCCCCC;">���ォ��J�n<br><font color="#FF0000">���ĊJ���z�M����w�肵���ꍇ�́A���͂��Ă��������B</font></td>
                                                      </tr>
                                                      <tr>
                                                        <td align="right" valign="top">�o�^�����[��</td>
                                                        <td><input name="sendflag" type="radio" value="0" checked="checked">
                                                          ���M���Ȃ�<br>
                                                          <input name="sendflag" type="radio" value="1">
                                                          ���M����</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><table width="450" border="0" align="center" cellpadding="2" cellspacing="0">
                                                            <tr>
                                                              <td><p>CSV�t�@�C�����V�K�o�^�����o�^�҂֓o�^�����[����z�M���邱�Ƃ��ł��܂��B<br>
                                                                <br>
                                                              </p>
                                                              </td>
                                                            </tr>
                                                          </table><table width="450" align="center" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td bgcolor="#999999"><table width="450" border="0" cellpadding="10" cellspacing="1">
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF"><p>�y���M���@�ɂ��āz</p>
                                                                      <p>���M���@�́u���M�����ݒ�v�̐ݒ�ɂ�茈�肳��܂��B<br>
                                                                          <br>
                                                                        ���o�b�N�O���E���h��CGI���N���ł���T�[�o�[�������p�̏ꍇ<br>
                                                                        <br>
                                                                        �u�����ő��M����v�ɐݒ肷�邱�ƂŁA��x�̔z�M����ł��ׂĂ̐V�K���[�U�[�փ��[���𑗐M���邱�Ƃ��ł��܂��B <br>
                                                                        �܂��A���̏ꍇCGI���펞�N�����Ă��Ă��A�T�[�o�[���ŋ����I�ɐؒf����Ȃ��K�v������܂��B<br>
                                                                        <br>
                                                                        ���o�b�N�O���E���h��CGI���N���łȂ��T�[�o�[�������p�̏ꍇ<br>
                                                                        <br>
                                                                        �u�A�N�Z�X���ɑ��M����v�ɐݒ肵�Ă��������B<br>
                                                                        ��x�̑��M����ő��M���������Ȃ������ꍇ�A�u�ꗗ���A�b�v���[�h�v��ʁi���̉�ʁj���蓮�ő��M�����s���Ă��������B</p></td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><table width="450" align="center" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                              <td bgcolor="#999999"><table width="450" border="0" cellpadding="10" cellspacing="1">
                                                                  <tr>
                                                                    <td bgcolor="#FFFFFF"><strong><font color="#FF0000">�y�d�v�����z</font></strong><br>
                                                                      <br>
                                                                      �u�y���[��PRO�v��CGI�v���O�����ł��邽�߁A����͐ݒu�����T�[�o�[�̔\\�͂Ɉˑ����܂��B<br>
                                                                      �T�[�o�[���̐����╉�ׂȂǂ̉e���Ŕz�M�����f�����ꍇ��z�M�G���[��������\\�����������܂��B<br />
                                                                      ��ʂ�CSV�t�@�C���f�[�^���ꊇ�o�^������A���[�U�[�������Ȃ�����Ԃł̈ꊇ���M���s���ꍇ�́A�����p�җl�̐ӔC�ɂ����ĐT�d�ɂ��肢�������܂��B</td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" bgcolor="#FFE4CA">(�S)�A�b�v���[�h����CSV�t�@�C���w��</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2"><input type="file" name="csvfile" size="60" /></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" align="center"><table width="450" border="0" cellspacing="0" cellpadding="2">
                                                            <tr>
                                                              <td width="450">�A�b�v���[�h����CSV�t�@�C�����u�Q�Ɓv��育�w�肭�������B</td>
                                                            </tr>
                                                          </table></td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" align="center"><input type="submit" name="Submit" value="�@�@�@�@�o�^�@�@�@�@" />
                                                          <input name="md" type="hidden" id="md" value="upload" />
                                                          <input name="id" type="hidden" id="id" value="$id" />
                                                        </td>
                                                      </tr>
                                                      <tr>
                                                        <td colspan="2" align="center">&nbsp;</td>
                                                      </tr>
                                                    </table></td>
                                                </tr>
                                              </table>
                                              <br>
                                              <br>
                                              <table  width="500" border="0" align="center" cellpadding="1" cellspacing="0">
                                                <tr>
                                                  <td bgcolor="#999999"><table width="500" border="0" cellpadding="5" cellspacing="0">
                                                      <tr>
                                                        <td bgcolor="#FFFFEC">�y�o�b�N�O���E���h�ł̑��M�������I�ɏI������Ă��܂����ꍇ�z<strong><br>  
                                                          <br>
                                                        </strong>����A���ׂ₻�̑��T�[�o�[�������Ńo�b�N�O���E���h�z�M�������I�ɏI������Ă��܂����ꍇ�A�ȉ��̕��@��
                                                          �z�M���ĊJ���邱�Ƃ��o���܂��B<br>
                                                          <br>
                                                          ���u���M�����v���A�N�Z�X�����M�ɐݒ肵�A���̃y�[�W���蓮�Ŕz�M���s���B<br>
                                                          ���z�M�����f���ꂽ����́u�z�M�����s����v�{�^�����z�M���s���B<br>
                                                          ���z�M�����f���ꂽ����̎����z�M�^�O�̃A�N�Z�X�ɂ��z�M���s���B<br>
                                                          �i�z�M�ݒ�}�j���A��.html�u�z�M��p�y�[�W�̐ݒ���@�v���Q�Ƃ��������j <br>
                                                          <br>
                                                          <font color="#FF0000"> �������I������Ȃ��悤�ɁA�T�[�o�[�X�y�b�N�ɍ��킹�u���M�����v�����肭�������B<br>
                                                          ���z�M�ĊJ�܂ł̊ԁA���v�����̃X�e�b�v���[�����̔z�M�ɉe�����邱�Ƃ͂������܂���B<br>
                                                          ���z�M���ĊJ���ꂽ�ꍇ�A�u�o�^���v���[�����D��I�ɔz�M����܂��B<br>
                                                          �������I���̉e���ɂ��A����Ȕz�M���ۏ�ł��Ȃ��ꍇ���������܂��B</font><br></td>
                                                      </tr>
                                                    </table></td>
                                                </tr>
                                              </table>
                                            </form></td>
                                          <td width="20">&nbsp;</td>
                                        </tr>
                                      </table>
END
	}elsif ( $page eq 'up_error' ){
		
		my( $session, $target ) = &get_csvup_session( $id );
		my $sendtable;
		if( $session ne '' ){
			local( $method, $each, $sleep, $partition ) = &send_method( \@errors );
			if( $method ){
				my $sendtag;
				my $message;
				my $sendact;
				my $flag    = "$myroot$data_dir$csv_dir" . $session;
				unless( -e $flag ){
					# �z�M�t���O�t�@�C�����쐬
					open(FLAG, ">$flag");
					close(FLAG);
					# �z�M�pIMG�^�O�쐬
					$sendtag = &csvup_sendtag( $session );
					$sendact = qq|�z�M���J�n���܂����B|;
					$message = qq|<br><br>���̏�������́u�Ǘ���ʁv�̃����N���N���b�N�����ۂ̓��삪�d�����Ȃ�ꍇ������܂��B���̍ۂ́A������x�Y���̃����N���N���b�N���Ă��������B|;
				}else{
					$sendact = qq|�z�M���ł��B|;
				}
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
       <tr>
        <td bgcolor="#FFFFFF"><font color="#FF0000"><strong>�ꗗ�A�b�v���[�h���V�K�ǉ������o�^�҂ցu�o�^�����[���v���o�b�N�O���E���h��$sendact</strong>$message</font>$sendtag</td>
       </tr>
      </table>
    </td>
  </tr>
</table><br><br>�@
END
			}else{
				open(LIST,$target);
				my $n = 0;
				while(<LIST>){
					$n++;
				}
				close(LIST);
				my $next = ( $each > $n )? $n: $each;
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
        <tr>
          <td bgcolor="#FFFFFF"><strong><font color="#FF0000">�ꗗ�A�b�v���[�h���V�K�ǉ������o�^�҂ւ̓o�^�����[�����z�M���𑗐M���Ă��������B</font>(�c��F$n��)</strong>
           <br><br><a href="$indexcgi?md=upsend&ss=$session"><font color="#0000FF">&gt;&gt;����$next���𑗐M����</font></a><br><br>
           �A���Ŕz�M���s���܂��ƁA�����p�̃T�[�o�̔\\�͂ɂ��܂��Ă͑�ʔz�M�ɂ�蕉�ׂ��������邱�Ƃɂ��z�M�G���[��������\\�����������܂��B
           ��ʂ̃��X�g���ꊇ�o�^������A���[�U�[�������Ȃ�����Ԃł̈ꊇ���M�y�ѓ��t�w��z�M���s���ꍇ�͂����p�җl�̐ӔC�ɂ����ĐT�d�ɂ��肢�������܂��B</td>
        </tr>
      </table>
    </td>
  </tr>
</table><br><br>�@
END
			}
		}
		
		my $message;
		my $rep = 0;
		# �d���o�^�ς�
		if( $param{'mail_overlap'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_overlap'}} ){
				$sel .= qq|$_�s�� $param{'mail_overlap'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|���u�o�^�ҏ��v�ɏd�����ēo�^�ς݂̃��[���A�h���X<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# �`���s��
		if( $param{'mail_format'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_format'}} ){
				$sel .= qq|$_�s�� $param{'mail_format'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|�����[���A�h���X�̌`�����������Ȃ��Ǝv����s<br>�@�@(���[���A�h���X�̑O��ɃX�y�[�X��S�p�����܂܂�Ă���Ȃ�)<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# �d��
		if( $param{'mail_repeat'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_repeat'}} ){
				$sel .= qq|$_�s�� $param{'mail_repeat'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|��CSV�t�@�C���ɏd�����ēo�^����Ă��郁�[���A�h���X�s<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# �o�^�ς݁i�ǉ��̏ꍇ�j
		if( $param{'mail_alr'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_alr'}} ){
				$sel .= qq|$_�s�� $param{'mail_alr'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|�����łɓo�^�ς݂̃��[���A�h���X�s<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# �o�^�s�����������ꍇ
		if( $message ne '' ){
			$message = qq|�ȉ��̃f�[�^�̓G���[������A�o�^�ł��܂���ł����B<br><br>$message|;
		}
		
		$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td align="center"><br><strong><font color="#FF0000">CSV�t�@�C���̃A�b�v���[�h���������܂����B</font></strong></td>
                                          </tr>
                                          <tr> 
                                            <td>$sendtable &nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$message</td>
                                          </tr>
                                           <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$rep_message</td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
		
    }elsif ( $page eq 'up_error' ){
		
		my( $session, $target ) = &get_csvup_session( $id );
		my $sendtable;
		if( $session ne '' ){
			local( $method, $each, $sleep, $partition ) = &send_method( \@errors );
			if( $method ){
				my $sendtag;
				my $message;
				my $sendact;
				my $flag    = "$myroot$data_dir$csv_dir" . $session;
				unless( -e $flag ){
					# �z�M�t���O�t�@�C�����쐬
					open(FLAG, ">$flag");
					close(FLAG);
					# �z�M�pIMG�^�O�쐬
					$sendtag = &csvup_sendtag( $session );
					$sendact = qq|�z�M���J�n���܂����B|;
					$message = qq|<br><br>���̏�������́u�Ǘ���ʁv�̃����N���N���b�N�����ۂ̓��삪�d�����Ȃ�ꍇ������܂��B���̍ۂ́A������x�Y���̃����N���N���b�N���Ă��������B|;
				}else{
					$sendact = qq|�z�M���ł��B|;
				}
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
       <tr>
        <td bgcolor="#FFFFFF"><font color="#FF0000"><strong>�ꗗ�A�b�v���[�h���V�K�ǉ������o�^�҂ցu�o�^�����[���v���o�b�N�O���E���h��$sendact</strong>$message</font>$sendtag</td>
       </tr>
      </table>
    </td>
  </tr>
</table><br><br>�@
END
			}else{
				open(LIST,$target);
				my $n = 0;
				while(<LIST>){
					$n++;
				}
				close(LIST);
				my $next = ( $each > $n )? $n: $each;
				$sendtable = <<"END";
<br>
<table width="450" border="0" cellspacing="0" cellpadding="1" align="center">
  <tr>
    <td bgcolor="#000000">
      <table width="450" border="0" cellspacing="0" cellpadding="10" align="center">
        <tr>
          <td bgcolor="#FFFFFF"><strong><font color="#FF0000">�ꗗ�A�b�v���[�h���V�K�ǉ������o�^�҂ւ̓o�^�����[�����z�M���𑗐M���Ă��������B</font>(�c��F$n��)</strong>
           <br><br><a href="$indexcgi?md=upsend&ss=$session"><font color="#0000FF">&gt;&gt;����$next���𑗐M����</font></a><br><br>
           �A���Ŕz�M���s���܂��ƁA�����p�̃T�[�o�̔\\�͂ɂ��܂��Ă͑�ʔz�M�ɂ�蕉�ׂ��������邱�Ƃɂ��z�M�G���[��������\\�����������܂��B
           ��ʂ̃��X�g���ꊇ�o�^������A���[�U�[�������Ȃ�����Ԃł̈ꊇ���M�y�ѓ��t�w��z�M���s���ꍇ�͂����p�җl�̐ӔC�ɂ����ĐT�d�ɂ��肢�������܂��B</td>
        </tr>
      </table>
    </td>
  </tr>
</table><br><br>�@
END
			}
		}
		
		my $message;
		my $rep = 0;
		# �d���o�^�ς�
		if( $param{'mail_overlap'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_overlap'}} ){
				$sel .= qq|$_�s�� $param{'mail_overlap'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|���u�o�^�ҏ��v�ɏd�����ēo�^�ς݂̃��[���A�h���X<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# �`���s��
		if( $param{'mail_format'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_format'}} ){
				$sel .= qq|$_�s�� $param{'mail_format'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|�����[���A�h���X�̌`�����������Ȃ��Ǝv����s<br>�@�@(���[���A�h���X�̑O��ɃX�y�[�X��S�p�����܂܂�Ă���Ȃ�)<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# �d��
		if( $param{'mail_repeat'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_repeat'}} ){
				$sel .= qq|$_�s�� $param{'mail_repeat'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|��CSV�t�@�C���ɏd�����ēo�^����Ă��郁�[���A�h���X�s<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# �o�^�ς݁i�ǉ��̏ꍇ�j
		if( $param{'mail_alr'} ne '' ){
			my $sel = qq|<textarea rows="5" cols="40">|;
			foreach( sort { $a <=> $b } keys %{$param{'mail_alr'}} ){
				$sel .= qq|$_�s�� $param{'mail_alr'}->{$_}\n|;
			}
			$sel .= qq|</textarea>|;
			$message .= qq|�����łɓo�^�ς݂̃��[���A�h���X�s<br>|;
			$message .= $sel;
			$message .= '<br><br>';
		}
		# �o�^�s�����������ꍇ
		if( $message ne '' ){
			$message = qq|�ȉ��̃f�[�^�̓G���[������A�o�^�ł��܂���ł����B<br><br>$message|;
		}
		
		$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td align="center"><br><strong><font color="#FF0000">CSV�t�@�C���̃A�b�v���[�h���������܂����B</font></strong></td>
                                          </tr>
                                          <tr> 
                                            <td>$sendtable &nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$message</td>
                                          </tr>
                                           <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td>$rep_message</td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
		
	}elsif ( $page eq 'mf1' || $page eq 'mf2' || $page eq 'mf3' || $page eq 'sprev' ) {
		# �o�^�p�t�H�[���̃\�[�X��\��
		my @data;
		my $type;
		my $url;
		if ( $page eq 'mf1'|| $page eq 'sprev' ) { @data = @line[15 .. 32, 43 .. 57, 61 .. 65, 66 .. 75]; $type = 'form1'; $url = $line[12]; }
		elsif ( $page eq 'mf2' ) { @data = $line[33]; $type = 'form2';  $url = $line[13]; }
		elsif ( $page eq 'mf3' ) { @data = $line[34]; $type = 'form3';  $url = $line[14]; }
		my( $source, $source_m ) = &make_form( 0, $id, $type, $url, $line[39], $line[58], $line[59], $line[81], @data );
		
		if( $page eq 'sprev' ){
			my $display = ( $param{'m'} )? $source_m: $source;
			$display =~ s/type\=[\"|\']?submit[\"|\']?/type=\"button\" /gi;
			$display =~ s/onclick\=[\"|\']?.+[\"|\'\\s]?(.*)>/$1>/ig;
			print <<"END";
Content-type: text/html

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis" />
</head>
<body>
$display
</body>
</html>
END
			exit;
		}
		
		$source = &deltag( $source );
		$source_m = &deltag( $source_m );
        $main_table = <<"END";
                                <table width="100%" cellpadding="3" cellspacing="0" border="0">
                                <tr>
                                <td>�ȉ��̃\\�[�X��<strong>�C�ӂ�HTML�t�@�C����</strong>�ɃR�s�[���Ďg�p���Ă�������
                                </td>
                                </tr>
                                <tr>
                                  <td>&nbsp;</td>
                                </tr>
                                <tr>
                                  <td bgcolor="#FFCC66">��PC��p�T���v��HTML�\\�[�X</td>
                                </tr>
                                <tr>
                                <td>
                                <textarea cols="60" rows="20" onFocus="this.select();">
$source</textarea>
                                </td>
                                </tr>
                                <tr>
                                  <td>&nbsp;</td>
                                </tr>
                                <tr>
                                  <td bgcolor="#FFCC66">���g�ѐ�p�T���v��HTML�\\�[�X</td>
                                </tr>
                                 <tr>
                                  <td><font color="#FF0000">���S�Ă̌g�тœ����ۏ؂�����̂ł͂���܂���B</font></td>
                                </tr>
                                <tr>
                                <td>
                                <textarea cols="60" rows="20" onFocus="this.select();">
$source_m</textarea></td>
                                </tr>
                                <tr>
                                </table>
<br><br>
<TABLE cellSpacing="0" cellPadding="5" width="500" border="0">
  <TBODY>
    <TR>
      <TD bgcolor="#FFCC66">���o�^�E�ύX�E����������ʂ𓯈�E�B���h�E�ŕ\\������ɂ�</TD>
    </TR>
    <TR>
      <TD bgcolor="#FFFFEE">
	<font color="#FF0000">���u�o�^�ݒ�v�Ŋ�����URL�����Ă���ꍇ</font><br>
	�@����E�B���h�E�Ŋm�F��ʁE������ʂ�\\�����܂��B<br>
	<br>
	<font color="#FF0000">���u�o�^�ݒ�v�Ŋ�����URL�����Ă��Ȃ��ꍇ</font><br>
	�@�|�b�v�A�b�v�E�C���h�E�ɂĊm�F��ʁE������ʂ�\\�����܂��B<br>
	�@���̏ꍇ�A����E�C���h�E�ł̕\\���؂�ւ����@�͈ȉ��̒ʂ�ł��B<br>
	�P�j<br>
        <strong>&lt;form name=&quot;form1&quot; method=&quot;post&quot; action=&quot;URL&quot; target=&quot;new&quot;&gt;</strong><br>
        ��L�̍s�́A<br>
        <font color="#FF0000">target=&quot;new&quot;</font><br>
        ���̕������폜���Ă��������B<br>
        <br>
        �Q�j<br>
        <strong>&lt;input type=&quot;submit&quot;   value=&quot;�@�o�^�@&quot;<br>
        onClick=&quot;window.open('','new','height=300,width=500,scrollbars=yes');&quot;&gt;</strong><br>
        ��L�̍s�́A<br>
        <font color="#FF0000">onClick=&quot;window.open('','new','height=300,width=500,scrollbars=yes');&quot;</font><br>
        ���̕������폜���Ă��������B<br></TD>
    </TR>
    <TR>
      <TD bgcolor="#FFCC66">�����̑��t�H�[���Ɋւ��钍�ӎ���</TD>
    </TR>
    <TR>
      <TD bgcolor="#FFFFEE">�P�D&lt;%***%&gt;�ƋL�q����Ă���ӏ��͕ҏW�E�폜���Ȃ��ł��������B<br>
        �Q�D&lt;form&gt;   �` &lt;/form&gt;����&lt;form&gt;�͓���Ȃ��ł��������B<br>
        �R�D&lt;input   name=&quot;***&quot;�@�`&gt;�́uname=&quot;***&quot;�v�����͕ҏW�E�폜���Ȃ��ł��������B<br>
        �S�D�T���v����HTML�\\�[�X�Ő�������鍀�ڈȊO�̃f�[�^�͂����p���������܂���B<br>
        �T�D�z�[���y�[�W�r���_�[�̎����C���@�\\���~���Ă��������B</TD>
    </TR>
  </TBODY>
</TABLE>

END
	}elsif ( $page eq 'preview' || $page eq 'body' || $page eq 'html' ) {
		#-------------------------------------
		# �{���̃v���r���[�A�X�V
		#-------------------------------------
		my $n = &delspace( $param{'n'} );
		$n -= 0 if ( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );# ra �ʐݒ�
		my $num = $n+1;
		$num = ($n>0)? "��$num��": '�o�^��';
		$num = '�ύX��' if( $n eq 'r' );
		$num = '������' if( $n eq 'c' );
		$num = '�o�^��(�Ǘ��Ғʒm��p)' if( $n eq 'ra' );
		if ( $n =~ /^d(\d+)/ ) {
			my $mon = substr($n, 1, 2 ) - 0;
			my $day = substr($n, 3, 2 ) - 0;
			$num = $mon . '��' . $day . '��';
		}
		
		if( $n =~ /^\d+$/ ){
			# �ȈՃ^�O�C���i�]���A�h���X�j
			&remakeTag( $id );
		}
		
		
		# �ʐݒ�̗��p
		my $ra_conf = $line[77] - 0;
		
		my $file = $myroot . $data_dir . $queue_dir . $line[7];
		unless ( open(BODY, $file) ) {
			&make_plan_page( 'plan', '', "�V�X�e���G���[<br><br>$file���J���܂���<br>�p�[�~�b�V�������m�F���Ă�������");
		}
		my ( $index, $h, $c, $body, $f, $ctype, $filename );
		local $btitle;
		while( <BODY> ) {
			chomp;
			( $index, $btitle, $h, $c, $body, $f, $ctype, $filename ) = split(/\t/);
			last if ( $index eq $n );
			( $index, $btitle, $h, $c, $body, $f, $ctype, $filename ) = undef;
		}
		if ( $page eq 'preview' ) {
			
			# �]��
			$body = &Click'prev1( $id, $body ) if( $n =~ /^\d+$/ );
			
			$btitle = &make_text( $btitle );
			$btitle = &reInclude( $btitle );
			$btitle = &include( \@temdata, $btitle, '', 1 );
			
			my $header = &include(\@temdata, &reInclude(&make_text($line[9])), '', 1)  if ( $h );
			my $cancel = &include(\@temdata, &reInclude(&make_text($line[10])), '', 1)  if ( $c );
			my $footer = &include(\@temdata, &reInclude(&make_text($line[11])), '', 1)  if ( $f );
			
			$body = &make_text( $body );
			$body = &reInclude( $body );
			$body = &include( \@temdata, $body, '', 1 );
			
			# �]���ϊ�(�v���r���[�p)
			$body = &Click'prev2( $body ) if( $n =~ /^\d+$/ );
			
			my $estab    = ( $ctype )? 'HTML�`��':  '�e�L�X�g�`��';
			my $prevhtml = ( $filename eq '' )? '�ݒ肳��Ă��܂���B': qq|<a href="$indexcgi?md=htmlprev&id=$id&n=$n" target="_blank"><font color="#0000FF">HTML�t�@�C���̃v���r���[</font></a>|;
			
			# �o�^���ʐݒ�
			if( $n eq '0' ){
				$sub_link_r = qq|<a href="$main'indexcgi?md=p&n=ra&id=$id"><font color="#0000FF">&gt;&gt;�y�Ǘ��Ғʒm��p�z�{��������</font></a><br>&nbsp;|;
			}
			if( $n eq 'ra' ){
				$sub_link_r = qq|<a href="$main'indexcgi?md=p&n=0&id=$id"><font color="#0000FF">&gt;&gt;�ʏ�́y�o�^���z�{��������</font></a><br>&nbsp;|;
				my $conf = ( $ra_conf )? '����': '���Ȃ�';
				$sub_radio = qq|<tr><td bgcolor="#EEEEEE">���p</td><td>$conf</td></tr><tr><td colspan="2">&nbsp;</td></tr>|;
			}
			
			
			$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="499"><table width="100%" border="0" cellspacing="0" cellpadding="2">
                                        <tr> 
                                          <td colspan="2"><strong>�{���̃v���r���[[ $num ] </strong>��\\�����Ă��܂�</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2">�ҏW����ꍇ�́u<strong>�ҏW����</strong>�v�{�^�����N���b�N���Ă�������</td>
                                        </tr>
                                        <tr>
                                          <td colspan="2">$sub_link_r&nbsp;</td>
                                        </tr>
       $sub_radio
	                                    <tr> 
                                          <td width="64" bgcolor="#EEEEEE">�薼</td>
                                          <td width="435">$btitle</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#EEEEEE">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td valign="top" bgcolor="#EEEEEE">�w�b�_�[</td>
                                          <td>$header</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#EEEEEE">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td valign="top" bgcolor="#EEEEEE">�{��</td>
                                          <td>$body</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#EEEEEE">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td valign="top" bgcolor="#EEEEEE">�����ē�</td>
                                          <td>$cancel</td>
                                        </tr>
                                        <tr> 
                                          <td bgcolor="#EEEEEE">&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td valign="top" bgcolor="#EEEEEE">�t�b�^�[</td>
                                          <td>$footer</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#EEEEEE">HTML�`��</td>
                                          <td>$prevhtml</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#EEEEEE">����`��</td>
                                          <td><font color="#FF0000">$estab</font> �ɐݒ肳��Ă��܂��B</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr align="center"> 
                                          <td colspan="2"><form action="$indexcgi" method="post" name="" id="">
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="n" type="hidden" id="n" value="$n">
                                              <input name="md" type="hidden" id="md" value="ml">
                                              <input type="submit" name="Submit" value="�@�ҏW����@">
                                            </form></td>
                                        </tr>
                                        <tr>
                                          <td colspan="2" bgcolor="#FFFFFF"><em><font color="#336600">&lt;���ږ�&gt;</font></em> �E�E�e�o�^�ҏ��̓��͒l����ѐ�p�̃f�[�^�ɕϊ�����܂��B<br>
                                            <font color="#FF0000">���u���M�e�X�g�v�̖{���ł�&lt;���ږ�&gt;�ƕϊ����ꑗ�M����܂��B</font></td>
                                        </tr>
                                      </table></td>
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
END
		}elsif( $page eq 'body' ){
            # �{���ҏW
			$h = 'checked' if ( $h );
			$c = 'checked' if ( $c );
			$f = 'checked' if ( $f );
			
			# �e�L�X�g�`�� or HTML�`��
			my $_text = ( !$ctype )? 'checked': '';
			my $_html = ( $ctype )? 'checked': '';
			$btitle = &make_text( $btitle );
			$body =~ s/<br>/\n/gi;
			$body = &make_text( $body );
			$main_table = &form_mailbody_top( $h, $c, $f, $_text, $_html, $num, $btitle, $body, $n, $id, $ra_conf );
		}elsif( $page eq 'html' ){
			$main_table = &form_mailbody_html( $h, $c, $f, $_text, $_html, $num, $btitle, $body, $n, $id, $filename );
		}
	} elsif ( $page eq 'schedule' ) {
        # �v�����̓���
		$main_table = &make_schedule( $id, 1, $line[35], $line[36] );
	} elsif ( $page eq 'guest' ) {
        # �o�^�ҏ��
        $main_table = &make_guest_table( $id, $line[6] );
    } elsif ( $page eq 'mail' ) {
		
		&Simul'running();
		
		# �ȈՃ^�O�C���i�]���A�h���X�j
		&remakeTag( $id );
		
        # �o�^�҂ւ̃��[���쐬
		my $btitle = &main'deltag( $main'param{'title'} );
		my $body = &main'the_text( $main'param{'body'} );
		$body  = &main'make_text( $body );
		$body =~ s/<br>/\n/gi;
		my $h = ' checked="checked"' if( $main'param{'header'} );
		my $c = ' checked="checked"' if( $main'param{'cancel'} );
		my $f = ' checked="checked"' if( $main'param{'footer'} );
		
		my $cdn;
		my $method_bg;
		my $method_ma;
		my $search;
		my $cdn_table;
		my $hidden;
		my $cdn_sid;
		my $cdn_filepath;
		my $rebody = 0;
		my $method = 1;
		my $set_mode = 'mailnext';
		if( $param{'md'} eq 'simul_cdn_set' ){
			$method = $main'param{'method'} -0;
			( $cdn_sid, $cdn_filepath ) = &Simul'cdn_session();
			( $search, $cdn_table, $hidden ) = &Simul'cdn_prop( $id, [@line] );
			$set_mode = 'simul_cdn_conf';
			$rebody = 1;
		}
		$method_bg = ' checked="checked"' if( $method );
		$method_ma = ' checked="checked"' if( !$method );
		
		$simul_src = 'http://' . $ENV{'SERVER_NAME'} .  $ENV{'SCRIPT_NAME'} . '?md=slch';
        $main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="500"><table width="500" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="500"> <form name="form1" method="post" action="$indexcgi">
                                              <table width="490" border="0" cellspacing="0" cellpadding="2">
                                                <tr> 
                                                  <td colspan="2" width="450"><strong>�{��</strong>���쐬���܂��B<br><br>
�z�M�v�����Ƃ͕ʂɁA�Վ��Ƀ��[����z�M����ꍇ�ɁA�u�o�^�҂փ��[�����M�v���g�p���Ă��������B<br><br>
<font color="FF0000">
���u�o�^�҂փ��[�����M�v�ł́A<strong>�g�s�l�k�`�����[��</strong>�͔�Ή��ƂȂ��Ă���܂��B<br>
�@ �g�s�l�k���[������đ��M�������ꍇ�́A<strong>�u���t�w��z�M�v</strong>�������p���������B
</font>
                                                  </td>
                                                </tr>
 
                                                <tr> 
                                                  <td colspan="2"><br>���͌�A�u<strong>����</strong>�v�{�^�����N���b�N���Ă�������</td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td width="70">�薼</td>
                                                  <td width="420"><input name="title" type="text" id="title" value="$btitle" size="50"></td>
                                                </tr>
                                                <tr> 
                                                  <td>�w�b�_�[</td>
                                                  <td><input name="header" type="checkbox" id="header" value="1" $h>
                                                    �}������</td>
                                                </tr>
                                                <tr>
                                                  <td>&nbsp;</td>
                                                  <td bgcolor="#FFFFE1"><font color="#FF0033">���ȈՃ^�O</font>
                                                  <select onchange="this.form.convtag.value = this.value;">$mail_reflect_tag</select>&nbsp;<input type="text" style="background-color:#EEEEEE" name="convtag" size="15" onfocus="this.select();">
                                                  </td>
                                                </tr>
                                                <tr> 
                                                  <td>�{��</td>
                                                  <td width="400"><textarea name="body" cols="50" rows="20" id="body">$body</textarea></td>
                                                </tr>
                                                <tr> 
                                                  <td>�����ē�</td>
                                                  <td><input name="cancel" type="checkbox" id="cancel" value="1" $c>
                                                    �}������</td>
                                                </tr>
                                                <tr> 
                                                  <td>�t�b�^�[</td>
                                                  <td><input name="footer" type="checkbox" id="footer" value="1" $f>
                                                    �}������</td>
                                                </tr>
   <tr>
    <td colspan="2"><br><br>
    �� �z�M���@��I�����Ă�������
<table width="450" border="0" cellspacing="1" cellpadding="5">
  <tr>
    <td colspan="2" valign="top" nowrap="nowrap" bgcolor="#FFFFFF"><input name="method" type="radio" value="1"$method_bg />
�o�b�N�O���E���h�Ŕz�M����(��)</td>
  </tr>
  <tr>
    <td width="70" valign="top" nowrap="nowrap" bgcolor="#FFFFFF">&nbsp;</td>
    <td width="350" valign="top" nowrap="nowrap" bgcolor="#FFFFFF">�u���M�����ݒ�v�́u�����ő��M����v�Őݒ肳�ꂽ���@�ł̎������M����</td>
  </tr>
  <tr>
    <td colspan="2" valign="top" nowrap="nowrap" bgcolor="#FFFFFF"><input name="method" type="radio" value="0"$method_ma />
�蓮�Ŕz�M����</td>
  </tr>
  <tr>
    <td width="70" valign="top" nowrap="nowrap" bgcolor="#FFFFFF">&nbsp;</td>
    <td width="350" bgcolor="#FFFFFF">�u���M�����ݒ�v�́u�A�N�Z�X���ɑ��M����v�Őݒ肳�ꂽ�������ɃN���b�N����K�v�̂���蓮���M����</td>
  </tr>
  <tr>
    <td colspan="2">
	 <table width="400"align="center"><tr><td>���K�{����<br>
      ���o�b�N�O���E���h��CGI�̋N�����ł���T�[�o�[�ł��邱�ƁB<br>
      ��CGI���펞�N�����Ă��Ă��A�T�[�o�[���ŋ����I�ɐؒf����Ȃ����ƁB</td></tr></table></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" bgcolor="#FFFFE1"><br>
<p>���z�M��������юd�l�ɂ���</p>
<font color="#FF0000">��đ��M���s���́A���̑����ׂẴv�������܂߂āA��ă��[�����M�̎��s��<br>�s���܂���B<br>
<br>�u�y���[��PRO�v��CGI�v���O�����ł��邽�߁A����͐ݒu�����T�[�o�[�̔\\�͂Ɉˑ����܂��B<br>
�T�[�o�[���̐����╉�ׂȂǂ̉e���Ŕz�M�����f�����ꍇ��z�M�G���[��������\\�����������܂��B<br>
���g�p�̃T�[�o�[�X�y�b�N�ɍ��킹�A�����p�җl�̐ӔC�ɂ����ĐT�d�ɂ��肢�������܂��B</font><br><br>

<p>���o�b�N�O���E���h�z�M�������I�ɏI������Ă��܂����ꍇ</p>

���ꕉ�ׂ₻�̑��T�[�o�[�������Ńo�b�N�O���E���h�z�M�������I�ɏI������Ă��܂����ꍇ�A�ȉ��̕��@��
�z�M���ĊJ���邱�Ƃ��o���܂��B<br><br>

������̃��O�C�����Ɏ����I�ɍĊJ����܂��B<br>
�����O�C�����̏ꍇ�A���̃y�[�W�ɃA�N�Z�X���邱�ƂōĊJ����܂��B<br>
���z�M�ĊJ�p��img�^�O��\\��t�����y�[�W�ɃA�N�Z�X���邱�ƂōĊJ����܂��B<br><br>

��img�^�O�ɂ��ā�
<br>�ȉ��^�O��C�Ӄy�[�W��&lt;body&gt;���ɓ\\��t���Ă��������B<br>
<strong>&lt;img src="$simul_src" border="0" width="1" height="1"&gt;</strong><br>
(�����ۂ́A���s���܂߂Ȃ�)
<br><br>
<font color="#FF0000">
�������I������Ȃ��悤�ɁA�T�[�o�[�X�y�b�N�ɍ��킹�u���M�����v��<br>�@ ���肵�Ă��������B<br>
���z�M�ĊJ�܂ł̊ԁA�X�e�b�v���[�����̔z�M�ɉe�����邱�Ƃ͂������܂���B<br>
�������I���̉e���ɂ��A����Ȕz�M���ۏ�ł��Ȃ��ꍇ���������܂��B</font><br><br>
�@    </td>
  </tr>
</table>
    </td>
  </tr>
                                                <tr> 
                                                  <td colspan="2" align="left"> <br><br>
                                                    <input name="id" type="hidden" id="id" value="$id">
                                                    <input name="md" type="hidden" id="md" value="$set_mode">
                                                    <input type="submit" value="�@�@�@���ց@�@�@"></td>
$hidden
                                                    <input name="cdn_sid" type="hidden" id="cdn_sid" value="$cdn_sid">
                                                    <input name="rebody" type="hidden" id="rebody" value="$rebody">
                                                </tr>
                                              </table>
                                            </form></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table>
END
    }elsif ( $page eq 'mailnext' ) {
		
		# ��ӂ̃��j�[�NID�𐶐�
		my $uniq = crypt( $$, &make_salt() );
		
		# �z�M���@
		my $method = $param{'method'} -0;
		my $method_mes = ( $method )? '�o�b�N�O���E���h�z�M': '�蓮�z�M';
		
	 	&Simul'background_check() if( $method );
		&Simul'running();
        # �o�^�҂ւ̃��[�����M�I��
		my @csvs = &get_csvdata( $id );
		
		#my $btitle = &deltag( &include( \@temdata, $param{'title'} ) );
		my $btitle = &make_text( $param{'title'} );
		$btitle = &reInclude( $btitle );
		$btitle = &include( \@temdata, $btitle, '', 1 );
		
		
		my $_btitle = &deltag( $param{'title'} );
		my $body = &the_text( $param{'body'} );
		$body  = &make_text( $body );
		
		# �]���ϊ�
		$pbody = &Click'prev1( $id, $main'param{'body'} );
		
		$pbody = &make_text( $pbody );
		$pbody = &reInclude( $pbody );
		$pbody = &include( \@temdata, $pbody, '', 1 );
		$pbody =~ s/\n/<br \/>/ig;
		
		# �]���ϊ�(�v���r���[�p)
		$pbody = &Click'prev2( $pbody );
		
		#$pbody = &include( \@temdata, $param{'body'} );
		#$pbody = &the_text( $pbody );
		#$pbody = &make_text( $pbody );
		my $header  = $line[9] if ($param{'header'});
		my $cancel  = $line[10] if ($param{'cancel'});
		my $footer  = $line[11] if ($param{'footer'});
		
		$header = &make_text( $header );
		$header = &reInclude( $header );
		$header = &include( \@temdata, $header, '', 1 );
		
		$cancel = &make_text( $cancel );
		$cancel = &reInclude( $cancel );
		$cancel = &include( \@temdata, $cancel, '', 1 );
		
		$footer = &make_text( $footer );
		$footer = &reInclude( $footer );
		$footer = &include( \@temdata, $footer, '', 1 );
		
		my $table;
		my $ed;
		my $count;
        foreach ( @csvs ) {
			if( $count >= 1000 ){
				$count = 0;
				select(undef, undef, undef, 0.20);
			}
			$count++;
            chomp;
            my ( $index, $name, $mail ) = ( split(/\t/) )[0, 3, 5];
			next if( index($ed, $mail) >= 0 );
			$ed .= "#$mail";
            $name = &make_text( $name );
            $name = '&nbsp;' if ( $name eq '' );
            $mail = &make_text( $mail );
            $table .= <<"END";
                                   <tr>
                                    <td align="center"><input type="checkbox" name="sm$index" value="1">
                                    </td>
                                    <td>$mail
                                    </td>
                                    <td>$name
                                    </td>
                                    </tr>
END
        }
        $main_table = <<"END";
                               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                <td width="20">&nbsp;</td>
                                <td width="450"">
                                  <form action="$indexcgi" method="POST">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                  <tr> 
                                  <td>$btitle</td>
                                  </tr>
                                  <tr>
                                  <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                  <td>$header</td>
                                  </tr>
                                  <tr> 
                                  <td>$pbody</td>
                                  </tr>
                                  <tr> 
                                  <td>$cancel</td>
                                  </tr>
                                  <tr> 
                                  <td>$footer</td>
                                  </tr>
                                  <tr> 
                                  <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                  <td>�z�M���@�F $method_mes  <input type="hidden" name="method" value="$method"></td>
                                  </tr>
                                         <tr>
                                          <td bgcolor="#FFFFFF" align="right"><br><em><font color="#336600">&lt;���ږ�&gt;</font></em> �E�E�e�o�^�ҏ��̓��͒l����ѐ�p�̃f�[�^�ɕϊ�����܂��B<br>
                                            <font color="#FF0000">���Ǘ��҈��֑��M����{���ł�&lt;���ږ�&gt;�ƕϊ����ꑗ�M����܂��B</font><hr></td>
                                        </tr>
                                  <tr>
                                  <td><strong>�����M����o�^�҂�I�����Ă��������B</strong><br><font color="#FF0000">�i���d�����ēo�^����Ă��郁�[���A�h���X�ւ͂P�ʂ̂ݑ��M���܂��j</font>
                                  </td>
                                  </tr>
                                  <tr>
                                  <td><input type="submit" name="simul_cdn" value="�@�������w�肵�Ĕz�M����@"><br>
 <input type="radio" name="all" value="0" checked>���ׂĂ̓o�^�҂ɑ��M����<br>
 <input type="radio" name="all" value="1">�`�F�b�N�����o�^�҂ɑ��M����<br>
 <input type="radio" name="all" value="2">�`�F�b�N�����o�^�҈ȊO�ɑ��M����
                                  </td>
                                  </tr>
                                  <tr>
                                  <td width="450">
                                    
                                    <table width="100%" border="1" cellspacing="0" cellpadding="2">
                                    <tr>
                                    <td width="26" align="center">�I��
                                    </td>
                                    <td width="140">���[���A�h���X
                                    </td>
                                    <td width="90">�����O
                                    </td>
                                    </tr>
                                    $table
                                    </table>
                                  </td>
                                  </tr>
                                  <tr>
                                  <td><input type="submit" value="�@���M����@" onClick="return confir('���M���܂����H');">
                                  </td>
                                  </tr>
                                  </table>
                                  <input type="hidden" name="md" value="mailsend">
                                  <input type="hidden" name="id" value="$id">
                                  <input type="hidden" name="title" value="$_btitle">
                                  <input type="hidden" name="header" value="$param{'header'}">
                                  <input type="hidden" name="cancel" value="$param{'cancel'}">
                                  <input type="hidden" name="body" value="$body">
                                  <input type="hidden" name="footer" value="$param{'footer'}">
                                  <input type="hidden" name="uniq" value="$uniq">
                                  </form>
                                
                                </td>
                                </tr>
                                </table>
END
	}elsif ( $page eq 'simul_cdn' ){
		$main_table = &Simul'cdn_form( @line );
	}elsif ( $page eq 'simul_cdn_conf' ){
		$main_table = &Simul'cdn_conf( @line);
    }elsif ( $page eq 'log' ) {
        $main_table = &make_log_table( $id, $line[6], $line[8] );
    }elsif ( $page eq 'error' || $page eq 'send' ) {
        $main_table = <<"END";
                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr><td>&nbsp;</td></tr>
                                <tr><td>&nbsp;</td></tr>
                                <tr>
                                <td align="center">$error
                                </td>
                                </tr>
                                </table>
END
    }
	
	elsif( $page eq 'delete' ){
		
		$main_table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="499"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="523"> <form action="index.cgi" method="post" enctype="multipart/form-data" name="form1">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                                <tr> 
                                                  <td width="515">���̔z�M�v�������폜���܂��B</td>
                                                </tr>
                                                <tr>
                                                  <td>���̔z�M�v�����Ɋ֘A���Ă��ׂẴf�[�^���폜����܂��B<br>
                                                    �܂��A�f�[�^�̕������ł��܂���B</td>
                                                </tr>
                                                <tr>
                                                  <td>&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td align="center"> 
                                                    <input name="action" type="hidden" id="action" value="delete">
                                                    <input name="id" type="hidden" id="id" value="$id"> 
                                                    <input name="md" type="hidden" id="md" value="text"> 
                                                    <input type="submit" value="�@�폜����@" onClick="return confirmation();"></td>
                                                </tr>
                                              </table>
                                            </form></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table>
END
		
	}
	
	# �܂��܂��o�^���
	elsif( $page eq 'magu' ){
		$main_table = &Magu::Form();
	}
	
	# ��ʃJ�X�^�}�C�Y
	elsif( $page eq 'ctm_regdisp' ){
		$main_table = &Ctm::Form( $line[60], [@line] );
	}
	# ��ʃv���r���[
	elsif( $page eq 'ctm_regprev' ){
		&Ctm::Prev(  $line[60], [@line] );
	}
	# �v�����R�s�[
	elsif( $page eq 'copy' ){
		$main_table = &Copy::form( '', $line[35], $line[36] );
	}
	# �N���b�N����
	elsif( $page eq 'click_analy' ){
		$main_table = &Click::page( $line[82] );
	}
	
	#--------------------------------------#
	# ���j���[�ƃ��C�������̃e�[�u�������� #
	#--------------------------------------#
	if ( $type eq 'plan' ) {
		my $csvcheck = &make_guest_table( $id, $line[6], 1 ); # �o�^�҂̗L�����m�F
		if ( $csvcheck > 0 ){
			$maillink = <<"END";
<tr> 
  <td align="center" bgcolor="#eeffe6">&nbsp;</td>
  <td width="117" bgcolor="#eeffe6"><a href="$indexcgi\?md=mail&id=$id"><font color="#FF9900">�o�^�҂փ��[�����M</font></a></td>
</tr>
END
		}
		$table = <<"END";
              <table width="100%" border="0" cellspacing="5" cellpadding="0">
                <tr> 
                  <td width="700"><br>
                    �v�����̕ҏW &gt; <strong>$pname</strong>�@ $auterun �@�@�@[ $runlink ]�@�@ $sendtag</a><hr noshade> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td width="141" height="100%" valign="top"> 
                          <table width="132" border="0" cellpadding="3" cellspacing="0">
                            <tr> 
                              <td colspan="2" align="center" bgcolor="#b1cca3">���j���[</td>
                            </tr>
                            <tr> 
                              <td width="3" align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi\?md=all&id=$id"><font color="#FF9900">�ڍ�</font></a></td>
                            </tr>
                            <tr>
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td bgcolor="#eeffe6"><a href="$indexcgi\?md=log&id=$id"><font color="#FF9900">�z�M���O</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi\?md=bs&id=$id"><font color="#FF9900">�z�M�����</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=l&id=$id"><font color="#FF9900">�z�M�����E�{��</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=header&id=$id"><font color="#FF9900">�w�b�_�[</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td bgcolor="#eeffe6"><a href="$indexcgi?md=cl&id=$id"><font color="#FF9900">�����ē�</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=footer&id=$id"><font color="#FF9900">�t�b�^�[</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=redirect&id=$id"><font color="#FF9900">�o�^�ݒ�</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=form1&id=$id"><font color="#FF9900">�o�^�p�t�H�[��</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=form2&id=$id"><font color="#FF9900">�ύX�E�����t�H�[��</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=ctm_regdisp&id=$id&act=top"><font color="#FF9900">��ʃJ�X�^�}�C�Y</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi\?md=g&id=$id"><font color="#FF9900">�o�^�ҏ��</font></a></td>
                            </tr>
                            $maillink
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=copy&id=$id"><font color="#FF9900">�R�s�[�v�����쐬</font></a></td>
                            </tr>
                            <tr>
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=f_magu&id=$id"><font color="#FF9900">�܂��܂��o�^�@�\\</font></a></td>
                            </tr>
                            <tr>
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=click_analy&id=$id"><font color="#FF9900">�N���b�N���́E�v��</font></a></td>
                            </tr>
                            <tr> 
                              <td align="center" bgcolor="#eeffe6">&nbsp;</td>
                              <td width="117" bgcolor="#eeffe6"><a href="$indexcgi?md=confdel&id=$id"><font color="#FF9900">���̃v�������폜</font></a></td>
                            </tr>
                          </table>
                        </td>
                        <td valign="top"> <table width="100%" border="0" cellspacing="0" cellpadding="3">
                            <tr> 
                              <td width="199" align="center"><a href="#" onClick="history.back();"><font color="#0000FF">�߂�</font></a></td>
                              <td width="348" align="center" bgcolor="#FF9900"><strong>$main_title</strong></td>
                            </tr>
                            <tr> 
                              <td colspan="2">$main_table</td>
                            </tr>
                          </table> </td>
                      </tr>
                    </table></td>
                </tr>
              </table>
END
	}
	&html_main($table, $help);
	exit;
}

#------------------------------------------------------------#
# �^�C�g���̃��j���|�����N����̃y�[�W���쐬                 #
#------------------------------------------------------------#
sub make_page {
	my ( $type, $err, $run, $load, $simul ) = @_;
	my $table;
	if ( $type eq 'new' ) {
		$table = <<"END";
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><form name="form1" method="post" action="$indexcgi">
                            <br>
                            <strong>�v������V�K�쐬���܂�</strong> 
                            <hr noshade>
                            <table width="663" border="0" cellpadding="5" cellspacing="0">
                              <tr bgcolor="#FF9900"> 
                                <td colspan="2"><strong><font color="#FFFFFF">�z�M�v�������Ɣz�M����</font></strong></td>
                              </tr>
                              <tr bgcolor="#e5f6ff"> 
                                <td width="107" align="center" bgcolor="#FFFFCC">�v������ 
                                </td>
                                <td bgcolor="#FFFFCC"> 
                                  <input name="p_title" type="text" id="p_title2" size="50">
                                  <font color="#CC0000">�����ʖ��ł�</font> </td>
                              </tr>
                              <tr bgcolor="#e5f6ff"> 
                                <td width="107" align="center" bgcolor="#FFFFCC">�z�M��</td>
                                <td width="536" bgcolor="#FFFFCC"> 
                                  <select name="count" id="count">
                                    <option value="0">-- �I�����Ă������� --</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                    <option value="6">6</option>
                                    <option value="7">7</option>
                                    <option value="8">8</option>
                                    <option value="9">9</option>
                                    <option value="10">10</option>
                                    <option value="11">11</option>
                                    <option value="12">12</option>
                                    <option value="13">13</option>
                                    <option value="14">14</option>
                                    <option value="15">15</option>
                                  </select>
                                </td>
                              </tr>
                              <tr bgcolor="#e5f6ff"> 
                                <td width="107" align="center" bgcolor="#FFFFCC">�z�M�Ԋu</td> 
                                <td bgcolor="#FFFFCC">
                                  <select name="interval" id="interval">
                                    <option value="0">-- �I�����Ă������� --</option>
                                    <option value="1">1����</option>
                                    <option value="2">2����</option>
                                    <option value="3">3����</option>
                                    <option value="4">4����</option>
                                    <option value="5">5����</option>
                                    <option value="6">6����</option>
                                    <option value="7">7����</option>
                                    <option value="8">8����</option>
                                    <option value="9">9����</option>
                                    <option value="10">10����</option>
                                  </select>
                                </td>
                              </tr>
                              <tr bgcolor="#e5f6ff"> 
                                <td align="center" bgcolor="#FFFFCC">&nbsp;</td>
                                <td bgcolor="#FFFFCC"><font color="#CC0000">
                                  �����͏��͂��ׂĕύX���\\�ł�<br>
                                  �^�u���̐��l�ȏ��ݒ肵�����ꍇ�A�����ł͉��Ɍ��߂Ă����Ă��������B</font></td>
                              </tr>
                              <tr align="center" bgcolor="#FFFFCC"> 
                                <td colspan="2"> 
                                  <input name="md" type="hidden" id="md" value="next"> 
                                  <input type="submit" value="�@���ց@"> </td>
                              </tr>
                            </table>
                          </form></td>
                      </tr>
                    </table>
END
	}elsif ( $type eq 'list' ) {
		#-----------------------------#
		# ���ۂ̃v�����ꗗ            #
		#-----------------------------#
		my $file = $myroot . $data_dir. $log_dir . $plan_txt;
		unless ( open(FILE, $file) ) {
			&make_plan_page( 'plan', '', "�V�X�e���G���[<br><br>$file���J���܂���<br>�p�[�~�b�V�������m�F���Ă�������");
		}
		my $list_table = <<"END";

                               <table width="100%" border="0" cellspacing="0" cellpadding="1">
<form name="form1" method="post" action="$main'indexcgi">
                                  <tr> 
                                    <td width="360"></td>
                                    <td width="60" align="center">&nbsp;</td>
                                    <td width="60">&nbsp;</td>
                                    <td width="160" align="center">���X�e�b�v���[���z�M���ԑ�</td>
                                    <td width="60"></td>
                                  </tr>
END
        my $flag = 0;
		while( <FILE> ) {
            $flag = 1;
			chomp;
			my ( $id ,$name, $_run, $runtime ) = ( split(/\t/) )[0, 2, 37, 76];
            my $run = ($_run)? '�ғ���': '<font color="#BBBBBB">��~��</font>';
            my $runlink = ($_run)? '��~����': '�ғ�����';
            my $alert = ($_run)? '��~���܂��B��낵���ł����H': '�ғ����܂��B��낵���ł����H';
            my $link = ($_run)? '0': '1';
			my ( $st, $ed ) = split(/<>/,$runtime);
			$st = 0 if( $st < 0 || $st > 23 );
			$ed = 0 if( $ed < 0 || $ed > 23 );
			my $sel_st;
			my $sel_ed;
			foreach my $s ( 0 .. 23 ){
				my $sed = ' selected' if( $st == $s );
				my $eed = ' selected' if( $ed == $s );
				$sel_st .= qq|<option value="$s"$sed>$s</option>\n|;
				$sel_ed .= qq|<option value="$s"$eed>$s</option>\n|;
			}
			$list_table .= <<"END";
                                  <tr> 
                                    <td width="360"><a href="$indexcgi?md=all&id=$id"><font color="#0000FF">$name</font></a></td>
                                    <td width="60" align="center"><font color="#000000">$run</font></td>
                                    <td width="60"><a href="$indexcgi?md=run&id=$id&action=$link"><font color="#0000FF" onClick="return confir('$alert');";>$runlink</font></a></td>
                                    <td width="160" align="center"><select name="$id\_s">$sel_st</select>��<span class="fontsize10px">����</span><select name="$id\_e">$sel_ed</select>��<span class="fontsize10px">�܂�</span></td>
                                    <td width="60" align="center"><a href="$indexcgi?md=log&id=$id"><font color="#0000FF">�z�M���O</font></a></td>
                                  </tr>
END
		}
		$list_table .= <<"END";
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td align="center">&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td align="center"><input type="submit" name="" value="�z�M���ԑт��X�V">
                                    <input type="hidden" name="md" value="text">
                                    <input type="hidden" name="action" value="runtime"></td>
                                    <td align="center">&nbsp;</a></td>
                                  </tr>
</form>
                                </table>
END
        $list_table = '�v�������쐬����Ă��܂���' if !$flag;
		#------------------------------#
		# �v�����̈ꗗ�̕\���p�e�[�u�� #
		#------------------------------#
		$table = <<"END";
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><strong><br>
                          �����̔z�M�v������\\�����Ă��܂�</strong> <hr noshade> <font color="#669900">�u 
                          �ҏW������<strong>�z�M�v������</strong> �v�܂��́u <strong>�z�M���O</strong> 
                          �v���N���b�N���Ă�������</font> <br> <br> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="5">
                            <tr> 
                              <td bgcolor="#FF9900"><font color="#FFFFFF">�z�M�v�����ꗗ</font></td>
                            </tr>
                            <tr> 
                              <td width="640" bgcolor="#FFFFCC"> 
                                $list_table
                              </td>
                            </tr>
                          </table><br>
                          <table width="100%" border="0" cellspacing="0" cellpadding="5"> 
                            <tr> 
                              <td bgcolor="#FFFFEE">
                                <table  width="640" border="0" cellspacing="0" cellpadding="2"> 
                                    <tr> 
                                      <td><font color="#FF0000"><strong>���X�e�b�v���[���z�M���ԑтɂ���</strong></font><br>
                                        <br>
                                       ���[���z�M���s�����ԑт��i�荞�ނ��Ƃ��ł��܂��B<br>
                                       ���w��̃X�e�b�v���[���z�M���ԑт́A�ғ����̃v�����ɑ΂��ėL���ƂȂ�܂��B<br>
                                       �u��~���ԁv�Ɂu�J�n���ԁv���O�̎������w�肷��ƁA�����̎������ݒ�\\�ł��B<br>
                                       ���������w�肷�邱�ƂŁA�펞�ғ��ƂȂ�܂��B<br>
                                       <br>
                                       ���ΏۂƂȂ郁�[���z�M
                                       <br>
                                       �E�Ǘ���ʁu�z�M�����s����v�����N�ɂ��z�M<br>
                                       �E�����z�M�^�O�ɂ��z�M<br>
                                       �Ecron�ɂ��z�M<br>
                                       <font color="#FF0000">
                                       �����̑����ׂĂ̋@�\\����єz�M�ɂ͓K�p����܂���B<br>
                                      ���u�o�^���v�Ȃǂ̊e�ʒm���[���͎��ԑт̐ݒ�Ɋւ�炸�o�^�y�єz�M���s���܂��B<br>
                                       <br>
                                       </font><table width="500" border="0" cellspacing="0" cellpadding="0">
                                         <tr>
                                           <td bgcolor="#999999"><table width="500" border="0" cellspacing="1" cellpadding="8">
                                             <tr>
                                               <td bgcolor="#FFFFFF">�y�ݒ��z
                                                 <br>
                                                 0��<span class="fontsize10px">����</span>12��<span class="fontsize10px">�܂�</span><br>
                                                 �� 0:00�`11:59�܂Ń��[���z�M���s���܂��B
                                                 <br>
                                                 20��<span class="fontsize10px">����</span>2��<span class="fontsize10px">�܂�</span><br>
                                                 �� 20:00�`������01:59�܂Ń��[���z�M���s���܂��B</td>
                                             </tr>
                                           </table></td>
                                         </tr>
                                       </table>
                                       <br>
                                       <table width="500" border="0" cellspacing="0" cellpadding="0">
                                         <tr>
                                           <td bgcolor="#999999"><table width="500" border="0" cellspacing="1" cellpadding="8">
                                             <tr>
                                               <td bgcolor="#FFFFFF">�y�����Ӂz
                                                 <br>
                                                 �w��̎��ԑтɃA�N�Z�X���Ȃ��A���̓��ɗ\\�肵�Ă����z�M���s���Ȃ������ꍇ�A<br>
                                                 ���̖��z�M���́A����̃X�e�b�v���[���z�M���ɗݐς���Ĕz�M����܂��B </td>
                                             </tr>
                                           </table></td>
                                         </tr>
                                       </table></td>
                                    </tr>
                                </table>
                              </td>
                             </tr>
                           </table></td>
                      </tr>
                    </table>
END
	}elsif ( $type eq 'admin' ) {
		$table = <<"END";
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td><strong><br>
                          �Ǘ��҂̏���ҏW���܂�</strong> <hr noshade> <font color="#669900">���͌�A�u<strong>�X�V�𔽉f</strong> �v
                          �{�^�������N���b�N���Ă�������</font> <br> <br> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="5">
                            <tr>
                            <td width="10">&nbsp;</td>
                            <td>
                              <font color="#FFOOOO">$err</font>
                              <form action="$indexcgi" method="POST">
                              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                <tr><td bgcolor="#FF9900" colspan="2">�� ID�A�p�X���[�h�̕ύX</td></tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                <tr>
                                <td width="100">�ύX���ID
                                </td>
                                <td width="470"><input type="text" name="nid" size="30">
                                </td>
                                </tr>
                                <tr>
                                <td>�ύX��̃p�X���[�h
                                </td>
                                <td><input type="password" name="npass" size="10" maxlength="8"> �i ���p�p���� 8�����ȓ� �j
                                </td
                                </tr>
                                <tr>
                                <td>�ύX��̊m�F�p�X���[�h
                                </td>
                                <td><input type="password" name="rpass" size="10" maxlength="8">
                                </td
                                </tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                <tr>
                                <td width="100">���݂�ID
                                </td>
                                <td width="450"><input type="text" name="input_id" size="30">
                                </td>
                                </tr>
                                <tr>
                                <td>���݂̃p�X���[�h
                                </td>
                                <td><input type="password" name="input_pass" size="10" maxlength="8">
                                </td
                                </tr>
                                <tr><td colspan="2">&nbsp;</td></tr>
                                <tr><td align="right"><input type="submit" value="�@�X�V�𔽉f�@" onClick="return confir('�{���ɕύX���܂����H');"></td><td>&nbsp;</td></tr>
                              </table>
                              <input type="hidden" name="md" value="ipchange">
                              </form>
                              
                            </td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                    </table>
END
	}elsif ( $type eq 'method' ) {
		#--------------------#
		# ���M����           #
		#--------------------#
		local $defeach = 100;
		local $defsleep = 30;
		local $defpartition = 50;
		my %method;
		unless( open(MET, "$myroot$data_dir$methodtxt") ) {
			&error('�V�X�e���G���[', "���M�����p�f�[�^�t�@�C�����J���܂���[ $myroot$data_dir$methodtxt ]");exit;
		}
		while( <MET> ) {
			chomp;
			my ( $nam, $val ) = split(/\t/);
			$nam = &deltag( $nam );
			$val -= 0 if( $nam ne 'f_mail' );
			$method{$nam} = $val;
		}
		close(MET);
		if ( !defined $method{'method'} || $method{'method'} ) {
			$checked2 = 'checked';
			
		}else{
			$checked = 'checked';
		}
		if ( defined $method{'each'} ) {
			${"each$method{'each'}"} = 'selected';
		}else{
			${"each$defeach"} = 'selected';
		}
		if ( defined $method{'sleep'} ) {
			${"sleep$method{'sleep'}"} = 'selected';
		}else{
			${"sleep$defsleep"} = 'selected';
		}
		if ( defined $method{'partition'} ) {
			${"partition$method{'partition'}"} = 'selected';
		}else{
			${"partition$defpartition"} = 'selected';
		}
		# �T�[�o�[����
		my $chk_sleep = ( $method{'chk_sleep'} )? ' checked': '';
		my $r_sleep   = ( $method{'r_sleep'} )? $method{'r_sleep'}:'';
		my $chk_f     = ( $method{'chk_f'} )? ' checked': '';
		my $f_mail    = $method{'f_mail'};
		
		$table = <<"END";
                    <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
                      <tr> 
                        <td><strong><br> 
                          �z�M���郁�[���̑��M������ݒ肵�܂�</strong> 
                          <hr noshade> 
                          <font color="#669900">���M������I�����A���M�����ɉ������ݒ��I����A�u<strong>�X�V�𔽉f</strong> �v �{�^�������N���b�N���Ă�������</font> <br> 
                          <br> 
                          <table width="100%" border="0" cellspacing="0" cellpadding="5"> 
                            <tr> 
                              <td width="10">&nbsp;</td> 
                              <td> <form action="index.cgi" method="POST"> 
                                  <table width="100%" border="0" cellspacing="0" cellpadding="2"> 
                                    <tr> 
                                      <td bgcolor="#FF9900" colspan="2"><input name="method" type="radio" value="0" $checked> 
                                        �A�N�Z�X���ɑ��M����</td> 
                                    </tr> 
                                    <tr> 
                                      <td colspan="2">&nbsp;</td> 
                                    </tr> 
                                    <tr> 
                                      <td width="120"> �P��̃A�N�Z�X�ɂ� </td> 
                                      <td width="380"><select name="each" id="each"> 
                                          <option $each10>10</option> 
                                          <option $each20>20</option> 
                                          <option $each30>30</option> 
                                          <option $each40>40</option> 
                                          <option $each50>50</option> 
                                          <option $each60>60</option> 
                                          <option $each70>70</option> 
                                          <option $each80>80</option> 
                                          <option $each90>90</option> 
                                          <option $each100>100 (����) </option> 
                                          <option $each110>110</option> 
                                          <option $each120>120</option> 
                                          <option $each130>130</option> 
                                          <option $each140>140</option> 
                                          <option $each150>150</option> 
                                          <option $each160>160</option> 
                                          <option $each170>170</option> 
                                          <option $each180>180</option> 
                                          <option $each190>190</option> 
                                          <option $each200>200</option> 
                                        </select> 
                                        �ʂÂ��M���� �B </td> 
                                    </tr> 
                                    <tr> 
                                      <td colspan="2"><font color="#FF0000">���z�M�����ȊO�̃��[�����M���̑��M���Ƃ��Ă��g�p����܂��B�i�ꊇ���M�j</font></td> 
                                    </tr>
                                    <tr> 
                                      <td colspan="2"><font color="#FF0000">���P��̑��M���������ꍇ�A�܂��͘A���ő��M����ƃT�[�o�[�ɕ��ׂ��|���܂��B</font></td> 
                                    </tr> 
                                    <tr> 
                                      <td colspan="2">�A�N�Z�X�����M�̏ꍇ�A��x�̃A�N�Z�X�ɂ�郁�[���z�M�����͍ő��200���ɐ������Ă��܂��B<br>
                                                      �V�X�e���S�̂̓o�^�l���������ꍇ��<font color="#0000FF">�z�M�ݒ�}�j���A��.html�u�����p�T�[�o�[�ł̐����v</font>���������������B</td> 
                                    </tr> 
                                    <tr> 
                                      <td colspan="2">&nbsp;</td> 
                                    </tr> 
                                  </table> 
                                  <table width="100%" border="0" cellspacing="0" cellpadding="2"> 
                                    <tr> 
                                      <td bgcolor="#FF9900"><input name="method" type="radio" value="1" $checked2> 
                                        �����ő��M����</td> 
                                    </tr> 
                                    <tr> 
                                      <td>&nbsp;</td> 
                                    </tr> 
                                    <tr> 
                                      <td width="380"><select name="sleep" id="sleep"> 
                                          <option $sleep5>5</option> 
                                          <option $sleep10>10</option> 
                                          <option $sleep15>15</option> 
                                          <option $sleep20>20</option> 
                                          <option $sleep25>25</option> 
                                          <option $sleep30>30 (����)</option> 
                                          <option $sleep35>35</option> 
                                          <option $sleep40>40</option> 
                                          <option $sleep45>45</option> 
                                          <option $sleep50>50</option> 
                                          <option $sleep55>55</option> 
                                          <option $sleep60>60</option> 
                                        </select> 
                                        �b����
                                        <select name="partition" id="select"> 
                                          <option $partition10>10</option> 
                                          <option $partition20>20</option> 
                                          <option $partition30>30</option> 
                                          <option $partition40>40</option> 
                                          <option $partition50>50 (����)</option> 
                                          <option $partition60>60</option> 
                                          <option $partition70>70</option> 
                                          <option $partition80>80</option> 
                                          <option $partition90>90</option> 
                                          <option $partition100>100</option> 
                                        </select> 
                                        �ʂÂ��M����B</td> 
                                    </tr> 
                                    <tr> 
                                      <td><font color="#FF0000">���P��̑��M���������ꍇ�T�[�o�[�ɕ��ׂ��|���܂��B</font></td> 
                                    </tr> 
                                    <tr> 
                                      <td>&nbsp;</td> 
                                    </tr> 
                                    <tr> 
                                      <td><strong>�K�{����</strong></td> 
                                    </tr> 
                                    <tr> 
                                      <td>���o�b�N�O���E���h��CGI�̋N�����ł���T�[�o�[�ł��邱�ƁB </td> 
                                    </tr> 
                                    <tr> 
                                      <td> ��CGI���펞�N�����Ă��Ă��A�T�[�o�[���ŋ����I�ɐؒf����Ȃ����ƁB </td> 
                                    </tr> 
                                    <tr>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td bgcolor="#FF9900">�� �T�[�o�[�����ݒ�</td>
                                    </tr>
                                    <tr>
                                      <td><table width="600" border="0" cellpadding="5" cellspacing="0">
                                          <tr>
                                            <td colspan="2">�����p�̃T�[�o�[��sendmail���g�p���ă��[���𑗐M����ہA���ʂȐ���������ꍇ�ȉ��̐ݒ��<br>
                                              �s���Ă��������B<br>
                                              �����Ɋւ���ڍׂ́u�y���[���v��ݒu�����T�[�o�[�̊Ǘ��҂ɖ₢���킹�邩�A�������̓T�|�[�g�y�[�W�����Q�Ƃ��������B<br>
                                              <br></td>
                                          </tr>
                                          <tr>
                                            <td colspan="2" bgcolor="#FFFFEE">�Y�����鐧���� <strong>�`�F�b�N�{�b�N�X</strong>�Ƀ`�F�b�N�����A<strong>�K�v�ȏ��</strong>�������͂��������B<br>
                                              ����������ꍇ�A�ȉ��̐ݒ���s���܂����<strong><font color="#FF0000">�u�y���[���v�͐���ɓ���v���܂���</font></strong>�B</td>
                                          </tr>
                                          <tr>
                                            <td colspan="2" bgcolor="#FFFFEE"><input name="chk_sleep" type="checkbox" id="chk_sleep" value="1"$chk_sleep>
                                              sendmail�Ń��[����A�����M����ۂɑ҂����Ԃ��K�v�B�@</td>
                                          </tr>
                                          <tr>
                                            <td width="50" bgcolor="#FFFFEE">&nbsp;</td>
                                            <td width="550" bgcolor="#FFFFEE">�P�ʑ��M�̓x��
                                              <input name="r_sleep" type="text" id="r_sleep" value="$r_sleep" size="5">
                                              �b�҂B</td>
                                          </tr>
                                          <tr>
                                            <td colspan="2" bgcolor="#FFFFEE">&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td colspan="2" bgcolor="#FFFFEE"><input name="chk_f" type="checkbox" id="chk_f" value="1"$chk_f>
                                              sendmail�Ń��[���𑗐M����ꍇ�A-f�I�v�V����(sender)���w�肷��K�v������B</td>
                                          </tr>
                                          <tr>
                                            <td bgcolor="#FFFFEE">&nbsp;</td>
                                            <td bgcolor="#FFFFEE">���[���A�h���X
                                              <input name="f_mail" type="text" id="f_mail" value="$f_mail" size="50">
                                              <br>
                                              �� �����p�̃T�[�o�[�Ŏ擾���܂������[���A�h���X����͂��Ă��������B</td>
                                          </tr>
                                        </table></td>
                                    </tr>
                                    <tr>
                                      <td>&nbsp;</td>
                                    </tr> 
                                  </table> 
                                  <input name="submit" type="submit" onClick="return confir('�{���ɕύX���܂����H');" value="�@�X�V�𔽉f�@"> 
                                  <input name="md" type="hidden" id="md" value="remethod"> 
                                </form></td>
                            </tr> 
                          </table>
                          <table width="600" border="0" cellspacing="0" cellpadding="5"> 
                            <tr> 
                              <td width="10">&nbsp;</td> 
                              <td bgcolor="#FFFFCC">
                                <table width="590" border="0" cellspacing="0" cellpadding="2"> 
                                    <tr> 
                                      <td><font color="#FF0000"><strong>���e���M�����̓���</strong></font><br>
                                       �u�������M�v�̏ꍇ�́A�P���P��̃A�N�Z�X�ł��̓��ɃX�P�W���[�����O���ꂽ���[����S�đ��M���܂��B<br>
                                       �u�A�N�Z�X���ɑ��M����v�ł́A�P��̔z�M���ȏ�ɔz�M�\\��̃��[��������ꍇ�A�����̃A�N�Z�X���K�v�ƂȂ�܂��B<br><br>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td><font color="#FF0000"><strong>�����M�̗D�揇�ʂɂ���</strong></font><br>
                                       �v��������������ꍇ�A�u�v�����ꗗ�v�̕\\�̏�̃v�������D��I�ɑ��M����܂��B
                                      </td> 
                                    </tr>
                                </table>
                              </td>
                             </tr>
                           </table>
                         </td> 
                      </tr> 
                    </table>
END
	
	}elsif ( $type eq 'help' ) {
		my $link_simul;
		if( $simul ){
			$link_simul = qq|<img src="$indexcgi\?md=simul" border="0" width="1" height="1">|;
		}
		$table = <<"END";
                     <TABLE cellspacing=0 cellpadding=3 width=660 border=0>
                      <TBODY>
                        <TR>
                          <TD>$link_simul&nbsp; </TD>
                        </TR>
                        <TR>
                          <TD>���@�T�v
                            <HR noShade>
                          </TD>
                        </TR>
                        <TR>
                          <TD width=640><TABLE cellSpacing=0 cellPadding=1 width=640 border=0>
                              <TBODY>
                                <TR>
                                  <TD width=20>&nbsp;</TD>
                                  <TD width=620>���[���}�K�W���A���[���Z�~�i�[�A�t�H���[���[���̔z�M�������I�ɍs���܂�<BR>
                                    ���炩���߃��[���̔z�M�񐔁E���[���̓��e�E�z�M�Ԋu���i���[���z�M�v�����j�� 
                                    �ݒ肵�Ă������ƂŁA�t�H�[���i�o�^�j��ݒu�����z�[���y�[�W�ɂ��q�l�����[���z�M����]����ƁA�ݒ�ɉ����Ď����I�Ƀ��[�����z�M����܂��B</TD>
                                </TR>
                              </TBODY>
                            </TABLE></TD>
                        </TR>
                        <TR>
                          <TD>&nbsp;</TD>
                        </TR>
                        <TR>
                          <TD>���@�����z�M�̐ݒ�ɂ���</TD>
                        </TR>
                        <TR>
                          <TD><HR noShade></TD>
                        </TR>
                        <TR>
                          <TD><TABLE cellSpacing=0 cellPadding=1 width=640 border=0>
                              <TBODY>
                                <TR>
                                  <TD width=20>&nbsp;</TD>
                                  <TD width=620>�u�y���[���v�ł͊Ǘ��җl�̂����p�ɉ����āA�������̔z�M������I���ł��܂��B<BR>
                                    <br>
                                    <strong>�i�P�j�z�M�^�O�𗘗p���������z�M�i�����j</strong><br>
                                    <br>
                                    �z�[���y�[�W�̔C�ӂ̏ꏊ�i�����̓g�b�v�y�[�W�̂ǂ����j�ɔz�M�p�̃^�O�𖄂ߍ���ł����A���̃y�[�W�A�N�Z�X������x�ɂb�f�h���N���E�`�F�b�N�E�z�M���s���܂��B<br>
                                    ����ɂ��A�C�ӂ̃y�[�W�ɂP���P�A�N�Z�X�ł�����΁A�����̃��[���z�M�����S�����ŉ\\�ƂȂ�܂��B
                                    <form>
                                      <table WIDTH="148" BORDER="0" align="center" CELLPADDING="0" CELLSPACING="0">
                                        <tr>
                                          <td BGCOLOR="#666666" ALIGN="center"><table WIDTH="600" BORDER="0" align="center" CELLPADDING="10" CELLSPACING="1" class="table1">
                                              <tr>
                                                <td ALIGN="center" BGCOLOR="#FFFFCC"><font color="#000000">���C�ӂ̃y�[�W��JAVASCRPT�̃v�����[�h�𗘗p���A�N�Z�X���邽�тɃ��[����z�M�������ꍇ </font>
                                                  <p><font color="#000000">�C�ӂ̃y�[�W��&lt;HEAD&gt;&lt;/HEAD&gt;����</font></p>
                                                  <textarea name="textarea" cols="70" rows="5" onFocus="this.select();">
&lt;script language="JavaScript"&gt;&lt;!--
myIMG = new Image();
myIMG.src = '$Pub'scriptName$sendcgi?run';
// --&gt;&lt;/script&gt;</textarea>
                                                  <font color="#FF0000"><br>
                                                  ���S�Ă̕������I�����ē\\��t���Ă��������B<br>���y���[��PRO��SSL�̈�ɐݒu�����ꍇ�ɂ́A�hhttp�h���hhttps�h�ւƕύX���Ă��������B</font> </td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
                                    </form>
                                    <strong><br>
                                    �i�Q�j�z�M��p�y�[�W����b�f�h�������N���b�N�ŋN��</strong><br>
                                    <br>
                                    �z�M�p�̂t�q�k�A�h���X���N���b�N���邱�ƂŁA�b�f�h�̋N���E�`�F�b�N�E�z�M���s���܂��B<br>
                                    <form>
                                      <table WIDTH="148" BORDER="0" align="center" CELLPADDING="0" CELLSPACING="0">
                                        <tr>
                                          <td BGCOLOR="#666666" ALIGN="center"><table WIDTH="600" BORDER="0" align="center" CELLPADDING="10" CELLSPACING="1" class="table1">
                                              <tr>
                                                <td ALIGN="center" BGCOLOR="#FFFFCC"><p><font color="#000000">���C�ӂ̃y�[�W�Ɂu�z�M��p�����N�v���쐬���A�N�Z�X���邽�тɃ��[����z�M�������ꍇ�̃����N </font></p>
                                                  <p>�C�ӂ̃y�[�W����</p>
                                                  <p>
                                                    <input name="text" type="test" id="text" value="&lt;a href=&quot;$Pub'scriptName$sendcgi&quot;&gt;�C��&lt;/a&gt;" size="90" onFocus="this.select();">
                                                    <font color="#FF0000"><br>
                                                    ���S�Ă̕������I�����ē\\��t���Ă��������B<br>���y���[��PRO��SSL�̈�ɐݒu�����ꍇ�ɂ́A�hhttp�h���hhttps�h�ւƕύX���Ă��������B</font></td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
                                    </form>
                                    <strong> �i�R�j�b�f�h�Ɏ蓮�ŃA�N�Z�X���A�z�M�����s����</strong><br>
                                    <br>
                                    �b�f�h�̊Ǘ���ʏォ��b�f�h�̋N���E�`�F�b�N�E�z�M���s���܂��B<br>
                                    ���̃y�[�W�㕔���j���[�́u<strong>�z�M�����s����</strong>�v���N���b�N���邱�ƂŁA �`�F�b�N�E�z�M���s���܂��B<br>
                                    <br>
                                    <font color="#FF0000">�y���Ӂz </font><BR>
                                    �z�M�ɂ�<BR>
                                    ���A�N�Z�X���ɔz�M<BR>
                                    �������Ŕz�M<BR>
                                    �̓�ʂ肪����A�ǂ��炩���u<u><font color="#0000FF">���M�����ݒ�</font></u>�v�Ō��肵�܂��B�i�f�t�H���g�͕��������j <BR>
                                    �������M�̏ꍇ�́A�P���P��̃A�N�Z�X�ł��̓��ɃX�P�W���[�����O���ꂽ���[����S�đ��M���܂����A�A�N�Z�X���̑��M�ł́A�P��̔z�M���ȏ�ɔz�M�\\��̃��[��������ꍇ�A�����̃A�N�Z�X���K�v�ƂȂ�܂��B<BR>
                                    <BR>
                                    ��<font color="#0000FF">�z�M�ݒ�}�j���A��.html�u�����p�T�[�o�[�ł̐����v</font>���������������B<BR>
                                    <BR>
                                    <strong>�i�S�j�N�[�����𗘗p�����������M�i�킩��������j</strong><BR>
                                    <BR>
                                    UNIX�n��OS�̋@�\\�ł���N�[�������g�p���邱�Ƃɂ���Ď������i�X�P�W���[���Ǘ��j 
                                    ���s���܂�<BR>
                                    �N�[�������g�p�ł��Ȃ����̏ꍇ�͏�L�̂��Âꂩ�̕��@�Ń��[����z�M���Ă��������B<br>
                                    <font color="#FF0000">���N�[�����̗��_�́A�^�O��A�N�Z�X���g�킸�Ɏ����z�M���ł���_�Ǝ��Ԏw�肪�\\�ȓ_�ł��B</font><br>
                                    <br>
                                    ��<font color="#0000FF">�z�M�ݒ�}�j���A��.html�u�N�[�����̐ݒ���@�v</font>���������������B</TD>
                                </TR>
                              </TBODY>
                            </TABLE></TD>
                        </TR>
                        <TR>
                          <TD>&nbsp;</TD>
                        </TR>
                        <TR>
                          <TD>���@������</TD>
                        </TR>
                        <TR>
                          <TD><hr noshade></TD>
                        </TR>
                        <TR>
                          <TD><table width="600" border="0" align="center" cellpadding="1" cellspacing="0">
                              <tr>
                                <td bgcolor="#666666"><TABLE cellSpacing=0 cellPadding=5 width=600 border=0>
                                    <TBODY>
                                      <TR>
                                        <TD bgcolor="#FFCC66">����ʔz�M�ɂ���</TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFFFEE">�u�y���[���v�͂b�f�h�v���O�����ł��邽�߁A�����p�̃T�[�o�̔\\�͂ɂ��܂��Ă͑�ʔz�M�ɂ�蕉�ׂ��������邱�ƂŁA�z�M�G���[��������\\�����������܂��B<br>
                                          ��ʂ̃��X�g���ꊇ�o�^������A���[�U�[�������Ȃ�����Ԃł̈ꊇ���M�y�ѓ��t�w��z�M���s���ꍇ�͂����p�җl�̐ӔC�ɂ����ĐT�d�ɂ��肢�������܂��B<br>
                                        </TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFCC66">�������z�M�ɂ���</TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFFFEE">�u�y���[���v�͂b�f�h�v���O�����ł��̂ŁA�z�M�\��\�̃`�F�b�N�E�z�M���s�����߃V�X�e���̋N���E�z�M�`�F�b�N�����I�ɍs���K�v���������܂��B
                                          ���̍�Ƃ�����������ɂ́A�ʏ�́u�����z�M�^�O�v���T�C�g���ɖ��ߍ���ł����A�T�C�g�ւ̕s���葽���̃A�N�Z�X������x�ɔz�M�`�F�b�N�E�����z�M���s���`������{�ƂȂ�܂��B<br>
                                          �y�ݒu�}�j���A���z<br>
                                          <a href="http://www.raku-mail.com/manual/autosendtag.pdf" target="_blank"><font color="#0000FF">http://www.raku-mail.com/manual/autosendtag.pdf</font></a><br>
�@                                           </TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFCC66">��unicode(UTF-8)���g�p���̃T�[�o�[���ׂɂ���</TD>
                                      </TR>
                                      <TR>
                                        <TD bgcolor="#FFFFEE">�y���[����UTF-8�Ŏg�p����ꍇ�ɂ����āA�����p�̃T�[�o�[��Jcode.pm���C���X�g�[������Ă��Ȃ��ƁA<br>
                                          �T�[�o�[�ւ̕��ׂ��ʏ��荂���Ȃ�ꍇ���������܂��B<br>
                                          Jcode.pm�̗L���ɂ��ẮA�����p�T�[�o�[�̃T�|�[�g���ł��m�F�������B</TD>
                                      </TR>
                                    </TBODY>
                                  </TABLE></td>
                              </tr>
                            </table></TD>
                        </TR>
                      <TD>&nbsp;</TD>
                      </TR>
                      <TD>���@�o�^���e�̊m�F�ʒm�ɂ���
                          <HR noShade>
                        </TD>
                      </TR>
                      <TR>
                        <TD width=640><TABLE cellSpacing=0 cellPadding=1 width=640 border=0>
                            <TBODY>
                              <TR>
                                <TD width=20>&nbsp;</TD>
                                <TD width=620>�Ǘ��҂ɁA�o�^����m�点��ɂ͓o�^���̍T����o�^�҂ɑ��M���A<br>
                                  ���̃��[�����Ǘ��҂ɂ����M����ݒ�ɂ�����@���l�����܂��B<br>
                                  <br>
                                  ��̓I�ȕ��@�Ƃ������܂��ẮA<br>
                                  <br>
                                  �P�j�o�^���̃��[�����Ɉȉ��̂悤�Ȍ`���œo�^���e���������݂܂��B<br>
                                  �y��z<br>
                                  <table WIDTH="148" BORDER="0" align="center" CELLPADDING="0" CELLSPACING="0">
                                    <tr>
                                      <td BGCOLOR="#666666" ALIGN="center"><table WIDTH="600" BORDER="0" align="center" CELLPADDING="5" CELLSPACING="1" class="table1">
                                          <tr>
                                            <td BGCOLOR="#FFFFCC">�ȉ��̓��e�œo�^����t���܂����B���o�^���肪�Ƃ��������܂��B<br>
                                              �����O�F&lt;%name%&gt;<br>
                                              ���[���A�h���X�F&lt;%mail%&gt;<br>
                                            </td>
                                          </tr>
                                        </table></td>
                                    </tr>
                                  </table>
                                  <br>
                                  �Q�j�u�o�^�ݒ�v�̃y�[�W�ɂāA�u�Ǘ��҂ɒʒm�v�Ƀ`�F�b�N�����܂��B<br>
                                  <br>
                                  ����ɂ��A�o�^�҂ɓo�^���e�̍T�����z�M����A�����ɊǗ��҈���<br>
                                  �������̂��͂����߁A�o�^���e���m�F�ł���d�g�݂ł��B</TD>
                              </TR>
                            </TBODY>
                          </TABLE></TD>
                      </TR>
                      <TR>
                        <TD>&nbsp;</TD>
                      </TR>
                      <TR>
                        <TD>���@���j���[�ɂ���
                          <HR noShade>
                        </TD>
                      </TR>
                      <TR>
                        <TD width=640><TABLE cellSpacing=0 cellPadding=1 width=630 border=0>
                            <TBODY>
                              <TR>
                                <TD width=20>&nbsp;</TD>
                                <TD width=610><TABLE cellSpacing=5 cellPadding=5 width=620 border=0>
                                    <TBODY>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>�V�K�쐬</STRONG> </TD>
                                        <TD width=500>���[���z�M�v������V�K�쐬���܂��B<BR>
                                          ���͂������͂��ׂĕύX�ł��܂��B </TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>�v�����ꗗ</STRONG> </TD>
                                        <TD width=500>���ݍ쐬�ς݂̃��[���z�M�v�����̈ꗗ��\\�����܂��B<BR>
                                          �\\������Ă���z�M�v�������N���b�N���邱�Ƃł��̃v�����̏����{�����A�X�V���s���܂��B </TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>�Ǘ��ҏ��</STRONG> </TD>
                                        <TD width=500>�Ǘ���ID�A�p�X���[�h��ύX�ł��܂��B<BR>
                                          �ύX����ID�A�p�X���[�h�͎��񂩂�K�p����܂��B </TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top><STRONG>���M�����ݒ�</STRONG></TD>
                                        <TD>�z�M���������ݒ�ł��܂��B<BR></TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top><STRONG>�z�M�����s����</STRONG></TD>
                                        <TD>���ۂɉғ����̔z�M�v�����̃��[����z�M���܂��B<BR></TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>���O�A�E�g</STRONG> </TD>
                                        <TD width=500>�F�؂Ɏg�p���Ă�������Ȃ��uCookie�v�����Z�b�g���܂��B<BR>
                                          �u���E�U����Ă��������ʂ������܂��B </TD>
                                      </TR>
                                      <TR>
                                        <TD vAlign=top width=100><STRONG>�w���v</STRONG> </TD>
                                        <TD width=500>�u�V�K�쐬�v�A�u�v�����ꗗ�v�A�u�Ǘ��ҏ��v�y�[�W���\\������Ă���ꍇ�͂��̃y�[�W���\\������܂��B 
                                          �e�v�����̍X�V��ʂ��\\������Ă���ꍇ�͂��̍X�V�̃}�j���A�����\\������܂��B 
                                          �g�p�}�j���A���Ƃ��Ă����p���������B </TD>
                                      </TR>
                                    </TBODY>
                                  </TABLE></TD>
                              </TR>
                            </TBODY>
                          </TABLE></TD>
                      </TR>
                        <TR>
                          <TD>&nbsp;</TD>
                        </TR>
                        <TR>
                          <TD>���@�Z�b�g�A�b�v�i���ݒ�j</TD>
                        </TR>
                        <TR>
                          <TD><hr noshade></TD>
                        </TR>
                        <TR>
                          <TD><TABLE cellSpacing=0 cellPadding=1 width=640 border=0>
                              <TBODY>
                                <TR>
                                  <TD width=20>&nbsp;</TD>
                                  <form method="post" action="$indexcgi">
                                    <TD width=620>�ȉ��̃{�^����菉�񎞂̃Z�b�g�A�b�v���ēx�N���ł��܂��B<br>
                                      �ݒ����蒼�������ꍇ�⓮�삪����ɍs���Ȃ��ꍇ�ȂǂɁA�ēx�Z�b�g�A�b�v�����s���Ă��������B<br>
                                      <input type="submit" name="setup" value="�@�Z�b�g�A�b�v�����s�@">
                                    <input name="md" type="hidden" id="md" value="setup"></TD>
                                  </form>
                                </TR>
                              </TBODY>
                            </TABLE></TD>
                        </TR>
                         <TR>
                          <TD>&nbsp;</TD>
                        </TR>
                      </TBODY>
                    </TABLE>
END
	}
    my $help = qq|"$indexcgi\?md=help"|;
	&html_main( $table, $help, $run, $load );
	exit;
}


#------------------------------------------------------------#
# ���C����ʂ̃e���v���[�g                                   #
#------------------------------------------------------------#
sub html_main {
	my ( $table, $help, $run, $load ) = @_;
	my $logo = &get_relpath( "$image_dir", $IMG_URL );
	$logo = $logo . 'rakumaillogo.jpg';
	print <<"END";
Content-type: text/html

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<title>$title</title>
<link href="$image_dir$css" rel="stylesheet" type="text/css">
<script type="text/javascript"><!--
function confirmation(){
    var what=confirm('���̔z�M�v�����Ɋ֘A����A���ׂẴf�[�^���폜����܂�\\n\\n�{���ɍ폜���܂����H');
    if(what == false){
        return false;
    }
}
function confir(str){
    var what=confirm(str);
    if(what == false){
        return false;
    }
}
function wopen( url, name, wd, ht ){
	var w = ( wd > 0 )? wd: 550;
	var h = ( ht > 0 )? ht: 500;
    window.open(url, name, "width="+w+",height="+h+",menubar=no,scrollbars=yes");
}
--></script>
</head>
<body>
<center>
  <table width="700" border="0" cellspacing="10">
    <tr> 
      <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr bgcolor="#0033CC"> 
            <td colspan="3" bgcolor="#FCD52F"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                  <td rowspan="2"><table cellpadding="5">
                    <tr><td><img src="$logo"></td></tr></table></td>
                  <td align="right" valign="top">
				  <table border="0" cellpadding="0" cellspacing="0">
				    <tr>
					  <td bgcolor="#003580">
					    <table width="100%" border="0" cellspacing="1" cellpadding="3">
						  <tr>
						    <td width="80" align="center" bgcolor="#6699CC"><a href="$indexcgi"><font style="font-size:10px"color="#FFFFFF">�g�b�v�y�[�W��</font></a></td>
						  </tr>
						</table>
					  </td>
					</tr>
				  </table>
				</td>
                </tr>
                <tr> 
                  <td align="right" valign="bottom"><font color="#666666">ver$Version</font></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3" bgcolor="#003580"> 
              <table width="100%" border="0" cellspacing="1" cellpadding="3">
                <tr bgcolor="#6699CC"> 
                  <td width="80" align="center"><a href="$indexcgi\?md=new">�V�K�쐬</a></td>
                  <td width="80" align="center"><a href="$indexcgi\?md=list">�v�����ꗗ</a></td>
                  <td width="90" align="center"><a href="$indexcgi\?md=admin">�Ǘ��ҏ��</a></td>
                  <td width="90" align="center"><a href="$indexcgi\?md=method">���M�����ݒ�</a></td>
                  <td width="100" align="center"><a href="#" onClick="alert('�z�M�����s���܂�');wopen('$sendcgi', 'raku_mail')">�z�M�����s����</a></td>
                  <td width="80" align="center"><a href="$indexcgi\?md=logout">���O�A�E�g</a></td>
                  <td width="60" align="center"><a href=$help>�w���v</a></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td colspan="3" bgcolor="#FFFFFF"> <table width="100%" border="0" cellspacing="0" cellpadding="5">
                <tr> 
                  <td>$table </td>
                </tr>
              </table></td>
          </tr>
        </table></td>
    </tr>
  </table>
</center>
</body>
</html>
END
	exit;
}

# �����e�[�u���̍쐬
# $type 0 => �ڍ׃y�[�W���̕\���p
# $type 1 => �z�M�����y�[�W�p
sub make_schedule {
	my ( $id, $type, $counts, $intervals, $qfilename ) = @_;
	my $now = time;
	my ( $count, $r1, $r2, $r3 ) = split(/,/, $counts);
	my ( $interval, $dates ) = split(/<>/, $intervals);
	my @interval = split( /,/, $interval );
	my @dates = split( /,/, $dates );
	my $table;
	
	# �z�M�����E�{���p
	if ( $type ) {
		my $ck1 = ' checked="checked"' if($r1);
		$baseNum = '�o�^��';
		$table = <<"END";
<script type="text/javascript"><!--

function getElem( nam ){
	var obj = '';
	if ( document.getElementById ){
		obj = document.getElementById ( nam );
	}else{
		obj = document.all [name];
	}
	return obj;
}

// �����I�u�W�F�N�g����
function openObj( nam ){
	var obj = getElem(nam);
	obj.style.display = "";
}
function closeObj( nam ){
	var obj = getElem(nam);
	obj.style.display = "none";
}
function ScheduleDisplay(){
	var count = $count;
	var message = '�o�^��';
	
	for( var i = 0; i < count; i++ ){
		var num = i + 2;
		var nam = 's' + num;
		var s1 = nam + '_1';
		var s2 = nam + '_2';
		var s3 = nam + '_3';
		
		var obj = getElem(nam);
		var next = getElem( nam + '_from' );
		next.innerText = message;
		next.textContent = message;
		if( obj.checked == false ){
			closeObj(s1);
			openObj(s2);
			openObj(s3);
		}else{
			// �e�L�X�g�̕ύX
			message = '��'+num+'��';
			openObj(s1);
			closeObj(s2);
			closeObj(s3);
			
		}
	}
	var SD = setTimeout("ScheduleDisplay();",200);
}
function winLoad(){
	if (window.addEventListener) { //for W3C DOM
		window.addEventListener("load", ScheduleDisplay, false);
	}else if (window.attachEvent) { //for IE
		window.attachEvent("onload", ScheduleDisplay);
	}else  {
		window.onload = ScheduleDisplay;
	}
}
winLoad();

// �A���[�g���b�Z�[�W
function altSdl(obj){
	if( obj.checked ){
		alert("�ȍ~�̃X�e�b�v�́A�z�M���ĊJ�������_����́u�N�Z�����v�Ŕz�M�����s����܂��B\\n�K�v�ȏꍇ�A�w������̒������s���Ă��������B");
	}
}

// -->
</script>
                                <table width="100%" border="0" cellspacing="0" cellpadding="5">
                                        <tr>
                                          <td bgcolor="#FFFFFF">�o�^�������<strong>�N�Z����</strong>�ŁA�I�[�g�X�e�b�v���[����z�M���܂��B<br>
                                          �z�M�Ԋu�Ɩ{����ݒ肵�Ă��������B</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#FFFFFF">�z�M�Ԋu�w��Ɠ��t�Ŏw��͕��s���Đݒ肪�\\�ł��B</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#FFFFFF"><table width="100%" border="0" cellspacing="0" cellpadding="1">
                                            <tr>
                                              <td bgcolor="#666666"><table width="100%" border="0" cellspacing="0" cellpadding="10">
                                                <tr>
                                                  <td bgcolor="#FFFFFF"><strong><font color="#FF0000">�y�����Ӂz</font><br>
                                                    </strong>�ғ����ɔz�M�Ԋu�̕ύX������ƁA�ꍇ�ɂ���Ă͈�x�ɕ����̃��[�����z�M����Ă��܂��ꍇ������܂��B<br>
                                                    �ғ����̔z�M�����̕ύX�͏\\�����ӂ��Ă��������B<br>�܂��A�o�^�Ґ��ɂ���ẮA�X�V����������܂łɎ��Ԃ�������ꍇ������܂��B</td>
                                                </tr>
                                              </table></td>
                                            </tr>
                                          </table></td>
                                        </tr>
                                        <tr>
                                          <td align="center" bgcolor="#FFFFCC"><form name="form1" method="post" action="$indexcgi">
                                              <table width="500" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                  <td bgcolor="#FFFFFF"><table width="500" border="0" cellpadding="2" cellspacing="0">
                                                      <tr>
                                                        <td height="20" colspan="6" bgcolor="#FFFFCC">&nbsp;</td>
                                                      </tr>
                                                      <tr>
                                                        <td width="8%" align="center" bgcolor="#FFCC33">�s��</td>
                                                        <td width="13%" align="center" bgcolor="#FFCC33">�ꎞ��~</td>
                                                        <td width="14%" align="center" bgcolor="#FFCC33">�z�M��</td>
                                                        <td width="20%" align="center" bgcolor="#FFCC33">�z�M�Ԋu</td>
                                                        <td align="center" bgcolor="#FFCC33">�ύX�{�^��</td>
                                                        <td width="15%" align="center" bgcolor="#FFCC33">�{���ҏW</td>
                                                      </tr>
                                                      <tr>
                                                        <td align="center" bgcolor="#FEF2CD" height="30"><input name="r" type="checkbox" value="1"$ck1></td>
                                                        <td align="center" valign="middle" bgcolor="#FEF2CD">--</td>
                                                        <td align="center" valign="middle" bgcolor="#FEF2CD">�o�^��</td>
                                                        <td align="center" bgcolor="#FEF2CD">�o�^���z�M</td>
                                                        <td valign="middle" nowrap="nowrap" bgcolor="#FEF2CD"><input type="submit" name="add0" value="���ɒǉ�" onClick="return confir('�ǉ����܂����H');"></td>
                                                        <td align="center" bgcolor="#FEF2CD"><a href="$indexcgi?md=ml&id=$id&n=0"><font color="#0000FF">�{���̕ҏW</font></a></td>
                                                      </tr>
END
		for ( my $i=1; $i<=$count; $i++ ) {
			my $num = $i +1;
			my $intnum = $i-1;
			my( $inter, $config ) = split( /\//,$interval[$i-1] );
			$inter = ( $config )? '': $inter -0;
			$config -= 0;
			
			my $def_stop = ( $config )? 1: 0;
			my $stop = ( $config )? ' checked="checked"': '';
			my $bgcolor = ( !$config )? '#FFFFCC': '#FEF2CD' ;
			$table .= <<"END";
                                                     <tr>
                                                        <td align="center" bgcolor="$bgcolor" height="30">&nbsp;</td>
                                                        <td align="center" valign="middle" bgcolor="$bgcolor"><input id="s$num" type="checkbox" name="stop$i" value="1"$stop onclick="altSdl(this);"><input type="hidden" name="def_stop$i" value="$def_stop"></td>
                                                        <td align="center" valign="middle" bgcolor="$bgcolor">��$num��</td>
                                                        <td align="center" bgcolor="$bgcolor">
                                                          <span id="s$num\_1" style="display:none;">�ĊJ���z�M</span>
                                                          <span id="s$num\_2"><font style="font-size:12px;"><span id="s$num\_from">$baseNum</span></font><font style="font-size:11px" color="#666666">���</font><br></span>
                                                          <span id="s$num\_3"><input type="text" name="int$i" size="3" value="$inter">����</span></td>
                                                        <td valign="middle" nowrap="nowrap" bgcolor="$bgcolor"><input name="add$i" type="submit" id="add$i" onClick="return confir('�ǉ����܂����H');" value="���ɒǉ�" />
                                                        <input name="del$i" type="submit" id="del$1" onClick="return confir('�폜���܂����H');" value="�폜" /></td>
                                                        <td align="center" bgcolor="$bgcolor"><a href="$indexcgi?md=ml&id=$id&n=$i"><font color="#0000FF">�{���̕ҏW</font></a></td>
                                                      </tr>
END
			$baseNum = '��'. $num. '��' if( $config );
		}
        $ck2 = ' checked="checked"' if($r2);
        $ck3 = ' checked="checked"' if($r3);
		$table .= <<"END";
                                                      <tr>
                                                        <td align="center" bgcolor="#FFFFCC" height="30"><input name="r2" type="checkbox" id="r" value="checkbox"$ck2></td>
                                                        <td nowrap="nowrap" bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td align="center" valign="middle" bgcolor="#FFFFCC">�ύX��</td>
                                                        <td bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td align="center" bgcolor="#FFFFCC"><a href="$indexcgi?md=ml&id=$id&n=r"><font color="#0000FF">�{���̕ҏW</font></a></td>
                                                      </tr>
                                                      <tr>
                                                        <td align="center" bgcolor="#FFFFCC" height="30"><input name="r3" type="checkbox" id="r" value="checkbox"$ck3></td>
                                                        <td nowrap="nowrap" bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td align="center" valign="middle" bgcolor="#FFFFCC">������</td>
                                                        <td bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td bgcolor="#FFFFCC">&nbsp;</td>
                                                        <td align="center" bgcolor="#FFFFCC"><a href="$indexcgi?md=ml&id=$id&n=c"><font color="#0000FF">�{���̕ҏW</font></a></td>
                                                      </tr>
                                                      
                                                  </table></td>
                                                </tr>
                                              </table>
                                              <br>
                                              <input name="md" type="hidden" id="md" value="resche">
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="count" type="hidden" id="count" value="$count">
                                              <input name="display" type="hidden" id="display" value="$now">
                                              <input type="submit" name="Submit2" value="�@�X�V�𔽉f�@" onClick="return confir('�X�V���܂����H');"><input type="reset" name="Submit4" value="�@���ɖ߂��@">
                                              <br>
                                              <table width="450" cellpadding="2">
                                                <tr>
                                                  <td width="5%" align="right" valign="top">��</td>
                                                  <td width="95%" align="left">���́u�s�v���`�F�b�N����ƁA�o�^�E�ύX�E�������̃��[����z�M���܂���B</td>
                                                </tr>
                                                <tr>
                                                  <td align="right" valign="top">��</td>
                                                  <td align="left">�u�ꎞ��~�v���`�F�b�N����ƁA�O��X�e�b�v�̑��M��ɒ�~��ԂƂȂ�ȍ~�̃X�e�b�v���[���̔z�M�����~����܂��B<br />
                                                    ����������Ɏ���X�e�b�v�֐i�߂�Ȃǂɗ��p����ƕ֗��ł��B</td>
                                                </tr>
                                                <tr>
                                                  <td align="right" valign="top">��</td>
                                                  <td align="left">��~��ԂƂȂ����o�^�҂֎���X�e�b�v�𑗐M����ɂ́A�u�o�^�ҏ��v��ʂ́u�ĊJ�v�{�^�����N���b�N���邩�u�z�M���v���X�V���Ă��������B</td>
                                                </tr>
                                                <tr>
                                                  <td align="left">&nbsp;</td>
                                                  <td align="left"><font color="FF0000"><strong>�u�s�v���`�F�b�N�����u�{���̕ҏW�v���s��Ȃ��ƁA�o�^�҂ɋ�̃��[���������Ă��܂��܂��̂ŁA�����ӂ��������B</strong></font></td>
                                                </tr>
                                              </table>
                                            </form></td>
                                        </tr>
                                      </table>
END
		#-----------#
		# ���t�w��  #
		#-----------#
		$table .= <<"END";
                               <table width="100%" border="0" cellspacing="0" cellpadding="5">
                                  <tr> 
                                    <td bgcolor="#FFFFCC"><form name="form1" method="post" action="$indexcgi?md=schedule&id=$id">
                                        <table width="100%" border="0" cellpadding="2" cellspacing="0">
                                          
                                          <tr bgcolor="#F3C261"> 
                                            <td height="20" colspan="3">�����t�Ŏw��</td>
                                          </tr>
                                          <tr> 
                                            <td width="50%">&nbsp;</td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                          </tr>
END
		foreach my $date ( @dates ) {
			# ���t�p�R�[�h����
			my ( $mon, $day, $year ) = split( /\//, $date );
			my $target = sprintf("%02d", $mon) . sprintf("%02d", $day);
			$target .= sprintf("%04d", $year) if( $year > 0 );
			
			# ���t�w��i���j
			my $smon = qq|<select name="mon$target" id="interval">\n|;
            for(my $t=1; $t<=12; $t++ ){
				my $selected = ($mon == $t)? 'selected': '';
				$smon .= qq|<option value="$t" $selected>$t</option>\n|;
			}
            $smon .= '</select>';
			
			# ���t�w��i���j
            my  $sday = qq|<select name="day$target" id="interval">\n|;
            for(my $t=1; $t<=31; $t++ ){
				my $selected = ($day == $t)? 'selected': '';
				$sday .= qq|<option value="$t" $selected>$t</option>\n|;
			}
            $sday .= '</select>';
			my $syear = &ToYearOption( $year -0 );
			$table .= <<"END";
                                          <tr>
                                            <td align="right"><select name="year$target">$syear</select>�N$smon��$sday��</td>
                                            <td><input type="submit" name="del$target" value="�폜" onClick="return confir('�폜���܂����H');"></td>
                                            <td><a href="$indexcgi?md=ml&id=$id&n=d$target"><font color="#0000FF">�{���̕ҏW</font></a></td>
                                          </tr>
END
		}
		my $addmon = qq|<select name="addmon">\n|;
		my $addday = qq|<select name="addday">\n|;
        for(my $t=0; $t<=31; $t++ ){
			my $str = ( $t )? $t: '--';
			$addmon .= qq|<option value="$t">$str</option>\n| if ( $t <= 12 );
			$addday .= qq|<option value="$t">$str</option>\n|;
		}
		$addmon .= '</select>';
		$addday .= '</select>';
		$addyear = &ToYearOption();
		$table .= <<"END";
                                          <tr> 
                                            <td align="center" colspan="3">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td align="center" colspan="3">&nbsp;
                                            �z�M���t�̒ǉ�
                                            <select name="addyear">$addyear</select>�N$addmon��$addday��</td>
                                          </tr>
                                          <tr align="center"> 
                                            <td colspan="3"><input name="md" type="hidden" id="md" value="resche">
                                              <input name="type" type="hidden" id="id" value="date">
                                              <input name="id" type="hidden" id="id" value="$id">
                                              <input name="count" type="hidden" id="count" value="$count">
                                              <input type="submit" name="Submit" value="�@�X�V�𔽉f�@" onClick="return confir('�X�V���܂����H');"></td>
                                          </tr>
                                          <tr>
                                            <td colspan="3" align="center">
                                              <table width="450" cellpadding="2">
                                                      <tr>
                                                        <td width="5%" align="right" valign="top">��</td>
                                                        <td width="95%" align="left">�N�x���o�߂������͏�����\\���ƂȂ�܂�</td>
                                                      </tr>
                                                      <tr>
                                                        <td width="5%" align="right" valign="top">��</td>
                                                        <td width="95%" align="left">�o�^�҂֎w��̓��t�Ɉꊇ�Ń��[�����z�M�����ׁA���M���ɂ���Ă̓T�[�o�[�ւ̕��ׂ������Ȃ�ꍇ������܂��B</td>
                                                      </tr>
                                                      <tr>
                                                        <td>&nbsp;</td>
                                                        <td><font color="#FF0000"><strong>�z�M�v�����Ƃ͕ʂɗՎ��Ƀ��[����z�M����ꍇ�́A
                                                        �u�o�^�҂փ��[�����M�v���g�p���Ă��������B</strong></font></td>
                                                      </tr>
                                                  </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </form></td>
                                  </tr>
                                         <tr>
                                          <td align="center" bgcolor="#FFFFFF">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td bgcolor="#FFFFFF"><form enctype="multipart/form-data" method="post" action="$indexcgi">
                                              <table width="500" border="0" cellspacing="0" cellpadding="5">
                                                <tr>
                                                  <td bgcolor="#FFCC66">���{���̃_�E�����[�h/�A�b�v���[�h</td>
                                                </tr>
                                                <tr>
                                                  <td align="center" bgcolor="#FFFFCC"><input name="stepfile" type="file" size="50">
                                                    <input type="submit" name="Submit3" value="�@�X�V�@" onclick="return confir('�{���f�[�^���X�V���܂��B\\n�{���ɂ�낵���ł����H');"></td>
                                                </tr>
                                                <tr>
                                                  <td align="center" bgcolor="#FFFFCC">[ <a href="$indexcgi?md=down_step&id=$id"><font color="#0000FF">�{�����_�E�����[�h</font></a> ]</td>
                                                </tr>
                                                <tr>
                                                 <td align="center" bgcolor="#FFFFCC"><table width="450" cellpadding="2">
                                                      <tr>
                                                        <td align="right" valign="top">��</td>
                                                        <td align="left">�{���X�V�p��CSV�t�@�C�����u�Q�Ɓv���I�����������B<br>
                                                          �A�b�v���[�h�ɂ��{�����X�V����ꍇ�́A�K���u�{�����_�E�����[�h�v���ŐV�̃f�[�^���擾���������B</td>
                                                      </tr>
                                                      <tr>
                                                        <td width="5%" align="right" valign="top">��</td>
                                                        <td width="95%" align="left">�z�M�����ɓo�^���Ă��Ȃ��f�[�^�́A�o�^�E�X�V����܂���B</td>
                                                      </tr>
                                                  </table></td>
                                                </tr>
                                              </table><input name="md" type="hidden" id="md" value="upload_step">
                                              <input name="id" type="hidden" id="id" value="$id">
                                            </form></td>
                                        </tr>
                                  <tr>
                                   <td><br>�� <strong>�X�e�b�v���[���̔z�M�J�n�ɂ���</strong><br><br>
                                      �o�^�҂̓o�^���ɔz�M���鎖�͂ł��܂���B<br>
                                      �z�M�Ԋu�͓o�^������̋N�Z�ƂȂ�܂��B<br>
                                      �z�M�Ԋu��1����ɐݒ肳��Ă���ꍇ�A�o�^���̗����łȂ��Ɣz�M����܂���B<br>
                                      �o�^���̗����ɔz�M�����s�����΁A�z�M����܂��B
                                   </td>
                                  </tr>
                                  <tr>
                                   <td><br>�� <strong>�ғ����̃X�P�W���[���ύX�ɂ���</strong><br><br>
�v�����ғ����ɃX�P�W���[�����ǉ��E�폜���ꂽ�ۂ́A"�e�o�^�҂́u�z�M�ς݉�v"��<br>
�����I�ɒ������X�V���e��K�؂ɏ���������̔z�M�{�������肳��܂��B<br>
<br>
�E�u�z�M�ς݉�v���O�̃f�[�^���ǉ����ꂽ�ꍇ�́u�z�M�ς݉�v���P�i�߂܂��B<br>
�E�u�z�M�ς݉�v���O�̃f�[�^���폜���ꂽ�ꍇ�́u�z�M�ς݉�v���P�߂��܂��B<br>
�E�u�z�M�ς݉�v����̃f�[�^���ǉ��E�폜���ꂽ�ꍇ�A�����̕K�v���Ȃ��ג����͂���܂���B<br>

                                    </td>
                                  </tr>
                                </table>
END
	} else {
	# �ڍ׃y�[�W�p
		# �{���薼���擾
		my $qfilepath = $myroot. $data_dir. $queue_dir. $qfilename;
		my $body = &get_body( $qfilepath );
		my $def_subject = '(�薼���ݒ�)';
		$table = <<"END";
                                      <table width="400" border="0" cellpadding="2" cellspacing="0">
                                        <tr> 
                                          <td width="40" align="center">�g�p</td>
                                          <td width="60">�z�M��</td>
                                          <td width="60">�z�M�Ԋu</td>
                                          <td width="175">&nbsp;</td>
                                          <td width="65">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
END
		my $baseNum = '�o�^��';
		for ( my $i=0; $i<=$count; $i++ ) {
			my $num = $i+1;
			$num = ($i)? "��$num��":'�o�^��';
			my( $int, $config ) =  split(/\//,$interval[$i-1]) if ($i>0);
			$int .= '����' if( !$config );
			$int = '�o�^��' if( !$i );
			$int = '�ĊJ��' if( $config );
			my $ck = '&nbsp;';
			$ck = ($r1)? '�~': '��' if !$i;
			my $from = ( !$i || $config )? '': $baseNum.'���<br>';
			# �{���薼
			my $mail_subject = ($body->{$i}->{'subject'} eq '' )? $def_subject: &deltag($body->{$i}->{'subject'});
			$table .= <<"END";
                                        <tr> 
                                          <td align="center">$ck</td>
                                          <td>$num</td>
                                          <td><font style="font-size:10px" color="#AAAAAA">$from</font>$int</td>
                                          <td><a href="$indexcgi?md=p&id=$id&n=$i"><font color="#0000FF">$mail_subject</font></a></td>
                                          <td><a href="$indexcgi?md=st&id=$id&n=$i"><font color="#0000FF" onClick="return confir('���M���Ă���낵���ł���?');">���M�e�X�g</font></a></td>
                                        </tr>
END
			$baseNum = $num if( $config );
		}
		foreach ( @dates ) {
			my ( $mon, $day, $year ) = split(/\//, $_ );
			$mon = sprintf("%02d", $mon);
			$day = sprintf("%02d", $day);
			$year = sprintf("%04d", $year);
			my $target = $mon . $day;
			$target .= $year if( $year > 0 );
			$year = '��' if( $year <= 0 );
			
			# �{���薼
			my $mail_subject = ($body->{"d$target"}->{'subject'} eq '' )? $def_subject: &deltag($body->{"d$target"}->{'subject'});
			$table .= <<"END";
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td colspan="2" align="right">$year�N $mon�� $day��&nbsp;</td>
                                          <td><a href="$indexcgi?md=p&id=$id&n=d$target"><font color="#0000FF">$mail_subject</font></a></td>
                                          <td><a href="$indexcgi?md=st&id=$id&n=d$target"><font color="#0000FF" onClick="return confir('���M���Ă���낵���ł���?');">���M�e�X�g</font></a></td>
                                        </tr>
END
		}
        $ck2 = ($r2)? '�~': '��';
        $ck3 = ($r3)? '�~': '��';
		# �{���薼
		my $renew_subject = ($body->{'r'}->{'subject'} eq '' )? $def_subject: &deltag($body->{'r'}->{'subject'});
		my $cancel_subject = ($body->{'c'}->{'subject'} eq '' )? $def_subject: &deltag($body->{'c'}->{'subject'});
			
		$table .= <<"END";
                                        <tr> 
                                          <td align="center">$ck2</td>
                                          <td>�ύX��</td>
                                          <td>&nbsp;</td>
                                          <td><a href="$indexcgi?md=p&id=$id&n=r"><font color="#0000FF">$renew_subject</font></a></td>
                                          <td><a href="$indexcgi?md=st&id=$id&n=r"><font color="#0000FF" onClick="return confir('���M���Ă���낵���ł���?');">���M�e�X�g</font></a></td>
                                        </tr>
                                        <tr> 
                                          <td align="center">$ck3</td>
                                          <td>������</td>
                                          <td>&nbsp;</td>
                                          <td><a href="$indexcgi?md=p&id=$id&n=c"><font color="#0000FF">$cancel_subject</font></a></td>
                                          <td><a href="$indexcgi?md=st&id=$id&n=c"><font color="#0000FF" onClick="return confir('���M���Ă���낵���ł���?');">���M�e�X�g</font></a></td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table>
END
	}
	return $table;
}

#-------------------------#
# �z�M���O�e�[�u���̍쐬  #
#-------------------------#
sub make_log_table {
	
	my ( $id, $csvfile, $file ) = @_;
	my $csvpath = "$myroot$data_dir$csv_dir$csvfile";
	my $path    = "$myroot$data_dir$log_dir$file";
	my $table;
	my $tmp = $myroot . $data_dir . $log_dir . $$ . time . 'log.tmp';
	
	my $lockfull = &lock();
	
	unless ( open(CSV, $csvpath) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br><br>$csvpath���J���܂���<br>�p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	my %CSV;
	while(<CSV>){
		chomp;
		my ( $id, $email ) = ( split(/\t/) )[0, 5];
		$CSV{$id} = $email;
	}
	
	unless ( open(LOG, $path) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br><br>$path���J���܂���<br>�p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	my @log = <LOG>;
	@log = reverse @log;
	if ( @log > $logmax ) {
		splice( @log, $logmax );
		unless ( open(TMP, ">$tmp") ) {
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', '', "�V�X�e���G���[<br><br>�e���v���[�g�t�@�C�����쐬�ł��܂���<br>[ $log_dir ]�p�[�~�b�V�������m�F���Ă�������");
			exit;
		}
		chmod 0606, $tmp;
		my @relog = reverse @log;
		print TMP @relog;
		close(TMP);
		close(LOG);
		rename $tmp, $path;
	}else{
		close(LOG);
	}
	&rename_unlock( $lockfull );
	
	my $position = $param{'pn'};
	
	# �X�^�[�g�R�[�h
	$position = 0 if ( $position < 0 );
	# �n�܂�̃C���f�b�N�X
	my $pstart = $position * $pagemax if ( $position > 0 );
	if ( $pstart > $#log ) {
		$position = 0;
		$pstart = 0;
	}
	# �I���̃C���f�b�N�X
	my $pend = $pstart + ( $pagemax - 1 );
	$pend = $#log if ( $pend > $#log );
	
	# �R�[�h�̐ݒ�
	my $old = $position + 1 if ( ($position + $papemax) < $logmax );
	my $new = $position -1 if ( $position > 0 );
	
	# �\���p
	my $total = @log;
	my $sp = $pstart + 1;
	my $ep = $pend + 1;
	my $newlink = qq|<a href="$indexcgi?md=log&id=$id&pn=$new"><font color="0000FF">���߂�</font></a>| if( $pstart > 0 );
	my $oldlink = qq|<a href="$indexcgi?md=log&id=$id&pn=$old"><font color="0000FF">�i�ށ�</font></a>| if( $pend < $#log );
	my $toplink = qq|<a href="$indexcgi?md=log&id=$id&pn=0"><font color="0000FF">���g�b�v��</font></a>| if( $pstart > 0 );
	#@log = splice( @log, $pstart, $pagemax );
	
    close(LOG);
    if ( @log ) {
        $table = <<"END";

  <table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr><td><strong>�z�M���O</strong>�̈ꗗ��\\�����Ă��܂��B<br>(�ő�ێ��� �ŐV2000���܂�)</td>
  </tr>
  <tr><td>&nbsp;</td>
  </tr>
  <tr><td>�u�薼�v���N���b�N����Ƒ��M�������[���̃v���r���[��\\�����܂��B<br>
          �u���[���A�h���X�v���N���b�N����Ɠo�^�҂̈ꗗ�y�[�W��\\�����܂��B<br>
		  <font color="#FF0000">���z�M��ɍ폜���ꂽ�X�e�b�v���[���̃��O�y�сu�o�^�҂փ��[�����M�v�ő��M���ꂽ���[�����O�̓����N�\\������܂���B</font>
</td>
  </tr>
  <tr><td>&nbsp;</td>
  </tr>
  <tr><td>
    <table>
    <tr>
      <td width="140">[ <strong>$total</strong> <small>����</small> $sp - $ep ]</td><td width="60">$toplink</td><td width="40" align="right">$newlink</td><td width="40">$oldlink</td>
    <tr>
    </table>
  </td>
  </tr>
  <tr>
  <td bgcolor="#FFCCF2">
    <table width="100%" border="0" cellpadding="2" cellspacing="1">
    <tr>
    <td width="200" bgcolor="#FFCCF2">�z�M�薼
    </td>
    <td width="150" bgcolor="#FFCCF2">����
    </td>
    <td width="70" bgcolor="#FFCCF2">�z�M���t
    </td>
    </tr>
END
		foreach( @log[$pstart .. $pend] ) {
			chomp;
			my ( $gnum, $mail, $name, $date, $bnum, $subject ) = split(/\t/);
			$date = &make_date3( $date );
			$name = &deltag( $name );
			$name = '&nbsp;' if(!$name);
			$mail = &deltag( $mail );
			$subject = '�薼���ݒ�' if( $subject eq '' );
			
			if( $bnum eq 'S' ){
				# �������Ȃ�
			}elsif( $bnum eq '' ){
				# �������Ȃ�
			}else{
				$subject = qq|<a href="$indexcgi?md=p&n=$bnum&id=$id"><font color="#0000FF">$subject</font></a>|;
			}
			$mail    = ( $CSV{$gnum} eq $mail )? qq|<a href="$indexcgi?md=g&id=$id#$gnum"><font color="#0000FF">$mail</font></a>|: $mail;
			
			$table .= <<"END";
    <tr>
    <td width="200" bgcolor="#FFFFFF">$subject
    </td>
    <td width="150" bgcolor="#FFFFFF">$mail
    </td>
    <td width="70" bgcolor="#FFFFFF">$date
    </td>
    </tr>
END
        }
        $table .= <<"END";
  </table>
END
    }else{
       $table = <<"END";
<table width="100%" border="0" cellpadding="" cellspacing="">
<tr>
<td>&nbsp;
</td>
</tr>
<tr>
<td align="center">�z�M����Ă��܂���
</td>
</tr>
</table>
END
    }
    return $table;
}

#-------------------------#
# �t�H�[���T���v���̍쐬  #
#-------------------------#
# $mode 0 => ���[�U�[�p
# $mode 1 => �Ǘ��җp
sub make_form {
	my ( $mode, $id, $type, $url, $rch, $sep1, $sep2, $design, @form ) = @_;
	local $md;
	local $submit = ($mode)? $indexcgi: $applycgi;
    local $subval;
    local $conf = qq|onClick="window.open('','new','height=300,width=500,scrollbars=yes');"| if( $rch || ($url eq '') );
	local $_target = qq| target="new"| if ( !$mode && ( $rch || ($url eq '') ) );
	local $button = ($mode)? 'button': 'submit';
	
	# �܂��܂��o�^�@�\���`�F�b�N
	my $rp = &Magu::Check();
	if( $rp->{'ON'} ){
		$_target = qq| target="_blank"|;
		$conf    = '';
	}
	
	#-----------------------------------------
	#-----------------------------------------
	
	# �ȉ��A����p�ɐU�蕪��
	if ( $type eq 'form1' ) {
		
		# �\�����𐮌`
		my @array;
		my @array2;
		@array = splice( @form, 33, 5 );
		@array2 = splice( @array, 4, 1 );
		splice( @form, 2, 0, @array );
		splice( @form, 9, 0, @array2 );
		
		$md = qq|<input name="md" type="hidden" id="md" value="guest">|;
		$subval = '�@�o�^�@';
		local $address=qq|<select name="address" size="1"><option>�k�C��</option><option>�X��</option><option>��茧</option><option>�{�錧</option><option>�H�c��</option><option>�R�`��</option><option>������</option><option>��錧</option><option>�Ȗ،�</option><option>�Q�n��</option><option>��ʌ�</option><option>��t��</option><option>�����s</option><option>�_�ސ쌧</option><option>�V����</option><option>�x�R��</option><option>�ΐ쌧</option><option>���䌧</option><option>�R����</option><option>���쌧</option><option>�򕌌�</option><option>�É���</option><option>���m��</option><option>�O�d��</option><option>���ꌧ</option><option>���s�{</option><option>���{</option><option>���Ɍ�</option><option>�ޗǌ�</option><option>�a�̎R��</option><option>���挧</option><option>������</option><option>���R��</option><option>�L����</option><option>�R����</option><option>������</option><option>���쌧</option><option>���Q��</option><option>���m��</option><option>������</option>
		<option>���ꌧ</option><option>���茧</option><option>�F�{��</option><option>�啪��</option><option>�{�茧</option><option>��������</option><option>���ꌧ</option><option>�S��</option><option>�C�O</option></select>\n|;
		if ( $mode ) {
			#$conf = qq|onClick="return confir('�o�^���܂���?');"|;
			$conf = qq|onClick="alert('�o�^�p�t�H�[���̊m�F�p�ł��B');"|;
			$message = qq|�����̃t�H�[���͊m�F�p�ł��B(PC�p)|;
        }
		
		my $seimei;
		my $seimei_kana;
		
		# �ڍאݒ��ǂݍ���
		my %MF_detail = &MF'_get_detail( $param{'id'}-0 );
		my $i = 1;
		my $d = 1;
		
		# �\�����w��ꗗ
		my @SortOn;
		my @SortOn_m;
		# �\���w�薳��
		my @SortNon;
		my @SortNon_m;
		
		my( $base, $line ) = &MF'_analyTemplate( $design );
		# �g�їp
		my( $mbase, $mline ) = &MF'_analyTemplate( $FormTemplate_mobile, 1 );
		
		foreach ( @form ) {
			my ( $ck, $name, $req, $sort ) = split(/<>/);
			$name = $Ctm'names[$i]->{'value'} if($name eq '');
			my $value = qq|<input name="$Ctm'names[$i]->{'name'}" type="text" size="25">|;
			my $value_m = qq|<input name="$Ctm'names[$i]->{'name'}" type="text" size="14">|;
			# �ڍ׃t�H�[����\��
			if( $i > 18 ){
				$value = &MF'makeform( $Ctm'names[$i]->{'name'}, $MF_detail{$d} );
				$value_m = &MF'makeform( $Ctm'names[$i]->{'name'}, $MF_detail{$d}, 1 );
				$d++;
			}
			#my $width = 150;
			# ���������d�l�t�H�[���ł́A�o�^����͎c�����܂܂Ȃ̂ŁA�d�l�m�F�̂��߈ȉ��R�[�h�͍폜�s������
			# ������
			#if( $i == 2 ){
			#	my( $sep_ch, $name1, $name2 ) = split(/<>/, $sep1);
			#	if( $sep_ch ){
			#		my $sep_name1 = ($name1 eq '')? '��': $name1;
			#		my $sep_name2 = ($name2 eq '')? '��': $name2;
			#		$value = qq|<font size="-1">$sep_name1</font><input name="_name1" type="text" size="10"> <font size="-1">$sep_name2</font><input name="_name2" type="text" size="10">|;
			#		$width = 200;
			#	}
			#}
			#if( $i == 3 ){
			#	my( $sep_ch, $name1, $name2 ) = split(/<>/, $sep2);
			#	if( $sep_ch ){
			#		my $sep_name1 = ($name1 eq '')? '��': $name1;
			#		my $sep_name2 = ($name2 eq '')? '��': $name2;
			#		$value = qq|<font size="-1">$sep_name1</font><input name="_kana1" type="text" size="10"> <font size="-1">$sep_name2</font><input name="_kana2" type="text" size="10">|;
			#		$width = 200;
			#	}
			#}
			$value = $address if ( $i == 15 ); # �s���{��
			$value_m = $address if ( $i == 15 ); # �s���{��
			if ( $ck ne '&nbsp;' && $ck) {
				
				my %FORM;
				$FORM{'name'} = $name;
				$FORM{'form'} = $value;
				$_form = &MF'include( $line, {%FORM} );
				# �g�їp
				$FORM{'form'} = $value_m;
				$_form_m = &MF'include( $mline, {%FORM} );
				
				if( $sort > 0 ){
					$SortOn[$sort] = $_form;
					$SortOn_m[$sort] = $_form_m;
				}else{
					push @SortNon, $_form;
					push @SortNon_m, $_form_m;
				}
			}
			$i++;
		}
		
		foreach( @SortOn ){
			$exchang .= $_;
		}
		foreach( @SortNon ){
			$exchang .= $_;
		}
		# �g�їp
		foreach( @SortOn_m ){
			$exchang_m .= $_;
		}
		foreach( @SortNon_m ){
			$exchang_m .= $_;
		}
		my %FORM;
		$FORM{'__ROW-exchang__'} = $exchang;
		$FORM{'cgi'} = $submit;
		$FORM{'submit'} = $button;
		$FORM{'target'} = $_target;
		$FORM{'javascript'} = $conf;
		$FORM{'hidden'} .= $md. "\n";
		$FORM{'hidden'} .= qq|<input name="id" type="hidden" id="id" value="$id">\n|;
		$FORM{'hidden'} .= qq|<input name="cd" type="hidden" id="cd" value="����">\n|;
		my $source = $message. &MF'include( $base, {%FORM} );
		# �g�їp
		$FORM{'__ROW-exchang__'} = $exchang_m;
		$FORM{'hidden'} = qq|<input type="hidden" name="m_prop" value="id:$id,md:guest,cd:����,mbl:1">|;
		my $source_m = $message. &MF'include( $mbase, {%FORM} );
		
		return $source, $source_m;
		
	} else {
		
		#-----------------------------------------
		# �ύX�E�����p
		#-----------------------------------------
		# �㕔
		my $form_source = <<"END";
<table width="270" border="0" cellspacing="0" cellpadding="0">
<form name="form1" method="post" action="$submit"$_target>
END
		my $form_source_m = <<"END";
<form  method="post" action="$submit">
END
		my @names = (
			{'name' => 'userid', 'value' => '�o�^��ID'},
			{'name' => 'mail', 'value' => '�ύX�O���[���A�h���X'},
			{'name' => 'nmail', 'value' => '�ύX�チ�[���A�h���X'},
		);
        my ( $ck, $uid, $mail, $rmail ) = split(/<>/, $form[0]);
        $uid  = $names[0]->{'value'} if ( $uid eq '' );
        $mail = $names[1]->{'value'} if ( $mail eq '' && $type eq 'form2' );
        $mail = '���[���A�h���X' if ( $mail eq '' && $type eq 'form3' );
        $rmail = $names[2]->{'value'} if ( $rmail eq '' );
        
        if ( $type eq 'form2' ) {
			
			#----------------------------------------------------------
			# �ύX�p
			#----------------------------------------------------------
			$md = qq|<input name="md" type="hidden" id="md" value="renew">|;
			$subval = '�@�ύX�@';
			
			# �R�����g
			if ( $mode ) {
				$conf = qq|onClick="alert('�ύX�p�t�H�[���̊m�F�p�ł��B');"|;
				$form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" colspan="2">�����̃t�H�[���͊m�F�p�ł��B(PC�p)<br><br></td>
</tr>
END
			}
			
			# �o�^��ID
			if ( $ck eq '1' ) {
				$form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$uid</font></td>
<td bgcolor="#FFFFFF"><input type="text" name="$names[0]->{'name'}" size="25"></td>
</tr>
END
				$form_source_m .= <<"END";
��$uid�F<input type="text" name="$names[0]->{'name'}" size="14"><br>
END
			}
			# ���̓t�H�[��
			$form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$mail</font></td>
<td bgcolor="#FFFFFF" width="150"><input type="text" name="$names[1]->{'name'}" size="25"></td>
</tr>
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$rmail</font></td>
<td bgcolor="#FFFFFF"><input type="text" name="$names[2]->{'name'}" size="25"></td>
</tr>
END
			$form_source_m .= <<"END";
��$mail�F<br>
<input type="text" name="$names[1]->{'name'}" size="14"><br>
��$rmail�F<br>
<input type="text" name="$names[2]->{'name'}" size="14"><br>
END
			
	    }elsif ( $type eq 'form3' ) {
			
			#----------------------------------------------------------
			# �폜�p
			#----------------------------------------------------------
			$md = qq|<input name="md" type="hidden" id="md" value="cancel">|;
			$subval = '�@�����@';
			
			if ( $mode ) {
				$conf = qq|onClick="alert('�����p�t�H�[���̊m�F�p�ł��B');"|;
				$form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" colspan="2">�����̃t�H�[���͊m�F�p�ł��B(PC�p)<br><br></td>
</tr>
END
            }
            if ( $ck eq '1' ) {
                $form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$uid</font></td>
<td bgcolor="#FFFFFF"><input type="text" name="$names[0]->{'name'}" size="25"></td>
</tr>
END
				$form_source_m .= <<"END";
��$uid�F<br>
<input type="text" name="$names[0]->{'name'}" size="14"><br>
</tr>
END
            }
            $form_source .= <<"END";
<tr>
<td bgcolor="#FFFFFF" width="120"><font size="-1">$mail</font></td>
<td bgcolor="#FFFFFF" width="150"><input type="text" name="$names[1]->{'name'}" size="25"></td>
</tr>
END
			$form_source_m .= <<"END";
��$mail�F<br>
<input type="text" name="$names[1]->{'name'}" size="14"><br>
END
    	}
		$form_source .= <<"END";
<tr>
<td colspan="2" align="center">
$md
<input name="id" type="hidden" id="id" value="$id">
<input type="$button" value="$subval" $conf>
<input name="cd" type="hidden" id="cd" value="����">
</td>
</tr>
</form>
</table>
END
		$form_source_m .= <<"END";

$md
<input name="id" type="hidden" value="$id">
<input type="$button" value="$subval">
<input name="cd" type="hidden" value="����">
<input name="mbl" type="hidden"  value="1">
</form>
END
		return $form_source, $form_source_m;
	}
}

#------------------------------#
# �o�^�ݒ�y�[�W�̍쐬�i�ڍׁj #
#------------------------------#
sub make_redirect_table {
    my ( $r, $n, $c, $o, $m, $http_regist, $http_renew, $http_cancel ) = @_;
	
	my $regist = &Pub'setHttp( $r, $http_regist, 'all' );
	my $renew = &Pub'setHttp( $n, $http_renew, 'all' );
	my $cancel = &Pub'setHttp( $c, $http_cancel, 'all' );
	
    $r = ( $r && $r ne '&nbsp;')? qq|<a href="$regist" target="_new"><font color="#0000FF">$regist</font></a>|: '�i���ݒ�j';
    $n = ( $n && $n ne '&nbsp;' )? qq|<a href="$renew" target="_new"><font color="#0000FF">$renew</font></a>|: '�i���ݒ�j';
    $c = ( $c && $c ne '&nbsp;' )? qq|<a href="$cancel" target="_new"><font color="#0000FF">$cancel</font></a>|: '�i���ݒ�j';
	$mes = ( $m && $m ne '&nbsp;' )? '�i�Ǘ��҂ɒʒm�j': '';
    my $table = <<"END";
                                               <table width="100%" border="0" cellpadding="1" cellspacing="0">
                                               <tr>
                                               <td>���o�^����$mes
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>$r
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>���ύX����
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>$n
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>����������
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>$c
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>����t����
                                               </td>
                                               </tr>
                                               <tr>
                                               <td>$o
                                               </td>
                                               </tr>
                                               </table>
END
    return $table;
}

#-------------------------#
# �o�^�ҏ��y�[�W�쐬    #
#-------------------------#
sub make_guest_table {
    my ( $id, $file, $chk ) = @_;
    my $table;
	
	# ����
	my $search;
	if( !$chk ){
		$search = $param{'search_str'};
		if( $search eq '' && !$param{'search'} ){
			$search = &unescape($all_cookies{'raku_search'});
		}
		my $search_cookie = &escape($search);
		print "Set-Cookie: raku_search=$search_cookie", "\n";
	}
#======================== �C���ӏ� ========================
$pnum = $param{'pnum'};
unless($pnum){
	$pnum = 1;
}
#==========================================================
    my $path = "$myroot$data_dir$csv_dir$file";
    unless ( open(CSV, "$path") ) {
		return if( $readflag );
		$readflag = 1;
        &make_plan_page( 'plan', '', "�V�X�e���G���[<br>$path���J���܂���<br>�p�[�~�b�V�������m�F���Ă�������");
        exit;
    }
	my $total = 0;
    unless( -z $path ) {
		while( <CSV> ) {
			my @str;
			if( $chk ){
				close(CSV);
				return 1;
			}
			if( $search ne '' ){
				@str = split(/\t/);
				$search_flag = 1;
				$search_result = qq|<td align="right" nowrap><font color="#FF0000"><strong>�i���� [  </strong><a href="$indexcgi?md=g&id=$id"><font color="#0000FF">��������</font></a><strong> ]</strong></font></td>|;
				next if( index($str[5], $search) < 0 );
			}
			$total++;
            chomp;
#======================== �C���ӏ� ========================
	if($total>($pnum-1)*100 && $total<=$pnum*100){
#==========================================================
			@str = split(/\t/) if( $search eq '' );
            my $uid = $str[0];
            my $email = &deltag( $str[5] );
            my $name = &deltag( $str[3] );
            my $date = &make_date3( $str[19] );
            my $result = "���z�M" if($str[20] eq '');
			my $status = '�ʏ�';
			$status = qq|��$str[51]��`| if( $str[51] > 0 );
			$status = qq|<input type="submit" name="restart-$uid-$str[20]" value="�ĊJ" onclick="return confir('�z�M���ĊJ���܂��B\\n�X�V�シ���ɁA�Y���̃X�e�b�v���[�������M����܂��B\\n\\n��낵���ł���?');">| if( $str[52] );
			$status = qq|�I��| if( $str[51] eq 'end' );
            $result = "�o�^��" if($str[20] eq 0);
            $result = "��$str[20]��" if($str[20] > 0);
            $_table .= <<"END";
                                  <tr align="center">
                                  <td bgcolor="#FFFFFF" align="left"><a name="$uid">$email</a></td>
                                  <td bgcolor="#FFFFFF" align="left">$name</td>
                                  <td bgcolor="#FFFFFF">$date</td>
                                  <td bgcolor="#FFFFFF">$result</td>
                                  <td bgcolor="#FFFFFF" align="center">
                                    <a href="$indexcgi\?md=ref&id=$id&n=$uid"><font color="#0000FF">�ҏW</font>
                                  </td>
                                  <td bgcolor="#FFFFFF">$status</td>
                                  </tr>
END
        }
	}
	
	# �����̌��ʊY�����[�U�����݂��Ȃ��ꍇ
	if( $search_flag && $_table eq '' ){
		$_table .= <<"END";
                                  <tr>
                                  <td colspan="5" bgcolor="#FFFFFF" align="center">�Y������o�^�҂����݂��܂���B
                                  </td>
                                  </tr>
END
	}
#======================== �C���ӏ� ========================

$pnuma = $pnum-1;
$pnumb = $pnum+1;
$mpnum = ($total/100 == int($total/100) ? $total/100 : int($total/100+1)); 


if($pnum <= 1){
$prepage = <<"END";
	<td align="left"><font color="#999999">�O��100��</font></td>
END
}else{
$prepage = <<"END";
	<td align="left"><a href="$indexcgi\?md=g&id=$id&pnum=$pnuma"><font color="#0000FF">�O��100��</font></a></td>
END
}
if($pnum*100 >= $total){
$nextpage = <<"END";
	<td align="right"><font color="#999999">����100��</font></td>
END
}else{
$nextpage = <<"END";
	<td align="right"><a href="$indexcgi\?md=g&id=$id&pnum=$pnumb"><font color="#0000FF">����100��</font></a></td>
END
}
#==========================================================
		$pnum = 0 if( $total <= 0 );
        $table = <<"END";
                              <table width="100%" cellpadding="0" cellspacing="0" border="0">
                              
                              <tr>
                              <td>[ <a href="$indexcgi\?md=add&id=$id"><font color="#0000FF">�ǉ�</font></a> ]
                              �@
                              [ <a href="$indexcgi\?md=get&id=$id"><font color="#0000FF">�ꗗ���_�E�����[�h</font></a> ]
                              �@
                              [ <a href="$indexcgi\?md=up&id=$id"><font color="#0000FF">�ꗗ���A�b�v���[�h</font></a> ]
                              �@
                              [ <a href="$indexcgi\?md=mail&id=$id"><font color="#0000FF">���[���𑗐M����</font></a> ]
                              </td>
                              </tr>
                              <tr>
                              <td>&nbsp;
                              </td>
                              </tr>
                              <tr>
                              <td align="center" valign="middle">
                                 <br>
                                 <table border="1" cellpadding="2" cellspacing="0" bordercolor="#ACA899">
                                   <tr><form action="" method="post">
                                     <td bgcolor="#EFEDDE">�@�o�^�҂̃��[���A�h���X��
                                       <input type="text" name="search_str" size="30" value="$search">
                                       ��
                                       <input type="submit" value="�i�荞��">�@
                                       <input type="hidden" name="md" value="g">
                                       <input type="hidden" name="id" value="$id">
                                       <input type="hidden" name="pnum" value="0">
                                       <input type="hidden" name="search" value="1"></td>
                                     </form></tr>
                                 </table></td>   
                              </tr>
                               <tr>
                              <td>&nbsp;
                              </td>
                              </tr>
                              <tr>
                              <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                  <td align="left" nowrap><strong>�o�^��</strong>�̈ꗗ<font color="#FF0000">�@</font> [ <strong>TOTAL</strong> $total �� ]�@�@[ $pnum / $mpnum �y�[�W ] </td>
                                  $search_result
                                </tr>
                              </table></td>
                              </tr>
	<tr>
	<td><table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
$prepage
$nextpage
	</tr>
	</table></td>
	</tr>

                              <tr>
                              <td>
                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                
                                <tr>
                                <td bgcolor="#99CCFF">
                              
                                                  <table width="100%" cellpadding="2" cellspacing="1" border="0">
                                                    <tr>
                                                      <td align="center"><font color="#000000">���[���A�h���X</font> </td>
                                                      <td width="18%" align="center" nowrap><font color="#000000">�����O</font> </td>
                                                      <td width="16%" align="center" nowrap><font color="#000000">�o�^��</font> </td>
                                                      <td width="11%" align="center" nowrap><font color="#000000">�z�M��</font> </td>
                                                      <td width="8%" align="center"><font color="#000000">&nbsp;</font> �ҏW</td>
                                                      <td width="10%" align="center" nowrap>���</td>
                                                    </tr>
                                                    <form ation="$indexcgi" method="post">$_table
													<input type="hidden" name="md" value="restart"><input type="hidden" name="id" value="$id"><input type="hidden" name="pnum" value="$pnum"></form>
                                                  </table>
                                </td></tr></table>
                              
                              </td>
                              </tr>
                              </table>
END
    }
	if( $total <= 0 && $search_flag <= 0 ){
        $table = <<"END";
                              <table width="100%" cellpadding="0" cellspacing="0" border="0">
                              <tr>
                              <td>&nbsp;
                              </td>
                              </tr>
                              <tr>
                              <td align="center">�o�^����Ă��܂���@�@ [ <a href="$indexcgi\?md=add&id=$id"><font color="#0000FF">�ǉ�</font></a> ]
                                                                        �@�@[ <a href="$indexcgi\?md=up&id=$id"><font color="#0000FF">�ꗗ���A�b�v���[�h</font></a> ]
                              </td>
                              </tr>
                              <tr>
                              <td>&nbsp;
                              </td>
                              </tr>
                              </table>
END
    }
	close(CSV);
    return $table;
}

#--------------------------#
# �p�X���[�h�F��HTML�̏o�� #
#--------------------------#
sub html_pass {

	print &html_header();
	print<<"END";
<body>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr> 
    <td><form action="$indexcgi" method="post">
        <br>
        <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr> 
            <td bgcolor="#000000"> 
              <table width="500" border="0" cellpadding="2" cellspacing="1">
                <tr bgcolor="#005E80"> 
                  <td colspan="2" align="center"><strong><font color="#FFFFFF">
                    �������[���z�M�V�X�e���u�y���[���v<BR>�p�X���[�h�F��</font></strong>
                  </td>
                </tr>
                <tr> 
                  <td width="30%" align="center" bgcolor="#ABDCE5"><font color="#333333">���[�U�[ID</font></td>
                  <td bgcolor="#E5FBFF"> <input name="input_id" type="text" size="40"> 
                  </td>
                </tr>
                <tr> 
                  <td width="30%" align="center" bgcolor="#ABDCE5"><font color="#333333">�p�X���[�h</font></td>
                  <td bgcolor="#E5FBFF"> <input name="input_pass" type="password" size="20"> 
                  </td>
                </tr>
                <tr bgcolor="#FFFFFF"> 
                  <td colspan="2" align="center"> <input type="submit" name="Submit" value="�@���O�C���F�؁@"> 
                    <br> <font size=2 color="7398E5">�Ǘ��c�[�����g�p����ɂ�Cookie��ON�ɂȂ��Ă���K�v������܂�</font>
					</td>
                </tr>
              </table></td>
          </tr>
        </table>

        <br>
        <br>
        <table border="1" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><iframe scrolling="Yes" frameborder="0" width="500" height="210" src="http://www.raku-mail.com/iframe_cgi_pr.htm"><a href="http://www.raku-mail.com/" target="_blank">�y���[���V�����</a>�� iframe �Ή��̃u���E�U�Ō��Ă��������B </iframe></td>
          </tr>
        </table><br>
        <table border="1" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><iframe scrolling="Yes" frameborder="0" width="500" height="210" src="http://www.raku-mail.com/iframe_cgi_info.htm"><a href="http://www.raku-mail.com/" target="_blank">�y���[���V�����</a>�� iframe �Ή��̃u���E�U�Ō��Ă��������B </iframe></td>
          </tr>
        </table>
        <input name="md" type="hidden" value="ck">
      </form></td>
  </tr>
</table>
</body>
</html>
END
	exit;
}


sub page {
	
	my( $position, $logmax ) = @_;
	# �X�^�[�g�R�[�h
	$position = 0 if ( $position < 0 );
	# �n�܂�̃C���f�b�N�X
	my $pstart = $position * $pagemax if ( $position > 0 );
	
	# �I���̃C���f�b�N�X
	my $pend = $pstart + ( $pagemax - 1 );
	
	# �R�[�h�̐ݒ�
	my $old;
	if( $logmax ){
		$old = $position + 1 if( ($position + $papemax) < $logmax );
	}else{
		$old = $position + 1;
	}
	my $new = $position -1 if ( $position > 0 );
	return $pstart, $pend, $old, $new;
}

#-----------------------------------------------#
# �Ǘ��c�[���̃t���[���̏o�́i�Ǘ��̃��C����ʁj#
#-----------------------------------------------#
sub edit_frame {
    my($menu)=@_;
    print &html_header();
    print "<frameset cols=\"180px,*\">\n";
    print "<frame src=\"$target_menu\" name=\"$frame_menu\">\n";
    print "<frame src=\"$target_main\" name=\"$frame_main\">\n";
    print "</frameset>\n";
    print "</html>\n";
    exit;
}

sub disp_config{
	open( CONF, "./config.pl" );
	binmode(CONF);
	print qq|Content-Disposition: attachment; filename="config.txt"| , "\n";
	print "Content-type: application/x-txt", "\n\n";
	while(<CONF>){
		print $_;
	}
	close(CONF);
	exit;
}
sub disp_error{
	my $errfile = "$myroot$data_dir" . 'errorlog.cgi';
	open( ERR, $errfile );
	binmode(ERR);
	print qq|Content-Disposition: attachment; filename="errorlog.txt"| , "\n";
	print "Content-type: application/x-txt", "\n\n";
	while(<ERR>){
		print $_;
	}
	close(ERR);
	exit;
}
sub disp_pms
{
	my $index = &dist_pms_check( $indexcgi );
	my $apply = &dist_pms_check( $applycgi_name );
	my $send = &dist_pms_check( $sendcgi );
	
	open( CGI, "<$sendcgi" );
	while(<CGI>){
		if( /^\$myroot/ ){
			$scriptcode = $_;
			last;
		}
	}
	close(CGI);
	$scriptcode = $sendcgi.'<font color="#FF0000"> �Ɏw��R�[�h��������܂���B<br>������ҏW���s�����\��������܂��B</font>' if( $scriptcode eq '' );
	
	$ENV{'SCRIPT_FILENAME'} =~ /(.*)$indexcgi/;
	my $rootpath = $1;
	
	$index->{'perl'} = &getPerlpath( $indexcgi );
	$apply->{'perl'} = &getPerlpath( $applycgi_name );
	$send->{'perl'} = &getPerlpath( $sendcgi );
	
	
	print <<"END";
Content-type: text/html

<html>
<head></head>
<body>
<h4>�p�[�~�b�V�����m�F</h4>
<strong>�y CGI �z</strong>
<table>
<tr>
 <td align="right">$indexcgi �F</td>
 <td>[ $index->{'pms'} ]</td>
 <td>$index->{'error'}</td>
 <td>$index->{'message'}</td>
</tr>
<tr>
 <td align="right">$applycgi_name �F</td>
 <td>[ $apply->{'pms'} ]</td>
 <td>$apply->{'error'}</td>
 <td>$apply->{'message'}</td>
</tr>
<tr>
 <td align="right">$sendcgi �F</td>
 <td>[ $send->{'pms'} ]</td>
 <td>$send->{'error'}</td>
 <td>$send->{'message'}</td>
</tr>
</table>
<br><br>
<h4>Perl�p�X�m�F</h4>
<table>
<tr>
 <td align="right">$indexcgi �F</td>
 <td>[$index->{'perl'}]</td>
</tr>
<tr>
 <td align="right">$applycgi_name �F</td>
 <td>[$apply->{'perl'}]</td>
 <td></td>
</tr>
<tr>
 <td align="right">$sendcgi �F</td>
 <td>[$send->{'perl'}]</td>
</tr>
</table>
<br><br>
<h4>Cron�m�F</h4>
<table>
<tr>
 <td align="left">$sendcgi �̐�΃p�X�ݒ�(��distribute�f�B���N�g���w��)</td>
</tr>
<tr>
 <td><strong>$scriptcode</strong></td>
</tr>
<tr>
 <td>[$rootpath]<br>($indexcgi���ݒu���ꂽ��΃p�X)</td>
</tr>
</table>
</body>
</html>

END
	exit;
}
sub dist_pms_check
{
	my( $path ) = @_;
	my %hash;
	$hash{'pms'} = &_getPms( $path );
	$hash{'message'} = &checkPms('cgi', $path);
	$hash{'error'} = ( $hash{'message'} eq '' )? $ErrorMessage{'001'}: $ErrorMessage{'002'};
	return {%hash};
}

sub getPerlpath
{
	my $path = shift;
	open( CGI, "<$sendcgi" );
	my $line = <CGI>;
	close(CGI);
	chomp( $line );
	return $line;
}

sub getControl
{
	my $file = $param{'p'};
	$file =~ s/\.\.\///g;
	
	my $path = $myroot. $data_dir. $file;
	my $filename;
	if( $path =~ /([^\/]+)$/ ){
		$filename = $1;
	}
	
	open( ERR, $path );
	binmode(ERR);
	print qq|Content-Disposition: attachment; filename="$filename"| , "\n";
	print "Content-type: application/x-txt", "\n\n";
	while(<ERR>){
		print $_;
	}
	close(ERR);
	unless( -e $path ){
		print $filename. ' �͌�����܂���ł���';
	}
	exit;
}


sub manual
{
	my $html = $param{'p'};
	$html =~ s/\.//g;
	$html =~ s/\///g;
	
	my $path = $manual . '/'. $html . '.html';
	
	if( $html eq 'distribute' ){
		my $filename = $html . '.csv';
		my $path = $manual . '/'. $filename;
		&manual_csv( $filename, $path );
		exit;
	}
	
	open( HTML, $path );
	my $source;
	while(<HTML>){
		while( ( $parameter ) = ( /<%__([^<>\%]+)__%>/oi ) ) {
			s//$$parameter/;
		}
		$source .= $_;
	}
	close(HTML);
	print <<"END";
Content-type: text/html

$source
END
	exit;
}
sub manual_csv
{
	my($filename, $path)  = @_;
	
	open( CSV, $path );
	my @csvdata = <CSV>;
	close(CSV);
	
	print qq|Content-Disposition: attachment; filename="$filename"| , "\n";
	print "Content-type: application/x-csv", "\n";
	print "\n";
	print @csvdata;
	exit;
}

sub restart
{
	my $id = $param{'id'};
	my $userid;
	foreach( keys %param ){
		if( /^restart-(\d+)-(\d*)$/ ){
			$userid = $1;
			$sended = $2;
			last;
		}
	}
	my $target = ( $sended > 1 )? $sended+1: 2;
	if( $userid eq '' ){
		&make_plan_page( 'plan', '', '�o�^�҂��w�肵�Ă��������B' );
	}
	
	# ���s
	&restart_action( $id, $userid, $target );
	&make_plan_page( 'plan', 'guest');
	exit;
}

sub restart_action
{
	my( $id, $userid, $target ) = @_;
	
	#---------------------#
	# �r������            #
	#---------------------#
	my $lockfull = &lock();
	
	# ���M�ςݒZ�kURL���擾
	my $forward = &Click'getForward_url();
	
    #--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	my @line;
	my $csvpath;
	my $queuepath;
	my $logpath;
	my %ra_conf;
	while( <PLAN> ) {
		chomp;
		@line = split(/\t/);
		if ( $line[0] eq $id ) {
			$csvpath   = "$myroot$data_dir$csv_dir$line[6]";
			$queuepath = "$myroot$data_dir$queue_dir$line[7]";
			$logpath   = "$myroot$data_dir$log_dir$line[8]";
			&Pub'ssl($line[83]);
			last;
		}
	}
	close(PLAN);
	
	#---------------------------#
	# �]���p�^�O�擾            #
	#---------------------------#
	my( $urlTag, $other ) = &Click'roadTag( $line[82] );
	my $uniq;
	my( $step, $dates ) = split(/<>/, $line[36] );
	my $n = 2;
	foreach( split(/,/, $step ) ){
		my( $inter, $config, $code ) = split(/\//);
		$stepConf{$n} = $config -0;
		$uniq = $code if( $n == $target );
		$n++;
	}
	
	#--------------------------------#
	# �����̓o�^�҃f�[�^����ID���擾 #
	#--------------------------------#
	unless ( open(CSV, "$csvpath") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>$csvpath���J���܂���");
		exit;
	}
	my $tmp = "$myroot$data_dir$csv_dir" . $$ . time . '.tmp';
	unless ( open(TMP, ">$tmp") ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����[�t�@�C�����J���܂���<br>$csv_dir�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	chmod 0606, $tmp;
	my @csvs;
	while( <CSV> ) {
		chomp;
		@csv = split(/\t/);
		my $tar_mail;
		if ( $csv[0] == $userid && $csv[52] ) {
			my $nextStep = ( $csv[20] > 1 )? $csv[20]+1: 2;
			if( $nextStep == $target ){
				if( defined $stepConf{$target} ){
					$csv[20] = $nextStep;
					my %baseTime; # �ĊJ���t
					foreach( split(/<>/,$csv[53] ) ){
						my( $n, $date ) = split(/\//);
						$baseTime{$n} = $date;
					}
					$baseTime{$target} = time;
					my @base;
					foreach( keys %baseTime ){
						push @base, qq|$_/$baseTime{$_}|;
					}
					$csv[53] = join( "<>", @base );
					$csv[52] = ( $stepConf{$target+1} )? 1: '';
				}else{
					$csv[52] = '';
				}
			}
			
			@csvs = @csv; # ���[�����M�p
			$_ = join( "\t", @csv );
		}
		
		print TMP "$_\n";
	}
	close(CSV);
	close(TMP);
	rename $tmp, $csvpath;
	
	if( @csvs && $target ){
		my $rh_body = &get_body( $queuepath );
		$line[9] =~ s/<br>/\n/gi;
		$line[10] =~ s/<br>/\n/gi;
		$line[11] =~ s/<br>/\n/gi;
		my $logNum = $target - 1;
		local ( $subject, $message ) = &make_send_body( $logNum, $rh_body, $line[9], $line[10], $line[11] );
		# �]���^�O�ϊ�
		my $forward_urls;
		($message, $forward_urls) = &Click'analyTag($csv[0], $message, $urlTag, $uniq, $forward);
		
		my $jis = ($CONTENT_TYPE eq 'text/html')? 1: 0;
		$subject = &include( \@csvs, $subject );
		$message = &include( \@csvs, $message, $jis );
		$senderror = &send( $line[4], $line[3], $csvs[5], $subject, $message, '' );
		# �z�M���O�ɒǉ�
		my $now = time;
		unless ( $senderror ) {
			open(LOG, ">>$logpath");
			print LOG "$csvs[0]\t$csvs[5]\t$csvs[3]\t$now\t$logNum\t$subject\n";
			close(LOG);
		}else{
			unlink $tmp;
			&rename_unlock( $lockfull );
			&make_plan_page( 'plan', 'g', '���[�����M�Ɏ��s���܂���');
			exit;
		}
		# �A�N�Z�X�W�v�p�f�[�^����
		&Click'setForward_t( $forward_urls, $uniq );
	}
	&rename_unlock( $lockfull );
}

sub down_step
{
	my $id = $param{'id'} - 0;
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, $file) ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>$file���J���܂���");
		exit;
	}
	my $path;
	while( <PLAN> ) {
		chomp;
		my ( $index, $queue, $_step, $_detail ) = ( split(/\t/) )[0, 7, 35, 36];
		if ( $index eq $id ) {
			$step = $_step;
			$detail = $_detail;
			$path = "$myroot$data_dir$queue_dir$queue";
			last;
		}
	}
	close(PLAN);
	unless ( $path ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>�Y������f�[�^������܂���");
		exit;
	}
	unless ( open(QUEUE, "$path") ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>$path���J���܂���");
		exit;
	}
	my $rh_body = &get_body( $path );
	
	my $filename = 'StepMail-'. $id . '.csv';
	print qq|Content-Disposition: attachment; filename="$filename"| , "\n";
	print "Content-type: application/x-csv", "\n";
	# print "Content-length: ", "\n";
	print "\n";
	
	# ����
	print qq|�X�e�b�v���i���ҏW�s�j,�薼,�{��,�w�b�_(�}������ꍇ�́u1�v),�����ē�(�}������ꍇ�́u1�v),�t�b�^(�}������ꍇ�́u1�v),�X�e�b�v���ʁi���ҏW�s�j,���t�N�i���ҏW�s�j,���t���i���ҏW�s�j,���t���i���ҏW�s�j\n|;
	
	# �X�e�b�v���[��
	my $count = (split( /,/, $step ))[0];
	for( my $i=0; $i<$count; $i++ ){
		my $n = $i+2;
		my $code = $i+1;
		print &down_step_makecsv( $n, $rh_body->{$code} );
	}
	
	# ���t
	my( $schedule, $dates ) = split(/<>/, $detail );
	foreach( split( /,/, $dates ) ){
		my( $mon, $day, $year  ) = split( /\// );
		my $code = sprintf( "%02d%02d", $mon, $day );
		$code .= sprintf( "%04d", $year ) if( $year > 0 );
		print &down_step_makecsv( "d$_", $rh_body->{"d$code"} );
	}
	# �o�^�����[��(�Ǘ��Ґ�p)
	print &down_step_makecsv( 'ra', $rh_body->{'ra'} );
	# �o�^�����[��
	print &down_step_makecsv( '0', $rh_body->{'0'} );
	# �ύX�����[��
	print &down_step_makecsv( 'r', $rh_body->{'r'} );
	# ���������[��
	print &down_step_makecsv( 'c', $rh_body->{'c'} );
	exit;
}
sub down_step_makecsv
{
	my( $step, $stepmail ) = @_;
	
	my @csv;
	my $year;
	my $mon;
	my $day;
	
	my $step_name;
	$step_name = qq|��$step��| if( $step > 1 );
	$step_name = '�o�^��' if( $step == 0 );
	$step_name = '�o�^��(�Ǘ��Ґ�p)' if( $step eq 'ra' );
	$step_name = '�ύX��' if( $step eq 'r' );
	$step_name = '������' if( $step eq 'c' );
	if( $step =~ /^d(.+)/ ){
		($mon, $day, $year ) = split(/\//, $1 );
		my $pyear =( $year eq '' )? '��': $year;
		$step_name = qq|(���t)$pyear�N$mon��$day��|;
	}
	
	my $step_code;
	$step_code = $step;
	$step_code = 'r1' if( $step == 0 );
	$step_code = 'r0' if( $step eq 'ra' );
	$step_code = 'r2' if( $step eq 'r' );
	$step_code = 'r3' if( $step eq 'c' );
	$step_code = '' if( $step =~ /^d(.+)/ );
	
	my $subject = $stepmail->{'subject'};
	my $body = $stepmail->{'body'};
	
	$subject =~ s/<br>//ig;
	$body =~ s/<br\s*\/?>/\n/ig;
	
	$csv[0] = $step_name;
	$csv[1] = $subject;
	$csv[2] = $body;
	$csv[3] = ($stepmail->{'header'})? 1: '';
	$csv[4] = ($stepmail->{'cancel'})? 1: '';
	$csv[5] = ($stepmail->{'footer'})? 1: '';
	$csv[6] = $step_code;
	$csv[7] = $year;
	$csv[8] = $mon;
	$csv[9] = $day;
	
	for( $i=0; $i<=$#csv; $i++ ){
		$csv[$i] =~ s/\"/\"\"/g;
		$csv[$i] = qq|"$csv[$i]"|;
	}
	my $line = join( ",", @csv );
	return "$line\n";
}

sub upload_step
{

	my $id = $param{'id'} - 0;
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	my $filedata = $param{'stepfile'};
	
	my $filename = &the_filedata( 'stepfile' );
	if ( $filename !~ /\.csv$/ ) {
		&make_plan_page( 'plan', '', "�X�V�G���[<br>CSV�t�@�C�����w�肵�Ă�������");
	}
	
	unless ( open(PLAN, $file) ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>$file���J���܂���");
		exit;
	}
	my $path;
	while( <PLAN> ) {
		chomp;
		my ( $index, $queue, $_step, $_detail ) = ( split(/\t/) )[0, 7, 35, 36];
		if ( $index eq $id ) {
			$step = $_step;
			$detail = $_detail;
			$path = "$myroot$data_dir$queue_dir$queue";
			last;
		}
	}
	close(PLAN);
	unless ( $path ) {
		&make_plan_page( 'plan', '', "�V�X�e���G���[<br>�Y������f�[�^������܂���");
		exit;
	}
	my $rh_body = &get_body( $path );
	
	my %StepDetail;
	# �X�e�b�v���[��
	my $count = (split( /,/, $step ))[0];
	for( my $i=0; $i<$count; $i++ ){
		my $n = $i+2;
		my $code = $i+1;
		$StepDetail{$n} = $code;
	}
	
	# ���t
	my( $schedule, $dates ) = split(/<>/, $detail );
	foreach( split( /,/, $dates ) ){
		my( $mon, $day, $year  ) = split( /\// );
		my $code = sprintf( "%02d%02d", $mon, $day );
		$code .= sprintf( "%04d", $year ) if( $year > 0 );
		$StepDetail{$code} = "d$code";
	}
	# �o�^�����[��(�Ǘ��Ґ�p)
	$StepDetail{'r0'} = 'ra';
	# �o�^�����[��
	$StepDetail{'r1'} = '0';
	# �ύX�����[��
	$StepDetail{'r2'} = 'r';
	# ���������[��
	$StepDetail{'r3'} = 'c';
	
	my @queue;
	my @stepdata = split( /\r?\n|\r/, $filedata );
	my $index;
	for( $index=0; $index <= $#stepdata; $index++) {
		
		$line = $stepdata[$index];
		# �s����i�߂�
		$n++;
		
		while( $line =~ tr/"// % 2 && $index < $#stepdata ){
			$index++;
			$_line = $stepdata[$index];
			$line .= "\n$_line";
		}
		$line =~ s/(?:\x0D\x0A|[\x0D\x0A])?$/,/;
		my @lines = map {/^"(.*)"$/s ? scalar($_ = $1, s/""/"/g, $_) : $_}
                ($line =~ /("[^"]*(?:""[^"]*)*"|[^,]*),/g);
		
		my $target;
		if( $lines[8] > 0 && $lines[9] > 0 ){
			$target = sprintf( "%02d%02d", $lines[8], $lines[9] );
			$target.= sprintf( "%04d", $lines[7] ) if( $lines[7] > 0 );
		}
		$target = $lines[6] if( $lines[6] > 1 );
		$target = 'r0' if( $lines[6] eq 'r0' );
		$target = 'r1' if( $lines[6] eq 'r1' );
		$target = 'r2' if( $lines[6] eq 'r2' );
		$target = 'r3' if( $lines[6] eq 'r3' );
		
		if( defined $StepDetail{$target} ){
			my $code = $StepDetail{$target};
			$rh_body->{$code}->{'subject'} = $lines[1];
			$rh_body->{$code}->{'body'} = $lines[2];
			$rh_body->{$code}->{'header'} = $lines[3];
			$rh_body->{$code}->{'cancel'} = $lines[4];
			$rh_body->{$code}->{'footer'} = $lines[5];
		}
	}
	
	my $tmp = "$myroot$data_dir$queue_dir". 'UP-'. time. '.cgi';
	unless ( open(TMP, ">$tmp") ) {
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�e���|�����t�@�C�����쐬�ł��܂���<br>$myroot$data_dir$queue_dir �f�B���N�g���̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	chmod 0606, $tmp;
	
	foreach( sort keys %StepDetail ){
		my $code = $StepDetail{$_};
		my @csv;
		$csv[0] = $code;
		$csv[1] = &the_text( $rh_body->{$code}->{'subject'});
		$csv[2] = ($rh_body->{$code}->{'header'})? 1 : 0;
		$csv[3] = ($rh_body->{$code}->{'cancel'})? 1 : 0;
		$csv[4] = &the_text( $rh_body->{$code}->{'body'});
		$csv[5] = ($rh_body->{$code}->{'footer'})? 1 : 0;;
		$csv[6] = $rh_body->{$code}->{'ctype'};
		$csv[7] = $rh_body->{$code}->{'filename'};
		my $newline = join( "\t", @csv );
		print TMP "$newline\n";
	}
	close(TMP);
	rename $tmp, $path;
	&make_plan_page( 'plan', 'schedule' );
	exit;
}

sub peculiar
{
	return;
	eval{ require './config.pl'; };
	
	$DEF_sendmail = $sendmail;
	$DEF_image_dir = $image_dir;
}
