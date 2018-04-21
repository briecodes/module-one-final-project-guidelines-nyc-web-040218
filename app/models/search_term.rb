class SearchTerm < ActiveRecord::Base
	has_many :queries
	has_many :query_results, through: :queries
	has_many :books, through: :query_results
	has_many :authors, through: :books
  has_many :categories, through: :books

	# GET PAST SEARCH WORDS AND BOOK ASSSOCIATIONS
	def self.get_past_searches
	  puts ""
	  puts ""
	  if self.all.count > 0
			secret_sauce_opening
	    self.all.each do |term|
	      if term.books.uniq.count == 1
	        puts "'#{term.search_term}' Resulted in #{term.books.uniq.count} match:"
	        term.books.uniq.map{|b| puts "  • #{b.title}" }
	        puts ""
	      elsif term.books.uniq.count > 1
	        puts "'#{term.search_term}' Resulted in #{term.books.uniq.count} matches:"
					term.books.uniq.map{|b| puts "  • #{b.title}" }
	        puts ""
	      else
	        puts "'#{term.search_term}' Resulted in #{term.books.uniq.count} matches."
	        puts ""
	      end
	    end
			secret_sauce_closing
	  else
	    puts "No searches have been made yet."
	  end
	  puts ""
	  puts ""
	end
end
