class CreateRemainders < ActiveRecord::Migration
  def change
    create_table :remainders do |t|
      t.string :term
      t.text :body
      t.integer :sentence_id

      t.timestamps
    end
  end
end
