class CreateQueries < ActiveRecord::Migration[4.2]
  def change
    create_table :queries do |t|
      t.integer :search_term_id
    end
  end
end
