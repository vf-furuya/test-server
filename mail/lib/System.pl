#---------------------------------------------------------------#
# カレントディレクトリ（設置のルートディレクトリ）の指定        #
#---------------------------------------------------------------#
$myroot = ( $myroot ne '' )? $myroot : '../'; # 最後に/を付ける

#---------------------------------------------------
# CGIスクリプト名
#---------------------------------------------------
$indexcgi = 'index.cgi';
$sendcgi = 'send.cgi';
$applycgi_name = 'apply.cgi';
$applycgi = $Pub'scriptName. $applycgi_name;
#---------------------------------------------------
# デザインテンプレート
#---------------------------------------------------
$DesignTemplate = 'DesignTemplate.csv';
$FormTemplate = 'BaseDesign.html';
$FormTemplate_mobile = 'BaseDesign_m.html';
# エラー出力用
$err = 'message.pl';
$err_m = 'message_m.pl'; # 携帯用

# データディレクトリのルートパス
$data_dir = 'data/';
# カレントディレクトリ$myrootからの相対パス（最後に/を付ける）

#---------------------------------------------------
# セットアップ制御ファイル(バージョンを格納)
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
# サーバー情報ファイル
#---------------------------------------------------
$DATA{'server'} = $myroot. $data_dir. 'server.cgi';

# sendmailパス予約
@SENDMAIL = ( '/usr/sbin/sendmail', '/usr/local/sendmail', '/usr/lib/sendmail' );


# 自動配信プラン配信ログを保存するディレクトリ
$log_dir = 'log/';
#（最後に/を付ける）

# 管理者情報用ファイル名
$admin_txt = 'admin.cgi';
# 配信プラン用ファイル名
$plan_txt = 'plan.cgi';

# 自動配信プランの内容を保存するディレクトリ
$queue_dir = 'queue/';
# （最後に/を付ける）

# 登録者リストCSVファイル保存用ディレクトリ
$csv_dir = 'csv/';
# （最後に/を付ける）

# テンプレートファイル保存用ディレクトリ
$template = 'template/';
# （最後に/を付ける）

# マニュアルページ保存用ディレクトリ
$manual = '../manual';
# index.cgiからの相対パス（最後に/を付けない）

# 送信方式設定ファイル名
$methodtxt = 'method.cgi';

# 一斉メール用
$simul_dir = 'simul/';

# フォーム生成用
$mkform_dir = 'mkform/';

# アクセス分析
$forward_dir = 'forward/';


#----------------------------------------------------
# 排他処理
#----------------------------------------------------

$lockdir  = 'lock/'; # （最後に/を付ける）
$lockfile = 'lock';    # ロック専用ファイル（ロック時はファイル名が変更される）

#----------------------------------------------------
# セッション
#----------------------------------------------------
$Session{'dir'} = $myroot . $data_dir;
$Session{'file'} = 'session.cgi';
$Session{'limit'} = 60; # 一時間
$Session{'cookie_id'} = 'SSID';

#---------------------------------------------------------------#
# 環境設定                                                      #
#---------------------------------------------------------------#

# 初期ユーザーＩＤ
$defid = 'id';
# 初期パスワード
$defpass = 'pass';

# 配信ログの最大保存数
$logmax = 2000;
# 配信ログの１ページの出力件数
$pagemax = 100;

#----------------------------------------------------
# HTMLファイル関連
#----------------------------------------------------

# スタイルシートのパス( or URL)
$css = 'ad_style.css';

#----------------------------------------------------
# 画像（任意のページで配信システムを稼動させる）
#----------------------------------------------------

# 画像ファイル名
$imagefile = 'space.gif';

# 画像保存ディレクトリ
$image_dir = '../images/';
# カレントディレクトリ(54行目に指定)内からの相対パス（最後に/を付ける）

$IMG_URL   = '';
# CGIを設置する専用ディレクトリがあり、かつそのディレクトリが
# 公開ディレクトリではない場合、画像保存ディレクトリのURLをhttpから
# 指定してください。
# HTML形式メール機能追加にともなう追加設定項目
# ※該当しない場合は未設定にしてください。

#----------------------------------------------------
# その他
#----------------------------------------------------

# 管理画面タイトル
$title = '[管理画面]';

# メール送信用ライブラリ
$mime = "${'myroot'}lib/mime_pls202/mimew.pl";

# セットアップエラー
$ErrorMessage{'001'} = '<strong>[ 成功 ]</strong>';
$ErrorMessage{'002'} = '<font color="#FF0000"><strong>[ 失敗 ]</strong></font><br>';
$ErrorMessage{'003'} = '見つかりません。<br>設置構成をご確認ください。';
$ErrorMessage{'004'} = '<font color="#FF0000">パーミッションを 700 or 705 に変更してください。</font>';
$ErrorMessage{'005'} = '<font color="#FF0000">パーミッションを 705 に変更してください。</font>';
$ErrorMessage{'006'} = '<font color="#FF0000">パーミッションを 707 に変更してください。</font>';

# 管理画面で利用する予約画像ファイル
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
