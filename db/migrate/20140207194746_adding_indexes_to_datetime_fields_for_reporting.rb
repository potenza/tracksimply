class AddingIndexesToDatetimeFieldsForReporting < ActiveRecord::Migration
  def change
    add_index :visits, :created_at
    add_index :conversions, :created_at
    add_index :expenses, :paid_at
  end
end
