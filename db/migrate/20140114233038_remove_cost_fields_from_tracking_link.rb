class RemoveCostFieldsFromTrackingLink < ActiveRecord::Migration
  def change
    remove_column :tracking_links, :cost, :decimal, precision: 10, scale: 2
    remove_column :tracking_links, :cost_type, :string
  end
end
