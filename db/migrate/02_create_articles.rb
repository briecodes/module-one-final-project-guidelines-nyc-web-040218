class CreateArticles < ActiveRecord::Migration[4.2]
  def change
    create_table :articles do |t|
      t.string :title
      # t.integer :author_id
      t.datetime :date
      t.string :content
      t.text :url
    end
  end
end
