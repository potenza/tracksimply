class SwitchPaidAtBackToDatetime < ActiveRecord::Migration
  def change
    change_column :expenses, :paid_at, :datetime
  end
end
