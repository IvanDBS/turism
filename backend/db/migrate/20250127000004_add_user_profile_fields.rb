class AddUserProfileFields < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :preferences, :jsonb, default: {}
    add_column :users, :avatar_url, :string
    
    add_index :users, :phone
    add_index :users, :preferences, using: :gin
  end
end
