#---------------------------------------
# �y���[��pro
#
# HTML�`�����[���p�֘A�֐��Q1 page.pl
# v 2.4
#---------------------------------------
sub form_mailbody_top {
	my( $h, $c, $f, $_text, $_html, $num, $btitle, $body, $n, $id, $config ) = @_;
	
	# �o�^���ʐݒ�
	if( $n eq '0' ){
		$sub_link_r = qq|<a href="$main'indexcgi?md=ml&n=ra&id=$id"><font color="#0000FF">&gt;&gt;�y�Ǘ��Ғʒm��p�z�{���ݒ��</font></a><br>&nbsp;|;
	}
	if( $n eq 'ra' ){
		$sub_link_r = qq|<a href="$main'indexcgi?md=ml&n=0&id=$id"><font color="#0000FF">&gt;&gt;�ʏ�́y�o�^���z�{���ݒ��</font></a><br>&nbsp;|;
		my $checked0 = ( $config )? '': ' checked="checked"';
		my $checked1 = ( $config )? ' checked="checked"': '';
		$sub_radio = qq|<tr><td bgcolor="#FFFFCC">���p</td><td><input type="radio" name="ra_conf" value="1"$checked1>����<input type="radio" name="ra_conf" value="0"$checked0>���Ȃ�</td></tr><tr><td colspan="2">&nbsp;</td></tr>|;
		$sub_message = <<"END";
<br><table  width="450" border="0" cellspacing="0" cellpadding="10"> 
  <tr> 
    <td width="450" bgcolor="#FFFFEE">�y�Ǘ��Ғʒm��p�z�{����L���Ƃ����ꍇ�A��L�{�����Ǘ��҂֑��M����܂��B�܂��A���̃��[���́y���M�҃��[���A�h���X�z�́u�o�^�҂̃��[���A�h���X�v�ƂȂ�A��ʓI�ȃ��[���\\�t�g���ł́u�ԐM���[���A�h���X�v�Ƃ��ė��p���邱�Ƃ��ł��܂��B
    </td>
  </tr>
</table>
END
	}
	
	my $main_table = <<"END";
                                 <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="499"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="523"> <form action="$indexcgi" method="post" enctype="multipart/form-data" name="form1">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                                <tr> 
                                                  <td colspan="2"><strong>�{��[ $num ]</strong>��ҏW���܂�</td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">���͌�A�u<strong>�X�V�𔽉f</strong>�v�{�^�����N���b�N���Ă��������B<br><br>
                                                    �܂��A<font color="#FF0000">HTML�`���Ń��[����z�M������</font>�ꍇ�́A�u<strong>HTML�`���̐ݒ�</strong>�v��<br>
                                                    �s������A�u<strong>HTML�`��������Ƃ���</strong>�v�Ƀ`�F�b�N���Ă��������B</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">$sub_link_r&nbsp;</td>
                                                </tr>
  $sub_radio
                                                <tr> 
                                                  <td width="76" bgcolor="#FFFFCC">�薼</td>
                                                  <td width="439"><input name="btitle" type="text" id="btitle" value="$btitle" size="50"></td>
                                                </tr>
                                                <tr> 
                                                  <td bgcolor="#FFFFCC">�w�b�_�[</td>
                                                  <td><input name="header" type="checkbox" id="header" value="checkbox" $h>
                                                    �}������</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2" align="center">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td valign="top" bgcolor="#FFFFCC">�{��</td>
                                                  <td bgcolor="#FFFFEC"><font color="#FF0033">���ȈՃ^�O</font>
                                                    <select onchange="this.form.convtag.value = this.value;">$mail_reflect_tag</select>&nbsp;<input type="text" style="background-color:#EEEEEE" name="convtag" size="15" onfocus="this.select();">
                                                    <br>
                                                    ��̃^�O�W���Q�l�ɁA�����E�{�����Ƀ^�O��ł�����ł��������B</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2"><input name="content-type" type="radio" value="0" $_text>
                                                    �e�L�X�g�`��������Ƃ���</td>
                                                  </tr>
                                                <tr> 
                                                  <td colspan="2"><textarea name="body" cols="65" rows="20" id="body">$body</textarea></td>
                                                  </tr>
                                                <tr>
                                                  <td colspan="2">&nbsp;</td>
                                                  </tr>
                                                <tr>
                                                  <td colspan="2"><input name="content-type" type="radio" value="1" $_html>
                                                    HTML�`��������Ƃ���</td>
                                                  </tr>
                                                <tr>
                                                  <td colspan="2"><br>�@
                                                    �� <a href="$indexcgi?md=mb_html&id=$id&n=$n"><font color="#0000FF">HTML�`���̐ݒ�͂�����</font></a><br>
                                                    <br>�@
                                                    <font color="#FF0000">HTML�`���̂�����Ƃ����ꍇ�A�u�w�b�_�v�u�����ē��v�u�t�b�^�v�̐ݒ��<br>�@
                                                    ��������܂��B<br>
                                                    �@</font></td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td bgcolor="#FFFFCC">�����ē�</td>
                                                  <td><input name="cancel" type="checkbox" id="cancel" value="checkbox" $c>
                                                    �}������</td>
                                                </tr>
                                                <tr> 
                                                  <td bgcolor="#FFFFCC">�t�b�^�[</td>
                                                  <td><input name="footer" type="checkbox" id="footer" value="checkbox" $f>
                                                    �}������</td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2" align="center"> 
                                                    <input name="id" type="hidden" id="id" value="$id"> 
                                                    <input name="n" type="hidden" id="n" value="$n"> 
                                                    <input name="md" type="hidden" id="md" value="body"> 
                                                    <input type="submit" value="�@�X�V�𔽉f�@"></td>
                                                </tr>
                                              </table>
$sub_message
                                            </form></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table>
END
	return $main_table;
}

sub form_mailbody_html {
	my( $h, $c, $f, $_text, $_html, $num, $btitle, $body, $n, $id, $filename ) = @_;
	my $prev = ( $filename ne '' )? qq|<a href="$indexcgi?md=htmlprev&id=$id&n=$n" target="_blank"><font color="#0000FF">�ݒ�ς�HTML�t�@�C���̃v���r���[( $filename )</font></a>|: 'HTML�t�@�C���͐ݒ肳��Ă��܂���B';
	
	my $main_table = <<"END";
                               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="499"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="523"> <form action="index.cgi" method="post" enctype="multipart/form-data" name="form1">
                                              <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                                <tr> 
                                                  <td colspan="2"><strong>�{��[ $num ] HTML�`���̐ݒ�</strong> </td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">�z�M������HTML�t�@�C�����Q�ƃ{�^������I�����A<strong>����</strong>�{�^�����N���b�N���Ă��������B</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">�܂��A���̖{����z�M���邽�߂ɂ́A<a href="$indexcgi?md=ml&id=$id&n=$n"><font color="#0000FF">�{���̕ҏW�g�b�v</font></a>��ʂŁu<strong>HTML�`��������Ƃ���</strong>�v�Ƀ`�F�b�N����K�v������܂��B</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2"></td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td width="100" bgcolor="#FFFFCC">HTML�t�@�C��</td>
                                                  <td width="400"><input name="html" type="file" id="html" size="50">
                                                    <br>
                                                    $prev</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2"><br><font color="#FF0000">�E</font><font color="#FF0000">�z�M����HTML�`���̖{���́A��p��HTML�t�@�C�������p�ӂ��������B<br>
                                                    �E�摜�t�@�C����\\��t���Ă���ꍇ�̓��[�J��PC��ŕ\\���m�F���s���Ă��������B<br>
                                                    �E�e�L�X�g�`���Ɠ��l�Ɂy�ȈՃ^�O�z�����p�\\�ł��B<br>
                                                    �E���̖{���Ŏg�p���Ă��铯���̃t�@�C���̓A�b�v���[�h�ł��܂���B<br>
                                                    �E���{��t�@�C�����͋����I�ɔ��p�֕ϊ�����܂��B<br>
                                                    �EHTML�t�@�C���̕����R�[�g���w�肷��ۂ́A'iso-2022-jp'�ł��w�肭�������B<br>
                                                    �@&lt;meta http-equiv="Content-Type" content="text/html; charset=iso-2022-jp"&gt;</font>
                                                    </td>
                                                  </tr>
                                                <tr>
                                                  <td colspan="2"></td>
                                                  </tr>
                                                <tr> 
                                                  <td colspan="2"> 
                                                    <input name="id" type="hidden" id="id" value="$id"> 
                                                    <input name="n" type="hidden" id="n" value="$n"> 
                                                    <input name="md" type="hidden" id="md" value="html"> 
                                                    �@�@<input type="submit" value="�@����@"><input name="del" type="submit" value="�@�ݒ���폜����@"></td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2" align="center">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2">�� �摜�t�@�C���̃A�b�v���[�h</td>
                                                </tr>
                                                <tr>
                                                  <td colspan="2"><br>
                                                    �摜�t�@�C���͂����g�ŗp�ӂ��AFTP�\\�t�g���g���ĔC�ӂ̃T�[�o�[�ɃA�b�v���[�h<br>
                                                    ���Ă��������B<br>
                                                    �܂��A�摜�t�@�C����URL�ihttp://�`�j�Ńp�X�w�肵�Ă��������B<br>
                                                    �������A�����^���T�[�o�[�̒��ɂ͊O������摜�t�@�C���̒������N�𐧌����Ă���<br>
                                                    �ꍇ������܂��B<br>
                                                    ���̏ꍇ�͉摜�t�@�C����\\��t���Ă��\\������܂���̂ŁA�Y����HTML�t�@�C����<br>
                                                    ���[�J��PC��Ő���ɕ\\������邩���m�F���������B<br>
                                                    <br>
                                                    ���̊Ǘ���ʂŉ摜�t�@�C�����Ǘ��������ꍇ�͈ȉ��̃����N���摜�t�@�C����<br>
                                                    �A�b�v���[�h���Ă��������B<br>
                                                    <br>�@
                                                    �� <a href="javascript: void(0);" onClick="window.open('$indexcgi?md=imgupload', 'imgup', 'width=600,height=500,menubar=no,scrollbars=yes');"><font color="#0000FF">�摜�t�@�C���Ǘ���</font></a><br></td>
                                                </tr>
                                              </table>
                                            </form></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table>
END
	return $main_table;
}

sub htmlprev {
	
	my $id = &delspace( $param{'id'} -0 );
	my $n = &delspace( $param{'n'} );
    $n -= 0 if ( $n ne 'r' && $n ne 'c' && $n !~ /^d(\d+)/ && $n ne 'ra' );
	
	#--------------------------#
	# �����̃v�����f�[�^���擾 #
	#--------------------------#
	my $file = "$myroot$data_dir$log_dir$plan_txt";
	unless ( open(PLAN, "$file" ) ) {
		&rename_unlock( $lockfull );
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$file�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	my($queuedir, $queue );
	while( <PLAN> ) {
		my ( $index, $file ) = ( split(/\t/) )[0, 7];
		if ( $index eq $id ) {
			$queuedir = $myroot . $data_dir . $queue_dir;
			$queue    = $queuedir . $file;
			last;
		}
	}
	close(PLAN);
	&make_plan_page( 'plan', '', '�G���[<br>�Y������v����������܂���') if (!$queue);
	my $flag = 0;
	my $filename;
	unless( open(BODY, $queue ) ){
		&make_plan_page( 'plan', '', "<font color=\"#CC0000\">�V�X�e���G���[</font><br><br>�t�@�C�����J���܂���<br>$queue�̃p�[�~�b�V�������m�F���Ă�������");
		exit;
	}
	while( <BODY> ) {
		chomp;
		my @_lines = split(/\t/);
		if ( $_lines[0] eq $n ) {
			$flag = 1;
			$filename = $_lines[7];
		}
	}
	close(BODY);
	my $path = $queuedir . $filename;
	my $message;
	if( $flag && -e $path ){
		open( HTML, $path );
		while(<HTML>){
			$message .= $_;
		}
		close(HTML);
	}else{
		&error('�G���[', '�Y������HTML�t�@�C��������܂���B');
	}
	$CONTENT_TYPE = 'text/html';
	# �]��
	$message = &Click'prev1( $id, $message ) if( $n =~ /^\d+$/ );
	$message = &include( \@temdata, $message, 1, 1 );
	# �]���ϊ�(�v���r���[�p)
	$message = &Click'prev2( $message ) if( $n =~ /^\d+$/ );
	print "Content-type: text/html", "\n\n";
	print $message;
	exit;
	
}

sub scheduleOption
{
	my( $step, $schedule, $ref, $sended, $target, $registTime,$baseTime ) = @_;
	
	$registTime = ( $registTime > 0 )? $registTime: time;
	#my $time = $registTime;
	my $option;
	my $script_array;
	my $next_step = ($ref && $sended > 1)? $sended+1: 2;
	$next_step = $target if( $target ne '' );
	#foreach( split(/<>/, $baseTime) ){
	#	my( $n, $time ) = split(/\//);
	#	$base{$n} = $time;
	#}
	# �X�e�b�v���[���������擾
	my @step = split( /,/, (split(/<>/,$schedule))[0] );
	
	my $base = &getBaseTime($registTime,$schedule,$baseTime, $sended);
	
	my $count = (split(/,/, $step ))[0];
	for( $i=0; $i<$count; $i++ ){
		my $n = $i+2;
		my( $inter, $config ) = split( /\//,$step[$i] );
		next if( $sended > 0 && $sended >= $n );
		
		#my $time = ($sended < $n)? ( $inter * 60*60*24 ) + $base->{$n}:  ( $inter * 60*60*24 ) + time;
		my $time = ( $inter * 60*60*24 ) + $base->{$n};
		my $date = &make_date3( $time );
		my $next = ( $config )? qq|��$n�� �i�J�n�����w�肵�Ă��������j|: qq|��$n�� �i$date �z�M�j$stop|;
		$next = qq|��$n�� �i����z�M��j| if( $ref &&  $next_step == $n && $target ne 'end' );
		my $selected = ' selected="selected"' if( $target == $n );
		
		if( $ref ){
			$script_array .= ( $config && $next_step ne $n && $target ne $n )? qq|chk[$n] = 1;|: qq|chk[$n] = 0;|;
		}else{
			$script_array .= ( $config )? qq|chk[$n] = 1;|: qq|chk[$n] = 0;|;
		}
		$option .= qq|<option value="$n"$selected>$next</option>\n|;
	}
	# �z�M�I��
	if( $count > 0 ){
		my $n = $count+1;
		my $selected = ' selected="selected"' if( $target eq 'end' );
		my $end = 'end' if( $sended < $n );
		$option .= qq|<option value="$end"$selected>�z�M�I��</option>|;
	}else{
		$option .= qq|<option value="">�w��Ȃ�</option>|;
	}
	return $option, $script_array;
}

sub ToYearOption
{
	my( $target ) = @_;
	
	my $t = time;
	local($sec, $min, $hour, $day, $mon, $year, $wday) = gmtime($t+(60*60*9));
	$year += 1900;
	my $option;
	$option = qq|<option value="">----</option>\n| if( $target eq '' );
	$option .= qq|<option value="0">���N</option>\n|;
	for( my $i=0; $i<=1; $i++ ){
		$year += $i;
		my $selected = ' selected="selected"' if( $target == $year );
		$option .= qq|<option value="$year"$selected>$year</option>\n|;
	}
	return $option;
}
1;
