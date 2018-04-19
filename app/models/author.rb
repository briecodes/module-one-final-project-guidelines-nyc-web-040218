class Author < ActiveRecord::Base
  has_many :book_authors
  has_many :books, through: :book_authors
  has_many :categories, through: :books
  has_many :query_results, through: :books
  has_many :queries, through: :query_results
  has_many :queries, through: :books
  has_many :search_terms, through: :queries
end
