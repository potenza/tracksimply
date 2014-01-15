class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.string :type
      t.integer :tracking_link_id
      t.decimal :amount, precision: 10, scale: 2
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    add_index :costs, :tracking_link_id
  end
end
