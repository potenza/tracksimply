class CreateTrackingLinks < ActiveRecord::Migration
  def change
    create_table :tracking_links do |t|
      t.integer :site_id
      t.string :landing_page_url
      t.string :campaign
      t.string :source
      t.string :medium
      t.string :ad_content
      t.string :token
      t.string :sid
      t.string :cost_type
      t.decimal :cost, precision: 10, scale: 2

      t.timestamps
    end

    add_index :tracking_links, :site_id
  end
end
