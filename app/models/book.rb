class Book < ActiveRecord::Base
  has_many :query_results
  has_many :book_authors
  has_many :book_categories
  has_many :queries, through: :query_results
  has_many :authors, through: :book_authors
  has_many :categories, through: :book_categories
  has_many :search_terms, through: :queries

  # TOP 5 POPULAR BOOKS
  def self.most_popular
    pop = self.all.sort{|a,b| b.avg_rating <=> a.avg_rating}
    puts_results_special(pop.take(5))
  end

  # TOP 5 MOST REVIEWED BOOKS
  def self.most_reviews
    pop = self.all.sort{|a,b| b.ratings_count <=> a.ratings_count}
    puts_results_special(pop.take(5))
  end

  # MOST POPULAR WORDS FROM BOOK DESCRIPTIONS, NOT YET FUNCTIONAL.
  def self.popular_words
    words = []
    pop = self.all.each{|b| words << b.description}
    words = words.join(" ")
    # binding.pry
    puts_results_special(pop)
  end

  # SEARCH FOR SUBMITTED WORD
  def self.search_term_instance(term_inst)
    self.all.select do |book|
      book.title ? book.title.downcase.include?(term_inst.search_term.downcase) : nil || book.description ? book.description.downcase.include?(term_inst.search_term.downcase) : nil
    end
  end

  def self.search_api(term_inst)
    new_book_array = []
    # API QUERY
    uri = URI("https://www.googleapis.com/books/v1/volumes?")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    uri.query = URI.encode_www_form({
    "api-key" => "",
    "q" => "#{term_inst.search_term.downcase}",
    "maxResults" => 40
    })
    request = Net::HTTP::Get.new(uri.request_uri)
    @result = JSON.parse(http.request(request).body)

    # PARSING RESULTS
    @result["items"].each do |volume|

    # BOOK CREATION
      new_book = self.new()
      new_book.title = volume["volumeInfo"]["title"]
      if volume["volumeInfo"]["publishedDate"]
        new_book.pub_date = volume["volumeInfo"]["publishedDate"]
      else
        new_book.pub_date = 0000
      end
      volume["volumeInfo"]["description"] ? new_book.description = volume["volumeInfo"]["description"] : new_book.description = "No description available."
      new_book.page_count = volume["volumeInfo"]["pageCount"]
      new_book.url = volume["volumeInfo"]["infoLink"]
      if volume["volumeInfo"]["averageRating"]
        new_book.avg_rating = volume["volumeInfo"]["averageRating"]
      else
        new_book.avg_rating = 0
      end
      if volume["volumeInfo"]["ratingsCount"]
        new_book.ratings_count = volume["volumeInfo"]["ratingsCount"]
      else
        new_book.ratings_count = 0
      end
      new_book.save
      new_book_array << new_book

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
          new_cat = Category.find_or_create_by({:cat_word => cat})
          new_bc = BookCategory.new({book_id: new_book.id, category_id: new_cat.id})
          new_bc.save
        end
      else
        new_cat = Category.find_or_create_by({:cat_word => "Unknown"})
        new_bc = BookCategory.new({book_id: new_book.id, category_id: new_cat.id})
        new_bc.save
      end
    end
    new_book_array
  end
end
