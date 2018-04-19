class SearchTerm < ActiveRecord::Base
	has_many :queries
	has_many :query_results, through: :queries
end
