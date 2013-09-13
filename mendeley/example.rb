# -*- coding: utf-8 -*-
#!/usr/bin/ruby

require 'json'
require 'oauth'
require 'oauth/consumer'
require 'tempfile'
require 'net/http'
require 'yaml'
#====== ここでログイン作業中 ======

config = YAML.load(open('config.yml'))

consumer = OAuth::Consumer.new(
  config['consumer_key'],
  config['consumer_secret'],
  {
    :site=>"http://api.mendeley.com/",
    :proxy => "http://wwwout.nims.go.jp:8888",
    :request_token_path => "/oauth/resuest_token/",
    :access_token_path => "/oauth/access_token/",
    :authorize_path => "/authorize/"
  }
)

access_token = OAuth::AccessToken.new(
  consumer,
  config['access_key'],
  config['access_secret'],
)


#====== ここらへんまでログイン作業 =======


# ====== ライブラリドキュメントのタイトルを取得 ==========
#p access_token.get('http://api.mendeley.com/oapi/library/').body

# a=  access_token.get('http://api.mendeley.com/oapi/library/documents/6087871964').body

#result = JSON.parse(a)
#p  result["title"]

# ===========================


#==== Profile Infomation ====

temp = access_token.get('http://api.mendeley.com/oapi/profiles/info/me/').body
profile = JSON.parse(temp)
#p profile

printf "\nユーザー情報\n"
profile["main"].each{|key,val|
  puts "#{key}:#{val}"
}
#===========================

#==== User Library Groups ====

temp_groups =access_token.get('http://api.mendeley.com/oapi/library/groups/').body

#p JSON.parse(temp_groups)
groups=JSON.parse(temp_groups)

printf "\nグループ情報\n"

groups_id=nil
groups.each{|hash|
#   puts "#{hash}"
  hash.each{|key,val|
    puts "#{key}:#{val}"
if key=="id" then
groups_id =val
end
  }
}
#=============================

#===== Group Documents ======
#p groups_id
group_documents_ids = nil
t_group_documents =  access_token.get('http://api.mendeley.com/oapi/library/groups/'+"#{groups_id}"+'/').body
group_documents = JSON.parse(t_group_documents)


printf "\nグループライブラリー情報\n"
group_documents.each{|key,val|
puts "#{key}:#{val}"
if key=="document_ids" then
#puts val[0]
  val.each{|ids|
    group_documents_ids=val
  }
end
}

#print "test"
#p group_documents_ids

#===========================

#====== 各グループドキュメント詳細情報 =====

printf "\nグループドキュメント詳細情報\n"

document_detail=nil
count_num=0
file_hash=[]
count_hash_num=0
document_title=[]

group_documents_ids.each{|ids|
 document_detail = JSON.parse(access_token.get('http://api.mendeley.com/oapi/library/documents/'+"#{ids}"+'/').body)

document_detail.each{|key,val|
  if key == "title" then
    document_title[count_num] = val
    count_num += 1
    printf "#{count_num}件目\n"
    puts "#{key}:#{val}"
  end
}


document_detail.each{|key,val|

  if key != "title" then  
    puts "#{key}:#{val}"
  end

  if key == "files" then
  
    val.each{|hash|
      hash.each{|files_key,files_val|
        if files_key == "file_hash" then
          file_hash[count_hash_num] = files_val
          count_hash_num+=1
        end
      }

    }
  end
  }
}

printf "\n\n"



#========================================

#====== ドキュメントDL ============
count_hash_num=0
printf "ドキュメントDL\n"
#p file_hash[0]
group_documents_ids.each{|id|
p count_hash_num
#body = access_token.get('http://api.mendeley.com/oapi/library/documents/'+id+'/file/'+"#{file_hash[count_hash_num]}"+'/'+"#{groups_id}"+'/').body
#この時点ではバイナリデータでDLしている

#open(id+".pdf","wb"){|file|
#file.write body

#              }
count_hash_num+=1
}

printf "書き込み終了\n"

#============

#p document_title


#===== POSTメゾット ========
Net::HTTP.version_1_2
count_title_num=0

#basic認証用
access_id="test"
access_pass=1111

printf "#{access_id}"+':'+"#{access_pass}"+'@'+'komorido.nims.go.jp'+"\n\n"


group_documents_ids.each{|id|
req=Net::HTTP::Post.new('/~a012427/create.cgi')
    req.basic_auth "#{access_id}", "#{access_pass}"
Net::HTTP.start( 'komorido.nims.go.jp' ) {|http|
 req.set_form_data({"title" => "#{document_title[count_title_num]}" , "print_issn" =>"", "online_issn" =>"" , "print_isbn" =>"" , "online_isbn" =>"", "doi" =>"" })
 response=http.request(req)


#group_documents_ids.each{|id|
#Net::HTTP.start("#{access_id}"+':'+"#{access_pass}"+'@'+'komorido.nims.go.jp',80){|http|
#response=http.post('/~a012427/create.cgi','title='+"#{document_title[count_title_num]}"+'&print_issn=&online_issn=&print_isbn=&online_isbn=&doi=')
count_title_num+=1
puts response.body
                          }
                        }
#=================================


