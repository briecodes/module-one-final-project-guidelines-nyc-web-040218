class CreateAuthors < ActiveRecord::Migration[4.2]
  def change
    create_table :authors do |t|
      t.string :author
    end
  end
end
