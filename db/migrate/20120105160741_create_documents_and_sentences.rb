class CreateDocumentsAndSentences < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :title
      t.string :student_id
      t.string :code
      t.string :level 
      t.string :date 
      t.string :module
      t.string :dgroup 
      t.string :grade   
      t.integer :words    
      t.integer :sunits    
      t.integer :punits     
      t.string :macrotype     
      t.text :content
      t.text :xml  
      t.timestamps
    end

    create_table :sentences do |t|
      t.integer :document_id
      t.string :text
      t.string :clean
      t.timestamps
    end
  end
end
