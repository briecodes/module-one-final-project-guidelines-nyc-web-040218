class Query < ActiveRecord::Base
  has_one :term
  has_many :articles, through: :queryresults
end
