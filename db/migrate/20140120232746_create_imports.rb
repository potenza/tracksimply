class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :user_id
      t.integer :site_id
      t.integer :import_format_id
      t.string :name
      t.string :file
      t.datetime :processed_at

      t.timestamps
    end

    add_index :imports, :user_id
    add_index :imports, :site_id
  end
end
