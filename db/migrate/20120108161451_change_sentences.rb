class ChangeSentences < ActiveRecord::Migration
  def change
    change_column :sentences, :text, :text
    change_column :sentences, :clean, :text    
  end
end
