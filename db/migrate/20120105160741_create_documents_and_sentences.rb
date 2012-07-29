class CreateDocumentsAndSentences < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :genre_id
      t.integer :level 
      t.integer :punits     
      t.integer :sunits    
      t.integer :words    
      t.text :abstract 
      t.text :block 
      t.text :code
      t.text :complex
      t.text :content
      t.text :course 
      t.text :date 
      t.text :dgroup 
      t.integer :discipline_id 
      t.text :dob 
      t.text :education 
      t.text :figures 
      t.text :formulae 
      t.text :gender 
      t.text :grade   
      t.text :l1 
      t.text :listlikes 
      t.text :lists 
      t.text :macrotype     
      t.text :module
      t.text :quotes 
      t.float :sp 
      t.text :student_id
      t.text :tables 
      t.text :texts 
      t.text :title
      t.float :ws 
      t.text :xml  
      t.timestamps
    end
    add_index :documents, :level

    create_table :sentences do |t|
      t.integer :document_id
      t.text :text
      t.text :clean
      t.timestamps
    end
  end
end
