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
# a=  access_token.get('http://api.mendeley.com/oapi/library/documents/6083469224').body
#result = JSON.parse(a)
#p  result["title"]
# ===========================




#==== Profile Infomation ====
#printf "\nユーザー情報\n"
#temp_profile = access_token.get('http://api.mendeley.com/oapi/profiles/info/me/').body
#profile = JSON.parse(temp_profile)
#profile["main"].each{|profile_key,profile_val|
#  print "#{profile_key}"+':'+"#{profile_val}"
#}
#===========================




#==== User Library Groups ====
#printf "\nグループ情報\n"
groups_id=nil

temp_groups =access_token.get('http://api.mendeley.com/oapi/library/groups/').body
groups=JSON.parse(temp_groups)
groups.each{|groups_hash|
  groups_hash.each{|groups_key,groups_val|
#    puts "#{groups_key}:#{groups_val}"
    if groups_key=="id" then
      groups_id =groups_val
    end
  }
}
#=============================




#===== Group Documents ======
printf "\nグループライブラリー情報\n"
group_documents_ids = nil

temp_group_documents =  access_token.get('http://api.mendeley.com/oapi/library/groups/'+"#{groups_id}"+'/').body
group_documents = JSON.parse(temp_group_documents)

group_documents.each{|group_documents_key,group_documents_val|
  puts "#{group_documents_key}:#{group_documents_val}"
  if group_documents_key=="document_ids" then
    group_documents_val.each{|ids|
      group_documents_ids=group_documents_val
    }
  end
}
#===========================




#====== 各グループドキュメント詳細情報 =====
printf "\nグループドキュメント詳細情報\n"
document_detail=nil
document_title_count_num=0
group_documents_ids_count_num=0

count_num=0
file_hash=[]
count_hash_num=0
document_title=[]


issued_count_num=0
name_count_num=0
authors_count_num=0

group_documents_ids.each{|ids|

  document_detail = JSON.parse(access_token.get('http://api.mendeley.com/oapi/library/documents/'+"#{ids}"+'/').body)
  document_detail["authors"].each{|num|
    printf("%s %s\n",num["forename"],num["surname"])
  }


#  document_detail = JSON.parse(access_token.get('http://api.mendeley.com/oapi/library/documents/'+"#{ids}"+'/').body)
#  document_detail.each{|document_detail_key,document_detail_val|
#      if document_detail_key == "authors" then
#        authors_name[group_documents_ids_count_num[authors_count_num]] =document_detail_val
#        authors_count_num+=1
#      end





# for i in 0..authors_count_num do
#   authors_name[group_documents_ids_count_num[i]]

#    authors_name[group_documents_ids_count_num].each{|name|
#      name.each{|name_type,name_body|
#        if type == "forname" then
#          family_name[name_count_num] = body
#          puts family_name[name_count_num]
#        elsif type == "sunname" then
#          given_name[name_count_num] = body
#          puts gimen_name[name_count_num]
#       end
#        if type == "forname" or type == "sunname" then
#          name_count_num +=1
#        end
#      }
#      }    
#   end










#  if key == "year" then
#    issued_year[issued_count_num] =val
#    issued_count_num +=1
#  end
#    if document_detail_key == "title" then
#      document_title[document_title_count_num] = document_detail_val
#      document_title_count_num += 1
#      printf "#{document_title_count_num}件目\n"
#      puts "#{document_detail_key}:#{document_detail_val}"
#    end
#  }


#document_detail.each{|key,val|
#  if key != "title" then  
#    puts "#{key}:#{val}"
#  end
#  if key == "files" then
#    val.each{|hash|
#      hash.each{|files_key,files_val|
#        if files_key == "file_hash" then
#          file_hash[count_hash_num] = files_val
#          count_hash_num+=1
#       end
#      }
#
#    }
#  end
#  }
#group_documents_ids_count_num+=1
}
#puts authors_name[0][1]
printf "\n\n"

printf "==================================================\n\n"
document_detail.each{|key,val|
  puts "#{key}:#{val}"
}
printf "==================================================\n\n"

#========================================




#====== ドキュメントDL ============
#count_hash_num=0
#printf "ドキュメントDL\n"
#group_documents_ids.each{|id|
#body = access_token.get('http://api.mendeley.com/oapi/library/documents/'+id+'/file/'+"#{file_hash[count_hash_num]}"+'/'+"#{groups_id}"+'/').body
#この時点ではバイナリデータでDLしている

#open(id+".pdf","wb"){|file|
#file.write body

#              }
#count_hash_num+=1
#}

#printf "書き込み終了\n"

#============

#p document_title


#===== POSTメゾット ========
#Net::HTTP.version_1_2
#count_title_num=0

#basic認証用
#access_id="test"
#access_pass=1111

#printf "#{access_id}"+':'+"#{access_pass}"+'@'+'komorido.nims.go.jp'+"\n\n"


#group_documents_ids.each{|id|
#req=Net::HTTP::Post.new('/~a012427/create.cgi')
#    req.basic_auth "#{access_id}", "#{access_pass}"
#Net::HTTP.start( 'komorido.nims.go.jp' ) {|http|
# req.set_form_data({"title" => "#{document_title[count_title_num]}" , "print_issn" =>"", "online_issn" =>"" , "print_isbn" =>"" , "online_isbn" =>"", "doi" =>"" })
# response=http.request(req)
#count_title_num+=1
#puts response.body
#                          }
#                        }

#=================================


#===== 書誌データ作成(xml) ======
#使えそうなデータ
#タイトル、著者(苗字、名前、フルネーム)、出版年


#printf "書誌データ作成\n"
#document_title


#bibliographic_data=nil
#
#open(id+".xml","w"){|file|
#file.write bibliographic data
#              }
#}
#=================

printf "おわり\n"
