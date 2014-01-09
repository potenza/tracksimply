class RenameClicksToVisits < ActiveRecord::Migration
  def change
    rename_table :clicks, :visits


    remove_index :conversions, :click_id
    rename_column :conversions, :click_id, :visit_id
    add_index :conversions, :visit_id
  end
end
