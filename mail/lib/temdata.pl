# 簡易タグ用サンプルデータを調整
sub make_mailtag_tmp
{
	
	@base = (
	'登録者ID',             # 登録者ID
	'会社名',               # 会社名
	'会社名フリガナ',       # 会社名フリガナ
	'お名前',               # お名前
	'お名前フリガナ',       # お名前フリガナ
	'メールアドレス',  # メールアドレス
	'電話番号',          # 電話番号
	'FAX番号',          # FAX番号
	'URL',# URL
	'郵便番号',             # 郵便番号
	'都道府県',             # 都道府県
	'住所１',               # 住所１
	'住所２',               # 住所２
	'住所３',               # 住所３
	'フリー項目１',         # フリー項目１
	'フリー項目２',         # フリー項目２
	'フリー項目３',         # フリー項目３
	'フリー項目４',         # フリー項目４
	'フリー項目５',         # フリー項目５
	'フリー項目６',         # フリー項目６
	'フリー項目７',         # フリー項目７
	'フリー項目８',         # フリー項目８
	'フリー項目９',         # フリー項目９
	'フリー項目１０',       # フリー項目１０
	'フリー項目１１',       # フリー項目１１
	'フリー項目１２',       # フリー項目１２
	'フリー項目１３',       # フリー項目１３
	'フリー項目１４',       # フリー項目１４
	'フリー項目１５',       # フリー項目１５
	'フリー項目１６',       # フリー項目１６
	'フリー項目１７',       # フリー項目１７
	'フリー項目１８',       # フリー項目１８
	'フリー項目１９',       # フリー項目１９
	'フリー項目２０',       # フリー項目２０
	'姓',                   # 姓
	'姓フリガナ',           # 姓フリガナ
	'名',                   # 名
	'名フリガナ',           # 名フリガナ
	'フリー項目２１',       # フリー項目２１
	'フリー項目２２',       # フリー項目２２
	'フリー項目２３',       # フリー項目２３
	'フリー項目２４',       # フリー項目２４
	'フリー項目２５',       # フリー項目２５
	'フリー項目２６',       # フリー項目２６
	'フリー項目２７',       # フリー項目２７
	'フリー項目２８',       # フリー項目２８
	'フリー項目２９',       # フリー項目２９
	'フリー項目３０',       # フリー項目３０
	);
	my @_tmp;
	$_tmp[0] = '';
	$_tmp[1] = '';
	$_tmp[2] = '';
	splice( @base, 19, 0, @_tmp );
	
	$base[51] = '登録日(年)';
	$base[52] = '登録日(月)';
	$base[53] = '登録日(日)';
	$base[54] = '配信日(年)';
	$base[55] = '配信日(月)';
	$base[56] = '配信日(日)';
	$base[57] = 'ワンクリック解除リンク';
	
	# プレビュー用に修正
	for( my $i=0; $i<=$#base; $i++ ){
		$temdata_base[$i] = qq|<$base[$i]>|;
		$temdata[$i] = qq|<em><font color="#336600">&lt;$base[$i]&gt;</font></em>|;
	}
	
	#my $now    = time;
	#my $result = 1;
}

$mail_reflect_tag =<<"END";
                                                
                                                  <option value="">-- 登録データ挿入タグ --</option>
                                                  <option value="&lt;%id%&gt;">登録者ID　　　　　　&lt;%id%&gt;</option>
                                                  <option value="&lt;%co%&gt;">会社名　　　　　　&lt;%co%&gt;</option>
                                                  <option value="&lt;%_co%&gt;">会社名フリガナ　　&lt;%_co%&gt;</option>
                                                  <option value="&lt;%sei%&gt;">姓　　　　　　　　&lt;%sei%&gt;</option>
                                                  <option value="&lt;%_sei%&gt;">姓フリガナ　　　　&lt;%_sei%&gt;</option>
                                                  <option value="&lt;%mei%&gt;">名　　　　　　　　&lt;%mei%&gt;</option>
                                                  <option value="&lt;%_mei%&gt;">名フリガナ　　　　&lt;%_mei%&gt;</option>
                                                  <option value="&lt;%name%&gt;">お名前　　　　　　&lt;%name%&gt;</option>
                                                  <option value="&lt;%_name%&gt;">お名前フリガナ　　&lt;%_name%&gt;</option>
                                                  <option value="&lt;%mail%&gt;">メールアドレス　　&lt;%mail%&gt;</option>
                                                  <option value="&lt;%tel%&gt;">電話番号　　　　　&lt;%tel%&gt;</option>
                                                  <option value="&lt;%fax%&gt;">FAX番号 　　　　　&lt;%fax%&gt;</option>
                                                  <option value="&lt;%url%&gt;">URL 　　　　　　　&lt;%url%&gt;</option>
                                                  <option value="&lt;%code%&gt;">郵便番号　　　　　&lt;%code%&gt;</option>
                                                  <option value="&lt;%address%&gt;">都道府県　　　　　&lt;%address%&gt;</option>
                                                  <option value="&lt;%address1%&gt;">住所１　　　　　　&lt;%address1%&gt;</option>
                                                  <option value="&lt;%address2%&gt;">住所２　　　　　　&lt;%address2%&gt;</option>
                                                  <option value="&lt;%address3%&gt;">住所３　　　　　　&lt;%address3%&gt;</option>
                                                  <option value="&lt;%free1%&gt;">フリー項目１　　　&lt;%free1%&gt;</option>
                                                  <option value="&lt;%free2%&gt;">フリー項目２　　　&lt;%free2%&gt;</option>
                                                  <option value="&lt;%free3%&gt;">フリー項目３　　　&lt;%free3%&gt;</option>
                                                  <option value="&lt;%free4%&gt;">フリー項目４　　　&lt;%free4%&gt;</option>
                                                  <option value="&lt;%free5%&gt;">フリー項目５　　　&lt;%free5%&gt;</option>
                                                  <option value="&lt;%free6%&gt;">フリー項目６　　　&lt;%free6%&gt;</option>
                                                  <option value="&lt;%free7%&gt;">フリー項目７　　　&lt;%free7%&gt;</option>
                                                  <option value="&lt;%free8%&gt;">フリー項目８　　　&lt;%free8%&gt;</option>
                                                  <option value="&lt;%free9%&gt;">フリー項目９　　　&lt;%free9%&gt;</option>
                                                  <option value="&lt;%free10%&gt;">フリー項目１０　　&lt;%free10%&gt;</option>
                                                  <option value="&lt;%free11%&gt;">フリー項目１１　　&lt;%free11%&gt;</option>
                                                  <option value="&lt;%free12%&gt;">フリー項目１２　　&lt;%free12%&gt;</option>
                                                  <option value="&lt;%free13%&gt;">フリー項目１３　　&lt;%free13%&gt;</option>
                                                  <option value="&lt;%free14%&gt;">フリー項目１４　　&lt;%free14%&gt;</option>
                                                  <option value="&lt;%free15%&gt;">フリー項目１５　　&lt;%free15%&gt;</option>
                                                  <option value="&lt;%free16%&gt;">フリー項目１６　　&lt;%free16%&gt;</option>
                                                  <option value="&lt;%free17%&gt;">フリー項目１７　　&lt;%free17%&gt;</option>
                                                  <option value="&lt;%free18%&gt;">フリー項目１８　　&lt;%free18%&gt;</option>
                                                  <option value="&lt;%free19%&gt;">フリー項目１９　　&lt;%free19%&gt;</option>
                                                  <option value="&lt;%free20%&gt;">フリー項目２０　　&lt;%free20%&gt;</option>
                                                  <option value="&lt;%free21%&gt;">フリー項目２１　　&lt;%free21%&gt;</option>
                                                  <option value="&lt;%free22%&gt;">フリー項目２２　　&lt;%free22%&gt;</option>
                                                  <option value="&lt;%free23%&gt;">フリー項目２３　　&lt;%free23%&gt;</option>
                                                  <option value="&lt;%free24%&gt;">フリー項目２４　　&lt;%free24%&gt;</option>
                                                  <option value="&lt;%free25%&gt;">フリー項目２５　　&lt;%free25%&gt;</option>
                                                  <option value="&lt;%free26%&gt;">フリー項目２６　　&lt;%free26%&gt;</option>
                                                  <option value="&lt;%free27%&gt;">フリー項目２７　　&lt;%free27%&gt;</option>
                                                  <option value="&lt;%free28%&gt;">フリー項目２８　　&lt;%free28%&gt;</option>
                                                  <option value="&lt;%free29%&gt;">フリー項目２９　　&lt;%free29%&gt;</option>
                                                  <option value="&lt;%free30%&gt;">フリー項目３０　　&lt;%free30%&gt;</option>
                                                  <option value="&lt;%ryear%&gt;">登録日（年）　　　&lt;%ryear%&gt;</option>
                                                  <option value="&lt;%rmon%&gt;">登録日（月）　　　&lt;%rmon%&gt;</option>
                                                  <option value="&lt;%rday%&gt;">登録日（日）　　　&lt;%rday%&gt;</option>
                                                  <option value="&lt;%year%&gt;">配信日（年）　　　&lt;%year%&gt;</option>
                                                  <option value="&lt;%mon%&gt;">配信日（月）　　　&lt;%mon%&gt;</option>
                                                  <option value="&lt;%day%&gt;">配信日（日）　　　&lt;%day%&gt;</option>
                                                  <option value="&lt;%cancel%&gt;">ワンクリック解除リンク&lt;%cancel%&gt;</option>
END
# 完了画面用
$thanks_reflect_tag =<<"END";
                                                  <option value="">-- 登録者データ挿入タグ --</option>
                                                  <option value="&lt;%id%&gt;">登録者ID　　　　　　&lt;%id%&gt;</option>
END
# 入力確認画面用
$confirm_reflect_tag =<<"END";
                                                  <option value="">-- 登録者データ挿入タグ --</option>
                                                  <option value="&lt;%co%&gt;">会社名　　　　　　&lt;%co%&gt;</option>
                                                  <option value="&lt;%_co%&gt;">会社名フリガナ　　&lt;%_co%&gt;</option>
                                                  <option value="&lt;%sei%&gt;">姓　　　　　　　　&lt;%sei%&gt;</option>
                                                  <option value="&lt;%_sei%&gt;">姓フリガナ　　　　&lt;%_sei%&gt;</option>
                                                  <option value="&lt;%mei%&gt;">名　　　　　　　　&lt;%mei%&gt;</option>
                                                  <option value="&lt;%_mei%&gt;">名フリガナ　　　　&lt;%_mei%&gt;</option>
                                                  <option value="&lt;%name%&gt;">お名前　　　　　　&lt;%name%&gt;</option>
                                                  <option value="&lt;%_name%&gt;">お名前フリガナ　　&lt;%_name%&gt;</option>
                                                  <option value="&lt;%mail%&gt;">メールアドレス　　&lt;%mail%&gt;</option>
                                                  <option value="&lt;%tel%&gt;">電話番号　　　　　&lt;%tel%&gt;</option>
                                                  <option value="&lt;%fax%&gt;">FAX番号 　　　　　&lt;%fax%&gt;</option>
                                                  <option value="&lt;%url%&gt;">URL 　　　　　　　&lt;%url%&gt;</option>
                                                  <option value="&lt;%code%&gt;">郵便番号　　　　　&lt;%code%&gt;</option>
                                                  <option value="&lt;%address%&gt;">都道府県　　　　　&lt;%address%&gt;</option>
                                                  <option value="&lt;%address1%&gt;">住所１　　　　　　&lt;%address1%&gt;</option>
                                                  <option value="&lt;%address2%&gt;">住所２　　　　　　&lt;%address2%&gt;</option>
                                                  <option value="&lt;%address3%&gt;">住所３　　　　　　&lt;%address3%&gt;</option>
                                                  <option value="&lt;%free1%&gt;">フリー項目１　　　&lt;%free1%&gt;</option>
                                                  <option value="&lt;%free2%&gt;">フリー項目２　　　&lt;%free2%&gt;</option>
                                                  <option value="&lt;%free3%&gt;">フリー項目３　　　&lt;%free3%&gt;</option>
                                                  <option value="&lt;%free4%&gt;">フリー項目４　　　&lt;%free4%&gt;</option>
                                                  <option value="&lt;%free5%&gt;">フリー項目５　　　&lt;%free5%&gt;</option>
                                                  <option value="&lt;%free6%&gt;">フリー項目６　　　&lt;%free6%&gt;</option>
                                                  <option value="&lt;%free7%&gt;">フリー項目７　　　&lt;%free7%&gt;</option>
                                                  <option value="&lt;%free8%&gt;">フリー項目８　　　&lt;%free8%&gt;</option>
                                                  <option value="&lt;%free9%&gt;">フリー項目９　　　&lt;%free9%&gt;</option>
                                                  <option value="&lt;%free10%&gt;">フリー項目１０　　&lt;%free10%&gt;</option>
                                                  <option value="&lt;%free11%&gt;">フリー項目１１　　&lt;%free11%&gt;</option>
                                                  <option value="&lt;%free12%&gt;">フリー項目１２　　&lt;%free12%&gt;</option>
                                                  <option value="&lt;%free13%&gt;">フリー項目１３　　&lt;%free13%&gt;</option>
                                                  <option value="&lt;%free14%&gt;">フリー項目１４　　&lt;%free14%&gt;</option>
                                                  <option value="&lt;%free15%&gt;">フリー項目１５　　&lt;%free15%&gt;</option>
                                                  <option value="&lt;%free16%&gt;">フリー項目１６　　&lt;%free16%&gt;</option>
                                                  <option value="&lt;%free17%&gt;">フリー項目１７　　&lt;%free17%&gt;</option>
                                                  <option value="&lt;%free18%&gt;">フリー項目１８　　&lt;%free18%&gt;</option>
                                                  <option value="&lt;%free19%&gt;">フリー項目１９　　&lt;%free19%&gt;</option>
                                                  <option value="&lt;%free20%&gt;">フリー項目２０　　&lt;%free20%&gt;</option>
                                                  <option value="&lt;%free21%&gt;">フリー項目２１　　&lt;%free21%&gt;</option>
                                                  <option value="&lt;%free22%&gt;">フリー項目２２　　&lt;%free22%&gt;</option>
                                                  <option value="&lt;%free23%&gt;">フリー項目２３　　&lt;%free23%&gt;</option>
                                                  <option value="&lt;%free24%&gt;">フリー項目２４　　&lt;%free24%&gt;</option>
                                                  <option value="&lt;%free25%&gt;">フリー項目２５　　&lt;%free25%&gt;</option>
                                                  <option value="&lt;%free26%&gt;">フリー項目２６　　&lt;%free26%&gt;</option>
                                                  <option value="&lt;%free27%&gt;">フリー項目２７　　&lt;%free27%&gt;</option>
                                                  <option value="&lt;%free28%&gt;">フリー項目２８　　&lt;%free28%&gt;</option>
                                                  <option value="&lt;%free29%&gt;">フリー項目２９　　&lt;%free29%&gt;</option>
                                                  <option value="&lt;%free30%&gt;">フリー項目３０　　&lt;%free30%&gt;</option>
END

sub remakeTag
{
	my $option = &Click'getTag();
	$mail_reflect_tag .= "\n". $option;
}
1;
