class Query < ActiveRecord::Base
  has_one :term, autosave: true
  has_many :articles, through: :queryresults
end
