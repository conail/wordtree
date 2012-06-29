class AddSsetToBranches < ActiveRecord::Migration
  def change
    add_column :branches, :sset, :string
  end
end
