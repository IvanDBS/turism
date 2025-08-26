class TourSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :duration, :destination, :image_url, :category, :created_at
  
  has_many :bookings
end
