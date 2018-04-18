require 'rest-client'
require 'JSON'
require 'pry'

# all_books = RestClient.get('https://www.googleapis.com/books/v1/volumes?q=philosophy&maxResults=15key=AIzaSyCZGgx4VzR81LmIxbFTN4c5APMTJfQf')
# books_hash = JSON.parse(all_books)

uri = URI("https://www.googleapis.com/books/v1/volumes?")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
uri.query = URI.encode_www_form({
 "api-key" => "AIzaSyCZGgx4VzR81LmIxbFTN4c5APMTJfQf",
 "q" => "poetry",
 "maxResults" => 15
})
request = Net::HTTP::Get.new(uri.request_uri)
@result = JSON.parse(http.request(request).body)
# puts @result.inspect

@result["items"].each do |volume|
  puts "Here is a book: #{volume["volumeInfo"]["title"]} by #{volume["volumeInfo"]["authors"] ? volume["volumeInfo"]["authors"].join(", ") : 'Unknown'}"
end
