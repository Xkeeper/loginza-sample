class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "name"
      t.string "username"
      t.string "identifier", :limit => 90, :null => false
      t.string "provider_name", :limit => 100, :null => false
      t.string "email"
      t.string "gender", :limit => 30
      t.date "birthday"
      t.string "phone"
      t.string "photo"
      t.text "address"
      t.string "language"
      t.integer "uid", :limit => 8

      t.timestamps
    end
  end
end
