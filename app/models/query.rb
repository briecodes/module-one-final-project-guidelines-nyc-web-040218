class Query < ActiveRecord::Base
  # ActiveRecord
  # has_many :articles, through: :queryresults
  attr_reader :name

	ALL = []

  def initialize(term_inst)
		@name == "Search Term: #{term_inst.name}"
		ALL << self
	end

	def search_term(term_inst)
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
