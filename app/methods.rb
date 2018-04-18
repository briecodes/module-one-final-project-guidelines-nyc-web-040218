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
  Term.find_or_create_by({:term => word})
  # if Term.all.exists?(:term => "word")
  #
  # else
  #   w = Term.new({term: word})
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
    book.title ? book.title.downcase.include?(term_inst.term.downcase) : nil || book.content ? book.content.downcase.include?(term_inst.term.downcase) : nil
  end
end

def save_query_results(results_array, query_inst)
  results_array.each do |book|
    q = QueryResults.new({query_id: query_inst.id, book_id: book.id})
    q.save
  end
end

def puts_results(results_array)
  puts ""
  puts ""
  puts "We found the following:"
  puts ""
  results_array.each do |book|
    puts "Title: #{book.title}"
    puts "#{book.content}"
    puts "#{book.url}"
    puts "* * * *"
  end
end

def run_first
  binding.pry
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
