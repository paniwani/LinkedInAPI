require 'oauth'
require 'pry'
require 'json'
require 'csv'
require 'open-uri'

# Check arguments
input_f, output_f = ARGV[0], ARGV[1]
abort("Must specify arguments: input.csv output.csv") if input_f.nil? or output_f.nil?
abort("Arguments must be .csv files") unless File.extname(input_f) == ".csv" or File.extname(output_f) == ".csv"
abort("Could not find input data: #{input_f}") unless File.exists?(input_f)

api_key = 'be5n1vcrlmfy'
api_secret = 'rgIYw7dnzOplgWZV'
user_token = '59c80ff4-16ad-4565-90cb-9c86873aaad7'
user_secret = '04fe139b-7723-44d7-836a-fe59f7155c40'

# Specify LinkedIn API endpoint
configuration = { :site => 'https://api.linkedin.com' }
 
# Use your API key and secret to instantiate consumer object
consumer = OAuth::Consumer.new(api_key, api_secret, configuration)
 
# Use your developer token and secret to instantiate access token object
access_token = OAuth::AccessToken.new(consumer, user_token, user_secret)

CSV.open(output_f, "w") do |csv|
  # Write output header line
  csv << ["Company Name", "LinkedIn Name", "Company Type", "Size", "City", "State", "Postal Code", "Description"]

  i = 1
  CSV.foreach(input_f, headers: true) do |row|

    output = []

    # Get company name from input file
    company_name = row[0]
    company_name_enc = URI.encode(company_name)

    # Find company by name
    # Search by keyword and assume first result is best
    query = "http://api.linkedin.com/v1/company-search?keywords=#{company_name_enc}&format=json"
    results = JSON.parse(access_token.get(query).body)

    begin
      unless results["companies"]["_total"] > 0
        puts "#{i} #{company_name} NOT FOUND (no companies)"
        csv << [company_name, "Not Found"]
        i = i+1
        next
      end

      id   = results["companies"]["values"][0]["id"]
      name = results["companies"]["values"][0]["name"]

      # Use id to find company size and location
      query = "http://api.linkedin.com/v1/companies/#{id}:" + "(" + 
        "company-type," + 
        "employee-count-range," +
        "locations:(address:(city,state,postal-code),is-headquarters)," +
        "description)" + 
        "?format=json"
      
      results = JSON.parse(access_token.get(query).body)

      if results.empty?
        puts "#{i} #{company_name} NOT FOUND (no id results)"
        csv << [company_name, "Not Found"]
        i = i+1
        next
      end

      company_type = results["companyType"]["name"]
      company_size = results["employeeCountRange"]["name"]
      company_description = results["description"]

      hq = {}
      hq["city"] = ""
      hq["state"] = ""
      hq["postalCode"] = ""

      locs = results["locations"]["values"].keep_if { |x| x["isHeadquarters"] }
      hq = locs[0]["address"] unless locs.empty?
          

      # Write data out to CSV file
      output = [company_name, name, company_type, company_size, hq["city"], hq["state"], hq["postalCode"], company_description]
      puts "#{i} " + output[0..-2].join("\t")
      
      csv << output

    rescue
      puts "#{i} #{company_name} NOT FOUND (no method error)"

      csv << [company_name, "Not Found"]
      i = i+1
      next
    end

    i = i+1
  end
end