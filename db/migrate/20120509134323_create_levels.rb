class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :name

      t.timestamps
    end

    add_column :documents, :level_id, :integer
  end
end
