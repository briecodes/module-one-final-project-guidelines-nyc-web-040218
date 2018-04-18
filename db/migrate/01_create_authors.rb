class CreateAuthors < ActiveRecord::Migration[4.2]
  def change
    create_table :queries do |t|
      t.string :full_name
    end
  end
end
