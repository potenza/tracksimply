class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :auth_token
      t.boolean :admin, default: false
      t.string :password_reset_token
      t.datetime :password_reset_token_expires_at

      t.timestamps
    end
  end
end
