require 'net/http'

uri = URI.parse('http://komorido.nims.go.jp/~a012427/issn.cgi')

req = Net::HTTP::Post.new(uri.path)
req.basic_auth 'test', '1111'

res = Net::HTTP.start(uri.hostname, uri.port) {|http|
  req.set_form_data({:title => "hogehoge"})
  http.request(req)
}
puts res.body
