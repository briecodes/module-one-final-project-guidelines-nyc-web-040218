class CreateBooks < ActiveRecord::Migration[4.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :pub_date
      t.integer :page_count
      t.string :description
      t.float :avg_rating
      t.integer :ratings_count
      t.text :url
    end
  end
end
