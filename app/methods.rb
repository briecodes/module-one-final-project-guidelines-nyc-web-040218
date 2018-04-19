def welcome
  puts ""
  puts ""
  puts ""
  puts "Welcome to Breadcrumbs."
end

def instruction
  puts ""
  puts ""
  puts "Enter your search term, or exit."
end

def order_question
  puts "You can order your results by RATING, PUBLISH DATE, or AUTHOR. You may also RESTART your search or QUIT."
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
  SearchTerm.find_or_create_by({:term => word})
  # if SearchTerm.all.exists?(:term => "word")
  #
  # else
  #   w = SearchTerm.new({term: word})
  #   w.save
  #   w
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
    q = QueryResults.new({query_id: query_inst.id, book_id: book.id})
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
        puts "Rating: #{book.avg_rating} out of #{book.ratings_count}."
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
