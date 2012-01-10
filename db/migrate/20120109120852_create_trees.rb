class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.string :name
      t.text :body

      t.timestamps
    end
  end
end
