class AddLandingPageProtocolToTrackingLinks < ActiveRecord::Migration
  def change
    add_column :tracking_links, :landing_page_protocol, :string, default: "http://"
  end
end
