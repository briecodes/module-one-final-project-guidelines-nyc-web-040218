require 'rest-client'
require 'JSON'

# Built by LucyBot. www.lucybot.com
uri = URI("https://api.nytimes.com/svc/semantic/v2/concept/search.json")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
uri.query = URI.encode_www_form({
 "api-key" => "dff3bb4eb3784dce96239aa8418ce2e3",
 "query" => ""
})
request = Net::HTTP::Get.new(uri.request_uri)
@result = JSON.parse(http.request(request).body)
puts @result.inspect
