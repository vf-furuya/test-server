# �ȈՃ^�O�p�T���v���f�[�^�𒲐�
sub make_mailtag_tmp
{
	
	@base = (
	'�o�^��ID',             # �o�^��ID
	'��Ж�',               # ��Ж�
	'��Ж��t���K�i',       # ��Ж��t���K�i
	'�����O',               # �����O
	'�����O�t���K�i',       # �����O�t���K�i
	'���[���A�h���X',  # ���[���A�h���X
	'�d�b�ԍ�',          # �d�b�ԍ�
	'FAX�ԍ�',          # FAX�ԍ�
	'URL',# URL
	'�X�֔ԍ�',             # �X�֔ԍ�
	'�s���{��',             # �s���{��
	'�Z���P',               # �Z���P
	'�Z���Q',               # �Z���Q
	'�Z���R',               # �Z���R
	'�t���[���ڂP',         # �t���[���ڂP
	'�t���[���ڂQ',         # �t���[���ڂQ
	'�t���[���ڂR',         # �t���[���ڂR
	'�t���[���ڂS',         # �t���[���ڂS
	'�t���[���ڂT',         # �t���[���ڂT
	'�t���[���ڂU',         # �t���[���ڂU
	'�t���[���ڂV',         # �t���[���ڂV
	'�t���[���ڂW',         # �t���[���ڂW
	'�t���[���ڂX',         # �t���[���ڂX
	'�t���[���ڂP�O',       # �t���[���ڂP�O
	'�t���[���ڂP�P',       # �t���[���ڂP�P
	'�t���[���ڂP�Q',       # �t���[���ڂP�Q
	'�t���[���ڂP�R',       # �t���[���ڂP�R
	'�t���[���ڂP�S',       # �t���[���ڂP�S
	'�t���[���ڂP�T',       # �t���[���ڂP�T
	'�t���[���ڂP�U',       # �t���[���ڂP�U
	'�t���[���ڂP�V',       # �t���[���ڂP�V
	'�t���[���ڂP�W',       # �t���[���ڂP�W
	'�t���[���ڂP�X',       # �t���[���ڂP�X
	'�t���[���ڂQ�O',       # �t���[���ڂQ�O
	'��',                   # ��
	'���t���K�i',           # ���t���K�i
	'��',                   # ��
	'���t���K�i',           # ���t���K�i
	'�t���[���ڂQ�P',       # �t���[���ڂQ�P
	'�t���[���ڂQ�Q',       # �t���[���ڂQ�Q
	'�t���[���ڂQ�R',       # �t���[���ڂQ�R
	'�t���[���ڂQ�S',       # �t���[���ڂQ�S
	'�t���[���ڂQ�T',       # �t���[���ڂQ�T
	'�t���[���ڂQ�U',       # �t���[���ڂQ�U
	'�t���[���ڂQ�V',       # �t���[���ڂQ�V
	'�t���[���ڂQ�W',       # �t���[���ڂQ�W
	'�t���[���ڂQ�X',       # �t���[���ڂQ�X
	'�t���[���ڂR�O',       # �t���[���ڂR�O
	);
	my @_tmp;
	$_tmp[0] = '';
	$_tmp[1] = '';
	$_tmp[2] = '';
	splice( @base, 19, 0, @_tmp );
	
	$base[51] = '�o�^��(�N)';
	$base[52] = '�o�^��(��)';
	$base[53] = '�o�^��(��)';
	$base[54] = '�z�M��(�N)';
	$base[55] = '�z�M��(��)';
	$base[56] = '�z�M��(��)';
	$base[57] = '�����N���b�N���������N';
	
	# �v���r���[�p�ɏC��
	for( my $i=0; $i<=$#base; $i++ ){
		$temdata_base[$i] = qq|<$base[$i]>|;
		$temdata[$i] = qq|<em><font color="#336600">&lt;$base[$i]&gt;</font></em>|;
	}
	
	#my $now    = time;
	#my $result = 1;
}

$mail_reflect_tag =<<"END";
                                                
                                                  <option value="">-- �o�^�f�[�^�}���^�O --</option>
                                                  <option value="&lt;%id%&gt;">�o�^��ID�@�@�@�@�@�@&lt;%id%&gt;</option>
                                                  <option value="&lt;%co%&gt;">��Ж��@�@�@�@�@�@&lt;%co%&gt;</option>
                                                  <option value="&lt;%_co%&gt;">��Ж��t���K�i�@�@&lt;%_co%&gt;</option>
                                                  <option value="&lt;%sei%&gt;">���@�@�@�@�@�@�@�@&lt;%sei%&gt;</option>
                                                  <option value="&lt;%_sei%&gt;">���t���K�i�@�@�@�@&lt;%_sei%&gt;</option>
                                                  <option value="&lt;%mei%&gt;">���@�@�@�@�@�@�@�@&lt;%mei%&gt;</option>
                                                  <option value="&lt;%_mei%&gt;">���t���K�i�@�@�@�@&lt;%_mei%&gt;</option>
                                                  <option value="&lt;%name%&gt;">�����O�@�@�@�@�@�@&lt;%name%&gt;</option>
                                                  <option value="&lt;%_name%&gt;">�����O�t���K�i�@�@&lt;%_name%&gt;</option>
                                                  <option value="&lt;%mail%&gt;">���[���A�h���X�@�@&lt;%mail%&gt;</option>
                                                  <option value="&lt;%tel%&gt;">�d�b�ԍ��@�@�@�@�@&lt;%tel%&gt;</option>
                                                  <option value="&lt;%fax%&gt;">FAX�ԍ� �@�@�@�@�@&lt;%fax%&gt;</option>
                                                  <option value="&lt;%url%&gt;">URL �@�@�@�@�@�@�@&lt;%url%&gt;</option>
                                                  <option value="&lt;%code%&gt;">�X�֔ԍ��@�@�@�@�@&lt;%code%&gt;</option>
                                                  <option value="&lt;%address%&gt;">�s���{���@�@�@�@�@&lt;%address%&gt;</option>
                                                  <option value="&lt;%address1%&gt;">�Z���P�@�@�@�@�@�@&lt;%address1%&gt;</option>
                                                  <option value="&lt;%address2%&gt;">�Z���Q�@�@�@�@�@�@&lt;%address2%&gt;</option>
                                                  <option value="&lt;%address3%&gt;">�Z���R�@�@�@�@�@�@&lt;%address3%&gt;</option>
                                                  <option value="&lt;%free1%&gt;">�t���[���ڂP�@�@�@&lt;%free1%&gt;</option>
                                                  <option value="&lt;%free2%&gt;">�t���[���ڂQ�@�@�@&lt;%free2%&gt;</option>
                                                  <option value="&lt;%free3%&gt;">�t���[���ڂR�@�@�@&lt;%free3%&gt;</option>
                                                  <option value="&lt;%free4%&gt;">�t���[���ڂS�@�@�@&lt;%free4%&gt;</option>
                                                  <option value="&lt;%free5%&gt;">�t���[���ڂT�@�@�@&lt;%free5%&gt;</option>
                                                  <option value="&lt;%free6%&gt;">�t���[���ڂU�@�@�@&lt;%free6%&gt;</option>
                                                  <option value="&lt;%free7%&gt;">�t���[���ڂV�@�@�@&lt;%free7%&gt;</option>
                                                  <option value="&lt;%free8%&gt;">�t���[���ڂW�@�@�@&lt;%free8%&gt;</option>
                                                  <option value="&lt;%free9%&gt;">�t���[���ڂX�@�@�@&lt;%free9%&gt;</option>
                                                  <option value="&lt;%free10%&gt;">�t���[���ڂP�O�@�@&lt;%free10%&gt;</option>
                                                  <option value="&lt;%free11%&gt;">�t���[���ڂP�P�@�@&lt;%free11%&gt;</option>
                                                  <option value="&lt;%free12%&gt;">�t���[���ڂP�Q�@�@&lt;%free12%&gt;</option>
                                                  <option value="&lt;%free13%&gt;">�t���[���ڂP�R�@�@&lt;%free13%&gt;</option>
                                                  <option value="&lt;%free14%&gt;">�t���[���ڂP�S�@�@&lt;%free14%&gt;</option>
                                                  <option value="&lt;%free15%&gt;">�t���[���ڂP�T�@�@&lt;%free15%&gt;</option>
                                                  <option value="&lt;%free16%&gt;">�t���[���ڂP�U�@�@&lt;%free16%&gt;</option>
                                                  <option value="&lt;%free17%&gt;">�t���[���ڂP�V�@�@&lt;%free17%&gt;</option>
                                                  <option value="&lt;%free18%&gt;">�t���[���ڂP�W�@�@&lt;%free18%&gt;</option>
                                                  <option value="&lt;%free19%&gt;">�t���[���ڂP�X�@�@&lt;%free19%&gt;</option>
                                                  <option value="&lt;%free20%&gt;">�t���[���ڂQ�O�@�@&lt;%free20%&gt;</option>
                                                  <option value="&lt;%free21%&gt;">�t���[���ڂQ�P�@�@&lt;%free21%&gt;</option>
                                                  <option value="&lt;%free22%&gt;">�t���[���ڂQ�Q�@�@&lt;%free22%&gt;</option>
                                                  <option value="&lt;%free23%&gt;">�t���[���ڂQ�R�@�@&lt;%free23%&gt;</option>
                                                  <option value="&lt;%free24%&gt;">�t���[���ڂQ�S�@�@&lt;%free24%&gt;</option>
                                                  <option value="&lt;%free25%&gt;">�t���[���ڂQ�T�@�@&lt;%free25%&gt;</option>
                                                  <option value="&lt;%free26%&gt;">�t���[���ڂQ�U�@�@&lt;%free26%&gt;</option>
                                                  <option value="&lt;%free27%&gt;">�t���[���ڂQ�V�@�@&lt;%free27%&gt;</option>
                                                  <option value="&lt;%free28%&gt;">�t���[���ڂQ�W�@�@&lt;%free28%&gt;</option>
                                                  <option value="&lt;%free29%&gt;">�t���[���ڂQ�X�@�@&lt;%free29%&gt;</option>
                                                  <option value="&lt;%free30%&gt;">�t���[���ڂR�O�@�@&lt;%free30%&gt;</option>
                                                  <option value="&lt;%ryear%&gt;">�o�^���i�N�j�@�@�@&lt;%ryear%&gt;</option>
                                                  <option value="&lt;%rmon%&gt;">�o�^���i���j�@�@�@&lt;%rmon%&gt;</option>
                                                  <option value="&lt;%rday%&gt;">�o�^���i���j�@�@�@&lt;%rday%&gt;</option>
                                                  <option value="&lt;%year%&gt;">�z�M���i�N�j�@�@�@&lt;%year%&gt;</option>
                                                  <option value="&lt;%mon%&gt;">�z�M���i���j�@�@�@&lt;%mon%&gt;</option>
                                                  <option value="&lt;%day%&gt;">�z�M���i���j�@�@�@&lt;%day%&gt;</option>
                                                  <option value="&lt;%cancel%&gt;">�����N���b�N���������N&lt;%cancel%&gt;</option>
END
# ������ʗp
$thanks_reflect_tag =<<"END";
                                                  <option value="">-- �o�^�҃f�[�^�}���^�O --</option>
                                                  <option value="&lt;%id%&gt;">�o�^��ID�@�@�@�@�@�@&lt;%id%&gt;</option>
END
# ���͊m�F��ʗp
$confirm_reflect_tag =<<"END";
                                                  <option value="">-- �o�^�҃f�[�^�}���^�O --</option>
                                                  <option value="&lt;%co%&gt;">��Ж��@�@�@�@�@�@&lt;%co%&gt;</option>
                                                  <option value="&lt;%_co%&gt;">��Ж��t���K�i�@�@&lt;%_co%&gt;</option>
                                                  <option value="&lt;%sei%&gt;">���@�@�@�@�@�@�@�@&lt;%sei%&gt;</option>
                                                  <option value="&lt;%_sei%&gt;">���t���K�i�@�@�@�@&lt;%_sei%&gt;</option>
                                                  <option value="&lt;%mei%&gt;">���@�@�@�@�@�@�@�@&lt;%mei%&gt;</option>
                                                  <option value="&lt;%_mei%&gt;">���t���K�i�@�@�@�@&lt;%_mei%&gt;</option>
                                                  <option value="&lt;%name%&gt;">�����O�@�@�@�@�@�@&lt;%name%&gt;</option>
                                                  <option value="&lt;%_name%&gt;">�����O�t���K�i�@�@&lt;%_name%&gt;</option>
                                                  <option value="&lt;%mail%&gt;">���[���A�h���X�@�@&lt;%mail%&gt;</option>
                                                  <option value="&lt;%tel%&gt;">�d�b�ԍ��@�@�@�@�@&lt;%tel%&gt;</option>
                                                  <option value="&lt;%fax%&gt;">FAX�ԍ� �@�@�@�@�@&lt;%fax%&gt;</option>
                                                  <option value="&lt;%url%&gt;">URL �@�@�@�@�@�@�@&lt;%url%&gt;</option>
                                                  <option value="&lt;%code%&gt;">�X�֔ԍ��@�@�@�@�@&lt;%code%&gt;</option>
                                                  <option value="&lt;%address%&gt;">�s���{���@�@�@�@�@&lt;%address%&gt;</option>
                                                  <option value="&lt;%address1%&gt;">�Z���P�@�@�@�@�@�@&lt;%address1%&gt;</option>
                                                  <option value="&lt;%address2%&gt;">�Z���Q�@�@�@�@�@�@&lt;%address2%&gt;</option>
                                                  <option value="&lt;%address3%&gt;">�Z���R�@�@�@�@�@�@&lt;%address3%&gt;</option>
                                                  <option value="&lt;%free1%&gt;">�t���[���ڂP�@�@�@&lt;%free1%&gt;</option>
                                                  <option value="&lt;%free2%&gt;">�t���[���ڂQ�@�@�@&lt;%free2%&gt;</option>
                                                  <option value="&lt;%free3%&gt;">�t���[���ڂR�@�@�@&lt;%free3%&gt;</option>
                                                  <option value="&lt;%free4%&gt;">�t���[���ڂS�@�@�@&lt;%free4%&gt;</option>
                                                  <option value="&lt;%free5%&gt;">�t���[���ڂT�@�@�@&lt;%free5%&gt;</option>
                                                  <option value="&lt;%free6%&gt;">�t���[���ڂU�@�@�@&lt;%free6%&gt;</option>
                                                  <option value="&lt;%free7%&gt;">�t���[���ڂV�@�@�@&lt;%free7%&gt;</option>
                                                  <option value="&lt;%free8%&gt;">�t���[���ڂW�@�@�@&lt;%free8%&gt;</option>
                                                  <option value="&lt;%free9%&gt;">�t���[���ڂX�@�@�@&lt;%free9%&gt;</option>
                                                  <option value="&lt;%free10%&gt;">�t���[���ڂP�O�@�@&lt;%free10%&gt;</option>
                                                  <option value="&lt;%free11%&gt;">�t���[���ڂP�P�@�@&lt;%free11%&gt;</option>
                                                  <option value="&lt;%free12%&gt;">�t���[���ڂP�Q�@�@&lt;%free12%&gt;</option>
                                                  <option value="&lt;%free13%&gt;">�t���[���ڂP�R�@�@&lt;%free13%&gt;</option>
                                                  <option value="&lt;%free14%&gt;">�t���[���ڂP�S�@�@&lt;%free14%&gt;</option>
                                                  <option value="&lt;%free15%&gt;">�t���[���ڂP�T�@�@&lt;%free15%&gt;</option>
                                                  <option value="&lt;%free16%&gt;">�t���[���ڂP�U�@�@&lt;%free16%&gt;</option>
                                                  <option value="&lt;%free17%&gt;">�t���[���ڂP�V�@�@&lt;%free17%&gt;</option>
                                                  <option value="&lt;%free18%&gt;">�t���[���ڂP�W�@�@&lt;%free18%&gt;</option>
                                                  <option value="&lt;%free19%&gt;">�t���[���ڂP�X�@�@&lt;%free19%&gt;</option>
                                                  <option value="&lt;%free20%&gt;">�t���[���ڂQ�O�@�@&lt;%free20%&gt;</option>
                                                  <option value="&lt;%free21%&gt;">�t���[���ڂQ�P�@�@&lt;%free21%&gt;</option>
                                                  <option value="&lt;%free22%&gt;">�t���[���ڂQ�Q�@�@&lt;%free22%&gt;</option>
                                                  <option value="&lt;%free23%&gt;">�t���[���ڂQ�R�@�@&lt;%free23%&gt;</option>
                                                  <option value="&lt;%free24%&gt;">�t���[���ڂQ�S�@�@&lt;%free24%&gt;</option>
                                                  <option value="&lt;%free25%&gt;">�t���[���ڂQ�T�@�@&lt;%free25%&gt;</option>
                                                  <option value="&lt;%free26%&gt;">�t���[���ڂQ�U�@�@&lt;%free26%&gt;</option>
                                                  <option value="&lt;%free27%&gt;">�t���[���ڂQ�V�@�@&lt;%free27%&gt;</option>
                                                  <option value="&lt;%free28%&gt;">�t���[���ڂQ�W�@�@&lt;%free28%&gt;</option>
                                                  <option value="&lt;%free29%&gt;">�t���[���ڂQ�X�@�@&lt;%free29%&gt;</option>
                                                  <option value="&lt;%free30%&gt;">�t���[���ڂR�O�@�@&lt;%free30%&gt;</option>
END

sub remakeTag
{
	my $option = &Click'getTag();
	$mail_reflect_tag .= "\n". $option;
}
1;
