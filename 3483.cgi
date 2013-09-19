#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require("sqlite3")
require("cgi")

s=CGI.new
issn_num=(s["issn"])

print("Content-Type: text/html; charset=utf-8\n")
print("\n")
print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n")
print(" \"http://www.w3.org/TR/html4/strict.dtd\">\n")
print("<html>\n")
print("<head>\n")
print('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">')
print("\n")
print("<title>ISSN検索システム</title>\n")
print("</head>\n")
print("<body>\n")
print('<form method="GET" action="issn.cgi">')
print("\n")
print('ISSN検索: <input type="text" name="issn" value="'+"#{issn_num}"+'"  size="20"><br>')
#print('ISSN検索: <input type="text" name="issn" value="'+s["issn"]+'"  size="20"><br>')
print("\n")
print('<input type="submit" value="検索">')
print("\n")
print('<input type="reset" value="クリア">')
print("\n")
print("</form>")
print('<table border="1"><tr><th>ID</th><th>Title</th><th>PrintISSN</th><th>OnlineISSN</th></tr>')
print("\n")
printf("issn=%s\n",CGI.escapeHTML(issn_num))


db=SQLite3::Database.new("issn.db")
db.transaction{
  db.execute("select * from issndb where print_issn like ? or online_issn like ?;",issn_num,issn_num){|row|
    printf("<tr><td>%d</td><td>%s</td><td>"'<a href='"https://library.nims.go.jp/manifestations?query=%s"'>%s</a>'"</td><td>"'<a href='"http://komorido.nims.go.jp/erms/journals?query=%s"'>%s</a>'"<td></tr>",row[0],row[1],row[2],row[2],row[3],row[3])
         }
}
db.close

print("</table>\n")
print("</body>\n")
print("</html>")