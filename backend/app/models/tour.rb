class Tour < ApplicationRecord
  has_many :bookings, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 2000 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :duration, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :destination, presence: true
  validates :category, presence: true, inclusion: { in: %w[beach mountain city cultural adventure luxury romantic family business] }
  validates :departure_city, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :max_travelers, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :min_travelers, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :accommodation_type, presence: true, inclusion: { in: %w[hotel resort hostel apartment villa] }
  validates :transport_type, presence: true, inclusion: { in: %w[plane bus train car boat] }
  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  
  # OBS интеграция
  validates :obs_id, uniqueness: true, allow_nil: true
  
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_price_range, ->(min_price, max_price) { where(price: min_price..max_price) if min_price.present? && max_price.present? }
  scope :by_duration, ->(duration) { where(duration: duration) if duration.present? }
  scope :by_destination, ->(destination) { where("destination ILIKE ?", "%#{destination}%") if destination.present? }
  scope :by_departure_city, ->(city) { where("departure_city ILIKE ?", "%#{city}%") if city.present? }
  scope :featured, -> { where(is_featured: true) }
  scope :active, -> { where(is_active: true) }
  scope :by_date_range, ->(start_date, end_date) { where("start_date >= ? AND end_date <= ?", start_date, end_date) if start_date.present? && end_date.present? }
  scope :order_by_rating, -> { order(rating: :desc) }
  scope :order_by_price, ->(direction = :asc) { order(price: direction) }
  
  def average_rating
    rating
  end
  
  def available_spots
    max_travelers - bookings.sum(:travelers_count)
  end
  
  def is_available?
    available_spots > 0 && is_active && start_date > Date.current
  end
  
  def price_per_person
    price
  end
  
  def discount_price
    # Логика для расчета скидки
    price * 0.9 if is_featured
  end
  
  # OBS интеграция методы
  def from_obs?
    obs_id.present?
  end
  
  def sync_with_obs!
    return unless from_obs?
    
    response = ObsService.get_tour_detail(obs_id)
    if response[:success]
      tour_data = response[:data]['tour']
      update_from_obs_data(tour_data)
    end
  end
  
  def update_from_obs_data(obs_data)
    update!(
      title: obs_data['title'],
      description: obs_data['description'],
      price: obs_data['price'],
      duration: obs_data['duration'],
      destination: obs_data['destination'],
      category: obs_data['category'],
      image_url: obs_data['image_url'],
      obs_data: obs_data,
      last_synced_at: Time.current
    )
  end
  
  def self.sync_all_from_obs
    response = ObsService.sync_tours
    response
  end
end
