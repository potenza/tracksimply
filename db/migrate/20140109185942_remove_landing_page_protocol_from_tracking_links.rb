class RemoveLandingPageProtocolFromTrackingLinks < ActiveRecord::Migration
  def change
    remove_column :tracking_links, :landing_page_protocol
  end
end
