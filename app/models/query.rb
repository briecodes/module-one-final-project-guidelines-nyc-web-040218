class Query < ActiveRecord::Base
  belongs_to :search_term
  has_many :query_results
  has_many :books, through: :query_results
  has_many :authors, through: :books
  has_many :categories, through: :books

  def self.create_query_from_term_instance(term_inst)
    q = self.new({search_term_id: term_inst.id})
    q.save
    q
  end
end
