class BookCategory < ActiveRecord::Base
  belongs_to :books
  belongs_to :categories
end
