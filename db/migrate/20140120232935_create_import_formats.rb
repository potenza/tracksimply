class CreateImportFormats < ActiveRecord::Migration
  def change
    create_table :import_formats do |t|
      t.string :file_type
      t.integer :date_column
      t.integer :url_column
      t.integer :cost_column

      t.timestamps
    end
  end
end
