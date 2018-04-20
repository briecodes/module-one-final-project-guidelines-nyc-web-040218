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


# SEED SINGLE SHOT OF POETRY BOOKS
# uri = URI("https://www.googleapis.com/books/v1/volumes?")
# http = Net::HTTP.new(uri.host, uri.port)
# http.use_ssl = true
# uri.query = URI.encode_www_form({
#  "api-key" => "AIzaSyCZGgx4VzR81LmIxbFTN4c5APMTJfQf",
#  "q" => "poetry",
#  "maxResults" => 15
# })
# request = Net::HTTP::Get.new(uri.request_uri)
# @result = JSON.parse(http.request(request).body)
#
# @result["items"].each do |volume|
#   # BOOK CREATION
#   new_book = Book.new()
#   new_book.title = volume["volumeInfo"]["title"]
#   new_book.pub_date = volume["volumeInfo"]["publishedDate"]
#   volume["volumeInfo"]["description"] ? new_book.description = volume["volumeInfo"]["description"] : new_book.description = "No description available."
#   new_book.page_count = volume["volumeInfo"]["pageCount"]
#   new_book.url = volume["volumeInfo"]["infoLink"]
#   if volume["volumeInfo"]["averageRating"]
#     new_book.avg_rating = volume["volumeInfo"]["averageRating"]
#   else
#     new_book.avg_rating = 0
#   end
#   if volume["volumeInfo"]["ratingsCount"]
#     new_book.ratings_count = volume["volumeInfo"]["ratingsCount"]
#   else
#     new_book.ratings_count = 0
#   end
#   new_book.save
#
#   # AUTHOR CREATION
#   if volume["volumeInfo"]["authors"]
#     volume["volumeInfo"]["authors"].each do |name|
#       new_author = Author.find_or_create_by({:full_name => name})
#       new_ba = BookAuthor.new({book_id: new_book.id, author_id: new_author.id})
#       new_ba.save
#     end
#   else
#     new_author = Author.find_or_create_by({:full_name => "Unknown"})
#     new_ba = BookAuthor.new({book_id: new_book.id, author_id: new_author.id})
#     new_ba.save
#   end
#
#   # CATEGORY CREATION
#   if volume["volumeInfo"]["categories"]
#     volume["volumeInfo"]["categories"].each do |cat|
#       new_cat = Category.find_or_create_by({:cat_word => cat})
#       new_bc = BookCategory.new({book_id: new_book.id, category_id: new_cat.id})
#       new_bc.save
#     end
#   else
#     new_cat = Category.find_or_create_by({:cat_word => "Unknown"})
#     new_bc = BookCategory.new({book_id: new_book.id, category_id: new_cat.id})
#     new_bc.save
#   end
# end
#
# puts "You have #{Book.all.count} books in your DB."


# SEED MULTIPLE SHOTS OF BOOKS THROUGH AN ARRAY
seed_arr_words = ["poetry", "philosophy", "fantasy", "sci-fi", "mystery"]

def superseed(seed_arr)
  seed_arr.map do |word|

    # API QUERY
    uri = URI("https://www.googleapis.com/books/v1/volumes?")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    uri.query = URI.encode_www_form({
    "api-key" => "",
    "q" => "#{word}",
    "maxResults" => 40
    })
    request = Net::HTTP::Get.new(uri.request_uri)
    @result = JSON.parse(http.request(request).body)

    # PARSING RESULTS
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
          new_author = Author.find_or_create_by({:author => name})
          new_ba = BookAuthor.new({book_id: new_book.id, author_id: new_author.id})
          new_ba.save
        end
      else
        new_author = Author.find_or_create_by({:author => "Unknown"})
        new_ba = BookAuthor.new({book_id: new_book.id, author_id: new_author.id})
        new_ba.save
      end

    # CATEGORY CREATION
      if volume["volumeInfo"]["categories"]
        volume["volumeInfo"]["categories"].each do |cat|
          new_cat = Category.find_or_create_by({:category => cat})
          new_bc = BookCategory.new({book_id: new_book.id, category_id: new_cat.id})
          new_bc.save
        end
      else
        new_cat = Category.find_or_create_by({:category => "Unknown"})
        new_bc = BookCategory.new({book_id: new_book.id, category_id: new_cat.id})
        new_bc.save
      end
    end

    # OUTCOME CONFIRMATION
    puts "You have #{Book.all.count} books in your DB."

  end
end

# CALLING THE METHOD
superseed(seed_arr_words)
