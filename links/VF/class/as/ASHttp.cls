<?php
/**
 * ASHttpクラス
 *
 * HTTP通信を行うクラス
 * GETパラメータはもちろん、POST/COOKIE/BASIC認証パラメータなどを任意に送出可能
 *
 * @package 
 * @access  public
 * @author  MasahitoSAMEKAWA <masahito@assiette.net>
 * @create  2004/10/19
 * @version 0.1
 **/

define ("EXIST_CLASS_ASHTTP","yes");

class ASHttp {
	/*
	 * アクセス先URL
	*/
	var $URL;
	/*
	 * リクエストメソッド
	*/
	var $Method;
	/*
	 * 追加ヘッダ
	*/
	var $Headers;
	/*
	 * ポストパラメータ
	*/
	var $Post;
	/*
	 * クッキーパラメータ
	*/
	var $Cookie;
	/*
	 * タイムアウトすべき時間
	*/
	var $TimeOut;
	/*
	 * 利用すべきUserAgent
	*/
	var $UserAgent;

	/*
	 * レスポンスステータス
	*/
	var $Status;


	/*
	 * リクエストヘッダ
	*/
	var $RequestHeader;
	/*
	 * レスポンスヘッダ
	*/
	var $ResponseHeader;
	/*
	 * レスポンス本文
	*/
	var $Response;

	/*
	 * エラーメッセージ
	*/
	var $Err;

	/**
	 * コンストラクタ
	 * 処理は特にナシ
	 * @access		public
	*/
	function ASHttp(){
	}

	/*
		$url		: http://から始まるURL( http://user:pass@host:port/path?query )
		$method		: GET, POST, HEADのいずれか(デフォルトはGET)
		$headers	: 任意の追加ヘッダ
		$post		: POSTの時に送信するデータを格納した配列("変数名"=>"値")
	*/
	function http()
	{
		if ($this->URL == NULL) {
			$this->Err = "URL Parameter is required. ";
			return FALSE;
		}

		if ($this->Method == NULL) $this->Method = 'GET';
		if ($this->Post == NULL || !is_array($this->Post)) $this->Post = array();
		if ($this->Cookie == NULL || !is_array($this->Cookie)) $this->Cookie = array();
		if ($this->TimeOut == NULL) $this->TimeOut = 30;
		if ($this->UserAgent == NULL) $this->UserAgent = 'PHP HTTP Browser.';

		$this->Status = "ok";

		// URLを分解
		$URL = parse_url($this->URL);

		// クエリー
		if (isset($URL['query'])) {
			$URL['query'] = "?".$URL['query'];
		} else {
			$URL['query'] = "";
		}

		// デフォルトのポートは80
		if (!isset($URL['port'])) $URL['port'] = 80;

		// リクエストライン
		$request  = $this->Method." ".$URL['path'].$URL['query']." HTTP/1.0\r\n";

		// リクエストヘッダ
		$request .= "Host: ".$URL['host']."\r\n";
		$request .= "User-Agent: " . $this->UserAgent . "\r\n";

		// Basic認証用のヘッダ
		if (isset($URL['user']) && isset($URL['pass'])) {
			$request .= "Authorization: Basic ".base64_encode($URL['user'].":".$URL['pass'])."\r\n";
		}

		// COOKIEのヘッダ
		if (count($this->Cookie) > 0) {
			$request .= "Cookie: ";
			while (list($name, $value) = each($this->Cookie)) 
				$COOKIE[] = $name."=".urlencode($value);
			$cookiedata = implode("; ", $COOKIE);
			$request .= $cookiedata . "\r\n";
		}

		// 追加ヘッダ
		$request .= $this->Headers;

		// POSTの時はヘッダを追加して末尾にURLエンコードしたデータを添付
		if (strtoupper($this->Method) == "POST") {
			while (list($name, $value) = each($this->Post)) {
				$POST[] = $name."=".urlencode($value);
			}
			$postdata = implode("&", $POST);
			$request .= "Content-Type: application/x-www-form-urlencoded\r\n";
			$request .= "Content-Length: ".strlen($postdata)."\r\n";
			$request .= "\r\n";
			$request .= $postdata;
		} else {
			$request .= "\r\n";
		}

		// WEBサーバへ接続
		if (!$fp = fsockopen($URL['host'], $URL['port'])){
			$this->Status = "unavailable";
		}
		else{
			// 要求データ送信
			fputs($fp, $request);

			// タイムアウトの指定
			socket_set_timeout($fp, $this->TimeOut);

			// 応答データ受信
			$response = "";
			$finishFlg = TRUE;
			while (!feof($fp) && $finishFlg) {
				$info = socket_get_status($fp);
				if ($info['timed_out'] == TRUE){
					$this->Status = 'timeout';
					$finishFlg = FALSE;
				}

				$response .= fgets($fp, 10240);
			}

			// 接続を終了
			fclose($fp);

			// ヘッダ部分とボディ部分を分離
			$DATA = split("\r\n\r\n", $response, 2);

			// リクエストヘッダをコメントアウトして出力
			//echo "<!--\n".$request."\n-->\n";
			$this->RequestHeader = $request;

			// レスポンスヘッダをコメントアウトして出力
			//echo "<!--\n".$DATA[0]."\n-->\n";
			$this->ResponseHeader = $DATA[0];

			// メッセージボディを出力
			//echo $DATA[1];
			$this->Response = $DATA[1];
		}

		return TRUE;
	}
}
?>
