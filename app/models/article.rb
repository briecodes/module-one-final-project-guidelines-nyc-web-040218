class Article < ActiveRecord::Base
  belongs_to :queryresults, autosave: true
end
