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
	    self.all.each do |term|
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
end
