class SearchTerm < ActiveRecord::Base
	has_many :queries
	has_many :query_results, through: :queries
	has_many :books, through: :query_results
	has_many :authors, through: :books
  has_many :categories, through: :books
end
