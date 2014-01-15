class RemoveSidFromTrackingLinks < ActiveRecord::Migration
  def change
    remove_column :tracking_links, :sid, :string
  end
end
