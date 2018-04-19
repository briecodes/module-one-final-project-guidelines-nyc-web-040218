# bones = Term.new(term: "bones")
# graveyard = Term.new(term: "graveyard")
# island = Term.new(term: "island")
# food = Term.new(term: "food")

# areax = Book.new(title: "Area X", description: "What lies beyond the border?", url: "http://a.co/aJJk31s")
# anni = Book.new(title:"Annihilation", description:"First book in the trilogy", url: "http://a.co/3TK1fYs")
# auth = Book.new(title:"Authority", description:"Second book in the trilogy", url: "http://a.co/40Jdjeg")
# acc = Book.new(title: "Acceptance", description: "Third book in the trilogy", url: "http://a.co/e5jBHi4")
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

@result["items"].each do |volume|
  # BOOK CREATION
  new_book = Book.new()
  new_book.title = volume["volumeInfo"]["title"]
  new_book.pub_date = volume["volumeInfo"]["publishedDate"]
  volume["volumeInfo"]["description"] ? new_book.description = volume["volumeInfo"]["description"] : new_book.description = "No description available."
  new_book.page_count = volume["volumeInfo"]["pageCount"]
  new_book.url = volume["volumeInfo"]["infoLink"]
  new_book.avg_rating = volume["volumeInfo"]["averageRating"]
  new_book.ratings_count = volume["volumeInfo"]["ratingsCount"]
  new_book.save

  # AUTHOR CREATION
  if volume["volumeInfo"]["authors"]
    volume["volumeInfo"]["authors"].each do |name|
      new_author = Author.find_or_create_by({:full_name => name})
      new_ba = BookAuthor.new({book_id: new_book.id, author_id: new_author.id})
      new_ba.save
    end
  else
    new_author = Author.find_or_create_by({:full_name => "Unknown"})
    new_ba = BookAuthor.new({book_id: new_book.id, author_id: new_author.id})
    new_ba.save
  end

  # CATEGORY CREATION
  if volume["volumeInfo"]["categories"]
    volume["volumeInfo"]["categories"].each do |cat|
      new_cat = Category.find_or_create_by({:word => cat})
      new_bc = BookCategory.new({book_id: new_book.id, category_id: new_cat.id})
      new_bc.save
    end
  else
    new_cat = Category.find_or_create_by({:word => "Unknown"})
    new_bc = BookCategory.new({book_id: new_book.id, category_id: new_cat.id})
    new_bc.save
  end

  puts "Added the following titles:"
  Book.all.each{|book| puts book.title}

end
