class CreateQueryResults < ActiveRecord::Migration[4.2]
  def change
    create_table :query_results do |t|
      t.integer :query_id
      t.integer :article_id
    end
  end
end
