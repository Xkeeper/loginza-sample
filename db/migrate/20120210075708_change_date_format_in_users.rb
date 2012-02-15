class ChangeDateFormatInUsers < ActiveRecord::Migration
  def up
    change_column :users, :remember_token_expires_at, :datetime
  end

  def down
    change_column :users, :remember_token_expires_at, :time
  end
end
