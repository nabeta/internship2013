require 'oauth'
require 'oauth/consumer'
require 'yaml'

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

p access_token.get('http://api.mendeley.com/oapi/library/').body
