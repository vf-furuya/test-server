<?php
// メール解析クラス
class popmail_parse
{
	var $plain, $header, $body;
	var $content_type, $content_subtype, $content_param, $content_encoding;
	var $content_disposition, $content_sub_disposition;
	var $to, $from, $msgid, $datetime, $subject;

	function popmail_parse($plain = '')
	{
		unset($this->plain);
		unset($this->header);
		unset($this->body);
		unset($this->content_type);
		unset($this->content_subtype);
		unset($this->content_param);
		unset($this->content_encoding);
		unset($this->content_disposition);
		unset($this->content_sub_disposition);
		unset($this->to);
		unset($this->from);
		unset($this->msgid);
		unset($this->datetime);
		unset($this->subject);
		$this->plain = $plain;
	}

	function analyze($plain = NULL)
	{
//global //$myLog;
		//
		//  Header 及び body の分離
		//
		if($plain!='')
		{
			$this->plain = $plain;
		}
		$ex = explode( "\r\n\r\n" , $this->plain , 2 ); 
		$header_temp = $ex[0];
		$body_temp   = $ex[1];
//$myLog->error($body_temp);

		if ($body_temp == NULL) {
			$ex = explode( "\n\n" , $this->plain , 2 ); 
			$header_temp = $ex[0];
			$body_temp   = $ex[1];
		}

//$myLog->error($body_temp);

		//
		// マルチラインヘッダーの正規化
		//
		$header_array = explode( "\n" , $header_temp );
		$this->header = '';
		foreach( $header_array as $hl )
		{
			$matches = array();
			if( preg_match("/^((?:\s|\t)+)(.*)/",$hl,$matches )==True )
			{
				$this->header .= trim($matches[2]);
			}
			else
			{
				$this->header .= "\n".trim($hl);
			}
		}
		$this->header .= "\n";
		$this->body    = $body_temp;
//$myLog->error($this->body);
		//
		// Content-Type: のチェック
		//

		$this->header = str_replace("Content-Type:", "Content-Type: ", $this->header);
		$this->header = str_replace("Content-Type:  ", "Content-Type: ", $this->header);
		$this->header = str_replace("Content-Type: multipart/related;Type=\"multipart/alternative\";", "Content-Type: multipart/mixed;", $this->header);
		if( preg_match("/[\^\n]content-type: (\S+)\/(\S+)\s*;\s*(.*)/i",$this->header,$match)==True )
		{
			$this->content_type    = $match[1];
			$this->content_subtype = $match[2];
			$this->content_param   = $match[3];
		}

		//
		// Content-Transfer-Encoding: のチェック
		//
		$this->header = str_replace("Content-Transfer-Encoding:", "Content-Transfer-Encoding: ", $this->header);
		$this->header = str_replace("Content-Transfer-Encoding:  ", "Content-Transfer-Encoding: ", $this->header);
		if( preg_match("/[\^\n]content-transfer-encoding: (\S+)/i",$this->header,$match)==True )
		{
			$this->content_encoding = $match[1];
			//echo $this->content_encoding."/ ";
		}

		// Content-Disposition: のチェック
		$this->header = str_replace("Content-Disposition:", "Content-Disposition: ", $this->header);
		$this->header = str_replace("Content-Disposition:  ", "Content-Disposition: ", $this->header);
		if( preg_match("/[\^\n]content-disposition: (\w+)\s*;\s*(.+)/i",$this->header,$match)==True )
		{
			$this->content_disposition     = $match[1];
			$this->content_sub_disposition = $match[2];
		}

		
		//
		// To: のチェック
		//
		if( preg_match("/[\^\n]to:\s+<([\w\.\-]+@[\w\.\-]+)>/i",$this->header,$match)==True )
		{
			$this->to = $match[1];
		}
		else if( preg_match("/[\^\n]to:\s+([\w\.\-]+@[\w\.\-]+)/i",$this->header,$match)==True )
		{
			$this->to = $match[1];
		}

		//
		// From: のチェック
		//
		if( preg_match("/[\^\n]from:\s+.*<([\w\.\-]+@[\w\.\-]+)>/i",$this->header,$match)==True )
		{
			$this->from = $match[1];
		}
		else if( preg_match("/[\^\n]from:\s+([\w\.\-]+@[\w\.\-]+)/i",$this->header,$match)==True )
		{
			$this->from = $match[1];
		}

		//
		// Message-Id: のチェック
		//
		if( preg_match("/[\^\n]message-id:[ \t]*([^\r\n]+)/i",$this->header,$match)==True )
		{
			$this->msgid = $match[1];
		}

		// 日付の抽出
		$this->datetime = -1;
		if( preg_match("/[\^\n]date:[ \t]*([^\r\n]+)/i",$this->header,$match)==True )
		{
			$this->datetime = strtotime($match[1]);
		}
		if ($this->datetime == -1)
		{
			$this->datetime = time();
		}

		// サブジェクトの抽出
		if (eregi("\nSubject:[ \t]*([^\r\n]+)", $this->header, $subreg))
		{
			// =?iso-2022-jp～ をデコードする
			$this->subject = $this->text_decode($subreg[1]);
		}

		//
		// Multipartチェック(RFC2046)
		// （再帰呼び出し）
		//
		$content = strtolower($this->content_type) . "/" . strtolower($this->content_subtype);
		//echo $content . "\n\n";
		if( $content=="multipart/mixed"    || $content=="multipart/alternative" ||
			$content=="multipart/parallel" || $content=="multipart/digest")
		{
			//$myLog->error($content);
			if( preg_match('/boundary="([^"]+)"/i' , $this->content_param , $match ) )
			{
				$boundary = '--'.$match[1];
			//$myLog->error($boundary);
			}
			else
			{
				return FALSE;
			}
			// echo "(!) Boundary => (" . $boundary . ")\n";
			$bounding_array = explode( $boundary , $this->body );

			$result = array();
			//$myLog->error(count($bounding_array));
			foreach( $bounding_array as $id => $bounding_body )
			{
			//$myLog->error("a");
				if( $id==0 ) continue;
				if( preg_match('/^--/',$bounding_body) )
				{
			//$myLog->error("b");
					break;
				}
				$bbody = new popmail_parse($bounding_body);
			//$myLog->error("c");
				$r     = $bbody->analyze();
			//$myLog->error("d");
				if($r!=FALSE)
				{
			//$myLog->error("e");
					foreach( $r as $key => $data )
					{
						$result[] = $data;
					}
				}
			}
			return $result;
		}

		//
		// BASE64 / uuencode
		//
		if( $this->content_encoding=="base64" )
		{
			$data = base64_decode($this->body);
		}
		else if( $this->content_encoding=="quoted-printable" )
		{
			$data = quoted_printable_decode($this->body);
		}
		else
		{
			$data = $this->body;
		}

		if($content=="text/plain")
		{
			if(function_exists('mb_convert_encoding'))
			{
				// テキストを変換する
				$data = mb_convert_encoding($data, "UTF-8", "auto");
			}
		}

		$filename = '';
		if( preg_match("/name\=\"(.+)\"/i",$this->content_param,$match)==True )
		{
			// Content-Type: にname指定あり
			$filename = $match[1];
		}
		else if ( preg_match("/name\=(.+)/i",$this->content_param,$match)==True )
		{
			// Content-Type: にname指定あり
			$filename = $match[1];
		}

		if( isset($this->content_sub_disposition)
			&& preg_match("/filename\=\"(.+)\"/i",$this->content_sub_disposition,$match)==True )
		{
			// こちらがContent-Typeの指定より優先される
			// Content-Disposition: にfilename指定あり
			$filename = $match[1];
		}
		// ファイル名を変換する
		$filename = $this->text_decode($filename);
		$result[] = array("Content-Type" => $content  ,
					"Body"         => $data ,
					"Filename"     => $filename);
		return $result;
	}

	function to()
	{
		return $this->to;
	}

	function from()
	{
		return $this->from;
	}

	function msgid()
	{
		return $this->msgid;
	}

	function datetime()
	{
		return strftime("%Y/%m/%d %H:%M:%S",$this->datetime);
	}

	function date()
	{
		return strftime("%Y-%m-%d",$this->datetime);
	}

	function body()
	{
		return $this->body;
	}

	function header()
	{
		return $this->header;
	}

	function subject()
	{
		return $this->subject;
	}

	function content_type()
	{
		return $this->content_type."/".$this->content_subtype;
	}

	function text_decode($str)
	{
		//MIME Bデコ－ド
		while (eregi("(.*)=\?iso-2022-jp\?B\?([^\?]+)\?=(.*)",$str,$regs))
		{
			$str = $regs[1].base64_decode($regs[2]).$regs[3];
		}
		//MIME Qデコ－ド
		while (eregi("(.*)=\?iso-2022-jp\?Q\?([^\?]+)\?=(.*)",$str,$regs))
		{
			$str = $regs[1].quoted_printable_decode($regs[2]).$regs[3];
		}
		if(function_exists('mb_convert_encoding'))
		{
			$str = mb_convert_encoding($str, "UTF-8", "JIS");
		}

		return htmlspecialchars($str);
	}
}
?>
