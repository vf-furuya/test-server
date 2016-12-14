#---------------------------------------
# 楽メールpro
#
# HTML形式メール用関連関数群2 upload.pl
# v 2.4
#---------------------------------------
sub imgupload {
	
	my $imgdir  = $image_dir;
	
	# 予約画像ファイル
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
		&imgerror("システムエラー", "$imgdir が開けません。<br>ディレクトリが存在するかパーミッションが[707]であるか確認してください。");
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
			&imgerror( "入力エラー", '画像ファイルを指定してください。' );
		}
		
		if( $filename =~ /^rakumaillogo(\d)*\.jpg$/ || $filename =~ /^$imagefile$/ || index( $reserve, $filename ) >= 0 ){
				&imgerror("システムエラー", "システムで使用されていますので、指定したファイルはアップロードできません。");
		}
		
		if( $filename ne '' ){
			
			my $path = $image_local . $filename;
			unless( open( IMG, ">$path" ) ){
				&imgerror("システムエラー", "ファイルがアップロードできません。<br>$imgdir ディレクトリが存在するかパーミッションが[707]であるか確認してください。");
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
	
		# 相対パスを削除
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
		&imgerror("システムエラー", "$imgdir が開けません。<br>ディレクトリが存在するかパーミッションが[707]であるか確認してください。");
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
<title>HTMLメール　画像ファイル管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=shift_jis">
<link href="$image_dir$css" rel="stylesheet" type="text/css">
</head>

<body>
<form action="$indexcgi" method="post" enctype="multipart/form-data" name="form1">
  　<br>
  <table width="500" border="0" align="center" cellpadding="5" cellspacing="0">
    <tr>
      <td align="right"><a href="javascript: void(0);" onClick="window.close();"><font color="#0000FF">閉じる</font></a></td>
    </tr>
  </table>
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td bgcolor="#FFEDC8"><table width="500" border="0" align="center" cellpadding="5" cellspacing="1">
    <tr bgcolor="#FFCC33">
      <td colspan="2">■ 新規画像ファイルのアップロード</td>
    </tr>
    <tr>
      <td width="90" align="right" bgcolor="#FFEDC8">画像ファイル</td>
      <td width="410" bgcolor="#FFEDC8"><input name="img" type="file" id="img" size="40">
       <input name="upload" type="submit" id="upload" value="　追加　">
       <input name="md" type="hidden" id="md" value="imgupload">
      </td>
    </tr>
  </table></td>
    </tr>
  </table>
  <table width="500" border="0" align="center" cellpadding="5" cellspacing="0">
    <tr>
      <td>各プラン毎に画像ファイルを管理することはできません。<br>
      同名ファイルは上書きされます。<br>
      日本語ファイル名はアップロードできません。(※強制的に半角へ変換されます。)</td>
    </tr>
  </table>
  <br>
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td><table width="500" border="0" cellpadding="5" cellspacing="0">
        <tr bgcolor="#99CCFF">
          <td colspan="3">■ アップロード済みファイル一覧</td>
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
          <td width="40" align="center"><input name="d-$_" type="submit" value="削除"></td>
        </tr>
END
	}
	if( $#$list < 0 ){
		print <<"END";
        <tr>
          <td width="60" align="center">&nbsp;</td>
          <td width="400"><br><br>画像ファイルはアップロードされていません。<br><br>
            </td>
          <td width="40" align="center">&nbsp;</td>
        </tr>
END
	}
	
	
	print <<"END";
        <tr>
          <td colspan="3">※画像ファイルのパスはhttpから指定してください。</td>
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
	
	# 相対パスの場合は処理終了
	return $path if( $path !~ /^\// );
	
	# 絶対パスを相対パスに変更
	
	$ENV{'SCRIPT_FILENAME'} =~ /\/(.*)\/$indexcgi/;
	my $chdir = $1;
	$chdir =~ s/^[^:+]://;
	$ENV{'SCRIPT_NAME'} =~ /\/(.*)\/$indexcgi/;
	my $chrul = $1;
	
	$path =~ s/^\///;
	my @chpath     = split( /\//, $chdir );
	my @churlpath  = split( /\//, $chrul );
	my @_path      = split( /\//, $path );
	
	# 相対パス指定を正規化
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
		
		# 相対パス指定を正規化
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
		
		# URLを取得
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
<title>HTMLメール　画像ファイル管理</title>
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
  <td><a href="$indexcgi?md=imgupload"><font color="#0000FF">戻る</font></a></td>
</tr>
</body>
</html>
END
	exit;
}
1;
