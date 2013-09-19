#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require("sqlite3")
require("cgi")
require("nkf")
require("csv")
require("tempfile")

w_id=nil
w_title=nil
w_id_type=nil
w_body=nil

s=CGI.new
s_id=[]
n=0
file_name="sample"

search_word=(s["search"])


print("Content-Type: text/html; charset=utf-8\n")
print("\n")
print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n")
print(" \"http://www.w3.org/TR/html4/strict.dtd\">\n")
print("<html>\n")
print("<head>\n")
print('<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">')
print("\n")
print("<title>情報検索システム</title>\n")
print("</head>\n")
print("<body>\n")
print('<form method="GET" action="issn.cgi">')
print("\n")
print('ID検索: <input type="text" name="search" value="'+"#{search_word}"+'"  size="20"><br>')
#print('ISSN検索: <input type="text" name="issn" value="'+s["issn"]+'"  size="20"><br>')
print("\n")
print('<input type="submit" value="検索">')
print("\n\n")
print('<a href='"http://komorido.nims.go.jp/~a012427/new.cgi"'>新規作成</a>')
print("\n")

#printf('<a href='"http://komorido.nims.go.jp%s"'>テスト用</a>'"\n",file.path.to_s)

print("</form>")
#print('<table border="1"><tr><th>ID</th><th>Title</th><th>PrintISSN</th><th>OnlineISSN</th></tr>')
print('<table border="1"><tr><th>ID</th><th>Title</th><th>ID_Type</th><th>ID_Value</th></tr>')
print("\n")
printf("search=%s\n",CGI.escapeHTML(search_word).to_s)


#Tempfile.open([file_name,'.csv']){|file|
#Tempfile.open(file_name,'w'){|file|
#p file.path
 
#p NKF.nkf("-sm0W8x","testestesあああ")
db=SQLite3::Database.new("issn.db")


#db.transaction{
#  db.execute("select * from issndb where print_issn = ? or online_issn = ?;",issn_num,issn_num){|row|
#    printf("<tr><td>%d</td><td>"'<a href='"http://komorido.nims.go.jp/~a012427/detail.cgi?id=%d"'>%s</a>'"</td><td>"'<a href='"https://library.nims.go.jp/manifestations?query=%s"'>%s</a>'"</td><td>"'<a href='"http://komorido.nims.go.jp/erms/journals?query=%s"'>%s</a>'"<td></tr>",row[0],row[0],row[1],row[2],row[2],row[3],row[3])
pass=nil
if search_word=="" then  

db.execute("select resource.id,resource.title,identifier.id_type,identifier.body from resource left join identifier on resource.id=identifier.resource_id "){|row|
printf("<tr><td>%d</td><td>",row[0])
printf('<a href='"http://komorido.nims.go.jp/~a012427/detail.cgi?id=%d"'>%s</a>',row[0],CGI.escapeHTML(row[1]))
printf("</td><td>%s",CGI.escapeHTML(row[2]))

Tempfile.open([file_name,'.csv']){|file|
w_id=row[0].to_i
w_title=NKF.nkf("-sm0W8x",row[1].to_s)
w_id_type=NKF.nkf("-sm0W8x",row[2].to_s)
w_body=NKF.nkf("-sm0W8x",row[3].to_s)


file.write(w_id)
file.write NKF.nkf("-sm0W8x","|")
file.write(w_title)
file.write NKF.nkf("-sm0W8x","|")
file.write(w_id_type)
file.write NKF.nkf("-sm0W8x","|")
file.write(w_body)
file.write("\n")
pass=file.path
FileUtils.cp file.path,'/home/a012427/public_html'+pass
FileUtils.chmod(0644,'/home/a012427/public_html'+pass)
    }

case row[2]
when "online_issn" then
printf("</td><td>"'<a href='"http://komorido.nims.go.jp/erms/journals?query=%s"'>%s</a>'"<td></tr>",CGI.escapeHTML(row[3]),CGI.escapeHTML(row[3]))
when "print_issn" then
printf("</td><td>"'<a href='"https://library.nims.go.jp/manifestations?query=%s"'>%s</a>'"<td></tr>",CGI.escapeHTML(row[3]),CGI.escapeHTML(row[3]))
when "doi" then
printf("</td><td>"'<a href='"http://dx.doi.org/%s"'>%s</a>'"<td></tr>",CGI.escapeHTML(row[3]),CGI.escapeHTML(row[3]))
else
printf("</td><td>%s<td></tr>",CGI.escapeHTML(row[3]))
end

}
db.close
else

db.execute("select distinct resource.id from resource left join identifier on resource.id=identifier.resource_id where identifier.body=? or identifier.id_type=? or resource.id=? or resource.title=? ;",search_word,search_word,search_word,search_word){|temp_id|
 s_id[n]=temp_id[0]
 n+=1
print("\n")
}


s_id.each{|each_id|
db.execute("select resource.id,resource.title,identifier.id_type,identifier.body from resource left join identifier on resource.id=identifier.resource_id where resource.id=?;",each_id){|row|
printf("<tr><td>%d</td><td>",row[0])
printf('<a href='"http://komorido.nims.go.jp/~a012427/detail.cgi?id=%d"'>%s</a>',row[0],CGI.escapeHTML(row[1]))
printf("</td><td>%s",CGI.escapeHTML(row[2]))

 Tempfile.open([file_name,'.csv']){|file|
w_id=row[0].to_i
w_title=NKF.nkf("-sm0W8x",row[1].to_s)
w_id_type=NKF.nkf("-sm0W8x",row[2].to_s)
w_body=NKF.nkf("-sm0W8x",row[3].to_s)

file.write(w_id)
file.write NKF.nkf("-sm0W8x","|")
file.write(w_title)
file.write NKF.nkf("-sm0W8x","|")
file.write(w_id_type)
file.write NKF.nkf("-sm0W8x","|")
file.write(w_body)
file.write("\n")
pass=file.path
FileUtils.cp file.path,'/home/a012427/public_html'+pass
FileUtils.chmod(0644,'/home/a012427/public_html'+pass)
  }

case row[2]
when "online_issn" then
printf("</td><td>"'<a href='"http://komorido.nims.go.jp/erms/journals?query=%s"'>%s</a>'"<td></tr>",CGI.escapeHTML(row[3]),CGI.escapeHTML(row[3]))
when "print_issn" then
printf("</td><td>"'<a href='"https://library.nims.go.jp/manifestations?query=%s"'>%s</a>'"<td></tr>",CGI.escapeHTML(row[3]),CGI.escapeHTML(row[3]))
when "doi" then
printf("</td><td>"'<a href='"http://dx.doi.org/%s"'>%s</a>'"<td></tr>",CGI.escapeHTML(row[3]),CGI.escapeHTML(row[3]))
else
printf("</td><td>%s<td></tr>",CGI.escapeHTML(row[3]))
end
}
}
db.close
end

printf('<a href='"http://komorido.nims.go.jp/~a012427/%s"'>テスト用</a>'"\n",pass.to_s)


print("</table>\n")
print("</body>\n")
print("</html>")

# issn_numにISSNが入っている
# 大丈夫な例（プレースホルダ）
#db.exectue("DELETE FROM issndb WHER issn = ?", issn_num)

# 危険な例
#db.exectue("DELETE FROM issndb WHER issn = #{issn_num}")

#'1234'
#'DELTEE FROM issndb WHERE issn = 1234; DELETE FROM issndb;'
