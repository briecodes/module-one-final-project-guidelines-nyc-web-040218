class Author < ActiveRecord::Base
  belongs_to :book_authors
  has_many :books, through: :book_authors
end
