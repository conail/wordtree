class CreateGenreMemberships < ActiveRecord::Migration
  def change
    create_table :genre_memberships do |t|
      t.integer :genre_id
      t.integer :document_id

      t.timestamps
    end
  end
end
