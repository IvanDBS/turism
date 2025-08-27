class User < ApplicationRecord
  has_secure_password
  
  has_many :bookings, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :favorite_tours, dependent: :destroy
  has_many :favorite_tour_objects, through: :favorite_tours, source: :tour
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :role, presence: true, inclusion: { in: %w[user admin] }
  validates :phone, format: { with: /\A\+?[\d\s\-\(\)]+\z/ }, allow_blank: true
  
  before_validation :set_default_role, on: :create
  
  scope :admins, -> { where(role: 'admin') }
  scope :regular_users, -> { where(role: 'user') }
  
  def admin?
    role == 'admin'
  end
  
  def unread_notifications_count
    notifications.unread.count
  end
  
  def recent_notifications(limit = 5)
    notifications.recent.limit(limit)
  end
  
  def favorite_tour?(tour)
    favorite_tours.exists?(tour: tour)
  end
  
  def add_to_favorites(tour)
    favorite_tours.find_or_create_by(tour: tour)
  end
  
  def remove_from_favorites(tour)
    favorite_tours.find_by(tour: tour)&.destroy
  end
  
  def total_spent
    bookings.where(status: 'completed').sum(:total_price)
  end
  
  def booking_stats
    {
      total: bookings.count,
      completed: bookings.where(status: 'completed').count,
      pending: bookings.where(status: 'pending').count,
      cancelled: bookings.where(status: 'cancelled').count
    }
  end
  
  private
  
  def set_default_role
    self.role ||= 'user'
  end
end
