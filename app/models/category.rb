class Category < ActiveRecord::Base
  belongs_to :book_categories
  has_many :books, through: :book_categories
end
