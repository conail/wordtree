class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :student_id
      t.string :code
      t.string :title
      t.integer :level
      t.date :date
      t.string :module
      t.string :genre
      t.string :discipline
      t.string :dgroup
      t.string :grade
      t.integer :words
      t.integer :sunits
      t.integer :punits
      t.string :macrotype

      t.timestamps
    end
  end
end
