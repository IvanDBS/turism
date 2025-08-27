class TourSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :duration, :destination, :image_url, :category, 
             :departure_city, :start_date, :end_date, :max_travelers, :min_travelers,
             :included_services, :not_included_services, :itinerary, :accommodation_type,
             :transport_type, :is_featured, :is_active, :rating, :reviews_count,
             :available_spots, :is_available, :price_per_person, :discount_price,
             :created_at, :updated_at
  
  has_many :bookings
  
  def available_spots
    object.available_spots
  end
  
  def is_available
    object.is_available?
  end
  
  def price_per_person
    object.price_per_person
  end
  
  def discount_price
    object.discount_price
  end
  
  def start_date
    object.start_date&.strftime('%Y-%m-%d')
  end
  
  def end_date
    object.end_date&.strftime('%Y-%m-%d')
  end
  
  def created_at
    object.created_at&.strftime('%Y-%m-%d %H:%M:%S')
  end
  
  def updated_at
    object.updated_at&.strftime('%Y-%m-%d %H:%M:%S')
  end
end
