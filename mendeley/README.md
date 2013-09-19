Welcome to the internship wiki!

#セルフアーカイブへの登録システム利用法 README
##始めに
このシステムは文献管理ツールMendeleyに登録されているグループライブラリー情報を、セルフアーカイブシステムPubManに自動的に登録することを目的として製作されています。利用するにはMendeleyAccount,MendeleyAPI,PubManAccountが必要です。  
持っていない場合、以下のリンクから各サイトに移動してアカウントもしくはAPIキーを取得してください。  
  
Mendeley：<http://www.mendeley.com/>  
Mendeley Developers Portal:<http://dev.mendeley.com/>  
PubMan：<http://amaayo.nims.go.jp:8080/pubman/faces/HomePage.jsp>  

##使用言語およびライブラリ
Ruby1.9.3  

'json'ライブラリ  
'oauth'ライブラリ  
'oauth/consumer'ライブラリ  
'tempfile'ライブラリ  
'net/http'ライブラリ  
'yaml'ライブラリ  
'zip'ライブラリ  
ライブラリが無い場合には[こちら](https://www.ruby-lang.org/ja/libraries/ "ライブラリ")を参考にライブラリを追加してください。
##利用準備
Mendeley内のMy LibralyにPubManというフォルダを作成し、そこに登録したいファイルを追加してください。  
次に、プログラム作業ディレクトリ内にconfig.ymlとpubman.ymlというファイルを作成してください。  
ファイル内容は下記の記述例に従ってconfig.ymlにはconsumer_key,consumer_secret,access_key,access_secretを、pubman.ymlにはpubman_id,pubman_passをそれぞれYAMLで記述してください。  
YAMLが分からない場合には[こちら](http://ja.wikipedia.org/wiki/YAML "Wikipedia:YAML")
  
  
config.yml記述例  
consumer_key:(スペース)Mendeley Consumer Keyを入力  
consumer_secret:(スペース)Mendeley Consumer Secretを入力  
access_key:(スペース)Mendeley Access Keyを入力  
access_secret:(スペース)Mendeley Access Secretを入力  
   
pubman.yml記述例  
pubman_id:(スペース)PubMan User-idを入力  
pubman_pass:(スペース)PubMan Passwordを入力  
  
プログラムを実行する準備が整いました。  
いつでもプログラムが実行できます。

##動作概要
プログラムを実行すると自動ログイン作業を行います。  
ログイン後、PubManフォルダ検索、フォルダ内ドキュメント情報取得、ドキュメントダウンロード、ドキュメント書誌情報作成を自動で行います。  
各種ファイル作成後、PubManに自動で情報を登録し、プログラムは終了、ログアウトされます。  
**ドキュメントが存在しない場合には書誌情報のみが登録されます。**  
**ドキュメントに著者が存在しない、もしくは姓、名に入力漏れがある場合はPubManに情報は登録されません。**  
  
