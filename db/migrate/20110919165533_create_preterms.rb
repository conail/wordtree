class CreatePreterms < ActiveRecord::Migration
  def change
    create_table :preterms, :id => false do |t|
      t.integer :term_id
      t.integer :preterm_id
    end
  end
end
