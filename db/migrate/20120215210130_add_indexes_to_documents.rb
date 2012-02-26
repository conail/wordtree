class AddIndexesToDocuments < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.remove :level
      t.integer :level
    end
    add_index :documents, :level
  end
end
