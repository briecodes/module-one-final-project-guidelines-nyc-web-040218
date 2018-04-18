def welcome
  puts "Welcome to Breadcrumbs."
end

def instruction
  puts "Enter your search term, or exit."
end

def get_term
  word = gets.chomp
end

def create_term_instance(word)
  w = Term.new({term: word})
  w.save
  w
end

def create_query_from_term_instance(term_inst)
  q = Query.new({integer: term_inst.id})
  q.term_id = term_inst.id
  q.save
  q
end

def search_term_instance(term_inst)
  Article.all.select do |article|
    article.title.downcase.include?(term_inst.term.downcase)
    article.content.downcase.include?(term_inst.term.downcase)
  end
end

def save_query_results(results_array)

end

def puts_results(results_array)
  results_array.each do |article|
    puts "Entry Title: #{article.title}"
    puts "Entry Content: #{article.content}"
  end
end

def run_first
  welcome
  instruction
  word = get_term
  puts "Searching for #{word}…"
  new_term = create_term_instance(word)
  create_query_from_term_instance(new_term)
  results_array = search_term_instance(new_term)
  puts "Your results are:"
  puts_results(results_array)
end

def run
end
