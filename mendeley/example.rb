# -*- coding: utf-8 -*-
#!/usr/bin/ruby

require 'json'
require 'oauth'
require 'oauth/consumer'
require 'tempfile'
require 'net/http'
require 'yaml'
require 'zip'

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
printf "ログイン完了\n"




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

#sleep 3


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

#sleep 3


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

#sleep 3


#====== 各グループドキュメント詳細情報 =====
printf "\nグループドキュメント詳細情報\n"
document_detail=nil
document_title_count_num=0
#group_documents_ids_count_num=0

count_num=0
file_hash=[]
count_hash_num=0
document_title={}


#issued_count_num=0
#name_count_num=0
#authors_count_num=0



group_documents_ids.each{|ids|
#
  document_detail = JSON.parse(access_token.get('http://api.mendeley.com/oapi/library/documents/'+"#{ids}"+'/').body)
#  document_detail["authors"].each{|num|
#    printf("%s %s\n",num["forename"],num["surname"])
#  }


#  document_detail = JSON.parse(access_token.get('http://api.mendeley.com/oapi/library/documents/'+"#{ids}"+'/').body)
#  document_detail.each{|document_detail_key,document_detail_val|
#      if document_detail_key == "authors" then
#        authors_name[group_documents_ids_count_num[authors_count_num]] =document_detail_val
#        authors_count_num+=1
#      end



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

document_detail.each{|key,val|
  if key == "title" then  
     document_title[ids.to_s]=val
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

#group_documents_ids_count_num+=1

#puts authors_name[0][1]
#printf "\n\n"

  printf "==================================================\n"
  printf "タイトル情報：%s\n",document_title[ids.to_s].to_s
  document_detail.each{|key,val|
    puts "#{key}:#{val}"
  }
  printf "==================================================\n\n"
}
#========================================




#====== ドキュメントDL ============
count_hash_num=0
printf "ドキュメントDL\n"
group_documents_ids.each{|id|
  body = access_token.get('http://api.mendeley.com/oapi/library/documents/'+id+'/file/'+"#{file_hash[count_hash_num]}"+'/'+"#{groups_id}"+'/').body
  #この時点ではバイナリデータでDLしている
 printf "ハッシュ値:%s\n",file_hash[count_hash_num].to_s
  if file_hash[count_hash_num]!=nil then
    open(id+".pdf","wb"){|file|
      file.write body
    }
  end
  count_hash_num+=1
}


printf "書き込み終了\n\n"

#============

#p document_title


#===== POSTメゾット ========
#インターン1週目で作ったシステムにPOST
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


printf "書誌データ作成\n"

#document_title
bibliographic_data=nil
first_half_tag=nil
last_half_tag=nil
open_person_tag='<eterms:creator role="http://www.loc.gov/loc.terms/relators/AUT">'+"\n"+"<person:person>"+"\n"
close_person_tag="</person:person>"+"\n"+"</eterms:creator>"+"\n"
full_name_tag=""
family_name_tag=""
given_name_tag=""
other_tag='<dcterms:issued xsi:type="dcterms:W3CDTF">2013-08-09</dcterms:issued>'+"\n"+'<source:source type="http://purl.org/eprint/type/Book">'+"\n"
title_tag=""
folder=""
input_files=nil
zip_filename=""
organization_tag="<organization:organization>"+"\n"+"<dc:title>NIMS</dc:title>"+"\n"+"<eterms:address/>"+"\n"+"<dc:identifier>escidoc:1001</dc:identifier>"+"\n"+"</organization:organization>"+"\n"
#close_eterms_creator_tag="</eterms:creator>"+"\n"
link_tag=""
link_url=""
attach_tag=""
temp_name={}

#temp_count=0

File.open("first_half.txt"){|first|
  first_half_tag=first.read
}

File.open("last_half.txt"){|last|
  last_half_tag=last.read
}

group_documents_ids.each{|ids|
  File.open(ids+".xml","w"){|file|

  #  p document_title[ids.to_s]
    
    link_url=URI.encode("http://www.mendeley.com/catalog/#{document_title[ids.to_s]}")
    
 link_tag='<escidocComponents:components xml:base="http://localhost:8080">'+"\n"+'<escidocComponents:component>'+"\n"+'<escidocComponents:properties>'+"\n"+"<prop:valid-status>valid</prop:valid-status>"+"\n"+"<prop:visibility>public</prop:visibility>"+"\n"+"<prop:pid></prop:pid>"+"\n"+"<prop:content-category>http://purl.org/escidoc/metadata/ves/content-categories/abstract</prop:content-category>"+"\n"+"<prop:file-name>#{link_url}</prop:file-name>"+"\n"+"<prop:checksum>ExceptionReadingStream</prop:checksum>"+"\n"+"<prop:checksum-algorithm>MD5</prop:checksum-algorithm>"+"\n"+"</escidocComponents:properties>"+"\n"+'<escidocComponents:content xlink:type="simple" xlink:title="'+link_url +'" xlink:href="'+ link_url +'" storage="external-url"/>'+"\n"+"<escidocMetadataRecords:md-records>"+"\n"+'<escidocMetadataRecords:md-record name="escidoc">'+"\n"+'<file:file xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:eterms="http://purl.org/escidoc/metadata/terms/0.1/" xmlns:person="http://purl.org/escidoc/metadata/profiles/0.1/person" xmlns:event="http://purl.org/escidoc/metadata/profiles/0.1/event" xmlns:source="http://purl.org/escidoc/metadata/profiles/0.1/source" xmlns:organization="http://purl.org/escidoc/metadata/profiles/0.1/organization" xmlns:legalCase="http://purl.org/escidoc/metadata/profiles/0.1/legal-case">'+"\n"+'<dc:title>'+"#{link_url}"+'</dc:title>'+"\n"+"</file:file>"+"\n"+"</escidocMetadataRecords:md-record>"+"\n"+"</escidocMetadataRecords:md-records>"+"\n"+"</escidocComponents:component>"+"\n"+"</escidocComponents:components>"+"\n"+"</escidocItem:item>"+"\n"


    #attach_tag="<escidocComponents:component>"+"\n"+"<escidocComponents:properties>"+"\n"+"<prop:valid-status>valid</prop:valid-status>"+"\n"+"<prop:visibility>public</prop:visibility>"+"\n"+"<prop:pid></prop:pid>"+"\n"+"<prop:content-category>http://purl.org/escidoc/metadata/ves/content-categories/abstract</prop:content-category>"+"\n"+"<prop:file-name>"+"#{ids}"+".pdf</prop:file-name>"+"\n"+"<prop:mime-type>application/pdf</prop:mime-type>"+"\n"+"<prop:checksum></prop:checksum>"+"\n"+"<prop:checksum-algorithm>MD5</prop:checksum-algorithm>"+"\n"+"</escidocComponents:properties>"+"\n"+'<escidocComponents:content xlink:type="simple" xlink:title="'+"#{ids}"+'.pdf"'+' storage="internal-managed"/>'+"\n"+"<escidocMetadataRecords:md-records>"+"\n"+'<escidocMetadataRecords:md-record name="escidoc">'+"\n"+'<file:file xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:eterms="http://purl.org/escidoc/metadata/terms/0.1/" xmlns:person="http://purl.org/escidoc/metadata/profiles/0.1/person" xmlns:event="http://purl.org/escidoc/metadata/profiles/0.1/event" xmlns:source="http://purl.org/escidoc/metadata/profiles/0.1/source" xmlns:organization="http://purl.org/escidoc/metadata/profiles/0.1/organization" xmlns:legalCase="http://purl.org/escidoc/metadata/profiles/0.1/legal-case">'+"\n"+"<dc:title>#{ids}.pdf</dc:title>"+"\n"+"<dc:description/>"+"\n"+'<dc:format xsi:type="dcterms:IMT">application/pdf</dc:format>'+"\n"+"<dcterms:extent></dcterms:extent>"+"\n"+"<dcterms:dateCopyrighted/>"+"\n"+"<dc:rights/>"+"\n"+"<dcterms:license/>"+"\n"+"</file:file>"+"\n"+"</escidocMetadataRecords:md-record>"+"\n"+"</escidocMetadataRecords:md-records>"+"\n"+ "</escidocComponents:component>"+"\n"+"</escidocComponents:components>"+"\n"+"</escidocItem:item>"+"\n"




    file.write first_half_tag
    document_detail = JSON.parse(access_token.get('http://api.mendeley.com/oapi/library/documents/'+"#{ids}"+'/').body)
#    temp_count=0
    document_detail["authors"].each{|num|





 #     if temp_count==0 then




      file.write open_person_tag
     # if num["forename"]!=nil and num["surname"]!=nil then
     #   full_name_tag="<eterms:complete-name>"+num["forename"]+"."+num["surname"]+"</eterms:complete-name>\n"
     #   file.write full_name_tag
     # end
      if num["forename"]!=nil then
        family_name_tag="<eterms:family-name>"+num["forename"]+"</eterms:family-name>\n"
        file.write family_name_tag
      end
 #      printf("%s %s\n",num["forename"],num["surname"])
      if num["surname"]!=nil then
      given_name_tag="<eterms:given-name>"+num["surname"]+"</eterms:given-name>\n"
      file.write given_name_tag
#     temp_count=1
      end
      file.write organization_tag
      file.write close_person_tag




#end








    }
    
 #   file.write mid_tag
    title_tag="<dc:title>"+document_detail["title"]+"</dc:title>\n"
 #   file.write close_eterms_creator_tag
    file.write title_tag
    file.write other_tag
    file.write title_tag
    file.write last_half_tag
    file.write link_tag
    file.write attach_tag
    file.close
    printf "%s.xml作成完了\n",ids.to_s

#===以下Zip化作業==
    folder=File.dirname(File.expand_path(__FILE__)) #"/home/a012427/public_html/mendeley" 
    if document_detail["authors"][0]!=nil then 
      temp_name = document_detail["authors"][0]
      if temp_name["surname"]!="" and temp_name["forename"]!="" then 
          if File.exist?("#{ids}.pdf") then
            input_filenames=["#{ids}.xml","#{ids}.pdf"]
          else
            input_filenames=["#{ids}.xml"]
          end
        zipfile_name=folder+"/#{ids}.zip"
         Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
            input_filenames.each do |filename|
              # Two arguments:
              # - The name of the file as it will appear in the archive
              # - The original file, including the path to find it
              zipfile.add(filename, folder + '/' + filename) { true }
          end
        end
        File.chmod(0644,"#{ids}.zip")
        printf "%s.zip作成完了\n",ids.to_s
      end
    end
#===================
  }
}




#=================



#=================
printf "\nPubman新規作成\n"

pubman_config= YAML.load(open('pubman.yml'))

#basic認証用
access_id=pubman_config['pubman_id']#id
access_pass=pubman_config['pubman_pass']#pass
request_uri="http://amaayo.nims.go.jp:8080/pubman/faces/sword-app/deposit?collection=escidoc:3001"
uri=URI.parse "http://amaayo.nims.go.jp:8080/pubman/faces/sword-app/deposit?collection=escidoc:3001"
Net::HTTP.version_1_2

group_documents_ids.each{|ids|
  if File.exist?("#{ids}.zip") then
    printf "%s.zip登録中\n",ids.to_s
    File.open(ids+".zip","r"){|file|
      request = Net::HTTP::Post.new(uri.request_uri, initheader = {"Content-Type" => "application/zip","X-Packaging" => "http://purl.org/escidoc/metadata/schemas/0.1/publication","X-Verbose" => "true"})
      request.body = file.read
      request.basic_auth access_id, access_pass
      Net::HTTP.start('amaayo.nims.go.jp'){|http|
        response=http.request(request) #実際にデータを送信している
        puts response.body
      }
    }
  end
}


#==============
printf "おわり\n"
