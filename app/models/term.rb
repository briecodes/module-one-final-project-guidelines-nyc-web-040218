class Term < ActiveRecord::Base
	has_one :query, autosave: true
end
