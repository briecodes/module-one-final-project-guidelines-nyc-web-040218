class CreateSearchTerms < ActiveRecord::Migration[4.2]
  def change
    create_table :search_terms do |t|
      t.string :term
    end
  end
end
