<?php
/**
 * bit.ly を使った短縮URLのAPI呼び出しクラス
 * IDやAPIキーの取得はbit.lyを参照のこと
 * 
 * php 5.2 以上 (filter_var 利用のため) 推奨
 */

class ASShortURL {
	const VERSION = '2.0.1';
	const FORMAT = 'json';

	private static $NG_ACCOUNT;

	public static function shortenURL($url, $id, $apikey) {
		if (empty($url)) {
			return null;
		}
		if (empty($id) || empty($apikey)) {
			return $url;
		}

		if (preg_match('|^http://bit.ly/|', $url)) {
			return $url;
		}

		$input_url = strip_tags(trim($url));

		// 正しいURLであることを確認する
		if (phpversion() >= "5.2") {
			if(!filter_var($input_url, FILTER_VALIDATE_URL)){
				return null;
			}
		} else {
		}

		$url_enc = urlencode($url);
		$data = file_get_contents('http://api.bit.ly/shorten?version='.self::VERSION.'&longUrl='.$url_enc.'&login='.$id.'&apiKey='.$apikey.'&format='.self::FORMAT);
		$json = json_decode($data, true);

		return $json["results"][$url]["shortUrl"];
	}

	/**
	 * 複数のURLをまとめて短縮
	 * @param url array
	 */
	public static function shortenURLs($urls, $id, $apikey) {
		if (!is_array($urls) || count($urls)<1) {
			if (!empty($urls)) return self::shortenURL($urls, $id, $apikey);

			return null;
		}
		if (empty($id) || empty($apikey)) {
			return $urls;
		}

		$query = "";
		foreach ($urls as $url) {

			if (preg_match('|^http://bit.ly/|', $url)) {
				continue;
			}

			$input_url = strip_tags(trim($url));

			// 正しいURLであることを確認する
			if (phpversion() >= "5.2") {
				if(!filter_var($input_url, FILTER_VALIDATE_URL)){
					continue;
				}
			}

			$query .= "&longUrl=".urlencode($input_url);
		}

		if ($query!="") {
			$apiurl = 'http://api.bit.ly/shorten?version='.self::VERSION.$query.'&login='.$id.'&apiKey='.$apikey.'&format='.self::FORMAT;
			$data = file_get_contents($apiurl);
			$json = json_decode($data, true);

			return $json["results"];
		} else {
			return NULL;
		}
	}

	public static function isShortenURL($url) {
		return (substr($url, 0, 14)=="http://bit.ly/");
	}

	public static function getClicks($urls, $id, $apikey) {
		if (self::$NG_ACCOUNT[$id] == $apikey) {
			return FALSE;
		}

		if (empty($urls) || !is_array($urls) || count($urls)<1) {
			return null;
		}
		if (empty($id) || empty($apikey)) {
			return $url;
		}

		$urlparam = "";
		foreach ($urls as $url) {
			$urlparam .= "&shortUrl=".urlencode($url);
		}

		$apiurl = 'http://api.bit.ly/v3/clicks?login='.$id.'&apiKey='.$apikey.'&hash=logitter&format='.self::FORMAT.$urlparam;
		$data = file_get_contents($apiurl);
		$json = json_decode($data, true);

		// エラーなく処理できた場合
		if (200<=$json['status_code'] && $json['status_code']<=400) {
			return $json["data"]["clicks"];

		}
		// エラーコードが返ってきた
		else {
			self::$NG_ACCOUNT[$id] = $apikey;
			return FALSE;
		}

	}


	/**
	 * URLを含むテキストの中からURLを抽出し、短縮したURLと交換します。
	 * 
	 */
	public function shortenText($message) {
		if (preg_match_all("|https?://[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#]+|", $message, $matched)) {
			for ($i=0; $i<count($matched[0]); $i++) {
				$url = $matched[0][$i];

				if (!self::isShortenURL($url)) {
					$short_url = self::shortenURL($url);
					$message = str_replace($url, $short_url, $message);
				}
			}
		}

		return $message;
	}

	public static function validateAccount($id, $apikey) {
		if (empty($id) || empty($apikey)) {
			return FALSE;
		}

		$url = "http://api.bit.ly/v3/validate?x_login=notbilytapi&x_apiKey=not_apikey&apiKey=$apikey&login=$id&format=json";


		$data = file_get_contents($url);
		$json = json_decode($data, true);

		// エラーなく処理できた場合
		if (200<=$json['status_code'] && $json['status_code']<=400) {
			if ($json['data']['valid']==0 || $json['data']['valid']==1) {
				return TRUE;
			}
		}
		// エラーコードが返ってきた
		else {
			self::$NG_ACCOUNT[$id] = $apikey;
			return FALSE;
		}
	}

}

?>