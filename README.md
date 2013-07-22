Description
------------

Search for a company by keyword and find company details and location

Execution
----------

linkedinapi.rb input.csv output.csv

input.csv should contain a header row, i.e. "Company"
Each subsequent row is the name of one company

Test
-----
linkedinapi.rb test_data.csv output.csv

Notes
-----

Companies are searched by keyword using http://developer.linkedin.com/documents/company-lookup-api-and-fields

Each LinkedIn API call is done on "behalf" of a LinkedIn User, which is achieved by generating a user token and secret. 

Read more here:
http://developer.linkedin.com/documents/quick-start-guide

The throttle limits for an individual user token is 500 calls per day. The limit for an entire application is 100K/day, but that would require getting multiple user keys to perform.

https://developer.linkedin.com/documents/throttle-limits

Set and get API keys here: https://www.linkedin.com/secure/developer