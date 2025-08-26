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

      t.timestamps
    end
  end
end
