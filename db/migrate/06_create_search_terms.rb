class CreateSearchTerms < ActiveRecord::Migration[4.2]
  def change
    create_table :search_terms do |t|
      t.string :search_term
    end
  end
end
