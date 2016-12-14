<?php
/**
 * ASGMailPopクラス
 *
 * GMail専用でPOP通信を行うクラス
 *
 * @package 
 * @access  public
 * @author  TakanoriYAMAZAKI <yamazaki@assiette.co.jp>
 * @create  2010/05/06
 * @depend  PEAR::Net/POP3
 * @version 0.1
 * description 使い方。
 *

	$gm = new GMailPop($user, pass);

	while (true) {
		// 毎回Connect()する
		$gm->Connect();

		// 一覧は最大で 296件しか取得できない
		$message_list = $gm->getList();
		if ($message_list) {
			foreach ($message_list as $k=>$message) {
				$subject = $gm->parseSubject($gm->getHeader($message['msg_id']));
				$body = $gm->getBody($message['msg_id']);

				// いろいろ処理

			}
		} else {
			break;
		}
		// Disconnectすることで、既読マークをサーバーに反映させる
		$gm->Disconnect();
	}

 **/

define ("EXIST_CLASS_GMAILPOP","yes");

class ASGmailPOP {

	const _GMAIL_POP_SERVER = 'ssl://pop.gmail.com';
	const _GMAIL_POP_PORT   = '995';

	/**
	 * Instance of Net/POP3 class
	 */
	var $_pop3;

	/**
	 * Authentication
	 */
	var $username;
	var $password;


	/**
	 * Construct
	 * 
	 * @param user_id string gmailのアカウント名
	 * @param user_pw string gmailのパスワード
	 */
	public function ASGmailPOP($user_id,$user_pw) {
		if (!class_exists('Net_POP3')) {
			require_once("Net/POP3.php");
		}

		$this->setLoginInfo($user_id, $user_pw);
		$this->_pop3 = new Net_POP3();
	}

	protected function setLoginInfo($user_id, $user_pw) {
		$this->username = $user_id;
		$this->password = $user_pw;
	}

	public function Connect() {
		try {
			if (!$this->_pop3->connect(self::_GMAIL_POP_SERVER, self::_GMAIL_POP_PORT)) {
				// connection failed.
				Logger::error("ASGmailPOP::Connect  Connection failed.");
				return FALSE;
			}
			if (!$this->_pop3->login($this->username, $this->password)) {
				// Login failure.
				Logger::error("ASGmailPOP::Connect  Login failed.");
				return FALSE;
			}

			return TRUE;
		} catch (Exception $e) {
			Logger::error($e);
			return false;
		}

	}

	public function Disconnect() {
		return $this->_pop3->disconnect();
	}

	/**
	 * LIST取得
	 * 
	 * @param msg_id string 指定された場合は特定のmsg_idをもつメッセージの情報だけを返す
	 * @return array [:msg_id],[:size],[:uidl] の３つの属性をもつ配列を返す
	 * 
	 */
	public function getList($msg_id=null) {
		return $this->_pop3->getListing($msg_id);
	}

	/**
	 * メッセージの件数を取得
	 * 
	 * @return int メッセージ件数
	 */
	public function numMsg() {
		return $this->_pop3->numMsg();
	}

	/**
	 * ヘッダ情報の取得
	 * 
	 * @param msg_id string 指定された場合は特定のメッセージのヘッダを取得。指定のない場合は全メッセージのヘッダ情報を一覧で返す
	 * @return mixed ヘッダ情報
	 * 
	 */
	public function getHeader($msg_id=null) {

		if ($msg_id==NULL) {
			$message_list = $this->getList();
			if ($message_list) {
				foreach ($message_list as $k=>$message) {
					$headers[] = $this->_pop3->getParsedHeaders($msg_id);
				}

				return $headers;

			} else {
				return array();
			}

		} else {
			$message_list = $this->getList($msg_id);
			if ($message_list) {
				return $this->_pop3->getParsedHeaders($msg_id);
			}
		}

	}

	/**
	 * 本文の取得（自動的に既読にマークされる）
	 * 
	 * @param msg_id string メッセージID
	 * @return string デコードされた本文
	 */
	public function getBody($msg_id) {
		$body = $this->_pop3->getBody($msg_id);
		$body = mb_convert_encoding($body, mb_internal_encoding(), "auto");
		return $body;
	}

	/**
	 * 取得したヘッダ情報からsubjectをデコードして返す
	 *
	 * @param header array ヘッダ
	 * @return string subject文字列
	 */
	public function parseSubject($header) {
		return mb_decode_mimeheader($header['Subject']);
	}

	/**
	 * 取得したヘッダ情報から from をデコードして返す
	 *
	 * @param header array ヘッダ
	 * @return string from文字列
	 */
	public function parseFrom($header) {
		return mb_decode_mimeheader($header['From']);
	}


}
?>
