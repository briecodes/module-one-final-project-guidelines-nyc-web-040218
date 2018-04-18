class CreateTerms < ActiveRecord::Migration[4.2]
  def change
    create_table :terms do |t|
      t.string :term
    end
  end
end
