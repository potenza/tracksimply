class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :tracking_link_id
      t.datetime :paid_at
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end

    add_index :expenses, :tracking_link_id
  end
end
