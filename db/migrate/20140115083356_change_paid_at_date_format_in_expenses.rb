class ChangePaidAtDateFormatInExpenses < ActiveRecord::Migration
  def change
    change_column :expenses, :paid_at, :date
  end
end
