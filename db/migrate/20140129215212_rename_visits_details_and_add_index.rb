class RenameVisitsDetailsAndAddIndex < ActiveRecord::Migration
  def up
    rename_column :visits, :details, :data
    execute "CREATE INDEX visits_gin_data ON visits USING gin(data)"
  end

  def down
    execute "DROP INDEX visits_gin_data"
    rename_column :visits, :data, :details
  end
end
