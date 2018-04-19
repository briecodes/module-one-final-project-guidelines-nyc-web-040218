class Book < ActiveRecord::Base
  belongs_to :queryresults
  belongs_to :author
  has_many :book_categories
  has_many :categories, through: :book_categories
end
