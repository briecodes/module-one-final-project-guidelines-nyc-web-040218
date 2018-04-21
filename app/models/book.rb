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

end
