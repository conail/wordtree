class CreatePostterms < ActiveRecord::Migration
  def change
    create_table :postterms, :id => false do |t|
      t.integer :term_id
      t.integer :postterm_id
    end
  end
end
