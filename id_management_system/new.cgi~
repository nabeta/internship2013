#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require("sqlite3")
require("cgi")

s=CGI.new

print("Content-Type: text/html; charset=utf-8\n")
print("\n")
print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n")
print(" \"http://www.w3.org/TR/html4/strict.dtd\">\n")
print("<html>\n")
print("<head>\n")
print('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">')
print("\n")
print("<title>新規作成ページ</title>\n")


print('<script type="text/javascript">'"\n") 
print('<!--'"\n")
print('function check(){'"\n")
#設定開始（必須にする項目を設定）
print('if (document.form.title.value == ""){'"\n")
print('window.alert("必須項目に未入力がありました");'"\n")# 入力漏れがあれば警告ダイアログを表示
print('return false;'"\n")
print('}'"\n") # 送信を中止
print('else{'"\n"'return true;'"\n")
print('}'"\n"'}'"\n") # 送信を実行
print('// -->'"\n")
print("</script>\n")


print("</head>\n")
print("<body>\n")

print('<form method="POST" action="create.cgi" name="form" onSubmit="return check()" >'"\n")
print('<div><a href='"http://komorido.nims.go.jp/~a012427/issn.cgi"'>Top</a></div>'"\n")
print("<p><b>ISBN,ISSNは‐(ハイフン)無しで入力すること</b></p>")
print("\n")
print('<p><b>Title:</b> <input type="text"  name="title"  size="20"> (必須) </p>'"\n")
print('<p><b>PrintISSN:</b> <input type="text" name="print_issn"  size="20"></p>'"\n")
print('<p><b>OnlineISSN:</b> <input type="text" name="online_issn"  size="20"></p>'"\n")
print('<p><b>PrintISBN:</b> <input type="text" name="print_isbn"  size="20"></p>'"\n")
print('<p><b>OnlineISBN:</b> <input type="text" name="online_isbn"  size="20"></p>'"\n")
print('<p><b>DOI:</b> <input type="text" name="doi"  size="20"></p>'"\n")

print('<input type="submit" value="新規作成">'"\n")
print('<input type="button" value="戻る" onClick="history.back()">'"\n")
print("</form>\n")
print("</body>\n")
print("</html>\n")
