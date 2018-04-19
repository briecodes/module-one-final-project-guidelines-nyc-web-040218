class Category < ActiveRecord::Base
  has_many :book_categories
  has_many :books, through: :book_categories
  has_many :authors, through: :books
  has_many :query_results, through: :books
  has_many :queries, through: :query_results
  has_many :search_terms, through: :queries
end
