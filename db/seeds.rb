# bones = Term.new(term: "bones")
# graveyard = Term.new(term: "graveyard")
# island = Term.new(term: "island")
# food = Term.new(term: "food")

# areax = Article.new(title: "Area X", content: "What lies beyond the border?", url: "http://a.co/aJJk31s")
# anni = Article.new(title:"Annihilation", content:"First book in the trilogy", url: "http://a.co/3TK1fYs")
# auth = Article.new(title:"Authority", content:"Second book in the trilogy", url: "http://a.co/40Jdjeg")
# acc = Article.new(title: "Acceptance", content: "Third book in the trilogy", url: "http://a.co/e5jBHi4")
# areax.save
# anni.save
# auth.save
# acc.save


# SEED POETRY BOOKS
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
  book = Article.new(title: volume["volumeInfo"]["title"], content: volume["volumeInfo"]["description"] ? volume["volumeInfo"]["description"] : "No description available.", url: volume["volumeInfo"]["infoLink"])
  book.save
  # puts "I've saved the following: #{volume["volumeInfo"]["title"]}"
  # puts "Here is a book: #{volume["volumeInfo"]["title"]} by #{volume["volumeInfo"]["authors"] ? volume["volumeInfo"]["authors"].join(", ") : 'Unknown'}"
end
