class Query < ActiveRecord::Base
  has_many :search_terms
  belongs_to :query_results
  has_many :books, through: :query_results
end
