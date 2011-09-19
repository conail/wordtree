class RenameGenreToGenreOldInDocuments < ActiveRecord::Migration
  def up
    rename_column :documents, :genre, :genre_old
    rename_column :documents, :discipline, :discipline_old
  end

  def down
    rename_column :documents, :genre_old, :genre
    rename_column :documents, :discipline_old, :discipline
  end
end
