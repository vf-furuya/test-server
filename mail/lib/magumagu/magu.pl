package Magu;
#---------------------------------------
# �y���[��pro
#
# �܂��܂��o�^�@�\�֘A�֐��Q magu.pl
# v 2.01
#---------------------------------------
my $Dir     = $main::myroot . $main::data_dir;
my $logfile = $Dir . 'magu.cgi';
my $def_url = 'http://regist.mag2.com/reader/Magrdadd';

sub Magumagu
{
	my $email   = shift;
	my $p_magid = 'magid';
	my $p_email = 'rdemail';
	my $rp      = &Check();
	
	# �o�^�@�\���L���łȂ��ꍇ�A�o�^�������I��
	return 0 unless( $rp->{'ON'} );
	
	my $url   = $rp->{'URL'};
	my $magid = $rp->{'MAGID'};
	
	my $href = qq|$url?$p_email=$email&$p_magid=$magid|;
	print "Location: $href", "\n\n";
	exit;
}

sub Keep
{
	
	my $id      = $main::param{'id'} - 0;
	my $now     = time;
	my $tmpfile = $Dir . $$ . $now . '.tmp';
	
	my $on      = $main::param{'on'} -0;
	my $url     = $main::param{'url'};
	my $magid   = $main::param{'magid'};
	my $newline = qq|$id\t$on\t$url\t$magid\n|;
	
	if( $on > 0 && $magid <= 0 ){
		&main::make_plan_page( 'plan', 'g', '�y�܂��܂��z�̃}�K�W��ID����͂��Ă��������B');
	}
	
	my $fullpath = &main::lock();
	unless( open( TMP, ">$tmpfile" ) ){
		&main::make_plan_page( 'plan', 'g', "�f�[�^�t�@�C�����쐬�ł��܂���B<br>[ $Dir ]�̃p�[�~�b�V���������m�F���������B " );
		&main::rename_unlock( $fullpath );
		exit;
	}
	open( MAGU, $logfile );

	my $flag = 0;
	while(<MAGU>){
		chomp;
		my @str = split(/\t/);
		if( $str[0] eq $id ){
			print TMP $newline;
			$flag = 1;
			next;
		}
		print TMP "$_\n";
	}
	if( !$flag ){
		print TMP $newline;
	}
	close(MAGU);
	close(TMP);
	chmod 0666, $logfile;
	
	unless( rename $tmpfile, $logfile ){
		unlink $tmpfile;
		&main::make_plan_page( 'plan', 'g', "�f�[�^�t�@�C�����쐬�ł��܂���B<br>[ $Dir ]�̃p�[�~�b�V���������m�F���������B ");
		&main::rename_unlock( $fullpath );
		exit;
	}
	&main::rename_unlock( $fullpath );
	
	&main::make_plan_page('plan', 'magu');
	exit;
}

sub delete{
	
	my $id = shift;
	$id         = $id - 0;
	my $now     = time;
	my $tmpfile = $Dir . $$ . $now . '.tmp';
	
	unless( open( TMP, ">$tmpfile" ) ){
		&main::make_plan_page( 'plan', 'g', "�f�[�^�t�@�C�����쐬�ł��܂���B<br>[ $Dir ]�̃p�[�~�b�V���������m�F���������B " );
		&main::rename_unlock( $fullpath );
		exit;
	}
	open( MAGU, $logfile );

	my $flag = 0;
	while(<MAGU>){
		chomp;
		my @str = split(/\t/);
		if( $str[0] eq $id ){
			next;
		}
		print TMP "$_\n";
	}
	close(MAGU);
	close(TMP);
	
	rename $tmpfile, $logfile;
	return;
}

sub Check
{
	my $id = $main::param{'id'} - 0;
	my %Param;
	open( MAGU, $logfile );
	while(<MAGU>){
		chomp;
		my @str = split(/\t/);
		if( $str[0] eq $id ){
			$Param{'id'}    = $id;
			$Param{'ON'}    = $str[1];
			$Param{'URL'}   = $str[2];
			$Param{'MAGID'} = $str[3];
		}
	}
	close(MAGU);
	$Param{'URL'} = $def_url if( $Param{'URL'} eq '' );
	return \%Param;
}

sub Form
{
	my $id = $main::param{'id'};
	my $rp = &Check( $id );
	my $on = ( $rp->{'ON'} )? ' checked': '';
	my $form  = <<"END";
                                        <form name="form1" method="post" action="$main::indexcgi">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                          <tr>
                                            <td width="20">&nbsp;</td>
                                            <td width="502"><table width="100%" border="0" cellspacing="1" cellpadding="3">
                                                <tr>
                                                  <td><strong>�u�܂��܂��o�^�@�\\�v</strong>��ݒ�ł��܂��B<br>
                                                    <br>
                                                  �u�܂��܂��o�^�@�\\�v�Ƃ͊y���[���̓o�^�t�H�[�����g���ă��[���}�K�W���u�܂��܂��v<br>
                                                  �֎����o�^����@�\\�ł��B<br></td>
                                                </tr>
                                                <tr>
                                                  <td>���͌�A�u�X�V�𔽉f�v�{�^�����N���b�N���Ă������� </td>
                                                </tr>
                                                <tr>
                                                  <td>&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td><table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                      <tr>
                                                        <td></td>
                                                      </tr>
                                                      <tr>
                                                        <td bgcolor="#ABDCE5"><table width="100%" border="0" cellpadding="5" cellspacing="1">
                                                            <tr>
                                                              <td width="100" bgcolor="#E5FDFF">��{�ݒ�</td>
                                                              <td bgcolor="#FFFFFF"><input name="on" type="checkbox" id="on" value="1"$on>
                                                              ���̃v�����ł́u�܂��܂��o�^�@�\\�v��L���ɂ���<br>
                                                              <font color="#666666">���Ǘ���ʂ���̓o�^�ɂ͓K������܂���B</font></td>
                                                            </tr>
                                                            <tr>
                                                              <td nowrap bgcolor="#E5FDFF">�܂��܂��o�^�pURL </td>
                                                              <td nowrap bgcolor="#FFFFFF"><input name="url" type="text" size="55" value="$rp->{'URL'}">
                                                              <br>
                                                              �o�^�p�v���O����URL��<strong> http </strong>������͂��������B</td>
                                                            </tr>
                                                            <tr>
                                                              <td bgcolor="#E5FDFF">�܂��܂��}�K�W��ID </td>
                                                              <td bgcolor="#FFFFFF"><input name="magid" type="text" size="20" value="$rp->{'MAGID'}">
                                                              <br>
                                                              �o�^����y�܂��܂��z�̃}�K�W��ID����͂��������B</td>
                                                            </tr>
                                                            <tr>
                                                              <td colspan="2" bgcolor="#FFFFFF">
                                                                <table width="100%" border="0" cellpadding="3" cellspacing="1">
                                                                  <tr>
                                                                    <td><font color="#FF0000">
                                                                      ���o�^�t�H�[���ɂ���
                                                                      <br><br>
                                                                      ���̋@�\\��L�����u�ڍׁv���uHTML�T���v���\\�[�X��\\���v���o�^�t�H�[���𐶐�����ƃ|�b�v�A�b�v�͒ʏ�T�C�Y�̃E�B���h�E�ł����p���������܂��B<br><br>
                                                                      ���o�^������ʂɂ���<br>
                                                                      <br>
                                                                      ���̋@�\\��L���ɂ���ƁA�u�o�^�ݒ�v�ł̊����y�[�W�ݒ�Ɋւ�炸�o�^������ʂ́y�܂��܂��z�̂��̂ɂȂ�܂��B<br>
                                                                      <br>
                                                                      ��������<br>
                                                                      <br>
                                                                      �y�܂��܂��z�o�^�ɕK�v�ȏ��ɕύX���������ꍇ�A���̓o�^�@�\\�͐���ɓ��삵�Ȃ��\\��������܂��B</font></td>
                                                                  </tr>
                                                                </table></td>
                                                            </tr>
                                                        </table></td>
                                                      </tr>
                                                    </table></td>
                                                </tr>
                                                <tr align="center">
                                                  <td><input name="id" type="hidden" id="id" value="$id">
                                                    <input name="md" type="hidden" id="md" value="k_magu">
                                                    <input type="submit" name="Submit" value="�@�X�V�𔽉f�@"></td>
                                                </tr>
                                              </table></td>
                                            <td width="21">&nbsp;</td>
                                          </tr>
                                        </table>
                                      </form>
END
	return $form;
}

1;
