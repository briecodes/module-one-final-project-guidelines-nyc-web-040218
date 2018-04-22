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
    SearchTerm.get_past_searches
    run
  elsif word.downcase == "most popular"
    Book.most_popular
    run
  elsif word.downcase == "most reviews"
    Book.most_reviews
    run
  elsif word.downcase == "binding.pry"
    binding.pry
    run
  # elsif word.downcase == "popular words"
  #   popular_words
  end
end

def check_response_order(word, results_array)
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
    puts ""
    puts ""
    puts "Sorry, I don’t understand that command. Try again."
    puts ""
    puts ""
    order?(results_array)
  end
end

def order_results(order_method, results_array)
  if order_method == "authors[0].full_name"
    results_array.sort!{|a, b| a.authors[0].full_name <=> b.authors[0].full_name}
  else
    results_array.sort!{|a, b| b.send(order_method) <=> a.send(order_method)}
  end
end

def secret_sauce_opening
  puts ""
  puts ""
  puts ""
  puts "(✿ ◡ ‿ ◡)  *  S E C R E T   S A U C E  *  ლ(ಠ益ಠლ)"
  puts ""
  puts ""
end

def secret_sauce_closing
  puts ""
  puts "* * * * * *  (╯°□°)╯︵ ┻━┻ ︵ ╯(°□° ╯) * * * * * * * * * *"
  puts ""
end

# SECRET SAUCE METHOD FOR SPECIAL SEARCHES, PROVIDING LIMITED INFORMATION
def puts_results_special(results_array)
  if results_array.count > 0
    secret_sauce_opening
    results_array.each do |book|
      puts "Title: #{book.title}"
      puts "Author(s): #{book.authors.map{|a| a.full_name}.join(', ')}"
      puts "#{book.page_count} pages."
      if book.avg_rating
        puts "Average Rating: #{book.avg_rating}, from #{book.ratings_count} responses."
      end
      puts ""
    end
    secret_sauce_closing
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
  response = check_response_order(up_word, results_array)
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
  # new_term = create_term_instance(word)
  new_term = SearchTerm.create_term_instance(word)
  # CREATE QUERY INSTANCE & SAVE TO DATABASE
  new_query = Query.create_query_from_term_instance(new_term)
  # PLACE SEARCH RESULTS INSIDE AN ARRAY
  results_array = []
  results_array << Book.search_term_instance(new_term)
  # SEARCH THROUGH GOOGLE BOOKS API
  results_array << Book.search_api(new_term)
  # CLEAN UP ARRAY
  binding.pry
  results_array.flatten
  # SAVE RESULTS & QUERY RELATIONSHIP TO DATABASE
  QueryResult.save_query_results(results_array, new_query)
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
