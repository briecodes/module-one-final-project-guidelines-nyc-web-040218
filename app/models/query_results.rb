class QueryResult < ActiveRecord::Base
  belongs_to :query
  belongs_to :book

  def self.save_query_results(results_array, query_inst)
    results_array.each do |book|
      q = self.new({query_id: query_inst.id, book_id: book.id})
      q.save
    end
  end
end
