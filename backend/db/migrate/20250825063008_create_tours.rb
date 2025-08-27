class CreateTours < ActiveRecord::Migration[7.1]
  def change
    create_table :tours do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.integer :duration
      t.string :destination
      t.string :image_url
      t.string :category
      t.string :departure_city
      t.date :start_date
      t.date :end_date
      t.integer :max_travelers
      t.integer :min_travelers
      t.text :included_services
      t.text :not_included_services
      t.text :itinerary
      t.string :accommodation_type
      t.string :transport_type
      t.boolean :is_featured, default: false
      t.boolean :is_active, default: true
      t.decimal :rating, precision: 3, scale: 2, default: 0.0
      t.integer :reviews_count, default: 0

      t.timestamps
    end
    
    add_index :tours, :category
    add_index :tours, :destination
    add_index :tours, :is_featured
    add_index :tours, :is_active
  end
end
