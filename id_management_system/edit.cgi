#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require("sqlite3")
require("cgi")

s=CGI.new
id_num=(s["id"])
count=0
id_type_kind=["online_issn","print_issn","doi","online_isbn","print_isbn"]
id_type_flag=0


print("Content-Type: text/html; charset=utf-8\n")
print("\n")
print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n")
print(" \"http://www.w3.org/TR/html4/strict.dtd\">\n")
print("<html>\n")
print("<head>\n")
print('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">')
print("\n")
print("<title>編集ページ</title>\n")
print("</head>\n")
print("<body>\n")


db=SQLite3::Database.new("issn.db")
db.transaction{
#  db.execute("select * from issndb where id like ?;",id_num){|row|

#if row[2]!=nil then
#printf('<div><a href='"http://komorido.nims.go.jp/~a012427/issn.cgi?issn=%s"'>Top</a></div>',row[2])
#else
#printf('<div><a href='"http://komorido.nims.go.jp/~a012427/issn.cgi?issn=%s"'>Top</a></div>',row[3])
#end

#print('<form method="POST" action="update.cgi">')
#print("\n")
#    printf('<p><b>ID:</b> <input type="text" name="id" value="'+"%d"+'"  size="20" class="text_id"></p>',row[0])
#    printf('<p><b>Title:</b> <input type="text" name="title" value="'+"%s"+'"  size="20"></p>',row[1])
#    printf('<p><b>PrintISSN:</b> <input type="text" name="print_issn" value="'+"%s"+'"  size="20"></p>',row[2])
#    printf('<p><b>OnlineISSN:</b> <input type="text" name="online_issn" value="'+"%s"+'"  size="20"></p>',row[3])
#print("\n")
#print('<input type="submit" value="更新">')
#print(' <input type="button" value="戻る" onClick="history.back()">')

#print("\n")
#print("</form>")


id_type_kind.each{|type|
    db.execute("select * from identifier where resource_id=? and id_type=?;",id_num.to_i,type.to_s){|row|
  id_type_flag=1
    }

if id_type_flag==0 then
 db.execute("insert into identifier values (NULL,?,?,?);",id_num.to_i,type.to_s,"")
end
id_type_flag=0
}


db.execute("select resource.id,resource.title,identifier.id_type,identifier.body from resource left join identifier on resource.id=identifier.resource_id where resource.id=?;",id_num){|row|

if count==0 then
print('<form method="POST" action="update.cgi">')
printf('<div><a href='"./issn.cgi?search=%d"'>Top</a></div>',row[0])
print("<p><b>ISBN,ISSNは‐(ハイフン)無しで入力すること</b></p>")

 printf('<p><b>ID:</b>%d (IDは変更できません)</p>',row[0])
 printf('<input type="hidden" name="id" value="'+"%d"+'"  size="20" class="text_id">',row[0])
 printf('<p><b>Title:</b> <input type="text" name="title" value="'+"%s"+'"  size="20"></p>',row[1])
count=1
end
 printf('<p><b>%s:</b> <input type="text" name="%s" value="'+"%s"+'"  size="20"></p>',row[2],row[2],row[3])

  }
}
db.close

print('<input type="submit" value="更新">')
print(' <input type="button" value="戻る" onClick="history.back()">')
print("</form>\n")
print("</body>\n")
print("</html>\n")
