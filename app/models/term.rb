class Term < ActiveRecord::Base
	has_one :query, autosave: true

	def search_term
		puts "about to search for: #{self.term}!"
		# q = Query.new()
		binding.pry

		q.term_id = self.id
		puts "Your new search query is: #{q.term_id}, #{q}."
    # q.send_results(self)
	end
end
