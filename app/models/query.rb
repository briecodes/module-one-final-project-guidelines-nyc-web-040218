class Query < ActiveRecord::Base
  has_one :search_term
  has_many :books, through: :queryresults
end
