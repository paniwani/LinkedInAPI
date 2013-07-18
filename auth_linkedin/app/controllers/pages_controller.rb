require 'net/https'

class PagesController < ApplicationController
  def page1
  end

  def page2
    authorization_code = params[:code]

    parameters = {
      grant_type: "authorization_code",
      code: authorization_code,
      redirect_uri: "http%3A%2F%2Flocalhost%3A3000%2Fpages%2Fpage2",
      client_id: "44ipbh2t36lp",
      client_secret: "JnCX2CpfZzARz33m"
    }

    url = "https://www.linkedin.com/uas/oauth2/accessToken"
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # request = Net::HTTP::Post.new("/v1.1/auth")
    # request.add_field('Content-Type', 'application/json')
    # request.body = parameters
    # @response = http.request(request)

    # response = Net::HTTP.post_form(uri, parameters)


    @response = HTTParty.post(url, body: parameters.to_json, :options => { :headers => { 'ContentType' => 'application/json' } })
    binding.pry
    

    "response"
  end
end
