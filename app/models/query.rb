class Query < ActiveRecord::Base
  # ActiveRecord
  has_one :term, autosave: true
  has_many :articles, through: :queryresults

	def search_term(term_inst)
    binding.pry
		Article.all.select do |article|
			article.title.downcase.include?(term_inst.name)
			article.content.downcase.include?(term_inst.name)
		end
	end

	def send_results(term_inst)
		self.search_term(term_inst).each do |article|
			QueryResults.new(article, self)
		end
	end
end
