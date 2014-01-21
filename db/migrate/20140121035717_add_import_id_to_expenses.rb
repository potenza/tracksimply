class AddImportIdToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :import_id, :integer
    add_index :expenses, :import_id
  end
end
