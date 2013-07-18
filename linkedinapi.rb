require 'oauth'
require 'pry'
require 'json'

# Fill the keys and secrets you retrieved after registering your app
api_key = 'be5n1vcrlmfy'
api_secret = 'rgIYw7dnzOplgWZV'
user_token = '55871945-b507-4842-8944-c866cddf1707'
user_secret = 'a92e96b7-ab52-41c3-a818-1f02a0101f1c'
 
# Specify LinkedIn API endpoint
configuration = { :site => 'https://api.linkedin.com' }
 
# Use your API key and secret to instantiate consumer object
consumer = OAuth::Consumer.new(api_key, api_secret, configuration)
 
# Use your developer token and secret to instantiate access token object
access_token = OAuth::AccessToken.new(consumer, user_token, user_secret)
 
# Make call to LinkedIn to retrieve your own profile
query = "http://api.linkedin.com/v1/companies/universal-name=linkedin"
response = JSON.parse(access_token.get("#{query}?format=json").body)

puts JSON.pretty_generate(response)