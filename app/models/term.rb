class Term < ActiveRecord::Base
  # ActiveRecord
  # 
	attr_reader :term

  ALL = []

	def initialize(term)
		@term = term
    ALL << self
	end

	def search_term
		q = Query.new(self)
    q.send_results(self)
	end
end
