class AddVisitIdToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :visit_id, :integer
  end
end
