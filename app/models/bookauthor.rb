class BookAuthor < ActiveRecord::Base
  has_many :books
  has_many :authors
end
