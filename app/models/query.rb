class Query < ActiveRecord::Base
  belongs_to :search_term
  has_many :query_results
  has_many :books, through: :query_results
end
