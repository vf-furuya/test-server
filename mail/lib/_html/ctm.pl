package Ctm;
#--------------------------------------------
# �y���[��pro
# ��ʃJ�X�^�}�C�Y�֘A�֐��Q
# ver2.2
#--------------------------------------------

# �݊����`�F�b�N
&compatibility();

# ���ڕ\�����ݒ�
@names = (
			{'name' => 'id', 'value' => '�o�^��ID'},
			{'name' => 'co', 'value' => '��Ж�'},
			{'name' => '_co', 'value' => '��Ж��t���K�i'},
			{'name' => 'sei', 'value' => '��'},
			{'name' => '_sei', 'value' => '���t���K�i'},
			{'name' => 'mei', 'value' => '��'},
			{'name' => '_mei', 'value' => '���t���K�i'},
			{'name' => 'name', 'value' => '�����O'},
			{'name' => '_name', 'value' => '�����O�t���K�i'},
			{'name' => 'mail', 'value' => '���[���A�h���X'},
			{'name' => '_mail', 'value' => '���[���A�h���X�m�F'},
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
			{'name' => 'free21', 'value' => '�t���[���ڂQ�P'},
			{'name' => 'free22', 'value' => '�t���[���ڂQ�Q'},
			{'name' => 'free23', 'value' => '�t���[���ڂQ�R'},
			{'name' => 'free24', 'value' => '�t���[���ڂQ�S'},
			{'name' => 'free25', 'value' => '�t���[���ڂQ�T'},
			{'name' => 'free26', 'value' => '�t���[���ڂQ�U'},
			{'name' => 'free27', 'value' => '�t���[���ڂQ�V'},
			{'name' => 'free28', 'value' => '�t���[���ڂQ�W'},
			{'name' => 'free29', 'value' => '�t���[���ڂQ�X'},
			{'name' => 'free30', 'value' => '�t���[���ڂR�O'},
);


sub regulation_dataline
{
	my %hash;
	$hash{'co'} = 15;
	$hash{'_co'} = 16;
	$hash{'sei'} = 61;
	$hash{'_sei'} = 62;
	$hash{'mei'} = 63;
	$hash{'_mei'} = 64;
	$hash{'name'} = 17;
	$hash{'_name'} = 18;
	$hash{'mail'} = 19;
	$hash{'_mail'} = 65;
	$hash{'tel'} = 20;
	$hash{'fax'} = 21;
	$hash{'url'} = 22;
	$hash{'code'} = 23;
	$hash{'address'} = 24;
	$hash{'address1'} = 25;
	$hash{'address2'} = 26;
	$hash{'address3'} = 27;
	$hash{'free1'} = 28;
	$hash{'free2'} = 29;
	$hash{'free3'} = 30;
	$hash{'free4'} = 31;
	$hash{'free5'} = 32;
	$hash{'free6'} = 43;
	$hash{'free7'} = 44;
	$hash{'free8'} = 45;
	$hash{'free9'} = 46;
	$hash{'free10'} = 47;
	$hash{'free11'} = 48;
	$hash{'free12'} = 49;
	$hash{'free13'} = 50;
	$hash{'free14'} = 51;
	$hash{'free15'} = 52;
	$hash{'free16'} = 53;
	$hash{'free17'} = 54;
	$hash{'free18'} = 55;
	$hash{'free19'} = 56;
	$hash{'free20'} = 57;
	$hash{'free21'} = 66;
	$hash{'free22'} = 67;
	$hash{'free23'} = 68;
	$hash{'free24'} = 69;
	$hash{'free25'} = 70;
	$hash{'free26'} = 71;
	$hash{'free27'} = 72;
	$hash{'free28'} = 73;
	$hash{'free29'} = 74;
	$hash{'free30'} = 75;
	
	return %hash;
}

sub regulation_csvline
{
	my %hash;
	$hash{'co'} = 1;
	$hash{'_co'} = 2;
	$hash{'sei'} = 37;
	$hash{'_sei'} = 38;
	$hash{'mei'} = 39;
	$hash{'_mei'} = 40;
	$hash{'name'} = 3;
	$hash{'_name'} = 4;
	$hash{'mail'} = 5;
	$hash{'tel'} = 6;
	$hash{'fax'} = 7;
	$hash{'url'} = 8;
	$hash{'code'} = 9;
	$hash{'address'} = 10;
	$hash{'address1'} = 11;
	$hash{'address2'} = 12;
	$hash{'address3'} = 13;
	$hash{'free1'} = 14;
	$hash{'free2'} = 15;
	$hash{'free3'} = 16;
	$hash{'free4'} = 17;
	$hash{'free5'} = 18;
	$hash{'free6'} = 22;
	$hash{'free7'} = 23;
	$hash{'free8'} = 24;
	$hash{'free9'} = 25;
	$hash{'free10'} = 26;
	$hash{'free11'} = 27;
	$hash{'free12'} = 28;
	$hash{'free13'} = 29;
	$hash{'free14'} = 30;
	$hash{'free15'} = 31;
	$hash{'free16'} = 32;
	$hash{'free17'} = 33;
	$hash{'free18'} = 34;
	$hash{'free19'} = 35;
	$hash{'free20'} = 36;
	$hash{'free21'} = 41;
	$hash{'free22'} = 42;
	$hash{'free23'} = 43;
	$hash{'free24'} = 44;
	$hash{'free25'} = 45;
	$hash{'free26'} = 46;
	$hash{'free27'} = 47;
	$hash{'free28'} = 48;
	$hash{'free29'} = 49;
	$hash{'free30'} = 50;
	
	return %hash;
}

sub regulation_detail
{
	my %hash;
	$hash{'text'} = '�e�L�X�g�t�H�[��';
	$hash{'textarea'} = '�e�L�X�g�G���A';
	$hash{'select'} = '�Z���N�g���j���[';
	$hash{'checkbox'} = '�`�F�b�N�{�b�N�X';
	$hash{'radio'} = '���W�I�{�^��';
	return %hash;
}

sub Form
{
	my ($utf, $r_prop ) = @_;
	my $action = $main'param{'act'};
	
	my $table;
	if( $action eq 'top' ){
		$table = &F_top();
	}elsif( $action eq 'form' ){
		$table = &F_customize( $utf, $r_prop );
	}elsif( $action eq 'renew' ){
		&renew();
		$table = &F_customize( $utf, $r_prop );
	}
	return $table;
}

sub F_top
{
	my $self = $main'indexcgi;
	my $id = $main'param{'id'};
	my $table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$self">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>�{�v�����̓o�^���̉�ʃJ�X�^�}�C�Y���s���܂��B</td>
                                          </tr>
                                          <tr> 
                                            <td>�J�X�^�}�C�Y�����ʃ��j���[�����N���N���b�N���Ă��������B</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>��PC��p���</td>
                                          </tr>
                                          <tr>
                                            <td><table width="450" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td colspan="2" bgcolor="#ABDCE5"><table width="450" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td width="150" bgcolor="#E5FDFF">�G���[���</td>
                                                    <td width="300" bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=err"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=err" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">���͊m�F���</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=conf"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=conf" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">�o�^�������</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=end"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=end" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">�ύX�������</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=renew"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=renew" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">�����������</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=delete"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=delete" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                </table></td>
                                                </tr>
                                              
                                            </table></td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>���g�їp���</td>
                                          </tr>
                                           <tr>
                                            <td><table width="450" border="0" cellspacing="0" cellpadding="0">
                                              <tr>
                                                <td colspan="2" bgcolor="#ABDCE5"><table width="450" border="0" cellspacing="1" cellpadding="5">
                                                  <tr>
                                                    <td width="150" bgcolor="#E5FDFF">�G���[���</td>
                                                    <td width="300" bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=err&m=1"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=err&m=1" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">���͊m�F���</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=conf&m=1"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=conf&m=1" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">�o�^�������</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=end&m=1"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=end&m=1" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">�ύX�������</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=renew&m=1"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=renew&m=1" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                  <tr>
                                                    <td bgcolor="#E5FDFF">�����������</td>
                                                    <td bgcolor="#FFFFFF"><a href="$self?id=$id&md=ctm_regdisp&act=form&type=delete&m=1"><font color="#0000FF">�ҏW����</font></a>�@<a href="$self?id=$id&md=ctm_regprev&type=delete&m=1" target="_blank"><font color="#0000FF">�v���r���[</font></a></td>
                                                  </tr>
                                                </table></td>
                                                </tr>
                                              
                                            </table></td>
                                          </tr>
                                          <tr> 
                                            <td align="center"><input name="id" type="hidden" id="id" value="$id">
                                              <input name="action" type="hidden" id="action"></td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
	return $table;
}


sub F_customize
{
	my( $utf, $r_prop ) = @_;
	my $self = $main'indexcgi;
	my $type = $main'param{'type'};
	my $id = $main'param{'id'};
	my $mobile = $main'param{'m'} -0;
	
	my $m = '&m=1' if( $mobile );
	my $m_message2 = <<"END";
	                            <tr>
                                  <td><font color="#FF0000">���S�Ă̌g�тœ����ۏ؂�����̂ł͂���܂���B</font></td>
                                </tr>
END
	$m_message2 = '' if( !$mobile );
	
	# �\����
	my $link_err  = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=err$m"><font color="#0000FF">�G���[��ʂ�</font></a>|;
	my $link_conf = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=conf$m"><font color="#0000FF">���͊m�F��ʂ�</font></a>|;
	my $link_end  = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=end$m"><font color="#0000FF">�o�^������ʂ�</font></a>|;
	my $link_renew  = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=renew$m"><font color="#0000FF">�ύX������ʂ�</font></a>|;
	my $link_delete = qq|<a href="$self?id=$id&md=ctm_regdisp&act=form&type=delete$m"><font color="#0000FF">����������ʂ�</font></a>|;
	
	my $disp;
	my $default_message;
	if( $type eq 'err' ){
		$disp = '�G���[';
		$link_err = '<strong>�G���[���</strong>';
	}elsif( $type eq 'conf' ){
		$disp = '���͊m�F';
		$link_conf = '<strong>���͊m�F���</strong>';
		$default_message = '<font color="#FF0000">���p����u�o�^�p�t�H�[���v���ڂ̕ύX���s�����ꍇ�A�ύX�������ڏ��𔽉f����ɂ́A��x�f�U�C�������������Ă��������A�ēx�f�U�C���̃J�X�^�}�C�Y�����Ē����K�v������܂��B</font>';
		$tag = <<"END";
<tr><td>
<table>
                                          <tr>
                                            <td align="center" valign="middle" nowrap bgcolor="#FFFFEE"><font color="#FF0000">���ϊ��^�O
                                            </font></td>
                                            <td><select onchange="this.form.convtag.value = this.value;">$main'confirm_reflect_tag</select>&nbsp;<input type="text" style="background-color:#EEEEEE" name="convtag" size="15" onfocus="this.select();">
                                              <br>
                                                �ȈՃ^�O�����p�ł��܂��B<br>
                                                ��̃^�O�W���Q�l�ɁA�\\�[�X���Ƀ^�O���L�q���������B</td>
                                          </tr>
</table>
</td></tr>
END
	}elsif( $type eq 'end' ){
		$disp = '�o�^����';
		$link_end = '<strong>�o�^�������</strong>';
		$tag = <<"END";
<tr><td>
<table>
                                          <tr>
                                            <td align="center" valign="middle" nowrap bgcolor="#FFFFEE"><font color="#FF0000">���ϊ��^�O
                                              </font></td>
                                            <td><select onchange="this.form.convtag.value = this.value;">$main'thanks_reflect_tag</select>&nbsp;<input type="text" style="background-color:#EEEEEE" name="convtag" size="15" onfocus="this.select();"><br>
                                            �ȈՃ^�O�����p�ł��܂��B<br>
                                            ��̃^�O�W���Q�l�ɁA�\\�[�X���Ƀ^�O���L�q���������B<br>
                                            <br><font color="#FF0000">
                                            <strong>���u�o�^��ID�v�Ƃ�</strong><br>
                                            �e�o�^�҂ɑ΂��āA�o�^���Ɏ�����������锼�p�����̒ʂ��ԍ��ł��B</font></td>
                                          </tr>
</table>
</td></tr>
END
	}elsif( $type eq 'renew' ){
		$disp = '�ύX����';
		$link_renew = '<strong>�ύX�������</strong>';
	}elsif( $type eq 'delete' ){
		$disp = '��������';
		$link_delete = '<strong>�����������</strong>';
	}
	
	# �\�[�X���擾
	local $array_source = &find( $id, $type, $utf, $mobile );
	local $source = join( "", @$array_source );
	
	# Jcode.pm��ǂݍ���ŕ����R�[�h�ϊ�(sjis��)
	&lib_inc();
	my $code = $jcodegetcode->($source);
	$jcodeconvert->(\$source, 'sjis', $code );
	
	# <%registtable%>��ϊ�
	my $source_table = &_table( $r_prop, 0, $mobile ) if( $type eq 'conf' );
	$source =~ s/<%registtable%>/$source_table/;
	
	# �^�O��ϊ�
	$source  = &main'deltag( $source );
	my $table = <<"END";
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="20">&nbsp;</td>
                                    <td width="441"> <form name="form1" method="post" action="$self">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                          <tr> 
                                            <td>�{�v�����̓o�^����<strong>$disp���</strong>�̃J�X�^�}�C�Y���s���܂��B</td>
                                          </tr>
                                          <tr> 
                                            <td>HTML�\\�[�X����͂��u<strong>�X�V�𔽉f����</strong>�v���N���b�N���Ă��������B</td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>[ $link_err ]�@[ $link_conf ]�@[ $link_end ]�@[ $link_renew ]�@<br>[ $link_delete ] </td>
                                          </tr>
                                          <tr>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td>�ȉ���<strong>HTML�\\�[�X</strong>����͂��Ă��������B�@�@<a href="$self?id=$id&md=ctm_regprev&type=$type$m" target="_blank"><font color="#0000FF">&gt;&gt;�ۑ��ς݂̉�ʃv���r���[</font></a></td>
                                          </tr>
                                          <tr>
                                            <td><textarea name="source" cols="60" rows="30" wrap="off">$source</textarea></td>
                                          </tr>
$m_message2
                                          $tag
                                          <tr>
                                            <td><input name="renew" type="submit" id="renew" value="�@�X�V�𔽉f����@">
                                              <input name="default" type="submit" id="default" value="�@����������@"></td>
                                          </tr>
                                          <tr> 
                                            <td align="center"><input name="id" type="hidden" id="id" value="$id">
                                              <input name="md" type="hidden" id="md" value="ctm_regdisp">
                                              <input name="m" type="hidden" id="type" value="$mobile">
                                              <input name="act" type="hidden" id="act" value="renew">
                                              <input name="type" type="hidden" id="type" value="$type"></td>
                                          </tr>
                                          <tr>
                                            <td bgcolor="#FFFFEE">�P�D&lt;%***%&gt;�ƋL�q����Ă���ӏ��͕ҏW�E�폜���Ȃ��ł��������B<br>
                                              �Q�D&lt;form&gt;   �` &lt;/form&gt;����&lt;form&gt;�͓���Ȃ��ł��������B<br>
                                              �R�DHTML�\\�[�X�Ő�������鍀�ڈȊO�̃f�[�^�͂����p���������܂���B<br>
                                              �S�D�z�[���y�[�W�r���_�[��ɏ�L�\\�[�X���R�s�[���ĕҏW����ꍇ�A�z�[���y�[�W�r���_�[�̎����C���@�\\���~���Ă��������B</td>
                                          </tr>
                                           <tr>
                                            <td><strong>$default_message</strong> &nbsp;</td>
                                          </tr>
                                        </table>
                                      </form></td>
                                    <td width="20">&nbsp; </td>
                                  </tr>
                                </table>
END
	return $table;
}

sub _table
{
	my( $prop, $prev, $mobile ) = @_;
	
	my $table;
	# ���ڔԍ� �t�H�[���ݒ�
	%rFORM = &regulation_dataline();
	
	# ���ڔԍ� �o�^�ҏ��CSV�ԍ�
	%rCSV = &regulation_csvline();
	
	# �\����On
	my @SortOn;
	# �\����Off
	my @SortOff;
	
	for ( my $i=1; $i<@names; $i++ ) {
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		
		my $confdata = ( $prev )? $main'temdata[$rCSV{$r_name}]: qq|<%$r_name%>&nbsp;|;
		
		if ( ( split(/<>/, $prop->[$r_num]) )[0] ) {
			
			my $fname = ( (split(/<>/,$prop->[$r_num]))[1] )? (split(/<>/,$prop->[$r_num]))[1]: $r_val;
			my $tr = qq|<tr><td width="120">$fname</td><td width="280">$confdata</td></tr>\n| if( $r_name ne '_mail');
			my $tr_m = qq|$fname�F<br>\n$confdata<br><br>\n| if( $r_name ne '_mail');
			my $line = ($mobile )? $tr_m: $tr;
			my $sort = ( split(/<>/, $prop->[$r_num]) )[3];
			if( $sort > 0 ){
				$SortOn[$sort] = $line;
			}else{
				push @SortOff, $line;
			}
		}
	}
	
	foreach( @SortOn ){
		$table .= $_;
	}
	foreach( @SortOff ){
		$table .= $_;
	}
	
	return $table;
}

sub Prev
{
	my( $utf, $prop ) = @_;
	
	my $type  = $main'param{'type'};
	local $id = $main'param{'id'};
	my $mobile = $main'param{'m'} -0;
	$utf = 0 if( $mobile );
	# �\�[�X���擾
	local $array_source = &find( $id, $type, $utf, $mobile );
	
	# <%registtable%>�������擾
	local $source_table = &_table( $prop, 1, $mobile ) if( $type eq 'conf' );
	
	# Jcode.pm��Ǎ�
	&lib_inc();
	
	# ���f�[�^��}��
	if( $type eq 'err' ){
		$subject = '���̓G���[';
		$message = '<em><font color="#336600">&lt;�����ɃG���[���e���L�ڂ���܂��B&gt;</font></em>';
	}
	
	# ���ڔԍ� �o�^�ҏ��CSV�ԍ�
	%rCSV = &regulation_csvline();
	
	for ( my $i=0; $i<@names; $i++ ) {
		next if( $type ne 'end' && $i == 0 );
		my $r_name = $names[$i]->{'name'};
		my $r_val  = $names[$i]->{'value'};
		my $r_num  = $rFORM{$r_name};
		
		local $confdata = $main'temdata[$rCSV{$r_name}];
		if( $utf ){
			$jcodeconvert->(\$confdata, 'utf8');
		}
		$$r_name = $confdata;
	}
	
	my $_url = '';
	if( $prop->[39] ){
		if( $type eq 'end' ){
			$_url = qq|<a href="http://$prop->[12]"><font color="#0000FF">�߂�</font></a>|;
		}elsif( $type eq 'renew' ){
			$_url = qq|<a href="http://$prop->[13]"><font color="#0000FF">�߂�</font></a>|;
		}elsif( $type eq 'delete' ){
			$_url = qq|<a href="http://$prop->[14]"><font color="#0000FF">�߂�</font></a>|;
		}
	}
	$url = $_url if( $type ne 'conf' );
	
	# �����R�[�h�𓝈�
	if( $utf ){
		$jcodeconvert->(\$source_table, 'utf8');
		$jcodeconvert->(\$subject, 'utf8');
		$jcodeconvert->(\$message, 'utf8');
		$jcodeconvert->(\$url, 'utf8');
	}
	
	my @source;
	foreach( @$array_source ){
		local $line = $_;
		if( $utf ){
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
	
	print "Content-type: text/html", "\n\n";
	foreach( @source ) {
		local $line = $_;
		$line =~ s/(<\s*meta.*http-equiv.*charset.*>)/$meta/i;
		$_ = $line;
		while( ( $parameter ) = ( /<%([^<>\%]+)%>/oi ) ) {
			s//$$parameter/;
		}
        print $_;
    }
	exit;
}

sub renew
{
	my $self = $main'self;
	my $type = $main'param{'type'};
	my $id   = $main'param{'id'};
	my $mobile = $main'param{'m'}  -0;
	
	my( $default_file, $ctm_file, $target_file ) = &get_path( $id, $type, $mobile );
	
	if( defined $main'param{'default'} ){
		unlink $ctm_file;
	}
	if( defined $main'param{'renew'} ){
		$main'param{'source'} =~ s/(\s\s)$//;
		my $source = &main'delspace( $main'param{'source'} );
		$source = &main'deltag( $source );
		$source = &main'the_text( $source );
		$source =~ s/<br>/\n/gi;
		$source =~ s/&lt;/</gi;
		$source =~ s/&gt;/>/gi;
		$source =~ s/&quot;/\"/gi;
		$source =~ s/&amp;/\&/gi;
		
		my $ctm_dir = &compatibility();
		my $tmp = $ctm_dir. 'CTM-'. $$. time. '.cgi';
		open( CTM, ">$tmp");
		print CTM $source;
		close(CTM);
		chmod 0606, $tmp;
		rename $tmp, $ctm_file;
	}
	
}
sub clean
{
	my( $id ) = @_;
	my @type = ( 'err','conf','end','renew','delete' );
	foreach my $type ( @type ){
		my( $default_file, $ctm_file, $target_file ) = &get_path( $id, $type );
		my( $default_file_m, $ctm_file_m, $target_file_m ) = &get_path( $id, $type, 1 );
		if( -f $ctm_file ){
			unlink $ctm_file;
		}
		if( -f $ctm_file_m ){
			unlink $ctm_file_m;
		}
	}
}

sub find
{
	my( $id, $type, $utf, $mobile ) = @_;
	
	my( $default_file, $ctm_file, $target_file ) = &get_path( $id, $type, $mobile );
	my @source;
	open( CTM, $target_file );
	while(<CTM>){
		push @source, $_;
	}
	close(CTM);
	
	#my $source = join("",@source);
	return [@source];

}

sub get_path
{
	my( $id, $type, $mobile ) = @_;
	my $ctm_dir = &compatibility();
	
	my $default_dir = $main'myroot . $main'template;
	my $default_file;
	my $ctm_file;
	if( $mobile ){
		$default_file = $default_dir . $main'err_m     if( $type eq 'err' );
		$default_file = $default_dir . 'confirm_m.pl'  if( $type eq 'conf' );
		$default_file = $default_dir . 'confirm1_m.pl' if( $type eq 'end' );
		$default_file = $default_dir . 'confirm2_m.pl' if( $type eq 'renew' );
		$default_file = $default_dir . 'confirm3_m.pl' if( $type eq 'delete' );
		$ctm_file = $ctm_dir . $id . '_' . $main'err_m     if( $type eq 'err' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm_m.pl'  if( $type eq 'conf' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm1_m.pl' if( $type eq 'end' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm2_m.pl' if( $type eq 'renew' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm3_m.pl' if( $type eq 'delete' );
	}else{
		$default_file = $default_dir . $main'err     if( $type eq 'err' );
		$default_file = $default_dir . 'confirm.pl'  if( $type eq 'conf' );
		$default_file = $default_dir . 'confirm1.pl' if( $type eq 'end' );
		$default_file = $default_dir . 'confirm2.pl' if( $type eq 'renew' );
		$default_file = $default_dir . 'confirm3.pl' if( $type eq 'delete' );
		$ctm_file = $ctm_dir . $id . '_' . $main'err     if( $type eq 'err' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm.pl'  if( $type eq 'conf' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm1.pl' if( $type eq 'end' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm2.pl' if( $type eq 'renew' );
		$ctm_file = $ctm_dir . $id . '_' . 'confirm3.pl' if( $type eq 'delete' );
	}
	my $target_file;
	$target_file = ( -f $ctm_file )? $ctm_file: $default_file;
	
	return $default_file, $ctm_file, $target_file;
}


sub compatibility
{
	my $dir = $main'myroot . $main'data_dir;
	my $path_dir = $dir . 'mkform/';
	
	unless( -d $path_dir ){
		my $flag = mkdir $path_dir, 0707;
		if( !$flag ){
			&main'error("<strong>�f�B���N�g�����쐬�ł��܂���B","</strong><br><br><br>$dir<br><br>�̃p�[�~�b�V���������������ݒ肳��Ă��邩���m�F���������B");
		}
		chmod 0707, $path_dir;
	}
	
	if( !( -x $path_dir) || !( -w $path_dir) ){
		&main'error("�p�[�~�b�V�����G���[","<br><br><br>$path_dir<br><br>�̃p�[�~�b�V������[707]�ɐ������ݒ肳��Ă��邩���m�F���������B");
	}
	
	return $path_dir;
}

# �f�o�b�O�p
sub debug {

	print "Content-type: text/html\n\n";
	print "<html><head><title>CGI Error</title></head>\n";
	print "<body>\n";
	print "<br>$_[0]<br>";
	print "</body></html>\n";
	exit;
}

#-----------------------#
# ���{��ϊ��֐��̎w��  #
#-----------------------#
sub jcode_rap {
	eval 'use Jcode;';
	if( $@ ){
		return \&jcode'convert, sub{ $str = shift; my $code = &jcode'getcode($str); return $code;};
	}else{
		return \&Jcode'convert, sub{ $str = shift; my($code, $len )= &Jcode'getcode($str); return $code;};
	}
}

sub lib_inc {
	unshift( @main'INC, "../lib/Jcode" );
	($jcodeconvert, $jcodegetcode ) = &jcode_rap();
}

sub jcode_check
{
	unshift( @main'INC, "../lib/Jcode" );
	eval 'use Jcode;';
	if( $@ ){
		return 0;
	}else{
		return 1;
	}
}

1;
