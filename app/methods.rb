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
end

def instruction
  puts ""
  puts "Please enter your search term, or type 'exit'."
  puts ""
end

def get_term
  word = gets.chomp
end

def check_response(word)
  if word.downcase == "exit"
    puts "Goodbye!"
    exit
  end
end

def create_term_instance(word)
  SearchTerm.find_or_create_by({:search_term => word})
  # if SearchTerm.all.exists?(:term => "word")
  #
  # else
  #   w = SearchTerm.new({term: word})
  #   w.save
  #   w
  # end
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

def puts_results(results_array)
  if results_array.count > 0
    puts ""
    puts ""
    puts "We found the following #{results_array.count} results:"
    puts ""
    results_array.each do |book|
      puts "Title: #{book.title}, Published #{book.pub_date}. #{book.page_count} pages."
      puts "#{book.description}"
      if book.avg_rating
        puts "Rating: #{book.avg_rating} out of #{book.ratings_count}."
      end
      puts "#{book.url}"
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

def run_first
  # binding.pry
  welcome
  instruction
  word = get_term
  check_response(word)
  puts "Searching for #{word}…"
  new_term = create_term_instance(word)
  new_query = create_query_from_term_instance(new_term)
  results_array = search_term_instance(new_term)
  save_query_results(results_array, new_query)
  puts_results(results_array)
  run
end

def run
  instruction
  word = get_term
  check_response(word)
  puts "Searching for #{word}…"
  new_term = create_term_instance(word)
  new_query = create_query_from_term_instance(new_term)
  results_array = search_term_instance(new_term)
  save_query_results(results_array, new_query)
  puts_results(results_array)
  run
end
