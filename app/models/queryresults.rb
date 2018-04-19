class QueryResults < ActiveRecord::Base
  has_many :queries
  has_many :books
end
