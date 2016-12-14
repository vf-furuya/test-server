<?php
/**
言語コード	表示言語	言語名 
is	en	アイスランド語
ga	en	アイルランド語
af	en	アフリカーンス語
sq	en	アルバニア語
it	en	イタリア語
id	en	インドネシア語
uk	en	ウクライナ語
nl	en	オランダ語
nl-BE	en	オランダ語/ベルギー語
ca	en	カタロニア語
gl	en	ガリチア語
el	en	ギリシア語
hr	en	クロアチア語
sv	en	スウェーデン語
gd	en	スコッチ ゲール語
es	en	スペイン語
es-AR	en	スペイン語/アルゼンチン
es-CO	en	スペイン語/コロンビア
es-ES	en	スペイン語/スペイン
es-MX	en	スペイン語/メキシコ
sk	en	スロヴァキア語
sl	en	スロヴェニア語
sr	en	セルビア語
cs	en	チェコ語
da	en	デンマーク語
de	en	ドイツ語
de-AU	en	ドイツ語/オーストリア
de-CH	en	ドイツ語/スイス
de-DE	en	ドイツ語/ドイツ
tr	en	トルコ語
no	en	ノルウェー語
eu	en	バスク語
hu	en	ハンガリー語
fi	en	フィンランド語
fo	en	フェロー語
fr	en	フランス語
fr-CA	en	フランス語/カナダ
fr-CH	en	フランス語/スイス
fr-FR	en	フランス語/フランス
fr-BE	en	フランス語/ベルギー
bg	en	ブルアリア語
pl	en	ポーランド語
pt	en	ポルトガル語
pt-BR	en	ポルトガル語/ブラジル
mk	en	マケドニア語
ro	en	ルーマニア語
ru	en	ロシア語
en	en	英語
en-GB	en	英語/英国
en-US	en	英語/米国
ko	en	韓国語
zh	en	中国語
zh-TW	en	中国語/台湾
zh-CN	en	中国語/中国
ja	ja	日本語
be	en	白ロシア語
*/



$LANGDEF = array(
	 'is'=>'en'			// アイスランド語
	,'ga'=>'en'			// アイルランド語
	,'af'=>'en'			// アフリカーンス語
	,'sq'=>'en'			// アルバニア語
	,'it'=>'en'			// イタリア語
	,'id'=>'en'			// インドネシア語
	,'uk'=>'en'			// ウクライナ語
	,'nl'=>'en'			// オランダ語
	,'nl-BE'=>'en'		// オランダ語/ベルギー語
	,'ca'=>'en'			// カタロニア語
	,'gl'=>'en'			// ガリチア語
	,'el'=>'en'			// ギリシア語
	,'hr'=>'en'			// クロアチア語
	,'sv'=>'en'			// スウェーデン語
	,'gd'=>'en'			// スコッチ ゲール語
	,'es'=>'en'			// スペイン語
	,'es-AR'=>'en'		// スペイン語/アルゼンチン
	,'es-CO'=>'en'		// スペイン語/コロンビア
	,'es-ES'=>'en'		// スペイン語/スペイン
	,'es-MX'=>'en'		// スペイン語/メキシコ
	,'sk'=>'en'			// スロヴァキア語
	,'sl'=>'en'			// スロヴェニア語
	,'sr'=>'en'			// セルビア語
	,'cs'=>'en'			// チェコ語
	,'da'=>'en'			// デンマーク語
	,'de'=>'en'			// ドイツ語
	,'de-AU'=>'en'		// ドイツ語/オーストリア
	,'de-CH'=>'en'		// ドイツ語/スイス
	,'de-DE'=>'en'		// ドイツ語/ドイツ
	,'tr'=>'en'			// トルコ語
	,'no'=>'en'			// ノルウェー語
	,'eu'=>'en'			// バスク語
	,'hu'=>'en'			// ハンガリー語
	,'fi'=>'en'			// フィンランド語
	,'fo'=>'en'			// フェロー語
	,'fr'=>'en'			// フランス語
	,'fr-CA'=>'en'		// フランス語/カナダ
	,'fr-CH'=>'en'		// フランス語/スイス
	,'fr-FR'=>'en'		// フランス語/フランス
	,'fr-BE'=>'en'		// フランス語/ベルギー
	,'bg'=>'en'			// ブルアリア語
	,'pl'=>'en'			// ポーランド語
	,'pt'=>'en'			// ポルトガル語
	,'pt-BR'=>'en'		// ポルトガル語/ブラジル
	,'mk'=>'en'			// マケドニア語
	,'ro'=>'en'			// ルーマニア語
	,'ru'=>'en'			// ロシア語
	,'en'=>'en'			// 英語
	,'en-GB'=>'en'		// 英語/英国
	,'en-US'=>'en'		// 英語/米国
	,'ko'=>'en'			// 韓国語
	,'zh'=>'en'			// 中国語
	,'zh-TW'=>'en'		// 中国語/台湾
	,'zh-CN'=>'en'		// 中国語/中国
	,'ja'=>'en'			// 日本語
	,'be'=>'en'			// 白ロシア語
);

$LOCALEDEF = array(
	 'en'=>'en_US'
	,'ja'=>'ja_JP'
	,'de'=>'de_DE'
	,'it'=>'it_IT'
	,'fr'=>'fr_FR'
);

class ASLanguage {
	function getAcceptLanguage() {
		$acceptLanguage = $_SERVER['HTTP_ACCEPT_LANGUAGE'];

		if (!$acceptLanguage || strlen(trim(acceptLanguage))==0) {
			$acceptLanguage = 'en';

		} else {
			$langArray = explode(",", $acceptLanguage, 2);
			$acceptLanguage = $langArray[0];
		}
		if (!$acceptLanguage) {
			$acceptLanguage = 'en';
		}

		return $acceptLanguage;
	}

	function getDisplayLanguage($acLng=NULL) {
		if ($acLng==NULL) {
			$acLng = self::getAcceptLanguage();
		}
		$displayLanguage = $GLOBALS['LANGDEF'][$acLng];

		if (!$displayLanguage) {
			$displayLanguage = 'en';
		}

		return $displayLanguage;
	}

	function formatMoney($value, $Locale=NULL) {
		$moneyLocale = $Locale!=NULL ? $Locale : $GLOBALS['LOCALEDEF'][self::getDisplayLanguage()];
		setlocale(LC_MONETARY, $moneyLocale);
		return preg_replace("/[^0-9\.\,\-]/", "", money_format("%i", $value));
	}

}

?>
