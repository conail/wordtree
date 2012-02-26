class AddExtraFieldsToDocuments < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.string :genre_family 
      t.string :discipline 
      t.string :tables 
      t.string :figures 
      t.string :block 
      t.string :quotes 
      t.string :formulae 
      t.string :lists 
      t.string :listlikes 
      t.string :abstract 
      t.string :ws 
      t.string :sp 
      t.string :gender 
      t.string :dob 
      t.string :l1 
      t.string :education 
      t.string :course 
      t.string :texts 
      t.string :complex
    end
  end
end
