MY_WORDS = []

def welcome
  puts ""
  puts ""
  puts ""
  puts "Welcome to Breadcrumbs."
end

def instruction
  puts ""
  puts ""
  puts "Enter your search term, or EXIT."
end

def order_question
  puts "You can order your results by RATING or PUBLISH DATE. You may also RESTART your search or EXIT."
end

def get_response
  gets.chomp
end

def check_response(word)
  if word.downcase == "exit"
    puts "Goodbye!"
    exit
  elsif word.downcase == "rating"
    "avg_rating"
  elsif word.downcase == "publish date"
    "pub_date"
  elsif word.downcase == "restart"
    run
  end
end

def order_results(order_method, results_array)
  # binding.pry
  results_array.sort!{|a, b| b.send(order_method) <=> a.send(order_method)}
end

def create_term_instance(word)
  SearchTerm.find_or_create_by({:term => word})
  # if SearchTerm.all.exists?(:term => "word")
  # end
end

def create_query_from_term_instance(term_inst)
  q = Query.new({term_id: term_inst.id})
  q.save
  q
end

def search_term_instance(term_inst)
  Book.all.select do |book|
    book.title ? book.title.downcase.include?(term_inst.term.downcase) : nil || book.description ? book.description.downcase.include?(term_inst.term.downcase) : nil
  end
end

def save_query_results(results_array, query_inst)
  results_array.each do |book|
    q = QueryResult.new({query_id: query_inst.id, book_id: book.id})
    q.save
  end
end

def puts_results(results_array)
  if results_array.count > 0
    puts ""
    puts ""
    puts "We found the following #{results_array.count} results:"
    puts ""
    results_array.each do |book|
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
      puts "* * * * * * * * * * * * * * * *"
      puts ""
    end
  else
    puts ""
    puts ""
    puts "Sorry, no matches for your search. Try again!"
    puts ""
  end
end

def order?(results_array)
  order_question
  up_word = get_response
  response = check_response(up_word)
  # binding.pry
  order_results(response, results_array)
  puts_results(results_array)
  puts ""
  puts "SEARCHED: #{MY_WORDS.join(" > ")}"
  puts "Filtered by #{up_word.upcase}"
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
  # FORMATS & PUTS RESULTS TO THE SCREEN
  puts_results(results_array)

  puts "SEARCHED: #{MY_WORDS.join(" > ")}"
  puts ""
  puts ""
  order?(results_array)
end
