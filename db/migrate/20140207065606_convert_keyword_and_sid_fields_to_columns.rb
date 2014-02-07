class ConvertKeywordAndSidFieldsToColumns < ActiveRecord::Migration
  def change
    add_column :visits, :keyword, :string
    add_column :visits, :sid, :string

    add_index :visits, :keyword
    add_index :visits, :sid
  end
end
