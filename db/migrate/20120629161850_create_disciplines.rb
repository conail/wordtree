class CreateDisciplines < ActiveRecord::Migration
  def change
    create_table :disciplines do |t|
      t.text :name
      t.timestamps
    end

  end
end
