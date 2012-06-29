class CreateDisciplines < ActiveRecord::Migration
  def change
    create_table :disciplines do |t|
      t.string :name
      t.timestamps
    end

    add_column :documents, :discipline_id, :integer
  end
end
