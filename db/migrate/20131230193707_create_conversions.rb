class CreateConversions < ActiveRecord::Migration
  def change
    create_table :conversions do |t|
      t.integer :click_id
      t.decimal :revenue, precision: 10, scale: 2

      t.timestamps
    end

    add_index :conversions, :click_id
  end
end
