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

end
