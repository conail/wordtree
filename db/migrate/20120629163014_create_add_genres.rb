class CreateAddGenres < ActiveRecord::Migration
  def change
    create_table :add_genres do |t|
      t.string :name
      t.timestamps
    end

    change_table :documents do |t|
      t.integer :genre_id
      t.remove :discipline
    end
  end
end
