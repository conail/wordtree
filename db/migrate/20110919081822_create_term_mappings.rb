class CreateTermMappings < ActiveRecord::Migration
  def change
    create_table :term_mappings do |t|
      t.integer :term_id
      t.integer :document_id
      t.integer :pos

      t.timestamps
    end
  end
end
