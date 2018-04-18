class CreateQueries < ActiveRecord::Migration[4.2]
  def change
    create_table :queries do |t|
      t.integer :term_id
    end
  end
end
