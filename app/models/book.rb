class Book < ActiveRecord::Base
  belongs_to :query_results
  belongs_to :book_authors
  belongs_to :book_categories
  has_many :queries, through: :query_results
  has_many :authors, through: :book_authors
  has_many :categories, through: :book_categories
end
