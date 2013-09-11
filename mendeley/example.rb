require 'oauth'
require 'oauth/consumer'

consumer = OAuth::Consumer.new(
  "your consumer key",
  "your consumer secret key",
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
  "your access token",
  "your access secret key",
)

p access_token.get('http://api.mendeley.com/oapi/library/').body
