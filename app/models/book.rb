class Book < ActiveRecord::Base
  has_many :query_results
  has_many :book_authors
  has_many :book_categories
  has_many :queries, through: :query_results
  has_many :authors, through: :book_authors
  has_many :categories, through: :book_categories
  has_many :search_terms, through: :queries
end
