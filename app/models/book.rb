class Book < ActiveRecord::Base
  belongs_to :queryresults
  belongs_to :author
  has_many :categories
end
