class AddMissingIndexToExpenses < ActiveRecord::Migration
  def change
    add_index :expenses, :visit_id
  end
end
