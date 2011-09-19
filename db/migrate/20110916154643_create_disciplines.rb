class CreateDisciplines < ActiveRecord::Migration
  def change
    create_table :disciplines do |t|
      t.string :name

      t.timestamps
    end

    create_table :disciplines_documents, :id => false do |t|
      t.integer :discipline_id
      t.integer :document_id
    end
  end
end
