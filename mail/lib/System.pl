#---------------------------------------------------------------#
# �J�����g�f�B���N�g���i�ݒu�̃��[�g�f�B���N�g���j�̎w��        #
#---------------------------------------------------------------#
$myroot = ( $myroot ne '' )? $myroot : '../'; # �Ō��/��t����

#---------------------------------------------------
# CGI�X�N���v�g��
#---------------------------------------------------
$indexcgi = 'index.cgi';
$sendcgi = 'send.cgi';
$applycgi_name = 'apply.cgi';
$applycgi = $Pub'scriptName. $applycgi_name;
#---------------------------------------------------
# �f�U�C���e���v���[�g
#---------------------------------------------------
$DesignTemplate = 'DesignTemplate.csv';
$FormTemplate = 'BaseDesign.html';
$FormTemplate_mobile = 'BaseDesign_m.html';
# �G���[�o�͗p
$err = 'message.pl';
$err_m = 'message_m.pl'; # �g�їp

# �f�[�^�f�B���N�g���̃��[�g�p�X
$data_dir = 'data/';
# �J�����g�f�B���N�g��$myroot����̑��΃p�X�i�Ō��/��t����j

#---------------------------------------------------
# �Z�b�g�A�b�v����t�@�C��(�o�[�W�������i�[)
#---------------------------------------------------
$DATA{'setup'} = $myroot. $data_dir. 'setup.cgi';

@SETUP_STEP = ( 
	'start',
	'pmsBase',
	'pathImg',
	'pmsImg',
	'pathSmail',
	'end',
);

$ICON = 'icon_alert.gif';

#---------------------------------------------------
# �T�[�o�[���t�@�C��
#---------------------------------------------------
$DATA{'server'} = $myroot. $data_dir. 'server.cgi';

# sendmail�p�X�\��
@SENDMAIL = ( '/usr/sbin/sendmail', '/usr/local/sendmail', '/usr/lib/sendmail' );


# �����z�M�v�����z�M���O��ۑ�����f�B���N�g��
$log_dir = 'log/';
#�i�Ō��/��t����j

# �Ǘ��ҏ��p�t�@�C����
$admin_txt = 'admin.cgi';
# �z�M�v�����p�t�@�C����
$plan_txt = 'plan.cgi';

# �����z�M�v�����̓��e��ۑ�����f�B���N�g��
$queue_dir = 'queue/';
# �i�Ō��/��t����j

# �o�^�҃��X�gCSV�t�@�C���ۑ��p�f�B���N�g��
$csv_dir = 'csv/';
# �i�Ō��/��t����j

# �e���v���[�g�t�@�C���ۑ��p�f�B���N�g��
$template = 'template/';
# �i�Ō��/��t����j

# �}�j���A���y�[�W�ۑ��p�f�B���N�g��
$manual = '../manual';
# index.cgi����̑��΃p�X�i�Ō��/��t���Ȃ��j

# ���M�����ݒ�t�@�C����
$methodtxt = 'method.cgi';

# ��ă��[���p
$simul_dir = 'simul/';

# �t�H�[�������p
$mkform_dir = 'mkform/';

# �A�N�Z�X����
$forward_dir = 'forward/';


#----------------------------------------------------
# �r������
#----------------------------------------------------

$lockdir  = 'lock/'; # �i�Ō��/��t����j
$lockfile = 'lock';    # ���b�N��p�t�@�C���i���b�N���̓t�@�C�������ύX�����j

#----------------------------------------------------
# �Z�b�V����
#----------------------------------------------------
$Session{'dir'} = $myroot . $data_dir;
$Session{'file'} = 'session.cgi';
$Session{'limit'} = 60; # �ꎞ��
$Session{'cookie_id'} = 'SSID';

#---------------------------------------------------------------#
# ���ݒ�                                                      #
#---------------------------------------------------------------#

# �������[�U�[�h�c
$defid = 'id';
# �����p�X���[�h
$defpass = 'pass';

# �z�M���O�̍ő�ۑ���
$logmax = 2000;
# �z�M���O�̂P�y�[�W�̏o�͌���
$pagemax = 100;

#----------------------------------------------------
# HTML�t�@�C���֘A
#----------------------------------------------------

# �X�^�C���V�[�g�̃p�X( or URL)
$css = 'ad_style.css';

#----------------------------------------------------
# �摜�i�C�ӂ̃y�[�W�Ŕz�M�V�X�e�����ғ�������j
#----------------------------------------------------

# �摜�t�@�C����
$imagefile = 'space.gif';

# �摜�ۑ��f�B���N�g��
$image_dir = '../images/';
# �J�����g�f�B���N�g��(54�s�ڂɎw��)������̑��΃p�X�i�Ō��/��t����j

$IMG_URL   = '';
# CGI��ݒu�����p�f�B���N�g��������A�����̃f�B���N�g����
# ���J�f�B���N�g���ł͂Ȃ��ꍇ�A�摜�ۑ��f�B���N�g����URL��http����
# �w�肵�Ă��������B
# HTML�`�����[���@�\�ǉ��ɂƂ��Ȃ��ǉ��ݒ荀��
# ���Y�����Ȃ��ꍇ�͖��ݒ�ɂ��Ă��������B

#----------------------------------------------------
# ���̑�
#----------------------------------------------------

# �Ǘ���ʃ^�C�g��
$title = '[�Ǘ����]';

# ���[�����M�p���C�u����
$mime = "${'myroot'}lib/mime_pls202/mimew.pl";

# �Z�b�g�A�b�v�G���[
$ErrorMessage{'001'} = '<strong>[ ���� ]</strong>';
$ErrorMessage{'002'} = '<font color="#FF0000"><strong>[ ���s ]</strong></font><br>';
$ErrorMessage{'003'} = '������܂���B<br>�ݒu�\�������m�F���������B';
$ErrorMessage{'004'} = '<font color="#FF0000">�p�[�~�b�V������ 700 or 705 �ɕύX���Ă��������B</font>';
$ErrorMessage{'005'} = '<font color="#FF0000">�p�[�~�b�V������ 705 �ɕύX���Ă��������B</font>';
$ErrorMessage{'006'} = '<font color="#FF0000">�p�[�~�b�V������ 707 �ɕύX���Ă��������B</font>';

# �Ǘ���ʂŗ��p����\��摜�t�@�C��
@ImageAdmin = (
	'bg2-r.gif',
	'fm01.gif',
	'fm02.gif',
	'fm01_s.gif',
	'fm02_s.gif',
	'fm03_s.gif',
	'fm04_s.gif',
	'fm05_s.gif',
	'fm06_s.gif',
	'fm07_s.gif',
	'fm08_s.gif',
	'fm09_s.gif',
	'fm10_s.gif',
	'fm11_s.gif',
	'fm12_s.gif',
	'fm13_s.gif',
	'icon_alert.gif',
	'icon_folder.gif',
	'icon_help.gif',
	'icon_l.gif',
	'icon_plan2.gif',
	'icon_plan.gif',
	'icon_title01.gif',
	'space.gif',
	'spacer01.gif',
	'rakumaillogo2.jpg',
	'rakumaillogo.jpg',
);

1;
