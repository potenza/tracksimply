class RemoveSiteIdFromVisits < ActiveRecord::Migration
  def change
    remove_column :visits, :site_id
  end
end
