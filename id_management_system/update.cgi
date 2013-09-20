#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require("library_stdnums")
require("sqlite3")
require("cgi")


s=CGI.new
update_id=s.params["id"][0]
update_title=s.params["title"][0]
update_print_issn= s.params["print_issn"]
update_online_issn=s.params["online_issn"]
update_doi=s.params["doi"]
update_print_isbn=s.params["print_isbn"]
update_online_isbn=s.params["online_isbn"]
identifire_id=nil
n=0

error_print_issn = nil
#if update_print_issn.to_s != ""
#  unless update_print_issn.to_s =~ /^[0-9]{7}[0-9xX]/
#    error_print_issn = true
#  end
#end

error_online_issn = nil
#if update_online_issn.to_s != ""
#  unless update_online_issn.to_s =~ /^[0-9]{7}[0-9xX]/
#    error_online_issn = true
#  end
#end

error_online_isbn = nil
error_print_isbn = nil

update_online_issn.each do |o_issn|
  if o_issn != ""
    unless StdNum::ISSN.valid?(o_issn.to_s)
      error_online_issn = true
    end
  end
end

update_print_issn.each do |p_issn|
  if p_issn != ""
    unless StdNum::ISSN.valid?(p_issn.to_s)
  error_online_issn = true
    end
  end
end

update_print_isbn.each do |p_isbn|
  if p_isbn != ""
    unless StdNum::ISBN.valid?(p_isbn.to_s)
  error_print_isbn = true
    end
  end
end


update_online_isbn.each do |o_isbn|
  if o_isbn != ""
    unless StdNum::ISBN.valid?(o_isbn.to_s) 
  error_online_isbn = true
    end
  end
end

if error_online_issn.nil? and error_print_issn.nil? and error_online_isbn.nil? and error_print_isbn.nil?
  db=SQLite3::Database.new("issn.db")
  #db.transaction{
#    db.execute("UPDATE issndb SET title=? ,print_issn=? ,online_issn=?  WHERE id = ?;",CGI.escapeHTML(update_title),update_print_issn,update_online_issn,update_id.to_i)
  #}

 db.execute("update resource set title=? where id=?;",update_title.to_s,update_id.to_i)

db.execute("delete from identifier where resource_id=? and body=?;",update_id.to_i,"")


db.execute("delete from identifier where resource_id=? and id_type=?;",update_id.to_i,"print_issn")
update_print_issn.each do |p_issn|
db.execute("insert into identifier values (NULL,?,'print_issn',?);",update_id.to_i,p_issn.to_s)
end

db.execute("delete from identifier where resource_id=? and id_type=?;",update_id.to_i,"online_issn")
update_online_issn.each do |o_issn|
db.execute("insert into identifier values (NULL,?,'online_issn',?);",update_id.to_i,o_issn.to_s)
end


 db.execute("delete from identifier where resource_id=? and id_type=?;",update_id.to_i,"doi")
update_doi.each do |doi|
db.execute("insert into identifier values (NULL,?,'doi',?);",update_id.to_i,doi.to_s)
end

 db.execute("delete from identifier where resource_id=? and id_type=?;",update_id.to_i,"print_isbn")
update_print_isbn.each do |p_isbn|
db.execute("insert into identifier values (NULL,?,'print_isbn',?);",update_id.to_i,p_isbn.to_s)
end

 db.execute("delete from identifier where resource_id=? and id_type=?;",update_id.to_i,"online_isbn")
update_online_isbn.each do |o_isbn|
db.execute("insert into identifier values (NULL,?,'online_isbn',?);",update_id.to_i,o_isbn.to_s)
end

#update_print_issn.each do |issn|
#  db.execute("UPDATE identifier set body = ? WHERE id = ?", issn, update_id.to_i)
#end

  db.close
  print("Content-Type: text/html; charset=utf-8\n")
  print  "Location: http://komorido.nims.go.jp/~a012427/id_management_system/detail.cgi?id=#{update_id}\n"
  print("\n")
else

print("Content-Type: text/html; charset=utf-8\n")
print("\n")
print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n")
print(" \"http://www.w3.org/TR/html4/strict.dtd\">\n")


print("<html>\n")
print("<head>\n")
printf('<meta http-equiv="refresh" content="5; URL=http://komorido.nims.go.jp/~a012427/id_management_system/edit.cgi?id=%s">',update_id.to_s)

print("\n")
print("<title>更新ページ</title>\n")
print("</head>\n")
print("<body>\n")

#p update_online_issn.class
#p error_online_issn
#p update_id
#p update_id.class


update_print_issn.each do |p_issn|
  if p_issn != ""
unless StdNum::ISSN.valid?(p_issn.to_s)
  print("<p><b>print_issnに不備があります。入力をやり直してください。</b></p>\n")
end
end
end

update_online_issn.each do |o_issn|
  if o_issn != ""
unless StdNum::ISSN.valid?(o_issn.to_s)
print("<p><b>online_issnに不備があります。入力をやり直してください。</b></p>\n")
end
end
end

update_print_isbn.each do |p_isbn|
  if p_isbn != ""
unless StdNum::ISBN.valid?(p_isbn.to_s)
print("<p><b>print_isbnに不備があります。入力をやり直してください。</b></p>\n")
end
end
end

update_online_isbn.each do |o_isbn|
  if o_isbn != ""
unless StdNum::ISBN.valid?(o_isbn.to_s)
print("<p><b>online_isbnに不備があります。入力をやり直してください。<b></p>\n")
end
end
end

print("<p>5秒後に元のページに戻ります</p>")
#printf("UPDATE issndb SET title='%s', print_issn='%s', online_issn='%s' WHERE id=%d\n",CGI.escapeHTML(update_title).to_s,CGI.escapeHTML(update_print_issn).to_s,CGI.escapeHTML(update_onlinen_issn)/to_s,CGI.escapeHTML(update_id).to_i)
print('<a href="./issn.cgi?">TOP</a>'"\n")
print('<a href="javascript:history.back();">戻る</a>'"\n")


print("</body>\n")
print("</html>\n")
end
