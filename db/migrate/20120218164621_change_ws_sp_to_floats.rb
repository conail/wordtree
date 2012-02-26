class ChangeWsSpToFloats < ActiveRecord::Migration
  def change
    change_column :documents, :ws, :integer, :float
    change_column :documents, :sp, :integer, :float
  end
end
