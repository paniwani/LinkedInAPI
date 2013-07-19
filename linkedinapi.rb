require 'oauth'
require 'pry'
require 'json'
require 'csv'
require 'open-uri'

# Fill the keys and secrets you retrieved after registering your app
# api_key = 'be5n1vcrlmfy'
# api_secret = 'rgIYw7dnjzOplgWZV'
# user_token = '59c80ff4-16ad-4565-90cb-9c86873aaad7'
# user_secret = '04fe139b-7723-44d7-836a-fe59f7155c40'

api_key = 'tzldc94jok1k'
api_secret = 'g7bbMduupz0YAdoh'
user_token = 'fcd6ebe2-8b85-42ea-9723-5da4f110f559'
user_secret = 'a0942932-3a76-4b97-8dad-19d8e5afaa06'
 
# Specify LinkedIn API endpoint
configuration = { :site => 'https://api.linkedin.com' }
 
# Use your API key and secret to instantiate consumer object
consumer = OAuth::Consumer.new(api_key, api_secret, configuration)
 
# Use your developer token and secret to instantiate access token object
access_token = OAuth::AccessToken.new(consumer, user_token, user_secret)

CSV.open("out.csv", "w") do |csv|
  # Write output header line
  csv << ["Company Name", "LinkedIn Name", "Company Type", "Size", "Location"]

  i = 1
  CSV.foreach("test_data.csv", headers: true) do |row|

    # Get company name from input file
    company_name = URI.encode(row[0])

    # Find company by name
    # Search by keyword and assume first result is best
    query = "http://api.linkedin.com/v1/company-search?keywords=#{company_name}&format=json"
    results = JSON.parse(access_token.get(query).body)
    
    

    id   = results["companies"]["values"][0]["id"]
    name = results["companies"]["values"][0]["name"]

    binding.pry

    # Use id to find company size and location
    query = "http://api.linkedin.com/v1/companies/#{id}:(company-type,employee-count-range,locations:(address:(state)))?format=json"
    results = JSON.parse(access_token.get(query).body)


    binding.pry

    company_size = results["employeeCountRange"]["name"]
    company_location = results["locations"][]

    # Write data out to CSV file
    # TODO
    csv << [company_name, name, company_size, company_location]

    i = i+1
    break if i >= 10
  end
end