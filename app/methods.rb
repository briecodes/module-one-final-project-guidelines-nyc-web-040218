MY_WORDS = []

def welcome
  puts ""
  puts ""
  puts ""

  art = AsciiArt.new("./app/breadcrumbs.jpg")
  puts art.to_ascii_art(width: 120)

  puts ""
  puts "Welcome to BREADCRUMBS v.0.2"
  puts ""
  puts "Your Personal Keyword Search Assistant"
  puts ""
  puts "(and if you forget your search path... follow the breadcrumbs...)"
  puts ""
  puts ""
end

def instruction
  puts ""
  puts "Please enter your search term, or type 'EXIT'."
  puts ""
end

def order_question
  puts "You can order your results by RATING, PUBLISH DATE, or AUTHOR. You may also RESTART your search or EXIT."
end

def get_response
  gets.chomp
end

def check_response(word)
  if word.downcase == "exit"
    puts "Goodbye!"
    exit
  elsif word.downcase == "rating" || word.downcase == "order by rating"
    "avg_rating"
  elsif word.downcase == "publish date" || word.downcase == "order by publish date"
    "pub_date"
  elsif word.downcase == "author" || word.downcase == "order by author"
    "authors[0].full_name"
  elsif word.downcase == "restart"
    # NEED TO CLEAR MY_WORDS CONST: My_WORDS.clear
    welcome
    run
  elsif word.downcase == "past searches" || word.downcase == "previous searches"
    get_past_searches
    run
  elsif word.downcase == "most popular"
    # most_popular
    Book.most_popular
  elsif word.downcase == "most reviews"
    # most_reviews
    Book.most_reviews
  # elsif word.downcase == "popular words"
  #   popular_words
  end
end

def check_response_order(word)
  if word.downcase == "exit"
    puts "Goodbye!"
    exit
  elsif word.downcase == "rating" || word.downcase == "order by rating"
    "avg_rating"
  elsif word.downcase == "publish date" || word.downcase == "order by publish date"
    "pub_date"
  elsif word.downcase == "author" || word.downcase == "order by author"
    "authors[0].full_name"
  elsif word.downcase == "restart"
    # NEED TO CLEAR MY_WORDS CONST: My_WORDS.clear
    welcome
    run
  else
    puts "Sorry, I don’t understand that command. Try again."
  end
end

def order_results(order_method, results_array)
  if order_method == "authors[0].full_name"
    results_array.sort!{|a, b| a.authors[0].full_name <=> b.authors[0].full_name}
  else
    results_array.sort!{|a, b| b.send(order_method) <=> a.send(order_method)}
  end
end

# GET PAST SEARCH WORDS AND BOOK ASSSOCIATIONS **belongs inside the SearchTerm class**
def get_past_searches
  puts ""
  puts ""
  if SearchTerm.all.count > 0
    SearchTerm.all.each do |term|
      if term.books.count == 1
        puts "'#{term.search_term}' Resulted in #{term.books.count} match:"
        puts term.books.map{|b| b.title }.join(", ")
        puts ""
      elsif term.books.count > 1
        puts "'#{term.search_term}' Resulted in #{term.books.count} matches:"
        puts term.books.map{|b| b.title }.join(", ")
        puts ""
      else
        puts "'#{term.search_term}' Resulted in #{term.books.count} matches."
        puts ""
      end
    end
  else
    puts "No searches have been made yet."
  end
  puts ""
  puts ""
end

# TOP 5 POPULAR BOOKS
# def most_popular
#   pop = Book.all.map{|b|b}
#   pop.sort!{|a,b| b.avg_rating <=> a.avg_rating}
#   puts_results_special(pop.take(5))
# end

# TOP 5 MOST REVIEWED BOOKS
# def most_reviews
#   pop = Book.all.map{|b|b}
#   pop.sort!{|a,b| b.ratings_count <=> a.ratings_count}
#   puts_results_special(pop.take(5))
# end

# MOST POPULAR WORDS FROM BOOK DESCRIPTIONS
def popular_words
  words = []
  pop = Book.all.each{|b| words << b.description}
  words = words.join(" ")
  # binding.pry
  puts_results_special(pop)
end

def create_term_instance(word)
  SearchTerm.find_or_create_by({:search_term => word})
end

def create_query_from_term_instance(term_inst)
  q = Query.new({search_term_id: term_inst.id})
  q.save
  q
end

def search_term_instance(term_inst)
  Book.all.select do |book|
    book.title ? book.title.downcase.include?(term_inst.search_term.downcase) : nil || book.description ? book.description.downcase.include?(term_inst.search_term.downcase) : nil
  end
end

def save_query_results(results_array, query_inst)
  results_array.each do |book|
    q = QueryResult.new({query_id: query_inst.id, book_id: book.id})
    q.save
  end
end

# SECRET SAUCE METHOD FOR SPECIAL SEARCHES, PROVIDING LIMITED INFORMATION
def puts_results_special(results_array)
  if results_array.count > 0
    puts ""
    puts ""
    puts ""
    puts "(✿ ◡ ‿ ◡)  *  S E C R E T   S A U C E  *  ლ(ಠ益ಠლ)"
    puts ""
    puts ""
    results_array.each do |book|
      puts "Title: #{book.title}"
      puts "#{book.page_count} pages."
      if book.avg_rating
        puts "Average Rating: #{book.avg_rating}, from #{book.ratings_count} responses."
      end
      puts ""
    end
    puts ""
    puts "* * * * * *  (╯°□°)╯︵ ┻━┻ ︵ ╯(°□° ╯) * * * * * * * * * *"
    puts ""
  end
end

def any_search_results?(results_array)
  results_array.count > 0
end

def no_matches
  puts "Sorry, no matches for your search. Try again!"
  puts ""
  puts ""
end

def we_found(results_array)
  puts "We found the following #{results_array.count} results:"
  puts ""
end

# METHOD TO PUT RESULTS OF SEARCHES
def puts_results(results_array)
  results_array.each do |book|
    puts ""
    puts "* * * * * * * * * * * * * * * *"
    puts ""
    puts "Title: #{book.title}"
    puts "Publish Date: #{book.pub_date}"
    if book.page_count
      puts "#{book.page_count} pages."
    end
    puts "Author(s): #{book.authors.map{|a| a.full_name}.join(', ')}"
    puts "#{book.description}"
    puts "Categories: #{book.categories.map{|c| c.cat_word}.join(', ')}"
    if book.avg_rating
      puts "Average Rating: #{book.avg_rating}, from #{book.ratings_count} responses."
    end
    puts "Buy now: #{book.url}"
    puts ""
  end
end

# ABILITY TO ORDER RESULTS
def order?(results_array)
  order_question
  up_word = get_response
  response = check_response(up_word)
  order_results(response, results_array)
  puts ""
  puts ""
  puts "Sorting by #{up_word.upcase}…"
  puts ""
  puts_results(results_array)
  puts "* * * * * * * * * * * * * * * *"
  puts ""
  puts ""
  puts "YOUR BREADCRUMBS… #{MY_WORDS.join(" > ")}"
  puts "Sorted by #{up_word.upcase}"
  puts ""
  puts ""
  order?(results_array)
end

def run
  # binding.pry
  instruction
  word = get_response
  MY_WORDS << word
  check_response(word)
  puts "Searching for #{word}…"

  # CREATE SEARCH TERM INSTANCE & SAVE TO DATABASE
  new_term = create_term_instance(word)
  # CREATE QUERY INSTANCE & SAVE TO DATABASE
  new_query = create_query_from_term_instance(new_term)
  # PLACE SEARCH RESULTS INSIDE AN ARRAY
  results_array = search_term_instance(new_term)
  # SAVE RESULTS & QUERY RELATIONSHIP TO DATABASE
  save_query_results(results_array, new_query)
  # CHECK IF ANY RESULTS
  if any_search_results?(results_array)
    # FORMATS & PUTS RESULTS TO THE SCREEN
    we_found(results_array)
    puts_results(results_array)
  else
    no_matches
    run
  end

  puts "YOUR BREADCRUMBS… #{MY_WORDS.join(" > ")}"
  puts ""
  puts ""
  order?(results_array)
end
