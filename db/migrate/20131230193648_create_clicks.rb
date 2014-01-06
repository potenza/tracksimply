class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.integer :site_id
      t.integer :visitor_id
      t.integer :tracking_link_id
      t.hstore :details

      t.timestamps
    end

    add_index :clicks, :site_id
    add_index :clicks, :visitor_id
    add_index :clicks, :tracking_link_id
  end
end
