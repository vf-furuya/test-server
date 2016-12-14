#---------------------------------------
# �y���[��pro
#
# HTML�`�����[���p�֘A�֐��Q2 upload.pl
# v 2.4
#---------------------------------------
sub imgupload {
	
	my $imgdir  = $image_dir;
	
	# �\��摜�t�@�C��
	my $reserve = join( "/", @ImageAdmin );
	
	my( $action, $target );
	foreach( keys %param ){
		if( /^d-(.+)$/ ){
			$action = 'delete';
			$target = $1;
			last;
		}
	}
	if( $param{'upload'} ){
		$action = 'upload';
	}
	
	unless( opendir( LIST, $imgdir ) ){
		&imgerror("�V�X�e���G���[", "$imgdir ���J���܂���B<br>�f�B���N�g�������݂��邩�p�[�~�b�V������[707]�ł��邩�m�F���Ă��������B");
	}
	my @_list = readdir LIST;
	close(LIST);
	my @list;
	foreach my $filename ( @_list ){
		next if( $filename =~ /^\.*$/ );
		next if( $filename =~ /^rakumaillogo(\d)*\.jpg$/ );
		next if( $filename =~ /^$imagefile$/ );
		next if( $filename =~ /\.css$/ );
		next if( index( $reserve, $filename ) >= 0 );
		push @list, $filename;
	}
	
	if( $action eq 'upload' ){
		my $filename = &the_filedata( 'img' );
		my $filedata = $param{'img'};
		
		local $_ = $filename;
		if( !/\.jp(e)?g$/ && !/\.tif$/ && !/\.bmp$/ && !/\.gif$/ && !/\.png$/ ){
			&imgerror( "���̓G���[", '�摜�t�@�C�����w�肵�Ă��������B' );
		}
		
		if( $filename =~ /^rakumaillogo(\d)*\.jpg$/ || $filename =~ /^$imagefile$/ || index( $reserve, $filename ) >= 0 ){
				&imgerror("�V�X�e���G���[", "�V�X�e���Ŏg�p����Ă��܂��̂ŁA�w�肵���t�@�C���̓A�b�v���[�h�ł��܂���B");
		}
		
		if( $filename ne '' ){
			
			my $path = $image_local . $filename;
			unless( open( IMG, ">$path" ) ){
				&imgerror("�V�X�e���G���[", "�t�@�C�����A�b�v���[�h�ł��܂���B<br>$imgdir �f�B���N�g�������݂��邩�p�[�~�b�V������[707]�ł��邩�m�F���Ă��������B");
			}
			binmode IMG;
			print IMG $filedata;
			close(IMG);
			if( $IMG_PMS > 0 ){
				my $pms = oct( $IMG_PMS );
				chmod $pms, $path;
			}else{
				chmod 0666, $path;
			}
			
		}
		
	}elsif( $action eq 'delete'){
	
		# ���΃p�X���폜
		$target =~ s/\.*\///ig if( $target ne '' );
		for( my $i=$#list; $i>=0; $i-- ){
			if( $list[$i] eq $target ){
				unlink "$imgdir$target";
				last;
			}
		}
	}
	
	undef @list;
	undef @_list;
	unless( opendir( LIST, $imgdir ) ){
		&imgerror("�V�X�e���G���[", "$imgdir ���J���܂���B<br>�f�B���N�g�������݂��邩�p�[�~�b�V������[707]�ł��邩�m�F���Ă��������B");
	}
	@_list = readdir LIST;
	close(LIST);
	
	foreach my $filename ( @_list ){
		next if( $filename =~ /^\.*$/ );
		next if( $filename =~ /^rakumaillogo(\d)*\.jpg$/ );
		next if( $filename =~ /^$imagefile$/ );
		next if( $filename =~ /\.css$/ );
		next if( index( $reserve, $filename ) >= 0 );
		push @list, $filename;
	}
	@list = sort{ (stat( $a ))[9] <=> (stat( $b ))[9] } @list;
	
	&img_upload_disp( \@list );
	exit;
}

sub img_upload_disp {
	
	my $list = shift;
	print <<"END";
Content-type: text/html

<html>
<head>
<title>HTML���[���@�摜�t�@�C���Ǘ�</title>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis">
<link href="$image_dir$css" rel="stylesheet" type="text/css">
</head>

<body>
<form action="$indexcgi" method="post" enctype="multipart/form-data" name="form1">
  �@<br>
  <table width="500" border="0" align="center" cellpadding="5" cellspacing="0">
    <tr>
      <td align="right"><a href="javascript: void(0);" onClick="window.close();"><font color="#0000FF">����</font></a></td>
    </tr>
  </table>
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td bgcolor="#FFEDC8"><table width="500" border="0" align="center" cellpadding="5" cellspacing="1">
    <tr bgcolor="#FFCC33">
      <td colspan="2">�� �V�K�摜�t�@�C���̃A�b�v���[�h</td>
    </tr>
    <tr>
      <td width="90" align="right" bgcolor="#FFEDC8">�摜�t�@�C��</td>
      <td width="410" bgcolor="#FFEDC8"><input name="img" type="file" id="img" size="40">
       <input name="upload" type="submit" id="upload" value="�@�ǉ��@">
       <input name="md" type="hidden" id="md" value="imgupload">
      </td>
    </tr>
  </table></td>
    </tr>
  </table>
  <table width="500" border="0" align="center" cellpadding="5" cellspacing="0">
    <tr>
      <td>�e�v�������ɉ摜�t�@�C�����Ǘ����邱�Ƃ͂ł��܂���B<br>
      �����t�@�C���͏㏑������܂��B<br>
      ���{��t�@�C�����̓A�b�v���[�h�ł��܂���B(�������I�ɔ��p�֕ϊ�����܂��B)</td>
    </tr>
  </table>
  <br>
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td><table width="500" border="0" cellpadding="5" cellspacing="0">
        <tr bgcolor="#99CCFF">
          <td colspan="3">�� �A�b�v���[�h�ς݃t�@�C���ꗗ</td>
          </tr>
END
	
	
	foreach( @$list ){
		my $url  = &get_url( "$image_dir", $IMG_URL );
		my $path = &get_relpath( "$image_local", $IMG_URL );
		$url .= $_;
		print <<"END";
        <tr>
          <td width="60" align="center"><img src="$path$_" width="50" height="50"></td>
          <td width="400">$url<br>
            </td>
          <td width="40" align="center"><input name="d-$_" type="submit" value="�폜"></td>
        </tr>
END
	}
	if( $#$list < 0 ){
		print <<"END";
        <tr>
          <td width="60" align="center">&nbsp;</td>
          <td width="400"><br><br>�摜�t�@�C���̓A�b�v���[�h����Ă��܂���B<br><br>
            </td>
          <td width="40" align="center">&nbsp;</td>
        </tr>
END
	}
	
	
	print <<"END";
        <tr>
          <td colspan="3">���摜�t�@�C���̃p�X��http����w�肵�Ă��������B</td>
          </tr>
      </table></td>
    </tr>
  </table>
</form>
</body>
</html>
END
	exit;
}

sub get_relpath {
	
	my( $path, $url ) = @_;
	if( $url ne '' ){
		$url =~ s/\/$//;
		return "$url/";
	}
	
	$path = $image_dir;
	
	# ���΃p�X�̏ꍇ�͏����I��
	return $path if( $path !~ /^\// );
	
	# ��΃p�X�𑊑΃p�X�ɕύX
	
	$ENV{'SCRIPT_FILENAME'} =~ /\/(.*)\/$indexcgi/;
	my $chdir = $1;
	$chdir =~ s/^[^:+]://;
	$ENV{'SCRIPT_NAME'} =~ /\/(.*)\/$indexcgi/;
	my $chrul = $1;
	
	$path =~ s/^\///;
	my @chpath     = split( /\//, $chdir );
	my @churlpath  = split( /\//, $chrul );
	my @_path      = split( /\//, $path );
	
	# ���΃p�X�w��𐳋K��
	my $flag = 0;
	for( my $i=$#_path; $i>=0; $i-- ){
		if( $_path[$i] =~ /^\.$/ ){
			splice( @_path, $i, 1 );
			next;
		}
		if( $_path[$i] =~ /^\.\.$/ ){
			splice( @_path, $i, 1 );
			$flag++;
			next;
		}
		if( $flag ){
			splice( @_path, $i, 1 );
			$flag--;
		}
	}
	
	my $num;
	for( my $i=0; $i<@chpath; $i++ ){
		if( $chpath[$i] ne $_path[$i] ){
			$num   = $i;
			last;
		}
	}
	my @rel_path = splice( @_path, $num );
	my $target = $#chpath - $num;
	$target += 1;
	for( my $i=0; $i<$target; $i++ ){
		unshift @rel_path, '..';
	}
	my $rel = join("/", @rel_path );
	return "$rel/";
}

sub get_url {
	
	my( $path, $url ) = @_;
	if( $url ne '' ){
		$url =~ s/\/$//;
		return "$url/";
	}
	$path =~ s/\/$//;
	
	my $urlpath;
	$ENV{'SCRIPT_FILENAME'} =~ /\/(.*)\/$indexcgi/;
	my $chdir = $1;
	$chdir =~ s/^[^:+]://;
	$ENV{'SCRIPT_NAME'} =~ /\/(.*)\/$indexcgi/;
	my $chrul = $1;
	
	if( $path =~ /^\// ){
		
		$path =~ s/^\///;
		my @chpath     = split( /\//, $chdir );
		my @churlpath  = split( /\//, $chrul );
		my @_path      = split( /\//, $path );
		
		# ���΃p�X�w��𐳋K��
		my $flag = 0;
		for( my $i=$#_path; $i>=0; $i-- ){
			if( $_path[$i] =~ /^\.$/ ){
				splice( @_path, $i, 1 );
				next;
			}
			if( $_path[$i] =~ /^\.\.$/ ){
				splice( @_path, $i, 1 );
				$flag++;
				next;
			}
			if( $flag ){
				splice( @_path, $i, 1 );
				$flag--;
			}
		}
		
		# URL���擾
		my $num;
		for( my $i=0; $i<@chpath; $i++ ){
			if( $chpath[$i] ne $_path[$i] ){
				$num   = $i;
				last;
			}
		}
		my $target = $#chpath - $num;
		$target += 1;
		for( my $i=0; $i<$target; $i++ ){
			pop @churlpath;
		}
		push @churlpath, splice( @_path, $num );
		$urlpath = join("/", @churlpath );
		
	}else{
		
		my @chpath = split( /\//, $chrul );
		my @_path  = split( /\//, $path );
		
		foreach( @_path ){
			if( /^\.\.$/ ){
				splice( @chpath, -1, 1 );
				next;
			}
			next if( /^\.$/ );
			push @chpath, $_;
		}
		$urlpath = join("/", @chpath );
	}
	return "$ENV{'HTTP_HOST'}/$urlpath/";
}

sub _url {
	my @path = @_;
	my $url = join("/", @path );
	&imgerror($url);
}

sub imgerror {

	my( $title, $message ) = @_;
	print <<"END";
Content-type: text/html

<html>
<title>HTML���[���@�摜�t�@�C���Ǘ�</title>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis">
<link href="$image_dir$css" rel="stylesheet" type="text/css">
<body>
<br><br>
<table cellpadding="4" cellspacing="0" border="0" width="500" align="center">
<tr>
  <td><h3>$title</h3></td>
<tr>
  <td>$message</td>
</tr>
<tr>
  <td><a href="$indexcgi?md=imgupload"><font color="#0000FF">�߂�</font></a></td>
</tr>
</body>
</html>
END
	exit;
}
1;
