#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require("library_stdnums")
require("sqlite3")
require("cgi")


s=CGI.new
create_id=nil
create_title=s.params["title"][0]
create_print_issn= s.params["print_issn"]
create_online_issn=s.params["online_issn"]
create_doi=s.params["doi"]
create_print_isbn=s.params["print_isbn"]
create_online_isbn=s.params["online_isbn"]
identifire_id=nil
n=0

error_print_issn = nil
error_online_issn = nil
error_online_isbn = nil
error_print_isbn = nil

create_online_issn.each do |o_issn|
  if o_issn != ""
    unless StdNum::ISSN.valid?(o_issn.to_s)
      error_online_issn = true
    end
  end
end

create_print_issn.each do |p_issn|
  if p_issn != ""
    unless StdNum::ISSN.valid?(p_issn.to_s)
  error_online_issn = true
    end
  end
end

create_print_isbn.each do |p_isbn|
  if p_isbn != ""
    unless StdNum::ISBN.valid?(p_isbn.to_s)
  error_print_isbn = true
    end
  end
end

create_online_isbn.each do |o_isbn|
  if o_isbn != ""
    unless StdNum::ISBN.valid?(o_isbn.to_s)
  error_online_isbn = true
    end
  end
end

if error_online_issn.nil? and error_print_issn.nil? and error_online_isbn.nil? and error_print_isbn.nil?
  db=SQLite3::Database.new("issn.db")
  db.transaction{

db.execute("insert into resource values (NULL,?);",create_title.to_s)
    db.execute("select * from resource where title=?;",create_title.to_s){|id|
      create_id=id[0]
    }

 create_print_issn.each do |p_issn|
db.execute("insert into identifier values (NULL,?,'print_issn',?);",create_id.to_i,p_issn.to_s)
end

create_online_issn.each do |o_issn|
db.execute("insert into identifier values (NULL,?,'online_issn',?);",create_id.to_i,o_issn.to_s)
end

create_doi.each do |doi|
db.execute("insert into identifier values (NULL,?,'doi',?);",create_id.to_i,doi.to_s)
end

create_print_isbn.each do |p_isbn|
db.execute("insert into identifier values (NULL,?,'print_isbn',?);",create_id.to_i,p_isbn.to_s)
end

create_online_isbn.each do |o_isbn|
db.execute("insert into identifier values (NULL,?,'online_isbn',?);",create_id.to_i,o_isbn.to_s)
end


  }
  db.close
  print("Content-Type: text/html; charset=utf-8\n")
    printf("Location: http://komorido.nims.go.jp/~a012427/id_managment_system/detail.cgi?id=%d\n",create_id)
  print("\n")
  else

print("Content-Type: text/html; charset=utf-8\n")
print("\n")
print("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n")
print(" \"http://www.w3.org/TR/html4/strict.dtd\">\n")


print("<html>\n")
print("<head>\n")
print('<meta http-equiv="refresh" content="5; URL=http://komorido.nims.go.jp/~a012427/id_managment_system/new.cgi">')

print("\n")
print("<title>更新ページ</title>\n")
print("</head>\n")
print("<body>\n")

#p update_online_issn.class
#p error_online_issn


create_print_issn.each do |p_issn|
  if p_issn != ""
    unless StdNum::ISSN.valid?(p_issn.to_s)
      print("<p><b>print_issnに不備があります。入力をやり直してください。</b></p>\n")
    end
  end
end

create_online_issn.each do |o_issn|
  if o_issn != ""
    unless StdNum::ISSN.valid?(o_issn.to_s)
      print("<p><b>online_issnに不備があります。入力をやり直してください。</b></p>\n")
    end
  end
end

create_print_isbn.each do |p_isbn|
  if p_isbn != ""
    unless StdNum::ISBN.valid?(p_isbn.to_s)
      print("<p><b>print_isbnに不備があります。入力をやり直してください。</b></p>\n")
    end
  end
end

create_online_isbn.each do |o_isbn|
  if o_isbn != ""
    unless StdNum::ISBN.valid?(o_isbn.to_s)
      print("<p><b>online_isbnに不備があります。入力をやり直してください。<b></p>\n")
    end
  end
end


print("<p>5秒後に元のページに戻ります</p>")
print('<a href="./issn.cgi?">TOP</a>')
print('<a href="javascript:history.back();">戻る</a>')


print("</body>\n")
print("</html>\n")
end
