#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require("sqlite3")
require("cgi")

s=CGI.new
id_num=(s["id"])
count=0



print("Content-Type: text/html; charset=utf-8\n")
print("\n")
print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n")
print(" \"http://www.w3.org/TR/html4/strict.dtd\">\n")
print("<html>\n")
print("<head>\n")
print('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">')
print("\n")
print("<title>詳細データ</title>\n")
print("</head>\n")
print("<body>\n")

#printf("id=%d\n",id_num.to_i)

db=SQLite3::Database.new("issn.db")
#db.transaction{
  #db.execute("select * from issndb where id = ?;",id_num){|row|

#if row[2]!=nil then
#printf('<div><a href='"http://komorido.nims.go.jp/~a012427/issn.cgi?search=%s"'>Top</a></div>',row[2])
#else
#printf('<div><a href='"http://komorido.nims.go.jp/~a012427/issn.cgi?search=%s"'>Top</a></div>',row[3])
#end
#  printf("<p><b>ID:</b>%d</p>\n",row[0])
#printf("<p><b>Title:</b>%s</p>\n",row[1])
#printf("<p><b>PrintISSN:</b>%s</p>\n",row[2])
#printf("<p><b>OnlineISSN:</b>%s</p>\n",row[3])
#printf('<div><a href='"http://komorido.nims.go.jp/~a012427/edit.cgi?id=%d"'>編集</a></div>',row[0])
#printf('<a href="javascript:history.back();">戻る</a>')
db.execute("select resource.id,resource.title,identifier.id_type,identifier.body from resource left join identifier on resource.id=identifier.resource_id where resource.id=?;",id_num.to_i){|row|


if count==0 then
printf('<div><a href='"./issn.cgi?search=%d"'>Top</a></div>',row[0])
printf("<p><b>ID:</b>%d</p>\n",row[0])
printf("<p><b>Title:</b>%s</p>\n",CGI.escapeHTML(row[1]))
count=1
end

case row[2]
when "online_issn" then
printf("<p><b>%s:</b>"'<a href='"http://komorido.nims.go.jp/erms/journals?query=%s"'>%s</a>'"</p>",CGI.escapeHTML(row[2].to_s),CGI.escapeHTML(row[3].to_s),CGI.escapeHTML(row[3].to_s))
when "print_issn" then
printf("<p><b>%s:</b>"'<a href='"https://library.nims.go.jp/manifestations?query=%s"'>%s</a>'"</p>",CGI.escapeHTML(row[2].to_s),CGI.escapeHTML(row[3].to_s),CGI.escapeHTML(row[3].to_s))
when "doi" then
printf("<p><b>%s:</b>"'<a href='"http://dx.doi.org/%s"'>%s</a>'"</p>",CGI.escapeHTML(row[2].to_s),CGI.escapeHTML(row[3].to_s),CGI.escapeHTML(row[3].to_s))
else
printf("<p><b>%s:</b></p>",CGI.escapeHTML(row[2].to_s),CGI.escapeHTML(row[3].to_s))
end

#printf("<p><b>%s:</b>%s</p>\n",CGI.escapeHTML(row[2].to_s),CGI.escapeHTML(row[3].to_s))

}
#}
db.close



printf('<a href='"./edit.cgi?id=%d"'>編集</a>'"\n",id_num.to_i)
printf('<a href="javascript:history.back();">戻る</a>'"\n")



print("</body>\n")
print("</html>\n")
