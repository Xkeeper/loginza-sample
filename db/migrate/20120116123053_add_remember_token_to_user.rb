class AddRememberTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string
    add_column :users, :remember_token_expires_at, :Time
  end
end
