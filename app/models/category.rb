class Category < ActiveRecord::Base
  has_many :book_categories
  has_many :books, through: :book_categories
  has_many :authors, through: :books
  has_many :queries, through: :books
  has_many :search_terms, through: :queries
end
