class AddObsFieldsToTours < ActiveRecord::Migration[8.0]
  def change
    add_column :tours, :obs_id, :string
    add_column :tours, :obs_data, :jsonb
    add_column :tours, :last_synced_at, :datetime
    add_column :tours, :image_url, :string
    
    add_index :tours, :obs_id, unique: true
    add_index :tours, :obs_data, using: :gin
  end
end
